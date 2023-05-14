import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:system_theme/system_theme.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _themeMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
