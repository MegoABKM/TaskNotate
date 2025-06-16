import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomFloatActionButtonView extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomFloatActionButtonView({Key? key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: context.appTheme.colorScheme.onSecondary,
      backgroundColor: context.appTheme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleConfig.scale(16))),
      elevation: context.scaleConfig.scale(6),
      onPressed: onPressed,
      child: Icon(Icons.edit, size: context.scaleConfig.scale(24)),
    );
  }
}
