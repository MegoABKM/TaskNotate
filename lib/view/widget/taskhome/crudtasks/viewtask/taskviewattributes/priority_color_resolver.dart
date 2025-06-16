import 'package:flutter/material.dart';

class PriorityColorResolver {
  Color resolve(String priority, ThemeData theme) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.redAccent;
      case "medium":
        return Colors.orangeAccent;
      case "low":
        return Colors.greenAccent;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
