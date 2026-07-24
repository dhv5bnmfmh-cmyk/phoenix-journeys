from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INTERACTIVE = ROOT / 'app/lib/widgets/interactive_story_text.dart'
LAYOUT_RULE = ROOT / 'worker/narration_layout_stability_rule.test.mjs'


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


text = INTERACTIVE.read_text(encoding='utf-8')
text = replace_once(
    text,
    """          child: _CinematicRevealGlyph(
            text: text,
""",
    """          child: _CinematicRevealGlyph(
            key: highlighted
                ? ValueKey(
                    'reading-triangle-${widget.narrationItemId ?? widget.text}',
                  )
                : null,
            text: text,
""",
    'cinematic marker key',
)
text = replace_once(
    text,
    """  const _CinematicRevealGlyph({
    required this.text,
    required this.style,
    required this.progress,
    required this.highlighted,
  });
""",
    """  const _CinematicRevealGlyph({
    required this.text,
    required this.style,
    required this.progress,
    required this.highlighted,
    super.key,
  });
""",
    'cinematic glyph key constructor',
)
INTERACTIVE.write_text(text, encoding='utf-8')

rule = LAYOUT_RULE.read_text(encoding='utf-8')
rule = replace_once(
    rule,
    "  assert.match(interactive, /height: style\\.height \\?\\? 1\\.22/);\n",
    "  assert.match(interactive, /final lineHeight = style\\.height \\?\\? 1\\.22/);\n",
    'layout line-height rule',
)
LAYOUT_RULE.write_text(rule, encoding='utf-8')
