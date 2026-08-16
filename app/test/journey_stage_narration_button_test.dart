import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_stage_narration_button.dart';

void main() {
  testWidgets('Memory speaker exposes play semantics and 44px touch target', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerRight,
            child: JourneyStageNarrationButton(
              key: const ValueKey('memory-narration-button'),
              stage: 'memory',
              isPlaying: false,
              onPressed: () => taps += 1,
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('播放朗读'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    final size = tester.getSize(
      find.byKey(const ValueKey('memory-narration-touch-target')),
    );
    expect(size.width, greaterThanOrEqualTo(44));
    expect(size.height, greaterThanOrEqualTo(44));

    await tester.tap(
      find.byKey(const ValueKey('memory-narration-touch-target')),
    );
    expect(taps, 1);
  });

  testWidgets('Completion speaker renders an explicit stop state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyStageNarrationButton(
            stage: 'completion',
            isPlaying: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('停止朗读'), findsOneWidget);
    expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
  });

  testWidgets('speaker remains layout-safe at narrow width and large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SizedBox(
              width: 48,
              child: JourneyStageNarrationButton(
                stage: 'memory',
                isPlaying: false,
                onPressed: null,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('memory-narration-touch-target')),
      findsOneWidget,
    );
  });

  test(
    'narration item builder is empty-safe and preserves displayed script',
    () {
      final traditional = buildJourneyStageNarrationItems(
        stage: 'memory',
        displayedLines: const ['  記憶中的城牆。  ', '', '回家。'],
      );
      expect(traditional.map((item) => item.text).toList(), ['記憶中的城牆。', '回家。']);
      expect(
        buildJourneyStageNarrationItems(
          stage: 'completion',
          displayedLines: const ['', '  '],
        ),
        isEmpty,
      );
    },
  );

  test('narration locale follows the displayed Chinese script', () {
    expect(journeyStageNarrationLanguageCode(false), 'zh-CN');
    expect(journeyStageNarrationLanguageCode(true), 'zh-TW');
  });
}
