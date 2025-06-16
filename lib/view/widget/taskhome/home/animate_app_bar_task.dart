import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/imageasset.dart';
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class AnimateAppBarTask extends GetView<HomeController> {
  const AnimateAppBarTask({super.key});

  @override
  Widget build(BuildContext context) {
    final ScaleConfig scaleConfig = ScaleConfig(context);
    final theme = Theme.of(context);
    String taskname = "92".tr; // Assuming "Tasks" or similar

    final bool isArabic =
        Get.find<StorageService>().sharedPreferences.getString("lang") == "ar";

    return SliverAppBar(
      elevation: AppThemes.appBarElevation,
      shadowColor: theme.shadowColor,
      stretch: true,
      expandedHeight: scaleConfig.scale(220),
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.secondary,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (BuildContext scaffoldContext) {
          return IconButton(
            icon: Icon(
              FontAwesomeIcons.list,
              color: theme.colorScheme.onSecondary,
              size: scaleConfig.scale(24),
            ),
            onPressed: () {
              Scaffold.of(scaffoldContext).openDrawer();
            },
            tooltip: 'Categories'.tr,
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          bottom: scaleConfig.scale(20),
        ),
        expandedTitleScale: 1.5,
        background: Padding(
          padding: EdgeInsets.only(
            top: scaleConfig.scale(40),
            bottom: scaleConfig.scale(20),
            left: isArabic ? scaleConfig.scale(30) : scaleConfig.scale(0),
            right: isArabic ? scaleConfig.scale(25) : 0,
          ),
          child: LottieBuilder.asset(
            AppImageAsset.taskpencil,
            repeat: false,
            height: scaleConfig.scale(120),
            fit: BoxFit.contain,
          ),
        ),
        collapseMode: CollapseMode.parallax,
        title: GetBuilder<HomeController>(
          id: "task-length",
          builder: (controller) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width - scaleConfig.scale(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$taskname ${controller.nonCompletedTaskCount}",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: scaleConfig.scaleText(28),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
