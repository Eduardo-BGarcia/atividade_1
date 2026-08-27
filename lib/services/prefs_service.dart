import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static const String _keyFocusTime = 'focus_time';
  static const String _keyBreakTime = 'break_time';
  static const String _keyCycles = 'completed_cycles';
  static const String _keyIsDarkMode = 'is_dark_mode';

  static final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value = isDarkMode;
  }

  static bool get isDarkMode => _prefs.getBool(_keyIsDarkMode) ?? false;
  
  static Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyIsDarkMode, value);
    isDarkModeNotifier.value = value;
  }

  static int get focusTime => _prefs.getInt(_keyFocusTime) ?? 25;
  static Future<void> setFocusTime(int minutes) async {
    await _prefs.setInt(_keyFocusTime, minutes);
  }

  static int get breakTime => _prefs.getInt(_keyBreakTime) ?? 5;
  static Future<void> setBreakTime(int minutes) async {
    await _prefs.setInt(_keyBreakTime, minutes);
  }

  static int get completedCycles => _prefs.getInt(_keyCycles) ?? 0;
  static Future<void> incrementCycle() async {
    final currentCycles = completedCycles;
    await _prefs.setInt(_keyCycles, currentCycles + 1);
  }
}