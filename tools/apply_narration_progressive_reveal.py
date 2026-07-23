from pathlib import Path


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text(encoding='utf-8')

journey = replace_once(
    journey,
    "  Widget _storyPage() {\n",
    """  int? _narrationRevealEnd({
    required String contentId,
    required int itemIndex,
    required int itemLength,
  }) {
    final sessionActive =
        _narration.contentId == contentId &&
        (_narration.status == NarrationStatus.playing ||
            _narration.status == NarrationStatus.paused);
    if (!sessionActive) return null;

    final snapshot = _narration.highlightSnapshot;
    if (snapshot == null || snapshot.contentId != contentId) return 0;
    if (itemIndex < snapshot.itemIndex) return itemLength;
    if (itemIndex > snapshot.itemIndex) return 0;
    return snapshot.end.clamp(0, itemLength).toInt();
  }

  Widget _storyPage() {
""",
    'insert narration reveal helper',
)

journey = replace_once(
    journey,
    """                                active: isActive,
                                onSupport: () => unawaited(
""",
    """                                active: isActive,
                                transparentSurface: true,
                                onSupport: () => unawaited(
""",
    'make story block frameless',
)

journey = replace_once(
    journey,
    """                                  highlightEnd: isActive ? snapshot!.end : null,
                                  narrationContentId: 'story',
""",
    """                                  highlightEnd: isActive ? snapshot!.end : null,
                                  revealEnd: _narrationRevealEnd(
                                    contentId: 'story',
                                    itemIndex: entry.key,
                                    itemLength: entry.value.length,
                                  ),
                                  narrationContentId: 'story',
""",
    'wire story progressive reveal',
)

journey = replace_once(
    journey,
    """                              active: isActive,
                              onSupport: () => unawaited(
""",
    """                              active: isActive,
                              transparentSurface: true,
                              onSupport: () => unawaited(
""",
    'make discovery block frameless',
)

journey = replace_once(
    journey,
    """                                highlightEnd: isActive ? snapshot!.end : null,
                                narrationContentId: 'discovery',
""",
    """                                highlightEnd: isActive ? snapshot!.end : null,
                                revealEnd: _narrationRevealEnd(
                                  contentId: 'discovery',
                                  itemIndex: entry.key,
                                  itemLength: item.text.length,
                                ),
                                narrationContentId: 'discovery',
""",
    'wire discovery progressive reveal',
)

journey = replace_once(
    journey,
    """    required this.child,
    required this.onSupport,
  });
""",
    """    required this.child,
    required this.onSupport,
    this.transparentSurface = false,
  });
""",
    'add transparent surface argument',
)

journey = replace_once(
    journey,
    """  final Widget child;
  final VoidCallback onSupport;
""",
    """  final Widget child;
  final VoidCallback onSupport;
  final bool transparentSurface;
""",
    'add transparent surface field',
)

journey = replace_once(
    journey,
    """      decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
        borderRadius: BorderRadius.circular(10),
      ),
""",
    """      decoration: transparentSurface
          ? null
          : PhoenixTheme.journeyPanelDecoration.copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
""",
    'remove reading frame decoration',
)

journey_path.write_text(journey, encoding='utf-8')


interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text(encoding='utf-8')

interactive = replace_once(
    interactive,
    """@visibleForTesting
List<StoryTextSegment> segmentStoryText(String text, List<WordEntry> entries) {
""",
    """@visibleForTesting
int revealedSegmentLength({
  required int segmentStart,
  required int segmentEnd,
  int? revealEnd,
}) {
  if (revealEnd == null) return segmentEnd - segmentStart;
  return revealEnd.clamp(segmentStart, segmentEnd).toInt() - segmentStart;
}

@visibleForTesting
List<StoryTextSegment> segmentStoryText(String text, List<WordEntry> entries) {
""",
    'add reveal length helper',
)

interactive = replace_once(
    interactive,
    """    this.highlightStart,
    this.highlightEnd,
    super.key,
""",
    """    this.highlightStart,
    this.highlightEnd,
    this.revealEnd,
    super.key,
""",
    'add reveal end constructor argument',
)

interactive = replace_once(
    interactive,
    """  final int? highlightStart;
  final int? highlightEnd;
""",
    """  final int? highlightStart;
  final int? highlightEnd;
  final int? revealEnd;
""",
    'add reveal end field',
)

interactive = replace_once(
    interactive,
    """                        highlightStart: highlightStart,
                        highlightEnd: highlightEnd,
""",
    """                        highlightStart: highlightStart,
                        highlightEnd: highlightEnd,
                        revealEnd: widget.revealEnd,
""",
    'pass reveal end into segment spans',
)

start = interactive.index('  List<InlineSpan> _buildSegmentSpans(')
end = interactive.index('  TextSpan _span(', start)
replacement = """  List<InlineSpan> _buildSegmentSpans(
    _InteractiveSegment segment, {
    required AppState state,
    required TextStyle? baseStyle,
    required int highlightStart,
    required int highlightEnd,
    required int? revealEnd,
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

    final visibleLength = revealedSegmentLength(
      segmentStart: segment.start,
      segmentEnd: segment.end,
      revealEnd: revealEnd,
    );
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

    if (visibleLength < segment.text.length) {
      final hiddenStyle =
          (segmentStyle ?? baseStyle ?? const TextStyle()).copyWith(
            color: Colors.transparent,
            decoration: TextDecoration.none,
            shadows: const <Shadow>[],
          );
      spans.add(
        _span(
          state.displayText(segment.text.substring(visibleLength)),
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
interactive = interactive[:start] + replacement + interactive[end:]

interactive = replace_once(
    interactive,
    """    required TextStyle? style,
    required AppState state,
  }) {
""",
    """    required TextStyle? style,
    required AppState state,
    bool interactive = true,
    bool hidden = false,
  }) {
""",
    'extend span options',
)

interactive = replace_once(
    interactive,
    """      recognizer: segment.recognizer,
      mouseCursor: entry == null ? MouseCursor.defer : SystemMouseCursors.click,
      semanticsLabel: entry == null
          ? null
          : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
""",
    """      recognizer: interactive ? segment.recognizer : null,
      mouseCursor: interactive && entry != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      semanticsLabel: hidden
          ? ''
          : entry == null
          ? null
          : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
""",
    'disable hidden text interaction and semantics',
)

interactive_path.write_text(interactive, encoding='utf-8')


test_path = Path('app/test/narration_progressive_reveal_test.dart')
test_path.write_text(
    """import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('narration reveal preserves layout while exposing only spoken text', () {
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10),
      5,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 3),
      0,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 7),
      2,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 14),
      5,
    );
  });
}
""",
    encoding='utf-8',
)

rule_path = Path('worker/narration_progressive_reveal_rule.test.mjs')
rule_path.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('story and discovery reveal text from narration progress', () => {
  assert.match(journey, /int\? _narrationRevealEnd\(/);
  assert.match(journey, /contentId: 'story'[\s\S]*revealEnd: _narrationRevealEnd/);
  assert.match(journey, /contentId: 'discovery'[\s\S]*revealEnd: _narrationRevealEnd/);
  assert.match(journey, /transparentSurface: true/);
});

test('unspoken text stays layout-stable, invisible, and non-interactive', () => {
  assert.match(interactive, /final int\? revealEnd/);
  assert.match(interactive, /revealedSegmentLength\(/);
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /semanticsLabel: hidden/);
});
""",
    encoding='utf-8',
)

workflow_path = Path('docs/development-workflow.md')
workflow = workflow_path.read_text(encoding='utf-8')
anchor = '- 禁止在开发体验版启用正式上市的免费旅程限制。\n'
addition = (
    '- 故事与发现朗读时，未朗读文字必须保持版面位置但不可见，'
    '已朗读文字随 NarrationController 进度逐字显现；阅读内容不得再用大面积框遮挡目的地背景。\n'
)
if addition not in workflow:
    if anchor not in workflow:
        raise RuntimeError('development rule anchor not found')
    workflow = workflow.replace(anchor, anchor + addition, 1)
workflow_path.write_text(workflow, encoding='utf-8')
