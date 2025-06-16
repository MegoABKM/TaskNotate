// In TaskTitleRow.dart
import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart'; // Ensure this is correct path to ScaleConfig

/// Class for building task title row
class TaskTitleRow {
  static Widget build(
    BuildContext context,
    String taskIndex,
    String title,
    ScaleConfig scale, // Make sure you pass this from CustomTaskCardHome
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          "$taskIndex -",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize:
                scale.scaleText(18), // Example: Ensure font size is scaled
          ),
        ),
        SizedBox(width: scale.scale(5)),
        Expanded(
          child: Text(
            title, // Pass the full title
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize:
                  scale.scaleText(18), // Example: Ensure font size is scaled
            ),
            maxLines: 1, // Important: Limits to 2 lines
            overflow:
                TextOverflow.ellipsis, // Important: Shows "..." if it overflows
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
