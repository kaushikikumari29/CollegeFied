import 'package:flutter/material.dart';

class AppTextStyles {
  // FontWeight map
  static const Map<int, FontWeight> _fontWeights = {
    400: FontWeight.w400,
    500: FontWeight.w500,
    600: FontWeight.w600,
    900: FontWeight.w900,
  };

  // Dynamic method to get TextStyle
  static TextStyle style({
    required double fontSize,
    required int weight,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: _fontWeights[weight] ?? FontWeight.normal,
    );
  }

  // Predefined combinations for convenience
  static const TextStyle f10w400 = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle f10w500 = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
  static const TextStyle f10w600 = TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
  static const TextStyle f10w900 = TextStyle(fontSize: 10, fontWeight: FontWeight.w900);

  static const TextStyle f12w400 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const TextStyle f12w500 = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle f12w600 = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static const TextStyle f12w900 = TextStyle(fontSize: 12, fontWeight: FontWeight.w900);

  static const TextStyle f14w400 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle f14w500 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle f14w600 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle f14w900 = TextStyle(fontSize: 14, fontWeight: FontWeight.w900);

  static const TextStyle f16w400 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle f16w500 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle f16w600 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle f16w900 = TextStyle(fontSize: 16, fontWeight: FontWeight.w900);

  static const TextStyle f18w400 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static const TextStyle f18w500 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const TextStyle f18w600 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle f18w900 = TextStyle(fontSize: 18, fontWeight: FontWeight.w900);

  static const TextStyle f20w400 = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  static const TextStyle f20w500 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle f20w600 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const TextStyle f20w900 = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);

  static const TextStyle f22w400 = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
  static const TextStyle f22w500 = TextStyle(fontSize: 22, fontWeight: FontWeight.w500);
  static const TextStyle f22w600 = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  static const TextStyle f22w900 = TextStyle(fontSize: 22, fontWeight: FontWeight.w900);

  static const TextStyle f24w400 = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static const TextStyle f24w500 = TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
  static const TextStyle f24w600 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle f24w900 = TextStyle(fontSize: 24, fontWeight: FontWeight.w900);

  static const TextStyle f26w400 = TextStyle(fontSize: 26, fontWeight: FontWeight.w400);
  static const TextStyle f26w500 = TextStyle(fontSize: 26, fontWeight: FontWeight.w500);
  static const TextStyle f26w600 = TextStyle(fontSize: 26, fontWeight: FontWeight.w600);
  static const TextStyle f26w900 = TextStyle(fontSize: 26, fontWeight: FontWeight.w900);

  static const TextStyle f28w400 = TextStyle(fontSize: 28, fontWeight: FontWeight.w400);
  static const TextStyle f28w500 = TextStyle(fontSize: 28, fontWeight: FontWeight.w500);
  static const TextStyle f28w600 = TextStyle(fontSize: 28, fontWeight: FontWeight.w600);
  static const TextStyle f28w900 = TextStyle(fontSize: 28, fontWeight: FontWeight.w900);

  static const TextStyle f30w400 = TextStyle(fontSize: 30, fontWeight: FontWeight.w400);
  static const TextStyle f30w500 = TextStyle(fontSize: 30, fontWeight: FontWeight.w500);
  static const TextStyle f30w600 = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const TextStyle f30w900 = TextStyle(fontSize: 30, fontWeight: FontWeight.w900);

  static const TextStyle f32w400 = TextStyle(fontSize: 32, fontWeight: FontWeight.w400);
  static const TextStyle f32w500 = TextStyle(fontSize: 32, fontWeight: FontWeight.w500);
  static const TextStyle f32w600 = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
  static const TextStyle f32w900 = TextStyle(fontSize: 32, fontWeight: FontWeight.w900);
}
