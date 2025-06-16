// import 'dart:async';
// import 'dart:io';
// import 'package:alarm/alarm.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tasknotate/core/functions/alarm_screen.dart';
// import 'package:tasknotate/data/datasource/local/sqldb.dart';
// import 'package:android_intent_plus/android_intent.dart';

// class MyServices extends GetxService {
//   SqlDb sqlDb = SqlDb();
//   late SharedPreferences sharedPreferences;
//   late final SupabaseClient supabase;

//   Future<MyServices> init() async {
//     try {
//       await Alarm.init();
//       print("Alarm initialized successfully");
//       final alarms = await Alarm.getAlarms();
//       print("Current alarms: $alarms");
//     } catch (e, stackTrace) {
//       print("Error initializing Alarm: $e");
//       print("StackTrace: $stackTrace");
//     }

//     await requestNotificationPermission();
//     await requestExactAlarmPermission();
//     await requestBatteryOptimizationExemption();

//     StreamSubscription? subscription;
//     try {
//       print("Setting up Alarm.ringStream listener");
//       subscription = Alarm.ringStream.stream.listen(
//         (alarmSettings) async {
//           print("Alarm.ringStream received for ID: ${alarmSettings.id}");
//           try {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setInt('current_alarm_id', alarmSettings.id);
//             await prefs.setString('alarm_${alarmSettings.id}_title',
//                 alarmSettings.notificationSettings.title);
//             await prefs.setBool('is_alarm_triggered', true);
//             print(
//                 "Stored alarm data in SharedPreferences: ID=${alarmSettings.id}, Title=${alarmSettings.notificationSettings.title}");

//             if (Get.currentRoute != '/AlarmScreen') {
//               print("Navigating to AlarmScreen");
//               await Get.offAll(() => const AlarmScreen(),
//                   transition: Transition.noTransition);
//               print("Navigation to AlarmScreen completed");
//             }

//             Get.snackbar(
//               alarmSettings.notificationSettings.title,
//               'key_alarm_ringing'.tr,
//               snackPosition: SnackPosition.TOP,
//               duration: const Duration(seconds: 10),
//             );
//             print("Snackbar displayed");
//           } catch (e, stackTrace) {
//             print("Error handling alarm ring: $e");
//             print("StackTrace: $stackTrace");
//           }
//         },
//         onError: (error, stackTrace) {
//           print("Alarm.ringStream error: $error");
//           print("StackTrace: $stackTrace");
//         },
//         onDone: () {
//           print("Alarm.ringStream done");
//         },
//       );
//       print("Alarm.ringStream listener set up successfully");
//     } catch (e, stackTrace) {
//       print("Error setting up alarm ring listener: $e");
//       print("StackTrace: $stackTrace");
//     }

//     try {
//       sharedPreferences = await SharedPreferences.getInstance();
//     } catch (e, stackTrace) {
//       print("Error initializing SharedPreferences: $e");
//       print("StackTrace: $stackTrace");
//     }

//     try {
//       await Supabase.initialize(
//         url: 'https://kymozkcwbuflexuazgsu.supabase.co',
//         anonKey:
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5bW96a2N3YnVmbGV4dWF6Z3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMzNDc0ODksImV4cCI6MjA1ODkyMzQ4OX0.xwqhkpoKan-ZxnASfr3a2vdIKYupH5aPrtgORXZIGTM', // Replace with the correct Supabase anon key
//       );
//       supabase = Supabase.instance.client;
//       print("Supabase initialized successfully");
//     } catch (e, stackTrace) {
//       print("Error initializing Supabase: $e");
//       print("StackTrace: $stackTrace");
//     }

//     return this;
//   }

//   Future<void> requestNotificationPermission() async {
//     try {
//       final status = await Permission.notification.request();
//       if (status.isGranted) {
//         print("Notification permission granted");
//       } else if (status.isDenied) {
//         print("Notification permission denied");
//         await Permission.notification.request();
//       } else if (status.isPermanentlyDenied) {
//         print("Notification permission permanently denied");
//         await openAppSettings();
//       }
//     } catch (e, stackTrace) {
//       print("Error requesting notification permission: $e");
//       print("StackTrace: $stackTrace");
//     }
//   }

//   Future<void> requestExactAlarmPermission() async {
//     if (Platform.isAndroid) {
//       try {
//         final status = await Permission.scheduleExactAlarm.request();
//         if (status.isGranted) {
//           print("Exact alarm permission granted");
//         } else if (status.isPermanentlyDenied) {
//           print("Exact alarm permission permanently denied");
//           await openAppSettings();
//         }
//       } catch (e, stackTrace) {
//         print("Error requesting exact alarm permission: $e");
//         print("StackTrace: $stackTrace");
//       }
//     }
//   }

//   Future<void> requestBatteryOptimizationExemption() async {
//     if (Platform.isAndroid) {
//       try {
//         const intent = AndroidIntent(
//           action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
//           data: 'package:com.example.tasknotate',
//         );
//         await intent.launch();
//       } catch (e, stackTrace) {
//         print("Error requesting battery optimization exemption: $e");
//         print("StackTrace: $stackTrace");
//       }
//     }
//   }
// }
