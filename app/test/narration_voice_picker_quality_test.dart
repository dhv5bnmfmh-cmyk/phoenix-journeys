import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_voice_quality.dart';

void main() {
  test('voice preferences stay separate for simplified and traditional Chinese', () {
    expect(
      narrationVoicePreferenceKey('zh-CN'),
      'phoenix.narration.voice.zh-cn',
    );
    expect(
      narrationVoicePreferenceKey('zh_TW'),
      'phoenix.narration.voice.zh-tw',
    );
    expect(
      narrationVoiceId(name: 'Xiaoxiao Natural', locale: 'zh_CN'),
      'zh-cn::Xiaoxiao Natural',
    );
  });

  test('ranked picker keeps the strongest exact-locale voices first', () {
    final ranked = rankNarrationVoiceOptions(
      languageCode: 'zh-CN',
      voices: const [
        NarrationVoiceOption(
          id: 'zh-tw::Meijia',
          name: 'Meijia',
          locale: 'zh-TW',
          localService: true,
          score: 0,
        ),
        NarrationVoiceOption(
          id: 'zh-cn::Xiaoxiao Natural',
          name: 'Xiaoxiao Natural',
          locale: 'zh-CN',
          localService: false,
          score: 0,
        ),
        NarrationVoiceOption(
          id: 'zh-cn::Compact',
          name: 'Chinese Compact',
          locale: 'zh-CN',
          localService: true,
          score: 0,
        ),
      ],
    );

    expect(ranked.first.name, 'Xiaoxiao Natural');
    expect(ranked.first.qualityLabel, '自然声线');
    expect(ranked.last.name, isNot('Meijia'));
  });

  test('voice option limit keeps the picker concise', () {
    final voices = List.generate(
      12,
      (index) => NarrationVoiceOption(
        id: 'zh-cn::Voice $index',
        name: 'Voice $index',
        locale: 'zh-CN',
        localService: true,
        score: 0,
      ),
    );
    expect(
      rankNarrationVoiceOptions(
        voices: voices,
        languageCode: 'zh-CN',
        limit: 6,
      ),
      hasLength(6),
    );
  });
}
