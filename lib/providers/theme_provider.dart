import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.dark; // O tema padrão será o escuro

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Lê a preferência salva, ou usa o escuro se for a primeira vez
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.dark.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
    notifyListeners();
  }
}