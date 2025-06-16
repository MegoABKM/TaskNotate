import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/tasks/taskcreate_controller.dart';
import 'package:tasknotate/view/widget/taskhome/crudtasks/createtask/custom_drop_down_button.dart';

class StatusOfTask extends StatelessWidget {
  const StatusOfTask({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskcreateController>(
      builder: (controller) => CustomDropDownButton(
        type: "status",
        controller.status!,
        controller.statuses,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.status = newValue;
            controller.update();
          }
        },
        hintTextKey: "selectStatusDropdownHint", // New hint key
      ),
    );
  }
}
