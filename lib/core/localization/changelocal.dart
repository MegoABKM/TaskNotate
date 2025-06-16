import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/constant/appthemes.dart';
import 'package:tasknotate/controller/theme_controller.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class LocalController extends GetxController {
  late Locale language;
  late ThemeData appTheme;
  final StorageService myServices = Get.find<StorageService>();

  LocalController() {
    String? sharedprefLang = myServices.sharedPreferences.getString("lang");

    // Check for supported languages
    switch (sharedprefLang) {
      case "ar":
        language = const Locale("ar");
        break;
      case "en":
        language = const Locale("en");
        break;
      case "de":
        language = const Locale("de");
        break;
      case "zh":
        language = const Locale("zh");
        break;
      case "es":
        language = const Locale("es");
        break;
      default:
        language = Locale(Get.deviceLocale?.languageCode ?? "en");
    }

    // Initialize theme based on language and theme mode
    ThemeController themeController = Get.find<ThemeController>();
    appTheme = themeController.isDarkMode
        ? AppThemes.darkTheme(language.languageCode)
        : AppThemes.lightTheme(language.languageCode);
  }

  void changeLang(String lang) {
    language = Locale(lang);
    myServices.sharedPreferences.setString("lang", lang);

    // Update theme based on new language and current theme mode
    ThemeController themeController = Get.find<ThemeController>();
    appTheme = themeController.isDarkMode
        ? AppThemes.darkTheme(lang)
        : AppThemes.lightTheme(lang);

    // Update ThemeController's currentTheme and notify listeners
    themeController.currentTheme = appTheme;
    themeController.update(); // Triggers rebuild for ThemeController listeners

    // Update both locale and theme globally
    Get.changeTheme(appTheme);
    Get.updateLocale(language);

    // Force a full rebuild by navigating to the same route
    Get.offAllNamed(Get.currentRoute);
  }
}
