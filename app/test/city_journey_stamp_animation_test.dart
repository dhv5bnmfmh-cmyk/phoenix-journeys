import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/widgets/city_journey_stamp.dart';

void main() {
  testWidgets('city stamp presses from above then removes the physical tool', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AnimatedCityJourneyStamp(
              journey: dailyJourneyExperiences.first,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('animated-city-journey-stamp')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('city-stamp-tool')), findsOneWidget);
    expect(find.byKey(const ValueKey('city-stamp-imprint')), findsOneWidget);

    expect(
      tester.widget<Opacity>(
        find.byKey(const ValueKey('city-stamp-tool')),
      ).opacity,
      1,
    );

    // The stamp agent starts in a post-frame callback, mirroring the real page.
    // Give that callback one frame before advancing through the full press.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1900));

    expect(
      tester.widget<Opacity>(
        find.byKey(const ValueKey('city-stamp-tool')),
      ).opacity,
      0,
    );
    expect(
      tester.widget<Opacity>(
        find.byKey(const ValueKey('city-stamp-imprint')),
      ).opacity,
      1,
    );
  });
}
