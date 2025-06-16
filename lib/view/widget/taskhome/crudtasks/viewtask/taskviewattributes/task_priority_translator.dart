import 'package:get/get.dart';

class TaskPriorityTranslator {
  String translate(String priority) {
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
}
