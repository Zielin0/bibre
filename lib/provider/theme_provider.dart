import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  setThemeFromLocal() async {
    final pref = await SharedPreferences.getInstance();
    bool isDark = pref.getBool('isDark') ?? false;

    toggleTheme(isDark);
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class BibreTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light().copyWith(secondary: Colors.indigo),
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black, opacity: 1),
    secondaryHeaderColor: Colors.black,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.indigo),
    primaryColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white, opacity: 1),
    secondaryHeaderColor: Colors.white,
  );
}
