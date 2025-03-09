import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/theme/theme_service.dart';

class ThemeController extends GetxController {
  final _themeService = ThemeService();
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _themeService.isSavedDarkMode();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _themeService.saveThemeMode(isDarkMode.value);
  }

  Color get primaryColor => ThemeService.primaryColor;
  Color get backgroundColor => ThemeService.backgroundColor;
  Color get textColor => ThemeService.textColor;
}
