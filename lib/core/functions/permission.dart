// // core/functions/permission.dart
// import 'package:permission_handler/permission_handler.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:platform/platform.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// Future<int> _getAndroidSDKVersion() async {
//   // ... (same as before)
//   if (const LocalPlatform().isAndroid) {
//     final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
//     return androidInfo.version.sdkInt ?? 0;
//   }
//   return 0;
// }

// Future<void> _showPermissionExplanationDialog(
//     String title, String content, VoidCallback onProceed) async {
//   print("PermissionDialog: Showing dialog for '$title'");
//   try {
//     await Get.dialog(
//       AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             child: Text("Cancel".tr),
//             onPressed: () {
//               print("PermissionDialog: '$title' - Cancelled by user.");
//               Get.back();
//             },
//           ),
//           TextButton(
//             child: Text("Proceed".tr),
//             onPressed: () {
//               print("PermissionDialog: '$title' - Proceeding by user.");
//               Get.back();
//               onProceed();
//             },
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   } catch (e) {
//     print("PermissionDialog: ERROR showing Get.dialog for '$title': $e");
//   }
// }

// Future<void> requestNotificationPermission() async {
//   print("requestNotificationPermission: CALLED");
//   final int sdkVersion = await _getAndroidSDKVersion();
//   print("requestNotificationPermission: SDK Version $sdkVersion");

//   if (const LocalPlatform().isAndroid && sdkVersion >= 33) {
//     PermissionStatus status = await Permission.notification.status;
//     print('requestNotificationPermission: Initial status: $status');
//     if (!status.isGranted) {
//       await _showPermissionExplanationDialog(
//           "Stay Updated!".tr, "[Your App Name] uses notifications...",
//           () async {
//         print("requestNotificationPermission: Requesting from system...");
//         final Map<Permission, PermissionStatus> statuses =
//             await [Permission.notification].request();
//         status = statuses[Permission.notification] ?? PermissionStatus.denied;
//         print(
//             'requestNotificationPermission: Status after system request: $status');
//         if (status.isDenied || status.isPermanentlyDenied) {
//           print(
//               'requestNotificationPermission: Denied/Permanently Denied. Offering settings.');
//           // ... (snackbar logic)
//         } else if (status.isGranted) {
//           print('requestNotificationPermission: GRANTED!');
//         }
//       });
//     } else {
//       print('requestNotificationPermission: Already granted.');
//     }
//   } else {
//     print(
//         'requestNotificationPermission: Not applicable or implicitly granted for SDK $sdkVersion.');
//   }
//   print("requestNotificationPermission: FINISHED");
// }

// Future<void> requestExactAlarmPermission() async {
//   print("requestExactAlarmPermission: CALLED");
//   final int sdkVersion = await _getAndroidSDKVersion();
//   print("requestExactAlarmPermission: SDK Version $sdkVersion");

//   if (const LocalPlatform().isAndroid && sdkVersion >= 31) {
//     PermissionStatus status = await Permission.scheduleExactAlarm.status;
//     print('requestExactAlarmPermission: Initial status: $status');
//     if (!status.isGranted) {
//       await _showPermissionExplanationDialog(
//           "Enable Exact Alarms".tr, "For precise and timely reminders...",
//           () async {
//         print("requestExactAlarmPermission: Requesting from system...");
//         final Map<Permission, PermissionStatus> statuses =
//             await [Permission.scheduleExactAlarm].request();
//         status =
//             statuses[Permission.scheduleExactAlarm] ?? PermissionStatus.denied;
//         print(
//             'requestExactAlarmPermission: Status after system request: $status');
//         if (status.isDenied || status.isPermanentlyDenied) {
//           print(
//               'requestExactAlarmPermission: Denied/Permanently Denied. Offering settings.');
//           // ... (snackbar logic)
//         } else if (status.isGranted) {
//           print('requestExactAlarmPermission: GRANTED!');
//         }
//       });
//     } else {
//       print('requestExactAlarmPermission: Already granted.');
//     }
//   } else {
//     print(
//         'requestExactAlarmPermission: Not applicable as separate runtime perm for SDK $sdkVersion.');
//   }
//   print("requestExactAlarmPermission: FINISHED");
// }

// // requestBatteryOptimizationPermission can remain as is, since it's not called at startup.
// // Make sure openAppSettings() is available if needed by snackbars
// // import 'package:permission_handler/permission_handler.dart' show openAppSettings; // if you prefer explicit import