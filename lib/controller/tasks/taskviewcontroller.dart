import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/base_task_controller.dart';
import 'package:tasknotate/core/functions/alarm.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/view/screen/tasks/update_task.dart';

class Taskviewcontroller extends BaseTaskController {
  UserTasksModel? task;
  String? index;
  Map<String, dynamic>? decodedsubtask;
  Map<String, String> decodedImages = {};
  List<Map<String, dynamic>> decodedTimeline = [];
  String? categoryName;

  void decodethemap() {
    if (task?.subtask != null && task?.subtask != "Not Set") {
      decodedsubtask = jsonDecode(task!.subtask!);
    }
  }

  void decodeImages() {
    if (task?.images != null && task?.images != "Not Set") {
      decodedImages = Map<String, String>.from(jsonDecode(task!.images!));
    }
  }

  void decodeTimeline() {
    if (task?.timeline != null && task?.timeline != "Not Set") {
      decodedTimeline =
          List<Map<String, dynamic>>.from(jsonDecode(task!.timeline!));
      decodedTimeline
          .sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
    }
  }

  Future<String?> fromIdToName(String? categoryid) async {
    if (categoryid == null || categoryid.isEmpty || categoryid == "Home") {
      return "key_home".tr;
    }
    int? parsedCategoryId = int.tryParse(categoryid);
    if (parsedCategoryId == null) {
      return "key_home".tr;
    }
    List<Map<String, dynamic>> response = await sqlDb.readData(
      "SELECT categoryName FROM categoriestasks WHERE id = ?",
      [parsedCategoryId],
    );
    return response.isNotEmpty && response[0]['categoryName'] != null
        ? response[0]['categoryName'] as String
        : "key_home".tr;
  }

  Future<void> updateStatus(
      String currentStatus, String? taskId, String targetStatus) async {
    if (taskId == null || taskId.isEmpty) {
      print(
          "Taskviewcontroller Error: Task ID is null or empty. Cannot update status.");
      Get.snackbar("key_error".tr, "Invalid Task ID for status update.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    print(
        "Taskviewcontroller: Attempting to update task '$taskId' to status '$targetStatus'");
    int response = await sqlDb.updateData(
      // This await is crucial and correct
      "UPDATE tasks SET status = ? WHERE id = ?",
      [targetStatus, taskId],
    );
    print(
        "Taskviewcontroller: DB update response for task '$taskId': $response");

    if (response > 0) {
      if (task != null && task!.id == taskId) {
        task = task!.copyWith(status: targetStatus);
        print(
            "Taskviewcontroller: Local task model updated to status '$targetStatus' for task '$taskId'");
      } else {
        print(
            "Taskviewcontroller: Warning - local 'task' instance might not match updated taskId ('$taskId') or is null.");
      }

      if (targetStatus == "Completed") {
        final soundService = Get.find<SoundService>();
        // --- MODIFICATION START ---
        // Remove 'await' to make sound playback non-blocking.
        // The sound will start playing, and the code will continue executing.
        soundService.playTaskCompletedSound();
        print(
            "Taskviewcontroller: Completion sound playback INITIATED for task '$taskId'."); // Changed log message
        // --- MODIFICATION END ---
      }
      update(); // Updates the UI of Taskviewcontroller (though this screen is about to be dismissed)
    } else {
      print(
          "Taskviewcontroller: Failed to update status in DB for task '$taskId'.");
      Get.snackbar("key_error".tr, "key_failed_to_update_status".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? dateTime = await selectDateTime(context);
    if (dateTime != null) {
      selectedAlarm = dateTime;
      if (task != null && task!.id != null && task!.title != null) {
        await setAlarm(selectedAlarm, int.parse(task!.id!), task!.title!);
        await updateReminder();
      }
      update();
    }
  }

  Future<void> updateReminder() async {
    String reminderValue =
        selectedAlarm != null ? selectedAlarm!.toIso8601String() : "Not Set";
    int response = await sqlDb.updateData(
      "UPDATE tasks SET reminder = ? WHERE id = ?",
      [reminderValue, task!.id],
    );
    if (response > 0) task = task!.copyWith(reminder: reminderValue);
    update();
  }

  Future<void> removeReminder() async {
    if (task == null || task!.id == null) {
      Get.snackbar("key_error".tr, "key_no_task_selected".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    await deactivateAlarm({'id': task!.id.toString()});
    int response = await sqlDb.updateData(
      "UPDATE tasks SET reminder = ? WHERE id = ?",
      ["Not Set", task!.id],
    );
    if (response > 0) {
      task = task!.copyWith(reminder: "Not Set");
      selectedAlarm = null;
      update();
    } else {
      Get.snackbar("key_error".tr, "key_failed_to_remove_reminder".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> refreshTask(String taskId) async {
    List<Map<String, dynamic>> response = await sqlDb.readData(
      "SELECT * FROM tasks WHERE id = ?",
      [taskId],
    );
    if (response.isNotEmpty) {
      task = UserTasksModel.fromJson(response.first);
      decodethemap();
      decodeImages();
      decodeTimeline();
      categoryName = await fromIdToName(task?.category);
      if (task?.reminder != null && task?.reminder != "Not Set") {
        selectedAlarm = DateTime.parse(task!.reminder!);
      } else {
        selectedAlarm = null;
      }
      update();
    } else {
      Get.snackbar("key_error".tr, "key_task_not_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
    }
  }

  void goToUpdateTask() {
    if (task == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.to(
      const UpdateTask(),
      transition: Transition.noTransition,
      arguments: {
        "task": task,
        "taskindex": index,
        "taskdecodedimages": decodedImages,
        "categoryname": categoryName,
      },
    );
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args == null || args['task'] == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      return;
    }
    task = args['task'] as UserTasksModel?;
    index = args['taskindex']?.toString();

    if (task == null) {
      Get.snackbar("key_error".tr, "key_no_task_found".tr,
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
      return;
    }

    if (task?.reminder != null && task?.reminder != "Not Set") {
      selectedAlarm = DateTime.parse(task!.reminder!);
    }
    decodethemap();
    decodeImages();
    decodeTimeline();
    categoryName = await fromIdToName(task?.category);
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
