import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages and persists the user's manual theme mode (light, dark, or system).
class ThemeController {
  static const String _prefKeyThemeMode = 'app_theme_mode';

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  /// Initializes the theme mode from SharedPreferences. Defaults to dark mode.
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = prefs.getString(_prefKeyThemeMode);
      if (modeString == 'light') {
        themeMode.value = ThemeMode.light;
      } else if (modeString == 'system') {
        themeMode.value = ThemeMode.system;
      } else {
        themeMode.value = ThemeMode.dark;
      }
    } catch (_) {
      themeMode.value = ThemeMode.dark;
    }
  }

  /// Sets and persists the selected [ThemeMode].
  static Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      String val = 'dark';
      if (mode == ThemeMode.light) {
        val = 'light';
      } else if (mode == ThemeMode.system) {
        val = 'system';
      }
      await prefs.setString(_prefKeyThemeMode, val);
    } catch (_) {}
  }

  /// Toggles between light and dark mode.
  static Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
}
