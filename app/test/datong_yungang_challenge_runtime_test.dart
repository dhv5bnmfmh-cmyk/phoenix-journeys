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

Future<void> _pumpLevel(WidgetTester tester, int level) async {
  final content = datongYungangGoldLevelContent(level);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 430,
          height: 900,
          child: JourneyChallengePanel(
            journeyId: datongYungangJourneyId,
            storyParagraphs: content.storyParagraphs,
            discoveryTexts: content.discoveries.map((item) => item.text).toList(growable: false),
            profile: null,
            seed: 186 + level,
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
}

Future<void> _finishBeginnerParagraph(WidgetTester tester) async {
  await _tap(tester, 'challenge-option-correct-0');
  await _tap(tester, 'challenge-option-correct-1');
  await _tap(tester, 'challenge-submit');
  await _tap(tester, 'challenge-dialog-action');
}

void main() {
  test('Datong Challenge Gold declares one primary intent per mode and level', () {
    for (var level = 1; level <= 10; level++) {
      final intents = <String>{
        for (final type in fixedJourneyChallengeTypes)
          datongChallengeGoldPrimaryIntent(level, type),
      };
      expect(intents, contains('LANGUAGE'));
      expect(intents.length, greaterThanOrEqualTo(2));
    }
    expect(datongChallengeGoldPrimaryIntent(1, JourneyChallengeType.paragraphRebuild), 'STORY');
    expect(datongChallengeGoldPrimaryIntent(5, JourneyChallengeType.paragraphRebuild), 'CAUSAL_REASONING');
    expect(datongChallengeGoldPrimaryIntent(10, JourneyChallengeType.missingSentence), 'CULTURE');
  });

  test('Datong source windows progress rather than replaying Lv1 openings', () {
    final starts = <int>[
      for (var level = 1; level <= 10; level++)
        datongChallengeWindowStart(level, 18, 3),
    ];
    expect(starts.first, 0);
    expect(starts.last, 15);
    for (var index = 1; index < starts.length; index++) {
      expect(starts[index], greaterThanOrEqualTo(starts[index - 1]));
    }
    expect(starts.toSet().length, greaterThanOrEqualTo(7));
  });

  testWidgets('Datong Lv1 active Challenge uses only Lv1-taught historical context', (tester) async {
    await _pumpLevel(tester, 1);
    expect(find.byKey(const ValueKey('challenge-mode-paragraphRebuild')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('长廊'), findsNothing);
    await _finishBeginnerParagraph(tester);
    expect(find.byKey(const ValueKey('challenge-mode-grammarRepair')), findsOneWidget);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsWidgets);
    expect(find.textContaining('494年'), findsNothing);
    expect(find.textContaining('昙曜五窟'), findsNothing);
  });

  testWidgets('Datong Lv5 active Challenge advances to taught middle-period context', (tester) async {
    await _pumpLevel(tester, 5);
    await _finishBeginnerParagraph(tester);
    expect(find.textContaining('中期营造高峰与更复杂的艺术表达'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
  });

  testWidgets('Datong Lv10 active Challenge reaches integrated cultural context', (tester) async {
    await _pumpLevel(tester, 10);
    await _finishBeginnerParagraph(tester);
    expect(find.textContaining('云冈在中国与东亚佛教石窟艺术中的影响'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
  });

  testWidgets('Datong active Challenge remains journey-grounded in all three modes', (tester) async {
    await _pumpLevel(tester, 1);
    await _finishBeginnerParagraph(tester);
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
