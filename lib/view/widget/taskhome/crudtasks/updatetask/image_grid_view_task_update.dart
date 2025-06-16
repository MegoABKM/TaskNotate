import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/shared/mediaviewer/fullimagescreen.dart';

class Imagegridviewtaskupdate extends GetView<TaskUpdatecontroller> {
  const Imagegridviewtaskupdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: context.scaleConfig.scale(4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16))),
      child: Container(
        padding: EdgeInsets.all(context.scaleConfig.scale(16)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.appTheme.colorScheme.surface,
              context.appTheme.colorScheme.surface.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "140".tr,
                  style: AppThemes.getCommonTextTheme().titleLarge!.copyWith(
                        fontSize: context.scaleConfig.scaleText(20),
                        color: context.appTheme.colorScheme.onSurface,
                      ),
                ),
                ElevatedButton(
                  onPressed: controller.pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appTheme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.scaleConfig.scale(12)),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: context.scaleConfig.scale(12)),
                  ),
                  child: Text(
                    "141".tr,
                    style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                          color: context.appTheme.colorScheme.onSecondary,
                          fontSize: context.scaleConfig.scaleText(16),
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.scaleConfig.scale(12)),
            SizedBox(
              height: context.scaleConfig.scale(200),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.decodedImages.length,
                itemBuilder: (context, index) {
                  String imagePath =
                      controller.decodedImages.values.toList()[index];
                  return Padding(
                    padding:
                        EdgeInsets.only(right: context.scaleConfig.scale(8)),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(
                              () => FullScreenImageView(imagePath: imagePath)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                context.scaleConfig.scale(12)),
                            child: Image.file(
                              File(imagePath),
                              width: context.scaleConfig.scale(160),
                              height: context.scaleConfig.scale(160),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: context.scaleConfig.scale(8),
                          right: context.scaleConfig.scale(8),
                          child: IconButton(
                            icon: Icon(Icons.remove_circle,
                                color: context.appTheme.colorScheme.secondary,
                                size: context.scaleConfig.scale(24)),
                            onPressed: () => controller.deleteImage(imagePath),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
