import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyTaskMessage extends StatelessWidget {
  const EmptyTaskMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "98".tr,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}
