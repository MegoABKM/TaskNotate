import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomPickDateAndTimeUpdate extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomPickDateAndTimeUpdate({
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleConfig.scale(12),
          vertical: context.scaleConfig.scale(12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.appTheme.colorScheme.primary),
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(10)),
          color: context.appTheme.colorScheme.primary.withOpacity(0.1),
        ),
        child: Text(
          text,
          style: AppThemes.getCommonTextTheme().bodyLarge!.copyWith(
                color: context.appTheme.colorScheme.onSurface,
                fontSize: context.scaleConfig.scaleText(16),
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
