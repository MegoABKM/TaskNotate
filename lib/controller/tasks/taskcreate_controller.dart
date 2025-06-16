import 'dart:convert';
// import 'dart:io'; // Already in base_task_controller if needed directly
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart'; // Already in base_task_controller
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
// import 'package:tasknotate/core/functions/saveimage.dart'; // Already in base_task_controller
import 'package:tasknotate/core/functions/alarm.dart';
// import 'package:tasknotate/data/datasource/local/sqldb.dart'; // sqlDb is inherited
import 'base_task_controller.dart'; // Import the new base controller

class TaskcreateController extends BaseTaskController {
  // Extend BaseTaskController
  TextEditingController? descriptioncontroller;
  DateTime? selectedFinish;
  // DateTime? selectedAlarm; // Inherited
  DateTime? selectedStart;
  bool statusprority = false;
  bool statusfinishdate = false;
  bool statusstartdate = false;
  bool statussubtasks = false;
  bool statustimer = false;
  // bool statustimeline = false; // Inherited
  bool statuscategory = false;
  // var timelineTiles = <Map<String, dynamic>>[].obs; // Inherited
  String? prority;
  String? status;
  int? selectedCategoryId;
  // SqlDb sqlDb = SqlDb(); // Inherited
  final HomeController homeController = Get.find<HomeController>();
  Map<int, String> images = {}; // Specific to TaskcreateController
  int counter = 0; // Specific to TaskcreateController's image handling
  final List<String> priorities = ["Low", "Medium", "High"];
  final List<String> statuses = ["Pending", "In Progress", "Completed"];
  final Map<String, String> priorityTranslations = {
    "Low": "146",
    "Medium": "147",
    "High": "148",
  };
  final Map<String, String> statusTranslations = {
    "Pending": "149",
    "In Progress": "150",
    "Completed": "151",
  };
  int? lastTaskIdinreased;
  // List<TextEditingController> subtaskControllers = []; // Inherited
  // String? newsubtasksconverted; // Inherited
  String? newimagesconverted; // Specific: source map 'images'
  // Map<int, String> subtasks = {}; // Inherited

  // addtosubtasktextfield() is inherited
  // removeSubtask(int index) is inherited

  void fromMapToString(String type) {
    if (type == "subtasks") {
      convertSubtasksMapToString(); // Use helper from base
    } else {
      // Assuming "images"
      final stringKeyedMap =
          images.map((key, value) => MapEntry(key.toString(), value));
      newimagesconverted = jsonEncode(stringKeyedMap);
    }
  }

  // saveAllSubtasks() is inherited
  // addTimelineTile(...) is inherited
  // deleteTimelineTile(...) is inherited

  void switchstatusbutton(bool value, String type) {
    if (type == "prority") statusprority = value;
    if (type == "finishdate") statusfinishdate = value;
    if (type == "subtasks") statussubtasks = value;
    if (type == "timer") statustimer = value;
    if (type == "timeline") {
      super.statustimeline = value; // Use super to access inherited member
      if (!value) super.timelineTiles.clear(); // Use super
    }
    if (type == "startdate") statusstartdate = value;
    if (type == "category") statuscategory = value;
    update();
  }

  Future<void> pickDateTime(BuildContext context, String type) async {
    final DateTime? dateTime = await selectDateTime(context); // Use helper
    if (dateTime != null) {
      switch (type) {
        case "startdate":
          selectedStart = dateTime;
          break;
        case "finishdate":
          selectedFinish = dateTime;
          break;
        case "timer":
          selectedAlarm = dateTime; // selectedAlarm is inherited
          break;
      }
      update();
    }
  }

  String getFormattedDateTime(String type) {
    DateTime? dateTimeToFormat;
    String placeholderText;

    if (type == "finishdate") {
      dateTimeToFormat = selectedFinish;
      placeholderText = "key_press_to_select_finish_date".tr;
    } else if (type == "startdate") {
      dateTimeToFormat = selectedStart;
      placeholderText = "key_press_to_select_start_date".tr;
    } else {
      // Assuming "timer" (for selectedAlarm)
      dateTimeToFormat = selectedAlarm; // selectedAlarm is inherited
      placeholderText = "key_press_to_select_date_and_time".tr;
    }

    if (dateTimeToFormat == null) {
      return placeholderText;
    }
    // Use the helper from BaseTaskController
    return formatDateTimeTo12Hour(dateTimeToFormat);
  }

  // In TaskcreateController.dart

// ... (other imports and class definition) ...
// final HomeController homeController = Get.find<HomeController>(); // This is already correct

  Future<void> uploadTask() async {
    if (titlecontroller!.text.isEmpty) {
      return Get.defaultDialog(middleText: "key_add_title_to_save_task".tr);
    }
    saveAllSubtasks();
    fromMapToString("subtasks");
    fromMapToString("images");

    String timelineJson = super.statustimeline && super.timelineTiles.isNotEmpty
        ? jsonEncode(super.timelineTiles)
        : "Not Set";

    int taskResponse = await sqlDb.insertData(
      "INSERT INTO tasks (title, content, date, estimatetime, starttime, status, priority, subtask, reminder, images, timeline, categoryId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        titlecontroller!.text,
        descriptioncontroller!.text,
        DateTime.now().toIso8601String(),
        selectedFinish?.toIso8601String() ?? "Not Set",
        selectedStart?.toIso8601String() ?? "Not Set",
        status ?? "Pending",
        statusprority ? prority : "Not Set",
        statussubtasks ? newsubtasksconverted : "Not Set",
        statustimer && selectedAlarm != null
            ? selectedAlarm!.toIso8601String()
            : "Not Set",
        newimagesconverted != null && newimagesconverted!.isNotEmpty
            ? newimagesconverted
            : "Not Set",
        timelineJson,
        selectedCategoryId, // This is the categoryId you assign during task creation
      ],
    );

    if (taskResponse > 0) {
      await getLastTaskId();
      if (statustimer && selectedAlarm != null) {
        await setAlarm(
            selectedAlarm, lastTaskIdinreased, titlecontroller!.text);
      }

      // --- MODIFICATION START ---
      // Explicitly tell HomeController to refresh its task data
      // homeController is already defined in your TaskcreateController
      await homeController.getTaskData();
      // --- MODIFICATION END ---

      Get.offAllNamed(AppRoute.home);
    } else {
      Get.snackbar("key_error".tr, "key_failed_to_save_task".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
// ... (rest of TaskcreateController)

  Future<void> getLastTaskId() async {
    List<Map> response = await sqlDb
        .readData("SELECT MAX(id) AS lastId FROM tasks"); // sqlDb inherited
    lastTaskIdinreased = response.isNotEmpty && response.first['lastId'] != null
        ? response.first['lastId']
        : 1;
    update();
  }

  // Specific image handling for TaskcreateController
  void addValue(String value) {
    images[counter] = value;
    counter++;
    update();
  }

  Future<void> pickImage() async {
    String? savedPath = await pickAndSaveImage(); // Use helper from base
    if (savedPath != null) {
      addValue(savedPath); // Calls this class's addValue
      if (images.isNotEmpty) fromMapToString("images");
    }
  }

  Future<void> deleteImage(String imagePath) async {
    bool deleted = await deleteFileInternal(imagePath); // Use helper from base
    if (deleted) {
      images.removeWhere((key, value) => value == imagePath);
      update();
      // No fromMapToString("images") or DB update here, as per original logic for create
    }
  }

  Future<void> deleteAllImages() async {
    List<String> pathsToDelete = List.from(images.values);
    for (String imagePath in pathsToDelete) {
      await deleteFileInternal(imagePath); // Use helper from base
    }
    images.clear();
    update();
  }

  @override
  void onInit() {
    super.onInit(); // Call base onInit
    titlecontroller = TextEditingController(); // titlecontroller is inherited
    descriptioncontroller = TextEditingController();
    prority = priorities.first;
    status = statuses.first;
    homeController.getTaskCategories();
  }

  @override
  void onClose() {
    descriptioncontroller?.dispose();
    // titlecontroller and subtaskControllers are disposed by base class
    super.onClose(); // Call base onClose
  }
}
