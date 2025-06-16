import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';

class Custombuttonlang extends StatelessWidget {
  final String textbutton;
  final void Function()? onPressed;

  const Custombuttonlang({super.key, required this.textbutton, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scaleConfig = ScaleConfig(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: scaleConfig.scale(100)),
      width: double.infinity,
      child: MaterialButton(
        textColor: theme.colorScheme.onPrimary,
        color: theme.colorScheme.primary,
        onPressed: onPressed,
        child: Text(
          textbutton,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
            fontSize: scaleConfig.scaleText(16),
          ),
        ),
      ),
    );
  }
}
