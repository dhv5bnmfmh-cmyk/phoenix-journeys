import 'package:flutter/material.dart';

class PhoenixTheme {
  static const red = Color(0xFF9D1C20);
  static const gold = Color(0xFFC79A43);
  static const ink = Color(0xFF202124);
  static const paper = Color(0xFFF8F2E8);
  static const translation = Color(0xFF476C8B);
  static const ai = Color(0xFF6A4C8C);

  // Phoenix Typography Agent: only two font roles are allowed.
  // Display uses a Chinese serif/kaishu face; all reading, pinyin, Latin text,
  // metadata and controls use one clean sans-serif family.
  static const displayFontFamily = 'STKaiti';
  static const displayFontFallback = <String>[
    'Kaiti SC',
    'KaiTi',
    'DFKai-SB',
    'Noto Serif CJK SC',
    'serif',
  ];
  static const chineseFontFamily = 'PingFang SC';
  static const chineseFontFallback = <String>[
    'Noto Sans CJK SC',
    'Microsoft YaHei',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static const pageTitleSize = 18.0;
  static const wordTitleSize = 17.0;
  static const bodySize = 13.0;
  static const metaSize = 11.0;
  static const buttonSize = 14.0;

  // Phoenix Typography Agent contract: journey content must use these tokens.
  // Keeping the tokens here makes destination pages change as one system.
  static const contentPrimary = Colors.white;
  static const contentSecondary = Color(0xFFEADFCB);
  static const contentAccent = Color(0xFFFFD46A);
  static const writingInk = Colors.white;
  static const writingSecondary = Color(0xFFEADFCB);
  static const writingSurface = Color(0x38000000);
  static const contentShadow = <Shadow>[
    Shadow(color: Color(0xE6000000), blurRadius: 3, offset: Offset(0, 1)),
    Shadow(color: Color(0x99000000), blurRadius: 8),
  ];

  static const journeyTitleStyle = TextStyle(
    color: contentPrimary,
    fontSize: pageTitleSize,
    height: 1.15,
    fontWeight: FontWeight.w800,
    fontFamily: displayFontFamily,
    fontFamilyFallback: displayFontFallback,
    shadows: contentShadow,
  );

  static const journeyWordTitleStyle = TextStyle(
    color: contentPrimary,
    fontSize: wordTitleSize,
    height: 1.1,
    fontWeight: FontWeight.w800,
    fontFamily: displayFontFamily,
    fontFamilyFallback: displayFontFallback,
    shadows: contentShadow,
  );

  static const journeyBodyStyle = TextStyle(
    color: contentPrimary,
    fontSize: bodySize,
    height: 1.35,
    fontWeight: FontWeight.w600,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyMetaStyle = TextStyle(
    color: contentSecondary,
    fontSize: metaSize,
    height: 1.25,
    fontWeight: FontWeight.w500,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyButtonStyle = TextStyle(
    fontSize: buttonSize,
    height: 1.1,
    fontWeight: FontWeight.w700,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
  );

  // Think, Express and Journey Memory share one readability contract.
  // These pages sit over changing destination art, so their writing content
  // must never inherit a color from either the image or the global theme.
  static const journeyWritingQuestionStyle = TextStyle(
    color: writingInk,
    fontSize: bodySize,
    height: 1.25,
    fontWeight: FontWeight.w800,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyWritingInputStyle = TextStyle(
    color: writingInk,
    fontSize: bodySize,
    height: 1.4,
    fontWeight: FontWeight.w600,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static const journeyWritingHintStyle = TextStyle(
    color: writingSecondary,
    fontSize: bodySize,
    height: 1.4,
    fontWeight: FontWeight.w500,
    fontFamily: chineseFontFamily,
    fontFamilyFallback: chineseFontFallback,
    shadows: contentShadow,
  );

  static BoxDecoration get journeyWritingPanelDecoration => BoxDecoration(
    color: writingSurface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0x8FC79A43), width: 1.2),
    boxShadow: const [
      BoxShadow(color: Color(0x4D000000), blurRadius: 18, offset: Offset(0, 7)),
    ],
  );

  static InputDecoration journeyWritingInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: journeyWritingHintStyle,
      filled: true,
      fillColor: const Color(0x24000000),
      contentPadding: const EdgeInsets.all(11),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0x8FC79A43)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: contentAccent, width: 1.6),
      ),
      border: const OutlineInputBorder(),
    );
  }

  static BoxDecoration destinationGlass({double alpha = .16}) => BoxDecoration(
    color: Colors.black.withValues(alpha: alpha),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: contentAccent.withValues(alpha: .42)),
    boxShadow: const [
      BoxShadow(color: Color(0x24000000), blurRadius: 14, offset: Offset(0, 5)),
    ],
  );

  // One shared surface for every card inside a journey. Individual pages must
  // not invent their own card color, border, radius, or shadow.
  static BoxDecoration get journeyPanelDecoration => destinationGlass(
    alpha: .30,
  );

  // Vocabulary details return to the original Phoenix golden surface. It is
  // fully opaque so the vocabulary grid and destination image never bleed
  // through the popup.
  static BoxDecoration get journeySolidPanelDecoration => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE0BC63),
        Color(0xFFB8862E),
        Color(0xFF7A4F12),
      ],
      stops: [0, .55, 1],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFFFE39A), width: 1.4),
    boxShadow: const [
      BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, 8)),
    ],
  );

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: red,
        primary: red,
        secondary: gold,
        surface: paper,
      ),
      scaffoldBackgroundColor: paper,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineMedium: journeyTitleStyle.copyWith(color: ink, shadows: const []),
        titleLarge: journeyTitleStyle.copyWith(color: ink, shadows: const []),
        titleMedium: journeyWordTitleStyle.copyWith(color: ink, shadows: const []),
        bodyLarge: journeyBodyStyle.copyWith(color: ink, shadows: const []),
        bodyMedium: journeyBodyStyle.copyWith(color: ink, shadows: const []),
        bodySmall: journeyMetaStyle.copyWith(color: ink, shadows: const []),
        labelLarge: journeyButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: journeyButtonStyle),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(textStyle: journeyButtonStyle),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(textStyle: journeyButtonStyle),
      ),
    );
  }
}
