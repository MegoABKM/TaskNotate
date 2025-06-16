import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/settings_controller.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';
import 'package:tasknotate/view/widget/settings/settings_switch_tile.dart';

class SoundToggleCard extends GetView<SettingsController> {
  const SoundToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SoundService soundService = Get.find<SoundService>();

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
                title: "Disable Sound Effects".tr,
                icon: Icons.volume_off,
                value: soundService.isSoundDisabled,
                onChanged: (value) async {
                  await soundService.toggleSound(value);
                  if (!value) {
                    await soundService
                        .playButtonClickSound(); // Feedback on enable
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
