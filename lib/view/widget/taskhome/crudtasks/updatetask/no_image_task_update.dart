import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class Noimagetaskupdate extends GetView<TaskUpdatecontroller> {
  const Noimagetaskupdate({super.key});

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "142".tr,
              style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                    color:
                        context.appTheme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: context.scaleConfig.scaleText(18),
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
      ),
    );
  }
}
