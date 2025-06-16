import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';

class CustomFloatButtonNote extends StatelessWidget {
  const CustomFloatButtonNote({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        Icons.edit_note,
        color: Theme.of(context).colorScheme.onPrimary,
        size: context.scaleConfig.scale(24),
      ),
      onPressed: () async {
        Get.find<SoundService>().playButtonClickSound();
        Get.toNamed(AppRoute.createNote);
      },
    );
  }
}
