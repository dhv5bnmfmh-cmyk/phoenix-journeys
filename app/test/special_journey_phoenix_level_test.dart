import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/special_journey_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('catalog exposes nine special journeys', () {
    expect(specialJourneyExperiences, hasLength(9));
    expect(
      specialJourneyExperiences.map((item) => item.id).toSet(),
      <String>{
        'literary-roaming',
        'myth-tracing',
        'strange-night-talks',
        'folk-secret-land',
        'changan-last-bus',
        'tide-letter',
        'arcade-lost-property',
        'tea-horse-echo',
        'ice-city-star-map',
      },
    );
  });

  for (final profile in levelAgent.allProfiles) {
    test('${profile.displayLabel} shapes every special journey', () {
      final target = phoenixStoryLengthTargetFor(profile);
      for (final journey in specialJourneyExperiences) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final characters = content.storyParagraphs.join().runes.length;

        expect(
          characters,
          inInclusiveRange(target.minimumCharacters, target.maximumCharacters),
          reason: '${journey.id} ${profile.displayLabel} length',
        );
        expect(
          content.storyParagraphs,
          hasLength(target.paragraphCount),
          reason: '${journey.id} ${profile.displayLabel} paragraph shape',
        );
        expect(
          content.storyAnnotations,
          hasLength(content.storyParagraphs.length),
          reason: '${journey.id} multilingual alignment',
        );
        expect(
          content.storyAnnotations.every(
            (item) =>
                item.pinyin.trim().isNotEmpty &&
                item.vietnamese.trim().isNotEmpty &&
                item.english.trim().isNotEmpty,
          ),
          isTrue,
          reason: '${journey.id} multilingual support',
        );
      }
    });
  }

  test('special journeys retain their own genre signatures at higher levels', () {
    final profile = levelAgent.allProfiles[7];
    final requiredSignals = <String, List<String>>{
      'literary-roaming': <String>['蝴蝶', '竹林', '梦'],
      'myth-tracing': <String>['桂花', '竹简', '白兔'],
      'strange-night-talks': <String>['客栈', '铜钱', '鸡鸣'],
      'folk-secret-land': <String>['河灯', '逆流', '倒影'],
      'changan-last-bus': <String>['末班车', '铜镜', '车票'],
      'tide-letter': <String>['收音机', '潮声', '渡船'],
      'arcade-lost-property': <String>['红伞', '骑楼', '失物'],
      'tea-horse-echo': <String>['录音', '马帮', '古道'],
      'ice-city-star-map': <String>['旧厂', '星图', '工人'],
    };
    const forbiddenHeritageFiller = <String>[
      '建筑材料',
      '门窗修缮',
      '街道、气候',
      '保护遗产并不是把它冻结',
    ];

    for (final journey in specialJourneyExperiences) {
      final story = resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
      ).storyParagraphs.join();
      expect(
        requiredSignals[journey.id]!.every(story.contains),
        isTrue,
        reason: '${journey.id} should retain its genre vocabulary',
      );
      expect(
        forbiddenHeritageFiller.any(story.contains),
        isFalse,
        reason: '${journey.id} should not use urban heritage filler',
      );
    }
  });

  test('special journeys do not collapse into the same expanded story', () {
    final profile = levelAgent.allProfiles.last;
    final stories = <String>{
      for (final journey in specialJourneyExperiences)
        resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        ).storyParagraphs.join(),
    };
    expect(stories, hasLength(specialJourneyExperiences.length));
  });
}
