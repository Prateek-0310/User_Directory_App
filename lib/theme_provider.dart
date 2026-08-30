import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isInitialized => _isInitialized;

  void initTheme(Brightness systemBrightness) {
    if (!_isInitialized) {
      // Invert theme: If phone is dark mode -> app opens in light mode
      _themeMode = (systemBrightness == Brightness.dark)
          ? ThemeMode.light
          : ThemeMode.dark;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
