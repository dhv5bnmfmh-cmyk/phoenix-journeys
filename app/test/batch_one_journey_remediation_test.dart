import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  final journeys = <RemediatedJourney>[
    forbiddenCityRemediation,
    shanghaiBundRemediation,
  ];

  String firstSentence(String story) => '${story.split('。').first}。';

  group('Phoenix Batch 1 scope', () {
    test('contains exactly the two requested Journey IDs', () {
      expect(
        batchOneRemediatedJourneys.keys.toSet(),
        <String>{'beijing-forbidden-city', 'shanghai-bund'},
      );
      expect(batchOneJourneyIds, batchOneRemediatedJourneys.keys.toSet());
    });

    test('the two Journeys have different narrative contracts', () {
      expect(forbiddenCityRemediation.protagonist, isNot(shanghaiBundRemediation.protagonist));
      expect(forbiddenCityRemediation.goal, isNot(shanghaiBundRemediation.goal));
      expect(forbiddenCityRemediation.conflict, isNot(shanghaiBundRemediation.conflict));
      expect(
        forbiddenCityRemediation.completion.memoryAnchor,
        isNot(shanghaiBundRemediation.completion.memoryAnchor),
      );
    });
  });

  for (final journey in journeys) {
    group(journey.title, () {
      test('Story PASS: Lv1-Lv10 preserve one complete narrative', () {
        expect(journey.levels, hasLength(10));
        final opening = firstSentence(journey.levels.first.storyParagraphs.join());
        for (var level = 1; level <= 10; level++) {
          final content = journey.levelContent(level);
          final story = content.storyParagraphs.join();
          final target = phoenixStoryLengthTargetForLevel(level);
          expect(
            story.runes.length,
            inInclusiveRange(target.minimumCharacters, target.maximumCharacters),
            reason: '${journey.id} Lv$level must use the official reading band',
          );
          expect(content.storyParagraphs, hasLength(level <= 2 ? 1 : 2));
          expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
          expect(firstSentence(story), opening);
          expect(story, contains(journey.protagonist.split('，').first));
          expect(story, contains('选择'));
          expect(story, contains(journey.completion.memoryAnchor));
          expect(
            content.storyAnnotations.every(
              (entry) =>
                  entry.pinyin.trim().isNotEmpty &&
                  entry.vietnamese.trim().isNotEmpty &&
                  entry.english.trim().isNotEmpty,
            ),
            isTrue,
          );
        }
      });

      test('Words PASS: vocabulary is multilingual and traced to Story', () {
        final levelTenStory = journey.levelContent(10).storyParagraphs.join();
        expect(journey.words, hasLength(greaterThanOrEqualTo(10)));
        expect(journey.wordTraces, hasLength(journey.words.length));
        expect(journey.words.map((entry) => entry.word).toSet(), hasLength(journey.words.length));
        for (final word in journey.words) {
          expect(levelTenStory, contains(word.word), reason: '${word.word} must occur in Story');
          expect(word.pinyin.trim(), isNotEmpty);
          expect(word.partOfSpeech.trim(), isNotEmpty);
          expect(word.simpleChinese.trim(), isNotEmpty);
          expect(word.translation.trim(), isNotEmpty);
          expect(word.englishDefinition.trim(), isNotEmpty);
          expect(word.examples, hasLength(3));
          expect(
            word.examples.every(
              (example) =>
                  example.chinese.contains(word.word) &&
                  example.pinyin.trim().isNotEmpty &&
                  example.vietnamese.trim().isNotEmpty &&
                  example.english.trim().isNotEmpty,
            ),
            isTrue,
          );
        }
        for (var level = 1; level <= 10; level++) {
          final content = journey.levelContent(level);
          final story = content.storyParagraphs.join();
          expect(content.words.every((word) => story.contains(word.word)), isTrue);
        }
        final eventIds = journey.eventIds.toSet();
        expect(
          journey.wordTraces.every(
            (trace) =>
                journey.words.any((word) => word.word == trace.word) &&
                eventIds.contains(trace.eventId),
          ),
          isTrue,
        );
      });

      test('Discovery PASS: every item extends Story and binds reviewed sources', () {
        expect(journey.discoveries, hasLength(greaterThanOrEqualTo(4)));
        expect(journey.discoveryTraces, hasLength(journey.discoveries.length));
        final sourceIds = journey.sources.map((source) => source.id).toSet();
        final eventIds = journey.eventIds.toSet();
        for (final trace in journey.discoveryTraces) {
          expect(trace.discoveryIndex, inInclusiveRange(0, journey.discoveries.length - 1));
          expect(trace.storyEventIds, isNotEmpty);
          expect(trace.storyEventIds.every(eventIds.contains), isTrue);
          expect(trace.sourceIds, isNotEmpty);
          expect(trace.sourceIds.every(sourceIds.contains), isTrue);
          final discovery = journey.discoveries[trace.discoveryIndex];
          expect(discovery.text.trim(), isNotEmpty);
          expect(discovery.pinyin.trim(), isNotEmpty);
          expect(discovery.simpleChinese.trim(), isNotEmpty);
          expect(discovery.vietnamese.trim(), isNotEmpty);
          expect(discovery.english.trim(), isNotEmpty);
        }
      });

      test('Challenge PASS: exactly the three approved Story-derived modes', () {
        expect(journey.challenges.map((item) => item.type).toList(), batchOneChallengeTypes);
        final eventIds = journey.eventIds.toSet();
        expect(
          journey.challenges.every(
            (item) =>
                item.storyEventIds.isNotEmpty &&
                item.storyEventIds.every(eventIds.contains) &&
                item.anchor.trim().isNotEmpty,
          ),
          isTrue,
        );
      });

      test('Memory PASS: structured review covers six required lenses without writing', () {
        expect(
          journey.memory.map((item) => item.category).toSet(),
          <String>{
            'protagonist',
            'events',
            'history',
            'culture',
            'architecture',
            'vocabulary',
          },
        );
        final memoryText = journey.memory
            .map((item) => '${item.prompt}${item.answer}')
            .join();
        for (final forbidden in <String>[
          '写一篇',
          '写一段',
          '自由写作',
          '日记',
          '反思',
          '表达你的感受',
        ]) {
          expect(memoryText, isNot(contains(forbidden)));
        }
        expect(journey.memory.every((item) => item.answer.trim().isNotEmpty), isTrue);
      });

      test('Complete PASS: all five completion outcomes are implemented', () {
        final complete = journey.completion;
        expect(complete.journeySummary.trim(), isNotEmpty);
        expect(complete.achievement.trim(), isNotEmpty);
        expect(complete.memoryAnchor.trim(), isNotEmpty);
        expect(complete.challengeReward.trim(), isNotEmpty);
        expect(complete.journeyCompletion.trim(), isNotEmpty);
      });

      test('adaptive runtime resolves the exact target Journey at Lv1-Lv10', () {
        final experience = requireDailyJourneyExperience(journey.id);
        for (var level = 1; level <= 10; level++) {
          final profile = ChineseProficiencyProfile(
            track: ChineseExamTrack.hsk,
            levelCode: 'phoenix-$level',
            levelLabel: 'Lv.$level',
            band: PhoenixReadingBand.intermediate,
            phoenixLevel: level,
          );
          final resolved = resolveAdaptiveJourneyLevel(
            experience,
            profile: profile,
          );
          expect(
            resolved.storyParagraphs,
            journey.levelContent(level).storyParagraphs,
          );
        }
      });
    });
  }
}
