// lib/core/localization/translation.dart (or wherever MyTranslation is)
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class MyTranslation extends Translations {
  // Static variable to hold the loaded translations AFTER they are loaded
  static Map<String, Map<String, String>> _loadedKeys = {};

  // Static method to initialize by loading files asynchronously
  // Call this ONCE in main() BEFORE runApp
  static Future<void> init() async {
    print('MyTranslation: Starting initialization...');
    final Map<String, Map<String, String>> translations = {};
    // Define all locales matching your JSON filenames
    final List<String> locales = ['en', 'ar', 'es', 'de', 'zh'];

    for (String locale in locales) {
      try {
        // Construct the path
        final String path = 'assets/translations/$locale.json';
        // Load the JSON string from assets
        String jsonString = await rootBundle.loadString(path);
        // Decode the JSON string into a Map
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        // Convert Map<String, dynamic> to Map<String, String> safely
        translations[locale] = jsonMap.map((key, value) {
          return MapEntry(key, value.toString()); // Ensure value is string
        });
        print('MyTranslation: Successfully loaded translations for "$locale".');
      } catch (e) {
        print(
            'MyTranslation: ERROR loading translations for locale "$locale": $e');
        // Provide an empty map as a fallback if a file is missing or corrupt
        translations[locale] = {};
      }
    }
    // Assign the loaded translations to the static variable
    _loadedKeys = translations;
    print('MyTranslation: Initialization complete.');
  }

  // The keys getter now returns the pre-loaded map
  // GetX will call this getter when it needs the translations
  @override
  Map<String, Map<String, String>> get keys => _loadedKeys;
}
