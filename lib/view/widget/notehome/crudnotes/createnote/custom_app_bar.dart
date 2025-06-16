// lib/view/widget/notehome/crudnotes/createnote/customappbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/notes/notecreate_controller.dart';
import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';

class CustomAppBar extends GetView<NotecreateController> {
  final Function(String) onTitleChanged;

  const CustomAppBar({super.key, required this.onTitleChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scaleConfig.scale(56),
      padding: EdgeInsets.symmetric(horizontal: context.scaleConfig.scale(12)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              padding: EdgeInsets.only(
                bottom: context.scaleConfig.scale(0.4),
                top: context.scaleConfig.scale(12),
              ),
              onPressed: () {
                controller.uploadData();
                Get.offAllNamed(AppRoute.home);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary,
                size: context.scaleConfig.scale(24),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.scaleConfig.scale(0.4),
                top: context.scaleConfig.scale(12),
              ),
              child: Text(
                "171".tr,
                style: TextStyle(
                  fontSize: context.scaleConfig.scaleText(24),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topLeft,
              child: TextFormField(
                controller: controller.titleController,
                maxLength: 30,
                style: TextStyle(fontSize: context.scaleConfig.scaleText(18)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "172".tr,
                  counterText: "",
                  contentPadding: EdgeInsets.only(
                    bottom: context.scaleConfig.scale(0.4),
                    top: context.scaleConfig.scale(17.6),
                  ),
                ),
                onChanged: onTitleChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
