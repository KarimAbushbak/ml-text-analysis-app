import 'package:flutter/material.dart';

/// App color palette with multicolor playful theme (like Duolingo)
class AppColors {
  AppColors._();

  // Primary gradient colors
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryGreen = Color(0xFF34A853);
  static const Color primaryYellow = Color(0xFFFBBC05);
  static const Color primaryRed = Color(0xFFEA4335);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryPurple = Color(0xFF9C27B0);

  // Gradient combinations
  static const LinearGradient blueGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF5C9EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [primaryGreen, Color(0xFF4BC460)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [primaryPurple, Color(0xFFBA68C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neutral colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A); // Slightly lighter for better contrast
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A2A); // Lighter card for better visibility

  // Text colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // Pure white for maximum visibility
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFCCCCCC); // Lighter secondary text

  // Feature colors
  static List<Color> featureColors = [
    primaryBlue,
    primaryGreen,
    primaryOrange,
    primaryPurple,
    primaryRed,
    primaryYellow,
  ];

  static List<LinearGradient> featureGradients = [
    blueGradient,
    greenGradient,
    orangeGradient,
    purpleGradient,
    LinearGradient(
      colors: [primaryRed, Color(0xFFFF6B6B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [primaryYellow, Color(0xFFFFD54F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}

