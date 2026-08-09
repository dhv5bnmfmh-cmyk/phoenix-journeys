import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_one_pass.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_vocabulary_curation.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Nanjing curated Words respect the canonical Phoenix ceiling at every level', () {
    for (var level = 1; level <= 10; level++) {
      final profile = levelAgent.profileForPhoenixLevel(level);
      final plan = levelAgent.planFor(profile);
      final content = nanjingQinhuaiCuratedLevelContent(level);
      // ignore: avoid_print
      print(
        'NANJING_VOCAB_METRIC Lv$level words=${content.words.length} maximum=${plan.maximumVocabularyCount}',
      );
      expect(content.words, isNotEmpty, reason: 'Lv$level should teach useful Story vocabulary');
      expect(
        content.words.length,
        lessThanOrEqualTo(plan.maximumVocabularyCount),
        reason: 'Lv$level must conform to the global Phoenix vocabulary ceiling',
      );
    }
  });

  test('every retained Word remains exact Story-derived and first-appearance truthful', () {
    final stories = <String>[
      for (final content in nanjingQinhuaiOnePassLevels)
        content.storyParagraphs.join(),
    ];

    for (var level = 1; level <= 10; level++) {
      final content = nanjingQinhuaiCuratedLevelContent(level);
      final story = content.storyParagraphs.join();
      final names = content.words.map((entry) => entry.word).toList(growable: false);
      expect(names.toSet(), hasLength(names.length), reason: 'Lv$level duplicate formal Word');

      for (final entry in content.words) {
        expect(story, contains(entry.word), reason: 'Lv$level ${entry.word} exact Story occurrence');
        final recordedFirst = nanjingQinhuaiWordFirstAppears[entry.word];
        expect(recordedFirst, isNotNull, reason: '${entry.word} has first-appearance metadata');
        final actualFirst = stories.indexWhere((item) => item.contains(entry.word)) + 1;
        expect(actualFirst, recordedFirst, reason: '${entry.word} truthful first appearance');
        expect(recordedFirst, lessThanOrEqualTo(level), reason: 'Lv$level cannot expose a higher-level-only Word');

        final trace = nanjingQinhuaiWordTraces.singleWhere(
          (item) => item.word == entry.word,
        );
        expect(trace.sourceText, contains(entry.word), reason: '${entry.word} source text');
        expect(stories.any((item) => item.contains(trace.sourceText)), isTrue);
      }
    }
  });

  test('production runtime returns the same curated Nanjing Word package', () {
    final experience = requireDailyJourneyExperience(nanjingQinhuaiJourneyId);
    for (var level = 1; level <= 10; level++) {
      final expected = nanjingQinhuaiCuratedLevelContent(level);
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      expect(
        resolved.words.map((entry) => entry.word),
        orderedEquals(expected.words.map((entry) => entry.word)),
        reason: 'Lv$level runtime and canonical curation must not drift',
      );
      expect(
        resolved.storyParagraphs,
        same(expected.storyParagraphs),
        reason: 'Lv$level Story remains the existing canonical package',
      );
      expect(resolved.discoveries, hasLength(1));
    }
  });
}
