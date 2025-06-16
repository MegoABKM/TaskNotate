// lib/view/widget/taskhome/crudtasks/updatetask/attributesupdatetask.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/functions/formatdate.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/data/model/categorymodel.dart'; // Import CategoryModel
import 'package:tasknotate/view/widget/taskhome/crudtasks/updatetask/custom_drop_down_button_update.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/updatetask/custom_pick_date_and_time.dart';

class Attributesupdatetask extends StatelessWidget {
  const Attributesupdatetask({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final LocalController localController = Get.find<LocalController>();
    final String currentLocale = localController.language.languageCode;
    final scaleConfig = ScaleConfig(context);
    final textTheme = AppThemes.getCommonTextTheme(); // Get text theme once
    const String homeCategoryTranslationKey = "key_home";

    return GetBuilder<TaskUpdatecontroller>(
      builder: (controller) {
        if (controller.task == null) {
          return Card(
            // Card styling from AppThemes (if applicable) or default
            elevation: scaleConfig.scale(4), // Keep consistent elevation
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(scaleConfig
                    .scale(12))), // Use AppThemes border radius or consistent
            child: Container(
              padding: AppThemes.defaultPadding.copyWith(
                // Use default padding
                top: scaleConfig.scale(16),
                bottom: scaleConfig.scale(16),
              ),
              child: Center(
                child: Text(
                  "key_no_task_found".tr,
                  style: textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.error,
                    fontSize: scaleConfig
                        .scaleText(16), // Or use textTheme.bodyLarge.fontSize
                  ),
                ),
              ),
            ),
          );
        }

        String currentCategoryNameForDropdown;
        if (controller.selectedCategoryId == null) {
          currentCategoryNameForDropdown = homeCategoryTranslationKey.tr;
        } else {
          final selectedCategory = controller.categories.firstWhere(
            (category) => category.id == controller.selectedCategoryId,
            orElse: () {
              debugPrint(
                  "Warning: Task has category ID ${controller.selectedCategoryId}, "
                  "but this category was not found. Displaying as '${homeCategoryTranslationKey.tr}'.");
              return CategoryModel(
                  id: null, categoryName: homeCategoryTranslationKey.tr);
            },
          );
          currentCategoryNameForDropdown = selectedCategory.categoryName;
        }

        List<String> dropdownItems = [
          homeCategoryTranslationKey.tr,
          ...controller.categories
              .map((category) => category.categoryName)
              .toList(),
        ];
        dropdownItems = dropdownItems.toSet().toList();

        // Use card theme from AppThemes if defined, otherwise keep local styling
        final cardTheme = theme.cardTheme;

        return Card(
          elevation: cardTheme.elevation ?? scaleConfig.scale(3),
          margin: cardTheme.margin ?? EdgeInsets.zero,
          shape: cardTheme.shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    scaleConfig.scale(16)), // Softer, larger radius
              ),
          child: Container(
            padding: AppThemes.defaultPadding.copyWith(
              // Use default padding from AppThemes
              top: scaleConfig.scale(20),
              bottom: scaleConfig.scale(20),
            ),
            decoration: BoxDecoration(
              // If you want to use the gradient, keep it.
              // Otherwise, for a theme-consistent look, consider:
              color: theme.cardColor, // Use theme's cardColor for background
              // gradient: LinearGradient(
              //   colors: [
              //     theme.colorScheme.surface, // Or theme.cardColor
              //     theme.colorScheme.surface.withOpacity(0.8) // Or theme.cardColor.withOpacity(0.8)
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              borderRadius: (cardTheme.shape is RoundedRectangleBorder)
                  ? (cardTheme.shape as RoundedRectangleBorder).borderRadius
                      as BorderRadius?
                  : BorderRadius.circular(scaleConfig.scale(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: scaleConfig.scale(18)),
                  child: Text(
                    "126".tr, // "Attributes"
                    style: textTheme.titleLarge!.copyWith(
                      // Use titleLarge as it's well-defined in AppThemes
                      color: theme.colorScheme.onSurface,
                      fontSize: scaleConfig
                          .scaleText(textTheme.titleLarge!.fontSize ?? 20),
                    ),
                  ),
                ),
                _buildAttributeRow(
                  context: context,
                  icon: Icons.flag_outlined,
                  title: "127".tr, // "Status"
                  widget: CustomDropDownButtonUpdate(
                    value: controller.getTranslatedStatus(
                        controller.task!.status ?? "Pending"),
                    items: controller.statuses
                        .map((s) => controller.getTranslatedStatus(s))
                        .toList(),
                    onChanged: (translatedValue) {
                      String originalStatus = controller.statuses.firstWhere(
                          (s) =>
                              controller.getTranslatedStatus(s) ==
                              translatedValue,
                          orElse: () => "Pending");
                      controller.task =
                          controller.task?.copyWith(status: originalStatus);
                      controller.update();
                    },
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: Icons.category_outlined,
                  title: "368".tr, // Category
                  widget: CustomDropDownButtonUpdate(
                    value: currentCategoryNameForDropdown,
                    items: dropdownItems,
                    onChanged: (selectedValue) {
                      int? newCategoryId;
                      String? newCategoryStringForTaskModel;
                      if (selectedValue == homeCategoryTranslationKey.tr) {
                        newCategoryId = null;
                        newCategoryStringForTaskModel = null;
                      } else {
                        final selectedCatModel =
                            controller.categories.firstWhere(
                          (category) => category.categoryName == selectedValue,
                        );
                        newCategoryId = selectedCatModel.id;
                        newCategoryStringForTaskModel =
                            newCategoryId.toString();
                      }
                      controller.selectedCategoryId = newCategoryId;
                      controller.task = controller.task
                          ?.copyWith(category: newCategoryStringForTaskModel);
                      controller.update();
                    },
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: Icons.low_priority_outlined,
                  title: "128".tr, // "Priority"
                  widget: Row(
                    children: [
                      Expanded(
                        child: controller.statusprority
                            ? CustomDropDownButtonUpdate(
                                value: controller.getTranslatedPriority(
                                    controller.task!.priority ?? "Not Set"),
                                items: controller.priorities
                                    .map((p) =>
                                        controller.getTranslatedPriority(p))
                                    .toList(),
                                onChanged: (translatedValue) {
                                  String originalPriority =
                                      controller.priorities.firstWhere(
                                          (p) =>
                                              controller
                                                  .getTranslatedPriority(p) ==
                                              translatedValue,
                                          orElse: () => "Not Set");
                                  controller.task = controller.task
                                      ?.copyWith(priority: originalPriority);
                                  controller.update();
                                },
                              )
                            : Text(
                                "132".tr, // "Not Set"
                                style: textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: scaleConfig.scaleText(
                                      textTheme.bodyMedium!.fontSize ?? 14),
                                ),
                              ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.onSurface.withOpacity(0.12),
                        inactiveThumbColor:
                            theme.colorScheme.onSurface.withOpacity(0.38),
                        value: controller.statusprority,
                        onChanged: (value) =>
                            controller.switchstatusbutton(value, "priority"),
                      ),
                    ],
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: FontAwesomeIcons.hourglassStart,
                  title: "359".tr, // "Start Date"
                  widget: Row(
                    children: [
                      Expanded(
                        child: controller.statusstartDate
                            ? CustomPickDateAndTimeUpdate(
                                text: controller.selectedStartDate != null
                                    ? DateFormat("dd MMM, hh:mm a")
                                        .format(controller.selectedStartDate!)
                                    : "360".tr,
                                onTap: () => controller.pickDateTime(
                                    context, "startdate"),
                              )
                            : Text(
                                "132".tr,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: scaleConfig.scaleText(
                                      textTheme.bodyMedium!.fontSize ?? 14),
                                ),
                              ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.onSurface.withOpacity(0.12),
                        inactiveThumbColor:
                            theme.colorScheme.onSurface.withOpacity(0.38),
                        value: controller.statusstartDate,
                        onChanged: (value) =>
                            controller.switchstatusbutton(value, "startdate"),
                      ),
                    ],
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: FontAwesomeIcons.hourglassEnd,
                  title: "130".tr, // "Finish Date"
                  widget: Row(
                    children: [
                      Expanded(
                        child: controller.statusdateandtime
                            ? CustomPickDateAndTimeUpdate(
                                text: controller.selectedDate != null
                                    ? DateFormat("dd MMM, hh:mm a")
                                        .format(controller.selectedDate!)
                                    : "131".tr,
                                onTap: () => controller.pickDateTime(
                                    context, "dateandtime"),
                              )
                            : Text(
                                "132".tr,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: scaleConfig.scaleText(
                                      textTheme.bodyMedium!.fontSize ?? 14),
                                ),
                              ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.onSurface.withOpacity(0.12),
                        inactiveThumbColor:
                            theme.colorScheme.onSurface.withOpacity(0.38),
                        value: controller.statusdateandtime,
                        onChanged: (value) =>
                            controller.switchstatusbutton(value, "dateandtime"),
                      ),
                    ],
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: Icons.notifications_active_outlined,
                  title: "133".tr, // "Reminder"
                  widget: Row(
                    children: [
                      Expanded(
                        child: controller.statusreminder
                            ? CustomPickDateAndTimeUpdate(
                                text: controller.selectedAlarm != null
                                    ? DateFormat("dd MMM, hh:mm a")
                                        .format(controller.selectedAlarm!)
                                    : "134".tr,
                                onTap: () =>
                                    controller.pickDateTime(context, "alarm"),
                              )
                            : Text(
                                "132".tr,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: scaleConfig.scaleText(
                                      textTheme.bodyMedium!.fontSize ?? 14),
                                ),
                              ),
                      ),
                      Switch(
                        activeColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.onSurface.withOpacity(0.12),
                        inactiveThumbColor:
                            theme.colorScheme.onSurface.withOpacity(0.38),
                        value: controller.statusreminder,
                        onChanged: (value) =>
                            controller.switchstatusbutton(value, "reminder"),
                      ),
                    ],
                  ),
                  scaleConfig: scaleConfig,
                ),
                _buildDivider(scaleConfig, theme),
                _buildAttributeRow(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  title: "135".tr, // "Created Date"
                  isStaticValue: true,
                  widget: Text(
                    controller.task!.date != null &&
                            controller.task!.date!.isNotEmpty
                        // If using Option A (new function):
                        ? formatDateTime(controller.task!.date!, currentLocale)
                        // If using Option B (modified function):
                        // ? formatDate(controller.task!.date!, includeTime: true)
                        : "136".tr,
                    style: textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: scaleConfig
                          .scaleText(textTheme.bodyLarge!.fontSize ?? 16),
                    ),
                  ),
                  scaleConfig: scaleConfig,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider(ScaleConfig scaleConfig, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: scaleConfig.scale(6.0)), // Slightly less vertical padding
      child: Divider(
        height: 1,
        thickness: 0.8, // Slightly thicker for visibility
        color: theme.dividerColor.withOpacity(0.6), // Use theme's dividerColor
      ),
    );
  }

  Widget _buildAttributeRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget widget,
    required ScaleConfig scaleConfig,
    bool isStaticValue = false,
  }) {
    final theme = Theme.of(context);
    final textTheme = AppThemes.getCommonTextTheme();
    // Use primary color for interactive elements, secondary or onSurface for static
    final Color iconColor = theme.colorScheme.primary;
    final Color titleColor =
        theme.colorScheme.onSurface.withOpacity(0.85); // Slightly subdued title

    return InkWell(
      // Add InkWell for tap feedback if the row itself is interactive
      onTap: isStaticValue
          ? null
          : () {
              // If the row itself should trigger an action (e.g., open a picker directly)
              // This might not be needed if individual widgets (dropdown, datepicker) handle taps
            },
      borderRadius: BorderRadius.circular(scaleConfig.scale(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: scaleConfig.scale(10.0),
            horizontal: scaleConfig.scale(4.0)), // Adjusted padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                  scaleConfig.scale(10)), // Slightly larger icon padding
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12), // Consistent with theme
                borderRadius: BorderRadius.circular(
                    scaleConfig.scale(20)), // More rounded icon background
              ),
              child: Icon(icon, color: iconColor, size: scaleConfig.scale(20)),
            ),
            SizedBox(width: scaleConfig.scale(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.labelLarge!.copyWith(
                      // Use labelLarge for attribute titles
                      color: titleColor,
                      fontSize: scaleConfig.scaleText(
                          textTheme.labelLarge!.fontSize ??
                              15), // Slightly larger label
                      fontWeight: FontWeight.w500, // Medium weight for labels
                    ),
                  ),
                  SizedBox(height: scaleConfig.scale(2)), // Minimal space
                  DefaultTextStyle(
                    // Ensure widget uses consistent styling
                    style: textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: scaleConfig
                          .scaleText(textTheme.bodyLarge!.fontSize ?? 16),
                      fontWeight: isStaticValue
                          ? FontWeight.normal
                          : FontWeight.w500, // Value a bit bolder
                    ),
                    child: widget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
