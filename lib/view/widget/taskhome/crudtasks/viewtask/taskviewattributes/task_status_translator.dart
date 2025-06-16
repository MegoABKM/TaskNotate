import 'package:get/get.dart';

class TaskStatusTranslator {
  String translate(String status) {
    switch (status) {
      case "Pending":
        return "149".tr;
      case "In Progress":
        return "150".tr;
      case "Completed":
        return "151".tr;
      default:
        return "132".tr; // "None" for "Not Set"
    }
  }
}
