import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/summer_palace_lore_battle.dart';

void main() {
  testWidgets('journey gear defeats the rotating Summer Palace boss',
      (tester) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 720,
            child: SummerPalaceLoreBattle(
              encounterSeed: 0,
              onCompleted: () => completed = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('旅程武装'), findsOneWidget);
    expect(find.text('长廊回声卷'), findsOneWidget);
    expect(find.text('借景符文'), findsOneWidget);
    expect(find.text('昆明湖罗盘'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pumpAndSettle();

    expect(find.text('因果断层'), findsWidgets);
    expect(find.text('空间失真'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('lore-rune-target-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lore-battle-begin')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('lore-equipment-0')));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byKey(const ValueKey('lore-equipment-1')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(find.text('旅程武装完成觉醒'), findsOneWidget);
    expect(find.text('小凰 · 守护完成'), findsOneWidget);
  });

  testWidgets('a completed arsenal battle can be replayed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 720,
            child: SummerPalaceLoreBattle(
              completed: true,
              encounterSeed: 0,
              onCompleted: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('旅程武装完成觉醒'), findsOneWidget);
    await tester.tap(find.text('重新挑战'));
    await tester.pumpAndSettle();

    expect(find.text('旅程武装'), findsOneWidget);
    expect(find.byKey(const ValueKey('lore-battle-start')), findsOneWidget);
  });

  test('completed battle progress is persisted before leaving the page', () {
    final source = File('lib/screens/journey_screen.dart').readAsStringSync();

    expect(
      source,
      contains('unawaited(_persistProgress(overrideStep: 4));'),
    );
    expect(
      source,
      contains('_appState.beijingJourneyFurthestStep > 3'),
    );
    expect(source, contains('final persistedStep = overrideStep'));
  });
}
