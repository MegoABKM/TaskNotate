import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/shared/mediaviewer/fullimagescreen.dart';

class ImageSectionTask extends StatelessWidget {
  final Taskviewcontroller controller;

  const ImageSectionTask({super.key, required this.controller});

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
            Text(
              "140".tr, // "Images"
              style: context.appTheme.textTheme.titleLarge!.copyWith(
                color: context.appTheme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: context.scaleConfig.scaleText(20),
              ),
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
                    child: GestureDetector(
                      onTap: () => Get.to(
                          () => FullScreenImageView(imagePath: imagePath)),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                context.scaleConfig.scale(12)),
                            child: Image.file(
                              File(imagePath),
                              width: context.scaleConfig.scale(160),
                              height: context.scaleConfig.scale(160),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: context.scaleConfig.scale(8),
                            right: context.scaleConfig.scale(8),
                            child: Container(
                              padding:
                                  EdgeInsets.all(context.scaleConfig.scale(4)),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(
                                    context.scaleConfig.scale(8)),
                              ),
                              child: Text(
                                "${index + 1}/${controller.decodedImages.length}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: context.scaleConfig.scaleText(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
