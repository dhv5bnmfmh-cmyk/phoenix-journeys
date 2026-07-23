import 'dart:async';
import 'dart:ui' show ImageFilter, lerpDouble;

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
int revealedSegmentLength({
  required int segmentStart,
  required int segmentEnd,
  int? revealEnd,
}) {
  if (revealEnd == null) return segmentEnd - segmentStart;
  return revealEnd.clamp(segmentStart, segmentEnd).toInt() - segmentStart;
}

@visibleForTesting
double cinematicRevealProgress({
  required double revealCursor,
  required int characterIndex,
}) {
  final raw = (revealCursor - characterIndex).clamp(0.0, 1.0).toDouble();
  return Curves.easeOutCubic.transform(raw);
}

@visibleForTesting
Duration cinematicRevealDuration(double characterDistance) {
  final milliseconds =
      (210 + characterDistance.abs() * 34).round().clamp(260, 720).toInt();
  return Duration(milliseconds: milliseconds);
}

@visibleForTesting
List<StoryTextSegment> segmentStoryText(String text, List<WordEntry> entries) {
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

@visibleForTesting
bool narrationSnapshotMatches({
  required NarrationHighlightSnapshot? snapshot,
  required String? contentId,
  required String? itemId,
  required String sourceText,
  required String displayedText,
  required String Function(String) displayText,
}) {
  if (snapshot == null) return false;

  if (contentId != null && snapshot.contentId != contentId) return false;
  if (itemId != null) return snapshot.itemId == itemId;

  final source = sourceText.trim();
  final spoken = snapshot.itemText.trim();
  if (source == spoken) return true;
  return displayedText.trim() == displayText(spoken).trim();
}

class InteractiveStoryText extends StatefulWidget {
  const InteractiveStoryText({
    required this.text,
    required this.entries,
    this.style,
    this.onWordLongPress,
    this.narrationContentId,
    this.narrationItemId,
    this.narrationController,
    this.highlightStart,
    this.highlightEnd,
    this.revealEnd,
    super.key,
  });

  final String text;
  final List<WordEntry> entries;
  final TextStyle? style;

  // Kept temporarily for compatibility with older Journey page calls.
  // Story vocabulary now uses tap-only inline meanings and never invokes this.
  final ValueChanged<WordEntry>? onWordLongPress;
  final String? narrationContentId;
  final String? narrationItemId;
  final NarrationController? narrationController;
  final int? highlightStart;
  final int? highlightEnd;
  final int? revealEnd;

  @override
  State<InteractiveStoryText> createState() => _InteractiveStoryTextState();
}

class _InteractiveStoryTextState extends State<InteractiveStoryText>
    with SingleTickerProviderStateMixin {
  final List<TapGestureRecognizer> _recognizers = [];
  late List<_InteractiveSegment> _segments;
  WordEntry? _selectedEntry;
  Timer? _hideTimer;
  late final AnimationController _cinematicRevealController;
  double _revealFrom = 0;
  double _revealTo = 0;

  @override
  void initState() {
    super.initState();
    final initialReveal = _targetRevealCursor(widget.revealEnd);
    _revealFrom = initialReveal;
    _revealTo = initialReveal;
    _cinematicRevealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      value: 1,
    );
    _buildSegments();
  }

  @override
  void didUpdateWidget(covariant InteractiveStoryText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final textChanged = oldWidget.text != widget.text;
    if (textChanged || oldWidget.entries != widget.entries) {
      _disposeRecognizers();
      _selectedEntry = null;
      _buildSegments();
    }

    if (textChanged) {
      _resetRevealTo(widget.revealEnd);
    } else if (oldWidget.revealEnd != widget.revealEnd) {
      _animateRevealTo(widget.revealEnd);
    }
  }

  double _targetRevealCursor(int? revealEnd) {
    return (revealEnd ?? widget.text.length)
        .clamp(0, widget.text.length)
        .toDouble();
  }

  double get _currentRevealCursor {
    final eased = Curves.easeOutCubic.transform(
      _cinematicRevealController.value,
    );
    return lerpDouble(_revealFrom, _revealTo, eased) ?? _revealTo;
  }

  void _resetRevealTo(int? revealEnd) {
    final target = _targetRevealCursor(revealEnd);
    _cinematicRevealController.stop();
    _revealFrom = target;
    _revealTo = target;
    _cinematicRevealController.value = 1;
  }

  void _animateRevealTo(int? revealEnd) {
    final target = _targetRevealCursor(revealEnd);
    final current =
        _currentRevealCursor.clamp(0.0, widget.text.length.toDouble());
    final distance = target - current;

    // Starting a new narration should hide future text immediately. Forward
    // progress is then interpolated continuously between speech callbacks.
    if (distance <= 0.01) {
      _resetRevealTo(revealEnd);
      return;
    }

    _cinematicRevealController.stop();
    _revealFrom = current;
    _revealTo = target;
    _cinematicRevealController.duration = cinematicRevealDuration(distance);
    _cinematicRevealController.forward(from: 0);
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

      final recognizer = TapGestureRecognizer()
        ..onTap = () => _showEntry(entry);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Scrollable.ensureVisible(
        context,
        alignment: .18,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    });
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
    _cinematicRevealController.dispose();
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final baseStyle = widget.style ?? Theme.of(context).textTheme.bodyLarge;
    final selectedEntry = _selectedEntry;
    final Listenable highlightSource =
        widget.narrationController ?? NarrationHighlightBus.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[
            highlightSource,
            _cinematicRevealController,
          ]),
          builder: (context, _) {
            final snapshot = widget.narrationController?.highlightSnapshot ??
                NarrationHighlightBus.instance.snapshot;
            final hasExplicitHighlight = widget.highlightStart != null &&
                widget.highlightEnd != null &&
                widget.highlightEnd! > widget.highlightStart!;
            final isCurrentNarrationItem = hasExplicitHighlight ||
                narrationSnapshotMatches(
                  snapshot: snapshot,
                  contentId: widget.narrationContentId,
                  itemId: widget.narrationItemId,
                  sourceText: widget.text,
                  displayedText: state.displayText(widget.text),
                  displayText: state.displayText,
                );
            final highlightStart = hasExplicitHighlight
                ? widget.highlightStart!
                : isCurrentNarrationItem
                    ? snapshot!.start
                    : -1;
            final highlightEnd = hasExplicitHighlight
                ? widget.highlightEnd!
                : isCurrentNarrationItem
                    ? snapshot!.end
                    : -1;

            return Text.rich(
              key: ValueKey(
                'interactive-highlight-${widget.narrationItemId ?? widget.text}',
              ),
              strutStyle: StrutStyle(
                fontSize: baseStyle?.fontSize,
                height: baseStyle?.height,
                fontWeight: baseStyle?.fontWeight,
                forceStrutHeight: true,
              ),
              TextSpan(
                style: baseStyle,
                children: _segments.expand((segment) {
                  return _buildSegmentSpans(
                    segment,
                    state: state,
                    baseStyle: baseStyle,
                    highlightStart: highlightStart,
                    highlightEnd: highlightEnd,
                    revealCursor: _currentRevealCursor,
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
                    key: ValueKey(
                        'word-popover-auto-visible-${selectedEntry.word}'),
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
    required double revealCursor,
  }) {
    final segmentStyle = segment.entry == null
        ? baseStyle
        : baseStyle?.copyWith(
            color: const Color(0xFFFFD879),
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationStyle: TextDecorationStyle.dotted,
            decorationThickness: 1.6,
            shadows: const [
              Shadow(
                color: Color(0xF0000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
              Shadow(color: Color(0xB3000000), blurRadius: 7),
            ],
          );

    final localCursor = (revealCursor - segment.start)
        .clamp(0.0, segment.text.length.toDouble())
        .toDouble();
    final visibleLength = localCursor.floor();
    final visibleEnd = segment.start + visibleLength;
    final spans = <InlineSpan>[];

    if (visibleLength > 0) {
      final overlapStart =
          highlightStart.clamp(segment.start, visibleEnd).toInt();
      final overlapEnd = highlightEnd.clamp(segment.start, visibleEnd).toInt();
      final hasHighlight = highlightStart >= 0 && overlapEnd > overlapStart;

      if (!hasHighlight) {
        spans.add(
          _span(
            state.displayText(segment.text.substring(0, visibleLength)),
            segment,
            style: segmentStyle,
            state: state,
          ),
        );
      } else {
        final beforeLength = overlapStart - segment.start;
        final activeLength = overlapEnd - overlapStart;

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
          _readingMarkerSpan(
            state.displayText(
              segment.text.substring(
                beforeLength,
                beforeLength + activeLength,
              ),
            ),
            segment,
            style: segmentStyle ?? baseStyle ?? const TextStyle(),
            state: state,
          ),
        );

        final afterStart = beforeLength + activeLength;
        if (afterStart < visibleLength) {
          spans.add(
            _span(
              state.displayText(
                segment.text.substring(afterStart, visibleLength),
              ),
              segment,
              style: segmentStyle,
              state: state,
            ),
          );
        }
      }
    }

    var hiddenStart = visibleLength;
    if (visibleLength < segment.text.length) {
      final characterIndex = segment.start + visibleLength;
      final frontierProgress = cinematicRevealProgress(
        revealCursor: revealCursor,
        characterIndex: characterIndex,
      );
      if (frontierProgress > .001) {
        final isHighlighted = highlightStart >= 0 &&
            characterIndex >= highlightStart &&
            characterIndex < highlightEnd;
        spans.add(
          _cinematicFrontierSpan(
            state.displayText(segment.text[visibleLength]),
            segment,
            style: segmentStyle ?? baseStyle ?? const TextStyle(),
            progress: frontierProgress,
            highlighted: isHighlighted,
          ),
        );
        hiddenStart += 1;
      }
    }

    if (hiddenStart < segment.text.length) {
      final hiddenStyle =
          (segmentStyle ?? baseStyle ?? const TextStyle()).copyWith(
        color: Colors.transparent,
        decoration: TextDecoration.none,
        shadows: const <Shadow>[],
      );
      spans.add(
        _span(
          state.displayText(segment.text.substring(hiddenStart)),
          segment,
          style: hiddenStyle,
          state: state,
          interactive: false,
          hidden: true,
        ),
      );
    }

    return spans;
  }

  WidgetSpan _cinematicFrontierSpan(
    String text,
    _InteractiveSegment segment, {
    required TextStyle style,
    required double progress,
    required bool highlighted,
  }) {
    final entry = segment.entry;
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Semantics(
        label: text,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: entry == null ? null : () => _showEntry(entry),
          child: _CinematicRevealGlyph(
            text: text,
            style: style,
            progress: progress,
            highlighted: highlighted,
          ),
        ),
      ),
    );
  }

  TextSpan _span(
    String text,
    _InteractiveSegment segment, {
    required TextStyle? style,
    required AppState state,
    bool interactive = true,
    bool hidden = false,
  }) {
    final entry = segment.entry;
    return TextSpan(
      text: text,
      recognizer: interactive ? segment.recognizer : null,
      mouseCursor: interactive && entry != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      semanticsLabel: hidden
          ? ''
          : entry == null
              ? null
              : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
      style: style,
    );
  }

  WidgetSpan _readingMarkerSpan(
    String text,
    _InteractiveSegment segment, {
    required TextStyle style,
    required AppState state,
  }) {
    final entry = segment.entry;
    return WidgetSpan(
      // Flutter Web on iPhone can clip content painted below an alphabetic
      // baseline when the surrounding paragraph uses a compact line height.
      // Middle alignment lets the marker reserve its full vertical space.
      alignment: PlaceholderAlignment.middle,
      child: Semantics(
        label: '正在朗读：$text',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: entry == null ? null : () => _showEntry(entry),
          child: _InlineReadingMarker(
            key: ValueKey(
              'reading-triangle-${widget.narrationItemId ?? widget.text}',
            ),
            text: text,
            style: style,
          ),
        ),
      ),
    );
  }
}

class _CinematicRevealGlyph extends StatelessWidget {
  const _CinematicRevealGlyph({
    required this.text,
    required this.style,
    required this.progress,
    required this.highlighted,
  });

  final String text;
  final TextStyle style;
  final double progress;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0).toDouble();
    final blur = (1 - t) * 3.8;
    final lift = (1 - t) * 4.5;
    final baseColor = style.color ?? Colors.white;
    final glowColor = highlighted ? const Color(0xFFFFD879) : baseColor;

    return Transform.translate(
      offset: Offset(0, lift),
      child: Opacity(
        opacity: t,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Text(
            text,
            style: style.copyWith(
              height: style.height ?? 1.22,
              shadows: <Shadow>[
                ...?style.shadows,
                Shadow(
                  color: glowColor.withValues(alpha: .4 * t),
                  blurRadius: 2 + (1 - t) * 8,
                  offset: Offset(0, 1 + (1 - t) * 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineReadingMarker extends StatelessWidget {
  const _InlineReadingMarker({
    required this.text,
    required this.style,
    super.key,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final fontSize = style.fontSize ?? 14;
    final lineHeight = style.height ?? 1.22;
    return SizedBox(
      height: fontSize * lineHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(text, style: style.copyWith(height: lineHeight)),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: CustomPaint(
                size: Size(9, 5),
                painter: _ReadingTrianglePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingTrianglePainter extends CustomPainter {
  const _ReadingTrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final triangle = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      triangle,
      Paint()
        ..color = PhoenixTheme.red
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ReadingTrianglePainter oldDelegate) => false;
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
    final nativeLabel = entry.nativeLabel(state.translationLanguage);
    final nativeDefinition = entry.nativeDefinition(state.translationLanguage);
    final englishDefinition = entry.englishDefinition.trim();

    return Material(
      color: Colors.transparent,
      child: DefaultTextStyle.merge(
        style: PhoenixTheme.journeyBodyStyle,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          decoration: PhoenixTheme.destinationGlass(alpha: .12),
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
                          style: PhoenixTheme.journeyTitleStyle,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            entry.pinyin,
                            overflow: TextOverflow.ellipsis,
                            style: PhoenixTheme.journeyMetaStyle
                                .copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      state.displayText(entry.partOfSpeech),
                      key: ValueKey('story-discovery-word-pos-${entry.word}'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      state.displayText(nativeLabel),
                      key: ValueKey(
                          'story-discovery-word-native-label-${entry.word}'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      nativeDefinition,
                      key:
                          ValueKey('story-discovery-word-native-${entry.word}'),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13, height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'English',
                      key: ValueKey(
                          'story-discovery-word-english-label-${entry.word}'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      englishDefinition.isEmpty ? '—' : englishDefinition,
                      key: ValueKey(
                          'story-discovery-word-english-${entry.word}'),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11.5, height: 1.25),
                    ),
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
