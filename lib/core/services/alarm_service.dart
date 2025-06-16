import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/services/alarm_display_service.dart';

class AlarmService extends GetxService {
  static AlarmService get to => Get.find();
  StreamSubscription<AlarmSettings>? _alarmSubscription;

  Future<AlarmService> init() async {
    print("AlarmService: init() called.");
    // Ensure AlarmDisplayStateService is ready before listening to alarms that might need its state.
    // This await can be important if AlarmService init can run before AlarmDisplayStateService.init completes.
    // However, with GetX binding order, AlarmDisplayStateService should be ready.
    // await Get.find<AlarmDisplayStateService>().initialized;

    _alarmSubscription = Alarm.ringStream.stream.listen(_handleAlarmTrigger);
    print("AlarmService: Initialized and listening to alarm ring stream.");
    // checkAndNavigateToAlarmScreenIfRinging(); // Call this from UI after build if needed.
    return this;
  }

  void _handleAlarmTrigger(AlarmSettings alarmSettings) async {
    print(
        "AlarmService (package:alarm): Received alarm trigger for ID ${alarmSettings.id}");
    final prefs = await SharedPreferences.getInstance();
    final String? taskTitle =
        prefs.getString('alarm_${alarmSettings.id}_title');

    if (taskTitle != null) {
      print(
          "AlarmService (package:alarm): Task title for alarm ${alarmSettings.id} is '$taskTitle'");

      // Set the global alarm display flag and store necessary data
      await AlarmDisplayStateService.to.setAlarmScreenActive(true);
      await prefs.setInt('current_alarm_id', alarmSettings.id);
      // Title is usually set when alarm is created, but ensure it's here for this trigger
      await prefs.setString('alarm_${alarmSettings.id}_title', taskTitle);
      await prefs.setBool(
          'is_alarm_triggered', true); // General package:alarm flag

      if (Get.currentRoute != AppRoute.alarmScreen) {
        print(
            "AlarmService: Navigating to AlarmScreen for ID ${alarmSettings.id}");
        await Get.offAllNamed(
          AppRoute.alarmScreen,
          arguments: {'id': alarmSettings.id, 'title': taskTitle},
        );
      } else {
        print(
            "AlarmService: Already on AlarmScreen. Alarm ID ${alarmSettings.id}");
      }
    } else {
      print(
          "AlarmService (package:alarm): Error - Could not find title for alarm id ${alarmSettings.id}. Cannot show AlarmScreen.");
      // If data is missing, we should not try to show an incomplete alarm screen.
      // Consider if flags should be cleared here.
      // await AlarmDisplayStateService.to.setAlarmScreenActive(false);
    }
  }

  Future<void> checkAndNavigateToAlarmScreenIfRinging() async {
    // This method is a fallback, primary handling should be via initialRoute and stream.
    final prefs = await SharedPreferences.getInstance();
    final bool isAlarmScreenMarkedActive =
        prefs.getBool(AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
            false;
    final int? currentAlarmId = prefs.getInt('current_alarm_id');

    if (isAlarmScreenMarkedActive && currentAlarmId != null) {
      print(
          "AlarmService: checkAndNavigate... - global flag true for ID $currentAlarmId.");
      final alarm = await Alarm.getAlarm(currentAlarmId);
      if (alarm != null &&
          DateTime.now()
              .isAfter(alarm.dateTime.subtract(const Duration(seconds: 10)))) {
        final String? taskTitle =
            prefs.getString('alarm_${currentAlarmId}_title');
        if (taskTitle != null && Get.currentRoute != AppRoute.alarmScreen) {
          print(
              "AlarmService: checkAndNavigate... - Found active alarm $currentAlarmId ($taskTitle), navigating.");
          await AlarmDisplayStateService.to
              .setAlarmScreenActive(true); // Re-affirm
          Get.toNamed(
            // or offAllNamed
            AppRoute.alarmScreen,
            arguments: {'id': currentAlarmId, 'title': taskTitle},
          );
        }
      } else {
        print(
            "AlarmService: checkAndNavigate... - Stale alarm flags found. Clearing them.");
        await AlarmDisplayStateService.to.setAlarmScreenActive(false);
        await prefs.remove('current_alarm_id');
        await prefs.remove('is_alarm_triggered');
      }
    }
  }

  @override
  void onClose() {
    _alarmSubscription?.cancel();
    print("AlarmService: Disposed, alarm subscription canceled.");
    super.onClose();
  }
}
