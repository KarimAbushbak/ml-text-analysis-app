import 'package:flutter/material.dart';

/// Centralized dimension constants for the entire app
/// All width, height, padding, margin, and spacing values should be defined here
class AppDimensions {
  AppDimensions._(); // Private constructor to prevent instantiation

  // Spacing (SizedBox heights/widths)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Padding
  static const EdgeInsets padding4 = EdgeInsets.all(4.0);
  static const EdgeInsets padding8 = EdgeInsets.all(8.0);
  static const EdgeInsets padding12 = EdgeInsets.all(12.0);
  static const EdgeInsets padding16 = EdgeInsets.all(16.0);
  static const EdgeInsets padding20 = EdgeInsets.all(20.0);

  // Horizontal Padding
  static const EdgeInsets paddingHorizontal8 = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets paddingHorizontal12 = EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets paddingHorizontal20 = EdgeInsets.symmetric(horizontal: 20.0);

  // Vertical Padding
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets paddingVertical12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets paddingVertical20 = EdgeInsets.symmetric(vertical: 20.0);

  // Symmetric Padding
  static const EdgeInsets paddingSymmetric12 = EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0);
  static const EdgeInsets paddingSymmetric16 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
  static const EdgeInsets paddingSymmetric20 = EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0);

  // Margin
  static const EdgeInsets margin4 = EdgeInsets.all(4.0);
  static const EdgeInsets margin8 = EdgeInsets.all(8.0);
  static const EdgeInsets margin12 = EdgeInsets.all(12.0);
  static const EdgeInsets margin16 = EdgeInsets.all(16.0);
  static const EdgeInsets margin20 = EdgeInsets.all(20.0);

  // Bottom Margin
  static const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: 12.0);

  // Right Margin/Padding
  static const EdgeInsets marginRight20 = EdgeInsets.only(right: 20.0);
  static const EdgeInsets paddingRight20 = EdgeInsets.only(right: 20.0);

  // Button Dimensions
  static const double buttonHeight = 56.0;
  static const double buttonWidth = double.infinity;
  static const double buttonBorderRadius = 12.0;
  static const double buttonIconSize = 24.0;

  // Icon Sizes
  static const double iconSize16 = 16.0;
  static const double iconSize20 = 20.0;
  static const double iconSize24 = 24.0;
  static const double iconSize64 = 64.0;
  static const double iconSize80 = 80.0;

  // Loading Indicator
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorStrokeWidth = 2.0;
  static const double loadingIndicatorDotSize = 8.0;
  static const double loadingIndicatorDotSpacing = 3.0;

  // Text Input Field
  static const double textInputBorderRadius = 12.0;
  static const double textInputContentPadding = 16.0;
  static const int textInputMaxLinesDefault = 5;
  static const int textInputMaxLines6 = 6;
  static const int textInputMaxLines8 = 8;
  static const int textInputMaxLines10 = 10;
  static const int textInputMaxLength500 = 500;
  static const int textInputMaxLength2000 = 2000;

  // Card Dimensions
  static const double cardBorderRadius = 12.0;
  static const double cardBorderRadius8 = 8.0;
  static const double cardElevation = 2.0;
  static const double cardPadding = 16.0;

  // Grid Dimensions (Home Screen)
  static const int gridCrossAxisCount = 2;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridMainAxisSpacing = 16.0;
  static const double gridChildAspectRatio = 0.85;

  // Divider
  static const double dividerHeight = 1.5;

  // Border Radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;

  // Shadow
  static const double shadowBlurRadius = 12.0;
  static const Offset shadowOffset = Offset(0, 4);

  // Font Sizes
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;

  // Font Weights
  static const FontWeight fontWeight500 = FontWeight.w500;
  static const FontWeight fontWeight600 = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.bold;

  // Snackbar Duration
  static const Duration snackbarDuration = Duration(seconds: 2);

  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
}

