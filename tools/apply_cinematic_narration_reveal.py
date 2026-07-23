from pathlib import Path


def replace_once(source: str, old: str, new: str, label: str) -> str:
    if old not in source:
        raise RuntimeError(f"Missing patch anchor: {label}")
    return source.replace(old, new, 1)


interactive_path = Path("app/lib/widgets/interactive_story_text.dart")
source = interactive_path.read_text(encoding="utf-8")

source = replace_once(
    source,
    "import 'dart:async';\n",
    "import 'dart:async';\nimport 'dart:ui' show ImageFilter, lerpDouble;\n",
    "dart ui import",
)

reveal_helper = """@visibleForTesting
int revealedSegmentLength({
  required int segmentStart,
  required int segmentEnd,
  int? revealEnd,
}) {
  if (revealEnd == null) return segmentEnd - segmentStart;
  return revealEnd.clamp(segmentStart, segmentEnd).toInt() - segmentStart;
}
"""
cinematic_helpers = reveal_helper + """

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
  final milliseconds = (210 + characterDistance.abs() * 34)
      .round()
      .clamp(260, 720)
      .toInt();
  return Duration(milliseconds: milliseconds);
}
"""
source = replace_once(
    source,
    reveal_helper,
    cinematic_helpers,
    "cinematic helper functions",
)

source = replace_once(
    source,
    "class _InteractiveStoryTextState extends State<InteractiveStoryText> {",
    "class _InteractiveStoryTextState extends State<InteractiveStoryText>\n    with SingleTickerProviderStateMixin {",
    "ticker provider mixin",
)

source = replace_once(
    source,
    "  Timer? _hideTimer;\n",
    """  Timer? _hideTimer;
  late final AnimationController _cinematicRevealController;
  double _revealFrom = 0;
  double _revealTo = 0;
""",
    "cinematic state fields",
)

source = replace_once(
    source,
    """  @override
  void initState() {
    super.initState();
    _buildSegments();
  }
""",
    """  @override
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
""",
    "init cinematic controller",
)

source = replace_once(
    source,
    """  @override
  void didUpdateWidget(covariant InteractiveStoryText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.entries != widget.entries) {
      _disposeRecognizers();
      _selectedEntry = null;
      _buildSegments();
    }
  }
""",
    """  @override
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
""",
    "update cinematic cursor",
)

source = replace_once(
    source,
    """  void _buildSegments() {
""",
    """  double _targetRevealCursor(int? revealEnd) {
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
    final current = _currentRevealCursor.clamp(0.0, widget.text.length.toDouble());
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
""",
    "cinematic cursor methods",
)

source = replace_once(
    source,
    """  @override
  void dispose() {
    _hideTimer?.cancel();
    _disposeRecognizers();
    super.dispose();
  }
""",
    """  @override
  void dispose() {
    _hideTimer?.cancel();
    _cinematicRevealController.dispose();
    _disposeRecognizers();
    super.dispose();
  }
""",
    "dispose cinematic controller",
)

source = replace_once(
    source,
    "          animation: highlightSource,",
    """          animation: Listenable.merge(<Listenable>[
            highlightSource,
            _cinematicRevealController,
          ]),""",
    "merged narration animation",
)

source = replace_once(
    source,
    "                        revealEnd: widget.revealEnd,",
    "                        revealCursor: _currentRevealCursor,",
    "animated reveal cursor call",
)

function_start = source.index("  List<InlineSpan> _buildSegmentSpans(")
function_end = source.index("  TextSpan _span(", function_start)
new_function = r'''  List<InlineSpan> _buildSegmentSpans(
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
      final overlapStart = highlightStart
          .clamp(segment.start, visibleEnd)
          .toInt();
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

'''
source = source[:function_start] + new_function + source[function_end:]

marker_class = "class _InlineReadingMarker extends StatelessWidget {"
cinematic_class = r'''class _CinematicRevealGlyph extends StatelessWidget {
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
              height: 1,
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

'''
source = replace_once(
    source,
    marker_class,
    cinematic_class + marker_class,
    "cinematic reveal glyph",
)

interactive_path.write_text(source, encoding="utf-8")


test_path = Path("app/test/narration_progressive_reveal_test.dart")
test_source = test_path.read_text(encoding="utf-8")
test_source = replace_once(
    test_source,
    """    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 14),
      5,
    );
  });
""",
    """    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 14),
      5,
    );
  });

  test('cinematic reveal interpolates each glyph with a bounded duration', () {
    expect(
      cinematicRevealProgress(revealCursor: 4, characterIndex: 4),
      0,
    );
    final half = cinematicRevealProgress(
      revealCursor: 4.5,
      characterIndex: 4,
    );
    expect(half, greaterThan(.5));
    expect(half, lessThan(1));
    expect(
      cinematicRevealProgress(revealCursor: 5, characterIndex: 4),
      1,
    );
    expect(cinematicRevealDuration(1).inMilliseconds, 260);
    expect(cinematicRevealDuration(30).inMilliseconds, 720);
  });
""",
    "cinematic Flutter test",
)
test_path.write_text(test_source, encoding="utf-8")

worker_test = Path("worker/cinematic_narration_reveal_rule.test.mjs")
worker_test.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('narration reveal uses cinematic interpolation instead of hard cuts', () => {
  assert.match(interactive, /SingleTickerProviderStateMixin/);
  assert.match(interactive, /AnimationController/);
  assert.match(interactive, /cinematicRevealProgress/);
  assert.match(interactive, /cinematicRevealDuration/);
  assert.match(interactive, /ImageFilter\\.blur/);
  assert.match(interactive, /Transform\\.translate/);
  assert.match(interactive, /Curves\\.easeOutCubic/);
  assert.match(interactive, /Listenable\\.merge/);
});

 test('future text remains layout-stable and non-interactive', () => {
  assert.match(interactive, /color: Colors\\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /hidden: true/);
});
""",
    encoding="utf-8",
)

docs_path = Path("docs/development-workflow.md")
docs = docs_path.read_text(encoding="utf-8")
rule_heading = "## 永久电影级朗读显现准则"
if rule_heading not in docs:
    docs += """

## 永久电影级朗读显现准则

- 故事页与发现页开始朗读后，文字显现不得使用逐字硬切或瞬间跳变。
- 两次语音进度回调之间必须连续插值，新增文字使用淡入、轻微上浮与散焦收束，形成电影字幕式节奏。
- 未朗读文字必须保留原版面位置，但不得显示、交互或进入辅助阅读语义。
- 新一轮朗读开始时可以立即隐藏未来文字；暂停必须保留当前进度，结束后平滑恢复全文。
- 动画最长不得超过 720ms，避免语音进度更新时产生明显拖尾。
"""
    docs_path.write_text(docs, encoding="utf-8")
