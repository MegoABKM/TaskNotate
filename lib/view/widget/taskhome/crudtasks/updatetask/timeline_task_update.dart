import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/timeline_section.dart';

class TimelineTaskUpdate extends StatelessWidget {
  final TaskUpdatecontroller controller; // Specify the controller type
  const TimelineTaskUpdate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: context.scaleConfig.scale(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(16)),
      ),
      child: Container(
        padding: EdgeInsets.all(context.scaleConfig.scale(16)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.appTheme.colorScheme.surface,
              context.appTheme.colorScheme.surface.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Timeline".tr,
                  style: context.appTheme.textTheme.titleLarge!.copyWith(
                    fontSize: context.scaleConfig.scaleText(20),
                    color: context.appTheme.colorScheme.onSurface,
                  ),
                ),
                Switch(
                  activeTrackColor: context.appTheme.colorScheme.secondary,
                  inactiveTrackColor: Colors.grey.shade400,
                  inactiveThumbColor: context.appTheme.colorScheme.primary,
                  value: controller.statustimeline,
                  onChanged: (value) {
                    controller.toggleTimeline();
                  },
                ),
              ],
            ),
            // Show TimelineSection if statustimeline is true
            if (controller.statustimeline)
              Padding(
                padding: EdgeInsets.only(
                  top: context.scaleConfig.scale(16),
                ),
                child: TimelineSection(controller: controller),
              ),
          ],
        ),
      ),
    );
  }
}
