import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/core/services/supabase_service.dart';
import 'package:tasknotate/core/services/app_bootstrap_service.dart'; // For key constants

class AppSecurityService extends GetxService {
  static const String isEnabledKey = 'app_is_enabled_cached_v7';
  static const String _messageKey = 'app_disable_message_cached_v7';
  // _disabledRecheckCounterKey and _disabledRecheckFrequency seem related to DisabledScreen's retry logic,
  // which is fine. We are primarily concerned with navigation here.

  SupabaseClient get _supabase => Get.find<SupabaseService>().supabase;
  SharedPreferences get prefs => Get.find<StorageService>().sharedPreferences;

  final _connectivity = Connectivity();
  bool _isCurrentlyChecking = false;

  @override
  void onInit() {
    super.onInit();
    print("AppSecurityService: [onInit] Initialized.");
  }

  Future<bool> _fetchAndUpdateFromSupabase() async {
    print(
        'AppSecurityService: [_fetchAndUpdateFromSupabase] Starting Supabase query...');
    try {
      final response = await _supabase
          .from('app_config')
          .select('is_enabled, message')
          .single()
          .timeout(
              const Duration(seconds: 3)); // Reduced timeout for faster failure

      final isEnabled = response['is_enabled'] as bool;
      final message = response['message'] as String?;
      print(
          'AppSecurityService: [_fetchAndUpdateFromSupabase] Raw response: $response');
      print(
          'AppSecurityService: [_fetchAndUpdateFromSupabase] Parsed is_enabled=$isEnabled, message=$message');

      await prefs.setBool(isEnabledKey, isEnabled);
      if (message != null) {
        await prefs.setString(_messageKey, message);
      } else {
        await prefs.remove(_messageKey);
      }

      // Removed _disabledRecheckCounterKey logic from here as it seems specific to DisabledScreen's internal retry limiting.
      // The core update of isEnabledKey is what matters for navigation.
      print(
          'AppSecurityService: [_fetchAndUpdateFromSupabase] Cached isEnabled=$isEnabled');
      return isEnabled;
    } catch (e, stackTrace) {
      print(
          'AppSecurityService: [_fetchAndUpdateFromSupabase] Error: $e\n$stackTrace');
      // Fallback to previously cached status if Supabase fails, or true if no cache yet (optimistic)
      final cachedStatus = prefs.getBool(isEnabledKey) ?? true;
      print(
          'AppSecurityService: [_fetchAndUpdateFromSupabase] Falling back to cached status: $cachedStatus');
      return cachedStatus;
    }
  }

  Future<bool> checkAppStatus({bool forceSupabaseCheck = false}) async {
    if (_isCurrentlyChecking && !forceSupabaseCheck) {
      // Allow forced check to proceed
      final cachedStatus = prefs.getBool(isEnabledKey) ?? true;
      print(
          "AppSecurityService: [checkAppStatus] Already checking (not forced). Returning cached: $cachedStatus");
      return cachedStatus;
    }
    _isCurrentlyChecking = true;
    print(
        "AppSecurityService: [checkAppStatus] STARTING. forceSupabaseCheck: $forceSupabaseCheck");

    try {
      if (!Get.isRegistered<StorageService>()) {
        print(
            "AppSecurityService: [checkAppStatus] StorageService not ready. Defaulting to true (optimistic).");
        _isCurrentlyChecking = false;
        return true;
      }

      final connectivityResult = await _connectivity.checkConnectivity();
      final isOnline = !connectivityResult.contains(ConnectivityResult.none);
      print("AppSecurityService: [checkAppStatus] Online: $isOnline");

      bool currentIsEnabledStatus;
      bool currentCachedStatus =
          prefs.getBool(isEnabledKey) ?? true; // Read current cache

      if (forceSupabaseCheck) {
        if (isOnline) {
          print(
              "AppSecurityService: [checkAppStatus] Forcing Supabase check (online).");
          currentIsEnabledStatus = await _fetchAndUpdateFromSupabase();
        } else {
          print(
              "AppSecurityService: [checkAppStatus] Forcing Supabase check (offline). Using cached: $currentCachedStatus");
          currentIsEnabledStatus =
              currentCachedStatus; // Cannot fetch, use cache
        }
      } else {
        // Not forcing, rely on cache. This path might be less common with new logic
        // but good to keep. If we are here, it means checkAppStatus was called without force
        // and app is not disabled.
        currentIsEnabledStatus = currentCachedStatus;
        print(
            "AppSecurityService: [checkAppStatus] Not forcing. Using cached status: $currentIsEnabledStatus");
      }

      print(
          "AppSecurityService: [checkAppStatus] Final isEnabled: $currentIsEnabledStatus");
      return currentIsEnabledStatus;
    } catch (e, stackTrace) {
      print("AppSecurityService: [checkAppStatus] Error: $e\n$stackTrace");
      final cachedStatusOnError =
          prefs.getBool(isEnabledKey) ?? true; // Fallback on error
      print(
          "AppSecurityService: [checkAppStatus] Returning cached status on error: $cachedStatusOnError");
      return cachedStatusOnError;
    } finally {
      _isCurrentlyChecking = false;
      print("AppSecurityService: [checkAppStatus] FINISHED.");
    }
  }

  Future<void> retryCheckAndNavigate() async {
    print("AppSecurityService: [retryCheckAndNavigate] Called.");
    if (!Get.isRegistered<SupabaseService>() ||
        !Get.isRegistered<StorageService>()) {
      print("AppSecurityService: [retryCheckAndNavigate] Services not ready.");
      return; // Cannot proceed
    }

    // Always fetch from Supabase on retry from DisabledScreen
    bool isNowEnabled = await _fetchAndUpdateFromSupabase();
    print(
        "AppSecurityService: [retryCheckAndNavigate] Supabase check result: isNowEnabled=$isNowEnabled");

    if (isNowEnabled) {
      print(
          "AppSecurityService: [retryCheckAndNavigate] App re-enabled. Determining next route.");
      // Removed _disabledRecheckCounterKey reset from here, DisabledScreen can manage its own UI state for retries.

      if (Get.currentRoute == AppRoute.disabled) {
        // Ensure we are navigating away from disabled screen
        bool onboardingCompleted =
            prefs.getBool(AppBootstrapService.onboardingCompletedKey) ?? false;

        String nextRoute =
            onboardingCompleted ? AppRoute.home : AppRoute.onBoarding;
        print(
            "AppSecurityService: [retryCheckAndNavigate] Navigating from DisabledScreen to $nextRoute (onboardingCompleted: $onboardingCompleted)");
        Get.offAllNamed(nextRoute);
      } else {
        print(
            "AppSecurityService: [retryCheckAndNavigate] App re-enabled, but not currently on DisabledScreen. No navigation needed from here.");
      }
    } else {
      print(
          "AppSecurityService: [retryCheckAndNavigate] App still disabled after check.");
      // DisabledScreen will show a message.
    }
  }

  String getDisabledMessage() {
    if (!Get.isRegistered<StorageService>()) {
      print(
          "AppSecurityService: [getDisabledMessage] StorageService not registered.");
      // SCENARIO 1: Returns a string that ends with .tr
      // This string itself is NOT YET translated by this method.
      // GetX will translate it when it's used in a Widget, e.g., Text('App is updating try again later'.tr)
      return 'App is updating try again later'.tr;
    }
    // SCENARIO 2: StorageService IS registered
    // This will return the string stored in SharedPreferences under _messageKey IF IT EXISTS.
    // OR, if that's null, it will return 'App is updating try again later'.tr
    return prefs.getString(_messageKey) ?? 'App is updating try again later'.tr;
  }
}
