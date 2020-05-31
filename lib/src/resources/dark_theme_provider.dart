import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:moska_app/src/utils/dark_theme_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  static var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool _darkTheme = brightness == Brightness.dark;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
  debugPrint(_darkTheme.toString());
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}