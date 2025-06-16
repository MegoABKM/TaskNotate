import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tasknotate/controller/notes/noteview_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

class ViewNote extends StatelessWidget {
  const ViewNote({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteviewController controller = Get.find<NoteviewController>();
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
          onPressed: () async {
            // Make onPressed async
            if (controller.areControllersInitialized &&
                controller.note != null) {
              print(
                  "[ViewNote BackButton] Attempting to save note before navigating...");
              await controller.updateData(); // AWAIIT for the save to complete
              // This updateData() will call Get.find<HomeController>().getNoteData()
              // which updates the *persistent* HomeController.
              print(
                  "[ViewNote BackButton] Save attempt finished. Navigating to home.");
            } else {
              print(
                  "[ViewNote BackButton] No note to save or controllers not ready. Navigating to home.");
            }
            Get.offAllNamed(AppRoute.home);
          },
        ),
        title: GetBuilder<NoteviewController>(builder: (ctrl) {
          if (ctrl.isLoadingNoteFromArgs ||
              ctrl.note == null ||
              !ctrl.areControllersInitialized) {
            // Show a simple text or nothing while loading or if note isn't ready
            return Text("key_loading_note".tr,
                style: TextStyle(
                    fontSize: scale.scaleText(18),
                    color: colorScheme.onSurfaceVariant));
          }
          return TextField(
            controller: ctrl.insideTitleField!,
            readOnly: ctrl.isDrawingMode,
            style: TextStyle(
              fontSize: scale.scaleText(22),
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: "key_view_note_title_hint".tr,
              border: InputBorder.none,
              counterText: "",
              hintStyle: TextStyle(
                fontSize: scale.scaleText(22),
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            onChanged: ctrl.saveTitle,
            textCapitalization: TextCapitalization.sentences,
          );
        }),
        actions: [
          GetBuilder<NoteviewController>(builder: (ctrl) {
            if (ctrl.isLoadingNoteFromArgs ||
                ctrl.note == null ||
                !ctrl.areControllersInitialized) {
              return const SizedBox.shrink(); // No actions if note isn't ready
            }
            return IconButton(
              icon: Icon(
                ctrl.isDrawingMode
                    ? Icons.text_fields_outlined
                    : Icons.draw_outlined,
                color: colorScheme.primary,
                size: scale.scale(26),
              ),
              tooltip: ctrl.isDrawingMode
                  ? "key_drawing_mode_on_tooltip".tr
                  : "key_drawing_mode_off_tooltip".tr,
              onPressed: () {
                ctrl.toggleDrawingMode();
                if (!ctrl.isDrawingMode &&
                    ctrl.signatureController?.isNotEmpty == true) {
                  ctrl.updateData(); // Save drawing if switching out of drawing mode with content
                }
              },
            );
          }),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<NoteviewController>(
          builder: (controller) {
            if (controller.isLoadingNoteFromArgs) {
              print("[ViewNote UI] State: Loading arguments.");
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.note == null) {
              // Arguments processed, but no note found/loaded
              print(
                  "[ViewNote UI] State: Note is null (after attempting to load from args).");
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(scale.scale(20)),
                  child: Text(
                    "key_note_not_found_message".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: scale.scaleText(18),
                      color: colorScheme.error,
                    ),
                  ),
                ),
              );
            }

            // Note is loaded, and areControllersInitialized should be true
            // because loadNoteData (which uses them) was called.
            print(
                "[ViewNote UI] State: Note loaded (ID: ${controller.note!.id}). Building main content.");
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: scale.scale(18), vertical: scale.scale(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCategorySelector(
                            context, controller, Get.find<HomeController>()),
                        SizedBox(height: scale.scale(16)),

                        if (!controller.isDrawingMode)
                          _buildTextContentView(context, controller)
                        else // In drawing mode
                          _buildDrawingViewOrEditCanvas(context, controller),

                        // Display existing drawing below text if not in drawing mode and drawing exists
                        if (!controller.isDrawingMode &&
                            controller.drawingBytes != null &&
                            controller.drawingBytes!.isNotEmpty)
                          _buildStaticDrawingDisplay(context, controller),

                        SizedBox(
                            height: scale.scale(controller.isDrawingMode
                                ? 20
                                : 80)), // Bottom padding
                      ],
                    ),
                  ),
                ),
                if (controller.isDrawingMode) // Drawing tools bar
                  _buildDrawingModeBottomBar(context, controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context,
      NoteviewController controller, HomeController homeController) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // Ensure homeController.noteCategories is accessible and populated
    // Add a check or default to empty list if not ready.
    final categoriesList = homeController.noteCategories;

    final categories = [
      DropdownMenuItem<int?>(
        value: null,
        child: Text("key_no_category_option".tr,
            style: TextStyle(fontSize: scale.scaleText(14))),
      ),
      ...categoriesList.map((category) {
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
        borderRadius: BorderRadius.circular(scale.scale(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: controller.selectedCategoryId,
          items: categories,
          onChanged: (int? newValue) {
            controller.selectedCategoryId = newValue;
            controller.updateData(); // Save category change immediately
          },
          icon:
              Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          isExpanded: true,
          style: TextStyle(
            fontSize: scale.scaleText(14),
            color: colorScheme.onSurface,
          ),
          dropdownColor: theme.cardColor,
          hint: Text(
            "key_select_category_hint".tr,
            style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: scale.scaleText(14)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContentView(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    String heroTag = controller.note!.id ??
        DateTime.now()
            .millisecondsSinceEpoch
            .toString(); // Note ID is non-null here

    return Hero(
      tag: heroTag,
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
          controller:
              controller.insideTextField!, // Controller is non-null here
          maxLines: null,
          minLines: 10,
          readOnly: controller.isDrawingMode,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            fontSize: scale.scaleText(16),
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: "key_note_content_hint".tr,
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: scale.scaleText(16),
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          onChanged: controller.saveContent,
        ),
      ),
    );
  }

  Widget _buildStaticDrawingDisplay(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // drawingBytes is checked non-null before this widget is built
    return Padding(
      padding: EdgeInsets.only(top: scale.scale(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("key_view_drawing_label".tr,
              style: TextStyle(
                  fontSize: scale.scaleText(14),
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant)),
          SizedBox(height: scale.scale(8)),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(scale.scale(12)),
                border:
                    Border.all(color: colorScheme.outline.withOpacity(0.5))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(scale.scale(11)),
              child: Image.memory(
                controller.drawingBytes!,
                height: scale.scale(300),
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                  "key_error_loading_drawing_message".tr,
                  style: TextStyle(
                      color: colorScheme.error, fontSize: scale.scaleText(14)),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingViewOrEditCanvas(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // signatureController is non-null here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: scale.scale(8)),
          child: Text(
            "key_drawing_canvas_label".tr,
            style: TextStyle(
                fontSize: scale.scaleText(14),
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant),
          ),
        ),
        Container(
          height: scale.scale(350),
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
              controller: controller.signatureController!,
              backgroundColor: theme.brightness == Brightness.dark
                  ? colorScheme.surfaceVariant
                  : Colors.white,
            ),
          ),
        ),
        // Optional: Show existing drawing as a faint background reference if canvas is empty
        if (controller.drawingBytes != null &&
            controller.signatureController?.isEmpty == true)
          Opacity(
            opacity: 0.3,
            child: Padding(
              padding: EdgeInsets.only(
                  top: scale.scale(
                      8.0)), // Should be under, but this is simpler for now
              child: IgnorePointer(
                // So it doesn't interfere with signature canvas
                child: Image.memory(
                  controller.drawingBytes!,
                  height: scale.scale(350),
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDrawingModeBottomBar(
      BuildContext context, NoteviewController controller) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ScaleConfig scale = context.scaleConfig;

    // signatureController is non-null here
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: scale.scale(8), horizontal: scale.scale(16)),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.undo, color: colorScheme.primary),
            tooltip: "key_drawing_tools_undo".tr,
            onPressed: () {
              if (controller.signatureController?.isNotEmpty == true) {
                controller.signatureController!.undo();
                controller.update(); // UI triggered update
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
            tooltip: "key_drawing_tools_clear".tr,
            onPressed: () {
              controller.signatureController?.clear();
              controller.update(); // UI triggered update
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.check_circle_outline, color: colorScheme.primary),
            label: Text("key_drawing_tools_done".tr,
                style: TextStyle(
                    color: colorScheme.primary, fontWeight: FontWeight.bold)),
            onPressed: () {
              controller.updateData(); // This will capture the drawing
              controller.isDrawingMode = false; // Switch mode
              controller.update(); // Refresh UI for mode switch
            },
          ),
        ],
      ),
    );
  }
}
