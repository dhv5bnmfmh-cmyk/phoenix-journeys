from pathlib import Path
import re

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()

story_strip = '''          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'story',
            totalItems: _journeyContent.storyParagraphs.length,
          ),
          const SizedBox(height: 2),
'''
if story_strip not in journey:
    raise SystemExit('story reading strip block not found')
journey = journey.replace(story_strip, '          const SizedBox(height: 3),\n', 1)

discovery_strip = '''          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'discovery',
            totalItems: discoveries.length,
          ),
          const SizedBox(height: 3),
'''
if discovery_strip not in journey:
    raise SystemExit('discovery reading strip block not found')
journey = journey.replace(discovery_strip, '          const SizedBox(height: 3),\n', 1)

journey, count = re.subn(
    r'class _NowReadingStrip extends StatelessWidget \{[\s\S]*?\n\}\n\n(?=class _CompactTextBlock)',
    '',
    journey,
    count=1,
)
if count != 1:
    raise SystemExit(f'_NowReadingStrip removal count: {count}')

journey = journey.replace(
    'const Color(0xFFFFE7A8)',
    'const Color(0xFFFFF2EE)',
)
journey_path.write_text(journey)

interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
old_style = '''          color: const Color(0xFF65130F),
          backgroundColor: const Color(0xFFFFC928),
          fontSize: ((segmentStyle ?? baseStyle)?.fontSize ?? 11) + 1.4,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF781E18),
          decorationThickness: 2.1,
          shadows: const [Shadow(color: Color(0x55FFFFFF), blurRadius: 1)],
'''
new_style = '''          color: Colors.white,
          backgroundColor: const Color(0xFF8F1D18),
          fontSize: ((segmentStyle ?? baseStyle)?.fontSize ?? 11) + 2.2,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.none,
          letterSpacing: .25,
          shadows: const [
            Shadow(color: Color(0x44000000), blurRadius: 1, offset: Offset(0, 1)),
          ],
'''
if old_style not in interactive:
    raise SystemExit('current word style block not found')
interactive = interactive.replace(old_style, new_style, 1)
interactive_path.write_text(interactive)

visual_test = Path('app/test/widgets/interactive_story_text_visual_test.dart')
visual = visual_test.read_text()
visual = visual.replace('_containsYellowHighlight', '_containsActiveHighlight')
visual = visual.replace('const Color(0xFFFFC928)', 'const Color(0xFF8F1D18)')
visual = visual.replace(
    'explicit narration range paints a visible yellow word highlight',
    'explicit narration range paints a visible high-contrast word highlight',
)
visual_test.write_text(visual)

Path('worker/reading_position_visibility.test.mjs').write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery show reading position only inside the text', () => {
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.doesNotMatch(journey, /朗读位置/);
  assert.doesNotMatch(journey, /正在朗读/);
  assert.doesNotMatch(journey, /当前：\$word/);
  assert.equal(
    (journey.match(/highlightStart: isActive \? snapshot!\.start : null/g) ?? [])
      .length,
    2,
  );
});

test('current word is unmistakably different from surrounding text', () => {
  assert.match(journey, /const Color\(0xFFFFF2EE\)/);
  assert.match(journey, /color: active[\s\S]*PhoenixTheme\.red/);
  assert.match(interactive, /color: Colors\.white/);
  assert.match(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.match(interactive, /fontSize:[\s\S]*\+ 2\.2/);
  assert.match(interactive, /fontWeight: FontWeight\.w900/);
});
''')

one_screen_path = Path('worker/one_screen_layout.test.mjs')
one_screen = one_screen_path.read_text()
one_screen = one_screen.replace(
    "  assert.equal((journey.match(/_NowReadingStrip\\(/g) ?? []).length, 3);\n  assert.match(journey, /按播放后，这里会显示当前段落和词语/);\n",
    "  assert.doesNotMatch(journey, /_NowReadingStrip/);\n  assert.doesNotMatch(journey, /朗读位置/);\n",
)
one_screen_path.write_text(one_screen)

explicit_path = Path('worker/explicit_visual_highlight.test.mjs')
explicit = explicit_path.read_text()
explicit = explicit.replace('0xFFFFC928', '0xFF8F1D18')
explicit_path.write_text(explicit)
