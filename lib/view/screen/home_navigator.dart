import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/functions/alertexitapp.dart';
import 'package:tasknotate/core/services/storage_service.dart';
import 'package:tasknotate/view/screen/notes_home.dart';
import 'package:tasknotate/view/screen/settings.dart';
import 'package:tasknotate/view/screen/tasks_home.dart';
import 'package:tasknotate/view/widget/home/all_nav_buttons.dart';
import 'package:tasknotate/view/widget/home/sloped_sidebar_painter.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.put(HomeController(), permanent: true);

    List<Widget> screens = [
      const Taskshome(),
      const NotesHome(),
      const Settings(),
    ];

    double sidebarWidth = Get.width * 0.08;
    double minWidth = context.scaleConfig.scale(50);
    double maxWidth = context.scaleConfig.scale(90);
    if (sidebarWidth < minWidth) sidebarWidth = minWidth;
    if (sidebarWidth > maxWidth) sidebarWidth = maxWidth;
    double sidebarHeight = context.scaleConfig.scale(160);

    bool isArabic =
        Get.find<StorageService>().sharedPreferences.getString("lang") == "ar";

    return Scaffold(
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () => alertExitApp(),
        child: Stack(
          children: [
            GetBuilder<HomeController>(
              builder: (controller) => screens[controller.currentIndex],
            ),
            Positioned(
              top: context.scaleConfig.scale(50),
              left: isArabic ? 0 : null,
              right: isArabic ? null : 0,
              child: SizedBox(
                width: sidebarWidth,
                height: sidebarHeight,
                child: CustomPaint(
                  painter: SidebarPainter(context, isArabic: isArabic),
                  child: AllNavButtons(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
