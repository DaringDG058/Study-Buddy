import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences prefs;
  final String _key = 'themeMode';
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark mode

  ThemeProvider(this.prefs) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final theme = prefs.getString(_key);
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs.setString(_key, isDark ? 'dark' : 'light');
    notifyListeners();
  }
}