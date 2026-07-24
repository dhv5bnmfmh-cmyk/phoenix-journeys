from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BRANCH_FILES = {
    "background": ROOT / "app/lib/widgets/destination_background.dart",
    "interactive": ROOT / "app/lib/widgets/interactive_story_text.dart",
    "reveal_test": ROOT / "app/test/narration_progressive_reveal_test.dart",
    "background_test": ROOT / "app/test/summer_palace_dynamic_background_test.dart",
    "cinematic_rule": ROOT / "worker/cinematic_narration_reveal_rule.test.mjs",
    "background_rule": ROOT / "worker/summer_palace_dynamic_background_rule.test.mjs",
    "docs": ROOT / "docs/development-workflow.md",
}


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected one match, found {count}")
    return text.replace(old, new, 1)


def remove_water_ripples() -> None:
    path = BRANCH_FILES["background"]
    text = path.read_text(encoding="utf-8")
    text = text.replace("import 'dart:math' as math;\n\n", "", 1)
    text = replace_once(
        text,
        "                      _SummerPalaceWaterRipples(progress: progress),\n",
        "",
        "water ripple layer",
    )
    pattern = re.compile(
        r"\nclass _SummerPalaceWaterRipples extends StatelessWidget \{.*?\nclass _SummerPalaceForegroundBreath extends StatelessWidget \{",
        re.S,
    )
    text, count = pattern.subn(
        "\nclass _SummerPalaceForegroundBreath extends StatelessWidget {",
        text,
        count=1,
    )
    if count != 1:
        raise SystemExit(f"water ripple classes: expected one match, found {count}")
    path.write_text(text, encoding="utf-8")


def refine_text_reveal() -> None:
    path = BRANCH_FILES["interactive"]
    text = path.read_text(encoding="utf-8")

    old_progress = """@visibleForTesting
double cinematicRevealProgress({
  required double revealCursor,
  required int characterIndex,
}) {
  final raw = (revealCursor - characterIndex).clamp(0.0, 1.0).toDouble();
  return Curves.easeOutCubic.transform(raw);
}
"""
    new_progress = """const int cinematicRevealTailLength = 6;

@visibleForTesting
double cinematicDepthProgress({
  required double revealCursor,
  required int characterIndex,
  int tailLength = cinematicRevealTailLength,
}) {
  final safeTailLength = tailLength.clamp(1, 12).toInt();
  final raw = ((revealCursor - characterIndex) / safeTailLength)
      .clamp(0.0, 1.0)
      .toDouble();
  return Curves.easeOutCubic.transform(raw);
}

@visibleForTesting
double cinematicRevealProgress({
  required double revealCursor,
  required int characterIndex,
}) {
  return cinematicDepthProgress(
    revealCursor: revealCursor,
    characterIndex: characterIndex,
    tailLength: 1,
  );
}
"""
    text = replace_once(text, old_progress, new_progress, "cinematic depth helper")

    text = replace_once(
        text,
        """  double _targetRevealCursor(int? revealEnd) {
    return (revealEnd ?? widget.text.length)
        .clamp(0, widget.text.length)
        .toDouble();
  }
""",
        """  double _targetRevealCursor(int? revealEnd) {
    final resolved = (revealEnd ?? widget.text.length).clamp(
      0,
      widget.text.length,
    );
    if (resolved >= widget.text.length) {
      return (widget.text.length + cinematicRevealTailLength).toDouble();
    }
    return resolved.toDouble();
  }
""",
        "full text depth cursor",
    )
    text = replace_once(
        text,
        """    final current =
        _currentRevealCursor.clamp(0.0, widget.text.length.toDouble());
""",
        """    final current = _currentRevealCursor.clamp(
      0.0,
      (widget.text.length + cinematicRevealTailLength).toDouble(),
    );
""",
        "reveal cursor clamp",
    )

    start = text.index("  List<InlineSpan> _buildSegmentSpans(")
    end = text.index("  WidgetSpan _cinematicFrontierSpan(", start)
    replacement = """  List<InlineSpan> _buildSegmentSpans(
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
    final effectiveStyle = segmentStyle ?? baseStyle ?? const TextStyle();
    final localCursor = (revealCursor - segment.start)
        .clamp(
          0.0,
          segment.text.length.toDouble() + cinematicRevealTailLength,
        )
        .toDouble();
    final visibleLength = localCursor
        .floor()
        .clamp(0, segment.text.length)
        .toInt();
    final stableLength = (visibleLength - cinematicRevealTailLength)
        .clamp(0, segment.text.length)
        .toInt();
    final stableEnd = segment.start + stableLength;
    final spans = <InlineSpan>[];

    if (stableLength > 0) {
      final overlapStart =
          highlightStart.clamp(segment.start, stableEnd).toInt();
      final overlapEnd = highlightEnd.clamp(segment.start, stableEnd).toInt();
      final hasHighlight = highlightStart >= 0 && overlapEnd > overlapStart;

      if (!hasHighlight) {
        spans.add(
          _span(
            state.displayText(segment.text.substring(0, stableLength)),
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
            style: effectiveStyle,
            state: state,
          ),
        );

        final afterStart = beforeLength + activeLength;
        if (afterStart < stableLength) {
          spans.add(
            _span(
              state.displayText(
                segment.text.substring(afterStart, stableLength),
              ),
              segment,
              style: segmentStyle,
              state: state,
            ),
          );
        }
      }
    }

    var hiddenStart = stableLength;
    for (var localIndex = stableLength;
        localIndex < segment.text.length;
        localIndex += 1) {
      final characterIndex = segment.start + localIndex;
      final depthProgress = cinematicDepthProgress(
        revealCursor: revealCursor,
        characterIndex: characterIndex,
      );
      if (depthProgress <= .001) break;
      final isHighlighted = highlightStart >= 0 &&
          characterIndex >= highlightStart &&
          characterIndex < highlightEnd;
      spans.add(
        _cinematicFrontierSpan(
          state.displayText(segment.text[localIndex]),
          segment,
          style: effectiveStyle,
          progress: depthProgress,
          highlighted: isHighlighted,
        ),
      );
      hiddenStart = localIndex + 1;
    }

    if (hiddenStart < segment.text.length) {
      final hiddenStyle = effectiveStyle.copyWith(
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

"""
    text = text[:start] + replacement + text[end:]

    glyph_pattern = re.compile(
        r"class _CinematicRevealGlyph extends StatelessWidget \{.*?\nclass _InlineReadingMarker extends StatelessWidget \{",
        re.S,
    )
    new_glyph = """class _CinematicRevealGlyph extends StatelessWidget {
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
    final contrast = Curves.easeInOutCubic.transform(t);
    final blur = (1 - t) * 2.8;
    final lift = (1 - t) * 3.2;
    final opacity = lerpDouble(.28, 1, t) ?? 1;
    final finalColor = style.color ?? Colors.white;
    final paleColor = highlighted
        ? const Color(0xFFFFE7AA)
        : const Color(0xFFD8D0C2);
    final cinematicColor = Color.lerp(paleColor, finalColor, contrast) ??
        finalColor;
    final fontSize = style.fontSize ?? 14;
    final lineHeight = style.height ?? 1.22;

    return Transform.translate(
      offset: Offset(0, lift),
      child: Opacity(
        opacity: opacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: SizedBox(
            height: fontSize * lineHeight,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: highlighted ? 3 : 0),
                  child: Text(
                    text,
                    style: style.copyWith(
                      color: cinematicColor,
                      height: lineHeight,
                      shadows: <Shadow>[
                        ...?style.shadows,
                        Shadow(
                          color: cinematicColor.withValues(
                            alpha: .14 + .18 * t,
                          ),
                          blurRadius: 2 + (1 - t) * 7,
                          offset: Offset(0, 1 + (1 - t)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (highlighted)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: CustomPaint(
                        size: Size(7, 4),
                        painter: _ReadingTrianglePainter(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineReadingMarker extends StatelessWidget {"""
    text, count = glyph_pattern.subn(new_glyph, text, count=1)
    if count != 1:
        raise SystemExit(f"cinematic glyph: expected one match, found {count}")

    path.write_text(text, encoding="utf-8")


def update_tests_and_rules() -> None:
    reveal_test = BRANCH_FILES["reveal_test"]
    text = reveal_test.read_text(encoding="utf-8")
    marker = """    expect(cinematicRevealDuration(30).inMilliseconds, 720);
  });
"""
    addition = """    expect(cinematicRevealDuration(30).inMilliseconds, 720);
  });

  test('cinematic reveal keeps a pale-to-deep six-character tail', () {
    expect(
      cinematicDepthProgress(revealCursor: 8, characterIndex: 8),
      0,
    );
    final fresh = cinematicDepthProgress(
      revealCursor: 8.5,
      characterIndex: 8,
    );
    final deepening = cinematicDepthProgress(
      revealCursor: 11,
      characterIndex: 8,
    );
    expect(fresh, greaterThan(0));
    expect(fresh, lessThan(.5));
    expect(deepening, greaterThan(fresh));
    expect(
      cinematicDepthProgress(revealCursor: 14, characterIndex: 8),
      1,
    );
  });
"""
    text = replace_once(text, marker, addition, "cinematic depth test")
    reveal_test.write_text(text, encoding="utf-8")

    background_test = BRANCH_FILES["background_test"]
    text = background_test.read_text(encoding="utf-8")
    text = re.sub(
        r"\n    expect\(\n      find\.byKey\(const ValueKey\('summer-palace-water-ripples'\)\),\n      findsOneWidget,\n    \);",
        "",
        text,
        count=1,
    )
    background_test.write_text(text, encoding="utf-8")

    cinematic_rule = BRANCH_FILES["cinematic_rule"]
    text = cinematic_rule.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "  assert.match(interactive, /cinematicRevealProgress/);\n",
        "  assert.match(interactive, /cinematicRevealProgress/);\n"
        "  assert.match(interactive, /cinematicDepthProgress/);\n"
        "  assert.match(interactive, /cinematicRevealTailLength = 6/);\n"
        "  assert.match(interactive, /Color\\.lerp\\(paleColor, finalColor/);\n"
        "  assert.match(interactive, /lerpDouble\\(\\.28, 1, t\\)/);\n",
        "cinematic rule depth assertions",
    )
    cinematic_rule.write_text(text, encoding="utf-8")

    background_rule = BRANCH_FILES["background_rule"]
    text = background_rule.read_text(encoding="utf-8")
    text = text.replace(
        "  assert.match(widget, /summer-palace-water-ripples/);\n",
        "  assert.doesNotMatch(widget, /summer-palace-water-ripples|_SummerPalaceRipplePainter/);\n",
        1,
    )
    background_rule.write_text(text, encoding="utf-8")

    docs = BRANCH_FILES["docs"]
    text = docs.read_text(encoding="utf-8")
    marker = "- 朗读跨越段落分隔符时，即使语音引擎短暂不给出高亮快照，也不得把全文显现进度清零或产生整页闪烁。\n"
    addition = (
        marker
        + "- 新显现文字必须保留约六个字的电影字幕尾迹：先以浅灰金、低对比和轻微虚焦出现，再连续沉到正文最终颜色；禁止单字硬切到最终颜色。\n"
        + "- 颐和园强化背景保留镜头、天空光影、湖面反光与前景呼吸，但不叠加人工水波纹线条，避免抢夺短文注意力。\n"
    )
    if "约六个字的电影字幕尾迹" not in text:
        text = replace_once(text, marker, addition, "development rules")
    docs.write_text(text, encoding="utf-8")


def main() -> None:
    remove_water_ripples()
    refine_text_reveal()
    update_tests_and_rules()


if __name__ == "__main__":
    main()
