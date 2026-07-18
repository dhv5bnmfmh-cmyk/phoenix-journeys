import 'dart:async';

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
    super.key,
  });

  final String text;
  final List<WordEntry> entries;

  @override
  State<InteractiveStoryText> createState() => _InteractiveStoryTextState();
}

class _InteractiveStoryTextState extends State<InteractiveStoryText> {
  final List<TapGestureRecognizer> _recognizers = [];
  late List<_InteractiveSegment> _segments;
  WordEntry? _selectedEntry;
  Timer? _hideTimer;

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
      _selectedEntry = null;
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

      final recognizer = TapGestureRecognizer()..onTap = () => _showEntry(entry);
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

  void _showEntry(WordEntry entry) {
    _hideTimer?.cancel();
    setState(() => _selectedEntry = entry);
    _hideTimer = Timer(const Duration(milliseconds: 3200), () {
      if (mounted && identical(_selectedEntry, entry)) {
        setState(() => _selectedEntry = null);
      }
    });
  }

  void _hideEntry() {
    _hideTimer?.cancel();
    if (_selectedEntry != null) setState(() => _selectedEntry = null);
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final baseStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedEntry = _selectedEntry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
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
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            reverseDuration: const Duration(milliseconds: 130),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: .96, end: 1).animate(animation),
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              );
            },
            child: selectedEntry == null
                ? const SizedBox.shrink(key: ValueKey('word-popover-empty'))
                : Padding(
                    key: ValueKey('word-popover-${selectedEntry.word}'),
                    padding: const EdgeInsets.only(top: 8),
                    child: _VocabularyPopover(
                      entry: selectedEntry,
                      state: state,
                      onClose: _hideEntry,
                    ),
                  ),
          ),
        ),
      ],
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
          : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
      style: style,
    );
  }
}

class _VocabularyPopover extends StatelessWidget {
  const _VocabularyPopover({
    required this.entry,
    required this.state,
    required this.onClose,
  });

  final WordEntry entry;
  final AppState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final nativeDefinition = entry.nativeDefinition(state.translationLanguage);
    final english = entry.englishDefinition.trim();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .55)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.symbol, style: const TextStyle(fontSize: 21)),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.displayText(entry.word),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          entry.pinyin,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: PhoenixTheme.ink.withValues(alpha: .62),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    nativeDefinition,
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                  if (english.isNotEmpty &&
                      state.translationLanguage != '英语') ...[
                    const SizedBox(height: 2),
                    Text(
                      english,
                      style: TextStyle(
                        color: PhoenixTheme.ink.withValues(alpha: .58),
                        fontSize: 11.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              tooltip: '关闭解释',
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 17),
            ),
          ],
        ),
      ),
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
  final TapGestureRecognizer? recognizer;
}
