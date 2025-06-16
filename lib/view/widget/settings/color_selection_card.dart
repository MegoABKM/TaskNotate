import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/services/sound_service.dart';

class ColorSelectionCard extends GetView<ThemeController> {
  final SoundService soundService;
  const ColorSelectionCard({required this.soundService, super.key});

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
              '370'.tr, // Color Selection
              style: context.appTextTheme.headlineSmall?.copyWith(
                fontSize: context.scaleConfig.scaleText(20).clamp(16, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.scaleConfig.scale(16).clamp(10, 20)),
            Text(
              '371'
                  .tr, // Color (you can define this in your translation as "Color")
              style: context.appTextTheme.bodyLarge?.copyWith(
                fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
              ),
            ),
            GetBuilder<ThemeController>(
              builder: (controller) {
                // Use primaryColorKey since primary and secondary are the same
                final colorValue = AppThemes.availableColors
                        .containsKey(controller.primaryColorKey)
                    ? controller.primaryColorKey
                    : 'deepTeal';
                return DropdownButton<String>(
                  value: colorValue,
                  isExpanded: true,
                  items: AppThemes.availableColors.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Container(
                            width: context.scaleConfig.scale(20).clamp(15, 25),
                            height: context.scaleConfig.scale(20).clamp(15, 25),
                            color: entry.value,
                          ),
                          SizedBox(
                              width:
                                  context.scaleConfig.scale(10).clamp(5, 15)),
                          Text(
                            entry.key.tr,
                            style: context.appTextTheme.bodyLarge?.copyWith(
                              fontSize: context.scaleConfig
                                  .scaleText(16)
                                  .clamp(14, 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      await soundService.playButtonClickSound(); // Sound effect
                      // Set both primary and secondary colors to the same value
                      controller.setPrimaryColor(newValue);
                      controller.setSecondaryColor(newValue);
                    }
                  },
                  underline: Container(
                    height: 2,
                    color: context.appTheme.colorScheme.secondary,
                  ),
                  icon: Icon(
                    Icons.color_lens,
                    color: context.appTheme.iconTheme.color,
                    size: context.scaleConfig.scale(24).clamp(20, 30),
                  ),
                  style: context.appTextTheme.bodyLarge?.copyWith(
                    fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                  ),
                  dropdownColor: context.appTheme.cardColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
