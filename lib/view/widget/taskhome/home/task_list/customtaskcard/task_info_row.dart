import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

/// Class for building task info rows
class TaskInfoRow {
  static Widget build(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ScaleConfig scale,
    bool visible = true,
  }) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: scale.scale(16), color: theme.colorScheme.primary),
        SizedBox(width: scale.scale(4)),
        Text(
          label,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
