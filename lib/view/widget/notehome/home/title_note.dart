import 'package:flutter/material.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class Titlenote extends StatelessWidget {
  final String titleText;

  const Titlenote(this.titleText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.scaleConfig.scale(168),
      alignment: Alignment.topCenter,
      child: Text(
        textAlign: TextAlign.center,
        titleText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: context.scaleConfig.scaleText(14),
        ),
      ),
    );
  }
}
