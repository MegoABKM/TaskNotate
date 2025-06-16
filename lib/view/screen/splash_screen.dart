import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/controller/splash_controller.dart';
import 'package:tasknotate/controller/theme_controller.dart'; // Make sure this is imported
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/app_bootstrap_service.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print("SplashScreen: [initState] START");
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }
    // It's important that ThemeController is initialized before this point
    // or that its default state is appropriate.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initiateNavigationSequence();
      }
    });
    print("SplashScreen: [initState] END");
  }

  Future<void> _initiateNavigationSequence() async {
    print("SplashScreen: [_initiateNavigationSequence] START");

    // ... (your existing _initiateNavigationSequence logic remains the same) ...
    // (Ensure ThemeController is ready or its persisted state is loaded before UI relies on it)

    if (!Get.isRegistered<StorageService>() ||
        !Get.isRegistered<AppSecurityService>()) {
      print(
          "SplashScreen: [_initiateNavigationSequence] ERROR: Core services not registered.");
      if (mounted) {
        Get.offAllNamed(AppRoute.disabled);
        Get.snackbar('Error'.tr,
            'Critical services unavailable. Please restart the app.'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5));
      }
      return;
    }

    final storageService = Get.find<StorageService>();
    final SharedPreferences prefs = storageService.sharedPreferences;
    final securityService = Get.find<AppSecurityService>();

    await Future.delayed(const Duration(milliseconds: 800)); // Show splash UI

    if (!mounted) {
      print(
          'SplashScreen: [_initiateNavigationSequence] Widget unmounted during delay. Aborting.');
      return;
    }

    print(
        'SplashScreen: [_initiateNavigationSequence] Forcing Supabase check for is_enabled.');
    final bool isAppNowEnabled =
        await securityService.checkAppStatus(forceSupabaseCheck: true);
    print(
        'SplashScreen: [_initiateNavigationSequence] Supabase check result: isAppNowEnabled=$isAppNowEnabled');

    if (!mounted) {
      print(
          'SplashScreen: [_initiateNavigationSequence] Widget unmounted after security check. Aborting.');
      return;
    }

    String nextRoute;
    bool wasInitialSplashProcessed =
        prefs.getBool(AppBootstrapService.initialSplashProcessedKey) ?? false;

    if (!isAppNowEnabled) {
      print(
          'SplashScreen: [_initiateNavigationSequence] App is DISABLED by Supabase.');
      nextRoute = AppRoute.disabled;
      if (!wasInitialSplashProcessed) {
        await prefs.setBool(
            AppBootstrapService.initialSplashProcessedKey, true);
        await prefs.setBool(AppBootstrapService.onboardingCompletedKey, false);
        await prefs.setInt(
            AppBootstrapService.appOpenCountAfterOnboardingKey, 0);
        print(
            'SplashScreen: [_initiateNavigationSequence] First launch (disabled): Flags set. To DisabledScreen.');
      } else {
        print(
            'SplashScreen: [_initiateNavigationSequence] Periodic splash (disabled): To DisabledScreen.');
      }
    } else {
      print(
          'SplashScreen: [_initiateNavigationSequence] App is ENABLED by Supabase.');
      bool onboardingHasBeenCompleted =
          prefs.getBool(AppBootstrapService.onboardingCompletedKey) ?? false;

      if (!wasInitialSplashProcessed) {
        await prefs.setBool(
            AppBootstrapService.initialSplashProcessedKey, true);
        await prefs.setBool(AppBootstrapService.onboardingCompletedKey, false);
        await prefs.setInt(
            AppBootstrapService.appOpenCountAfterOnboardingKey, 0);
        nextRoute = AppRoute.onBoarding;
        print(
            'SplashScreen: [_initiateNavigationSequence] First launch (enabled): Flags set. To Onboarding.');
      } else {
        if (!onboardingHasBeenCompleted) {
          nextRoute = AppRoute.onBoarding;
          print(
              'SplashScreen: [_initiateNavigationSequence] Periodic/Re-enabled (enabled): Onboarding not complete. To Onboarding.');
        } else {
          int currentOpenCount = prefs
                  .getInt(AppBootstrapService.appOpenCountAfterOnboardingKey) ??
              0;
          await prefs.setInt(AppBootstrapService.appOpenCountAfterOnboardingKey,
              currentOpenCount + 1);
          print(
              'SplashScreen: [_initiateNavigationSequence] Periodic/Re-enabled (enabled): Onboarding complete. To Home. Incremented openCount to ${currentOpenCount + 1}.');
          nextRoute = AppRoute.home;
        }
      }
    }

    print(
        "SplashScreen: [_initiateNavigationSequence] Navigating to $nextRoute");
    if (mounted) {
      Get.offAllNamed(nextRoute);
    }
    print("SplashScreen: [_initiateNavigationSequence] END");
  }

  @override
  Widget build(BuildContext context) {
    final SplashController? splashController =
        Get.isRegistered<SplashController>()
            ? Get.find<SplashController>()
            : null;

    // Get the ThemeController to determine the current theme mode
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode;

    // Define colors based on the current theme mode
    final Color backgroundColor;
    final Color textColor;
    final Color textSlightlyTransparentColor;
    final Color progressIndicatorColor;
    final String logoAssetPath;

    if (isDarkMode) {
      backgroundColor = const Color(0xFF1A1A1A); // Your dark background
      textColor = Colors.white;
      textSlightlyTransparentColor = Colors.white.withOpacity(0.85);
      progressIndicatorColor = Colors.white.withOpacity(0.7);
      logoAssetPath =
          'assets/images/logo_foreground.png'; // Assuming this logo works well on dark
    } else {
      // Use light theme colors. You might want to define these more centrally
      // in your AppThemes or use context.appTheme.
      backgroundColor =
          context.appTheme.scaffoldBackgroundColor; // Example from your theme
      textColor =
          context.appTheme.colorScheme.onSurface; // Example from your theme
      textSlightlyTransparentColor =
          context.appTheme.colorScheme.onSurface.withOpacity(0.65);
      progressIndicatorColor =
          context.appTheme.colorScheme.primary.withOpacity(0.7);
      // You MIGHT want a different logo version if your primary logo has elements
      // that don't show well on a light background, e.g., if it had white text.
      // For your current logo, logo.png should be fine.
      logoAssetPath = 'assets/images/logo_foreground.png';
    }

    if (splashController != null && !splashController.animationStarted.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            Get.isRegistered<SplashController>() &&
            !Get.find<SplashController>().isClosed) {
          Get.find<SplashController>().startAnimation();
        }
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor, // Apply dynamic background color
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor, // Apply dynamic background color
        child: splashController != null
            ? Obx(
                () => AnimatedOpacity(
                  opacity: splashController.opacity.value,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeIn,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        logoAssetPath, // Use determined logo path
                        width: context.scaleConfig.scale(200),
                        height: context.scaleConfig.scale(200),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: context.scaleConfig.scale(20)),
                      Text(
                        'TaskNotate',
                        style:
                            context.appTheme.textTheme.headlineLarge!.copyWith(
                          color: textColor, // Apply dynamic text color
                          fontSize: context.scaleConfig.scaleText(32),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: context.scaleConfig.scale(10)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.scaleConfig.scale(30)),
                        child: Text(
                          'master_your_day_tasks_notes'.tr,
                          style:
                              context.appTheme.textTheme.titleMedium!.copyWith(
                            color:
                                textSlightlyTransparentColor, // Apply dynamic text color
                            fontSize: context.scaleConfig.scaleText(16),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: context.scaleConfig.scale(30)),
                      SizedBox(
                        width: context.scaleConfig.scale(30),
                        height: context.scaleConfig.scale(30),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              progressIndicatorColor), // Apply dynamic progress color
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                // Fallback if splashController is null
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(logoAssetPath,
                        width: context.scaleConfig.scale(200),
                        height: context.scaleConfig.scale(200)),
                    SizedBox(height: context.scaleConfig.scale(30)),
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            progressIndicatorColor)),
                  ],
                ),
              ),
      ),
    );
  }
}
