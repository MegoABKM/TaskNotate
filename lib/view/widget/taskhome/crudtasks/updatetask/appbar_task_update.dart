import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class AppbarTaskUpdate extends StatelessWidget {
  const AppbarTaskUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.appTheme.colorScheme.primary,
            context.appTheme.colorScheme.secondary
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleConfig.scale(16),
            vertical: context.scaleConfig.scale(8),
          ),
          child: Center(
            child: Text(
              "123".tr,
              style: AppThemes.getCommonTextTheme().titleLarge!.copyWith(
                    color: context.appTheme.colorScheme.onPrimary,
                    fontSize: context.scaleConfig.scaleText(20),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
