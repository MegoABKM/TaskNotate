import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart'; // Keep for Color and WidgetsBindingObserver
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();

  AppLifecycleState? _appLifecycleState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleState =
        WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
    print('Initial app lifecycle state: $_appLifecycleState');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    print('App lifecycle state changed: $state');
  }

  Future init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/notification_icon', // Your app icon
      [
        NotificationChannel(
          channelKey: 'daily_reminder_channel',
          channelName: 'notification_channel_name'.tr, // Updated
          channelDescription: 'notification_channel_description'.tr, // Updated
          importance: NotificationImportance.Max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          ledColor: const Color(0xFFFF0000), // Example color
          channelShowBadge: true,
          criticalAlerts: false, // Set to true only for very critical alerts
          icon: 'resource://drawable/notification_icon',
        ),
      ],
      debug: true, // Set to false in production
    );

    final granted =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    print('Notification permission granted: $granted');
    print('AwesomeNotifications initialized');

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod: (ReceivedNotification notification) async {
        print('Notification created: ID=${notification.id}');
      },
      onNotificationDisplayedMethod: (ReceivedNotification notification) async {
        // If app is in foreground, consider not showing or dismissing immediately
        if (_appLifecycleState == AppLifecycleState.resumed &&
            notification.id != null) {
          // Optional: Dismiss if you don't want it to persist while app is open
          await AwesomeNotifications().dismiss(notification.id!);
          print(
              'Dismissed notification ID=${notification.id} (displayed in foreground)');
          return;
        }
        print('Notification displayed: ID=${notification.id}');
      },
      onDismissActionReceivedMethod: (ReceivedAction action) async {
        print('Notification dismissed by user: ID=${action.id}');
      },
    );

    return this;
  }

  static Future onActionReceivedMethod(ReceivedAction receivedAction) async {
    print(
        'Action received: ID=${receivedAction.id}, Button Key Pressed: ${receivedAction.buttonKeyPressed}, Input: ${receivedAction.buttonKeyInput}');
    // Handle actions, e.g., navigate to a specific screen
    // if (receivedAction.buttonKeyPressed == 'view_tasks') {
    //   // Get.toNamed(AppRoute.tasksScreen); // Example
    // }
  }

  Future scheduleDailyNotifications({bool isTesting = false}) async {
    await cancelAllNotifications();

    final now = DateTime.now();
    final List<DateTime> scheduledTimes;

    if (isTesting) {
      scheduledTimes = [
        now.add(const Duration(seconds: 10)), // Morning
        now.add(const Duration(seconds: 20)), // Afternoon
        now.add(const Duration(seconds: 30)), // Evening
      ];
    } else {
      scheduledTimes = [
        DateTime(now.year, now.month, now.day, 8, 00).isBefore(now)
            ? DateTime(now.year, now.month, now.day, 8, 00)
                .add(const Duration(days: 1))
            : DateTime(now.year, now.month, now.day, 8, 00), // 8:00 AM
        DateTime(now.year, now.month, now.day, 14, 00).isBefore(now)
            ? DateTime(now.year, now.month, now.day, 14, 00)
                .add(const Duration(days: 1))
            : DateTime(now.year, now.month, now.day, 14, 00), // 2:00 PM
        DateTime(now.year, now.month, now.day, 19, 00).isBefore(now)
            ? DateTime(now.year, now.month, now.day, 19, 00)
                .add(const Duration(days: 1))
            : DateTime(now.year, now.month, now.day, 19, 00), // 7:00 PM
      ];
    }

    await _scheduleNotification(
      id: 1,
      titleKey: 'notification_morning_title', // Updated
      bodyKey: 'notification_morning_body', // Updated
      scheduledTime: scheduledTimes[0],
    );
    print('Scheduled morning notification at ${scheduledTimes[0]}');

    await _scheduleNotification(
      id: 2,
      titleKey: 'notification_afternoon_title', // Updated
      bodyKey: 'notification_afternoon_body', // Updated
      scheduledTime: scheduledTimes[1],
    );
    print('Scheduled afternoon notification at ${scheduledTimes[1]}');

    await _scheduleNotification(
      id: 3,
      titleKey: 'notification_evening_title', // Updated (was before_night)
      bodyKey: 'notification_evening_body', // Updated
      scheduledTime: scheduledTimes[2],
    );
    print('Scheduled evening notification at ${scheduledTimes[2]}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_scheduled', true);
    await prefs.setBool('is_testing_notifications', isTesting);
    print(
        'Saved notifications_scheduled: true, is_testing_notifications: $isTesting');

    final active = await AwesomeNotifications().listScheduledNotifications();
    print(
        'Active notifications: ${active.map((n) => "ID=${n.content?.id}, Title=${n.content?.title}, Schedule=${n.schedule?.toMap().toString().substring(0, 50)}...").toList()}');
  }

  Future _scheduleNotification({
    required int id,
    required String titleKey,
    required String bodyKey,
    required DateTime scheduledTime,
  }) async {
    try {
      // displayOnForeground: false means it won't pop up if app is active.
      // The onNotificationDisplayedMethod handles immediate dismissal if app is in foreground.
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'daily_reminder_channel',
            title: titleKey.tr, // Use .tr
            body: bodyKey.tr, // Use .tr
            notificationLayout: NotificationLayout.Default,
            category: NotificationCategory.Reminder,
            wakeUpScreen: true, // Wakes up screen briefly
            fullScreenIntent: false, // Avoid if not absolutely necessary
            autoDismissible: true, // User can swipe away
            icon: 'resource://drawable/notification_icon',
            displayOnForeground:
                false, // System handles if app is in foreground based on importance
            // But our onNotificationDisplayedMethod will dismiss it anyway.
          ),
          actionButtons: [
            NotificationActionButton(
                key: 'DISMISS',
                label: 'notification_action_dismiss'.tr,
                autoDismissible: true), // Updated
            NotificationActionButton(
                key: 'VIEW_TASKS',
                label: 'notification_action_view_tasks'.tr,
                autoDismissible: true), // Updated
          ],
          schedule: NotificationCalendar.fromDate(
              date: scheduledTime, allowWhileIdle: true, preciseAlarm: true));
      print(
          'Notification scheduled: ID=$id, Title=${titleKey.tr}, Time=$scheduledTime');
    } catch (e) {
      print('Error scheduling notification ID=$id: $e');
    }
  }

  Future cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_scheduled', false);
    // Consider if you want to remove is_testing_notifications or keep it
    // await prefs.remove('is_testing_notifications');
    print('Cancelled all scheduled notifications');
  }

  Future checkAndRescheduleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final isScheduled = prefs.getBool('notifications_scheduled') ?? false;
    final isTesting = prefs.getBool('is_testing_notifications') ?? false;
    print(
        'Checked notifications_scheduled: $isScheduled, is_testing_notifications: $isTesting');
    if (!isScheduled) {
      print('Notifications not scheduled or schedule lost, rescheduling...');
      await scheduleDailyNotifications(isTesting: isTesting);
    }
  }

  // This static method might be called from background isolate, be careful with GetX dependencies
  static Future rescheduleNotifications() async {
    print('Static rescheduleNotifications called at ${DateTime.now()}');
    // Re-initialize AwesomeNotifications if called from a new isolate context
    // For simplicity, assuming it's called where GetX bindings are available.
    // If called from true background (e.g. android_alarm_manager), you'd need careful setup.
    final notificationService = NotificationService(); // Get or create instance
    await notificationService.init(); // Ensure it's initialized
    await notificationService.cancelAllNotifications();
    await notificationService.scheduleDailyNotifications(
        isTesting: false); // Default to non-testing
  }
}
