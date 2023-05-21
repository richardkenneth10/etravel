import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';

class ETravelTheme {
  static final _light = ThemeData.light().copyWith(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: AppColors.primary,
        highlightColor: AppColors.primary,
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
      ),
      useMaterial3: true);

  static ThemeData get light => _light.copyWith();
}
