import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasknotate/core/services/storage_service.dart';

class AppThemes {
  static final StorageService myServices = Get.find<StorageService>();

  static bool isColorDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  static TextTheme getCommonTextTheme() => TextTheme(
        displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );

  static const double appBarElevation = 4.0;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  static const TextStyle dropdownTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle emptyTaskTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const BoxShadow cardBoxShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 6,
    offset: Offset(0, 2),
  );
  static const BoxShadow darkCardBoxShadow = BoxShadow(
    color: Colors.black54,
    blurRadius: 8,
    offset: Offset(0, 3),
  );

  static ButtonThemeData buttonTheme(ColorScheme colorScheme) {
    return ButtonThemeData(
      buttonColor: colorScheme.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: colorScheme.brightness == Brightness.light
                ? colorScheme.primary
                : colorScheme.secondary,
            width: 2),
      ),
      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
      labelStyle: TextStyle(color: colorScheme.primary),
    );
  }

  static final Map<String, Color> availableColors = {
    'IndigoBlend': Color(0xFF0C94CB), // NEW
    'vibrantBlue': Color(0xFF1976D2),
    'sunsetCoral': Color(0xFFE64A19),
    'emeraldGreen': Color(0xFF27AE60),
    'royalPurple': Color(0xFF7B1FA2),
    'goldenYellow': Color(0xFFFFA000),
    'deepTeal': Color(0xFF00695C), // This IS the darker variant for aquaMarine
    'rubyRed': Color(0xFFD81B60),
    'oceanCyan': Color(0xFF00838F),
    'limeBurst': Color(0xFFAFB42B),
    'twilightIndigo': Color(0xFF303F9F),

    'darkSunsetCoral': Color(0xFFBF360C),
    'darkEmeraldGreen': Color(0xFF1B5E20),
    'darkRoyalPurple': Color(0xFF4A148C),
    'darkGoldenYellow': Color(0xFFF57F17),
    'darkDeepTeal':
        Color(0xFF004D40), // Even darker teal, distinct from deepTeal
    'darkOceanCyan': Color(0xFF006064),
    'darkLimeBurst': Color(0xFF827717),
    'forestGreen': Color(0xFF2E7D32),
    'burntOrange': Color(0xFFEF6C00),
    'amethystPurple': Color(0xFFAB47BC),
    'sapphireBlue': Color(0xFF0D47A1), // Was duplicate of darkVibrantBlue
    'crimsonRed': Color(0xFFB71C1C), // Was duplicate of darkRubyRed
    'aquaMarine': Color(0xFF26A69A), // Current default
    'midnightBlue': Color(0xFF1A237E), // Was duplicate of darkTwilightIndigo
    'coralPink': Color(0xFFF06292),
    'oliveGreen': Color(0xFF4CAF50),

    // Truly unique dark variants
    'darkAmethystPurple': Color(0xFF6A1B9A),
    'darkSapphireBlue': Color(0xFF002171),
    'darkCrimsonRed': Color(0xFF7F0000),
    'darkSunflowerYellow': Color(0xFFC6A700),
    'darkMidnightBlue': Color(0xFF0D1428),
    'darkCoralPink': Color(0xFFC2185B),
  };

  static Color getPrimaryColor(bool isDarkMode) {
    String? colorKey = myServices.sharedPreferences.getString('PrimaryColor');
    // Default key is 'aquaMarine' as set in ThemeController
    Color selectedColor =
        availableColors[colorKey] ?? availableColors['IndigoBlend']!;

    if (isDarkMode) {
      if (colorKey == 'IndigoBlend') {
        return availableColors[
            'IndigoBlend']!; // Use 'deepTeal' as the dark variant for 'aquaMarine'
      }
      // Add other explicit mappings for mid-tones to their darker counterparts if needed
      // e.g., if 'goldenYellow' is selected, use 'darkGoldenYellow' in dark mode
      // else if (colorKey == 'goldenYellow') {
      //   return availableColors['darkGoldenYellow']!;
      // }
    }
    return selectedColor;
  }

  static Color getSecondaryColor(bool isDarkMode) {
    String? colorKey = myServices.sharedPreferences.getString('SecondColor');
    // Default key is 'aquaMarine' as set in ThemeController
    Color selectedColor =
        availableColors[colorKey] ?? availableColors['aquaMarine']!;

    if (isDarkMode) {
      if (colorKey == 'IndigoBlend') {
        return availableColors[
            'IndigoBlend']!; // Use 'deepTeal' as the dark variant for 'aquaMarine'
      }
      // Add other explicit mappings for mid-tones
      // else if (colorKey == 'limeBurst') {
      //   return availableColors['darkLimeBurst']!;
      // }
    }
    return selectedColor;
  }

  static ThemeData lightTheme(String languageCode) {
    final primaryColor = getPrimaryColor(false);
    final secondaryColor = getSecondaryColor(false);

    final Color onPrimaryColor =
        isColorDark(primaryColor) ? Colors.white : Colors.black87;
    final Color onSecondaryColor =
        isColorDark(secondaryColor) ? Colors.white : Colors.black87;
    final Color mainTextColor = Colors.black87;

    return ThemeData(
      fontFamily: languageCode == "ar" ? "Cairo" : "OpenSans",
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.grey[100],
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
        surface: Colors.white,
        onSurface: mainTextColor,
        error: Colors.red.shade700,
        onError: Colors.white,
      ),
      textTheme: getCommonTextTheme().apply(
        bodyColor: mainTextColor,
        displayColor: mainTextColor,
      ),
      iconTheme: IconThemeData(
          color: isColorDark(primaryColor) ? primaryColor : Colors.black54,
          size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: appBarElevation,
        shadowColor: Colors.black26,
      ),
      buttonTheme: buttonTheme(ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      inputDecorationTheme: inputDecorationTheme(ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        onSurface: mainTextColor,
      )),
      dividerColor: Colors.grey[300],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimaryColor,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: onSecondaryColor,
      ),
    );
  }

  static ThemeData darkTheme(String languageCode) {
    final primaryColor = getPrimaryColor(
        true); // Will be 'deepTeal' if 'aquaMarine' was selected
    final secondaryColor = getSecondaryColor(
        true); // Will be 'deepTeal' if 'aquaMarine' was selected

    // Now that primaryColor and secondaryColor are guaranteed to be dark enough (or a dark variant)
    // 'on' colors can be consistently white.
    final Color onPrimaryColor = Colors.white;
    final Color onSecondaryColor = Colors.white;
    final Color mainTextColor = Colors.grey.shade300;

    return ThemeData(
      fontFamily: languageCode == "ar" ? "Cairo" : "OpenSans",
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF1E1E1E),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
        surface: Color(0xFF1E1E1E),
        onSurface: mainTextColor,
        error: Colors.red.shade400,
        onError: Colors.black,
      ),
      textTheme: getCommonTextTheme().apply(
        bodyColor: mainTextColor,
        displayColor: mainTextColor,
      ),
      iconTheme: IconThemeData(
          color: onSecondaryColor,
          size: 24), // Consistent light icon on dark bg
      appBarTheme: AppBarTheme(
        backgroundColor:
            primaryColor, // Uses the (now correctly darkened) primary color
        foregroundColor: onPrimaryColor,
        elevation: 0,
      ),
      buttonTheme: buttonTheme(ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
      )),
      inputDecorationTheme: inputDecorationTheme(ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Color(0xFF1E1E1E),
        onSurface: mainTextColor,
      )),
      dividerColor: Colors.grey[700],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimaryColor,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: onSecondaryColor,
      ),
    );
  }
}
