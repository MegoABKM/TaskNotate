import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasknotate/controller/onboarding_controller.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
// Ensure this path is correct for your project structure
import 'package:tasknotate/core/constant/utils/scale_confige.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/data/datasource/static/static.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    // To make text smaller, you'd pass globalPixelTextAdjustment here, e.g.:
    // final scaleConfig = ScaleConfig(context, globalPixelTextAdjustment: -1.0);
    // Or change the default in ScaleConfig.dart
    final scaleConfig = ScaleConfig(context);
    final theme = Theme.of(context);
    final localController = Get.find<LocalController>();

    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (value) {
        controller.onPageChanged(value);
      },
      itemCount: onBoardingList.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Directionality(
            textDirection: localController.language.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: scaleConfig.scale(40)), // Good
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      onBoardingList[index].title!.tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: scaleConfig.scaleText(24), // Good
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: scaleConfig.scale(20)), // Good
                // Using Get.width/height for proportions is fine if that's the design intent.
                // Alternatively, you could use scaleConfig.scale(referenceLottieWidth)
                Container(
                  width: Get.width * 0.8,
                  height: Get.height * 0.35,
                  child: LottieBuilder.asset(
                    onBoardingList[index].image!,
                    width: Get.width * 0.8,
                    height: Get.height * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: scaleConfig.scale(20)), // Good
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: scaleConfig.scale(20)), // Good
                  child: Text(
                    onBoardingList[index].body!.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height:
                          1.5, // Line height is usually relative, so fixed is okay
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: scaleConfig.scaleText(18), // Good
                    ),
                  ),
                ),
                // Language Dropdown
                if (index == 0) ...[
                  SizedBox(height: scaleConfig.scale(20)), // Good
                  GetBuilder<LocalController>(
                    builder: (localController) => DropdownButton<String>(
                      value: localController.language.languageCode,
                      items: [
                        // ... DropdownMenuItem ... (content not scaled, usually fine for short text)
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                              'English'), // Text inside items usually doesn't need explicit scaleText
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('العربية'),
                        ),
                        DropdownMenuItem(
                          value: 'de',
                          child: Text('Deutsch'),
                        ),
                        DropdownMenuItem(
                          value: 'es',
                          child: Text('Español'),
                        ),
                        DropdownMenuItem(
                          value: 'zh',
                          child: Text('中文'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          localController.changeLang(value);
                        }
                      },
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: scaleConfig.scaleText(16), // Good
                        color: theme.colorScheme.onSurface,
                      ),
                      dropdownColor: theme.colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(scaleConfig.scale(8)), // Good
                    ),
                  ),
                ],
                // Theme Toggle
                if (index == 4) ...[
                  SizedBox(height: scaleConfig.scale(20)), // Good
                  GetBuilder<ThemeController>(
                    builder: (themeController) => SwitchListTile(
                      title: Text(
                        themeController.isDarkMode
                            ? 'dark_mode'.tr
                            : 'light_mode'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: scaleConfig.scaleText(16), // Good
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      value: themeController.isDarkMode,
                      onChanged: (value) {
                        themeController.toggleTheme();
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
                // Color Selection
                if (index == 5) ...[
                  SizedBox(height: scaleConfig.scale(20)), // Good
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          scaleConfig.scale(20).clamp(15, 30)), // Good
                    ),
                    elevation: scaleConfig.scale(8).clamp(5, 10), // Good
                    color: theme.cardColor.withOpacity(0.9),
                    child: Padding(
                      padding: EdgeInsets.all(
                          scaleConfig.scale(20).clamp(15, 25)), // Good
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '370'.tr, // Color Selection
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: scaleConfig
                                  .scaleText(20)
                                  .clamp(16, 22), // Good
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  scaleConfig.scale(16).clamp(10, 20)), // Good
                          Text(
                            '371'.tr, // Color
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: scaleConfig
                                  .scaleText(16)
                                  .clamp(14, 18), // Good
                            ),
                          ),
                          GetBuilder<ThemeController>(
                            builder: (themeController) {
                              final colorValue = AppThemes.availableColors
                                      .containsKey(
                                          themeController.primaryColorKey)
                                  ? themeController.primaryColorKey
                                  : 'deepTeal';
                              return DropdownButton<String>(
                                value: colorValue,
                                isExpanded: true,
                                items: AppThemes.availableColors.entries
                                    .map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: scaleConfig
                                              .scale(20)
                                              .clamp(15, 25), // Good
                                          height: scaleConfig
                                              .scale(20)
                                              .clamp(15, 25), // Good
                                          color: entry.value,
                                        ),
                                        SizedBox(
                                            width: scaleConfig
                                                .scale(10)
                                                .clamp(5, 15)), // Good
                                        Text(
                                          entry.key.tr,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontSize: scaleConfig
                                                .scaleText(16)
                                                .clamp(14, 18), // Good
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    themeController.setPrimaryColor(newValue);
                                    themeController.setSecondaryColor(newValue);
                                  }
                                },
                                underline: Container(
                                  height:
                                      2, // Fixed height for underline is often fine
                                  color: theme.colorScheme.secondary,
                                ),
                                icon: Icon(
                                  Icons.color_lens,
                                  color: theme.iconTheme.color,
                                  size: scaleConfig
                                      .scale(24)
                                      .clamp(20, 30), // Good
                                ),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: scaleConfig
                                      .scaleText(16)
                                      .clamp(14, 18), // Good
                                ),
                                dropdownColor: theme.cardColor,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: scaleConfig.scale(20)), // Good
              ],
            ),
          ),
        );
      },
    );
  }
}
