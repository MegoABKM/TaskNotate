// import 'package:get/get.dart';
// import 'package:tasknotate/controller/tasks/attributestask/subtask_manager.dart';
// import 'package:tasknotate/controller/tasks/attributestask/timeline_manager.dart';
// import 'package:tasknotate/data/model/usertasksmodel.dart';

// mixin StatusToggleMixin on GetxController {
//   void toggleStatus(String type, bool value, {UserTasksModel? task}) {
//     switch (type) {
//       case "priority":
//         statusPriority = value;
//         if (!value && task != null) {
//           updateTaskPriority(task, "Not Set");
//         }
//         break;
//       case "dateandtime":
//       case "finishdate":
//         statusDateAndTime = value;
//         if (!value) selectedDate = null;
//         break;
//       case "startdate":
//         statusStartDate = value;
//         if (!value) selectedStartDate = null;
//         break;
//       case "subtasks":
//         statusSubtasks = value;
//         if (!value) {
//           Get.find<SubtaskManager>().clear();
//         }
//         break;
//       case "reminder":
//       case "timer":
//         statusReminder = value;
//         if (!value) selectedAlarm = null;
//         break;
//       case "timeline":
//         statusTimeline = value;
//         if (!value) {
//           Get.find<TimelineManager>().clear();
//         }
//         break;
//       case "category":
//         statusCategory = value;
//         if (!value) selectedCategoryId = null;
//         break;
//     }
//     update();
//   }

//   void updateTaskPriority(UserTasksModel task, String priority) {
//     task = UserTasksModel(
//       id: task.id,
//       title: task.title,
//       content: task.content,
//       date: task.date,
//       estimatetime: task.estimatetime,
//       starttime: task.starttime,
//       reminder: task.reminder,
//       status: task.status,
//       priority: priority,
//       subtask: task.subtask,
//       checked: task.checked,
//       images: task.images,
//       timeline: task.timeline,
//       category: task.category,
//     );
//   }

//   // Abstract properties to be implemented by controllers
//   bool get statusPriority;
//   set statusPriority(bool value);

//   bool get statusDateAndTime;
//   set statusDateAndTime(bool value);

//   bool get statusStartDate;
//   set statusStartDate(bool value);

//   bool get statusSubtasks;
//   set statusSubtasks(bool value);

//   bool get statusReminder;
//   set statusReminder(bool value);

//   bool get statusTimeline;
//   set statusTimeline(bool value);

//   bool get statusCategory;
//   set statusCategory(bool value);

//   DateTime? get selectedDate;
//   set selectedDate(DateTime? value);

//   DateTime? get selectedStartDate;
//   set selectedStartDate(DateTime? value);

//   DateTime? get selectedAlarm;
//   set selectedAlarm(DateTime? value);

//   int? get selectedCategoryId;
//   set selectedCategoryId(int? value);
// }
