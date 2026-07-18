import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class WordMark extends StatelessWidget {
  const WordMark({
    required this.word,
    this.size = 44,
    super.key,
  });

  final String word;
  final double size;

  String _label(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '词';
    return trimmed.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final displayWord = state.displayText(word);

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
        _label(displayWord),
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
