import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/data/model/usernotesmodel.dart';

class CardContentNote extends GetView<HomeController> {
  final UserNotesModel note;

  const CardContentNote(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => Get.defaultDialog(
        title: "Caution".tr,
        middleText: "Delete This Note?".tr,
        textConfirm: "Confirm".tr,
        textCancel: "Cancel".tr,
        onCancel: () {
          return;
        },
        onConfirm: () async {
          await controller.deleteDataNote(note.id!);
          Navigator.of(context).pop();
        },
      ),
      onTap: () {
        print(
            "[CardContentNote onTap] Going to view note ID: ${note.id}, Title: '${note.title}'");
        controller.goToViewNote(note);
      },
      child: Hero(
        tag: note.id ?? "",
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: context.scaleConfig.scale(2),
            horizontal: context.scaleConfig.scale(2),
          ),
          width: context.scaleConfig.scale(200),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.scaleConfig.scale(5),
                  vertical: context.scaleConfig.scale(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      note.content ?? "",
                      maxLines: 11,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: context.scaleConfig.scaleText(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
