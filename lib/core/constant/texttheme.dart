// lib/core/constant/texttheme.dart
import 'package:flutter/material.dart';

ThemeData themeEnglish = ThemeData(
  fontFamily: "PlayfairDisplay",
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      height: 1.5, // Reduced height for better readability
      color: Colors.black,
      fontWeight: FontWeight.w500, // Slightly lighter weight
      fontSize: 17,
    ),
    bodyMedium: TextStyle(
      height: 1.5,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      height: 1.5,
      color: Colors.grey,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      // Added for buttons
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
);

ThemeData themeArabic = ThemeData(
  fontFamily: "Cairo", // Use Cairo font for Arabic
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22, // Slightly larger for Arabic
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32, // Slightly larger for Arabic
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      height: 1.8, // More spacing for Arabic readability
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 18, // Larger for Arabic
    ),
    bodyMedium: TextStyle(
      height: 1.8,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    ),
    bodySmall: TextStyle(
      height: 1.8,
      color: Colors.grey,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      // Added for buttons
      fontSize: 18, // Larger for Arabic buttons
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
);
