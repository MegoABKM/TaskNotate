import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomAppBarTaskCreate extends GetView<TaskcreateController> {
  const CustomAppBarTaskCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: context.scaleConfig.scale(60),
      padding: EdgeInsets.symmetric(horizontal: context.scaleConfig.scale(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: context.appTheme.colorScheme.onSecondary,
            onPressed: () {
              controller
                  .deleteAllImages(); // Consider if this is always desired on back press
              Get.offAllNamed(AppRoute.home);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: context.scaleConfig.scale(22),
            ),
          ),
          Expanded(
            child: Center(
              // Center the "Create Task" title
              child: Text(
                "key_create_task".tr, // "Create Task"
                style: context.appTheme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.appTheme.colorScheme.onSecondary,
                  fontSize:
                      context.scaleConfig.scaleText(21), // Slightly larger
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
              width: context.scaleConfig.scale(
                  48)), // Placeholder to balance the back button, adjust as needed
        ],
      ),
    );
  }
}
