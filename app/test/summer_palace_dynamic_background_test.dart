import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/widgets/destination_background.dart';

void main() {
  testWidgets('Summer Palace living background respects reduced motion',
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
      find.byKey(const ValueKey('summer-palace-static-background')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-living-layer')),
      findsNothing,
    );
  });

  testWidgets('Summer Palace living scene advances at a capped frame rate',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DestinationBackground(
          journeyId: 'beijing-summer-palace',
          pageType: JourneyBackgroundPage.story,
          child: SizedBox.expand(),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('summer-palace-living-layer')),
      findsOneWidget,
    );

    final initialTransform = tester
        .widget<Transform>(
          find.byKey(const ValueKey('summer-palace-camera-transform')),
        )
        .transform
        .storage
        .toList(growable: false);

    await tester.pump(const Duration(seconds: 2));

    final laterTransform = tester
        .widget<Transform>(
          find.byKey(const ValueKey('summer-palace-camera-transform')),
        )
        .transform
        .storage
        .toList(growable: false);

    expect(laterTransform, isNot(orderedEquals(initialTransform)));
  });
}
