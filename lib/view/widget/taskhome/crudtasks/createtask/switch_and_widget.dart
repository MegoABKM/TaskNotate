import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class SwitchAndWidget extends GetView<TaskcreateController> {
  final String nameofswitch;
  final String typeofswitch;
  final bool valueofswitch;
  final Widget widget;

  const SwitchAndWidget(
    this.nameofswitch,
    this.typeofswitch,
    this.valueofswitch,
    this.widget, {
    super.key,
    required ThemeData theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                controller.switchstatusbutton(!valueofswitch, typeofswitch),
            borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleConfig.scale(4),
                vertical: context.scaleConfig.scale(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nameofswitch,
                      style: context.appTheme.textTheme.bodyLarge!.copyWith(
                        color: context.appTheme.colorScheme.onSurface,
                        fontSize: context.scaleConfig.scaleText(17),
                      ),
                    ),
                  ),
                  SizedBox(width: context.scaleConfig.scale(10)),
                  Switch.adaptive(
                    inactiveTrackColor:
                        context.appTheme.colorScheme.onSurface.withOpacity(0.2),
                    inactiveThumbColor: context.appTheme.colorScheme.surface,
                    activeColor: context.appTheme.colorScheme.primary,
                    activeTrackColor:
                        context.appTheme.colorScheme.primary.withOpacity(0.4),
                    value: valueofswitch,
                    onChanged: (value) {
                      controller.switchstatusbutton(value, typeofswitch);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (valueofswitch)
          Padding(
            padding: EdgeInsets.only(
              top: context.scaleConfig.scale(10),
              left: context.scaleConfig.scale(4),
              right: context.scaleConfig.scale(4),
              bottom: context.scaleConfig.scale(8),
            ),
            child: widget,
          ),
      ],
    );
  }
}
