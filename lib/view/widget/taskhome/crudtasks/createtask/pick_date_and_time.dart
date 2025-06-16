import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class PickDateAndTime extends GetView<TaskcreateController> {
  final String type;
  const PickDateAndTime(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    // These are the exact English strings we assume the controller returns for defaults.
    // These strings will *also* be our translation keys.
    String defaultPlaceholderKeyFromController;

    switch (type) {
      case "startdate":
        iconData = Icons.calendar_today_outlined;
        defaultPlaceholderKeyFromController = "Pick Start Date";
        break;
      case "finishdate":
        iconData = Icons.event_available_outlined;
        defaultPlaceholderKeyFromController = "Pick Finish Date";
        break;
      case "timer":
        iconData = Icons.alarm_add_outlined;
        defaultPlaceholderKeyFromController = "Set Reminder";
        break;
      default:
        iconData = Icons.date_range_outlined;
        defaultPlaceholderKeyFromController =
            "Select Date/Time"; // A generic fallback, ensure this key exists if used
    }

    return GestureDetector(
      onTap: () => controller.pickDateTime(context, type),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleConfig.scale(12),
          vertical: context.scaleConfig.scale(14),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.appTheme.colorScheme.onSurface.withOpacity(0.25),
            width: context.scaleConfig.scale(1.5),
          ),
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
        ),
        child: GetBuilder<TaskcreateController>(
          builder: (ctrl) {
            // Renamed to ctrl to avoid conflict with outer controller
            String textFromController = ctrl.getFormattedDateTime(type);
            // Check if the text returned by the controller is one of our known default placeholder keys
            bool isDefaultText =
                textFromController == defaultPlaceholderKeyFromController;

            return Row(
              children: [
                Icon(
                  iconData,
                  size: context.scaleConfig.scaleText(20),
                  color: isDefaultText
                      ? context.appTheme.colorScheme.onSurface.withOpacity(0.6)
                      : context.appTheme.colorScheme.primary,
                ),
                SizedBox(width: context.scaleConfig.scale(12)),
                Expanded(
                  child: Text(
                    textFromController
                        .tr, // Translate the string (either a key or actual date)
                    style: context.appTheme.textTheme.bodyMedium!.copyWith(
                      color: isDefaultText
                          ? context.appTheme.colorScheme.onSurface
                              .withOpacity(0.7)
                          : context.appTheme.colorScheme.onSurface,
                      fontSize: context.scaleConfig.scaleText(16),
                      fontWeight:
                          isDefaultText ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: context.scaleConfig.scaleText(22),
                  color:
                      context.appTheme.colorScheme.onSurface.withOpacity(0.6),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
