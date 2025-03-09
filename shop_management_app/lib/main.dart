import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/theme/theme_service.dart';
import 'package:shop_management_app/core/theme/app_theme.dart';
import 'package:shop_management_app/routes/app_pages.dart';
import 'package:shop_management_app/core/bindings/initial_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shop Management App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeService().getThemeMode(),
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
