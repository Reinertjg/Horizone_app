import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Get the current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Check if the current theme is dark mode.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize the theme provider.
  ThemeProvider() {
    _loadTheme();
  }

  /// Toggle the theme mode.
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  /// Set the theme mode.
  void setTheme(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _saveTheme(mode);
    notifyListeners();
  }

  /// Load the theme from shared preferences.
  Future<void> _loadTheme() async {
    final perfs = await SharedPreferences.getInstance();
    final isDarkMode = perfs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Save the theme to shared preferences.
  Future<void> _saveTheme(ThemeMode mode) async {
    final perfs = await SharedPreferences.getInstance();
    await perfs.setBool('isDarkMode', mode == ThemeMode.dark);
  }
}
