import 'package:flutter/material.dart';

/// Base class for theme states
abstract class ThemeState {
  const ThemeState();
}

/// Initial theme state (loading saved preference)
class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

/// Theme loaded state with current theme mode
class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;

  const ThemeLoaded({
    required this.themeMode,
    required this.isDarkMode,
  });
}

