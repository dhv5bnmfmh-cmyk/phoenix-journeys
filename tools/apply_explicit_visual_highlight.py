from pathlib import Path
import re


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if new in text:
        return text
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, got {count}')
    return text.replace(old, new, 1)


# 1) Make the controller highlight getter derive directly from the current
# character position. This cannot go stale even if a browser misses callbacks.
controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
controller = replace_once(
    controller,
    '  NarrationHighlightSnapshot? get highlightSnapshot => _highlightSnapshot;\n',
    '''  NarrationHighlightSnapshot? get highlightSnapshot {
    final contentId = _contentId;
    final itemIndex = _currentItemIndex;
    if (_plan.isEmpty || contentId == null || itemIndex == null) return null;
    if (itemIndex < 0 || itemIndex >= _plan.items.length) return null;

    final item = _plan.items[itemIndex];
    final itemStart = _plan.itemStart(itemIndex);
    var localStart = (_currentOffset - itemStart)
        .clamp(0, item.text.length)
        .toInt();
    while (localStart < item.text.length &&
        _isBoundary(item.text.substring(localStart, localStart + 1))) {
      localStart += 1;
    }
    if (localStart >= item.text.length) return null;

    final localEnd = (localStart + _fallbackHighlightLength(item.text, localStart))
        .clamp(localStart + 1, item.text.length)
        .toInt();
    return NarrationHighlightSnapshot(
      contentId: contentId,
      itemId: item.id,
      itemText: item.text,
      itemIndex: itemIndex,
      start: localStart,
      end: localEnd,
      word: _highlightSnapshot?.word ?? '',
    );
  }
''',
    'derived controller highlight getter',
)
controller_path.write_text(controller)


# 2) Allow Journey to pass an explicit visual range. Explicit values bypass all
# snapshot matching inside the text widget.
interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
interactive = replace_once(
    interactive,
    '''    this.narrationItemId,
    this.narrationController,
    super.key,
''',
    '''    this.narrationItemId,
    this.narrationController,
    this.highlightStart,
    this.highlightEnd,
    super.key,
''',
    'interactive explicit range constructor',
)
interactive = replace_once(
    interactive,
    '''  final String? narrationItemId;
  final NarrationController? narrationController;
''',
    '''  final String? narrationItemId;
  final NarrationController? narrationController;
  final int? highlightStart;
  final int? highlightEnd;
''',
    'interactive explicit range fields',
)
old_resolution = '''            final snapshot =
                widget.narrationController?.highlightSnapshot ??
                NarrationHighlightBus.instance.snapshot;
            final isCurrentNarrationItem = narrationSnapshotMatches(
              snapshot: snapshot,
              contentId: widget.narrationContentId,
              itemId: widget.narrationItemId,
              sourceText: widget.text,
              displayedText: state.displayText(widget.text),
              displayText: state.displayText,
            );
            final highlightStart = isCurrentNarrationItem
                ? snapshot!.start
                : -1;
            final highlightEnd = isCurrentNarrationItem ? snapshot!.end : -1;

            return Text.rich(
'''
new_resolution = '''            final snapshot =
                widget.narrationController?.highlightSnapshot ??
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
'''
interactive = replace_once(
    interactive,
    old_resolution,
    new_resolution,
    'explicit visual range resolution',
)
interactive_path.write_text(interactive)


# 3) Journey computes the active range once from the same controller that owns
# audio and passes it directly into Story and Discovery text widgets.
journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
journey = replace_once(
    journey,
    '''                          final annotation = storyAnnotations[entry.key];
                          final isActive = _isNarrating('story', entry.key);
''',
    '''                          final annotation = storyAnnotations[entry.key];
                          final snapshot = _narration.highlightSnapshot;
                          final isActive = snapshot?.contentId == 'story' &&
                              snapshot?.itemId == 'story-${entry.key}';
''',
    'story explicit active range',
)
journey = replace_once(
    journey,
    '''                              narrationController: _narration,
                              narrationContentId: 'story',
''',
    '''                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'story',
''',
    'story explicit highlight arguments',
)
journey = replace_once(
    journey,
    '''                          final item = entry.value;
                          final isActive = _isNarrating('discovery', entry.key);
''',
    '''                          final item = entry.value;
                          final snapshot = _narration.highlightSnapshot;
                          final isActive = snapshot?.contentId == 'discovery' &&
                              snapshot?.itemId == 'discovery-${entry.key}';
''',
    'discovery explicit active range',
)
journey = replace_once(
    journey,
    '''                              narrationController: _narration,
                              narrationContentId: 'discovery',
''',
    '''                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'discovery',
''',
    'discovery explicit highlight arguments',
)
journey_path.write_text(journey)


# 4) Real Flutter widget test: verify a TextSpan is actually painted yellow.
test_path = Path('app/test/widgets/interactive_story_text_visual_test.dart')
test_path.parent.mkdir(parents=True, exist_ok=True)
test_path.write_text(r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

bool _containsYellowHighlight(InlineSpan span) {
  if (span.style?.backgroundColor == const Color(0xFFFFD05A)) return true;
  if (span is TextSpan) {
    return span.children?.any(_containsYellowHighlight) ?? false;
  }
  return false;
}

void main() {
  testWidgets('explicit narration range paints a visible yellow word highlight',
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

    final text = tester.widget<Text>(
      find.byKey(const ValueKey('interactive-highlight-visual-test')),
    );
    expect(text.textSpan, isNotNull);
    expect(_containsYellowHighlight(text.textSpan!), isTrue);
  });
}
''')

# Static gate protects the explicit binding and the real visual test.
Path('worker/explicit_visual_highlight.test.mjs').write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const widgetTest = readFileSync(
  'app/test/widgets/interactive_story_text_visual_test.dart',
  'utf8',
);

test('highlight derives from current playback position and is passed explicitly', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot \{/);
  assert.match(interactive, /final int\? highlightStart/);
  assert.match(interactive, /hasExplicitHighlight/);
  assert.equal((journey.match(/highlightStart: isActive \? snapshot!\.start : null/g) ?? []).length, 2);
});

test('Flutter verifies an actual yellow TextSpan is painted', () => {
  assert.match(widgetTest, /backgroundColor == const Color\(0xFFFFD05A\)/);
  assert.match(widgetTest, /_containsYellowHighlight\(text\.textSpan!\)/);
});
''')
