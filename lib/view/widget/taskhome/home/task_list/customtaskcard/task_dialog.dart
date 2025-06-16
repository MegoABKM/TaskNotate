import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/status_button.dart';

/// Helper class for task dialog
class TaskDialogHelper {
  static void showTaskDialog(
    BuildContext context,
    UserTasksModel task,
    ScaleConfig scale,
    HomeController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => _TaskDialogContent(
        task: task,
        scale: scale,
        controller: controller,
      ),
    );
  }
}

class _TaskDialogContent extends StatelessWidget {
  final UserTasksModel task;
  final ScaleConfig scale;
  final HomeController controller;

  const _TaskDialogContent({
    required this.task,
    required this.scale,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(scale.scale(12))),
      elevation: scale.scale(8),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.title ?? "",
              style: context.appTheme.textTheme.titleLarge
                  ?.copyWith(color: context.appTheme.colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: scale.scale(16)),
            _buildTaskStatusOptions(context),
            SizedBox(height: scale.scale(16)),
            StatusButton.build(
              context,
              label: "152".tr,
              color: Colors.red,
              icon: Icons.delete,
              scale: scale,
              onPressed: () {
                controller.deleteDataTask(task.id ?? "");
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusOptions(BuildContext context) {
    final statusOptions = [
      {
        "label": "153".tr,
        "color": Colors.green,
        "icon": Icons.check_circle,
        "newStatus": "Completed"
      },
      {
        "label": "154".tr,
        "color": Colors.blue,
        "icon": Icons.work,
        "newStatus": "In Progress"
      },
      {
        "label": "155".tr,
        "color": const Color.fromARGB(144, 255, 255, 0),
        "icon": Icons.watch_outlined,
        "newStatus": "Pending"
      },
    ];

    return Column(
      children: statusOptions
          .where((option) => option['newStatus'] != task.status)
          .map((option) => StatusButton.build(
                context,
                label: option['label'] as String,
                color: option['color'] as Color,
                icon: option['icon'] as IconData,
                scale: scale,
                onPressed: () {
                  controller.updateStatus(task.status ?? "", task.id ?? "",
                      option['newStatus'] as String);
                  controller.getTaskData();
                  Get.back();
                },
              ))
          .toList(),
    );
  }
}
