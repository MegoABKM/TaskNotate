import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class Subtasks extends GetView<TaskcreateController> {
  const Subtasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(12)),
        border: Border.all(
          width: context.scaleConfig.scale(1.5),
          color: context.appTheme.colorScheme.onSurface.withOpacity(0.15),
        ),
        color: context.appTheme.colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      padding: EdgeInsets.all(context.scaleConfig.scale(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.add_task_outlined,
                size: context.scaleConfig.scaleText(18)),
            label: Text(
              "112".tr, // "Add Subtask" - existing key
              style: context.appTheme.textTheme.labelLarge!.copyWith(
                color: Colors
                    .white, // Consider context.appTheme.colorScheme.onPrimary
                fontSize: context.scaleConfig.scaleText(15),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  context.appTheme.colorScheme.primary.withOpacity(0.9),
              foregroundColor: context.appTheme.colorScheme.onPrimary,
              padding:
                  EdgeInsets.symmetric(vertical: context.scaleConfig.scale(12)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(context.scaleConfig.scale(10)),
              ),
            ),
            onPressed: controller.addtosubtasktextfield,
          ),
          // MODIFIED: Removed SizedBox(height: context.scaleConfig.scale(12))
          // The list of subtasks will now appear directly after the "Add Subtask" button.
          // If a small space is desired, add a smaller SizedBox here, e.g. context.scaleConfig.scale(6)
          GetBuilder<TaskcreateController>(
            builder: (controller) {
              if (controller.subtaskControllers.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: context.scaleConfig.scale(
                          25)), // This padding is for the "empty" message
                  alignment: Alignment.center,
                  child: Text(
                    "noSubtasksPrompt".tr,
                    textAlign: TextAlign.center,
                    style: context.appTheme.textTheme.bodyMedium?.copyWith(
                      color: context.appTheme.colorScheme.onSurface
                          .withOpacity(0.6),
                      fontSize: context.scaleConfig.scaleText(15),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.subtaskControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.scaleConfig.scale(
                            6.0)), // This padding gives space between subtask items
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            style:
                                context.appTheme.textTheme.bodyLarge!.copyWith(
                              color: context.appTheme.colorScheme.onSurface,
                              fontSize: context.scaleConfig.scaleText(16),
                            ),
                            cursorColor: context.appTheme.colorScheme
                                .primary, // Good practice to set cursor color
                            controller: controller.subtaskControllers[index],
                            decoration: InputDecoration(
                              hintStyle: context.appTheme.textTheme.bodyMedium!
                                  .copyWith(
                                color: context.appTheme.colorScheme.onSurface
                                    .withOpacity(0.5),
                                fontSize: context.scaleConfig.scaleText(15),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: context.scaleConfig.scale(14),
                                vertical: context.scaleConfig.scale(14),
                              ),
                              hintText: "subtaskItemHint".tr,
                              filled: true,
                              fillColor: context.appTheme.colorScheme.surface
                                  .withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    context.scaleConfig.scale(10)),
                                borderSide: BorderSide(
                                  color: context.appTheme.colorScheme.onSurface
                                      .withOpacity(0.2),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    context.scaleConfig.scale(10)),
                                borderSide: BorderSide(
                                  color: context.appTheme.colorScheme.onSurface
                                      .withOpacity(0.2),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: context.appTheme.colorScheme.primary,
                                    width: context.scaleConfig.scale(1.5)),
                                borderRadius: BorderRadius.circular(
                                    context.scaleConfig.scale(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.scaleConfig.scale(8)),
                        IconButton(
                          onPressed: () => controller.removeSubtask(index),
                          icon: Icon(
                              FontAwesomeIcons
                                  .trashAlt, // Consider Icons.delete_outline for Material look
                              color: context.appTheme.colorScheme.error
                                  .withOpacity(0.75),
                              size: context.scaleConfig.scale(
                                  18)), // Use scale() for icon containers, scaleText() for font icons if size is font-based
                          tooltip: "removeSubtaskTooltip".tr,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
