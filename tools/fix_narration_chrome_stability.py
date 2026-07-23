from __future__ import annotations

from pathlib import Path


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected one match, found {count}")
    return text.replace(old, new, 1)


journey_path = Path("app/lib/screens/journey_screen.dart")
journey = journey_path.read_text(encoding="utf-8")

journey = replace_once(
    journey,
    "key: ValueKey('compact-text-$index-${active ? 'active' : 'idle'}'),",
    "key: ValueKey('compact-text-$index'),",
    "stable compact text key",
)
journey = replace_once(
    journey,
    "backgroundColor: const Color(0x99000000),",
    "backgroundColor: active\n                  ? const Color(0xB33A1714)\n                  : const Color(0x99000000),",
    "fixed-size active indicator",
)
journey = replace_once(
    journey,
    "fontWeight:\n                                  isActive ? FontWeight.w900 : FontWeight.w700,",
    "fontWeight: FontWeight.w700,",
    "discovery fixed font weight",
)
journey_path.write_text(journey, encoding="utf-8")

interactive_path = Path("app/lib/widgets/interactive_story_text.dart")
interactive = interactive_path.read_text(encoding="utf-8")

interactive = replace_once(
    interactive,
    """              key: ValueKey(
                'interactive-highlight-${widget.narrationItemId ?? widget.text}',
              ),
              TextSpan(""",
    """              key: ValueKey(
                'interactive-highlight-${widget.narrationItemId ?? widget.text}',
              ),
              strutStyle: StrutStyle(
                fontSize: baseStyle?.fontSize,
                height: baseStyle?.height,
                fontWeight: baseStyle?.fontWeight,
                forceStrutHeight: true,
              ),
              TextSpan(""",
    "fixed narration strut",
)
interactive = replace_once(
    interactive,
    """            style: style.copyWith(
              height: 1,
              shadows: <Shadow>[""",
    """            style: style.copyWith(
              height: style.height ?? 1.22,
              shadows: <Shadow>[""",
    "cinematic glyph line height",
)
interactive = replace_once(
    interactive,
    """  @override
  Widget build(BuildContext context) {
    return Padding(
      // Reserve real layout space for the triangle. Painting below a Text
      // baseline alone is clipped by Flutter Web on iOS Safari.
      padding: const EdgeInsets.only(bottom: 5),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Text(text, style: style.copyWith(height: 1)),
          const Positioned(
            left: 0,
            right: 0,
            bottom: -4,
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
  }""",
    """  @override
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
  }""",
    "reading marker fixed line box",
)
interactive_path.write_text(interactive, encoding="utf-8")

rule_path = Path("worker/narration_layout_stability_rule.test.mjs")
rule_path.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('story and discovery side controls keep stable geometry during narration', () => {
  assert.match(journey, /ValueKey\('compact-text-\$index'\)/);
  assert.doesNotMatch(journey, /compact-text-\$index-\$\{active/);
  assert.match(journey, /fontWeight: FontWeight\.w700/);
  assert.match(journey, /backgroundColor: active/);
});

test('cinematic glyphs and reading marker use one fixed line box', () => {
  assert.match(interactive, /strutStyle: StrutStyle\(/);
  assert.match(interactive, /forceStrutHeight: true/);
  assert.match(interactive, /height: style\.height \?\? 1\.22/);
  assert.match(interactive, /height: fontSize \* lineHeight/);
  assert.doesNotMatch(interactive, /padding: const EdgeInsets\.only\(bottom: 5\)/);
});
""",
    encoding="utf-8",
)
