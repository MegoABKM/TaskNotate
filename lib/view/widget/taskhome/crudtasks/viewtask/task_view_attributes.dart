import 'package:flutter/material.dart';
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:get/get.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/taskviewattributes/priority_color_resolver.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/taskviewattributes/task_date_formatter.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/taskviewattributes/task_priority_translator.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/taskviewattributes/task_status_translator.dart';

class TaskViewAttributes extends GetView<Taskviewcontroller> {
  final UserTasksModel task;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveReminder;

  TaskViewAttributes({
    Key? key,
    required this.task,
    this.onTap,
    this.onRemoveReminder,
  }) : super(key: key);

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
            _buildHeader(context),
            SizedBox(height: context.scaleConfig.scale(12)),
            _buildAttributeRows(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      "126".tr, // "Details"
      style: context.appTheme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: context.appTheme.colorScheme.onSurface,
        fontSize: context.scaleConfig.scaleText(20),
      ),
    );
  }

  Widget _buildAttributeRows(BuildContext context) {
    final dateFormatter = TaskDateFormatter();
    final priorityTranslator = TaskPriorityTranslator();
    final statusTranslator = TaskStatusTranslator();
    final priorityColorResolver = PriorityColorResolver();
    return Column(
      children: [
        _buildAttributeRow(
          context: context,
          icon: Icons.list,
          title: "368".tr, // "Category"
          value: controller.categoryName ?? "key_home".tr,
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.calendar_today,
          title: "135".tr, // "Created"
          value: dateFormatter.format(task.date),
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.timelapse,
          title: "359".tr, // "Start"
          value: dateFormatter.format(task.starttime),
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.stop_circle,
          title: "130".tr, // "Due"
          value: dateFormatter.format(task.estimatetime),
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.priority_high,
          title: "113".tr, // "Priority"
          value: priorityTranslator.translate(task.priority ?? "Not Set"),
          valueColor: priorityColorResolver.resolve(
              task.priority ?? "Not Set", context.appTheme),
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.flag,
          title: "122".tr, // "Status"
          value: statusTranslator.translate(task.status ?? "Not Set"),
        ),
        SizedBox(height: context.scaleConfig.scale(8)),
        _buildAttributeRow(
          context: context,
          icon: Icons.alarm,
          title: "key_reminder_text".tr,
          value: dateFormatter.format(task.reminder),
          isTappable: true,
          onTap: onTap,
          showDeleteButton: task.reminder != "Not Set",
          onDelete: onRemoveReminder,
        ),
      ],
    );
  }

  Widget _buildAttributeRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    bool isTappable = false,
    VoidCallback? onTap,
    bool showDeleteButton = false,
    VoidCallback? onDelete,
  }) {
    return Row(
      children: [
        _buildIconContainer(context, icon),
        SizedBox(width: context.scaleConfig.scale(12)),
        Text(
          "$title: ",
          style: context.appTheme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.appTheme.colorScheme.onSurface,
            fontSize: context.scaleConfig.scaleText(15),
          ),
        ),
        Expanded(
          child: isTappable
              ? GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: context.appTheme.textTheme.bodyLarge!.copyWith(
                      color: context.appTheme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontSize: context.scaleConfig.scaleText(15),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: context.appTheme.textTheme.bodyLarge!.copyWith(
                    color: valueColor ?? context.appTheme.colorScheme.onSurface,
                    fontSize: context.scaleConfig.scaleText(15),
                  ),
                ),
        ),
        if (showDeleteButton && onDelete != null)
          IconButton(
            icon: Icon(
              Icons.delete,
              color: context.appTheme.colorScheme.error,
              size: context.scaleConfig.scale(20),
            ),
            onPressed: onDelete,
            tooltip: "Remove Reminder",
          ),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context, IconData icon) {
    return Container(
      padding: EdgeInsets.all(context.scaleConfig.scale(8)),
      decoration: BoxDecoration(
        color: context.appTheme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(8)),
      ),
      child: Icon(
        icon,
        color: context.appTheme.colorScheme.primary,
        size: context.scaleConfig.scale(20),
      ),
    );
  }
}
