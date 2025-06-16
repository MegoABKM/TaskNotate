// taskshome.dart (or wherever your home screen's task list UI is)
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/taskhome/home/categoires_task_drawer.dart';
import 'package:tasknotate/view/widget/taskhome/home/category_dropdown.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_timeline/timeline_task_home.dart';
import 'package:tasknotate/view/widget/taskhome/home/animate_app_bar_task.dart';
import 'package:tasknotate/view/widget/taskhome/home/custom_float_button_task.dart';
import 'package:tasknotate/view/widget/taskhome/home/empty_task_message.dart';
import 'package:tasknotate/view/widget/taskhome/home/sort_drop_down.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/task_item.dart'; // Ensure this path is correct

class Taskshome extends StatelessWidget {
  const Taskshome({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.find<HomeController>(); // Finding the permanent instance

    return Scaffold(
      floatingActionButton: CustomFloatButtonTask(
        onPressed: () {
          Get.toNamed(AppRoute.createTask);
          Get.find<SoundService>().playButtonClickSound();
        },
      ),
      drawer: CategoryDrawerTask(
        controller: controller,
        isTaskDrawer: true,
      ),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          const AnimateAppBarTask(),
          GetBuilder<HomeController>(
            // This GetBuilder listens for 'sort-view'
            id: 'sort-view',
            builder: (ctrl) => SliverToBoxAdapter(
              // ctrl is the same as controller here
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.scaleConfig.scale(8.0),
                  horizontal: context.scaleConfig.scale(24.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: !ctrl.isTimelineView // Use ctrl here
                                ? context.appTheme.colorScheme.secondary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadiusDirectional.only(
                              topStart:
                                  Radius.circular(context.scaleConfig.scale(8)),
                              bottomStart:
                                  Radius.circular(context.scaleConfig.scale(8)),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => ctrl.toggleTaskView(false),
                            icon: Icon(
                              FontAwesomeIcons.listCheck,
                              color: !ctrl.isTimelineView
                                  ? context.appTheme.colorScheme.onSecondary
                                  : Colors.grey.shade600,
                              size: context.scaleConfig.scale(20),
                            ),
                            tooltip: 'List View'.tr,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ctrl.isTimelineView // Use ctrl here
                                ? context.appTheme.colorScheme.secondary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd:
                                  Radius.circular(context.scaleConfig.scale(8)),
                              bottomEnd:
                                  Radius.circular(context.scaleConfig.scale(8)),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => ctrl.toggleTaskView(true),
                            icon: Icon(
                              FontAwesomeIcons.timeline,
                              color: ctrl.isTimelineView
                                  ? context.appTheme.colorScheme.onSecondary
                                  : Colors.grey.shade600,
                              size: context.scaleConfig.scale(20),
                            ),
                            tooltip: 'Timeline View'.tr,
                          ),
                        ),
                      ],
                    ),
                    CategoryDropdown(
                      controller: ctrl, // Pass ctrl
                    ),
                    SortDropdown(
                      controller: ctrl, // Pass ctrl
                      scale: context.scaleConfig,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<HomeController>(
            // This GetBuilder listens for 'task-view' (and others if specified in update())
            id: 'task-view', // Make sure this ID matches what's in controller.update()
            builder: (ctrl) {
              // ctrl is the same as controller here
              if (ctrl.isLoadingTasks) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (ctrl.isTimelineView) {
                return const TimelineHome(); // Assuming TimelineHome also uses GetBuilder or reacts to ctrl changes
              } else {
                if (ctrl.taskdata.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyTaskMessage(),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < ctrl.taskdata.length) {
                        final task = ctrl.taskdata[index];
                        return TaskItem(
                          // TaskItem needs to correctly display the task.status
                          task: task,
                          index: index,
                          scale: context.scaleConfig,
                        );
                      }
                      // For the extra item for potential spacing at the bottom
                      return SizedBox(
                          height: 80 * context.scaleConfig.scaleHeight);
                    },
                    childCount: ctrl.taskdata.length +
                        (ctrl.taskdata.isEmpty
                            ? 0
                            : 1), // Adjust childCount if adding spacer
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
