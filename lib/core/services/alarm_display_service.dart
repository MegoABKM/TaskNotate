import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmDisplayStateService extends GetxService {
  static AlarmDisplayStateService get to => Get.find();

  final RxBool isAlarmScreenActive = false.obs;
  static const String prefsKeyIsAlarmScreenActive =
      'is_alarm_screen_active_flag';

  // To allow external awaiting for the async part of init to complete
  // We'll use the onReady mechanism provided by GetxService or manually manage a completer.
  // GetxService's onReady is called after onInit.
  // For this specific case, since init() itself is async and we need its SharedPreferences
  // part done before others might check the value, we'll ensure that happens.
  // The `Get.putAsync()` in bindings already handles awaiting the Future from init().

  // If you absolutely need a Future to await this specific service's async init completion
  // from outside the GetX binding flow, you could do this:
  final Completer<void> _asyncInitCompleter = Completer<void>();
  Future<void> get asyncInitializationCompleted => _asyncInitCompleter.future;

  // The `init()` method is not standard in GetxService in the same way `onInit` is.
  // `onInit` is called by GetX. If you name your method `init` and call it
  // from `Get.putAsync(() => MyService().init())`, that's fine.
  Future<AlarmDisplayStateService> initService() async {
    // Renamed to avoid confusion with GetX's internal `initialized`
    print("AlarmDisplayStateService: initService() called.");
    try {
      final prefs = await SharedPreferences.getInstance();
      isAlarmScreenActive.value =
          prefs.getBool(prefsKeyIsAlarmScreenActive) ?? false;
      print(
          "AlarmDisplayStateService: Initialized. isAlarmScreenActive from prefs: ${isAlarmScreenActive.value}");
      if (!_asyncInitCompleter.isCompleted) {
        _asyncInitCompleter.complete();
      }
    } catch (e) {
      print("AlarmDisplayStateService: Error during initService: $e");
      if (!_asyncInitCompleter.isCompleted) {
        _asyncInitCompleter
            .completeError(e); // Complete with error if something went wrong
      }
    }
    return this;
  }

  // GetX calls onInit after the instance is created by Get.put/Get.lazyPut
  // @override
  // void onInit() {
  //   super.onInit();
  //   // If you had synchronous initialization, it would go here.
  //   // For async initialization like SharedPreferences, doing it in a separate async method
  //   // called by Get.putAsync is the correct GetX pattern.
  //   print("AlarmDisplayStateService: onInit() (from GetxService lifecycle) called.");
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   // Called after onInit and when the widget that depends on it is rendered.
  //   // If _asyncInitCompleter wasn't completed in initService, ensure it is here.
  //   // (though with Get.putAsync, initService should have completed)
  //   if (!_asyncInitCompleter.isCompleted) {
  //       _asyncInitCompleter.complete();
  //   }
  //   print("AlarmDisplayStateService: onReady() (from GetxService lifecycle) called.");
  // }

  Future<void> setAlarmScreenActive(bool isActive) async {
    isAlarmScreenActive.value = isActive;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKeyIsAlarmScreenActive, isActive);
    print(
        "AlarmDisplayStateService: isAlarmScreenActive set to $isActive (RxBool and SharedPreferences)");
  }
}
