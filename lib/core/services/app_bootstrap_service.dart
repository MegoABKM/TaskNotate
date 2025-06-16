import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/services/app_security_service.dart'; // For AppSecurityService.isEnabledKey

class AppBootstrapService {
  static const _platform = MethodChannel('com.example.tasknotate/alarm');

  static const String initialSplashProcessedKey = 'initial_splash_processed_v3';
  static const String onboardingCompletedKey = 'onboarding_completed_v3';
  static const String appOpenCountAfterOnboardingKey =
      'app_open_count_post_onboarding_v3';

  static Future<Map<String, dynamic>?> _getInitialAlarmDataFromNative() async {
    // ... (your existing _getInitialAlarmDataFromNative method)
    try {
      final intentData = await _platform
          .invokeMethod<Map<dynamic, dynamic>>('getInitialIntent');
      print(
          "AppBootstrapService: [getInitialAlarmDataFromNative] Received: $intentData");
      if (intentData != null &&
          intentData['action'] == 'com.example.tasknotate.ALARM_TRIGGER') {
        final alarmId = intentData['alarmId'] as int?;
        final title = intentData['title'] as String?;
        if (alarmId != null && title != null) {
          return {'id': alarmId, 'title': title};
        }
        print(
            "AppBootstrapService: [getInitialAlarmDataFromNative] Missing ID or Title: $intentData");
      }
    } catch (e) {
      print('AppBootstrapService: [getInitialAlarmDataFromNative] Error: $e');
    }
    return null;
  }

  static Future<String> determineInitialRoute(SharedPreferences prefs) async {
    print("AppBootstrapService: [determineInitialRoute] START");

    // Priority 1: Check for alarm triggered
    final Map<String, dynamic>? initialAlarmDataFromNative =
        await _getInitialAlarmDataFromNative();
    if (initialAlarmDataFromNative != null) {
      await prefs.setInt('current_alarm_id', initialAlarmDataFromNative['id']);
      await prefs.setString('alarm_${initialAlarmDataFromNative['id']}_title',
          initialAlarmDataFromNative['title']);
      await prefs.setBool(
          AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
      await prefs.setBool('is_alarm_triggered', true);
      print(
          "AppBootstrapService: [determineInitialRoute] Alarm detected (Native). Route: ${AppRoute.alarmScreen}");
      return AppRoute.alarmScreen;
    }

    bool isGlobalAlarmDisplayFlagStillSet =
        prefs.getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
            false;
    bool isPackageAlarmFlagStillSet =
        prefs.getBool('is_alarm_triggered') ?? false;

    if (isGlobalAlarmDisplayFlagStillSet || isPackageAlarmFlagStillSet) {
      final int? alarmId = prefs.getInt('current_alarm_id');
      final String? alarmTitle =
          (alarmId != null) ? prefs.getString('alarm_${alarmId}_title') : null;

      if (alarmId != null && alarmTitle != null) {
        await prefs.setBool(
            AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
        await prefs.setBool('is_alarm_triggered', true);
        print(
            "AppBootstrapService: [determineInitialRoute] Persisted alarm found. Route: ${AppRoute.alarmScreen}");
        return AppRoute.alarmScreen;
      }
      print(
          "AppBootstrapService: [determineInitialRoute] Inconsistent alarm state. Clearing stale flags.");
      await prefs.remove(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive);
      await prefs.remove('is_alarm_triggered');
      final int? lingeringAlarmId = prefs.getInt('current_alarm_id');
      if (lingeringAlarmId != null) {
        await prefs.remove('alarm_${lingeringAlarmId}_title');
        await prefs.remove('current_alarm_id');
      }
    }
    // End Alarm Check

    // Priority 2: Determine if a Splash Screen (initial or periodic) is needed.
    // SplashScreen will handle Supabase check and subsequent navigation.
    bool wasInitialSplashProcessed =
        prefs.getBool(AppBootstrapService.initialSplashProcessedKey) ?? false;
    bool onboardingHasBeenCompleted =
        prefs.getBool(AppBootstrapService.onboardingCompletedKey) ?? false;

    if (!wasInitialSplashProcessed) {
      print(
          "AppBootstrapService: [determineInitialRoute] Initial splash not yet processed. Route: ${AppRoute.splashScreen}");
      return AppRoute.splashScreen; // Must show splash for the first time.
    }

    // Initial splash has been processed. Check for periodic splash if onboarding is done.
    if (onboardingHasBeenCompleted) {
      int openCount =
          prefs.getInt(AppBootstrapService.appOpenCountAfterOnboardingKey) ?? 0;
      // If openCount is 0, it's the first launch after onboarding, no periodic splash.
      // If openCount is 9, this launch (if it were to go to Home) would be the 10th. So show splash.
      // The counter is incremented when actually navigating to Home (either from Splash or from here).
      if (openCount > 0 && (openCount % 9 == 0)) {
        // This makes the 10th, 20th etc. a splash
        print(
            "AppBootstrapService: [determineInitialRoute] Periodic splash due (Open count was $openCount). Route: ${AppRoute.splashScreen}");
        return AppRoute.splashScreen;
      }
    }

    // Priority 3: No alarm, no splash due for *this specific launch determination*.
    // Navigate based on CACHED app status and onboarding state.
    // This path is typically hit on hot restarts when it's not a periodic splash time.

    // CRITICAL: Check cached is_enabled status
    bool isAppEnabledCached = prefs.getBool(AppSecurityService.isEnabledKey) ??
        true; // Default to true if no cache (optimistic)
    print(
        "AppBootstrapService: [determineInitialRoute] Using cached is_enabled: $isAppEnabledCached");

    if (!isAppEnabledCached) {
      print(
          "AppBootstrapService: [determineInitialRoute] App cached as disabled. Route: ${AppRoute.disabled}");
      return AppRoute
          .disabled; // Go directly to disabled if cache says so. This handles hot restart to disabled.
    }

    // App is cached as enabled (or no cache yet, assuming enabled)
    if (!onboardingHasBeenCompleted) {
      print(
          "AppBootstrapService: [determineInitialRoute] Onboarding not completed. Route: ${AppRoute.onBoarding}");
      return AppRoute.onBoarding;
    }

    // App enabled (cached), onboarding completed, not a splash launch. Go to Home.
    // Increment app open count for next periodic splash check because we are going to Home.
    int currentOpenCount =
        prefs.getInt(AppBootstrapService.appOpenCountAfterOnboardingKey) ?? 0;
    await prefs.setInt(AppBootstrapService.appOpenCountAfterOnboardingKey,
        currentOpenCount + 1);
    print(
        "AppBootstrapService: [determineInitialRoute] Regular launch to Home. Incremented openCount to ${currentOpenCount + 1}. Route: ${AppRoute.home}");
    return AppRoute.home;
  }

  static void setupNativeMethodCallHandler() {
    // ... (your existing setupNativeMethodCallHandler method)
    _platform.setMethodCallHandler((call) async {
      print(
          "AppBootstrapService: [Handler] Method call '${call.method}' with arguments: ${call.arguments}");
      if (call.method == 'showAlarmScreen') {
        final alarmIdFromNative = call.arguments['alarmId'] as int?;
        final titleFromNative = call.arguments['title'] as String?;

        if (alarmIdFromNative != null && titleFromNative != null) {
          print(
              "AppBootstrapService: [Handler] showAlarmScreen ID=$alarmIdFromNative, Title='$titleFromNative'");
          final currentPrefs = await SharedPreferences.getInstance();
          await currentPrefs.setBool(
              AlarmDisplayStateService.prefsKeyIsAlarmScreenActive, true);
          await currentPrefs.setInt('current_alarm_id', alarmIdFromNative);
          await currentPrefs.setString(
              'alarm_${alarmIdFromNative}_title', titleFromNative);
          await currentPrefs.setBool('is_alarm_triggered', true);

          if (Get.isRegistered<AlarmDisplayStateService>()) {
            await Get.find<AlarmDisplayStateService>()
                .setAlarmScreenActive(true);
          }

          if (Get.currentRoute != AppRoute.alarmScreen) {
            print("AppBootstrapService: [Handler] Navigating to AlarmScreen.");
            await Get.offAllNamed(AppRoute.alarmScreen,
                arguments: {'id': alarmIdFromNative, 'title': titleFromNative});
          } else {
            print("AppBootstrapService: [Handler] Already on AlarmScreen.");
          }
        } else {
          print(
              "AppBootstrapService: [Handler] showAlarmScreen called with null ID or Title: ${call.arguments}");
        }
      } else {
        print(
            "AppBootstrapService: [Handler] Unhandled method call '${call.method}'");
      }
    });
    print("AppBootstrapService: Native method call handler setup completed.");
  }
}
