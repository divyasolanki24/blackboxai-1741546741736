import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    return _box.read(_key) ?? false;
  }

  void saveThemeMode(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }

  static Color get primaryColor => Get.isDarkMode ? Colors.purple.shade200 : Colors.purple;
  static Color get backgroundColor => Get.isDarkMode ? const Color(0xFF121212) : Colors.white;
  static Color get textColor => Get.isDarkMode ? Colors.white : Colors.black;
}
