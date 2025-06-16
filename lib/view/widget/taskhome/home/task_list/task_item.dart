import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/custom_task_card.dart'; // Assuming this is CustomTaskCardHome
import 'package:tasknotate/view/widget/taskhome/home/task_list/flags/flag_icon_builder.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/status_indicator.dart';

class TaskItem extends StatelessWidget {
  final UserTasksModel task;
  final int index;
  final ScaleConfig scale;

  const TaskItem({
    required this.task,
    required this.index,
    required this.scale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: scale.scale(8.0),
        vertical: scale.scale(4.0),
      ),
      child: LayoutBuilder(
        // Wrap with LayoutBuilder to get constraints
        builder: (BuildContext context, BoxConstraints constraints) {
          // constraints.maxWidth gives the available physical width for the Stack
          final double taskItemPhysicalWidth = constraints.maxWidth;

          final flags = FlagIconBuilder(
            task: task,
            scale: scale,
            context: context,
          ).build(taskItemPhysicalWidth); // Pass the physical width

          return GestureDetector(
            onTap: () {
              controller.goToViewTask(
                task,
                index.toString(),
              );
            },
            // Consider adding onLongPress from CustomTaskCardHome here if needed,
            // or ensure CustomTaskCardHome's onLongPress is accessible.
            // For simplicity, CustomTaskCardHome's own gestures will work if it's the primary visible layer.
            child: Stack(
              clipBehavior: Clip
                  .none, // Allows flags to potentially overflow slightly if designed that way
              children: [
                CustomTaskCardHome(task, "${index + 1}", scale: scale),
                ...flags, // Spread the list of Positioned FlagIcon widgets
                StatusIndicator(
                  task: task,
                  scale: scale,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
