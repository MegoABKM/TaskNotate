import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:get/get.dart';

class TaskViewTitle extends StatelessWidget {
  final String indextask;
  final String titleText;

  const TaskViewTitle({
    Key? key,
    required this.titleText,
    required this.indextask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${"159".tr}$indextask", // "Task #$indextask"
          style: context.appTheme.textTheme.bodyLarge!.copyWith(
            color: context.appTheme.colorScheme.onPrimary.withOpacity(0.8),
            fontSize: context.scaleConfig.scaleText(16),
          ),
        ),
        Text(
          titleText,
          textAlign: TextAlign.center,
          style: context.appTheme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.appTheme.colorScheme.onPrimary,
            fontSize: context.scaleConfig.scaleText(24),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
