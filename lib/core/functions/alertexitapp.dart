import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    title: "exitAlertTitle".tr,
    middleText: "exitAlertMessage".tr,
    actions: [
      ElevatedButton(
        onPressed: () {
          exit(0);
        },
        child: Text("confirm".tr),
      ),
      ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("no".tr),
      )
    ],
  );
  return Future.value(true);
}
