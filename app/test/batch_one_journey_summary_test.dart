import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';
import 'package:phoenix_journeys/widgets/batch_one_journey_summary.dart';

void main() {
  for (final journeyId in batchOneJourneyIds) {
    testWidgets('$journeyId Memory renders every canonical review category', (
      tester,
    ) async {
      final spec = batchOneMemorySpecFor(journeyId)!;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 420,
              height: 900,
              child: BatchOneJourneySummary(
                spec: spec,
                words: const <String>['证据', '复核'],
                challengeCompleted: true,
                displayText: (value) => value,
              ),
            ),
          ),
        ),
      );

      for (final review in spec.reviews) {
        expect(find.text(review.prompt), findsOneWidget);
        expect(find.textContaining(review.answer), findsOneWidget);
      }
      expect(find.text('Challenge 表现'), findsOneWidget);
      expect(find.text('长期记忆点'), findsOneWidget);
    });
  }

  testWidgets('Completion keeps canonical Journey result and closure', (
    tester,
  ) async {
    final journey = forbiddenCityRemediation;
    final spec = batchOneMemorySpecFor(journey.id)!;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 420,
            height: 900,
            child: BatchOneJourneySummary(
              spec: spec,
              words: journey.words.map((entry) => entry.word).toList(),
              challengeCompleted: true,
              displayText: (value) => value,
              completion: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('旅程结果'), findsOneWidget);
    expect(find.text(spec.storyResult), findsOneWidget);
    expect(find.text('旅程收束'), findsOneWidget);
    expect(find.text(spec.completionSummary), findsOneWidget);
  });
}
