import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_voice_quality.dart';

void main() {
  group('narration voice quality', () {
    test('prefers exact-locale natural voices over compact fallbacks', () {
      final natural = narrationVoiceScore(
        name: 'Microsoft Xiaoxiao Online (Natural)',
        locale: 'zh-CN',
        requestedLanguageCode: 'zh-CN',
        localService: false,
      );
      final compact = narrationVoiceScore(
        name: 'Chinese Compact',
        locale: 'zh-CN',
        requestedLanguageCode: 'zh-CN',
        localService: true,
      );

      expect(natural, greaterThan(compact));
    });

    test('keeps simplified and traditional Chinese regions distinct', () {
      final mainland = narrationVoiceScore(
        name: 'Mandarin Natural',
        locale: 'zh-CN',
        requestedLanguageCode: 'zh-CN',
        localService: false,
      );
      final taiwan = narrationVoiceScore(
        name: 'Mandarin Natural',
        locale: 'zh-TW',
        requestedLanguageCode: 'zh-CN',
        localService: false,
      );

      expect(mainland, greaterThan(taiwan));
    });

    test('rejects unrelated language voices', () {
      expect(
        narrationVoiceScore(
          name: 'English Natural',
          locale: 'en-US',
          requestedLanguageCode: 'zh-CN',
          localService: true,
        ),
        -10000,
      );
    });

    test('uses restrained language-specific prosody', () {
      expect(resolveNaturalNarrationPitch('zh-CN'), .96);
      expect(
        resolveNaturalNarrationRate(
          languageCode: 'zh-CN',
          requestedRate: 1.8,
        ),
        1.35,
      );
      expect(
        resolveNaturalNarrationRate(
          languageCode: 'en-US',
          requestedRate: .2,
        ),
        .55,
      );
    });
  });

  group('narration startup reliability', () {
    test('confirms playback when the browser reports speaking', () {
      expect(
        resolveNarrationStartupDecision(
          startObserved: false,
          synthesisSpeaking: true,
          synthesisPending: false,
          finalCheck: false,
        ),
        NarrationStartupDecision.confirmStarted,
      );
    });

    test('waits briefly for a queued utterance', () {
      expect(
        resolveNarrationStartupDecision(
          startObserved: false,
          synthesisSpeaking: false,
          synthesisPending: true,
          finalCheck: false,
        ),
        NarrationStartupDecision.wait,
      );
    });

    test('fails instead of leaving a silent fake-playing session', () {
      expect(
        resolveNarrationStartupDecision(
          startObserved: false,
          synthesisSpeaking: false,
          synthesisPending: false,
          finalCheck: true,
        ),
        NarrationStartupDecision.fail,
      );
    });
  });
}
