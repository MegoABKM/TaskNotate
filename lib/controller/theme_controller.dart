import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/core/localization/changelocal.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService myServices = Get.find<StorageService>();
  bool isDarkMode = false;
  ThemeData currentTheme;
  String primaryColorKey = 'IndigoBlend';
  String secondaryColorKey = 'IndigoBlend';

  ThemeController() : currentTheme = AppThemes.lightTheme("en");

  // Map old color keys to new ones for backward compatibility
  static const Map<String, String> _colorMigrationMap = {
    'mutedTeal': 'vibrantBlue',
    'softMintGreen': 'sunsetCoral',
    'paleSkyBlue': 'oceanCyan',
    'slateBlue': 'twilightIndigo',
    'lavenderMist': 'royalPurple',
    'dustyLilac': 'royalPurple',
    'warmIvory': 'goldenYellow',
    'softTaupe': 'deepTeal',
    'palePeach': 'sunsetCoral',
    'mutedSageGreen': 'emeraldGreen',
    'aquaMarine': 'IndigoBlend',
  };

  @override
  void onInit() {
    super.onInit();
    // Load saved theme and colors
    String? savedTheme = myServices.sharedPreferences.getString('theme');
    String? savedPrimaryColor =
        myServices.sharedPreferences.getString('PrimaryColor');
    String? savedSecondaryColor =
        myServices.sharedPreferences.getString('SecondColor');
    String? savedLang = myServices.sharedPreferences.getString('lang');

    // Check device theme if no saved theme
    if (savedTheme == null) {
      // ignore: deprecated_member_use
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    } else {
      isDarkMode = savedTheme == 'dark';
    }

    // Migrate old color keys to new ones
    primaryColorKey = _colorMigrationMap[savedPrimaryColor] ??
        savedPrimaryColor ??
        'IndigoBlend';
    secondaryColorKey = _colorMigrationMap[savedSecondaryColor] ??
        savedSecondaryColor ??
        'IndigoBlend';

    // Validate colors exist in availableColors
    if (!AppThemes.availableColors.containsKey(primaryColorKey)) {
      primaryColorKey = 'IndigoBlend';
    }
    if (!AppThemes.availableColors.containsKey(secondaryColorKey)) {
      secondaryColorKey = 'IndigoBlend';
    }

    // Save migrated colors and theme
    myServices.sharedPreferences.setString('PrimaryColor', primaryColorKey);
    myServices.sharedPreferences.setString('SecondColor', secondaryColorKey);
    myServices.sharedPreferences
        .setString('theme', isDarkMode ? 'dark' : 'light');

    // Determine language code
    String languageCode;
    try {
      LocalController localController = Get.find<LocalController>();
      languageCode = localController.language.languageCode;
    } catch (e) {
      print("Error finding LocalController: $e");
      // Fallback to saved language or device locale
      languageCode = savedLang ?? Get.deviceLocale?.languageCode ?? 'en';
    }

    // Set theme with correct font family
    currentTheme = isDarkMode
        ? AppThemes.darkTheme(languageCode)
        : AppThemes.lightTheme(languageCode);

    Get.changeTheme(currentTheme);
    update();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    myServices.sharedPreferences
        .setString('theme', isDarkMode ? 'dark' : 'light');
    try {
      LocalController localController = Get.find<LocalController>();
      String languageCode = localController.language.languageCode;
      currentTheme = isDarkMode
          ? AppThemes.darkTheme(languageCode)
          : AppThemes.lightTheme(languageCode);
    } catch (e) {
      print("Error finding LocalController: $e");
      currentTheme =
          isDarkMode ? AppThemes.darkTheme("en") : AppThemes.lightTheme("en");
    }
    Get.changeTheme(currentTheme);
    update();
  }

  void switchTheme(String themeMode) {
    isDarkMode = themeMode == 'dark';
    myServices.sharedPreferences.setString('theme', themeMode);
    try {
      LocalController localController = Get.find<LocalController>();
      String languageCode = localController.language.languageCode;
      currentTheme = isDarkMode
          ? AppThemes.darkTheme(languageCode)
          : AppThemes.lightTheme(languageCode);
    } catch (e) {
      print("Error finding LocalController: $e");
      currentTheme =
          isDarkMode ? AppThemes.darkTheme("en") : AppThemes.lightTheme("en");
    }
    Get.changeTheme(currentTheme);
    update();
  }

  void setPrimaryColor(String colorKey) {
    if (AppThemes.availableColors.containsKey(colorKey)) {
      primaryColorKey = colorKey;
      myServices.sharedPreferences.setString('PrimaryColor', colorKey);
      try {
        LocalController localController = Get.find<LocalController>();
        String languageCode = localController.language.languageCode;
        currentTheme = isDarkMode
            ? AppThemes.darkTheme(languageCode)
            : AppThemes.lightTheme(languageCode);
      } catch (e) {
        print("Error finding LocalController: $e");
        currentTheme =
            isDarkMode ? AppThemes.darkTheme("en") : AppThemes.lightTheme("en");
      }
      Get.changeTheme(currentTheme);
      update();
    } else {
      print("Invalid color key: $colorKey");
    }
  }

  void setSecondaryColor(String colorKey) {
    if (AppThemes.availableColors.containsKey(colorKey)) {
      secondaryColorKey = colorKey;
      myServices.sharedPreferences.setString('SecondColor', colorKey);
      try {
        LocalController localController = Get.find<LocalController>();
        String languageCode = localController.language.languageCode;
        currentTheme = isDarkMode
            ? AppThemes.darkTheme(languageCode)
            : AppThemes.lightTheme(languageCode);
      } catch (e) {
        print("Error finding LocalController: $e");
        currentTheme =
            isDarkMode ? AppThemes.darkTheme("en") : AppThemes.lightTheme("en");
      }
      Get.changeTheme(currentTheme);
      update();
    } else {
      print("Invalid color key: $colorKey");
    }
  }
}
