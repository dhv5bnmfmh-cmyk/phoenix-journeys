from pathlib import Path

screen_path = Path('app/lib/screens/journey_screen.dart')
test_path = Path('app/test/narration_progressive_reveal_test.dart')
rule_path = Path('worker/narration_progressive_reveal_rule.test.mjs')
workflow_doc_path = Path('docs/development-workflow.md')

screen = screen_path.read_text()

import_anchor = "import '../widgets/word_detail_sheet.dart';\n\nclass JourneyScreen"
helper = """import '../widgets/word_detail_sheet.dart';

@visibleForTesting
int? stableNarrationRevealEnd({
  required bool sessionActive,
  required int itemIndex,
  required int itemLength,
  required int? snapshotItemIndex,
  required int? snapshotEnd,
  required int? controllerItemIndex,
  required int currentOffset,
}) {
  if (!sessionActive) return null;

  final activeItemIndex = snapshotItemIndex ?? controllerItemIndex;
  if (activeItemIndex == null) return currentOffset <= 0 ? 0 : itemLength;
  if (itemIndex < activeItemIndex) return itemLength;
  if (itemIndex > activeItemIndex) return 0;

  if (snapshotEnd != null) {
    return snapshotEnd.clamp(0, itemLength).toInt();
  }

  // At the newline between narration items, Flutter TTS briefly reports no
  // highlight snapshot. Keep the paragraph that just finished fully visible
  // instead of clearing every paragraph for one frame.
  return currentOffset <= 0 ? 0 : itemLength;
}

class JourneyScreen"""
if import_anchor not in screen:
    raise SystemExit('journey screen import anchor not found')
screen = screen.replace(import_anchor, helper, 1)

old_method = """  int? _narrationRevealEnd({
    required String contentId,
    required int itemIndex,
    required int itemLength,
  }) {
    final sessionActive = _narration.contentId == contentId &&
        (_narration.status == NarrationStatus.playing ||
            _narration.status == NarrationStatus.paused);
    if (!sessionActive) return null;

    final snapshot = _narration.highlightSnapshot;
    if (snapshot == null || snapshot.contentId != contentId) return 0;
    if (itemIndex < snapshot.itemIndex) return itemLength;
    if (itemIndex > snapshot.itemIndex) return 0;
    return snapshot.end.clamp(0, itemLength).toInt();
  }
"""
new_method = """  int? _narrationRevealEnd({
    required String contentId,
    required int itemIndex,
    required int itemLength,
  }) {
    final sessionActive = _narration.contentId == contentId &&
        (_narration.status == NarrationStatus.playing ||
            _narration.status == NarrationStatus.paused);
    final snapshot = _narration.highlightSnapshot;
    final snapshotMatches = snapshot?.contentId == contentId;

    return stableNarrationRevealEnd(
      sessionActive: sessionActive,
      itemIndex: itemIndex,
      itemLength: itemLength,
      snapshotItemIndex: snapshotMatches ? snapshot?.itemIndex : null,
      snapshotEnd: snapshotMatches ? snapshot?.end : null,
      controllerItemIndex: _narration.currentItemIndex,
      currentOffset: _narration.currentOffset,
    );
  }
"""
if old_method not in screen:
    raise SystemExit('old narration reveal method not found')
screen = screen.replace(old_method, new_method, 1)
screen_path.write_text(screen)

test = test_path.read_text()
if "screens/journey_screen.dart" not in test:
    test = test.replace(
        "import 'package:phoenix_journeys/widgets/interactive_story_text.dart';",
        "import 'package:phoenix_journeys/screens/journey_screen.dart';\nimport 'package:phoenix_journeys/widgets/interactive_story_text.dart';",
        1,
    )
insert_anchor = "  test('cinematic reveal interpolates each glyph with a bounded duration', () {"
boundary_test = """  test('paragraph boundary never clears the whole narration for one frame', () {
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 12,
      ),
      12,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 1,
        itemLength: 10,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 12,
      ),
      0,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 0,
      ),
      0,
    );
  });

"""
if boundary_test.strip() not in test:
    if insert_anchor not in test:
        raise SystemExit('test insertion anchor not found')
    test = test.replace(insert_anchor, boundary_test + insert_anchor, 1)
test_path.write_text(test)

rule = rule_path.read_text()
rule_anchor = "  assert.match(journey, /transparentSurface: true/);\n"
rule_addition = """  assert.match(journey, /stableNarrationRevealEnd/);
  assert.match(journey, /controllerItemIndex: _narration\.currentItemIndex/);
  assert.match(journey, /currentOffset: _narration\.currentOffset/);
"""
if rule_addition.strip() not in rule:
    if rule_anchor not in rule:
        raise SystemExit('worker rule anchor not found')
    rule = rule.replace(rule_anchor, rule_anchor + rule_addition, 1)
rule_path.write_text(rule)

doc = workflow_doc_path.read_text()
doc_anchor = '- 动画最长不得超过 720ms，避免语音进度更新时产生明显拖尾。\n'
doc_addition = '- 朗读跨越段落分隔符时，即使语音引擎短暂不给出高亮快照，也不得把全文显现进度清零或产生整页闪烁。\n'
if doc_addition not in doc:
    if doc_anchor not in doc:
        raise SystemExit('workflow doc anchor not found')
    doc = doc.replace(doc_anchor, doc_anchor + doc_addition, 1)
workflow_doc_path.write_text(doc)
