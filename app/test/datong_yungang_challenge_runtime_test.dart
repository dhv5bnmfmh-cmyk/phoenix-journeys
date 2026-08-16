import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/datong_yungang_gold_content.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

String _identity(String value) => value;

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Datong active Challenge is journey-grounded in all three modes', (tester) async {
    final lv1 = datongYungangGoldLevelContent(1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 430,
            height: 900,
            child: JourneyChallengePanel(
              journeyId: datongYungangJourneyId,
              storyParagraphs: lv1.storyParagraphs,
              discoveryTexts: lv1.discoveries.map((item) => item.text).toList(growable: false),
              profile: null,
              seed: 186,
              displayText: _identity,
              onResolved: (_, __) async {},
              onAllCompleted: () async {},
              autoNarrate: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('challenge-mode-paragraphRebuild')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('长廊'), findsNothing);
    await _tap(tester, 'challenge-option-correct-0');
    await _tap(tester, 'challenge-option-correct-1');
    await _tap(tester, 'challenge-submit');
    await _tap(tester, 'challenge-dialog-action');

    expect(find.byKey(const ValueKey('challenge-mode-grammarRepair')), findsOneWidget);
    expect(find.textContaining('昙曜五窟与迁都后的较小窟龛'), findsWidgets);
    expect(find.textContaining('通过参观这里'), findsNothing);
    await _tap(tester, 'challenge-grammar-segment-1');
    await _tap(tester, 'challenge-option-correct');
    await _tap(tester, 'challenge-submit');
    await _tap(tester, 'challenge-dialog-action');

    expect(find.byKey(const ValueKey('challenge-mode-missingSentence')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('很快离开了这里'), findsNothing);
    expect(find.textContaining('沿途景色'), findsNothing);
    expect(find.textContaining('园林'), findsNothing);
  });
}
