// In core/functions/alarm.dart

import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setAlarm(DateTime? selectedAlarm, int? lastTaskIdinreased,
    String titlecontroller) async {
  print(
      "[setAlarm] Called with: selectedAlarm: $selectedAlarm, id: $lastTaskIdinreased, title: '$titlecontroller'");

  if (selectedAlarm == null || lastTaskIdinreased == null) {
    print(
        "[setAlarm] Error: No alarm selected or last task ID is null. Aborting.");
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('alarm_${lastTaskIdinreased}_id', lastTaskIdinreased);
  await prefs.setString('alarm_${lastTaskIdinreased}_title', titlecontroller);

  final alarmSettings = AlarmSettings(
    androidFullScreenIntent: true,
    id: lastTaskIdinreased,
    dateTime: selectedAlarm,
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    notificationSettings: NotificationSettings(
      title: titlecontroller,
      body: 'key_notification_body'.tr,
      stopButton: 'key_notification_stop_button'.tr,
      icon: 'notification_icon',
    ),
  );

  try {
    print(
        "[setAlarm] Attempting to call Alarm.set() with ID: ${alarmSettings.id}, DateTime: ${alarmSettings.dateTime}");
    // For your Test Case 1 (Alarm Active, with alarm calls commented out):
    // You would manually comment out the line below and add:
    // print("SIMULATING ALARM SET");
    // bool isSet = true; // Simulate success for the test flow
    // --- Actual call ---
    bool isSet = await Alarm.set(alarmSettings: alarmSettings);
    // -------------------
    print("[setAlarm] Alarm.set() completed. Result (isSet): $isSet");

    if (isSet) {
      print("[setAlarm] Alarm successfully set for ID: ${alarmSettings.id}.");
      // The user's test log "SIMULATING ALARM SET" is handled by manually editing this for that test case.
      // For actual operation, this confirms success.

      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'key_alarm_set'.tr,
          'key_alarm_set_message'.trParams({'s': selectedAlarm.toString()}),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      print(
          "[setAlarm] Failed to set the alarm (Alarm.set returned false) for ID: ${alarmSettings.id}.");
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'key_alarm_error'.tr,
          'key_alarm_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  } catch (e, s) {
    print(
        "[setAlarm] Error during Alarm.set() for ID: ${alarmSettings.id}: $e\nStack trace: $s");
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        'key_alarm_error'.tr,
        'key_alarm_error_message'.trParams({'s': e.toString()}),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

// deactivateAlarm function remains the same as you provided
Future<void> deactivateAlarm(Map<String, String> task) async {
  print('[deactivateAlarm] called with task: $task');
  final String? alarmIdStr = task['id'];
  if (alarmIdStr != null) {
    final int alarmId = int.parse(alarmIdStr);
    print('[deactivateAlarm] Attempting to stop alarm ID: $alarmId');

    bool alarmExists = await Alarm.getAlarm(alarmId) != null;
    print(
        '[deactivateAlarm] Alarm ID $alarmId exists (is scheduled): $alarmExists');

    try {
      bool stopped = false;
      if (alarmExists) {
        stopped = await Alarm.stop(alarmId);
        print('[deactivateAlarm] Alarm.stop($alarmId) returned: $stopped');
      } else {
        print(
            '[deactivateAlarm] Alarm ID: $alarmId not found or already stopped/unscheduled.');
        stopped = true;
      }

      if (!stopped && alarmExists) {
        // Only try stopAll if specific stop failed AND it existed
        print(
            '[deactivateAlarm] Failed to stop alarm ID: $alarmId, attempting to stop all alarms as a fallback.');
        await Alarm.stopAll();
        print('[deactivateAlarm] Stopped all alarms (fallback).');
      } else if (stopped) {
        print(
            '[deactivateAlarm] Alarm ID $alarmId processed (stopped or was not active).');
      }
    } catch (e) {
      print('[deactivateAlarm] Error stopping alarm ID $alarmId: $e');
      try {
        print('[deactivateAlarm] Attempting to stop all alarms due to error.');
        await Alarm.stopAll();
        print('[deactivateAlarm] Stopped all alarms (error fallback).');
      } catch (e2) {
        print('[deactivateAlarm] Error stopping all alarms: $e2');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarm_${alarmId}_id');
    await prefs.remove('alarm_${alarmId}_title');
    // Consider removing these only if they are exclusively for a single active alarm
    // await prefs.remove('current_alarm_id');
    // await prefs.remove('is_alarm_triggered');
    print('[deactivateAlarm] Cleared SharedPreferences for alarm ID: $alarmId');

    try {
      const platform = MethodChannel('com.example.tasknotate/alarm');
      await platform.invokeMethod('stopAlarm', {'alarmId': alarmId});
      print(
          '[deactivateAlarm] Notified native layer to stop alarm ID: $alarmId');
    } catch (e) {
      print(
          '[deactivateAlarm] Error notifying native layer for stopAlarm: $e. This might be expected if not implemented.');
    }
  } else {
    print('[deactivateAlarm] Invalid task or task ID. Task: $task');
    try {
      print(
          '[deactivateAlarm] Attempting to stop all alarms due to invalid task ID.');
      await Alarm.stopAll(); // Fallback if task ID is missing
      print('[deactivateAlarm] Stopped all alarms (invalid task ID fallback).');
    } catch (e) {
      print('[deactivateAlarm] Error stopping all alarms: $e');
    }
  }
}
