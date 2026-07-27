import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/widgets/city_journey_stamp.dart';

void main() {
  for (final journeyId in const [
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    testWidgets('$journeyId uses its shaped collectible stamp', (tester) async {
      final journey = requireDailyJourneyExperience(journeyId);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CityJourneyStamp(
                journey: journey,
                isUnlocked: true,
                size: 128,
              ),
            ),
          ),
        ),
      );

      expect(
        find.byKey(ValueKey('special-journey-stamp-$journeyId')),
        findsOneWidget,
      );
      expect(find.byType(CustomPaint), findsWidgets);
    });
  }
}
