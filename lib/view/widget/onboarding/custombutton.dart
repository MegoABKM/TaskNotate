import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/onboarding_controller.dart';
// Ensure this path is correct
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/services/sound_service.dart';

class CustombuttonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustombuttonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final soundService = Get.find<SoundService>();
    // To make text smaller, you'd pass globalPixelTextAdjustment here
    final scaleConfig = ScaleConfig(context);
    final theme = Theme.of(context);
    final localController = Get.find<LocalController>();

    return Container(
      margin: EdgeInsets.only(
        bottom: scaleConfig.scale(20), // Good
        top: scaleConfig.scale(10), // Good
      ),
      height: scaleConfig.scale(50), // Good
      width: Get.width * 0.5, // Proportional width, fine if intended
      child: Directionality(
        textDirection: localController.language.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: MaterialButton(
          padding: EdgeInsets.symmetric(
            horizontal: scaleConfig.scale(20), // Good
            vertical: scaleConfig.scale(10), // Good
          ),
          textColor: theme.colorScheme.onPrimary,
          onPressed: () async {
            await soundService.playButtonClickSound();
            controller.next();
          },
          color: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleConfig.scale(12)), // Good
          ),
          child: Text(
            "continue".tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: scaleConfig.scaleText(18), // Good
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
