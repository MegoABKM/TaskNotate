import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/settings/theme_selection_tile.dart';

class ThemeSelectionMain extends GetView<ThemeController> {
  final SoundService soundService;
  const ThemeSelectionMain({required this.soundService, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(context.scaleConfig.scale(20).clamp(15, 30)),
      ),
      elevation: context.scaleConfig.scale(8).clamp(5, 10),
      color: context.appTheme.cardColor.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(context.scaleConfig.scale(20).clamp(15, 25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '102'.tr,
              style: context.appTextTheme.headlineSmall?.copyWith(
                fontSize: context.scaleConfig.scaleText(20).clamp(16, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.scaleConfig.scale(16).clamp(10, 20)),
            GetBuilder<ThemeController>(
              builder: (controller) => ThemeSelectionTile(
                title: "103".tr,
                icon: Icons.wb_sunny,
                iconColor: Colors.amber,
                onTap: () async {
                  await soundService.playButtonClickSound();
                  controller.switchTheme("light");
                },
                isSelected: !controller.isDarkMode,
              ),
            ),
            const Divider(),
            GetBuilder<ThemeController>(
              builder: (controller) => ThemeSelectionTile(
                title: "104".tr,
                icon: Icons.nightlight_round,
                iconColor: Colors.deepPurple,
                onTap: () async {
                  await soundService.playButtonClickSound();
                  controller.switchTheme("dark");
                },
                isSelected: controller.isDarkMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
