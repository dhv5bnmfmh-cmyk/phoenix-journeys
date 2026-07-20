import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'phoenix_web_speech.dart';

enum NarrationStatus { idle, playing, paused, error }

enum _NarrationSpeechMode { idle, narration, word }

@immutable
class NarrationSpeedOption {
  const NarrationSpeedOption({required this.label, required this.rate});

  final String label;
  final double rate;
}

@immutable
class NarrationItem {
  const NarrationItem({
    required this.id,
    required this.text,
    required this.label,
  });

  final String id;
  final String text;
  final String label;
}

@immutable
class NarrationHighlightSnapshot {
  const NarrationHighlightSnapshot({
    required this.contentId,
    required this.itemId,
    required this.itemText,
    required this.itemIndex,
    required this.start,
    required this.end,
    required this.word,
  });

  final String contentId;
  final String itemId;
  final String itemText;
  final int itemIndex;
  final int start;
  final int end;
  final String word;
}

class NarrationHighlightBus extends ChangeNotifier {
  NarrationHighlightBus._();

  static final NarrationHighlightBus instance = NarrationHighlightBus._();

  NarrationHighlightSnapshot? _snapshot;

  NarrationHighlightSnapshot? get snapshot => _snapshot;

  void update(NarrationHighlightSnapshot snapshot) {
    if (_snapshot?.contentId == snapshot.contentId &&
        _snapshot?.itemId == snapshot.itemId &&
        _snapshot?.start == snapshot.start &&
        _snapshot?.end == snapshot.end) {
      return;
    }
    _snapshot = snapshot;
    notifyListeners();
  }

  void clear({String? contentId}) {
    if (_snapshot == null) return;
    if (contentId != null && _snapshot?.contentId != contentId) return;
    _snapshot = null;
    notifyListeners();
  }
}

@immutable
class NarrationTextPlan {
  const NarrationTextPlan._({
    required this.items,
    required this.text,
    required this.itemStarts,
  });

  factory NarrationTextPlan.fromItems(List<NarrationItem> sourceItems) {
    final items = sourceItems
        .where((item) => item.text.trim().isNotEmpty)
        .toList(growable: false);
    final buffer = StringBuffer();
    final starts = <int>[];

    for (var index = 0; index < items.length; index += 1) {
      starts.add(buffer.length);
      buffer.write(items[index].text.trim());
      if (index != items.length - 1) buffer.write('\n');
    }

    return NarrationTextPlan._(
      items: items,
      text: buffer.toString(),
      itemStarts: starts,
    );
  }

  final List<NarrationItem> items;
  final String text;
  final List<int> itemStarts;

  bool get isEmpty => items.isEmpty || text.isEmpty;

  int? indexForOffset(int offset) {
    if (isEmpty) return null;

    final safeOffset = offset.clamp(0, text.length).toInt();
    for (var index = 0; index < itemStarts.length - 1; index += 1) {
      if (safeOffset < itemStarts[index + 1]) return index;
    }
    return itemStarts.length - 1;
  }

  int itemStart(int index) => itemStarts[index];

  int itemEnd(int index) {
    if (index >= items.length - 1) return text.length;
    return itemStarts[index + 1] - 1;
  }
}

class NarrationController extends ChangeNotifier {
  NarrationController({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _webSpeech = PhoenixWebSpeech(
      onStart: _handleWebStart,
      onProgress: _handleWebProgress,
      onComplete: _handleWebComplete,
      onPause: _handleWebPause,
      onResume: _handleWebResume,
      onError: _handleWebError,
    );
    _bindHandlers();
  }

  static const speedOptions = <NarrationSpeedOption>[
    NarrationSpeedOption(label: '0.8×', rate: .29),
    NarrationSpeedOption(label: '1.0×', rate: .36),
    NarrationSpeedOption(label: '1.2×', rate: .44),
    NarrationSpeedOption(label: '1.5×', rate: .54),
  ];

  final FlutterTts _tts;
  late final PhoenixWebSpeech _webSpeech;

  NarrationStatus _status = NarrationStatus.idle;
  NarrationTextPlan _plan = NarrationTextPlan.fromItems(
    const <NarrationItem>[],
  );
  String? _contentId;
  String? _errorMessage;
  int _speechBaseOffset = 0;
  int _currentOffset = 0;
  int? _currentItemIndex;
  double _speechRate = .36;
  bool _disposed = false;
  Timer? _progressTimer;
  DateTime? _estimateAnchorTime;
  int _estimateAnchorOffset = 0;
  DateTime? _lastNativeProgressAt;
  int _lastNativeOffset = 0;
  _NarrationSpeechMode _speechMode = _NarrationSpeechMode.idle;
  bool _suppressEngineCallbacks = false;
  DateTime? _ignoreEngineCallbacksUntil;
  bool _isSpeakingWord = false;
  bool _wordSpeechUnavailable = false;
  String? _spokenWord;
  Completer<bool>? _wordSpeechCompleter;
  String? _configuredVoiceLanguage;
  NarrationHighlightSnapshot? _highlightSnapshot;
  int _speechSessionToken = 0;
  bool _webSpeechPausedInPlace = false;
  bool _restartWebSpeechOnResume = false;

  NarrationStatus get status => _status;
  String? get contentId => _contentId;
  String? get errorMessage => _errorMessage;
  int? get currentItemIndex => _currentItemIndex;
  int get itemCount => _plan.items.length;
  bool get hasContent => !_plan.isEmpty;
  double get speechRate => _speechRate;
  int get currentOffset => _currentOffset;
  int get lastNativeOffset => _lastNativeOffset;
  bool get hasFreshNativeProgress {
    final last = _lastNativeProgressAt;
    return last != null &&
        DateTime.now().difference(last).inMilliseconds < 1200;
  }

  int get totalCharacters => _plan.text.length;
  bool get isSpeakingWord => _isSpeakingWord;
  bool get wordSpeechUnavailable => _wordSpeechUnavailable;
  String? get spokenWord => _spokenWord;
  NarrationHighlightSnapshot? get highlightSnapshot {
    final contentId = _contentId;
    final sessionActive =
        _status == NarrationStatus.playing || _status == NarrationStatus.paused;
    final itemIndex =
        _currentItemIndex ??
        (sessionActive ? _plan.indexForOffset(_currentOffset) : null);
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

    final localEnd =
        (localStart + _fallbackHighlightLength(item.text, localStart))
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

  String get speedLabel {
    return speedOptions
        .firstWhere(
          (option) => (option.rate - _speechRate).abs() < .001,
          orElse: () => speedOptions[1],
        )
        .label;
  }

  String? get currentItemLabel {
    final index = _currentItemIndex;
    if (index == null || index < 0 || index >= _plan.items.length) {
      return null;
    }
    return _plan.items[index].label;
  }

  double get progress {
    if (_plan.text.isEmpty) return 0;
    final value = _currentOffset / _plan.text.length;
    return value.clamp(0.0, 1.0).toDouble();
  }

  bool get _shouldIgnoreEngineCallback {
    if (_suppressEngineCallbacks) return true;
    final until = _ignoreEngineCallbacksUntil;
    return until != null && DateTime.now().isBefore(until);
  }


  void _handleWebStart() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.playing;
    _errorMessage = null;
    _startProgressClock(_currentOffset);
    _safeNotify();
  }

  void _handleWebProgress(int startOffset, int endOffset, String word) {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    final globalStart = _speechBaseOffset + startOffset;
    final globalEnd = _speechBaseOffset + endOffset;
    final now = DateTime.now();
    _lastNativeOffset = globalStart;
    _lastNativeProgressAt = now;
    _estimateAnchorTime = now;
    _estimateAnchorOffset = globalStart;
    _applyProgress(globalStart, endOffset: globalEnd, word: word);
  }

  void _handleWebComplete() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _webSpeechPausedInPlace = false;
    _restartWebSpeechOnResume = false;
    _finishNarrationSession();
  }

  void _handleWebPause() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.paused;
    _cancelProgressClock();
    _safeNotify();
  }

  void _handleWebResume() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.playing;
    _startProgressClock(_currentOffset);
    _safeNotify();
  }

  void _handleWebError(String message) {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _cancelProgressClock();
    _speechMode = _NarrationSpeechMode.idle;
    _status = NarrationStatus.error;
    _errorMessage = '当前设备暂时无法朗读，请检查声音设置后重试。';
    _currentItemIndex = null;
    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    debugPrint('Phoenix web narration error: $message');
    _safeNotify();
  }

  void _bindHandlers() {
    _tts.setStartHandler(() {
      if (_shouldIgnoreEngineCallback) return;
      if (_speechMode == _NarrationSpeechMode.word) {
        _isSpeakingWord = true;
        _wordSpeechUnavailable = false;
        _safeNotify();
        return;
      }
      if (_speechMode != _NarrationSpeechMode.narration) return;
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _startProgressClock(_currentOffset);
      _safeNotify();
    });
    _tts.setCompletionHandler(() {
      if (_shouldIgnoreEngineCallback) return;
      if (_speechMode == _NarrationSpeechMode.word) {
        _finishWordSpeech(success: true);
        return;
      }
      if (_speechMode != _NarrationSpeechMode.narration) return;

      // Safari can report completion before the audible voice has finished.
      // Keep the single Phoenix clock alive until it reaches the text end.
      final finalReadableOffset = _plan.text.isEmpty
          ? 0
          : _plan.text.length - 1;
      if (_currentOffset < finalReadableOffset) {
        if (_progressTimer == null) _startProgressClock(_currentOffset);
        return;
      }
      _finishNarrationSession();
    });
    _tts.setCancelHandler(() {
      if (_shouldIgnoreEngineCallback) return;
      if (_speechMode == _NarrationSpeechMode.word) {
        _finishWordSpeech(success: true);
        return;
      }
      if (_status == NarrationStatus.paused ||
          _speechMode != _NarrationSpeechMode.narration) {
        return;
      }
      _cancelProgressClock();
      _speechMode = _NarrationSpeechMode.idle;
      _status = NarrationStatus.idle;
      _currentItemIndex = null;
      _highlightSnapshot = null;
      NarrationHighlightBus.instance.clear(contentId: _contentId);
      _safeNotify();
    });
    _tts.setProgressHandler((wordText, startOffset, endOffset, word) {
      if (_shouldIgnoreEngineCallback ||
          _speechMode != _NarrationSpeechMode.narration) {
        return;
      }
      final globalStart = _speechBaseOffset + startOffset;
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
    });
    _tts.setErrorHandler((message) {
      if (_speechMode == _NarrationSpeechMode.word) {
        debugPrint('Word narration error: $message');
        _finishWordSpeech(success: false);
        return;
      }
      _cancelProgressClock();
      _speechMode = _NarrationSpeechMode.idle;
      _status = NarrationStatus.error;
      _errorMessage = '当前设备暂时无法朗读，请检查声音设置后重试。';
      _currentItemIndex = null;
      _highlightSnapshot = null;
      NarrationHighlightBus.instance.clear(contentId: _contentId);
      debugPrint('Narration error: $message');
      _safeNotify();
    });
  }

  Future<void> play({
    required String contentId,
    required List<NarrationItem> items,
  }) async {
    final plan = NarrationTextPlan.fromItems(items);
    if (plan.isEmpty) return;

    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    _contentId = contentId;
    _plan = plan;
    _currentOffset = 0;
    _lastNativeOffset = 0;
    _lastNativeProgressAt = null;
    _currentItemIndex = 0;
    _errorMessage = null;
    _status = NarrationStatus.playing;
    _speechMode = _NarrationSpeechMode.narration;
    _webSpeechPausedInPlace = false;
    _restartWebSpeechOnResume = false;
    _applyProgress(0);
    await _speakFrom(0);
  }

  Future<void> pause() async {
    await pauseAtOffset(_currentOffset);
  }

  Future<void> pauseAtOffset(int offset) async {
    if (_plan.isEmpty || _disposed) return;

    final maxOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _cancelProgressClock();
    _applyProgress(safeOffset);

    if (_webSpeech.isAvailable) {
      final paused = await _webSpeech.pause();
      if (_disposed) return;
      _webSpeechPausedInPlace = paused;
      _status = NarrationStatus.paused;
      _currentOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _applyProgress(safeOffset);
      return;
    }

    _speechBaseOffset = safeOffset;
    await _stopSpeechEngine();
    if (_disposed) return;

    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _applyProgress(safeOffset);
  }

  Future<void> resume() async {
    if (_status != NarrationStatus.paused || _plan.isEmpty) return;
    await resumeFromOffset(_currentOffset);
  }

  Future<void> resumeFromOffset(int offset) async {
    if (_plan.isEmpty || _disposed) return;

    final maxOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _cancelProgressClock();
    _applyProgress(safeOffset);

    if (_webSpeech.isAvailable) {
      final resumeInPlace =
          _webSpeechPausedInPlace && !_restartWebSpeechOnResume;
      _webSpeechPausedInPlace = false;
      final restartAtSavedOffset = _restartWebSpeechOnResume;
      _restartWebSpeechOnResume = false;

      if (resumeInPlace) {
        _status = NarrationStatus.playing;
        _startProgressClock(safeOffset);
        _safeNotify();
        final resumed = await _webSpeech.resume();
        if (resumed || _disposed) return;
      }

      if (restartAtSavedOffset || !_disposed) {
        await _speakFrom(safeOffset);
      }
      return;
    }

    await _stopSpeechEngine();
    if (_disposed) return;

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (_disposed) return;
    _ignoreEngineCallbacksUntil = null;
    await _speakFrom(safeOffset, stopEngineFirst: false);
  }

  Future<bool> speakWord(String word, {required String languageCode}) async {
    final value = word.trim();
    if (value.isEmpty || _disposed) return false;

    if (_status == NarrationStatus.playing) {
      await pause();
    }
    await _stopSpeechEngine();
    if (_disposed) return false;

    _speechMode = _NarrationSpeechMode.word;
    _spokenWord = value;
    _isSpeakingWord = true;
    _wordSpeechUnavailable = false;
    final completer = Completer<bool>();
    _wordSpeechCompleter = completer;
    _safeNotify();

    try {
      await _configureNaturalVoice(languageCode);
      await _tts.setSpeechRate(.38);
      await _tts.setPitch(.98);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(value);
      if (result != 1) {
        _finishWordSpeech(success: false);
      }
    } catch (error) {
      debugPrint('Unable to pronounce $value: $error');
      _finishWordSpeech(success: false);
    }

    try {
      return await completer.future.timeout(const Duration(seconds: 8));
    } on TimeoutException {
      await _stopSpeechEngine();
      return false;
    }
  }

  Future<void> restart() async {
    if (_plan.isEmpty || _contentId == null) return;
    await _speakFrom(0);
  }

  Future<void> setSpeechRate(double rate) async {
    final option = speedOptions.reduce(
      (current, next) => (next.rate - rate).abs() < (current.rate - rate).abs()
          ? next
          : current,
    );
    if ((_speechRate - option.rate).abs() < .001) return;

    _speechRate = option.rate;
    if (_webSpeech.isAvailable && _status == NarrationStatus.paused) {
      _restartWebSpeechOnResume = true;
    }
    _safeNotify();
  }

  Future<void> stop({bool resetPosition = true}) async {
    _cancelProgressClock();
    _status = NarrationStatus.idle;
    _errorMessage = null;
    _currentItemIndex = null;
    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    if (resetPosition) {
      _currentOffset = 0;
      _speechBaseOffset = 0;
    }
    _safeNotify();

    await _stopSpeechEngine();
    if (_disposed) return;
    _status = NarrationStatus.idle;
    _currentItemIndex = null;
    _safeNotify();
  }

  Future<void> _configureNaturalVoice(String languageCode) async {
    await _tts.setLanguage(languageCode);
    if (_configuredVoiceLanguage == languageCode) return;

    try {
      final dynamic availableVoices = await _tts.getVoices;
      if (availableVoices is List) {
        Map<String, String>? bestVoice;
        var bestScore = -1;
        final requestedPrefix =
            languageCode.toLowerCase().split(RegExp('[-_]')).first;
        for (final dynamic rawVoice in availableVoices) {
          if (rawVoice is! Map) continue;
          final name = '${rawVoice['name'] ?? ''}';
          final locale = '${rawVoice['locale'] ?? rawVoice['language'] ?? ''}';
          final lowerName = name.toLowerCase();
          final lowerLocale = locale.toLowerCase();
          if (!lowerLocale.startsWith(requestedPrefix)) continue;

          var score = 10;
          if (lowerLocale == languageCode.toLowerCase()) score += 80;
          if (lowerName.contains('natural')) score += 60;
          if (lowerName.contains('premium')) score += 50;
          if (lowerName.contains('enhanced')) score += 45;
          if (requestedPrefix == 'zh') {
            for (final preferredName in const [
              'xiaoxiao',
              'tingting',
              'meijia',
              'yunxi',
              'sinji',
            ]) {
              if (lowerName.contains(preferredName)) score += 35;
            }
          }

          if (score > bestScore && name.isNotEmpty && locale.isNotEmpty) {
            bestScore = score;
            bestVoice = <String, String>{'name': name, 'locale': locale};
          }
        }
        if (bestVoice != null) await _tts.setVoice(bestVoice);
      }
    } catch (error) {
      debugPrint('Natural Chinese voice selection unavailable: $error');
    }

    _configuredVoiceLanguage = languageCode;
  }

  Future<void> _speakFrom(int offset, {bool stopEngineFirst = true}) async {
    if (_plan.isEmpty) return;
    final maxOffset = math.max(0, _plan.text.length - 1);
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    final remainingText = _plan.text.substring(safeOffset);

    try {
      _cancelProgressClock();
      if (stopEngineFirst) {
        await _stopSpeechEngine();
      }
      if (_disposed) return;

      _speechMode = _NarrationSpeechMode.narration;
      _lastNativeOffset = safeOffset;
      _lastNativeProgressAt = null;
      _speechBaseOffset = safeOffset;
      _currentOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _applyProgress(safeOffset);
      _safeNotify();
      final sessionToken = ++_speechSessionToken;

      if (_webSpeech.isAvailable) {
        _webSpeechPausedInPlace = false;
        _restartWebSpeechOnResume = false;
        unawaited(_startProgressWatchdog(sessionToken, safeOffset));
        final started = await _webSpeech.speak(
          remainingText,
          languageCode: 'zh-CN',
          rate: _speechRate,
          pitch: .98,
          volume: 1,
        );
        if (!started && !_disposed) {
          _cancelProgressClock();
          _speechMode = _NarrationSpeechMode.idle;
          _status = NarrationStatus.error;
          _errorMessage = '当前浏览器暂时无法朗读，请换用 Safari 或 Chrome 重试。';
          _safeNotify();
        }
        return;
      }

      await _configureNaturalVoice('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(.98);
      await _tts.setVolume(1.0);
      // Schedule Phoenix progress before invoking Safari. On iOS Web the
      // speak() call can hold the Dart continuation until the utterance ends.
      // Starting the watchdog first keeps percentage and the triangle marker
      // moving while audio is audible.
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
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
        _cancelProgressClock();
        _speechMode = _NarrationSpeechMode.idle;
        _status = NarrationStatus.error;
        _errorMessage = '没有找到可用的中文语音，请换用 Safari 或 Chrome 重试。';
        _currentItemIndex = null;
        _highlightSnapshot = null;
        NarrationHighlightBus.instance.clear(contentId: _contentId);
        _safeNotify();
      }
    } catch (error, stackTrace) {
      debugPrint('Unable to start narration: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (_disposed) return;
      _cancelProgressClock();
      _speechMode = _NarrationSpeechMode.idle;
      _status = NarrationStatus.error;
      _errorMessage = '朗读启动失败，请检查设备音量或浏览器权限。';
      _currentItemIndex = null;
      _highlightSnapshot = null;
      NarrationHighlightBus.instance.clear(contentId: _contentId);
      _safeNotify();
    }
  }

  Future<void> _startProgressWatchdog(int sessionToken, int offset) async {
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

  void _finishNarrationSession() {
    _speechSessionToken += 1;
    _cancelProgressClock();
    _speechMode = _NarrationSpeechMode.idle;
    _status = NarrationStatus.idle;
    _currentOffset = _plan.text.length;
    _currentItemIndex = null;
    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    _safeNotify();
  }

  void _finishWordSpeech({required bool success}) {
    _isSpeakingWord = false;
    _wordSpeechUnavailable = !success;
    _spokenWord = null;
    _speechMode = _NarrationSpeechMode.idle;
    final completer = _wordSpeechCompleter;
    _wordSpeechCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(success);
    }
    _safeNotify();
  }

  Future<void> _stopSpeechEngine() async {
    _speechSessionToken += 1;
    if (_webSpeech.isAvailable &&
        _speechMode != _NarrationSpeechMode.word) {
      await _webSpeech.stop();
      _webSpeechPausedInPlace = false;
      _restartWebSpeechOnResume = false;
      _speechMode = _NarrationSpeechMode.idle;
      _isSpeakingWord = false;
      _spokenWord = null;
      return;
    }
    _suppressEngineCallbacks = true;
    _ignoreEngineCallbacksUntil = DateTime.now().add(
      const Duration(milliseconds: 120),
    );
    try {
      await _tts.stop();
      await Future<void>.delayed(const Duration(milliseconds: 30));
    } catch (error) {
      debugPrint('Unable to stop speech engine: $error');
    } finally {
      _suppressEngineCallbacks = false;
    }

    if (_speechMode == _NarrationSpeechMode.word) {
      _finishWordSpeech(success: true);
    } else {
      _speechMode = _NarrationSpeechMode.idle;
      _isSpeakingWord = false;
      _spokenWord = null;
    }
  }

  void _startProgressClock(int offset) {
    _cancelProgressClock();
    _estimateAnchorOffset = offset;
    _estimateAnchorTime = DateTime.now();
    _lastNativeProgressAt = null;
    _progressTimer = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (_disposed || _status != NarrationStatus.playing || _plan.isEmpty) {
        return;
      }

      final now = DateTime.now();
      final nativeProgressIsFresh =
          _lastNativeProgressAt != null &&
          now.difference(_lastNativeProgressAt!).inMilliseconds < 650;
      if (nativeProgressIsFresh) return;

      final anchor = _estimateAnchorTime ?? now;
      final elapsedSeconds =
          now.difference(anchor).inMilliseconds.toDouble() / 1000;
      // Conservative fallback pace: native word callbacks remain exact;
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
    });
  }

  void _cancelProgressClock() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void _applyProgress(int offset, {int? endOffset, String word = ''}) {
    if (_plan.isEmpty) return;

    final safeOffset = offset.clamp(0, _plan.text.length).toInt();
    _currentOffset = safeOffset;
    final itemIndex = _plan.indexForOffset(safeOffset);
    _currentItemIndex = itemIndex;
    if (itemIndex == null || _contentId == null) {
      _safeNotify();
      return;
    }

    final item = _plan.items[itemIndex];
    final itemStart = _plan.itemStart(itemIndex);
    final itemEnd = _plan.itemEnd(itemIndex);
    var localStart = (safeOffset - itemStart)
        .clamp(0, item.text.length)
        .toInt();
    while (localStart < item.text.length &&
        _isBoundary(item.text.substring(localStart, localStart + 1))) {
      localStart += 1;
    }

    var localEnd = endOffset == null
        ? localStart + _fallbackHighlightLength(item.text, localStart)
        : endOffset - itemStart;
    localEnd = localEnd.clamp(localStart, item.text.length).toInt();
    if (localEnd == localStart && localStart < item.text.length) {
      localEnd = (localStart + 1).clamp(0, item.text.length).toInt();
    }

    if (safeOffset <= itemEnd && localStart < item.text.length) {
      final snapshot = NarrationHighlightSnapshot(
        contentId: _contentId!,
        itemId: item.id,
        itemText: item.text,
        itemIndex: itemIndex,
        start: localStart,
        end: localEnd,
        word: word,
      );
      _highlightSnapshot = snapshot;
      NarrationHighlightBus.instance.update(snapshot);
    }
    _safeNotify();
  }

  int _fallbackHighlightLength(String text, int start) {
    if (start >= text.length) return 0;
    var length = 1;
    while (length < 3 && start + length < text.length) {
      final character = text.substring(start + length, start + length + 1);
      if (_isBoundary(character)) break;
      length += 1;
    }
    return length;
  }

  bool _isBoundary(String character) {
    return RegExp(r'[\s，。！？；：、,.!?;:]').hasMatch(character);
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _speechSessionToken += 1;
    _disposed = true;
    _cancelProgressClock();
    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    _webSpeech.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }
}
