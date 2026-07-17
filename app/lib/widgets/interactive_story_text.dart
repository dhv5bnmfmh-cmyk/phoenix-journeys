import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/journey_data.dart';
import '../theme/phoenix_theme.dart';

@immutable
class StoryTextSegment {
  const StoryTextSegment({required this.text, this.entry});

  final String text;
  final WordEntry? entry;

  bool get isVocabulary => entry != null;
}

@visibleForTesting
List<StoryTextSegment> segmentStoryText(
  String text,
  List<WordEntry> entries,
) {
  final sortedEntries = List<WordEntry>.of(entries)
    ..sort((a, b) => b.word.length.compareTo(a.word.length));
  final segments = <StoryTextSegment>[];
  final plainText = StringBuffer();
  var cursor = 0;

  void flushPlainText() {
    if (plainText.isEmpty) return;
    segments.add(StoryTextSegment(text: plainText.toString()));
    plainText.clear();
  }

  while (cursor < text.length) {
    WordEntry? match;
    for (final entry in sortedEntries) {
      if (text.startsWith(entry.word, cursor)) {
        match = entry;
        break;
      }
    }

    if (match == null) {
      plainText.write(text[cursor]);
      cursor += 1;
      continue;
    }

    flushPlainText();
    segments.add(StoryTextSegment(text: match.word, entry: match));
    cursor += match.word.length;
  }

  flushPlainText();
  return segments;
}

class InteractiveStoryText extends StatefulWidget {
  const InteractiveStoryText({
    required this.text,
    required this.entries,
    required this.onWordLongPress,
    super.key,
  });

  final String text;
  final List<WordEntry> entries;
  final ValueChanged<WordEntry> onWordLongPress;

  @override
  State<InteractiveStoryText> createState() => _InteractiveStoryTextState();
}

class _InteractiveStoryTextState extends State<InteractiveStoryText> {
  final List<LongPressGestureRecognizer> _recognizers = [];
  late List<_InteractiveSegment> _segments;

  @override
  void initState() {
    super.initState();
    _buildSegments();
  }

  @override
  void didUpdateWidget(covariant InteractiveStoryText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.entries != widget.entries) {
      _disposeRecognizers();
      _buildSegments();
    }
  }

  void _buildSegments() {
    _segments = segmentStoryText(widget.text, widget.entries).map((segment) {
      final entry = segment.entry;
      if (entry == null) {
        return _InteractiveSegment(text: segment.text);
      }

      final recognizer = LongPressGestureRecognizer()
        ..onLongPress = () => widget.onWordLongPress(entry);
      _recognizers.add(recognizer);
      return _InteractiveSegment(
        text: segment.text,
        entry: entry,
        recognizer: recognizer,
      );
    }).toList(growable: false);
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge;

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: _segments.map((segment) {
          final entry = segment.entry;
          if (entry == null) {
            return TextSpan(text: segment.text);
          }

          return TextSpan(
            text: segment.text,
            recognizer: segment.recognizer,
            mouseCursor: SystemMouseCursors.click,
            semanticsLabel: '${entry.word}，${entry.pinyin}，长按查看词语解释',
            style: baseStyle?.copyWith(
              color: PhoenixTheme.red,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: PhoenixTheme.gold,
              decorationStyle: TextDecorationStyle.dotted,
              decorationThickness: 1.6,
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _InteractiveSegment {
  const _InteractiveSegment({
    required this.text,
    this.entry,
    this.recognizer,
  });

  final String text;
  final WordEntry? entry;
  final LongPressGestureRecognizer? recognizer;
}
