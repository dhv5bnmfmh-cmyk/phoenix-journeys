from pathlib import Path

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()

field_marker = '  Timer? _progressTimer;\n'
if 'int _playbackGeneration = 0;' not in controller:
    if field_marker not in controller:
        raise SystemExit('progress timer field marker missing')
    controller = controller.replace(
        field_marker,
        field_marker + '  int _playbackGeneration = 0;\n',
        1,
    )

pause_marker = '''  Future<void> pauseAtOffset(int offset) async {
    if (_plan.isEmpty || _disposed) return;

'''
if '_playbackGeneration += 1;\n\n    final maxOffset' not in controller:
    if pause_marker not in controller:
        raise SystemExit('pause marker missing')
    controller = controller.replace(
        pause_marker,
        pause_marker + '    _playbackGeneration += 1;\n\n',
        1,
    )

stop_marker = '''  Future<void> stop({bool resetPosition = true}) async {
    _cancelProgressClock();
'''
if '''  Future<void> stop({bool resetPosition = true}) async {
    _playbackGeneration += 1;
    _cancelProgressClock();
''' not in controller:
    if stop_marker not in controller:
        raise SystemExit('stop marker missing')
    controller = controller.replace(
        stop_marker,
        '''  Future<void> stop({bool resetPosition = true}) async {
    _playbackGeneration += 1;
    _cancelProgressClock();
''',
        1,
    )

old_speak = '''      await _configureNaturalVoice('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(.98);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(remainingText);
      if (result == 1 && !_disposed) {
        // Most engines call setStartHandler. This fallback covers browsers
        // that start speaking without providing that callback.
        await Future<void>.delayed(const Duration(milliseconds: 140));
        if (!_disposed &&
            _status == NarrationStatus.playing &&
            _progressTimer == null) {
          _startProgressClock(_currentOffset);
        }
      } else if (!_disposed) {
'''
new_speak = '''      await _configureNaturalVoice('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(.98);
      await _tts.setVolume(1.0);

      // iOS Safari can play audio without firing start/progress callbacks, and
      // flutter_tts may keep this Future pending until speech is finished.
      // Arm Phoenix's single fallback clock before awaiting speak so the
      // progress bar and current-word highlight never remain frozen at 0%.
      final playbackGeneration = ++_playbackGeneration;
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 320), () {
          if (_disposed ||
              playbackGeneration != _playbackGeneration ||
              _status != NarrationStatus.playing ||
              _speechMode != _NarrationSpeechMode.narration ||
              _progressTimer != null) {
            return;
          }
          _startProgressClock(_currentOffset);
        }),
      );

      final result = await _tts.speak(remainingText);
      if (result != 1 && !_disposed) {
'''
if new_speak not in controller:
    if old_speak not in controller:
        raise SystemExit('old speak fallback block missing')
    controller = controller.replace(old_speak, new_speak, 1)

finish_marker = '''  void _finishNarrationSession() {
    _cancelProgressClock();
'''
if '''  void _finishNarrationSession() {
    _playbackGeneration += 1;
    _cancelProgressClock();
''' not in controller:
    if finish_marker not in controller:
        raise SystemExit('finish marker missing')
    controller = controller.replace(
        finish_marker,
        '''  void _finishNarrationSession() {
    _playbackGeneration += 1;
    _cancelProgressClock();
''',
        1,
    )

dispose_marker = '''  void dispose() {
    _disposed = true;
    _cancelProgressClock();
'''
if '''  void dispose() {
    _disposed = true;
    _playbackGeneration += 1;
    _cancelProgressClock();
''' not in controller:
    if dispose_marker not in controller:
        raise SystemExit('dispose marker missing')
    controller = controller.replace(
        dispose_marker,
        '''  void dispose() {
    _disposed = true;
    _playbackGeneration += 1;
    _cancelProgressClock();
''',
        1,
    )

controller_path.write_text(controller)

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
old_sheet = '''    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
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
    );
'''
new_sheet = '''    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .52,
          ),
          child: SingleChildScrollView(
            shrinkWrap: true,
            child: _ReadingSupportSheet(
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
            ),
          ),
        ),
      ),
    );
'''
if new_sheet not in journey:
    if old_sheet not in journey:
        raise SystemExit('reading support sheet block missing')
    journey = journey.replace(old_sheet, new_sheet, 1)

old_support = '''class _ReadingSupportSheet extends StatelessWidget {
  const _ReadingSupportSheet({
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
  });

  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 8),
        _SupportLine(
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
        ),
        const SizedBox(height: 8),
        _SupportLine(label: 'English', text: english, color: PhoenixTheme.ai),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4)),
        ],
      ),
    );
  }
}
'''
new_support = '''class _ReadingSupportSheet extends StatelessWidget {
  const _ReadingSupportSheet({
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
  });

  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 5),
        _SupportLine(
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
        ),
        const SizedBox(height: 5),
        _SupportLine(label: 'English', text: english, color: PhoenixTheme.ai),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(text, style: const TextStyle(fontSize: 11.2, height: 1.25)),
        ],
      ),
    );
  }
}
'''
if new_support not in journey:
    if old_support not in journey:
        raise SystemExit('reading support classes missing')
    journey = journey.replace(old_support, new_support, 1)

journey_path.write_text(journey)

test_path = Path('worker/ios_live_progress_compact_notes.test.mjs')
test_path.write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('iOS narration arms progress before awaiting the speech engine', () => {
  const delayed = controller.indexOf(
    'Future<void>.delayed(const Duration(milliseconds: 320)',
  );
  const speak = controller.indexOf('await _tts.speak(remainingText)');
  assert.ok(delayed >= 0);
  assert.ok(speak > delayed);
  assert.match(controller, /playbackGeneration != _playbackGeneration/);
  assert.match(controller, /_startProgressClock\(_currentOffset\)/);
});

test('reading support sheet follows content and stays compact', () => {
  assert.doesNotMatch(journey, /heightFactor: \.72/);
  assert.match(journey, /maxHeight:[\s\S]*height \* \.52/);
  assert.match(journey, /shrinkWrap: true/);
  assert.match(journey, /fontSize: 11\.2, height: 1\.25/);
});
''')
