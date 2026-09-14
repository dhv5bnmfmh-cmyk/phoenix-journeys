// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'narration_voice_quality.dart';

final class NarrationVoicePickerService {
  final List<StreamSubscription<dynamic>> _previewSubscriptions = [];
  html.SpeechSynthesisUtterance? _previewUtterance;
  int _previewToken = 0;

  html.SpeechSynthesis? get _synth => html.window.speechSynthesis;

  bool get isAvailable => _synth != null;

  String? selectedVoiceId(String languageCode) {
    return html.window.localStorage[narrationVoicePreferenceKey(languageCode)];
  }

  Future<List<NarrationVoiceOption>> loadVoices(String languageCode) async {
    final synth = _synth;
    if (synth == null) return const <NarrationVoiceOption>[];

    var voices = synth.getVoices();
    if (voices.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 280));
      voices = synth.getVoices();
    }
    if (voices.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 720));
      voices = synth.getVoices();
    }

    final options = voices.map(
      (voice) => NarrationVoiceOption(
        id: narrationVoiceId(
          name: voice.name ?? '',
          locale: voice.lang ?? '',
        ),
        name: voice.name ?? '系统声线',
        locale: voice.lang ?? languageCode,
        localService: voice.localService == true,
        score: 0,
      ),
    );
    return rankNarrationVoiceOptions(
      voices: options,
      languageCode: languageCode,
      limit: 8,
    );
  }

  Future<void> selectVoice(String languageCode, String? voiceId) async {
    final key = narrationVoicePreferenceKey(languageCode);
    final value = voiceId?.trim();
    if (value == null || value.isEmpty) {
      html.window.localStorage.remove(key);
    } else {
      html.window.localStorage[key] = value;
    }
  }

  Future<bool> previewVoice({
    required NarrationVoiceOption voice,
    required String languageCode,
    required String sample,
    NarrationVoicePreviewProgress? onProgress,
    NarrationVoicePreviewCallback? onComplete,
    NarrationVoicePreviewCallback? onError,
  }) async {
    final synth = _synth;
    if (synth == null || sample.trim().isEmpty) return false;

    final matchingVoice = synth
        .getVoices()
        .cast<html.SpeechSynthesisVoice?>()
        .firstWhere(
          (candidate) {
            if (candidate == null) return false;
            return narrationVoiceId(
                  name: candidate.name ?? '',
                  locale: candidate.lang ?? '',
                ) ==
                voice.id;
          },
          orElse: () => null,
        );
    if (matchingVoice == null) return false;

    final token = ++_previewToken;
    _clearPreviewSubscriptions();
    synth.cancel();

    final utterance = html.SpeechSynthesisUtterance(sample)
      ..lang = languageCode
      ..voice = matchingVoice
      ..rate = .88
      ..pitch = resolveNaturalNarrationPitch(languageCode)
      ..volume = 1;
    _previewUtterance = utterance;

    _previewSubscriptions.add(
      utterance.onStart.listen((_) {
        if (!_previewIsCurrent(token, utterance)) return;
        onProgress?.call(.04);
      }),
    );
    _previewSubscriptions.add(
      utterance.onBoundary.listen((event) {
        if (!_previewIsCurrent(token, utterance)) return;
        final offset = (event.charIndex ?? 0).clamp(0, sample.length).toInt();
        final progress = sample.isEmpty ? 0.0 : offset / sample.length;
        onProgress?.call(progress.clamp(.04, .96).toDouble());
      }),
    );
    _previewSubscriptions.add(
      utterance.onEnd.listen((_) {
        if (!_previewIsCurrent(token, utterance)) return;
        onProgress?.call(1);
        _finishPreview(token, utterance);
        onComplete?.call();
      }),
    );
    _previewSubscriptions.add(
      utterance.onError.listen((_) {
        if (!_previewIsCurrent(token, utterance)) return;
        _finishPreview(token, utterance);
        onError?.call();
      }),
    );

    synth.speak(utterance);
    return true;
  }

  Future<void> stopPreview() async {
    _previewToken += 1;
    _previewUtterance = null;
    _clearPreviewSubscriptions();
    _synth?.cancel();
  }

  bool _previewIsCurrent(
    int token,
    html.SpeechSynthesisUtterance utterance,
  ) {
    return token == _previewToken && identical(_previewUtterance, utterance);
  }

  void _finishPreview(
    int token,
    html.SpeechSynthesisUtterance utterance,
  ) {
    if (!_previewIsCurrent(token, utterance)) return;
    _previewUtterance = null;
    _clearPreviewSubscriptions();
  }

  void _clearPreviewSubscriptions() {
    for (final subscription in _previewSubscriptions) {
      unawaited(subscription.cancel());
    }
    _previewSubscriptions.clear();
  }
}
