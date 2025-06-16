import 'dart:math'; // Added for max()
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class TaskViewSubtask extends GetView<Taskviewcontroller> {
  const TaskViewSubtask({Key? key}) : super(key: key);

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "110".tr, // "Subtasks"
              style: context.appTheme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appTheme.colorScheme.onSurface,
                fontSize: context.scaleConfig.scaleText(20),
              ),
            ),
            GetBuilder<Taskviewcontroller>(
              builder: (controller) {
                final subtasks = controller.decodedsubtask;
                if (subtasks == null || subtasks.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.scaleConfig.scale(12.0)),
                    child: Center(
                      child: Text(
                        "158".tr, // "No Subtasks"
                        style: context.appTheme.textTheme.bodyLarge!.copyWith(
                          color: context.appTheme.colorScheme.onSurface
                              .withOpacity(0.7),
                          fontSize: context.scaleConfig.scaleText(18),
                        ),
                      ),
                    ),
                  );
                }

                final double itemContentHeight =
                    context.scaleConfig.scale(38); // Base height of content
                final double separatorHeight = context.scaleConfig.scale(12);
                // Adjusting item height to ensure number container (32) fits well,
                // and text has enough space. scale(38) seems reasonable.
                // The total height will be sum of item heights + separator heights.
                double listViewHeight = (subtasks.length * itemContentHeight) +
                    (max(0, subtasks.length - 1) * separatorHeight);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height:
                            context.scaleConfig.scale(8)), // Space after title
                    SizedBox(
                      height: listViewHeight,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: subtasks.length,
                        itemBuilder: (context, i) {
                          final entry = subtasks.entries.elementAt(i);
                          final index = int.parse(entry.key) + 1;
                          final subtask = entry.value;
                          return Row(
                            // MODIFIED: Changed from CrossAxisAlignment.start
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: context.scaleConfig.scale(32),
                                height: context.scaleConfig.scale(32),
                                decoration: BoxDecoration(
                                  color: context.appTheme.colorScheme.primary
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      context.scaleConfig.scale(8)),
                                ),
                                child: Center(
                                  child: Text(
                                    "$index",
                                    style: context.appTheme.textTheme.bodyLarge!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          context.appTheme.colorScheme.primary,
                                      fontSize: context.scaleConfig.scaleText(
                                          18), // Ensure this text is scaled
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: context.scaleConfig.scale(12)),
                              Expanded(
                                child: Text(
                                  subtask,
                                  style: context.appTheme.textTheme.bodyLarge!
                                      .copyWith(
                                    color:
                                        context.appTheme.colorScheme.onSurface,
                                    fontSize: context.scaleConfig.scaleText(
                                        18), // Ensure this text is scaled
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: separatorHeight),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
