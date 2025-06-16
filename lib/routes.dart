import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/bindings/view_note_binding.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/functions/alarm_screen.dart';
import 'package:tasknotate/core/middleware/mymiddleware.dart'; // Ensure correct import
import 'package:tasknotate/core/services/alarm_display_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/view/screen/disabled_screen.dart';
import 'package:tasknotate/view/screen/home_navigator.dart';
import 'package:tasknotate/view/screen/notes/create_note.dart';
import 'package:tasknotate/view/screen/notes/view_note.dart';
import 'package:tasknotate/view/screen/onboaring.dart';
import 'package:tasknotate/view/screen/splash_screen.dart';
import 'package:tasknotate/view/screen/tasks/create_task.dart';
import 'package:tasknotate/view/screen/tasks/update_task.dart';
import 'package:tasknotate/view/screen/tasks/view_task.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: "/", // Default, often initial route before AppBootstrapService runs
    page: () => const OnBoarding(), // Or potentially SplashScreen initially
    middlewares: [Mymiddleware()],
  ),
  GetPage(
    name: AppRoute.splashScreen, // No middleware, splash has its own logic
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppRoute.home,
    page: () => const HomeNavigator(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.onBoarding,
    page: () => const OnBoarding(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.createNote,
    page: () => const CreateNoteView(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.viewNote,
    page: () => const ViewNote(),
    binding: ViewNoteBinding(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.createTask,
    page: () => CreateTask(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.viewTask,
    page: () => const ViewTask(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.updatetask,
    page: () => const UpdateTask(),
    middlewares: [Mymiddleware()], // <<-- ADDED MIDDLEWARE
  ),
  GetPage(
    name: AppRoute.disabled, // No middleware needed
    page: () => const DisabledScreen(),
  ),
  GetPage(
    name: AppRoute.alarmScreen, // No middleware needed, special handling
    page: () {
      dynamic routeArgs = Get.arguments;
      int? screenId;
      String? screenTitle;

      print("AlarmScreen GetPage: Received arguments: $routeArgs");

      if (routeArgs is Map<String, dynamic>) {
        screenId = routeArgs['id'] as int?;
        screenTitle = routeArgs['title'] as String?;
        print(
            "AlarmScreen GetPage: Extracted from Get.arguments - ID: $screenId, Title: $screenTitle");
      }

      if (screenId == null || screenTitle == null) {
        print(
            "AlarmScreen GetPage: ID/Title not in Get.arguments. Checking SharedPreferences.");
        if (Get.isRegistered<StorageService>()) {
          final storageService = Get.find<StorageService>();
          final prefs = storageService.sharedPreferences;
          final bool isAlarmScreenGloballyActive = prefs.getBool(
                  AlarmDisplayStateService.prefsKeyIsAlarmScreenActive) ??
              false;

          if (isAlarmScreenGloballyActive) {
            screenId = prefs.getInt('current_alarm_id');
            if (screenId != null) {
              screenTitle = prefs.getString('alarm_${screenId}_title');
              print(
                  "AlarmScreen GetPage: Extracted from SharedPreferences (due to global flag) - ID: $screenId, Title: $screenTitle");
            } else {
              print(
                  "AlarmScreen GetPage: 'current_alarm_id' not found in SharedPreferences despite global flag.");
            }
          } else {
            print(
                "AlarmScreen GetPage: Global alarm screen flag (${AlarmDisplayStateService.prefsKeyIsAlarmScreenActive}) is false or null. No fallback from SharedPreferences.");
          }
        } else {
          print(
              "AlarmScreen GetPage: StorageService not registered. Cannot check SharedPreferences.");
        }
      }

      if (screenId != null && screenTitle != null) {
        return AlarmScreen(id: screenId, title: screenTitle);
      } else {
        print(
            "ERROR: AlarmScreen cannot be displayed. ID or Title is missing. Navigating to home or showing error.");
        return Scaffold(
          appBar: AppBar(title: Text("Error".tr)),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "key_alarm_data_missing_error".tr,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    },
  ),
];
