import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class TitleUpdateTask extends GetView<TaskUpdatecontroller> {
  const TitleUpdateTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.04),
      child: TextFormField(
        controller: controller.titlecontroller,
        style: AppThemes.getCommonTextTheme().headlineSmall!.copyWith(
              color: context.appTheme.colorScheme.onSurface,
              fontSize: Get.width * 0.06,
            ),
        decoration: InputDecoration(
          hintText: "124".tr,
          hintStyle: AppThemes.getCommonTextTheme().headlineSmall!.copyWith(
                color: context.appTheme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: Get.width * 0.06,
              ),
          // border: InputBorder.none,
        ),
      ),
    );
  }
}
