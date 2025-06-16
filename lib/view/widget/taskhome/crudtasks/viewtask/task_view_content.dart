import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:get/get.dart';

class TaskViewContent extends StatelessWidget {
  final String content;

  const TaskViewContent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // If the content is specifically "Not Set", then render an empty widget.
    if (content == "Not Set") {
      return const SizedBox
          .shrink(); // This widget takes up no space and is invisible.
    }

    // If content is not "Not Set", proceed to build the Card.
    // The logic inside will handle empty strings by showing "No description available".
    return Card(
      elevation: context.scaleConfig.scale(4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16))),
      child: Container(
        padding: EdgeInsets.all(context.scaleConfig.scale(16)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.appTheme.colorScheme.surface,
              context.appTheme.colorScheme.surface.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "137".tr, // "Description"
              style: context.appTheme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appTheme.colorScheme.onSurface,
                fontSize: context.scaleConfig.scaleText(20),
              ),
            ),
            SizedBox(height: context.scaleConfig.scale(12)),
            Text(
              // At this point, 'content' is not "Not Set".
              // If 'content' is an empty string, show "No description available".
              // Otherwise, show the actual content.
              content.isNotEmpty
                  ? content
                  : "157".tr, // "No description available"
              style: context.appTheme.textTheme.bodyLarge!.copyWith(
                color: context.appTheme.colorScheme.onSurface.withOpacity(0.85),
                fontSize: context.scaleConfig.scaleText(18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
