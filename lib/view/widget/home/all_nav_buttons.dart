import 'package:flutter/material.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/view/widget/home/nav_button.dart';

// ignore: must_be_immutable
class AllNavButtons extends StatelessWidget {
  HomeController controller;
  AllNavButtons({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        NavButton(
          controller: controller,
          index: 0,
          icon: Icons.timer_outlined,
          scaleConfig: context.scaleConfig,
          tooltip: 'Tasks',
        ),
        NavButton(
          controller: controller,
          index: 1,
          icon: Icons.note_alt_outlined,
          scaleConfig: context.scaleConfig,
          tooltip: 'Notes',
        ),
        NavButton(
          controller: controller,
          index: 2,
          icon: Icons.settings,
          scaleConfig: context.scaleConfig,
          tooltip: 'Settings',
        ),
      ],
    );
  }
}
