import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const qualityAgent = PhoenixJourneyContentQualityAgent();

  final targetJourneys = <String, List<String>>{
    'beijing-forbidden-city': <String>[
      '梁砚',
      '沈岚',
      '午门',
      '太和殿',
      '修缮',
      '选择',
      '工牌',
      '复核',
      '拆检',
      '同长度',
    ],
    'shanghai-bund': <String>[
      '周玥',
      '韩澈',
      '外滩',
      '九十秒',
      '选择',
      '上传',
      '金融',
      '贸易',
      '天际线',
      '红笔校样',
    ],
  };

  test('Batch 1 preserves the existing Journey IDs and source evidence', () {
    expect(batchOneGoldJourneyIds, targetJourneys.keys.toSet());
    for (final journeyId in targetJourneys.keys) {
      final journey = requireDailyJourneyExperience(journeyId);
      expect(journey.id, journeyId);
      expect(journey.content.sourceIds.length, greaterThanOrEqualTo(2));
    }
  });

  test('Batch 1 uses exactly the canonical three Challenge modes', () {
    expect(
      fixedJourneyChallengeTypes,
      const <JourneyChallengeType>[
        JourneyChallengeType.paragraphRebuild,
        JourneyChallengeType.grammarRepair,
        JourneyChallengeType.missingSentence,
      ],
    );
  });

  for (final entry in targetJourneys.entries) {
    test('${entry.key} preserves narrative identity from Lv1 through Lv10', () {
      final journey = requireDailyJourneyExperience(entry.key);
      String? previousStory;

      for (final profile in levelAgent.allProfiles) {
        final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
        final story = content.storyParagraphs.join();
        final target = phoenixStoryLengthTargetFor(profile);

        expect(
          story.runes.length,
          inInclusiveRange(target.minimumCharacters, target.maximumCharacters),
          reason: '${entry.key} ${profile.displayLabel}',
        );
        expect(content.storyParagraphs, hasLength(target.paragraphCount));
        expect(content.storyAnnotations, hasLength(target.paragraphCount));
        expect(
          content.storyAnnotations.every(
            (annotation) =>
                annotation.pinyin.trim().isNotEmpty &&
                annotation.vietnamese.trim().isNotEmpty &&
                annotation.english.trim().isNotEmpty,
          ),
          isTrue,
        );
        for (final invariant in entry.value) {
          expect(story, contains(invariant), reason: profile.displayLabel);
        }
        expect(
          const <String>[
            '你先停下来',
            '你沿着主要路线向前',
            '游客举起手机',
            '探索者来到',
          ].every((filler) => !story.contains(filler)),
          isTrue,
        );
        expect(content.discoveries.length, inInclusiveRange(1, 2));
        expect(content.words, isNotEmpty);
        final context = '$story${content.discoveries.map((item) => item.text).join()}';
        expect(
          content.words.every((word) => context.contains(word.word)),
          isTrue,
          reason: '${entry.key} vocabulary must come from Story or Discovery',
        );
        expect(
          content.words.map((word) => word.word).toSet().length,
          content.words.length,
        );

        final decision = qualityAgent.inspect(
          experience: journey,
          content: content,
          profile: profile,
        );
        expect(
          decision.status,
          PhoenixJourneyReleaseStatus.approved,
          reason:
              '${entry.key} ${profile.displayLabel}: ${decision.recommendations.map((item) => item.code).join(', ')}',
        );

        if (previousStory != null) expect(story, isNot(previousStory));
        previousStory = story;
      }
    });
  }

  test('the two remediated Journeys have independent causal engines', () {
    final mastery = levelAgent.allProfiles.last;
    final forbidden = resolveAdaptiveJourneyLevel(
      requireDailyJourneyExperience('beijing-forbidden-city'),
      profile: mastery,
    ).storyParagraphs.join();
    final bund = resolveAdaptiveJourneyLevel(
      requireDailyJourneyExperience('shanghai-bund'),
      profile: mastery,
    ).storyParagraphs.join();

    expect(forbidden, contains('测量基准'));
    expect(forbidden, contains('拆检'));
    expect(forbidden, isNot(contains('九十秒')));
    expect(bund, contains('九十秒'));
    expect(bund, contains('红笔校样'));
    expect(bund, isNot(contains('测量基准')));
  });

  test('Batch 1 Memory is structured and Journey-specific', () {
    final forbidden = batchOneMemorySpecFor('beijing-forbidden-city');
    final bund = batchOneMemorySpecFor('shanghai-bund');

    expect(forbidden, isNotNull);
    expect(bund, isNotNull);
    expect(forbidden!.storyResult, contains('复核单'));
    expect(forbidden.longTermAnchor, contains('同长度'));
    expect(bund!.storyResult, contains('九十秒'));
    expect(bund.longTermAnchor, contains('红笔校样'));
    expect(forbidden.longTermAnchor, isNot(bund.longTermAnchor));
  });
}
