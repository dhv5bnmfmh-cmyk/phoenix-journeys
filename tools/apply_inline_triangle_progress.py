from pathlib import Path
import re

# 1) Ignore stalled/regressive Safari progress callbacks.
controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
old_progress = '''      final globalStart = _speechBaseOffset + startOffset;
      final globalEnd = _speechBaseOffset + endOffset;
      _lastNativeOffset = globalStart;
      _lastNativeProgressAt = DateTime.now();
      _estimateAnchorTime = _lastNativeProgressAt;
      _estimateAnchorOffset = globalStart;
      _applyProgress(
        globalStart,
        endOffset: globalEnd,
        word: word.isNotEmpty ? word : wordText,
      );
'''
new_progress = '''      final globalStart = _speechBaseOffset + startOffset;
      final globalEnd = _speechBaseOffset + endOffset;

      // Safari can repeatedly report offset 0 while speech is already moving.
      // Never allow a stale native callback to pull Phoenix progress backwards,
      // and only mark native progress as fresh when it truly advances.
      if (globalStart < _currentOffset) return;
      final nativeAdvanced = globalStart > _lastNativeOffset;
      if (nativeAdvanced) {
        final now = DateTime.now();
        _lastNativeOffset = globalStart;
        _lastNativeProgressAt = now;
        _estimateAnchorTime = now;
        _estimateAnchorOffset = globalStart;
      }
      _applyProgress(
        globalStart,
        endOffset: globalEnd,
        word: word.isNotEmpty ? word : wordText,
      );
'''
if old_progress not in controller:
    raise SystemExit('native progress handler not found')
controller_path.write_text(controller.replace(old_progress, new_progress, 1))

# 2) Replace color-changing highlight with an inline triangle marker.
interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
old_active = '''    spans.add(
      _span(
        state.displayText(
          segment.text.substring(beforeLength, beforeLength + activeLength),
        ),
        segment,
        style: (segmentStyle ?? baseStyle ?? const TextStyle()).copyWith(
          color: Colors.white,
          backgroundColor: const Color(0xFF8F1D18),
          fontSize: ((segmentStyle ?? baseStyle)?.fontSize ?? 11) + 2.2,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.none,
          letterSpacing: .25,
          shadows: const [
            Shadow(
              color: Color(0x44000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        state: state,
      ),
    );
'''
new_active = '''    spans.add(
      _readingMarkerSpan(
        state.displayText(
          segment.text.substring(beforeLength, beforeLength + activeLength),
        ),
        segment,
        style: segmentStyle ?? baseStyle ?? const TextStyle(),
        state: state,
      ),
    );
'''
if old_active not in interactive:
    raise SystemExit('active color highlight block not found')
interactive = interactive.replace(old_active, new_active, 1)

old_span_end = '''  TextSpan _span(
    String text,
    _InteractiveSegment segment, {
    required TextStyle? style,
    required AppState state,
  }) {
    final entry = segment.entry;
    return TextSpan(
      text: text,
      recognizer: segment.recognizer,
      mouseCursor: entry == null ? MouseCursor.defer : SystemMouseCursors.click,
      semanticsLabel: entry == null
          ? null
          : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
      style: style,
    );
  }
}

class _VocabularyPopover extends StatelessWidget {
'''
new_span_end = '''  TextSpan _span(
    String text,
    _InteractiveSegment segment, {
    required TextStyle? style,
    required AppState state,
  }) {
    final entry = segment.entry;
    return TextSpan(
      text: text,
      recognizer: segment.recognizer,
      mouseCursor: entry == null ? MouseCursor.defer : SystemMouseCursors.click,
      semanticsLabel: entry == null
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
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: style),
        const SizedBox(height: .5),
        const CustomPaint(
          size: Size(7, 4),
          painter: _ReadingTrianglePainter(),
        ),
      ],
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
'''
if old_span_end not in interactive:
    raise SystemExit('TextSpan helper ending not found')
interactive_path.write_text(interactive.replace(old_span_end, new_span_end, 1))

# 3) Remove active paragraph color/border/icon so only the triangle indicates position.
journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
journey = journey.replace(
'''    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFF2EE)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? PhoenixTheme.red
              : PhoenixTheme.gold.withValues(alpha: .22),
          width: active ? 1.5 : 1,
        ),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x24781E18),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
''',
'''    return Container(
      key: ValueKey('compact-text-$index-${active ? 'active' : 'idle'}'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: PhoenixTheme.gold.withValues(alpha: .22),
        ),
      ),
''',
1,
)
old_avatar = '''              backgroundColor: active
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .18),
              child: active
                  ? const Icon(
                      Icons.graphic_eq_rounded,
                      size: 10,
                      color: Colors.white,
                    )
                  : Text(
                      '$index',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
'''
new_avatar = '''              backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              child: Text(
                '$index',
                style: const TextStyle(
                  color: PhoenixTheme.red,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
'''
if old_avatar not in journey:
    raise SystemExit('active paragraph avatar block not found')
journey_path.write_text(journey.replace(old_avatar, new_avatar, 1))

# 4) Never show 0% after progress has begun.
player_path = Path('app/lib/widgets/narration_player_card.dart')
player = player_path.read_text()
old_percent = '''        final percent = (progress * 100).round();
'''
new_percent = '''        final roundedPercent = (progress * 100).round();
        final percent = progress > 0 && roundedPercent == 0
            ? 1
            : roundedPercent;
'''
if old_percent not in player:
    raise SystemExit('player percentage line not found')
player_path.write_text(player.replace(old_percent, new_percent, 1))

# 5) Update the real Flutter visual test to require the inline triangle.
visual_test = Path('app/test/widgets/interactive_story_text_visual_test.dart')
visual_test.write_text('''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'explicit narration range paints a triangle under the active text',
    (tester) async {
      final state = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const MaterialApp(
            home: Scaffold(
              body: InteractiveStoryText(
                text: '故宫很美',
                entries: <WordEntry>[],
                narrationItemId: 'visual-test',
                highlightStart: 0,
                highlightEnd: 1,
              ),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('reading-triangle-visual-test')),
        findsOneWidget,
      );
      expect(find.byType(CustomPaint), findsWidgets);
    },
  );
}
''')

# 6) Update static regression gates.
Path('worker/explicit_visual_highlight.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const widgetTest = readFileSync(
  'app/test/widgets/interactive_story_text_visual_test.dart',
  'utf8',
);

test('position derives from playback and is passed to Story and Discovery', () => {
  assert.match(controller, /NarrationHighlightSnapshot\\? get highlightSnapshot \\{/);
  assert.match(interactive, /final int\\? highlightStart/);
  assert.equal(
    (journey.match(/highlightStart: isActive \\? snapshot!\\.start : null/g) ?? [])
      .length,
    2,
  );
});

test('Flutter verifies a real inline triangle is painted', () => {
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /class _ReadingTrianglePainter/);
  assert.match(interactive, /size: Size\\(7, 4\\)/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\\(0xFF8F1D18\\)/);
  assert.match(widgetTest, /reading-triangle-visual-test/);
});
''')

Path('worker/reading_position_visibility.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery show position only with the inline triangle', () => {
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.equal(
    (journey.match(/highlightStart: isActive \\? snapshot!\\.start : null/g) ?? [])
      .length,
    2,
  );
  assert.match(interactive, /reading-triangle-/);
  assert.match(interactive, /_ReadingTrianglePainter/);
});

test('no text or paragraph color change is used for narration position', () => {
  assert.doesNotMatch(interactive, /color: Colors\\.white/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\\(0xFF8F1D18\\)/);
  assert.doesNotMatch(journey, /const Color\\(0xFFFFF2EE\\)/);
  assert.doesNotMatch(journey, /Icons\\.graphic_eq_rounded/);
});
''')

Path('worker/monotonic_narration_progress.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('stalled Safari offsets cannot freeze or rewind Phoenix progress', () => {
  assert.match(controller, /if \\(globalStart < _currentOffset\\) return;/);
  assert.match(controller, /final nativeAdvanced = globalStart > _lastNativeOffset;/);
  assert.match(controller, /if \\(nativeAdvanced\\) \\{[\\s\\S]*_lastNativeProgressAt = now;/);
});

test('visible percentage leaves zero as soon as progress advances', () => {
  assert.match(player, /progress > 0 && roundedPercent == 0/);
});
''')
