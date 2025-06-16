import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class ContentOfTask extends GetView<TaskcreateController> {
  final TextEditingController titleController; // Added titleController
  final TextEditingController contentcontroller;

  const ContentOfTask({
    required this.titleController, // Added
    required this.contentcontroller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleConfig.scale(24),
        vertical: context.scaleConfig.scale(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Task Title TextFormField
          TextFormField(
            controller: titleController,
            cursorColor: context.appTheme.colorScheme
                .onSecondary, // <-- Added: Set cursor color
            style: context.appTheme.textTheme.headlineSmall!.copyWith(
              // More prominent style for title
              color: context.appTheme.colorScheme.onSecondary,
              fontSize: context.scaleConfig.scaleText(22),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "117".tr, // "Task Title" - existing key
              hintStyle: context.appTheme.textTheme.headlineSmall!.copyWith(
                color:
                    context.appTheme.colorScheme.onSecondary.withOpacity(0.7),
                fontSize: context.scaleConfig.scaleText(22),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: context.scaleConfig.scale(8)),
            ),
            maxLines: 1,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(
              height: context.scaleConfig
                  .scale(8)), // Space between title and description

          // Task Description TextFormField
          TextFormField(
            style: context.appTheme.textTheme.bodyLarge!.copyWith(
              fontSize: context.scaleConfig.scaleText(17),
              color: context.appTheme.colorScheme.onSecondary,
            ),
            cursorColor: context.appTheme.colorScheme
                .onSecondary, // <-- Added: Set cursor color
            controller: contentcontroller,
            maxLines: 4,
            minLines: 2,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintStyle: context.appTheme.textTheme.bodyLarge!.copyWith(
                fontSize: context.scaleConfig.scaleText(17),
                color:
                    context.appTheme.colorScheme.onSecondary.withOpacity(0.7),
              ),
              hintText: "118".tr, // "Task Description..." - existing key
              border: InputBorder.none,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: context.scaleConfig.scale(16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GetBuilder<TaskcreateController>(
                  builder: (controller) => controller.images.isNotEmpty
                      ? SizedBox(
                          height: context.scaleConfig.scale(72),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.images.length,
                            itemBuilder: (context, index) {
                              final imagePath = controller.images[index] ?? '';
                              if (imagePath.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: context.scaleConfig.scale(10)),
                                child: GestureDetector(
                                  onTap: () {
                                    if (imagePath.isNotEmpty) {
                                      Get.dialog(
                                        Dialog(
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                context.scaleConfig.scale(16)),
                                            child: Image.file(File(imagePath),
                                                fit: BoxFit.contain),
                                          ),
                                        ),
                                        barrierDismissible: true,
                                      );
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            context.scaleConfig.scale(10)),
                                        child: Image.file(
                                          File(imagePath),
                                          height: context.scaleConfig.scale(72),
                                          width: context.scaleConfig.scale(72),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            controller.deleteImage(imagePath),
                                        child: Container(
                                          margin: EdgeInsets.all(
                                              context.scaleConfig.scale(4)),
                                          padding: EdgeInsets.all(
                                              context.scaleConfig.scale(3)),
                                          decoration: BoxDecoration(
                                            color: context
                                                .appTheme.colorScheme.error
                                                .withOpacity(0.85),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: context.scaleConfig.scale(14),
                                            color: context
                                                .appTheme.colorScheme.onError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: context.scaleConfig.scale(20.0)),
                          child: Text(
                            "120".tr, // "No images added yet" - existing key
                            style:
                                context.appTheme.textTheme.bodyMedium!.copyWith(
                              color: context.appTheme.colorScheme.onSecondary
                                  .withOpacity(0.7),
                              fontSize: context.scaleConfig.scaleText(15),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: context.scaleConfig.scale(10)),
              MaterialButton(
                onPressed: controller.pickImage,
                color:
                    context.appTheme.colorScheme.onSecondary.withOpacity(0.2),
                textColor: context.appTheme.colorScheme.onSecondary,
                elevation: 0,
                highlightElevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(12),
                  vertical: context.scaleConfig.scale(10),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(context.scaleConfig.scale(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        size: context.scaleConfig.scaleText(18)),
                    SizedBox(width: context.scaleConfig.scale(6)),
                    Text(
                      "121".tr, // "Add" - existing key
                      style: context.appTheme.textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontSize: context.scaleConfig.scaleText(14),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
