from pathlib import Path
import re

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()

controller = controller.replace(
    '  NarrationHighlightSnapshot? _highlightSnapshot;\n',
    '  NarrationHighlightSnapshot? _highlightSnapshot;\n  int _speechSessionToken = 0;\n',
    1,
)

controller = controller.replace(
    '''  NarrationHighlightSnapshot? get highlightSnapshot {
    final contentId = _contentId;
    final itemIndex = _currentItemIndex;
    if (_plan.isEmpty || contentId == null || itemIndex == null) return null;
''',
    '''  NarrationHighlightSnapshot? get highlightSnapshot {
    final contentId = _contentId;
    final sessionActive =
        _status == NarrationStatus.playing ||
        _status == NarrationStatus.paused;
    final itemIndex =
        _currentItemIndex ??
        (sessionActive ? _plan.indexForOffset(_currentOffset) : null);
    if (_plan.isEmpty || contentId == null || itemIndex == null) return null;
''',
    1,
)

controller = controller.replace(
    '''    _currentItemIndex = 0;
    _errorMessage = null;
    await _speakFrom(0);
''',
    '''    _currentItemIndex = 0;
    _errorMessage = null;
    _status = NarrationStatus.playing;
    _speechMode = _NarrationSpeechMode.narration;
    _applyProgress(0);
    await _speakFrom(0);
''',
    1,
)

controller = controller.replace(
    '''      _applyProgress(safeOffset);
      _safeNotify();

      await _configureNaturalVoice('zh-CN');
''',
    '''      _applyProgress(safeOffset);
      _safeNotify();
      final sessionToken = ++_speechSessionToken;

      await _configureNaturalVoice('zh-CN');
''',
    1,
)

controller = controller.replace(
    '''      final result = await _tts.speak(remainingText);
      if (result == 1 && !_disposed) {
''',
    '''      final speakFuture = _tts.speak(remainingText);
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
      final result = await speakFuture;
      if (result == 1 && !_disposed) {
''',
    1,
)

watchdog = '''  Future<void> _startProgressWatchdog(
    int sessionToken,
    int offset,
  ) async {
    // iOS Safari may not resolve speak() or emit a start callback until the
    // utterance ends. Start Phoenix's single fallback clock independently so
    // progress and the inline current-word highlight never remain at 0%.
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (_disposed ||
        sessionToken != _speechSessionToken ||
        _speechMode != _NarrationSpeechMode.narration ||
        _status != NarrationStatus.playing ||
        _progressTimer != null) {
      return;
    }
    _startProgressClock(offset);
  }

'''
marker = '  void _finishNarrationSession() {\n'
if watchdog not in controller:
    if marker not in controller:
        raise SystemExit('finish narration marker missing')
    controller = controller.replace(marker, watchdog + marker, 1)

controller = controller.replace(
    '''  void _finishNarrationSession() {
    _cancelProgressClock();
''',
    '''  void _finishNarrationSession() {
    _speechSessionToken += 1;
    _cancelProgressClock();
''',
    1,
)

controller = controller.replace(
    '''  Future<void> _stopSpeechEngine() async {
    _suppressEngineCallbacks = true;
''',
    '''  Future<void> _stopSpeechEngine() async {
    _speechSessionToken += 1;
    _suppressEngineCallbacks = true;
''',
    1,
)

controller = controller.replace(
    '''  void dispose() {
    _disposed = true;
''',
    '''  void dispose() {
    _speechSessionToken += 1;
    _disposed = true;
''',
    1,
)

required_controller_tokens = [
    'final speakFuture = _tts.speak(remainingText);',
    'unawaited(_startProgressWatchdog(sessionToken, safeOffset));',
    'int _speechSessionToken = 0;',
]
for token in required_controller_tokens:
    if token not in controller:
        raise SystemExit(f'missing controller token: {token}')
controller_path.write_text(controller)

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()

old_sheet = '''      builder: (_) => FractionallySizedBox(
        heightFactor: .72,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: _ReadingSupportSheet(
            title: title,
            pinyin: pinyin,
            nativeLabel: nativeLabel,
            nativeText: nativeText,
            english: english,
          ),
        ),
      ),
'''
new_sheet = '''      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ReadingSupportSheet(
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
            ),
          ),
        );
      },
'''
if old_sheet not in journey:
    raise SystemExit('old reading support sheet layout missing')
journey = journey.replace(old_sheet, new_sheet, 1)

journey = journey.replace(
    '''    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
''',
    '''    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
''',
    1,
)
journey = journey.replace('        const SizedBox(height: 8),\n', '        const SizedBox(height: 5),\n', 2)
journey = journey.replace('      padding: const EdgeInsets.all(11),\n', '      padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),\n', 1)
journey = journey.replace('        borderRadius: BorderRadius.circular(12),\n', '        borderRadius: BorderRadius.circular(10),\n', 1)
journey = journey.replace('              fontSize: 10,\n', '              fontSize: 9.5,\n', 1)
journey = journey.replace('          const SizedBox(height: 3),\n', '          const SizedBox(height: 2),\n', 1)
journey = journey.replace(
    "          Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4)),\n",
    "          Text(text, style: const TextStyle(fontSize: 11.5, height: 1.28)),\n",
    1,
)

required_journey_tokens = [
    'constraints: BoxConstraints(maxHeight: maxHeight)',
    'MediaQuery.sizeOf(sheetContext).height * .52',
    'mainAxisSize: MainAxisSize.min',
]
for token in required_journey_tokens:
    if token not in journey:
        raise SystemExit(f'missing journey token: {token}')
if 'heightFactor: .72' in journey:
    raise SystemExit('fixed 72% reading support height still present')
journey_path.write_text(journey)

Path('worker/ios_live_word_progress.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('iOS narration starts its progress watchdog without awaiting speak completion', () => {
  assert.match(controller, /final speakFuture = _tts\.speak\(remainingText\);/);
  assert.match(
    controller,
    /unawaited\(_startProgressWatchdog\(sessionToken, safeOffset\)\);[\s\S]*final result = await speakFuture;/,
  );
  assert.match(controller, /Duration\(milliseconds: 260\)/);
});

test('active narration always derives an inline highlight item', () => {
  assert.match(controller, /sessionActive[\s\S]*_plan\.indexForOffset\(_currentOffset\)/);
  assert.match(controller, /_status = NarrationStatus\.playing;[\s\S]*_applyProgress\(0\);/);
});
''')

Path('worker/compact_reading_support.test.mjs').write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('annotation sheet follows content and never occupies most of the screen', () => {
  assert.doesNotMatch(journey, /heightFactor:\s*\.72/);
  assert.match(journey, /MediaQuery\.sizeOf\(sheetContext\)\.height \* \.52/);
  assert.match(journey, /constraints: BoxConstraints\(maxHeight: maxHeight\)/);
  assert.match(journey, /class _ReadingSupportSheet[\s\S]*mainAxisSize: MainAxisSize\.min/);
});
''')
