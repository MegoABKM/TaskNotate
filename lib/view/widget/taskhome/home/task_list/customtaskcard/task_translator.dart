import 'package:get/get.dart';

/// Helper class for task translations
class TaskTranslator {
  static String translatePriority(String priority) {
    switch (priority) {
      case "Low":
        return "146".tr;
      case "Medium":
        return "147".tr;
      case "High":
        return "148".tr;
      case "Not Set":
      default:
        return "129".tr;
    }
  }

  static String translateStatus(String status) {
    switch (status) {
      case "Pending":
        return "149".tr;
      case "In Progress":
        return "150".tr;
      case "Completed":
        return "151".tr;
      default:
        return status;
    }
  }
}
