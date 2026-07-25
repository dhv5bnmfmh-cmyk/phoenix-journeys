import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/summer_palace_lore_battle.dart';

Widget _app({
  required VoidCallback onCompleted,
  bool completed = false,
  int scenarioSeed = 0,
  int ruleSeed = 0,
  Set<String> learnedWords = const <String>{},
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
          learnedWords: learnedWords,
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

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  final target = finder.last;
  await tester.ensureVisible(target);
  await tester.pump();
  await tester.tap(target);
  await tester.pump();
}

Future<void> _select(WidgetTester tester, String id) async {
  await _tapVisible(
    tester,
    find.byKey(ValueKey<String>('lore-equipment-$id')),
  );
}

Future<void> _cast(WidgetTester tester) async {
  await _tapVisible(tester, find.byKey(const ValueKey('lore-cast-combo')));
  await _finishEffect(tester);
}

void main() {
  testWidgets('learned journey knowledge becomes wuxia techniques', (
    tester,
  ) async {
    await tester.pumpWidget(_app(onCompleted: () {}));

    expect(find.text('小凰少侠'), findsOneWidget);
    expect(find.text('失序魇兽'), findsOneWidget);
    expect(find.text('长廊回声卷'), findsOneWidget);
    expect(find.text('借景字诀'), findsOneWidget);
    expect(find.text('昆明湖山水盘'), findsOneWidget);
    expect(find.textContaining('故事心法'), findsWidgets);
    expect(find.textContaining('生词字诀'), findsWidgets);
    expect(find.textContaining('发现奇器'), findsWidgets);
  });

  testWidgets('ordered opening and finishing techniques break both seals', (
    tester,
  ) async {
    var completed = false;
    await tester.pumpWidget(
      _app(onCompleted: () => completed = true, scenarioSeed: 0, ruleSeed: 0),
    );

    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('因果断层'), findsWidgets);
    expect(find.textContaining('断章掌'), findsOneWidget);
    await _select(tester, 'story-scroll');
    await _select(tester, 'word-rune');
    expect(find.byKey(const ValueKey('lore-combo-slot-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('lore-combo-slot-1')), findsOneWidget);
    await _cast(tester);

    expect(find.textContaining('空间错位'), findsWidgets);
    await _select(tester, 'discovery-compass');
    await _select(tester, 'word-rune');
    await _cast(tester);

    expect(completed, isTrue);
    expect(find.text('幻阵已破'), findsOneWidget);
    expect(find.textContaining('侠游武学共鸣'), findsOneWidget);
  });

  testWidgets('wrong learned knowledge order consumes inner power', (
    tester,
  ) async {
    await tester.pumpWidget(_app(onCompleted: () {}, ruleSeed: 0));
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    await _select(tester, 'word-rune');
    await _select(tester, 'story-scroll');
    await _cast(tester);

    expect(find.text('魔障 1/3'), findsOneWidget);
    expect(find.text('内力 4'), findsOneWidget);
    expect(find.textContaining('起手先恢复故事行动'), findsOneWidget);
  });

  testWidgets('saved past word unlocks an alternate martial solution', (
    tester,
  ) async {
    var completed = false;
    await tester.pumpWidget(
      _app(
        onCompleted: () => completed = true,
        scenarioSeed: 0,
        ruleSeed: 1,
        learnedWords: const {'层次'},
      ),
    );

    expect(find.text('层次身法'), findsOneWidget);
    expect(find.textContaining('旧游字诀'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    await _select(tester, 'story-scroll');
    await _select(tester, 'word-rune');
    await _cast(tester);

    await _select(tester, 'discovery-compass');
    await _select(tester, 'legacy-layer');
    await _cast(tester);

    expect(completed, isTrue);
    expect(find.text('幻阵已破'), findsOneWidget);
  });

  testWidgets('Phoenix insight reveals the first formation move once', (
    tester,
  ) async {
    await tester.pumpWidget(_app(onCompleted: () {}));
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    await _tapVisible(tester, find.byKey(const ValueKey('lore-use-insight')));

    expect(find.textContaining('起手式应当是“长廊回声卷”'), findsOneWidget);
    expect(find.text('金羽点拨已用'), findsOneWidget);
  });

  testWidgets('a completed battle can replay without snapping to victory', (
    tester,
  ) async {
    await tester.pumpWidget(_app(completed: true, onCompleted: () {}));

    expect(find.text('幻阵已破'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lore-battle-restart')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('所学皆可成武学'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('第 1 阵'), findsOneWidget);
    expect(find.text('幻阵已破'), findsNothing);
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
