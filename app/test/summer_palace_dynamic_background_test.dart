import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/widgets/destination_background.dart';

void main() {
  const completePages = <JourneyBackgroundPage>[
    JourneyBackgroundPage.story,
    JourneyBackgroundPage.vocabulary,
    JourneyBackgroundPage.discovery,
    JourneyBackgroundPage.reflection,
    JourneyBackgroundPage.memory,
  ];

  for (final page in completePages) {
    testWidgets('Summer Palace ${page.name} shows the complete background',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DestinationBackground(
            journeyId: 'beijing-summer-palace',
            pageType: page,
            child: const SizedBox.expand(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(
          ValueKey(
            'journey-complete-background-beijing-summer-palace-${page.name}',
          ),
        ),
        findsOneWidget,
      );
      final image = tester.widget<Image>(
        find.byKey(
          ValueKey(
            'journey-complete-image-beijing-summer-palace-${page.name}',
          ),
        ),
      );
      expect(image.fit, BoxFit.contain);
      expect(
        find.byKey(const ValueKey('summer-palace-camera-transform')),
        findsNothing,
      );
    });
  }

  testWidgets('Summer Palace completion keeps reduced-motion cinematic layers',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: DestinationBackground(
            journeyId: 'beijing-summer-palace',
            pageType: JourneyBackgroundPage.completion,
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

  testWidgets('Summer Palace completion camera changes position over time',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DestinationBackground(
          journeyId: 'beijing-summer-palace',
          pageType: JourneyBackgroundPage.completion,
          child: SizedBox.expand(),
        ),
      ),
    );
    await tester.pump();

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
