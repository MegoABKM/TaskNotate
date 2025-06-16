import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class Subtaskupdate extends StatelessWidget {
  const Subtaskupdate({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskUpdatecontroller>(
      builder: (controller) => Card(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "143".tr, // "Subtasks"
                    style: AppThemes.getCommonTextTheme().titleLarge!.copyWith(
                          fontSize: context.scaleConfig.scaleText(20),
                          color: context.appTheme.colorScheme.onSurface,
                        ),
                  ),
                  Switch(
                    activeTrackColor: context.appTheme.colorScheme.secondary,
                    inactiveTrackColor: Colors.grey.shade400,
                    inactiveThumbColor: context.appTheme.colorScheme.primary,
                    value: controller.statussubtasks,
                    onChanged: (value) =>
                        controller.switchstatusbutton(value, "subtasks"),
                  ),
                ],
              ),
              if (controller.statussubtasks) ...[
                SizedBox(height: context.scaleConfig.scale(12)),
                ElevatedButton(
                  onPressed: controller.addtosubtasktextfield,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appTheme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.scaleConfig.scale(12)),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: context.scaleConfig.scale(12)),
                  ),
                  child: Text(
                    "144".tr, // "Add Subtask"
                    style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                          color: context.appTheme.colorScheme.onSecondary,
                          fontSize: context.scaleConfig.scaleText(16),
                        ),
                  ),
                ),
                SizedBox(height: context.scaleConfig.scale(12)),
                SizedBox(
                  height: controller.subtaskControllers.isEmpty
                      ? context.scaleConfig.scale(100)
                      : controller.subtaskControllers.length *
                          context.scaleConfig.scale(80),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller.subtaskControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: context.scaleConfig.scale(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    controller.subtaskControllers[index],
                                style: AppThemes.getCommonTextTheme()
                                    .bodyLarge!
                                    .copyWith(
                                      color: context
                                          .appTheme.colorScheme.onSurface,
                                      fontSize:
                                          context.scaleConfig.scaleText(16),
                                    ),
                                decoration: InputDecoration(
                                  hintText: "145".tr, // "Enter subtask"
                                  hintStyle: AppThemes.getCommonTextTheme()
                                      .bodyLarge!
                                      .copyWith(
                                        color: context
                                            .appTheme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                        fontSize:
                                            context.scaleConfig.scaleText(16),
                                      ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        context.scaleConfig.scale(10)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: context
                                      .appTheme.colorScheme.primary
                                      .withOpacity(0.1),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.minus,
                                color: context.appTheme.colorScheme.secondary,
                                size: context.scaleConfig.scale(20),
                              ),
                              onPressed: () => controller.removeSubtask(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
