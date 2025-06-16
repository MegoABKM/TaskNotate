import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasknotate/controller/home_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/imageasset.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class AnimateAppBarNote extends GetView<HomeController> {
  const AnimateAppBarNote({super.key});

  @override
  Widget build(BuildContext context) {
    String notesname = "99".tr;

    final bool isArabic =
        Get.find<StorageService>().sharedPreferences.getString("lang") == "ar";

    return SliverAppBar(
      elevation: AppThemes.appBarElevation,
      shadowColor: context.appTheme.shadowColor,
      stretch: true,
      expandedHeight: context.scaleConfig.scale(220),
      floating: false,
      pinned: true,
      backgroundColor: context.appTheme.colorScheme.secondary,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (BuildContext scaffoldContext) {
          return IconButton(
            icon: Icon(
              FontAwesomeIcons.list,
              color: context.appTheme.colorScheme.onSecondary,
              size: context.scaleConfig.scale(24),
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
          bottom: context.scaleConfig.scale(20),
        ),
        expandedTitleScale: 1.5,
        background: Padding(
          padding: EdgeInsets.only(
            top: context.scaleConfig.scale(40),
            bottom: context.scaleConfig.scale(20),
            left: isArabic ? 40 : context.scaleConfig.scale(10),
            right: isArabic ? context.scaleConfig.scale(40) : 0,
          ),
          child: LottieBuilder.asset(
            AppImageAsset.noteanimation3,
            repeat: false,
            height: context.scaleConfig.scale(120),
            fit: BoxFit.contain,
          ),
        ),
        collapseMode: CollapseMode.parallax,
        title: GetBuilder<HomeController>(
          id: "notes-length",
          builder: (controller) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width - context.scaleConfig.scale(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$notesname ${controller.notedata.length}",
                    textAlign: TextAlign.center,
                    style: context.appTheme.textTheme.titleLarge?.copyWith(
                      color: context.appTheme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.scaleConfig.scaleText(26),
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
