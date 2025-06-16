import 'dart:convert';
// import 'dart:io'; // From base
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart'; // From base
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/controller/tasks/taskviewcontroller.dart';
import 'package:tasknotate/core/constant/routes.dart'; // Ensure AppRoute is imported
import 'package:tasknotate/core/functions/alarm.dart';
// import 'package:tasknotate/core/functions/saveimage.dart'; // From base
// import 'package:tasknotate/data/datasource/local/sqldb.dart'; // Inherited
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'base_task_controller.dart'; // Import base

class TaskUpdatecontroller extends BaseTaskController {
  UserTasksModel? task;
  String? index;
  DateTime? selectedDate; // Finish date for update
  DateTime? selectedStartDate; // Start date for update
  Map<String, dynamic>? decodedsubtask;
  TextEditingController? contentcontroller;
  final List<String> statuses = ["Pending", "In Progress", "Completed"];
  final List<String> priorities = ["Not Set", "Low", "Medium", "High"];
  bool statusprority = false;
  bool statusdateandtime = false;
  bool statusstartDate = false;
  bool statussubtasks = false;
  bool statusreminder = false;
  Map<String, String> decodedImages = {};
  String? newimagesconverted;
  int? selectedCategoryId;
  List<CategoryModel> categories = [];
  HomeController homeController = Get.find<HomeController>();

  String getTranslatedPriority(String priority) {
    switch (priority) {
      case "Not Set":
        return "166".tr; // Assuming this is an existing, unrelated key
      case "Low":
        return "160".tr; // Assuming this is an existing, unrelated key
      case "Medium":
        return "161".tr; // Assuming this is an existing, unrelated key
      case "High":
        return "162".tr; // Assuming this is an existing, unrelated key
      default:
        return priority;
    }
  }

  String getTranslatedStatus(String status) {
    switch (status) {
      case "Pending":
        return "163".tr; // Assuming this is an existing, unrelated key
      case "In Progress":
        return "164".tr; // Assuming this is an existing, unrelated key
      case "Completed":
        return "165".tr; // Assuming this is an existing, unrelated key
      default:
        return status;
    }
  }

  void decodeTimeline() {
    if (task?.timeline != null && task!.timeline != "Not Set") {
      try {
        super.timelineTiles.value =
            List<Map<String, dynamic>>.from(jsonDecode(task!.timeline!));
        super
            .timelineTiles
            .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
        super.statustimeline = true;
      } catch (e) {
        print("Error decoding timeline: $e");
        super.timelineTiles.value = [];
        super.statustimeline = false;
      }
    } else {
      super.timelineTiles.value = [];
      super.statustimeline = false;
    }
  }

  void toggleTimeline() {
    super.statustimeline = !super.statustimeline;
    if (!super.statustimeline) super.timelineTiles.clear();
    update();
  }

  void fromMapToString(String type) {
    if (type == "subtasks") {
      convertSubtasksMapToString();
    } else {
      final stringKeyedMap =
          decodedImages.map((key, value) => MapEntry(key.toString(), value));
      newimagesconverted = jsonEncode(stringKeyedMap);
    }
  }

  Future<void> deactivateAlarm() async {
    if (task?.id != null) {
      await Alarm.stop(int.parse(task!.id!));
    }
  }

  Future<void> pickDateTime(BuildContext context, String type) async {
    final DateTime? dateTime = await selectDateTime(context);
    if (dateTime != null) {
      switch (type) {
        case "alarm":
          selectedAlarm = dateTime;
          break;
        case "startdate":
          selectedStartDate = dateTime;
          break;
        case "dateandtime":
          selectedDate = dateTime;
          break;
      }
      update();
    }
  }

  void switchstatusbutton(bool value, String type) {
    switch (type) {
      case "priority":
        statusprority = value;
        if (!value) task = task!.copyWith(priority: "Not Set");
        break;
      case "dateandtime":
        statusdateandtime = value;
        if (!value) selectedDate = null;
        break;
      case "startdate":
        statusstartDate = value;
        if (!value) selectedStartDate = null;
        break;
      case "subtasks":
        statussubtasks = value;
        if (!value) {
          for (var controller in super.subtaskControllers) controller.dispose();
          super.subtaskControllers.clear();
          super.subtasks.clear();
        }
        break;
      case "reminder":
        statusreminder = value;
        if (!value) selectedAlarm = null;
        break;
      case "timeline":
        super.statustimeline = value;
        if (!value) super.timelineTiles.clear();
        break;
    }
    update();
  }

  void assigndateifnotset() {
    if (task?.estimatetime != null && task?.estimatetime != "Not Set") {
      selectedDate = DateTime.parse(task!.estimatetime!);
      statusdateandtime = true;
    }
    if (task?.reminder != null && task?.reminder != "Not Set") {
      selectedAlarm = DateTime.parse(task!.reminder!);
      statusreminder = true;
    }
    if (task?.starttime != null && task?.starttime != "Not Set") {
      selectedStartDate = DateTime.parse(task!.starttime!);
      statusstartDate = true;
    }
  }

  Future<void> updatetaskafteredit() async {
    print("TaskUpdateController: updatetaskafteredit called.");
    if (super.titlecontroller == null ||
        super.titlecontroller!.text.trim().isEmpty) {
      Get.snackbar("key_error".tr, "key_title_cannot_empty".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (statusreminder && selectedAlarm == null) {
      Get.snackbar("key_error".tr, "key_set_reminder_or_disable".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (statusdateandtime && selectedDate == null) {
      Get.snackbar("key_error".tr, "key_set_finish_date_or_disable".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    saveAllSubtasks();
    if (super.subtasks.isNotEmpty && statussubtasks) {
      fromMapToString("subtasks");
    } else {
      newsubtasksconverted = "Not Set";
    }

    if (decodedImages.isNotEmpty) {
      fromMapToString("images");
    } else {
      newimagesconverted = "Not Set";
    }

    String timelineJson = super.statustimeline && super.timelineTiles.isNotEmpty
        ? jsonEncode(super.timelineTiles)
        : "Not Set";

    print(
        "TaskUpdateController: Preparing to update task in DB. Task ID: ${task?.id}");
    int response = await sqlDb.updateData(
      "UPDATE tasks SET title = ?, content = ?, estimatetime = ?, starttime = ?, reminder = ?, status = ?, priority = ?, subtask = ?, images = ?, timeline = ?, categoryId = ? WHERE id = ?",
      [
        titlecontroller!.text.trim(),
        contentcontroller!.text.isNotEmpty
            ? contentcontroller!.text.trim()
            : "Not Set",
        statusdateandtime && selectedDate != null
            ? selectedDate!.toIso8601String()
            : "Not Set",
        statusstartDate && selectedStartDate != null
            ? selectedStartDate!.toIso8601String()
            : "Not Set",
        statusreminder && selectedAlarm != null
            ? selectedAlarm!.toIso8601String()
            : "Not Set",
        task?.status,
        statusprority && task?.priority != null ? task?.priority : "Not Set",
        statussubtasks && super.subtasks.isNotEmpty
            ? newsubtasksconverted
            : "Not Set",
        decodedImages.isNotEmpty ? newimagesconverted : "Not Set",
        timelineJson,
        selectedCategoryId,
        task?.id,
      ],
    );

    if (response > 0) {
      print(
          "TaskUpdateController: DB update successful for task ${task?.id}. Response: $response");

      // --- ALARM LOGIC ---
      if (!statusreminder) {
        // If reminder was switched off or was already off
        if (task != null && task!.id != null) {
          print(
              "TaskUpdateController: Reminder is OFF. Attempting to deactivate alarm for task ID ${task!.id!}.");
          // Pass task details as a Map<String, String> as expected by deactivateAlarm
          await deactivateAlarm();
          print(
              "TaskUpdateController: deactivateAlarm call completed for task ID ${task!.id!}.");
        } else {
          print(
              "TaskUpdateController: Reminder is OFF, but task or task ID is null. Skipping deactivation.");
        }
      } else if (statusreminder &&
          selectedAlarm != null &&
          task != null &&
          task!.id != null &&
          task!.title != null) {
        // If reminder is ON and details are available
        print(
            "TaskUpdateController: Reminder is ON. Attempting to set/update alarm for task ID ${task!.id!}.");
        await setAlarm(selectedAlarm!, int.parse(task!.id!), task!.title!);
        // Logs from setAlarm ("ALARM SET SUCCESSFULLY..." or "SIMULATING ALARM SET" or errors) will appear here.
        print(
            "TaskUpdateController: setAlarm call completed for task ID ${task!.id!}.");
      }
      // --- END ALARM LOGIC ---

      print("TaskUpdateController: Attempting homeController.getTaskData().");
      await homeController.getTaskData();
      print("TaskUpdateController: homeController.getTaskData() completed.");

      // --- NAVIGATION LOGIC ---
      print("TaskUpdateController: Preparing for navigation.");
      try {
        // CRITICAL: Close any open snackbars/overlays before navigating
        if (Get.isSnackbarOpen) {
          print(
              "TaskUpdateController: Snackbar is open. Closing all snackbars.");
          Get.closeAllSnackbars(); // Close any snackbars shown by setAlarm or other operations
          // Wait for snackbar animations to finish. This can be crucial.
          await Future.delayed(
              const Duration(milliseconds: 250)); // Adjust if needed
          print(
              "TaskUpdateController: Delay after closing snackbars completed.");
        } else {
          print("TaskUpdateController: No snackbar was open.");
        }

        if (Get.isRegistered<Taskviewcontroller>() &&
            task != null &&
            task!.id != null) {
          final viewController = Get.find<Taskviewcontroller>();
          print(
              "TaskUpdateController: Taskviewcontroller is registered. Attempting to refresh task ${task!.id!} in TaskViewcontroller.");
          await viewController.refreshTask(task!.id!);
          print(
              "TaskUpdateController: TaskViewcontroller.refreshTask completed for ${task!.id!}.");

          print(
              "TaskUpdateController: Attempting Get.back() to navigate to TaskView.");
          Get.back();
          // This log might not show if Get.back() is successful and the current controller is disposed
          print("TaskUpdateController: Get.back() called.");
        } else {
          print(
              "TaskUpdateController: Taskviewcontroller not registered or task ID is null. Navigating to Home (AppRoute.home).");
          Get.offAllNamed(AppRoute.home);
          print("TaskUpdateController: Get.offAllNamed(AppRoute.home) called.");
        }
      } catch (e, s) {
        print(
            "TaskUpdateController: Error during post-update navigation/refresh: $e\nStack trace: $s");
        Get.snackbar("key_error".tr, "key_failed_refresh_task_view".tr,
            snackPosition: SnackPosition.BOTTOM);
        // Fallback navigation even on error
        if (Get.isRegistered<Taskviewcontroller>()) {
          print(
              "TaskUpdateController: Error fallback: Navigating back using Get.back().");
          Get.back();
        } else {
          print(
              "TaskUpdateController: Error fallback: Navigating to Home (AppRoute.home).");
          Get.offAllNamed(AppRoute.home);
        }
      }
      // --- END NAVIGATION LOGIC ---
    } else {
      print(
          "TaskUpdateController: Failed to update task ${task?.id} in DB. Response: $response");
      Get.snackbar("key_error".tr, "key_failed_to_update_task".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteImage(String imagePath) async {
    bool deleted = await deleteFileInternal(imagePath);
    if (deleted) {
      final newImages = Map<String, String>.from(decodedImages);
      newImages.removeWhere((key, value) => value == imagePath);
      decodedImages = newImages;

      if (decodedImages.isNotEmpty) {
        fromMapToString("images");
        await sqlDb.updateData(
          "UPDATE tasks SET images = ? WHERE id = ?",
          [newimagesconverted, task!.id],
        );
      } else {
        await sqlDb.updateData(
          "UPDATE tasks SET images = ? WHERE id = ?",
          ["Not Set", task!.id],
        );
      }
      update();
      print("TaskUpdateController: Image deleted and DB updated.");
    }
  }

  void addValue(String value) {
    final newImages = Map<String, String>.from(decodedImages);
    String newKey = DateTime.now().millisecondsSinceEpoch.toString();
    while (newImages.containsKey(newKey)) {
      newKey = (DateTime.now().millisecondsSinceEpoch + UniqueKey().hashCode)
          .toString();
    }
    newImages[newKey] = value;
    decodedImages = newImages;
    update();
    print("TaskUpdateController: Image added to decodedImages. Path: $value");
  }

  Future<void> pickImage() async {
    String? savedPath = await pickAndSaveImage();
    if (savedPath != null) {
      addValue(savedPath);
    }
  }

  Future<void> fetchCategories() async {
    if (homeController.taskCategories.isNotEmpty) {
      categories = homeController.taskCategories;
    } else {
      await homeController.getTaskCategories();
      categories = homeController.taskCategories;
    }
    if (task?.category != null &&
        task!.category != "Home" &&
        task!.category!.isNotEmpty) {
      try {
        selectedCategoryId = int.tryParse(task!.category!);
        if (!categories.any((cat) => cat.id == selectedCategoryId)) {
          print(
              "Warning: Task's category ID ${task!.category!} not found in fetched categories. Resetting.");
          selectedCategoryId = null;
        }
      } catch (e) {
        print("Error parsing task category ID: ${task!.category} - $e");
        selectedCategoryId = null;
      }
    } else {
      selectedCategoryId = null;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) {
      Get.snackbar("key_error".tr,
          "key_task_data_missing".tr); // Add this key: "Task data missing."
      Get.back();
      return;
    }

    task = arguments['task'] as UserTasksModel?;
    if (task == null) {
      Get.snackbar("key_error".tr,
          "key_task_model_null".tr); // Add this key: "Task model is null."
      Get.back();
      return;
    }
    index = arguments['taskindex'] as String?;

    var imagesFromArgs = arguments['taskdecodedimages'];
    if (imagesFromArgs is Map<String, String>) {
      decodedImages = Map<String, String>.from(imagesFromArgs);
    } else if (imagesFromArgs is Map) {
      decodedImages = imagesFromArgs
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    } else {
      decodedImages = {};
    }

    contentcontroller = TextEditingController(text: task?.content ?? "");
    titlecontroller = TextEditingController(text: task?.title ?? "");

    assigndateifnotset();
    statusprority = task?.priority != null && task?.priority != "Not Set";

    if (task?.subtask != null &&
        task?.subtask != "Not Set" &&
        task!.subtask!.trim().isNotEmpty) {
      statussubtasks = true;
      try {
        decodedsubtask = jsonDecode(task!.subtask!);
        if (decodedsubtask is Map) {
          var sortedKeys = decodedsubtask!.keys.toList()
            ..sort((a, b) {
              int? valA = int.tryParse(a);
              int? valB = int.tryParse(b);
              if (valA != null && valB != null) return valA.compareTo(valB);
              return a.compareTo(b);
            });
          for (var key in sortedKeys) {
            super.subtaskControllers.add(TextEditingController(
                text: decodedsubtask![key] as String? ?? ''));
          }
        } else {
          statussubtasks = false;
        }
      } catch (e) {
        print("Error decoding subtasks in onInit: $e");
        statussubtasks = false;
      }
    } else {
      statussubtasks = false;
    }

    decodeTimeline();
    fetchCategories();
    update();
  }

  @override
  void onClose() {
    contentcontroller?.dispose();
    super.onClose();
  }
}
