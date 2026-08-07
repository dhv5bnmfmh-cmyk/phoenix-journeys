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
}
