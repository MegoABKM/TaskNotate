import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/app_bootstrap_service.dart'; // Import AppBootstrapService
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/data/datasource/static/static.dart';

abstract class OnboardingController extends GetxController {
  next();
  onPageChanged(int index);
}

class OnBoardingControllerImp extends OnboardingController {
  late PageController pageController;
  int currentpage = 0;

  @override
  Future<void> next() async {
    print('OnBoardingControllerImp: next() called, currentpage: $currentpage');
    currentpage++;
    if (currentpage > onBoardingList.length - 1) {
      print('OnBoardingControllerImp: Completing onboarding...');
      final storageService = Get.find<StorageService>();
      final prefs = storageService.sharedPreferences;

      // Set the primary onboarding completed flag
      await prefs.setBool(AppBootstrapService.onboardingCompletedKey, true);

      // Set the legacy "step" flag (can be phased out later)
      await prefs.setString("step", "1");

      // Reset the app open count for the periodic splash logic
      // This ensures the 1-in-10 count starts fresh after onboarding.
      await prefs.setInt(AppBootstrapService.appOpenCountAfterOnboardingKey, 0);

      print(
          'OnBoardingControllerImp: Onboarding completed. Set onboardingCompletedKey=true, step=1, appOpenCountAfterOnboardingKey=0.');
      Get.offAllNamed(AppRoute.home); // Navigate to home after onboarding
    } else {
      print('OnBoardingControllerImp: Animating to page: $currentpage');
      pageController.animateToPage(
        currentpage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  onPageChanged(int index) {
    print('OnBoardingControllerImp: onPageChanged called, index: $index');
    currentpage = index;
    update();
  }

  @override
  void onInit() {
    print('OnBoardingControllerImp initialized');
    pageController = PageController();
    super.onInit();
  }
}
