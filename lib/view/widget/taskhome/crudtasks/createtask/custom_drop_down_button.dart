import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomDropDownButton extends GetView<TaskcreateController> {
  final String? value; // This 'value' should be one of the 'items'
  final List<String>
      items; // These are the raw values/keys for the dropdown items
  final Function(String?)? onChanged;
  final String type; // "priority", "status", or "category"
  final String hintTextKey; // New parameter for the hint text key

  const CustomDropDownButton(
    this.value,
    this.items, {
    super.key,
    this.onChanged,
    required this.type,
    required this.hintTextKey, // Make it required
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.scaleConfig.scale(12)),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.appTheme.colorScheme.onSurface.withOpacity(0.25),
          width: context.scaleConfig.scale(1.5),
        ),
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value)
              ? value
              : null, // Ensure value is among items or null
          items: items.map((String itemKeyOrValue) {
            // itemKeyOrValue is e.g. "High", "Medium", "homeCategoryDropdownLabel", "CategoryName1"
            String displayText;
            if (type == "priority") {
              displayText =
                  controller.priorityTranslations[itemKeyOrValue]?.tr ??
                      itemKeyOrValue.tr;
            } else if (type == "status") {
              displayText = controller.statusTranslations[itemKeyOrValue]?.tr ??
                  itemKeyOrValue.tr;
            } else if (type == "category") {
              // If itemKeyOrValue is 'homeCategoryDropdownLabel', it gets translated.
              // If it's a category name directly from homeController.taskCategories, it's used as is (assuming it's already localized or fine as is).
              // However, category names from DB are usually not translation keys. 'homeCategoryDropdownLabel' is a key.
              if (itemKeyOrValue == 'homeCategoryDropdownLabel') {
                displayText = itemKeyOrValue.tr;
              } else {
                displayText =
                    itemKeyOrValue; // Actual category name, not a translation key
              }
            } else {
              displayText =
                  itemKeyOrValue.tr; // Fallback for other types if any
            }
            return DropdownMenuItem<String>(
              value: itemKeyOrValue, // The value is the key/raw name
              child: Text(
                displayText, // The displayed text is translated
                style: context.appTheme.textTheme.bodyLarge?.copyWith(
                  fontSize: context.scaleConfig.scaleText(16),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          style: context.appTheme.textTheme.bodyLarge?.copyWith(
            fontSize: context.scaleConfig.scaleText(16),
            color: context.appTheme.colorScheme.onSurface,
          ),
          hint: Text(
            hintTextKey.tr, // Use the provided hint text key
            style: context.appTheme.textTheme.bodyLarge?.copyWith(
              fontSize: context.scaleConfig.scaleText(16),
              color: context.appTheme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          icon: Icon(Icons.arrow_drop_down_rounded,
              size: context.scaleConfig.scale(28)),
          dropdownColor: context.appTheme.colorScheme.surfaceVariant,
        ),
      ),
    );
  }
}
