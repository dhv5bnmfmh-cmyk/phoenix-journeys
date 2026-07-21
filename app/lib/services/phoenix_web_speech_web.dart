// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

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
       _onError = onError;

  final PhoenixSpeechStartCallback _onStart;
  final PhoenixSpeechProgressCallback _onProgress;
  final PhoenixSpeechCallback _onComplete;
  final PhoenixSpeechCallback _onPause;
  final PhoenixSpeechCallback _onResume;
  final PhoenixSpeechErrorCallback _onError;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  html.SpeechSynthesisUtterance? _utterance;
  int _sessionToken = 0;
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
  }) async {
    final synth = _synth;
    if (synth == null || text.trim().isEmpty) return false;

    final token = ++_sessionToken;
    _paused = false;
    _cancelSubscriptions();
    synth.cancel();

    final utterance = html.SpeechSynthesisUtterance(text)
      ..lang = languageCode
      ..rate = rate
      ..pitch = pitch
      ..volume = volume;
    final selectedVoice = _selectNaturalVoice(
      synth.getVoices(),
      languageCode,
    );
    if (selectedVoice != null) utterance.voice = selectedVoice;
    _utterance = utterance;

    _subscriptions.add(
      utterance.onStart.listen((_) {
        if (token != _sessionToken) return;
        _paused = false;
        _onStart();
      }),
    );
    _subscriptions.add(
      utterance.onBoundary.listen((event) {
        if (token != _sessionToken) return;
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
        _onResume();
      }),
    );
    _subscriptions.add(
      utterance.onEnd.listen((_) {
        if (token != _sessionToken) return;
        _paused = false;
        _utterance = null;
        _cancelSubscriptions();
        _onComplete();
      }),
    );
    _subscriptions.add(
      utterance.onError.listen((event) {
        if (token != _sessionToken) return;
        _paused = false;
        _utterance = null;
        _cancelSubscriptions();
        _onError(event.type);
      }),
    );

    synth.speak(utterance);
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
    _paused = false;
    _utterance = null;
    _cancelSubscriptions();
    _synth?.cancel();
  }

  html.SpeechSynthesisVoice? _selectNaturalVoice(
    List<html.SpeechSynthesisVoice> voices,
    String languageCode,
  ) {
    final requested = languageCode.toLowerCase().replaceAll('_', '-');
    final prefix = requested.split('-').first;
    html.SpeechSynthesisVoice? bestVoice;
    var bestScore = -1;
    for (final voice in voices) {
      final locale = (voice.lang ?? '').toLowerCase().replaceAll('_', '-');
      if (!locale.startsWith(prefix)) continue;
      final name = (voice.name ?? '').toLowerCase();
      var score = 10;
      if (locale == requested) score += 100;
      if (name.contains('natural')) score += 70;
      if (name.contains('premium')) score += 60;
      if (name.contains('enhanced')) score += 50;
      if (name.contains('compact')) score -= 40;
      if (score > bestScore) {
        bestScore = score;
        bestVoice = voice;
      }
    }
    return bestVoice;
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

  void _cancelSubscriptions() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
  }

  void dispose() {
    unawaited(stop());
  }
}
