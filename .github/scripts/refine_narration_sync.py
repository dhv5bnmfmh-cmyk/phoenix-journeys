from pathlib import Path
import re

interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
interactive = interactive.replace(
    'const int cinematicRevealTailLength = 6;',
    'const int cinematicRevealTailLength = 3;',
)
interactive = interactive.replace(
    "      (90 + characterDistance.abs() * 28).round().clamp(120, 420).toInt();",
    "      (characterDistance.abs() * 210).round().clamp(160, 700).toInt();",
)
interactive = interactive.replace(
    '    this.revealEnd,\n    super.key,',
    '    this.revealEnd,\n    this.narrationSessionToken = 0,\n    super.key,',
)
interactive = interactive.replace(
    '  final int? revealEnd;\n\n  @override',
    '  final int? revealEnd;\n  final int narrationSessionToken;\n\n  @override',
)

state_pattern = re.compile(
    r"  late final AnimationController _cinematicRevealController;.*?\n  void _buildSegments\(\) \{",
    re.S,
)
state_replacement = '''  late final AnimationController _cinematicRevealController;
  double _lastAcceptedRevealCursor = 0;

  @override
  void initState() {
    super.initState();
    final initialReveal = _targetRevealCursor(widget.revealEnd);
    _lastAcceptedRevealCursor = initialReveal;
    _cinematicRevealController = AnimationController.unbounded(
      vsync: this,
      value: initialReveal,
    );
    _buildSegments();
  }

  @override
  void didUpdateWidget(covariant InteractiveStoryText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final textChanged = oldWidget.text != widget.text;
    final sessionChanged =
        oldWidget.narrationSessionToken != widget.narrationSessionToken;
    if (textChanged || oldWidget.entries != widget.entries) {
      _disposeRecognizers();
      _selectedEntry = null;
      _buildSegments();
    }

    if (textChanged || sessionChanged) {
      _resetRevealTo(widget.revealEnd);
    } else if (oldWidget.revealEnd != widget.revealEnd) {
      _animateRevealTo(widget.revealEnd);
    }
  }

  double _targetRevealCursor(int? revealEnd) {
    final resolved = (revealEnd ?? widget.text.length).clamp(
      0,
      widget.text.length,
    );
    if (resolved >= widget.text.length) {
      return (widget.text.length + cinematicRevealTailLength).toDouble();
    }
    return resolved.toDouble();
  }

  double get _currentRevealCursor => _cinematicRevealController.value;

  void _resetRevealTo(int? revealEnd) {
    final target = _targetRevealCursor(revealEnd);
    _cinematicRevealController.stop();
    _lastAcceptedRevealCursor = target;
    _cinematicRevealController.value = target;
  }

  void _animateRevealTo(int? revealEnd) {
    final requestedTarget = _targetRevealCursor(revealEnd);
    final acceptedTarget = requestedTarget < _lastAcceptedRevealCursor
        ? _lastAcceptedRevealCursor
        : requestedTarget;
    _lastAcceptedRevealCursor = acceptedTarget;

    final current = _currentRevealCursor.clamp(
      0.0,
      (widget.text.length + cinematicRevealTailLength).toDouble(),
    );
    final distance = acceptedTarget - current;
    if (distance <= 0.01) return;

    _cinematicRevealController.animateTo(
      acceptedTarget,
      duration: cinematicRevealDuration(distance),
      curve: Curves.linear,
    );
  }

  void _buildSegments() {'''
interactive, count = state_pattern.subn(state_replacement, interactive, count=1)
if count != 1:
    raise SystemExit('Unable to replace reveal animation state')

interactive = interactive.replace(
    '          highlighted: isHighlighted,\n        ),',
    '          highlighted: isHighlighted,\n          state: state,\n        ),',
    1,
)

frontier_pattern = re.compile(
    r"  WidgetSpan _cinematicFrontierSpan\(.*?\n  TextSpan _span\(",
    re.S,
)
frontier_replacement = '''  TextSpan _cinematicFrontierSpan(
    String text,
    _InteractiveSegment segment, {
    required TextStyle style,
    required double progress,
    required bool highlighted,
    required AppState state,
  }) {
    final entry = segment.entry;
    final t = progress.clamp(0.0, 1.0).toDouble();
    final contrast = Curves.easeOutCubic.transform(t);
    final opacity = lerpDouble(.35, 1, t) ?? 1;
    final finalColor = style.color ?? Colors.white;
    final paleColor =
        highlighted ? const Color(0xFFFFE7AA) : const Color(0xFFD8D0C2);
    final cinematicColor =
        Color.lerp(paleColor, finalColor, contrast) ?? finalColor;

    return TextSpan(
      text: text,
      recognizer: segment.recognizer,
      mouseCursor:
          entry == null ? MouseCursor.defer : SystemMouseCursors.click,
      semanticsLabel: entry == null
          ? null
          : '${state.displayText(entry.word)}，${entry.pinyin}，点按查看词语解释',
      style: style.copyWith(
        color: cinematicColor.withValues(alpha: opacity),
      ),
    );
  }

  TextSpan _span('''
interactive, count = frontier_pattern.subn(frontier_replacement, interactive, count=1)
if count != 1:
    raise SystemExit('Unable to replace frontier span')

glyph_pattern = re.compile(
    r"\nclass _CinematicRevealGlyph extends StatelessWidget \{.*?\nclass _InlineReadingMarker",
    re.S,
)
interactive, count = glyph_pattern.subn(
    '\nclass _InlineReadingMarker',
    interactive,
    count=1,
)
if count != 1:
    raise SystemExit('Unable to remove glyph widget')
interactive_path.write_text(interactive)

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
controller = controller.replace(
    '  int get currentOffset => _currentOffset;\n  int get lastNativeOffset => _lastNativeOffset;',
    '''  int get currentOffset => _currentOffset;
  int? get currentItemStartOffset {
    final index = _currentItemIndex ?? _plan.indexForOffset(_currentOffset);
    if (index == null || index < 0 || index >= _plan.items.length) return null;
    return _plan.itemStart(index);
  }
  int get speechSessionToken => _speechSessionToken;
  int get lastNativeOffset => _lastNativeOffset;''',
)
old_web = '''    final now = DateTime.now();
    _lastNativeOffset = globalStart;
    _lastNativeProgressAt = now;
    _estimateAnchorTime = now;
    _estimateAnchorOffset = globalStart;
    _applyProgress(globalStart, endOffset: globalEnd, word: word);'''
new_web = '''    if (globalStart < _currentOffset) return;
    final nativeAdvanced = globalStart > _lastNativeOffset;
    if (nativeAdvanced) {
      final now = DateTime.now();
      _lastNativeOffset = globalStart;
      _lastNativeProgressAt = now;
      _estimateAnchorTime = now;
      _estimateAnchorOffset = globalStart;
    }
    _applyProgress(globalStart, endOffset: globalEnd, word: word);'''
if old_web not in controller:
    raise SystemExit('Unable to find web progress block')
controller = controller.replace(old_web, new_web, 1)
old_session = '''      _speechMode = _NarrationSpeechMode.narration;
      _lastNativeOffset = safeOffset;
      _lastNativeProgressAt = null;
      _speechBaseOffset = safeOffset;
      _currentOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _applyProgress(safeOffset);
      _safeNotify();
      final sessionToken = ++_speechSessionToken;'''
new_session = '''      final sessionToken = ++_speechSessionToken;
      _speechMode = _NarrationSpeechMode.narration;
      _lastNativeOffset = safeOffset;
      _lastNativeProgressAt = null;
      _speechBaseOffset = safeOffset;
      _currentOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _applyProgress(safeOffset);
      _safeNotify();'''
if old_session not in controller:
    raise SystemExit('Unable to find narration session block')
controller = controller.replace(old_session, new_session, 1)
controller = controller.replace(
    '// moving while audio is audible.',
    '// text reveal moving while audio is audible.',
)
controller_path.write_text(controller)

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
journey = journey.replace(
    '  required int? controllerItemIndex,\n  required int currentOffset,',
    '  required int? controllerItemIndex,\n  required int? controllerItemStartOffset,\n  required int currentOffset,',
    1,
)
old_fallback = '''  if (snapshotEnd != null) {
    return snapshotEnd.clamp(0, itemLength).toInt();
  }

  // At the newline between narration items, Flutter TTS briefly reports no
  // highlight snapshot. Keep the paragraph that just finished fully visible
  // instead of clearing every paragraph for one frame.
  return currentOffset <= 0 ? 0 : itemLength;'''
new_fallback = '''  if (snapshotEnd != null) {
    return snapshotEnd.clamp(0, itemLength).toInt();
  }

  final itemStart = controllerItemStartOffset;
  if (itemStart != null) {
    return (currentOffset - itemStart).clamp(0, itemLength).toInt();
  }

  return currentOffset <= 0 ? 0 : itemLength;'''
if old_fallback not in journey:
    raise SystemExit('Unable to find reveal fallback block')
journey = journey.replace(old_fallback, new_fallback, 1)
journey = journey.replace(
    '      controllerItemIndex: _narration.currentItemIndex,\n      currentOffset: _narration.currentOffset,',
    '      controllerItemIndex: _narration.currentItemIndex,\n      controllerItemStartOffset: _narration.currentItemStartOffset,\n      currentOffset: _narration.currentOffset,',
    1,
)
journey = journey.replace(
    "                              narrationContentId: 'story',\n                              narrationItemId: 'story-${entry.key}',",
    "                              narrationContentId: 'story',\n                              narrationItemId: 'story-${entry.key}',\n                              narrationSessionToken:\n                                  _narration.speechSessionToken,",
    1,
)
journey = journey.replace(
    "                            narrationContentId: 'discovery',\n                            narrationItemId: 'discovery-${entry.key}',",
    "                            narrationContentId: 'discovery',\n                            narrationItemId: 'discovery-${entry.key}',\n                            narrationSessionToken:\n                                _narration.speechSessionToken,",
    1,
)
journey_path.write_text(journey)

Path('app/test/narration_progressive_reveal_test.dart').write_text('''import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('narration reveal preserves layout while exposing only spoken text', () {
    expect(revealedSegmentLength(segmentStart: 5, segmentEnd: 10), 5);
    expect(revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 3), 0);
    expect(revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 7), 2);
    expect(revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 14), 5);
  });

  test('missing snapshots use local controller progress without jumping', () {
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 1,
        itemLength: 10,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      4,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      12,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 2,
        itemLength: 8,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      0,
    );
  });

  test('linear reveal duration follows natural Chinese reading pace', () {
    expect(cinematicRevealDuration(1).inMilliseconds, 210);
    expect(cinematicRevealDuration(30).inMilliseconds, 700);
  });

  test('cinematic reveal keeps a short pale-to-deep tail', () {
    expect(cinematicDepthProgress(revealCursor: 8, characterIndex: 8), 0);
    final fresh = cinematicDepthProgress(revealCursor: 8.5, characterIndex: 8);
    final deepening = cinematicDepthProgress(revealCursor: 9.5, characterIndex: 8);
    expect(fresh, greaterThan(0));
    expect(fresh, lessThan(deepening));
    expect(cinematicDepthProgress(revealCursor: 11, characterIndex: 8), 1);
  });
}
''')

Path('worker/cinematic_narration_reveal_rule.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');

test('narration reveal uses one monotonic linear cursor', () => {
  assert.match(interactive, /AnimationController\.unbounded/);
  assert.match(interactive, /_lastAcceptedRevealCursor/);
  assert.match(interactive, /animateTo\(/);
  assert.match(interactive, /curve: Curves\.linear/);
  assert.match(interactive, /narrationSessionToken/);
  assert.doesNotMatch(interactive, /_revealFrom|_revealTo/);
  assert.match(interactive, /clamp\(160, 700\)/);
});

test('frontier characters stay lightweight on iPhone Flutter Web', () => {
  assert.match(interactive, /TextSpan _cinematicFrontierSpan/);
  assert.match(interactive, /lerpDouble\(\.35, 1, t\)/);
  assert.doesNotMatch(interactive, /_CinematicRevealGlyph/);
  assert.doesNotMatch(interactive, /ImageFilter\.blur|ImageFiltered\(/);
  assert.doesNotMatch(interactive, /reading-triangle-|_ReadingTrianglePainter/);
});

test('future text remains layout-stable and non-interactive', () => {
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /hidden: true/);
});
''')

Path('worker/monotonic_text_reveal_rule.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');

test('native callbacks cannot move narration progress backwards', () => {
  assert.equal((controller.match(/if \(globalStart < _currentOffset\) return;/g) ?? []).length, 2);
  assert.match(controller, /int\? get currentItemStartOffset/);
  assert.match(controller, /int get speechSessionToken/);
});

test('missing word snapshots resolve to local paragraph progress', () => {
  assert.match(journey, /controllerItemStartOffset/);
  assert.match(journey, /currentOffset - itemStart/);
  assert.match(journey, /narrationSessionToken:\s*_narration\.speechSessionToken/);
});

test('same narration session accepts forward reveal targets only', () => {
  assert.match(interactive, /requestedTarget < _lastAcceptedRevealCursor/);
  assert.match(interactive, /acceptedTarget - current/);
  assert.doesNotMatch(interactive, /distance <= 0\.01[\s\S]{0,80}_resetRevealTo/);
});
''')
