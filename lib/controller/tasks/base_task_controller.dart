// lib/controller/base_task_controller.dart (or your preferred path)
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tasknotate/core/functions/saveimage.dart'; // Ensure this path is correct
import 'package:tasknotate/data/datasource/local/sqldb.dart';

abstract class BaseTaskController extends GetxController {
  SqlDb sqlDb = SqlDb();
  TextEditingController? titlecontroller;
  DateTime? selectedAlarm; // Common for alarm/reminder functionality

  // --- Attributes primarily for Task Create/Update ---
  List<TextEditingController> subtaskControllers = [];
  Map<int, String> subtasks = {};
  String? newsubtasksconverted;
  var timelineTiles = <Map<String, dynamic>>[].obs;
  bool statustimeline = false; // Related to timelineTiles display

  // --- Protected Helper Methods ---

  String formatDateTimeTo12Hour(DateTime? dateTime,
      {String defaultText = "Not Set"}) {
    if (dateTime == null) return defaultText;
    // Example: "2023-10-27 at 3:45 PM"
    // Adjust 'yyyy-MM-dd \'at\' h:mm a' to your desired format string
    // 'h' for 1-12 hour, 'hh' for 01-12 hour
    // 'a' for AM/PM marker
    return DateFormat('yyyy-MM-dd \'at\' h:mm a').format(dateTime.toLocal());
  }

  // Helper for picking date and time
  Future<DateTime?> selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return null;

    // Validate that the selected time is not in the past if the date is today
    if (pickedDate.year == now.year &&
        pickedDate.month == now.month &&
        pickedDate.day == now.day) {
      if (pickedTime.hour < now.hour ||
          (pickedTime.hour == now.hour && pickedTime.minute < now.minute)) {
        Get.snackbar("key_invalid_time".tr, "key_cannot_select_past_time".tr,
            snackPosition: SnackPosition.BOTTOM);
        return null;
      }
    }
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  // Helper for picking an image from gallery and saving it
  Future<String?> pickAndSaveImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Assuming saveImageToFileSystem takes an XFile object
      return await saveImageToFileSystem(pickedFile);
    }
    return null;
  }

  // Helper for deleting a file from the filesystem
  Future<bool> deleteFileInternal(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      try {
        await file.delete();
        return true;
      } catch (e) {
        // Handle error, e.g., log it
        print("Error deleting file: $e");
        return false;
      }
    }
    return false; // File doesn't exist
  }

  // Helper to convert the 'subtasks' map to a JSON string
  void convertSubtasksMapToString() {
    final stringKeyedMap =
        subtasks.map((key, value) => MapEntry(key.toString(), value));
    newsubtasksconverted = jsonEncode(stringKeyedMap);
  }

  // --- Common Methods primarily for Task Create/Update ---

  void addtosubtasktextfield() {
    subtaskControllers.add(TextEditingController());
    update();
  }

  void removeSubtask(int index) {
    if (index >= 0 && index < subtaskControllers.length) {
      subtaskControllers[index].dispose();
      subtaskControllers.removeAt(index);
      update();
    }
  }

  void saveAllSubtasks() {
    subtasks.clear();
    for (int i = 0; i < subtaskControllers.length; i++) {
      final text = subtaskControllers[i].text.trim();
      if (text.isNotEmpty) {
        subtasks[i] = text;
      }
    }
    update();
  }

  void addTimelineTile(String title, DateTime time, {int? index}) {
    if (title.isEmpty) return;
    if (index != null) {
      int tileIndex =
          timelineTiles.indexWhere((tile) => tile['index'] == index);
      if (tileIndex != -1) {
        timelineTiles[tileIndex] = {
          'index': index,
          'title': title,
          'time': time.toIso8601String(),
        };
      }
    } else {
      int newIndex = timelineTiles.isEmpty
          ? 1
          : timelineTiles
                  .map((tile) => tile['index'] as int)
                  .reduce((a, b) => a > b ? a : b) +
              1;
      timelineTiles.add({
        'index': newIndex,
        'title': title,
        'time': time.toIso8601String(),
      });
    }
    timelineTiles
        .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    timelineTiles.refresh();
    update();
  }

  void deleteTimelineTile(int index) {
    timelineTiles.removeWhere((tile) => tile['index'] == index);
    timelineTiles
        .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    timelineTiles.refresh();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // titlecontroller is initialized in subclasses as logic varies
    // other specific initializations also happen in subclasses
  }

  @override
  void onClose() {
    titlecontroller?.dispose();
    for (var controller in subtaskControllers) {
      controller.dispose();
    }
    subtaskControllers.clear();
    super.onClose();
  }
}
