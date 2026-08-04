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

  test('all other Journey effective outputs stay exactly on the shared pipeline',
      () {
    for (final journey in allJourneyExperiences.where(
      (item) => item.id != 'beijing-summer-palace',
    )) {
      for (final profile in agent.allProfiles) {
        final public = resolveAdaptiveJourneyLevel(journey, profile: profile);
        final shared = resolveSharedAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );

        expect(public.storyParagraphs, shared.storyParagraphs,
            reason: '${journey.id} ${profile.displayLabel} Story');
        expect(
          public.storyAnnotations
              .map((entry) => (
                    entry.pinyin,
                    entry.vietnamese,
                    entry.english,
                  ))
              .toList(growable: false),
          shared.storyAnnotations
              .map((entry) => (
                    entry.pinyin,
                    entry.vietnamese,
                    entry.english,
                  ))
              .toList(growable: false),
          reason: '${journey.id} ${profile.displayLabel} annotations',
        );
        expect(
          public.words
              .map((entry) => (
                    entry.word,
                    entry.pinyin,
                    entry.translation,
                    entry.englishDefinition,
                  ))
              .toList(growable: false),
          shared.words
              .map((entry) => (
                    entry.word,
                    entry.pinyin,
                    entry.translation,
                    entry.englishDefinition,
                  ))
              .toList(growable: false),
          reason: '${journey.id} ${profile.displayLabel} vocabulary',
        );
        expect(
          public.discoveries
              .map((entry) => (
                    entry.text,
                    entry.pinyin,
                    entry.vietnamese,
                    entry.english,
                  ))
              .toList(growable: false),
          shared.discoveries
              .map((entry) => (
                    entry.text,
                    entry.pinyin,
                    entry.vietnamese,
                    entry.english,
                  ))
              .toList(growable: false),
          reason: '${journey.id} ${profile.displayLabel} Discovery',
        );
        expect(public.wonderQuestion, shared.wonderQuestion);
        expect(public.expressQuestion, shared.expressQuestion);
      }
    }
  });

  test('Easy, Standard, and Challenge preserve caused consequence and ending',
      () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');
    for (final difficulty in JourneyDifficulty.values) {
      final content = resolveJourneyLevel(journey, difficulty);
      final story = content.storyParagraphs.join();
      final orderedEvidence = <String>[
        '十七岁',
        '校展',
        '周岚',
        '长廊',
        '修复',
        '十七孔桥',
        '旧照片',
        '选择',
        '捡',
        '错失',
        '外婆',
        '万寿山',
        '《留下痕迹的风景》',
        '不再替她调整构图',
        '交给她保存',
      ];
      var cursor = -1;
      for (final evidence in orderedEvidence) {
        final next = story.indexOf(evidence, cursor + 1);
        expect(next, greaterThan(cursor),
            reason: '${difficulty.name} ordered event $evidence');
        cursor = next;
      }
    }
  });
}
