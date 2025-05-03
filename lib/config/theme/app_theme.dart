import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      error: AppColors.error,
      secondary: AppColors.success,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );
}
