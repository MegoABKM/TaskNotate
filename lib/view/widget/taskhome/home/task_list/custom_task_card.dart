import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/task_dialog.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/task_info_row.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/task_title_row.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/customtaskcard/task_translator.dart';

class CustomTaskCardHome extends GetView<HomeController> {
  final UserTasksModel task;
  final String taskIndex;
  final ScaleConfig scale;

  const CustomTaskCardHome(this.task, this.taskIndex,
      {required this.scale, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () =>
          TaskDialogHelper.showTaskDialog(context, task, scale, controller),
      onTap: () => controller.goToViewTask(task, taskIndex),
      child: Card(
        color: context.appTheme.colorScheme.surface,
        elevation: scale.scale(5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scale.scale(12))),
        child: Padding(
          padding: EdgeInsets.all(scale.scale(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskTitleRow.build(context, taskIndex, task.title ?? "", scale),
              SizedBox(height: scale.scale(8)),
              TaskInfoRow.build(
                context,
                icon: Icons.priority_high,
                label:
                    "${"113".tr}: ${TaskTranslator.translatePriority(task.priority!)}",
                visible: task.priority != "Not Set",
                scale: scale,
              ),
              SizedBox(height: scale.scale(4)),
              TaskInfoRow.build(
                context,
                icon: FontAwesomeIcons.clock,
                label: task.estimatetime != null &&
                        task.estimatetime != "Not Set"
                    ? "${"373".tr}: ${DateFormat("dd MMM, hh:mm a").format(DateTime.parse(task.estimatetime!))}"
                    : "${"373".tr}: -",
                visible: task.estimatetime != null,
                scale: scale,
              ),
              SizedBox(height: scale.scale(4)),
              TaskInfoRow.build(
                context,
                icon: FontAwesomeIcons.fire,
                label:
                    "${"122".tr}: ${TaskTranslator.translateStatus(task.status!)}",
                scale: scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
