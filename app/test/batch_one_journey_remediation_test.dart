import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const requestedIds = <String>{
    'beijing-forbidden-city',
    'shanghai-bund',
  };

  group('Phoenix Batch 1 Journey remediation', () {
    test('scope preserves exactly the requested Journey IDs', () {
      expect(batchOneJourneyIds, requestedIds);
      for (final id in requestedIds) {
        expect(requireDailyJourneyExperience(id).id, id);
      }
    });

    test('Challenge contains exactly the three approved modes', () {
      expect(
        fixedJourneyChallengeTypes,
        const <JourneyChallengeType>[
          JourneyChallengeType.paragraphRebuild,
          JourneyChallengeType.grammarRepair,
          JourneyChallengeType.missingSentence,
        ],
      );
      for (final journey in batchOneRemediatedJourneys.values) {
        expect(
          journey.challenges.map((item) => item.type).toList(),
          batchOneChallengeTypes,
        );
      }
    });

    test('quality gates are computed from implemented content', () {
      final results = <String, bool>{};
      for (final id in requestedIds) {
        final experience = requireDailyJourneyExperience(id);
        final remediation = batchOneRemediationFor(id)!;
        final memory = batchOneMemorySpecFor(id);
        final protagonistName = remediation.protagonist.split('，').first;
        final timelineMarker =
            id == 'beijing-forbidden-city' ? '闭馆' : '开幕';
        final levels = levelAgent.allProfiles
            .map(
              (profile) => resolveAdaptiveJourneyLevel(
                experience,
                profile: profile,
              ),
            )
            .toList(growable: false);

        results['$id Story Continuity'] = levels.every((content) {
          final story = content.storyParagraphs.join();
          return story.contains('选择') && story.contains(protagonistName);
        });
        results['$id Timeline Consistency'] = levels.every(
          (content) => content.storyParagraphs.join().contains(timelineMarker),
        );
        results['$id Multilingual Consistency'] = levels.every(
          (content) =>
              content.storyAnnotations.length == content.storyParagraphs.length &&
              content.storyAnnotations.every(
                (annotation) =>
                    annotation.pinyin.trim().isNotEmpty &&
                    annotation.vietnamese.trim().isNotEmpty &&
                    annotation.english.trim().isNotEmpty,
              ),
        );
        results['$id Vocabulary Source Validation'] = levels.every((content) {
          final context = <String>[
            ...content.storyParagraphs,
            ...content.discoveries.map((entry) => entry.text),
          ].join();
          return content.words.isNotEmpty &&
              content.words.every(
                (word) =>
                    context.contains(word.word) &&
                    word.pinyin.trim().isNotEmpty &&
                    word.translation.trim().isNotEmpty &&
                    word.englishDefinition.trim().isNotEmpty,
              );
        });
        results['$id Discovery Quality'] = levels.every(
          (content) =>
              content.discoveries.isNotEmpty &&
              content.discoveries.length <= 2 &&
              content.discoveries.every(
                (entry) =>
                    entry.text.trim().isNotEmpty &&
                    entry.vietnamese.trim().isNotEmpty &&
                    entry.english.trim().isNotEmpty,
              ),
        );
        results['$id Historical Source Binding'] =
            remediation.discoveryTraces.every(
          (trace) =>
              trace.storyEventIds.isNotEmpty && trace.sourceIds.isNotEmpty,
        );
        results['$id Memory Quality'] = memory != null &&
            remediation.memory.map((item) => item.category).toSet().containsAll(
              <String>{
                'protagonist',
                'events',
                'history',
                'culture',
                'architecture',
                'vocabulary',
              },
            ) &&
            memory.storyResult.trim().isNotEmpty &&
            memory.culturalPoint.trim().isNotEmpty &&
            memory.longTermAnchor.trim().isNotEmpty;
        results['$id Complete Quality'] = memory != null &&
            remediation.completion.journeySummary.trim().isNotEmpty &&
            remediation.completion.achievement.trim().isNotEmpty &&
            remediation.completion.memoryAnchor.trim().isNotEmpty &&
            remediation.completion.challengeReward.trim().isNotEmpty &&
            remediation.completion.journeyCompletion.trim().isNotEmpty;
        results['$id No Reflection or Writing'] = memory != null &&
            !<String>[
              ...remediation.memory.map((item) => item.answer),
              memory.storyResult,
              memory.culturalPoint,
              memory.longTermAnchor,
              memory.completionSummary,
            ].join().contains(RegExp('写一篇|写一段|自由写作|日记|反思'));

        for (var index = 0; index < levels.length; index++) {
          final profile = levelAgent.allProfiles[index];
          final target = phoenixStoryLengthTargetFor(profile);
          final story = levels[index].storyParagraphs.join();
          results['$id ${profile.displayLabel} length'] =
              story.runes.length >= target.minimumCharacters &&
              story.runes.length <= target.maximumCharacters;
        }
      }

      expect(
        results.entries.where((entry) => !entry.value).map((entry) => entry.key),
        isEmpty,
      );
    });

    test('the two Journeys keep independent protagonists and memory anchors', () {
      final forbidden = batchOneRemediationFor('beijing-forbidden-city')!;
      final bund = batchOneRemediationFor('shanghai-bund')!;
      expect(forbidden.protagonist, contains('梁砚'));
      expect(bund.protagonist, contains('林乔'));
      expect(
        forbidden.completion.memoryAnchor,
        isNot(bund.completion.memoryAnchor),
      );
      expect(
        forbidden.completion.journeySummary,
        isNot(bund.completion.journeySummary),
      );
    });
  });
}
