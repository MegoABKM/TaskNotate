import 'package:get/get.dart';

mixin TranslationMixin {
  String translatePriority(String priority) {
    switch (priority) {
      case "Not Set":
        return "166".tr;
      case "Low":
        return "160".tr;
      case "Medium":
        return "161".tr;
      case "High":
        return "162".tr;
      default:
        return priority;
    }
  }

  String translateStatus(String status) {
    switch (status) {
      case "Pending":
        return "163".tr;
      case "In Progress":
        return "164".tr;
      case "Completed":
        return "165".tr;
      default:
        return status;
    }
  }
}
