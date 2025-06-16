import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/controller/notes/notecreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart'; // For Get.back()

class CreateNoteView extends StatelessWidget {
  const CreateNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotecreateController controller = Get.put(NotecreateController());
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: colorScheme.onSurfaceVariant),
          onPressed: () {
            // Save on back press, onClose will also attempt save
            controller.uploadData();
            Get.offAllNamed(AppRoute.home);
          },
        ),
        title: Text(
          "key_create_note_appbar_title".tr, // New Key
          style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: scale.scaleText(20),
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  controller.isDrawingMode
                      ? Icons.text_fields_outlined
                      : Icons.draw_outlined,
                  color: colorScheme.primary,
                  size: scale.scale(26),
                ),
                tooltip: controller.isDrawingMode
                    ? "key_drawing_mode_on_tooltip"
                        .tr // New Key "Switch to Text Mode"
                    : "key_drawing_mode_off_tooltip"
                        .tr, // New Key "Switch to Drawing Mode"
                onPressed: () {
                  controller.toggleDrawingMode();
                  // If switching from drawing mode to text mode, and there's a drawing, save it.
                  if (!controller.isDrawingMode &&
                      controller.signatureController.isNotEmpty) {
                    controller.uploadData();
                  }
                },
              ),
              SizedBox(
                width: scale.scale(10),
              ),
              IconButton(
                icon: Icon(Icons.check,
                    color: colorScheme.primary, size: scale.scale(28)),
                tooltip: "key_save_note".tr, // New Key
                onPressed: () {
                  controller.uploadData();
                  Get.offAllNamed(
                      AppRoute.home); // Or Get.back() if appropriate
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<NotecreateController>(
          builder: (controller) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: scale.scale(18), vertical: scale.scale(10)),
                  children: [
                    // Title TextField
                    TextField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        hintText: "key_note_title_hint"
                            .tr, // New Key (replaces 172.tr)
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: scale.scaleText(24),
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: scale.scaleText(24),
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: controller.saveTitle,
                    ),
                    SizedBox(height: scale.scale(8)),

                    // Category Dropdown
                    _buildCategoryDropdown(
                        context, controller, Get.find<HomeController>()),
                    SizedBox(height: scale.scale(13)),

                    // Content TextField
                    TextField(
                      controller: controller.insideTextField,
                      decoration: InputDecoration(
                        hintText: "key_note_content_hint"
                            .tr, // New Key (replaces 167.tr)
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: scale.scaleText(16),
                          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: scale.scaleText(16),
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                      maxLines: null,
                      minLines: controller.isDrawingMode
                          ? 3
                          : 10, // Less space if drawing canvas is visible
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: controller.saveContent,
                    ),
                    SizedBox(height: scale.scale(16)),

                    // Drawing Area (conditionally shown)
                    if (controller.isDrawingMode)
                      _buildDrawingCanvas(context, controller),
                  ],
                ),
              ),
              // _buildBottomToolBar(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context,
      NotecreateController controller, HomeController homeController) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return GetBuilder<HomeController>(
      // Ensure this GetBuilder has an ID if needed for targeted updates
      builder: (homeCtrl) {
        final categories = [
          DropdownMenuItem<int?>(
            value: null,
            child: Text("key_no_category_option".tr,
                style: TextStyle(fontSize: scale.scaleText(14))), // New Key
          ),
          ...homeCtrl.noteCategories.map((category) {
            return DropdownMenuItem<int?>(
              value: category.id,
              child: Text(category.categoryName,
                  style: TextStyle(fontSize: scale.scaleText(14))),
            );
          }).toList(),
        ];

        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: scale.scale(12), vertical: scale.scale(4)),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(scale.scale(20)), // Pill shape
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: controller.selectedCategoryId,
              items: categories,
              onChanged: (int? newValue) {
                controller.selectedCategoryId = newValue;
                controller.updateNoteCategory(); // Updates and saves
              },
              icon: Icon(Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              hint: Text(
                "key_select_category_hint".tr, // New Key
                style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: scale.scaleText(14)),
              ),
              style: TextStyle(
                // Style for selected item text
                color: colorScheme.onSurface,
                fontSize: scale.scaleText(14),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawingCanvas(
      BuildContext context, NotecreateController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: scale.scale(8)),
          child: Text(
            "key_drawing_canvas_label".tr, // New Key
            style: TextStyle(
                fontSize: scale.scaleText(14),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant),
          ),
        ),
        Container(
          height: scale.scale(300),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? colorScheme.surfaceVariant
                : Colors.white,
            borderRadius: BorderRadius.circular(scale.scale(12)),
            border: Border.all(
                color: colorScheme.outline.withOpacity(0.5), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(scale.scale(11)),
            child: Signature(
              controller: controller.signatureController,
              backgroundColor: theme.brightness == Brightness.dark
                  ? colorScheme.surfaceVariant
                  : Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.undo, color: colorScheme.primary),
              tooltip: "key_drawing_tools_undo".tr, // New Key
              onPressed: () => controller.signatureController.undo(),
            ),
            IconButton(
              icon: Icon(Icons.clear, color: colorScheme.error),
              tooltip: "key_drawing_tools_clear".tr, // New Key
              onPressed: () => controller.signatureController.clear(),
            ),
          ],
        ),
        SizedBox(
            height: scale.scale(10)), // Space before bottom toolbar if drawing
      ],
    );
  }

//   Widget _buildBottomToolBar(
//       BuildContext context, NotecreateController controller) {
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     final ScaleConfig scale = context.scaleConfig;

//     return Container(
//       padding: EdgeInsets.symmetric(
//           vertical: scale.scale(8), horizontal: scale.scale(16)),
//       decoration: BoxDecoration(
//         color: theme.cardColor, // Or theme.bottomAppBarTheme.color
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, -2),
//           )
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           IconButton(
//             icon: Icon(
//               controller.isDrawingMode
//                   ? Icons.text_fields_outlined
//                   : Icons.draw_outlined,
//               color: colorScheme.primary,
//               size: scale.scale(26),
//             ),
//             tooltip: controller.isDrawingMode
//                 ? "key_drawing_mode_on_tooltip"
//                     .tr // New Key "Switch to Text Mode"
//                 : "key_drawing_mode_off_tooltip"
//                     .tr, // New Key "Switch to Drawing Mode"
//             onPressed: () {
//               controller.toggleDrawingMode();
//               // If switching from drawing mode to text mode, and there's a drawing, save it.
//               if (!controller.isDrawingMode &&
//                   controller.signatureController.isNotEmpty) {
//                 controller.uploadData();
//               }
//             },
//           ),
//           // You can add more tools here, like color picker, etc.
//           // Example:
//           // IconButton(
//           //   icon: Icon(Icons.color_lens_outlined, color: colorScheme.secondary),
//           //   onPressed: () { /* Open color picker */ },
//           // ),
//         ],
//       ),
//     );
//   }
// }
}
