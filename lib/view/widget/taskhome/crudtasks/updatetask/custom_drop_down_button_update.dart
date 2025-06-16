import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskupdate_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomDropDownButtonUpdate extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final TaskUpdatecontroller controller = Get.find();

  CustomDropDownButtonUpdate({
    required this.value,
    required this.items,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: context.appTheme.colorScheme.surface,
      elevation: context.scaleConfig.scale(4).toInt(),
      value: value, // Raw value like "Completed"
      onChanged: (String? newValue) {
        if (newValue != null && onChanged != null) {
          onChanged!(newValue); // Pass raw value back
        }
      },
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(horizontal: context.scaleConfig.scale(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
          borderSide: BorderSide(color: context.appTheme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
          borderSide: BorderSide(color: context.appTheme.colorScheme.secondary),
        ),
      ),
      items: items
          .map((String rawValue) => DropdownMenuItem<String>(
                value: rawValue,
                child: Text(
                  items.length == 3
                      ? controller.getTranslatedStatus(rawValue)
                      : controller.getTranslatedPriority(rawValue),
                  style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                        color: context.appTheme.colorScheme.onSurface,
                        fontSize: context.scaleConfig.scaleText(16),
                      ),
                ),
              ))
          .toList(),
    );
  }
}
