import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class WordMark extends StatelessWidget {
  const WordMark({
    required this.word,
    this.size = 44,
    super.key,
  });

  final String word;
  final double size;

  String get _label {
    final value = word.trim();
    if (value.isEmpty) return '词';
    return value.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PhoenixTheme.red.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(size * .32),
        border: Border.all(
          color: PhoenixTheme.red.withValues(alpha: .14),
        ),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: PhoenixTheme.red,
          fontSize: size * .42,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
