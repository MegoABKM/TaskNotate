import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class ThemeSelectionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isSelected;

  const ThemeSelectionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Access theme and scaleConfig via context extensions
    return ListTile(
      leading: CircleAvatar(
        radius: context.scaleConfig.scale(20),
        backgroundColor: isSelected
            ? context.appTheme.colorScheme.secondary
            : Colors.grey[300],
        child: Icon(
          icon,
          color: isSelected ? Colors.white : iconColor,
          size: context.scaleConfig.scale(24),
        ),
      ),
      title: Text(
        title,
        style: context.appTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: context.scaleConfig.scaleText(16),
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Colors.green,
              size: context.scaleConfig.scale(24),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(12)),
      ),
      tileColor: isSelected
          ? context.appTheme.colorScheme.primary.withOpacity(0.1)
          : null,
    );
  }
}
