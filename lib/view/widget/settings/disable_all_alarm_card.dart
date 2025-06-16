import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/settings_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/settings/settings_switch_tile.dart';

class DisableAllAlarmCard extends GetView<SettingsController> {
  final SoundService soundService;
  const DisableAllAlarmCard({required this.soundService, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.scaleConfig.scale(20)),
      ),
      elevation: context.scaleConfig.scale(8),
      color: context.appTheme.cardColor.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.scaleConfig.scale(10)),
        child: Column(
          children: [
            Obx(
              () => SettingsSwitchTile(
                title: "106".tr,
                icon: Icons.block,
                value: controller.areAlarmsDisabled.value,
                onChanged: (value) async {
                  await soundService.playButtonClickSound();
                  await controller.toggleAllAlarms(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
