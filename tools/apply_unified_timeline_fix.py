from pathlib import Path
import re


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if new in text:
        return text
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, got {count}')
    return text.replace(old, new, 1)


# 1) Make NarrationController the only playback/highlight clock.
controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()

old_completion = '''    _tts.setCompletionHandler(() {
      if (_shouldIgnoreEngineCallback) return;
      if (_speechMode == _NarrationSpeechMode.word) {
        _finishWordSpeech(success: true);
        return;
      }
      if (_speechMode != _NarrationSpeechMode.narration) return;
      _cancelProgressClock();
      _speechMode = _NarrationSpeechMode.idle;
      _status = NarrationStatus.idle;
      _currentOffset = _plan.text.length;
      _currentItemIndex = null;
      NarrationHighlightBus.instance.clear(contentId: _contentId);
      _safeNotify();
    });
'''
new_completion = '''    _tts.setCompletionHandler(() {
      if (_shouldIgnoreEngineCallback) return;
      if (_speechMode == _NarrationSpeechMode.word) {
        _finishWordSpeech(success: true);
        return;
      }
      if (_speechMode != _NarrationSpeechMode.narration) return;

      // Safari can report completion before the audible voice has finished.
      // Keep the single Phoenix clock alive until it reaches the text end.
      final finalReadableOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
      if (_currentOffset < finalReadableOffset) {
        if (_progressTimer == null) _startProgressClock(_currentOffset);
        return;
      }
      _finishNarrationSession();
    });
'''
controller = replace_once(
    controller,
    old_completion,
    new_completion,
    'completion handler',
)

controller = re.sub(
    r'''\n  /// Keeps the visible word highlight moving while a browser continues to\n  /// speak but reports an unreliable completion/progress state\.\n  void syncPlaybackHighlight\([\s\S]*?\n  \}\n\n  void clearPlaybackHighlight\([\s\S]*?\n  \}\n''',
    '\n',
    controller,
    count=1,
)

controller = replace_once(
    controller,
    '''      _status = NarrationStatus.playing;
      _errorMessage = null;
      _startProgressClock(safeOffset);
      _applyProgress(safeOffset);
      _safeNotify();
''',
    '''      _status = NarrationStatus.playing;
      _errorMessage = null;
      _applyProgress(safeOffset);
      _safeNotify();
''',
    'pre-speech progress clock',
)

old_speak_result = '''      final result = await _tts.speak(remainingText);
      if (result != 1 && !_disposed) {
        _cancelProgressClock();
        _speechMode = _NarrationSpeechMode.idle;
        _status = NarrationStatus.error;
        _errorMessage = '没有找到可用的中文语音，请换用 Safari 或 Chrome 重试。';
        _currentItemIndex = null;
        NarrationHighlightBus.instance.clear(contentId: _contentId);
        _safeNotify();
      }
'''
new_speak_result = '''      final result = await _tts.speak(remainingText);
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
        _cancelProgressClock();
        _speechMode = _NarrationSpeechMode.idle;
        _status = NarrationStatus.error;
        _errorMessage = '没有找到可用的中文语音，请换用 Safari 或 Chrome 重试。';
        _currentItemIndex = null;
        NarrationHighlightBus.instance.clear(contentId: _contentId);
        _safeNotify();
      }
'''
controller = replace_once(
    controller,
    old_speak_result,
    new_speak_result,
    'speak result handling',
)

controller = replace_once(
    controller,
    '''      final charsPerSecond = 4.2 * (_speechRate / .36);
      final estimated =
          _estimateAnchorOffset + (elapsedSeconds * charsPerSecond).floor();
      if (estimated <= _currentOffset) return;
      _applyProgress(estimated);
''',
    '''      // Conservative fallback pace: native word callbacks remain exact;
      // this clock is only used when a browser supplies no usable word events.
      final charsPerSecond = 3.35 * (_speechRate / .36);
      final estimated =
          _estimateAnchorOffset + (elapsedSeconds * charsPerSecond).floor();
      if (estimated >= _plan.text.length) {
        _finishNarrationSession();
        return;
      }
      if (estimated <= _currentOffset) return;
      _applyProgress(estimated);
''',
    'fallback clock pace',
)

finish_marker = '  void _finishWordSpeech({required bool success}) {'
finish_method = '''  void _finishNarrationSession() {
    _cancelProgressClock();
    _speechMode = _NarrationSpeechMode.idle;
    _status = NarrationStatus.idle;
    _currentOffset = _plan.text.length;
    _currentItemIndex = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    _safeNotify();
  }

'''
if finish_method not in controller:
    controller = replace_once(
        controller,
        finish_marker,
        finish_method + finish_marker,
        'finish narration method',
    )
controller_path.write_text(controller)


# 2) Remove the player's competing local clock and read controller progress only.
player_path = Path('app/lib/widgets/narration_player_card.dart')
player = player_path.read_text()

new_state_prefix = '''class _NarrationPlayerCardState extends State<NarrationPlayerCard> {
  bool _sessionPlaying = false;
  bool _sessionPaused = false;
  int _commandVersion = 0;
  int _resumeOffset = 0;

  bool get _controllerIsCurrent =>
      widget.controller.contentId == widget.contentId;

  bool get _controllerFinished =>
      _controllerIsCurrent &&
      widget.controller.status == NarrationStatus.idle &&
      widget.controller.totalCharacters > 0 &&
      widget.controller.currentOffset >= widget.controller.totalCharacters;

  @override
  void didUpdateWidget(covariant NarrationPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentId != widget.contentId ||
        oldWidget.controller != widget.controller) {
      _commandVersion += 1;
      _resetLocalSession();
    }
  }

  @override
  void dispose() {
    _commandVersion += 1;
    super.dispose();
  }

  void _resetLocalSession() {
    _sessionPlaying = false;
    _sessionPaused = false;
    _resumeOffset = 0;
  }

  void _beginLocalPlayback(int offset) {
    setState(() {
      _sessionPlaying = true;
      _sessionPaused = false;
      _resumeOffset = offset;
    });
  }

  void _handleMainPressed() {
    final commandId = ++_commandVersion;
    final controllerPlaying =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.playing;
    final controllerPaused =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.paused;

    if (_controllerFinished) {
      _sessionPlaying = false;
      _sessionPaused = false;
      _resumeOffset = 0;
      unawaited(_startSession(commandId));
      return;
    }
    if (_sessionPlaying || controllerPlaying) {
      unawaited(_pauseSession(commandId));
      return;
    }
    if (_sessionPaused || controllerPaused) {
      if (!_sessionPaused) _resumeOffset = widget.controller.currentOffset;
      unawaited(_resumeSession(commandId));
      return;
    }
    unawaited(_startSession(commandId));
  }

  Future<void> _startSession(int commandId) async {
    _beginLocalPlayback(0);
    await widget.onPlay();
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    setState(() {
      _resumeOffset = _controllerIsCurrent
          ? widget.controller.currentOffset
          : 0;
    });
  }

  Future<void> _pauseSession(int commandId) async {
    final currentOffset = _controllerIsCurrent
        ? widget.controller.currentOffset
        : _resumeOffset;
    final offset = _controllerIsCurrent
        ? resolveNarrationPauseOffset(
            nativeOffset: widget.controller.lastNativeOffset,
            nativeProgressIsFresh: widget.controller.hasFreshNativeProgress,
            estimatedOffset: currentOffset,
            totalCharacters: widget.controller.totalCharacters,
          )
        : currentOffset;
    if (!mounted || commandId != _commandVersion) return;
    setState(() {
      _sessionPlaying = false;
      _sessionPaused = true;
      _resumeOffset = offset;
    });
    await widget.controller.pauseAtOffset(offset);
  }

  Future<void> _resumeSession(int commandId) async {
    final total = widget.controller.totalCharacters;
    final safeOffset = total <= 0
        ? 0
        : _resumeOffset.clamp(0, math.max(0, total - 1)).toInt();
    if (!mounted || commandId != _commandVersion) return;
    _beginLocalPlayback(safeOffset);
    await widget.controller.resumeFromOffset(safeOffset);
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    setState(() => _resumeOffset = widget.controller.currentOffset);
  }

  Future<void> _restartSession() async {
    final commandId = ++_commandVersion;
    _beginLocalPlayback(0);
    if (_controllerIsCurrent && widget.controller.hasContent) {
      await widget.controller.restart();
    } else {
      await widget.onPlay();
    }
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    setState(() => _resumeOffset = widget.controller.currentOffset);
  }

  Future<void> _setSpeechRate(double rate) async {
    final offset = _controllerIsCurrent
        ? widget.controller.currentOffset
        : _resumeOffset;
    _resumeOffset = offset;
    await widget.controller.setSpeechRate(rate);
    if (_sessionPlaying && widget.controller.status != NarrationStatus.playing) {
      await widget.controller.resumeFromOffset(offset);
    }
  }

  @override
  Widget build'''
player, count = re.subn(
    r'class _NarrationPlayerCardState extends State<NarrationPlayerCard> \{[\s\S]*?  @override\n  Widget build',
    new_state_prefix,
    player,
    count=1,
)
if count != 1:
    raise RuntimeError(f'player state prefix replacement count: {count}')

player = replace_once(
    player,
    '''        final isPlaying =
            _sessionPlaying ||
            (!_sessionPaused && controllerStatus == NarrationStatus.playing);
        final isPaused =
            _sessionPaused ||
            (!isPlaying && controllerStatus == NarrationStatus.paused);
''',
    '''        final finished =
            controllerIsCurrent &&
            controllerStatus == NarrationStatus.idle &&
            widget.controller.totalCharacters > 0 &&
            widget.controller.currentOffset >= widget.controller.totalCharacters;
        final isPlaying =
            !finished &&
            (_sessionPlaying ||
                (!_sessionPaused &&
                    controllerStatus == NarrationStatus.playing));
        final isPaused =
            !finished &&
            (_sessionPaused ||
                (!isPlaying && controllerStatus == NarrationStatus.paused));
''',
    'player visible status',
)

player = replace_once(
    player,
    '''        final total = widget.controller.totalCharacters;
        final progress = (_sessionPlaying || _sessionPaused) && total > 0
            ? (_displayOffset / total).clamp(0.0, 1.0).toDouble()
            : controllerIsCurrent
            ? widget.controller.progress
            : 0.0;
        final currentItem = (_sessionPlaying || _sessionPaused)
            ? _displayItemIndex
            : controllerIsCurrent
            ? widget.controller.currentItemIndex
            : null;
''',
    '''        final progress = controllerIsCurrent
            ? widget.controller.progress
            : 0.0;
        final currentItem = controllerIsCurrent
            ? widget.controller.currentItemIndex
            : null;
''',
    'player progress source',
)
player_path.write_text(player)


# 3) Give Discovery the same per-word highlighter as Story and compact its cards.
journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
old_discovery_text = '''                          child: Text(
                            state.displayText(item.text),
                            style: TextStyle(
                              fontSize: 10.2,
                              height: 1.15,
                              fontWeight: isActive
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
'''
new_discovery_text = '''                          child: InteractiveStoryText(
                            text: item.text,
                            entries: words,
                            narrationContentId: 'discovery',
                            narrationItemId: 'discovery-${entry.key}',
                            style: TextStyle(
                              fontSize: 9.9,
                              height: 1.12,
                              fontWeight: isActive
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
'''
journey = replace_once(
    journey,
    old_discovery_text,
    new_discovery_text,
    'Discovery word highlighter',
)
journey = replace_once(
    journey,
    '''                return Column(
                  children: discoveries
''',
    '''                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: discoveries
''',
    'Discovery top alignment',
)
journey = replace_once(
    journey,
    '''                      .toList(growable: false),
                );
''',
    '''                        .toList(growable: false),
                  ),
                );
''',
    'Discovery aligned column closing',
)
journey = replace_once(
    journey,
    'margin: const EdgeInsets.only(bottom: 2),\n      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),',
    'margin: const EdgeInsets.only(bottom: 1),\n      padding: const EdgeInsets.fromLTRB(3, 1, 1, 1),',
    'compact text block density',
)
journey_path.write_text(journey)


# 4) Make the vocabulary sheet content-sized instead of 88% fixed height.
sheet_path = Path('app/lib/widgets/word_detail_sheet.dart')
sheet = sheet_path.read_text()
sheet = replace_once(
    sheet,
    '''    builder: (_) => FractionallySizedBox(
      heightFactor: .88,
      child: _WordDetailSheet(
        entries: studyEntries,
        initialIndex: safeIndex,
        onSpeak: onSpeak,
        onSpeakEntry: onSpeakEntry,
      ),
    ),
''',
    '''    builder: (_) => _WordDetailSheet(
      entries: studyEntries,
      initialIndex: safeIndex,
      onSpeak: onSpeak,
      onSpeakEntry: onSpeakEntry,
    ),
''',
    'content-sized word sheet route',
)
sheet = replace_once(
    sheet,
    'final compact = MediaQuery.sizeOf(context).height < 720;',
    'final compact = MediaQuery.sizeOf(context).height < 780;',
    'word sheet compact threshold',
)
sheet = replace_once(
    sheet,
    '''          child: Column(
            children: [
''',
    '''          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
''',
    'word sheet minimum height column',
)
sheet = replace_once(
    sheet,
    '''              Expanded(
                child: _CoreExampleCard(
                  example: example,
                  nativeLabel: entry.nativeLabel(language),
                  nativeText: example?.nativeText(language) ?? '',
                  compact: compact,
                ),
              ),
''',
    '''              _CoreExampleCard(
                example: example,
                nativeLabel: entry.nativeLabel(language),
                nativeText: example?.nativeText(language) ?? '',
                compact: compact,
              ),
''',
    'content-sized example card',
)
for old, new, label in [
    ('WordMark(word: entry.word, size: compact ? 40 : 46)',
     'WordMark(word: entry.word, size: compact ? 34 : 38)',
     'word mark size'),
    ('fontSize: compact ? 21 : 24,', 'fontSize: compact ? 18.5 : 20,', 'word title size'),
    ('fontSize: 13,', 'fontSize: 11.5,', 'pinyin size'),
    ('const SizedBox(height: 7),\n              ClipRRect(',
     'const SizedBox(height: 5),\n              ClipRRect(',
     'header gap'),
    ('minHeight: 4,', 'minHeight: 3,', 'study progress height'),
    ('padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),',
     'padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),',
     'definition padding'),
    ('padding: EdgeInsets.all(compact ? 8 : 10),',
     'padding: EdgeInsets.all(compact ? 6 : 8),',
     'example padding'),
    ('mainAxisAlignment: MainAxisAlignment.center,\n', '', 'example vertical stretching'),
    ('minimumSize: const Size.fromHeight(40),',
     'minimumSize: const Size.fromHeight(36),',
     'first button height'),
]:
    sheet = replace_once(sheet, old, new, label)
# The second button has the same original height and remains after the first replacement.
sheet = replace_once(
    sheet,
    'minimumSize: const Size.fromHeight(40),',
    'minimumSize: const Size.fromHeight(36),',
    'second button height',
)
sheet_path.write_text(sheet)


# 5) Update regression gates to enforce the single timeline and content-sized sheet.
Path('worker/live_narration_highlight.test.mjs').write_text(r'''import test from 'node:test';
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
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('NarrationController is the only playback and highlight clock', () => {
  assert.doesNotMatch(player, /_positionClock/);
  assert.doesNotMatch(player, /syncPlaybackHighlight/);
  assert.match(controller, /setStartHandler\([\s\S]*_startProgressClock/);
  assert.match(controller, /final charsPerSecond = 3\.35/);
});

test('Story and Discovery share the same word highlight path', () => {
  assert.match(journey, /narrationContentId: 'story'/);
  assert.match(journey, /narrationContentId: 'discovery'/);
  assert.match(journey, /narrationItemId: 'discovery-\$\{entry\.key\}'/);
});

test('premature Safari completion cannot clear an active highlight', () => {
  assert.match(controller, /if \(_currentOffset < finalReadableOffset\)/);
  assert.match(controller, /_finishNarrationSession\(\)/);
});
''')

Path('worker/compact_word_study.test.mjs').write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('word study sheet follows its content and advances through the list', () => {
  assert.doesNotMatch(sheet, /FractionallySizedBox/);
  assert.match(sheet, /mainAxisSize: MainAxisSize\.min/);
  assert.doesNotMatch(sheet, /Expanded\([\s\S]*child: _CoreExampleCard/);
  assert.match(sheet, /下一个单词/);
  assert.match(sheet, /完成并收起/);
  assert.match(sheet, /if \(_isLast\) \{[\s\S]*Navigator\.of\(context\)\.pop/);
  assert.match(journey, /entries: words/);
  assert.match(journey, /onSpeakEntry:/);
});

test('Discovery cards follow text height and support word highlighting', () => {
  const start = journey.indexOf('Widget _discoveryPage()');
  const end = journey.indexOf('Widget _wonderPage()', start);
  const discovery = journey.slice(start, end);
  assert.match(discovery, /mainAxisSize: MainAxisSize\.min/);
  assert.match(discovery, /InteractiveStoryText/);
  assert.match(discovery, /fontSize: 9\.9/);
  assert.match(discovery, /height: 1\.12/);
});

test('narration keeps the natural Chinese voice profile', () => {
  assert.match(narration, /getVoices/);
  assert.match(narration, /natural/);
  assert.match(narration, /premium/);
  assert.match(narration, /NarrationSpeedOption\(label: '1\.0×', rate: \.36\)/);
  assert.match(narration, /setPitch\(\.98\)/);
});
''')
