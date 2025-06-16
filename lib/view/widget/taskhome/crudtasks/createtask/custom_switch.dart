import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomSwitch extends GetView<TaskcreateController> {
  final String nameofswitch;
  final String typeofswitch;
  final bool valueofswitch;

  const CustomSwitch(
    this.nameofswitch,
    this.typeofswitch,
    this.valueofswitch, {
    super.key,
    required ThemeData theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            controller.switchstatusbutton(!valueofswitch, typeofswitch),
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                context.scaleConfig.scale(4), // Minimal horizontal padding
            vertical:
                context.scaleConfig.scale(10), // Vertical padding for tap area
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nameofswitch,
                  style: context.appTheme.textTheme.bodyLarge!.copyWith(
                    fontSize: context.scaleConfig.scaleText(17),
                    color: context.appTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(width: context.scaleConfig.scale(10)),
              Switch.adaptive(
                inactiveTrackColor:
                    context.appTheme.colorScheme.onSurface.withOpacity(0.2),
                inactiveThumbColor: context.appTheme.colorScheme.surface,
                activeColor: context
                    .appTheme.colorScheme.primary, // Thumb color when active
                activeTrackColor:
                    context.appTheme.colorScheme.primary.withOpacity(0.4),
                value: valueofswitch,
                onChanged: (value) =>
                    controller.switchstatusbutton(value, typeofswitch),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
