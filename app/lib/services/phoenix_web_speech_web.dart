// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'narration_voice_quality.dart';

typedef PhoenixSpeechStartCallback = void Function();
typedef PhoenixSpeechProgressCallback =
    void Function(int startOffset, int endOffset, String word);
typedef PhoenixSpeechCallback = void Function();
typedef PhoenixSpeechErrorCallback = void Function(String message);

final class PhoenixWebSpeech {
  PhoenixWebSpeech({
    required PhoenixSpeechStartCallback onStart,
    required PhoenixSpeechProgressCallback onProgress,
    required PhoenixSpeechCallback onComplete,
    required PhoenixSpeechCallback onPause,
    required PhoenixSpeechCallback onResume,
    required PhoenixSpeechErrorCallback onError,
  }) : _onStart = onStart,
       _onProgress = onProgress,
       _onComplete = onComplete,
       _onPause = onPause,
       _onResume = onResume,
       _onError = onError {
    _primeVoiceCatalog();
  }

  final PhoenixSpeechStartCallback _onStart;
  final PhoenixSpeechProgressCallback _onProgress;
  final PhoenixSpeechCallback _onComplete;
  final PhoenixSpeechCallback _onPause;
  final PhoenixSpeechCallback _onResume;
  final PhoenixSpeechErrorCallback _onError;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final List<Timer> _voiceWarmupTimers = [];
  List<html.SpeechSynthesisVoice> _voiceCatalog = const [];
  html.SpeechSynthesisUtterance? _utterance;
  Timer? _startupTimer;
  int _sessionToken = 0;
  int _startedSessionToken = 0;
  bool _paused = false;

  html.SpeechSynthesis? get _synth => html.window.speechSynthesis;
  bool get isAvailable => _synth != null;
  bool get isPaused => _paused;

  Future<bool> speak(
    String text, {
    required String languageCode,
    required double rate,
    double pitch = .98,
    double volume = 1,
    bool cancelExisting = true,
  }) async {
    final synth = _synth;
    if (synth == null || text.trim().isEmpty) return false;

    final token = ++_sessionToken;
    _startedSessionToken = 0;
    _paused = false;
    _cancelStartupTimer();
    _cancelSubscriptions();
    _refreshVoiceCatalog();
    // iOS Safari can silently discard the utterance that immediately follows
    // cancel(). Discovery autoplay is already entered from the Continue tap,
    // so preserve that user-gesture speech start instead of cancelling again.
    if (cancelExisting) synth.cancel();

    final naturalPitch = pitch == .98
        ? resolveNaturalNarrationPitch(languageCode)
        : pitch;
    final utterance = html.SpeechSynthesisUtterance(text)
      ..lang = languageCode
      ..rate = resolveNaturalNarrationRate(
        languageCode: languageCode,
        requestedRate: rate,
      )
      ..pitch = naturalPitch
      ..volume = volume;
    final voices = _voiceCatalog.isNotEmpty
        ? _voiceCatalog
        : synth.getVoices();
    final selectedVoice = _selectNaturalVoice(voices, languageCode);
    if (selectedVoice != null) utterance.voice = selectedVoice;
    _utterance = utterance;

    _subscriptions.add(
      utterance.onStart.listen((_) {
        if (token != _sessionToken) return;
        _paused = false;
        _markStarted(token);
      }),
    );
    _subscriptions.add(
      utterance.onBoundary.listen((event) {
        if (token != _sessionToken) return;
        _markStarted(token);
        final start = (event.charIndex ?? 0).clamp(0, text.length).toInt();
        final end = _findWordEnd(text, start);
        final word = start < end ? text.substring(start, end) : '';
        _onProgress(start, end, word);
      }),
    );
    _subscriptions.add(
      utterance.onPause.listen((_) {
        if (token != _sessionToken) return;
        _paused = true;
        _onPause();
      }),
    );
    _subscriptions.add(
      utterance.onResume.listen((_) {
        if (token != _sessionToken) return;
        _paused = false;
        _markStarted(token);
        _onResume();
      }),
    );
    _subscriptions.add(
      utterance.onEnd.listen((_) {
        if (token != _sessionToken) return;
        _cancelStartupTimer();
        _paused = false;
        _utterance = null;
        _cancelSubscriptions();
        _onComplete();
      }),
    );
    _subscriptions.add(
      utterance.onError.listen((event) {
        if (token != _sessionToken) return;
        _cancelStartupTimer();
        _paused = false;
        _utterance = null;
        _cancelSubscriptions();
        _onError(event.type);
      }),
    );

    synth.speak(utterance);
    _scheduleStartupCheck(token, synth, utterance);
    return true;
  }

  Future<bool> pause() async {
    final synth = _synth;
    if (synth == null || _utterance == null) return false;
    if (synth.paused == true) {
      _paused = true;
      return true;
    }
    synth.pause();
    _paused = true;
    return true;
  }

  Future<bool> resume() async {
    final synth = _synth;
    if (synth == null || _utterance == null) return false;
    synth.resume();
    _paused = false;
    return true;
  }

  Future<void> stop() async {
    _sessionToken += 1;
    _startedSessionToken = 0;
    _paused = false;
    _utterance = null;
    _cancelStartupTimer();
    _cancelSubscriptions();
    _synth?.cancel();
  }

  void _primeVoiceCatalog() {
    _refreshVoiceCatalog();
    for (final delay in const [
      Duration(milliseconds: 250),
      Duration(milliseconds: 900),
      Duration(milliseconds: 2400),
    ]) {
      _voiceWarmupTimers.add(Timer(delay, _refreshVoiceCatalog));
    }
  }

  void _refreshVoiceCatalog() {
    final voices = _synth?.getVoices() ?? const <html.SpeechSynthesisVoice>[];
    if (voices.isNotEmpty) {
      _voiceCatalog = List<html.SpeechSynthesisVoice>.unmodifiable(voices);
    }
  }

  void _scheduleStartupCheck(
    int token,
    html.SpeechSynthesis synth,
    html.SpeechSynthesisUtterance utterance,
  ) {
    _startupTimer = Timer(const Duration(milliseconds: 700), () {
      if (!_startupCheckIsCurrent(token, utterance)) return;
      final decision = resolveNarrationStartupDecision(
        startObserved: _startedSessionToken == token,
        synthesisSpeaking: synth.speaking == true,
        synthesisPending: synth.pending == true,
        finalCheck: false,
      );
      if (decision == NarrationStartupDecision.confirmStarted) {
        _markStarted(token);
        return;
      }

      _startupTimer = Timer(const Duration(milliseconds: 1800), () {
        if (!_startupCheckIsCurrent(token, utterance)) return;
        final finalDecision = resolveNarrationStartupDecision(
          startObserved: _startedSessionToken == token,
          synthesisSpeaking: synth.speaking == true,
          synthesisPending: synth.pending == true,
          finalCheck: true,
        );
        if (finalDecision == NarrationStartupDecision.confirmStarted) {
          _markStarted(token);
          return;
        }

        _sessionToken += 1;
        _startedSessionToken = 0;
        _utterance = null;
        _cancelSubscriptions();
        synth.cancel();
        _onError('speech-start-blocked');
      });
    });
  }

  bool _startupCheckIsCurrent(
    int token,
    html.SpeechSynthesisUtterance utterance,
  ) {
    return token == _sessionToken && identical(_utterance, utterance);
  }

  void _markStarted(int token) {
    if (token != _sessionToken || _startedSessionToken == token) return;
    _startedSessionToken = token;
    _cancelStartupTimer();
    _onStart();
  }

  html.SpeechSynthesisVoice? _selectNaturalVoice(
    List<html.SpeechSynthesisVoice> voices,
    String languageCode,
  ) {
    html.SpeechSynthesisVoice? bestVoice;
    var bestScore = -10000;
    for (final voice in voices) {
      final score = narrationVoiceScore(
        name: voice.name ?? '',
        locale: voice.lang ?? '',
        requestedLanguageCode: languageCode,
        localService: voice.localService == true,
      );
      if (score > bestScore) {
        bestScore = score;
        bestVoice = voice;
      }
    }
    return bestScore <= -10000 ? null : bestVoice;
  }

  int _findWordEnd(String text, int start) {
    if (start >= text.length) return text.length;
    if (_isCjkCodeUnit(text.codeUnitAt(start))) {
      return (start + 1).clamp(0, text.length).toInt();
    }
    var end = start + 1;
    while (end < text.length &&
        !RegExp(r'[\s，。！？；：、,.!?;:]').hasMatch(text[end])) {
      end += 1;
    }
    return end;
  }

  bool _isCjkCodeUnit(int value) {
    return (value >= 0x3400 && value <= 0x4DBF) ||
        (value >= 0x4E00 && value <= 0x9FFF) ||
        (value >= 0xF900 && value <= 0xFAFF);
  }

  void _cancelStartupTimer() {
    _startupTimer?.cancel();
    _startupTimer = null;
  }

  void _cancelSubscriptions() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
  }

  void dispose() {
    for (final timer in _voiceWarmupTimers) {
      timer.cancel();
    }
    _voiceWarmupTimers.clear();
    _cancelStartupTimer();
    unawaited(stop());
  }
}
