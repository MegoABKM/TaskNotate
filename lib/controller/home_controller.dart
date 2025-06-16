import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/functions/alarm.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/data/model/categorymodel.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';
import 'package:tasknotate/data/model/usertasksmodel.dart';
import 'package:tasknotate/data/datasource/local/sqldb.dart';

class HomeController extends GetxController {
  List<UserNotesModel> notedata = [];
  List<UserTasksModel> taskdata = [];
  List<CategoryModel> taskCategories = [];
  List<CategoryModel> noteCategories = [];
  RxBool forceRefreshTasks =
      false.obs; // Flag for other potential refresh scenarios
  SqlDb sqlDb = SqlDb();
  SharedPreferences myService = Get.find<StorageService>().sharedPreferences;
  String? userid;
  String? selectedSortCriterion;
  int currentIndex = 0;
  bool isTimelineView = false;
  bool isLoadingTasks = true;
  bool isLoadingNotes = true;
  Rx<int?> selectedTaskCategoryId = Rx<int?>(null);
  Rx<int?> selectedNoteCategoryId = Rx<int?>(null);
  final ScrollController scrollController = ScrollController();
  List<BottomNavigationBarItem> itemsOfScreen = [
    BottomNavigationBarItem(
        icon: const Icon(Icons.timer_outlined), label: "key_tasks".tr),
    BottomNavigationBarItem(
        icon: const Icon(Icons.note_alt),
        label: "key_notes".tr,
        activeIcon: const Icon(Icons.edit)),
    BottomNavigationBarItem(
        icon: const Icon(Icons.settings), label: "key_settings".tr),
  ];

  int get nonCompletedTaskCount =>
      taskdata.where((task) => task.status != 'Completed').length;

  void toggleTaskView(bool showTimeline) {
    isTimelineView = showTimeline;
    update(['task-view', 'sort-view', 'timeline-view']);
  }

  void onTapBottom(int value) {
    currentIndex = value;
    myService.setInt("indexhome", currentIndex);
    update();
  }

  Future<void> getTaskCategories() async {
    final List<Map<String, dynamic>> maps =
        await sqlDb.readData('SELECT * FROM categoriestasks');
    taskCategories = maps.map((map) => CategoryModel.fromMap(map)).toList();
    update(['task-category-view']);
  }

  Future<void> getNoteCategories() async {
    final List<Map<String, dynamic>> maps =
        await sqlDb.readData('SELECT * FROM categoriesnotes');
    noteCategories = maps.map((map) => CategoryModel.fromMap(map)).toList();
    update(['note-category-view']);
  }

  Future<void> addTaskCategory(String name) async {
    final response = await sqlDb.insertData(
        'INSERT INTO categoriestasks (categoryName) VALUES (?)', [name]);
    if (response > 0) {
      await getTaskCategories();
      Get.snackbar('key_success'.tr, 'key_category_added'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_add_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addNoteCategory(String name) async {
    final response = await sqlDb.insertData(
        'INSERT INTO categoriesnotes (categoryName) VALUES (?)', [name]);
    if (response > 0) {
      await getNoteCategories();
      Get.snackbar('key_success'.tr, 'key_category_added'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_add_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateTaskCategory(int? id, String name) async {
    final response = await sqlDb.updateData(
        'UPDATE categoriestasks SET categoryName = ? WHERE id = ?', [name, id]);
    if (response > 0) {
      await getTaskCategories();
      Get.snackbar('key_success'.tr, 'key_category_updated'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_update_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateNoteCategory(int? id, String name) async {
    final response = await sqlDb.updateData(
        'UPDATE categoriesnotes SET categoryName = ? WHERE id = ?', [name, id]);
    if (response > 0) {
      await getNoteCategories();
      Get.snackbar('key_success'.tr, 'key_category_updated'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_update_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteTaskCategory(int? id) async {
    if (id == null) {
      Get.snackbar('key_error'.tr, 'key_invalid_category_id'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final response = await sqlDb
        .deleteData('DELETE FROM categoriestasks WHERE id = ?', [id]);
    if (response > 0) {
      await getTaskCategories();
      if (selectedTaskCategoryId.value == id) {
        selectedTaskCategoryId.value = null;
        await getTaskData();
      }
      Get.snackbar('key_success'.tr, 'key_category_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteNoteCategory(int? id) async {
    if (id == null) {
      Get.snackbar('key_error'.tr, 'key_invalid_category_id'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final response = await sqlDb
        .deleteData('DELETE FROM categoriesnotes WHERE id = ?', [id]);
    if (response > 0) {
      await getNoteCategories();
      if (selectedNoteCategoryId.value == id) {
        selectedNoteCategoryId.value = null;
        await getNoteData();
      }
      Get.snackbar('key_success'.tr, 'key_category_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_category'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteDataNote(String id) async {
    int response =
        await sqlDb.deleteData("DELETE FROM notes WHERE id = ?", [id]);
    if (response > 0) {
      notedata.removeWhere((note) => note.id == id);
      update(['notes-view', "notes-length"]);
      Get.snackbar('key_success'.tr, 'key_note_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_note'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteDataTask(String idtask) async {
    int response =
        await sqlDb.deleteData("DELETE FROM tasks WHERE id = ?", [idtask]);
    if (response > 0) {
      taskdata.removeWhere((task) => task.id == idtask);
      await deactivateAlarm({'id': idtask});
      update(['task-view', 'timeline-view', "task-length"]);
      Get.snackbar('key_success'.tr, 'key_task_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_failed_to_delete_task'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // This method is for updating status from within HomeController (e.g., directly from home screen list)
  Future<void> updateStatus(
      String status, String id, String statustarget) async {
    print(
        "HomeController.updateStatus: Updating task $id to $statustarget from home list.");
    final double scrollOffset = scrollController.offset;
    int dbResponse = await sqlDb.updateData(
        "UPDATE tasks SET status = ? WHERE id = ?", [statustarget, id]);

    if (dbResponse > 0) {
      final index = taskdata.indexWhere((task) => task.id == id);
      if (index != -1) {
        taskdata[index] = taskdata[index].copyWith(status: statustarget);
        if (statustarget == 'Completed') {
          final soundService = Get.find<SoundService>();
          await soundService.playTaskCompletedSound();
        }
        update(['task-view', 'timeline-view', "task-length"]);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollOffset);
          }
        });
      }
    } else {
      print("HomeController.updateStatus: Failed to update task $id in DB.");
    }
  }

  Future<void> setTasksToPending(int? categoryId) async {
    String sql;
    List<Object?>? arguments;
    if (categoryId == null) {
      sql =
          'UPDATE tasks SET status = ? WHERE categoryId IS NULL AND status IN (?, ?)';
      arguments = ['Pending', 'Completed', 'In Progress'];
    } else {
      sql =
          'UPDATE tasks SET status = ? WHERE categoryId = ? AND status IN (?, ?)';
      arguments = ['Pending', categoryId, 'Completed', 'In Progress'];
    }
    final response = await sqlDb.updateData(sql, arguments);
    if (response > 0) {
      await getTaskData();
      Get.snackbar('key_success'.tr, 'key_tasks_set_pending'.tr,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('key_error'.tr, 'key_no_tasks_updated'.tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> getNoteData() async {
    isLoadingNotes = true;
    update(['notes-view']);
    List<Map<String, dynamic>> response;
    if (selectedNoteCategoryId.value == null) {
      response = await sqlDb.readData('SELECT * FROM notes');
    } else {
      response = await sqlDb.readData(
          'SELECT * FROM notes WHERE categoryId = ?',
          [selectedNoteCategoryId.value]);
    }
    notedata.clear();
    notedata.addAll(response.map((e) => UserNotesModel.fromJson(e)).toList());
    isLoadingNotes = false;
    update(['notes-view', "notes-length"]);
  }

  Future<void> getTaskData() async {
    print(
        "HomeController: getTaskData() CALLED. Filter: ${selectedTaskCategoryId.value}");
    final overallStopwatch = Stopwatch()..start();

    isLoadingTasks = true;
    update(['task-view', 'timeline-view', "task-length", 'sort-view']);

    final dbStopwatch = Stopwatch()..start();
    List<Map<String, dynamic>> response;
    if (selectedTaskCategoryId.value == null) {
      response =
          await sqlDb.readData('SELECT * FROM tasks WHERE categoryId IS NULL');
    } else {
      response = await sqlDb.readData(
          'SELECT * FROM tasks WHERE categoryId = ?',
          [selectedTaskCategoryId.value]);
    }
    dbStopwatch.stop();
    print(
        "HomeController: DB query took ${dbStopwatch.elapsedMilliseconds}ms for ${response.length} tasks.");

    final mappingStopwatch = Stopwatch()..start();
    taskdata.clear();
    taskdata.addAll(response.map((e) => UserTasksModel.fromJson(e)).toList());
    mappingStopwatch.stop();
    print(
        "HomeController: Mapping ${response.length} tasks took ${mappingStopwatch.elapsedMilliseconds}ms.");

    // Example: If you know task '6' is the one being updated.
    var taskToCheck = taskdata.firstWhereOrNull((t) => t.id == '6');
    if (taskToCheck != null) {
      print(
          "HomeController: (In getTaskData) Task '6' status after fetch: ${taskToCheck.status}");
    }

    if (selectedSortCriterion != null) {
      final sortStopwatch = Stopwatch()..start();
      sortTasks(selectedSortCriterion!);
      sortStopwatch.stop();
      print(
          "HomeController: Sorting tasks took ${sortStopwatch.elapsedMilliseconds}ms.");
    }

    isLoadingTasks = false;
    update(['task-view', 'sort-view', 'timeline-view', "task-length"]);

    overallStopwatch.stop();
    print(
        "HomeController: getTaskData() FINISHED in ${overallStopwatch.elapsedMilliseconds}ms. Updating UI.");
  }

  // Method to be called from ViewTask to directly update the in-memory list
  void updateTaskInListDirectly(String taskId, String newStatus) {
    print(
        "HomeController: updateTaskInListDirectly CALLED for taskId: $taskId, newStatus: $newStatus");
    int index = taskdata.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      taskdata[index] = taskdata[index].copyWith(status: newStatus);
      print(
          "HomeController: Task $taskId status updated to $newStatus IN MEMORY (taskdata list).");
      // This update should refresh GetBuilders listening to these IDs on the home screen
      update(['task-view', 'timeline-view', "task-length", 'sort-view']);
    } else {
      print(
          "HomeController: Task $taskId NOT FOUND in taskdata list during updateTaskInListDirectly.");
    }
  }

  Future<void> goToViewNote(UserNotesModel note) async {
    Get.toNamed(AppRoute.viewNote, arguments: {
      "note": note,
    });
  }

  Future<void> goToViewTask(UserTasksModel task, String index) async {
    Get.toNamed(AppRoute.viewTask, arguments: {
      "task": task,
      "taskindex": index,
      "taskdecodedimages": task.images != null && task.images != "Not Set"
          ? jsonDecode(task.images!)
          : {},
      "categoryname": task.category ?? "Home",
    });
  }

  void sortTasks(String criterion) {
    selectedSortCriterion = criterion;
    if (criterion == "priority") {
      const priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3, 'Not Set': 4};
      taskdata.sort((a, b) => (priorityOrder[a.priority] ?? 0)
          .compareTo(priorityOrder[b.priority] ?? 0));
    } else if (criterion == "status") {
      const statusOrder = {'In Progress': 1, 'Pending': 2, 'Completed': 3};
      taskdata.sort((a, b) =>
          (statusOrder[a.status] ?? 0).compareTo(statusOrder[b.status] ?? 0));
    } else if (criterion == "datecreated") {
      taskdata.sort((a, b) =>
          (a.date != null ? DateTime.parse(a.date!) : DateTime.now()).compareTo(
              b.date != null ? DateTime.parse(b.date!) : DateTime.now()));
    } else if (criterion == "datefinish") {
      taskdata.sort((a, b) {
        DateTime dateA = a.estimatetime != "Not Set" && a.estimatetime != null
            ? DateTime.parse(a.estimatetime!)
            : DateTime(9999);
        DateTime dateB = b.estimatetime != "Not Set" && b.estimatetime != null
            ? DateTime.parse(b.estimatetime!)
            : DateTime(9999);
        return dateA.compareTo(dateB);
      });
    } else if (criterion == "datestart") {
      taskdata.sort((a, b) {
        DateTime dateA = a.starttime != "Not Set" && a.starttime != null
            ? DateTime.parse(a.starttime!)
            : DateTime(9999);
        DateTime dateB = b.starttime != "Not Set" && b.starttime != null
            ? DateTime.parse(b.starttime!)
            : DateTime(9999);
        return dateA.compareTo(dateB);
      });
    }
    update(['task-view', 'timeline-view', 'sort-view', "task-length"]);
  }

  void filterTasksByCategory(int? categoryId) {
    selectedTaskCategoryId.value = categoryId;
    getTaskData();
  }

  void filterNotesByCategory(int? categoryId) {
    selectedNoteCategoryId.value = categoryId;
    getNoteData();
    update(['note-category-view', "notes-length"]);
  }

  @override
  void onInit() {
    super.onInit();
    print("HomeController: onInit() CALLED.");
    getTaskCategories();
    getNoteCategories();
    getNoteData();
    getTaskData(); // Initial data fetch
    currentIndex = myService.getInt("indexhome") ?? 0;
  }

  @override
  void onReady() {
    super.onReady();
    print(
        "HomeController: onReady() CALLED. forceRefreshTasks.value = ${forceRefreshTasks.value}");
    if (forceRefreshTasks.value) {
      // This flag can be used for other refresh scenarios
      print("HomeController: onReady() - Forcing DB data refresh due to flag.");
      getTaskData(); // Re-fetches from DB
      forceRefreshTasks.value = false;
    } else {
      print(
          "HomeController: onReady() - No force refresh flag set for DB reload.");
    }
  }
}
