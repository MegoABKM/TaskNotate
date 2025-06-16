import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart'; // Import HomeController
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/custom_float_action_button.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/image_section.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/task_view_attributes.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/task_view_content.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/task_view_subtask.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/task_view_timeline.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/viewtask/task_view_title.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.colorScheme.surface,
      body: GetBuilder<Taskviewcontroller>(
        init: Taskviewcontroller(),
        builder: (controller) {
          if (controller.task == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: context.scaleConfig.scale(200),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.appTheme.colorScheme.primary,
                          context.appTheme.colorScheme.secondary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(context.scaleConfig.scale(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TaskViewTitle(
                              indextask: controller.index ?? "0",
                              titleText: controller.task!.title ?? "No Title",
                            ),
                            if (controller.task!.status != "Completed")
                              Padding(
                                padding: EdgeInsets.only(
                                    top: context.scaleConfig.scale(16)),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final String taskIdToUpdate =
                                        controller.task!.id!;
                                    final String targetStatus = "Completed";
                                    await controller.updateStatus(
                                      controller.task!.status ?? "",
                                      taskIdToUpdate,
                                      targetStatus,
                                    );
                                    if (Get.isRegistered<HomeController>()) {
                                      try {
                                        final homeController =
                                            Get.find<HomeController>();
                                        homeController.updateTaskInListDirectly(
                                            taskIdToUpdate, targetStatus);
                                      } catch (e) {
                                        // print("ViewTask: ERROR finding/calling homeController: $e");
                                      }
                                    }
                                    Get.offAllNamed(AppRoute.home);
                                  },
                                  icon: Icon(Icons.check,
                                      size: context.scaleConfig.scaleText(18)),
                                  label: Text("156".tr),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: context
                                        .appTheme.colorScheme.onSecondary,
                                    backgroundColor: context
                                        .appTheme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          context.scaleConfig.scale(30)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.scaleConfig.scale(16),
                                      vertical: context.scaleConfig.scale(8),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: context.appTheme.colorScheme.onPrimary,
                      size: context.scaleConfig.scale(24)),
                  onPressed: () => Get.offAllNamed(AppRoute.home),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.scaleConfig
                          .scale(16)), // Horizontal padding only
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attributes always shown, so it can have its own top padding if needed inside its own widget
                      // or add a SizedBox above it if consistent top padding is desired for the first item.
                      SizedBox(
                          height: context.scaleConfig.scale(
                              16)), // Initial top padding for the content block
                      TaskViewAttributes(
                        task: controller.task!,
                        onTap: () => controller.pickDateTime(context),
                      ),

                      // Conditionally add padding AND the widget
                      if (controller.task!.content != null &&
                          controller.task!.content != "Not Set" &&
                          controller.task!.content!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(16)),
                          child: TaskViewContent(
                              content: controller.task!.content!),
                        )
                      else if (controller.task!.content != null &&
                          controller.task!.content != "Not Set" &&
                          controller.task!.content!
                              .isEmpty) // Explicitly handle empty but not "Not Set"
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(16)),
                          child: TaskViewContent(
                              content: controller.task!
                                  .content!), // Will show "No description"
                        ),

                      if (controller.decodedImages.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(16)),
                          child: ImageSectionTask(controller: controller),
                        ),

                      // For subtasks, only show if not "Not Set" and add padding conditionally
                      if (controller.task!.subtask != null &&
                          controller.task!.subtask != "Not Set")
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(16)),
                          child: const TaskViewSubtask(),
                        ),

                      if (controller.decodedTimeline.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(16)),
                          child: TaskViewTimeline(controller: controller),
                        ),

                      SizedBox(height: context.scaleConfig.scale(20)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: CustomFloatActionButtonView(
        onPressed: () => Get.find<Taskviewcontroller>().goToUpdateTask(),
      ),
    );
  }
}
