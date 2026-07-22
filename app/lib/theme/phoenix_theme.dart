import 'package:flutter/material.dart';

class PhoenixTheme {
  static const red = Color(0xFF9D1C20);
  static const gold = Color(0xFFC79A43);
  static const ink = Color(0xFF202124);
  static const paper = Color(0xFFF8F2E8);
  static const translation = Color(0xFF476C8B);
  static const ai = Color(0xFF6A4C8C);
  static const chineseFontFamily = 'STKaiti';
  static const chineseFontFallback = <String>[
    'Kaiti SC',
    'KaiTi',
    'DFKai-SB',
    'Noto Serif CJK SC',
    'serif',
  ];

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: red,
        primary: red,
        secondary: gold,
        surface: paper,
      ),
      scaffoldBackgroundColor: paper,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: ink),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(height: 1.65, color: ink),
        bodyMedium: TextStyle(height: 1.55, color: ink),
      ),
    );
  }
}
