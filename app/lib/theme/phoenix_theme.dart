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

  // Phoenix Typography Agent contract: journey content must use these tokens.
  // Keeping the tokens here makes destination pages change as one system.
  static const contentPrimary = Colors.white;
  static const contentSecondary = Color(0xFFEADFCB);
  static const contentAccent = Color(0xFFFFD46A);
  static const contentShadow = <Shadow>[
    Shadow(color: Color(0xE6000000), blurRadius: 3, offset: Offset(0, 1)),
    Shadow(color: Color(0x99000000), blurRadius: 8),
  ];

  static const journeyTitleStyle = TextStyle(
    color: contentPrimary,
    fontSize: 16,
    height: 1.15,
    fontWeight: FontWeight.w900,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyBodyStyle = TextStyle(
    color: contentPrimary,
    fontSize: 15,
    height: 1.28,
    fontWeight: FontWeight.w700,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyMetaStyle = TextStyle(
    color: contentSecondary,
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static BoxDecoration destinationGlass({double alpha = .16}) => BoxDecoration(
    color: Colors.black.withValues(alpha: alpha),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: contentAccent.withValues(alpha: .42)),
    boxShadow: const [
      BoxShadow(color: Color(0x24000000), blurRadius: 14, offset: Offset(0, 5)),
    ],
  );

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
