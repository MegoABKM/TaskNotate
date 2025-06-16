import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/onboarding_controller.dart';
// Ensure this path is correct
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/data/datasource/static/static.dart';

class CustomDotControllerOnBoarding extends StatelessWidget {
  const CustomDotControllerOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    // To make text smaller, you'd pass globalPixelTextAdjustment here
    // (though no text is directly scaled here, its container sizes are)
    final scaleConfig = ScaleConfig(context);
    final theme = Theme.of(context);

    return GetBuilder<OnBoardingControllerImp>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onBoardingList.length,
            (index) => AnimatedContainer(
              margin: EdgeInsets.only(right: scaleConfig.scale(8)), // Good
              duration: const Duration(milliseconds: 300),
              width: controller.currentpage == index
                  ? scaleConfig.scale(20) // Good
                  : scaleConfig.scale(8), // Good
              height: scaleConfig.scale(8), // Good
              decoration: BoxDecoration(
                color: controller.currentpage == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                borderRadius:
                    BorderRadius.circular(scaleConfig.scale(12)), // Good
              ),
            ),
          ),
        ],
      ),
    );
  }
}
