import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/utils/extensions.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/services/sound_service.dart';

class ChangeLanguageCard extends GetView<LocalController> {
  final SoundService soundService;
  const ChangeLanguageCard({required this.soundService, super.key});

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
              '105'.tr, // "Language" (translated)
              style: context.appTextTheme.headlineSmall?.copyWith(
                fontSize: context.scaleConfig.scaleText(20).clamp(16, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.scaleConfig.scale(16).clamp(10, 20)),
            GetBuilder<LocalController>(
              builder: (controller) => DropdownButton<String>(
                value: controller.language.languageCode,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      'English', // "English" (translated)
                      style: context.appTextTheme.bodyLarge?.copyWith(
                        fontSize:
                            context.scaleConfig.scaleText(16).clamp(14, 18),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(
                      'العربية', // "العربية" (translated)
                      style: context.appTextTheme.bodyLarge?.copyWith(
                        fontSize:
                            context.scaleConfig.scaleText(16).clamp(14, 18),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'de',
                    child: Text(
                      'Deutsch', // Use translated key if available, e.g., 'german'.tr
                      style: context.appTextTheme.bodyLarge?.copyWith(
                        fontSize:
                            context.scaleConfig.scaleText(16).clamp(14, 18),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'zh',
                    child: Text(
                      '中文', // Use translated key if available, e.g., 'chinese'.tr
                      style: context.appTextTheme.bodyLarge?.copyWith(
                        fontSize:
                            context.scaleConfig.scaleText(16).clamp(14, 18),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Text(
                      'español', // Use translated key if available, e.g., 'chinese'.tr
                      style: context.appTextTheme.bodyLarge?.copyWith(
                        fontSize:
                            context.scaleConfig.scaleText(16).clamp(14, 18),
                      ),
                    ),
                  ),
                ],
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    await soundService.playButtonClickSound(); // Sound effect
                    controller.changeLang(newValue);
                  }
                },
                underline: Container(
                  height: 2,
                  color: context.appTheme.colorScheme.secondary,
                ),
                icon: Icon(
                  Icons.language,
                  color: context.appTheme.iconTheme.color,
                  size: context.scaleConfig.scale(24).clamp(20, 30),
                ),
                style: context.appTextTheme.bodyLarge?.copyWith(
                  fontSize: context.scaleConfig.scaleText(16).clamp(14, 18),
                ),
                dropdownColor: context.appTheme.cardColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
