import 'package:tasknotate/core/constant/routes.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import '../widget/language/custombuttonlang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Langauge extends GetView<LocalController> {
  const Langauge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "1".tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Custombuttonlang(
              textbutton: "العربية",
              onPressed: () {
                controller.changeLang("ar");
                Get.toNamed(AppRoute.onBoarding);
              },
            ),
            Custombuttonlang(
              textbutton: "English",
              onPressed: () {
                controller.changeLang("en");
                Get.toNamed(AppRoute.onBoarding);
              },
            )
          ],
        ),
      ),
    );
  }
}
