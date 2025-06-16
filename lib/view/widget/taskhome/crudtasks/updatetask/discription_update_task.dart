import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class Discriptionupdatetask extends GetView<TaskUpdatecontroller> {
  const Discriptionupdatetask({super.key});

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
              "137".tr,
              style: AppThemes.getCommonTextTheme().titleLarge!.copyWith(
                    fontSize: context.scaleConfig.scaleText(20),
                    color: context.appTheme.colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: context.scaleConfig.scale(12)),
            TextFormField(
              controller: controller.contentcontroller,
              maxLines: null,
              minLines: 3,
              keyboardType: TextInputType.multiline,
              style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                    color: context.appTheme.colorScheme.onSurface,
                    fontSize: context.scaleConfig.scaleText(16),
                  ),
              decoration: InputDecoration(
                hintText: "138".tr,
                hintStyle: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                      color: context.appTheme.colorScheme.onSurface
                          .withOpacity(0.5),
                      fontSize: context.scaleConfig.scaleText(16),
                    ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(context.scaleConfig.scale(10)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    context.appTheme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
