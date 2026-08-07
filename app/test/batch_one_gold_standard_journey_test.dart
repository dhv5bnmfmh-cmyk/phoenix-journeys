import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';

void main() {
  test('Batch 1 summary adapter reads the canonical remediation records', () {
    for (final journeyId in batchOneJourneyIds) {
      final journey = batchOneRemediationFor(journeyId);
      final summary = batchOneMemorySpecFor(journeyId);

      expect(journey, isNotNull);
      expect(summary, isNotNull);
      expect(summary!.storyResult, journey!.completion.journeySummary);
      expect(summary.reviews, journey.memory);
      expect(
        summary.reviews.map((item) => item.category).toList(),
        <String>[
          'protagonist',
          'events',
          'history',
          'culture',
          'architecture',
          'vocabulary',
        ],
      );
      expect(summary.longTermAnchor, journey.completion.memoryAnchor);
      expect(summary.completionSummary, contains(journey.completion.achievement));
      expect(summary.completionSummary, contains(journey.completion.challengeReward));
    }
  });

  test('Batch 1 keeps exactly the approved Challenge modes', () {
    expect(
      batchOneChallengeTypes,
      <String>['paragraphRebuild', 'grammarRepair', 'missingSentence'],
    );
    for (final journey in batchOneRemediatedJourneys.values) {
      expect(
        journey.challenges.map((item) => item.type).toList(),
        batchOneChallengeTypes,
      );
    }
  });

  test('Batch 1 vocabulary examples never leak the other protagonist', () {
    final forbidden = batchOneRemediationFor('beijing-forbidden-city')!;
    final bund = batchOneRemediationFor('shanghai-bund')!;

    String examplesFor(RemediatedJourney journey) => journey.words
        .expand((entry) => entry.examples)
        .map(
          (example) => <String>[
            example.chinese,
            example.pinyin,
            example.vietnamese,
            example.english,
          ].join(' '),
        )
        .join('\n');

    final forbiddenExamples = examplesFor(forbidden);
    expect(forbiddenExamples, isNot(contains('陆潮')));
    expect(forbiddenExamples, isNot(contains('Lù Cháo')));
    expect(forbiddenExamples, isNot(contains('Lục Triều')));
    expect(forbiddenExamples, isNot(contains('Lu Chao')));

    final bundExamples = examplesFor(bund);
    expect(bundExamples, isNot(contains('纪衡')));
    expect(bundExamples, isNot(contains('Jì Héng')));
    expect(bundExamples, isNot(contains('Kỷ Hành')));
    expect(bundExamples, isNot(contains('Ji Heng')));
  });

  test('Batch 1 rejects the remediated Journeys previous plot engines', () {
    final forbiddenStory = batchOneRemediationFor('beijing-forbidden-city')!
        .levels
        .last
        .storyParagraphs
        .join();
    final bundStory = batchOneRemediationFor('shanghai-bund')!
        .levels
        .last
        .storyParagraphs
        .join();

    for (final oldAnchor in <String>['工牌', '投影长度', '斜长', '最快实习生']) {
      expect(forbiddenStory, isNot(contains(oldAnchor)));
    }
    for (final oldAnchor in <String>['旧照片', '底片编号', '说明牌', '档案志愿者']) {
      expect(bundStory, isNot(contains(oldAnchor)));
    }
  });
}
