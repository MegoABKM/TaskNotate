import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class FloataActionButtonUpdateTask extends StatelessWidget {
  final void Function()? onPressed;

  const FloataActionButtonUpdateTask({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: context.appTheme.colorScheme.onPrimary,
      backgroundColor: context.appTheme.colorScheme.primary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16))),
      elevation: context.scaleConfig.scale(6),
      onPressed: onPressed,
      child: Icon(Icons.save, size: context.scaleConfig.scale(24)),
    );
  }
}
