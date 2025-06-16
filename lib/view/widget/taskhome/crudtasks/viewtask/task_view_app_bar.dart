import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart'; // Import ScaleConfig

class TaskViewAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String status;
  final VoidCallback? onPressed;
  final ScaleConfig scaleConfig; // <-- Accept ScaleConfig instance

  const TaskViewAppbar({
    Key? key,
    required this.status,
    this.onPressed,
    required this.scaleConfig, // <-- Required in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can now use widget.scaleConfig OR context.scaleConfig
    // Using context.scaleConfig might be slightly more consistent if you use the extension elsewhere
    final currentScaleConfig = context.scaleConfig; // Or use widget.scaleConfig
    final theme = context.appTheme;

    return AppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
        onPressed: () => Get.back(),
      ),
      actions: [
        if (status != "Completed")
          TextButton.icon(
            // Changed to TextButton for better padding/look
            onPressed: onPressed,
            icon: Icon(
              Icons.check,
              color: theme.colorScheme.onSecondary,
              size: currentScaleConfig.scale(20),
            ),
            label: Text(
              "156".tr, // "Mark as Done"
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontSize: currentScaleConfig.scaleText(15),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              padding: EdgeInsets.symmetric(
                  horizontal: currentScaleConfig.scale(12),
                  vertical: currentScaleConfig.scale(6)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(currentScaleConfig.scale(8)),
              ),
            ),
          ),
        SizedBox(width: currentScaleConfig.scale(8)),
      ],
      title: Text(
        "126".tr, // "Your Task Details"
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
          fontSize: currentScaleConfig.scaleText(20),
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      elevation: currentScaleConfig.scale(4),
      titleSpacing: 0,
    );
  }

  @override
  // Use the passed-in scaleConfig instance here
  Size get preferredSize => Size.fromHeight(scaleConfig.scale(56));
}
