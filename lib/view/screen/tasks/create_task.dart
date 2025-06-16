import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart'; // Assuming AppThemes is accessible via extensions or directly
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/content_of_task.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/custom_appbar_create.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/custom_drop_down_button.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/pick_date_and_time.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/status_of_task.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/custom_switch.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/subtasks.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/switch_and_widget.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/timeline_section.dart';
// Make sure AppThemes is imported if not through extensions
// import 'package:tasknotate/core/theme/app_themes.dart'; // Example path

class CreateTask extends StatelessWidget {
  CreateTask({super.key});
  final TaskcreateController controller = Get.put(TaskcreateController());

  Widget _buildSectionTitle(BuildContext context, String titleKey) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.scaleConfig.scale(20),
        bottom: context.scaleConfig.scale(10),
        left: context.scaleConfig.scale(4),
      ),
      child: Text(
        titleKey.tr,
        style: context.appTheme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: context.appTheme.colorScheme.primary,
          fontSize: context.scaleConfig.scaleText(18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // Changed to extended
        foregroundColor: context.appTheme.colorScheme.onPrimary,
        elevation: context.scaleConfig.scale(4),
        backgroundColor: context.appTheme.colorScheme.secondary,
        onPressed: () => controller.uploadTask(),
        shape: RoundedRectangleBorder(
            // FAB.extended often uses rounded rectangle
            borderRadius: BorderRadius.circular(context.scaleConfig.scale(16))),
        icon: Icon(FontAwesomeIcons.checkToSlot,
            size: context.scaleConfig
                .scale(20)), // Slightly smaller icon for extended FAB
        label: Text(
          // Added label
          "saveButtonText".tr,
          style: TextStyle(
              fontSize: context.scaleConfig.scaleText(16),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.appTheme.colorScheme.secondary,
          // Use your AppThemes.isColorDark or a similar utility if available
          statusBarIconBrightness:
              AppThemes.isColorDark(context.appTheme.colorScheme.secondary)
                  ? Brightness.light
                  : Brightness.dark,
        ),
        child: Container(
          color: context.appTheme.colorScheme.surface,
          child: ListView(
            children: [
              Container(
                width: Get.width,
                padding: EdgeInsets.only(bottom: context.scaleConfig.scale(20)),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    color: context.appTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(context.scaleConfig.scale(35)),
                      bottomRight:
                          Radius.circular(context.scaleConfig.scale(35)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomAppBarTaskCreate(), // AppBar now mainly for back and "Create Task" title
                    ContentOfTask(
                        // ContentOfTask now includes the task title input
                        titleController: controller.titlecontroller!,
                        contentcontroller: controller.descriptioncontroller!),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(20),
                  vertical: context.scaleConfig.scale(20),
                ),
                child: GetBuilder<TaskcreateController>(
                  builder: (controller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle(
                          context, "275".tr), // Status (existing key)
                      const StatusOfTask(),
                      const Divider(height: 30, thickness: 1),

                      SwitchAndWidget(
                        "113".tr, // Priority (existing key)
                        "prority",
                        controller.statusprority,
                        CustomDropDownButton(
                          type: "priority",
                          controller.prority!,
                          controller.priorities,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.prority = newValue;
                              controller.update();
                            }
                          },
                          hintTextKey: "selectPriorityDropdownHint",
                        ),
                        theme: context.appTheme,
                      ),
                      const Divider(height: 30, thickness: 1),

                      SwitchAndWidget(
                        "366".tr, // Category (existing key)
                        "category",
                        controller.statuscategory,
                        GetBuilder<HomeController>(
                          id: 'task-category-view',
                          builder: (homeController) {
                            final categoryNames = homeController.taskCategories
                                .map((c) => c.categoryName)
                                .toList();
                            // The "Home" value is handled internally by controller.selectedCategoryId = null
                            // The display text for "Home" option in dropdown needs "homeCategoryDropdownLabel".tr
                            List<String> displayItems = [
                              'homeCategoryDropdownLabel',
                              ...categoryNames
                            ];
                            String? currentValueDisplay;
                            if (controller.selectedCategoryId == null) {
                              currentValueDisplay = 'homeCategoryDropdownLabel';
                            } else {
                              currentValueDisplay = homeController
                                  .taskCategories
                                  .firstWhere(
                                    (c) =>
                                        c.id == controller.selectedCategoryId,
                                    orElse: () => CategoryModel(
                                        id: null,
                                        categoryName:
                                            'homeCategoryDropdownLabel'), // Fallback
                                  )
                                  .categoryName;
                              // If categoryName isn't "homeCategoryDropdownLabel" itself ensure it's a valid item.
                              if (!displayItems.contains(currentValueDisplay)) {
                                // This case should ideally not happen if data is consistent
                                // If categoryName can be different from the displayItems list, more complex mapping needed.
                                // For now, assuming categoryName will be in categoryNames or we default to "Home" conceptually.
                              }
                            }

                            return CustomDropDownButton(
                              type: "category",
                              currentValueDisplay, // This needs to be one of the `items`
                              displayItems, // Use displayItems which includes "homeCategoryDropdownLabel"
                              onChanged: (String? newDisplayValue) {
                                // newDisplayValue is from displayItems
                                if (newDisplayValue ==
                                    'homeCategoryDropdownLabel') {
                                  controller.selectedCategoryId = null;
                                } else {
                                  // Find the original category by its name (which is newDisplayValue)
                                  final selectedCategory =
                                      homeController.taskCategories.firstWhere(
                                          (c) =>
                                              c.categoryName == newDisplayValue,
                                          orElse: () => CategoryModel(
                                              id: null, categoryName: 'None'));
                                  controller.selectedCategoryId =
                                      selectedCategory.id;
                                }
                                controller.update();
                              },
                              hintTextKey: "selectCategoryDropdownHint",
                            );
                          },
                        ),
                        theme: context.appTheme,
                      ),
                      const Divider(height: 30, thickness: 1),

                      _buildSectionTitle(
                          context, "scheduleRemindersSectionTitle"),
                      SwitchAndWidget(
                        "359".tr, // Start Date (existing key)
                        "startdate",
                        controller.statusstartdate,
                        const PickDateAndTime("startdate"),
                        theme: context.appTheme,
                      ),
                      SizedBox(height: context.scaleConfig.scale(10)),
                      SwitchAndWidget(
                        "114".tr, // Finish Date (existing key)
                        "finishdate",
                        controller.statusfinishdate,
                        const PickDateAndTime("finishdate"),
                        theme: context.appTheme,
                      ),
                      SizedBox(height: context.scaleConfig.scale(10)),
                      SwitchAndWidget(
                        "115".tr, // Reminder (existing key, was "Timer")
                        "timer",
                        controller.statustimer,
                        const PickDateAndTime("timer"),
                        theme: context.appTheme,
                      ),
                      const Divider(height: 30, thickness: 1),

                      _buildSectionTitle(
                          context, "additionalDetailsSectionTitle"),
                      CustomSwitch(
                        "110".tr, // Subtasks (existing key)
                        "subtasks",
                        controller.statussubtasks,
                        theme: context.appTheme,
                      ),
                      if (controller.statussubtasks)
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(8.0),
                              bottom: context.scaleConfig.scale(12.0)),
                          child: Subtasks(),
                        ),
                      SizedBox(
                          height: controller.statussubtasks
                              ? 0
                              : context.scaleConfig.scale(10)),

                      CustomSwitch(
                        "367".tr, // Timeline (existing key)
                        "timeline",
                        controller.statustimeline,
                        theme: context.appTheme,
                      ),
                      if (controller.statustimeline) ...[
                        Padding(
                          padding: EdgeInsets.only(
                              top: context.scaleConfig.scale(8.0),
                              bottom: context.scaleConfig.scale(12.0)),
                          child: TimelineSection(controller: controller),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: context.scaleConfig
                      .scale(90)) // Increased space for extended FAB
            ],
          ),
        ),
      ),
    );
  }
}
