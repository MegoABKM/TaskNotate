import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomFloatButtonTask extends StatelessWidget {
  final void Function()? onPressed;
  const CustomFloatButtonTask({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        foregroundColor: context.appTheme.colorScheme.onSecondary,
        backgroundColor: context.appTheme.colorScheme.secondary,
        shape: const CircleBorder(),
        elevation: 4.0,
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: onPressed);
  }
}
