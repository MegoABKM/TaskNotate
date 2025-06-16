// lib/view/widget/taskhome/task_list/statusindicator.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/core/constant/imageasset.dart';

class StatusIndicator extends StatelessWidget {
  final UserTasksModel task;
  final ScaleConfig scale;

  const StatusIndicator({
    required this.task,
    required this.scale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final StorageService myServices = Get.find<StorageService>();
    final String? lang = myServices.sharedPreferences.getString("lang");
    final bool isRTL = lang == "ar";

    return Positioned(
      top: scale.scale(10), // Position at the top
      right: isRTL ? null : scale.scale(10), // Right corner in LTR
      left: isRTL ? scale.scale(10) : null, // Left corner in RTL
      child: SizedBox(
        height: scale.scale(40),
        width: scale.scale(40),
        child: LottieBuilder.asset(
          task.status == "In Progress"
              ? AppImageAsset.taskunchecked
              : task.status == "Pending"
                  ? AppImageAsset.pendingtask2
                  : AppImageAsset.checked2,
          repeat: task.status != "Completed",
        ),
      ),
    );
  }
}
