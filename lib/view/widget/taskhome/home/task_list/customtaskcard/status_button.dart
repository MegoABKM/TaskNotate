import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

/// Class for building status buttons
class StatusButton {
  static Widget build(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
    required ScaleConfig scale,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(scale.scale(8))),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: scale.scale(8)),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
