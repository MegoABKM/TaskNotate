import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart'; // Assuming 'scale_confige.dart' is the correct filename
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/widget/taskhome/home/task_list/flags/flag.dart'; // Path from your original code

class FlagIconBuilder {
  final UserTasksModel task;
  final ScaleConfig scale;
  final BuildContext context;

  FlagIconBuilder({
    required this.task,
    required this.scale,
    required this.context,
  });

  List<Widget> build(double taskItemPhysicalWidth) {
    final StorageService myServices = Get.find<StorageService>();
    final String? lang = myServices.sharedPreferences.getString("lang");
    final bool isRTL = lang == "ar";

    // Define logical (unscaled) dimensions for flags and gaps.
    // FlagIcon will scale these values using `this.scale.scale()` internally for its `leftpostion`.
    const double logicalFlagWidth = 30.0;
    const double logicalFlagGap = 8.0; // A reasonable gap between flags
    const double logicalInitialEdgeOffset = 10.0; // Margin from the card's edge

    // Determine which flags are active and their icons
    // The order here defines the visual stacking order:
    // - For LTR: From right-most to left-most.
    // - For RTL: From left-most to right-most.
    final List<Map<String, dynamic>> activeFlagDefinitions = [
      if (task.subtask != "Not Set" && task.subtask != "{}")
        {'icon': FontAwesomeIcons.list, 'id': 'subtask'},
      if (task.reminder != "Not Set")
        {'icon': FontAwesomeIcons.clock, 'id': 'reminder'},
      if (task.images != "Not Set" && task.images != "{}")
        {'icon': FontAwesomeIcons.fileImage, 'id': 'image'},
    ];

    List<Widget> builtFlags = [];

    if (isRTL) {
      double currentLogicalLeft = logicalInitialEdgeOffset;
      for (var flagDef in activeFlagDefinitions) {
        builtFlags.add(
          FlagIcon(
            typeflag: "flagged",
            leftpostion: currentLogicalLeft, // Pass unscaled logical position
            iconforflag: flagDef['icon'] as IconData,
            colorflag: Colors.red, // Consider making this themable
          ),
        );
        currentLogicalLeft += logicalFlagWidth + logicalFlagGap;
      }
    } else {
      // LTR
      // For LTR, flags are positioned relative to the right edge of the task item,
      // stacking visually from right to left.
      // `taskItemPhysicalWidth` is the width in physical pixels.
      // We need the equivalent unscaled width for calculations with logical units.

      // Get the scale factor. Assuming scale.scale(1.0) returns the pure factor.
      // If scale.scale(1.0) is 0 or throws error, this needs adjustment based on ScaleConfig's implementation.
      final double scaleFactor =
          this.scale.scale(1.0) != 0 ? this.scale.scale(1.0) : 1.0;
      final double unscaledTaskItemWidth = taskItemPhysicalWidth / scaleFactor;

      for (int i = 0; i < activeFlagDefinitions.length; i++) {
        final flagDef = activeFlagDefinitions[i];

        // `i` is the index of the flag in the visual order from the "start" edge.
        // For LTR, "start" edge for flags is right. So, 0th flag is rightmost.

        // Calculate the unscaled 'left' position for this flag.
        // 1. Calculate how far the right edge of this flag is from the container's right edge:
        double logicalOffsetOfFlagRightEdgeFromContainerRight =
            logicalInitialEdgeOffset +
                (i * (logicalFlagWidth + logicalFlagGap));

        // 2. The left edge of this flag is its own width further from the right edge:
        double logicalPositionOfFlagLeftEdgeFromContainerRight =
            logicalOffsetOfFlagRightEdgeFromContainerRight + logicalFlagWidth;

        // 3. Convert this "distance from right" to "distance from left":
        double logicalLeftForThisFlag = unscaledTaskItemWidth -
            logicalPositionOfFlagLeftEdgeFromContainerRight;

        builtFlags.add(
          FlagIcon(
            typeflag: "flagged",
            leftpostion:
                logicalLeftForThisFlag, // Pass unscaled logical position
            iconforflag: flagDef['icon'] as IconData,
            colorflag: Colors.red,
          ),
        );
      }
    }
    // Each FlagIcon is already a Positioned widget.
    return builtFlags;
  }
}
