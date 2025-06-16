import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/settings_controller.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/settings/change_language_card.dart';
import 'package:tasknotate/view/widget/settings/disable_all_alarm_card.dart';
import 'package:tasknotate/view/widget/settings/sound_toggle_card.dart';
import 'package:tasknotate/view/widget/settings/theme_selection_main.dart';
import 'package:tasknotate/view/widget/settings/color_selection_card.dart';
import 'package:tasknotate/view/widget/settings/info_card.dart';
import 'package:tasknotate/view/widget/settings/support_card.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final SoundService soundService = Get.find<SoundService>();
    Get.put(SettingsController());

    return GetBuilder<ThemeController>(
      builder: (themeController) => Scaffold(
        backgroundColor: context.appTheme.colorScheme.primary,
        appBar: AppBar(
          title: Text(
            '101'.tr, // "Settings"
            style: context.appTextTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: context.scaleConfig.scaleText(20).clamp(18, 24),
              color: context.appTheme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: context.appTheme.colorScheme.primary,
          elevation: 0,
        ),
        body: Container(
          color: context.appTheme.colorScheme.primary,
          padding: EdgeInsets.all(context.scaleConfig.scale(20).clamp(16, 24)),
          child: ListView(
            children: [
              ThemeSelectionMain(
                soundService: soundService,
              ),
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              ColorSelectionCard(
                soundService: soundService,
              ),
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              ChangeLanguageCard(
                soundService: soundService,
              ),
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              SoundToggleCard(), // Added before DisableAllAlarmCard
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              DisableAllAlarmCard(
                soundService: soundService,
              ),

              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              SupportCard(
                soundService: soundService,
              ),
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
              InfoCard(
                soundService: soundService,
              ),
              SizedBox(height: context.scaleConfig.scale(16).clamp(12, 20)),
            ],
          ),
        ),
      ),
    );
  }
}
