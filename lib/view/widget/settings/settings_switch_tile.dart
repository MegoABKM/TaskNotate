import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Access theme and scaleConfig via context extensions
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: context.appTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: context.scaleConfig.scaleText(16),
        ),
      ),
      secondary: Icon(
        icon,
        color: context.appTheme.iconTheme.color,
        size: context.scaleConfig.scale(24),
      ),
      activeColor: context.appTheme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(12)),
      ),
    );
  }
}
