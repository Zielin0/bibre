import 'package:bibre/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  void setPrefThemeMode(bool isDark) async {
    final pref = await SharedPreferences.getInstance();

    pref.remove('isDark');
    pref.setBool('isDark', isDark);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeColor: Colors.indigo[500],
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);

        setPrefThemeMode(value);
        provider.toggleTheme(value);
      },
    );
  }
}
