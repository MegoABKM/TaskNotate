import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/onboarding_controller.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/view/widget/onboarding/custombutton.dart';
import 'package:tasknotate/view/widget/onboarding/customslider.dart';
import 'package:tasknotate/view/widget/onboarding/dotcontroller.dart';
// You might need ScaleConfig here if you scale something directly in this widget's build method
// import 'package:tasknotate/core/constant/utils/scale_config.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller only if not already present
    Get.put(OnBoardingControllerImp(), permanent: false);
    print('OnBoarding screen built');

    // If you were to scale anything directly here, you'd init ScaleConfig:
    // final scaleConfig = ScaleConfig(context, globalPixelTextAdjustment: -1.0); // Example

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              // Added const
              flex: 4,
              child: CustomSliderOnBoarding(),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomDotControllerOnBoarding(), // Added const
                  // SizedBox(height: Get.height * 0.02), // Original
                  // If you want to use ScaleConfig for consistent spacing:
                  SizedBox(
                      height: ScaleConfig(context)
                          .scale(16)), // Example: scale 16 logical pixels
                  const CustombuttonOnBoarding(), // Added const
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
