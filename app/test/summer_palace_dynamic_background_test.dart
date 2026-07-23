import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/widgets/destination_background.dart';

void main() {
  testWidgets('Summer Palace dynamic background respects reduced motion',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: DestinationBackground(
            journeyId: 'beijing-summer-palace',
            pageType: JourneyBackgroundPage.story,
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('summer-palace-dynamic-background')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-camera-layer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-cloud-light')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-water-shimmer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-foreground-breath')),
      findsOneWidget,
    );
  });
}
