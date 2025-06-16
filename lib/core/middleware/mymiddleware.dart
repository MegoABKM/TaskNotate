import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/app_security_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class Mymiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<StorageService>() ||
        !Get.isRegistered<AppSecurityService>()) {
      print(
          "Mymiddleware: Core services not yet registered for route: $route. Skipping.");
      return null;
    }

    final storageService = Get.find<StorageService>();
    final prefs = storageService.sharedPreferences;

    // Default to true (optimistic) if key doesn't exist, AppSecurityService will set it.
    final bool isAppEnabledCached =
        prefs.getBool(AppSecurityService.isEnabledKey) ?? true;

    print(
        "Mymiddleware: Checking route: $route, isAppEnabledCached (from prefs): $isAppEnabledCached");

    if (!isAppEnabledCached &&
        route != AppRoute.disabled &&
        route != AppRoute.splashScreen && // Allow navigating TO splash
        route != AppRoute.alarmScreen) {
      print(
          "Mymiddleware: App cached as disabled. Redirecting to ${AppRoute.disabled} from $route");
      return const RouteSettings(name: AppRoute.disabled);
    }

    print("Mymiddleware: No redirection needed for route: $route");
    return null;
  }
}
