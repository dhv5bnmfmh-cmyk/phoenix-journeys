import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/summer_palace_lore_battle.dart';

Widget _app({
  required VoidCallback onCompleted,
  bool completed = false,
  int scenarioSeed = 0,
  int ruleSeed = 0,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 390,
        height: 720,
        child: SummerPalaceLoreBattle(
          completed: completed,
          scenarioSeed: scenarioSeed,
          ruleSeed: ruleSeed,
          onCompleted: onCompleted,
        ),
      ),
    ),
  );
}

Future<void> _finishEffect(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pump(const Duration(milliseconds: 800));
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('journey knowledge becomes usable battle equipment', (tester) async {
    await tester.pumpWidget(_app(onCompleted: () {}));

    expect(find.text('小凰'), findsOneWidget);
    expect(find.text('失序巨兽'), findsOneWidget);
    expect(find.text('长廊回声卷'), findsOneWidget);
    expect(find.text('借景符文'), findsOneWidget);
    expect(find.text('昆明湖罗盘'), findsOneWidget);
    expect(find.textContaining('来自故事'), findsOneWidget);
    expect(find.textContaining('来自生词'), findsOneWidget);
    expect(find.textContaining('来自发现'), findsOneWidget);
  });

  testWidgets('correct equipment combinations defeat both armor layers', (
    tester,
  ) async {
    var completed = false;
    await tester.pumpWidget(
      _app(onCompleted: () => completed = true, scenarioSeed: 0, ruleSeed: 0),
    );

    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('因果断层'), findsWidgets);
    await tester.tap(
      find.byKey(const ValueKey('lore-equipment-story-scroll')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lore-cast-combo')));
    await _finishEffect(tester);

    expect(find.textContaining('空间错位'), findsWidgets);
    await tester.tap(
      find.byKey(const ValueKey('lore-equipment-word-rune')),
    );
    await tester.tap(
      find.byKey(const ValueKey('lore-equipment-discovery-compass')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lore-cast-combo')));
    await _finishEffect(tester);

    expect(completed, isTrue);
    expect(find.text('失序巨兽已被净化'), findsOneWidget);
    expect(find.textContaining('装备共鸣解锁'), findsOneWidget);
  });

  testWidgets('wrong equipment consumes focus and increases distortion', (
    tester,
  ) async {
    await tester.pumpWidget(_app(onCompleted: () {}, ruleSeed: 0));
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(
      find.byKey(const ValueKey('lore-equipment-word-rune')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lore-cast-combo')));
    await _finishEffect(tester);

    expect(find.text('失真 1/3'), findsOneWidget);
    expect(find.text('专注 4'), findsOneWidget);
    expect(find.textContaining('先恢复故事'), findsOneWidget);
  });

  testWidgets('a completed battle can replay without snapping to victory', (
    tester,
  ) async {
    await tester.pumpWidget(_app(completed: true, onCompleted: () {}));

    expect(find.text('失序巨兽已被净化'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lore-battle-restart')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('这段旅程已经把知识变成装备'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('第 1 回合'), findsOneWidget);
    expect(find.text('失序巨兽已被净化'), findsNothing);
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
