import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/data/summer_palace_adaptive_story_levels.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('Summer Palace Lv.1-10 preserve the exact ordered semantic event ledger',
      () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');

    for (var level = 1; level <= 10; level += 1) {
      final profile = agent.profileForPhoenixLevel(level);
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final target = phoenixStoryLengthTargetFor(profile);
      final story = content.storyParagraphs.join();
      final visibleContext = <String>[
        story,
        ...content.discoveries.map((entry) => entry.text),
      ].join();

      expect(
        summerPalaceN1EventOrderForLevel(level),
        summerPalaceN1RequiredEventOrder,
        reason: 'Lv.$level event order',
      );
      expect(
        story.runes.length,
        inInclusiveRange(target.minimumCharacters, target.maximumCharacters),
        reason: 'Lv.$level length',
      );
      expect(content.storyParagraphs, hasLength(target.paragraphCount));
      expect(content.storyAnnotations, hasLength(target.paragraphCount));
      expect(
        summerPalaceN1ContainsGenericTouristEnrichment(content),
        isFalse,
        reason: 'Lv.$level must keep Xu Cheng as the only narrative voice',
      );
      for (final word in content.words) {
        expect(
          visibleContext,
          contains(word.word),
          reason: 'Lv.$level vocabulary ${word.word} must be learner-visible',
        );
      }
    }
  });

  test('the public resolver is exactly the unchanged shared pipeline for 33 Journeys',
      () {
    final otherJourneys = allJourneyExperiences
        .where(
          (journey) =>
              journey.id != 'beijing-summer-palace' &&
              journey.id != 'beijing-forbidden-city' &&
              journey.id != 'shanghai-bund',
        )
        .toList(growable: false);
    expect(otherJourneys, hasLength(33));

    for (final journey in otherJourneys) {
      for (final profile in agent.allProfiles) {
        final public = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final shared = resolveSharedAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        expect(public.storyParagraphs, shared.storyParagraphs,
            reason: '${journey.id} ${profile.displayLabel} Story');
        expect(
          public.storyAnnotations.map((entry) => (
                entry.pinyin,
                entry.vietnamese,
                entry.english,
              )),
          shared.storyAnnotations.map((entry) => (
                entry.pinyin,
                entry.vietnamese,
                entry.english,
              )),
          reason: '${journey.id} ${profile.displayLabel} annotations',
        );
        expect(
          public.words.map((entry) => entry.word),
          shared.words.map((entry) => entry.word),
          reason: '${journey.id} ${profile.displayLabel} vocabulary',
        );
        expect(
          public.discoveries.map((entry) => (
                entry.text,
                entry.pinyin,
                entry.vietnamese,
                entry.english,
              )),
          shared.discoveries.map((entry) => (
                entry.text,
                entry.pinyin,
                entry.vietnamese,
                entry.english,
              )),
          reason: '${journey.id} ${profile.displayLabel} Discovery',
        );
        expect(public.wonderQuestion, shared.wonderQuestion);
        expect(public.expressQuestion, shared.expressQuestion);
      }
    }
  });

  test('Easy, Standard, and Challenge keep the same ending state', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');
    for (final difficulty in JourneyDifficulty.values) {
      final story = resolveJourneyLevel(journey, difficulty)
          .storyParagraphs
          .join();
      final orderedEvidence = <String>[
        '十七岁',
        '校展',
        '周岚',
        '修复',
        '十七孔桥',
        '选择',
        '捡回',
        '错失',
        '《留下痕迹的风景》',
        '不再替她调整构图',
        '交给她保存',
      ];
      var cursor = -1;
      for (final evidence in orderedEvidence) {
        final next = story.indexOf(evidence, cursor + 1);
        expect(next, greaterThan(cursor),
            reason: '${difficulty.name}: $evidence must preserve causal order');
        cursor = next;
      }
      expect(
        story,
        contains('万寿山'),
        reason: '${difficulty.name}: relational photograph anchor',
      );
    }
  });

  test('legacy generic expansion demonstrates the tourist-voice regression', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');
    final legacy = resolveLegacySummerPalaceGenericExpansionForTesting(
      journey,
      profile: agent.profileForPhoenixLevel(10),
    );
    final pilot = resolveAdaptiveJourneyLevel(
      journey,
      profile: agent.profileForPhoenixLevel(10),
    );

    expect(
      legacy.storyParagraphs.join(),
      anyOf(
        contains('你先停下来'),
        contains('你沿着主要路线向前'),
        contains('游客举起手机'),
      ),
    );
    expect(summerPalaceN1ContainsGenericTouristEnrichment(pilot), isFalse);
  });
}
