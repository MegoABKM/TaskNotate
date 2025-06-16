import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class EmptyNoteMessage extends StatelessWidget {
  const EmptyNoteMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '100'.tr,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: context.scaleConfig.scaleText(24),
            ),
      ),
    );
  }
}
