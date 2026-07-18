import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

@immutable
class StoryTextSegment {
  const StoryTextSegment({
    required this.text,
    required this.start,
    required this.end,
    this.entry,
  });

  final String text;
  final int start;
  final int end;
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
  var plainStart = 0;
  var cursor = 0;

  void flushPlainText() {
    if (plainText.isEmpty) return;
    final value = plainText.toString();
    segments.add(
      StoryTextSegment(
        text: value,
        start: plainStart,
        end: plainStart + value.length,
      ),
    );
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
      if (plainText.isEmpty) plainStart = cursor;
      plainText.write(text[cursor]);
      cursor += 1;
      continue;
    }

    flushPlainText();
    segments.add(
      StoryTextSegment(
        text: match.word,
        start: cursor,
        end: cursor + match.word.length,
        entry: match,
      ),
    );
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
        return _InteractiveSegment(
          text: segment.text,
          start: segment.start,
          end: segment.end,
        );
      }

      final recognizer = LongPressGestureRecognizer()
        ..onLongPress = () => widget.onWordLongPress(entry);
      _recognizers.add(recognizer);
      return _InteractiveSegment(
        text: segment.text,
        start: segment.start,
        end: segment.end,
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
    final state = context.watch<AppState>();
    final baseStyle = Theme.of(context).textTheme.bodyLarge;

    return AnimatedBuilder(
      animation: NarrationHighlightBus.instance,
      builder: (context, _) {
        final snapshot = NarrationHighlightBus.instance.snapshot;
        final highlightStart = snapshot?.itemText == widget.text
            ? snapshot!.start
            : -1;
        final highlightEnd = snapshot?.itemText == widget.text
            ? snapshot!.end
            : -1;

        return Text.rich(
          TextSpan(
            style: baseStyle,
            children: _segments.expand((segment) {
              return _buildSegmentSpans(
                segment,
                state: state,
                baseStyle: baseStyle,
                highlightStart: highlightStart,
                highlightEnd: highlightEnd,
              );
            }).toList(growable: false),
          ),
        );
      },
    );
  }

  List<InlineSpan> _buildSegmentSpans(
    _InteractiveSegment segment, {
    required AppState state,
    required TextStyle? baseStyle,
    required int highlightStart,
    required int highlightEnd,
  }) {
    final segmentStyle = segment.entry == null
        ? baseStyle
        : baseStyle?.copyWith(
            color: PhoenixTheme.red,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationColor: PhoenixTheme.gold,
            decorationStyle: TextDecorationStyle.dotted,
            decorationThickness: 1.6,
          );

    final overlapStart = highlightStart.clamp(segment.start, segment.end).toInt();
    final overlapEnd = highlightEnd.clamp(segment.start, segment.end).toInt();
    final hasHighlight = highlightStart >= 0 && overlapEnd > overlapStart;

    if (!hasHighlight) {
      return [
        _span(
          state.displayText(segment.text),
          segment,
          style: segmentStyle,
          state: state,
        ),
      ];
    }

    final beforeLength = overlapStart - segment.start;
    final activeLength = overlapEnd - overlapStart;
    final spans = <InlineSpan>[];

    if (beforeLength > 0) {
      spans.add(
        _span(
          state.displayText(segment.text.substring(0, beforeLength)),
          segment,
          style: segmentStyle,
          state: state,
        ),
      );
    }

    spans.add(
      _span(
        state.displayText(
          segment.text.substring(beforeLength, beforeLength + activeLength),
        ),
        segment,
        style: segmentStyle?.copyWith(
          color: PhoenixTheme.ink,
          backgroundColor: const Color(0xFFFFD879),
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.none,
        ),
        state: state,
      ),
    );

    final afterStart = beforeLength + activeLength;
    if (afterStart < segment.text.length) {
      spans.add(
        _span(
          state.displayText(segment.text.substring(afterStart)),
          segment,
          style: segmentStyle,
          state: state,
        ),
      );
    }

    return spans;
  }

  TextSpan _span(
    String text,
    _InteractiveSegment segment, {
    required TextStyle? style,
    required AppState state,
  }) {
    final entry = segment.entry;
    return TextSpan(
      text: text,
      recognizer: segment.recognizer,
      mouseCursor:
          entry == null ? MouseCursor.defer : SystemMouseCursors.click,
      semanticsLabel: entry == null
          ? null
          : '${state.displayText(entry.word)}，${entry.pinyin}，长按查看词语解释',
      style: style,
    );
  }
}

class _InteractiveSegment {
  const _InteractiveSegment({
    required this.text,
    required this.start,
    required this.end,
    this.entry,
    this.recognizer,
  });

  final String text;
  final int start;
  final int end;
  final WordEntry? entry;
  final LongPressGestureRecognizer? recognizer;
}
