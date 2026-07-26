import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/coin_journey_prototype_screen.dart';

String _identity(String value) => value;

Widget _app() {
  return const MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 390,
        height: 900,
        child: CoinJourneyGame(text: _identity),
      ),
    ),
  );
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      220,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void _solveParagraph(WidgetTester tester) {
  final list = tester.widget<ReorderableListView>(
    find.byKey(const ValueKey('paragraph-reorder-list')),
  );
  list.onReorder!(2, 0);
  list.onReorder!(3, 1);
}

void _solveNightOrder(WidgetTester tester) {
  final list = tester.widget<ReorderableListView>(
    find.byKey(const ValueKey('night-reorder-list')),
  );
  list.onReorder!(2, 0);
  list.onReorder!(2, 1);
  list.onReorder!(3, 2);
}

Future<void> _completeFirstChallenge(WidgetTester tester) async {
  await _tapVisible(
    tester,
    find.byKey(const ValueKey('coin-start-challenges')),
  );
  _solveParagraph(tester);
  await tester.pumpAndSettle();
  await _tapVisible(
    tester,
    find.byKey(const ValueKey('paragraph-submit')),
  );
}

void main() {
  testWidgets('the prototype explains the coin and hidden journey loop', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.text('学习闯关 · 钱币收藏 · 异境解锁'), findsOneWidget);
    expect(find.text('普通挑战：颐和园'), findsOneWidget);
    expect(find.text('隐藏旅程：聊斋夜客'), findsOneWidget);
    expect(find.textContaining('第一次答对'), findsOneWidget);
  });

  testWidgets('a corrected grammar sentence receives a clear explanation', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _completeFirstChallenge(tester);

    expect(find.text('获得金币'), findsOneWidget);
    await _tapVisible(tester, find.text('进入语病修复'));

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('grammar-submit')),
    );
    expect(find.byKey(const ValueKey('grammar-explanation')), findsNothing);
    expect(find.textContaining('没有明确主语'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('grammar-input')),
      '通过游览长廊，游客可以看到不同的风景。',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('grammar-submit')),
    );

    expect(find.byKey(const ValueKey('grammar-explanation')), findsOneWidget);
    expect(find.text('成分残缺：主语缺失'), findsOneWidget);
    expect(find.textContaining('两个结构叠在一起'), findsOneWidget);
    expect(find.textContaining('删除“使”'), findsOneWidget);
    expect(find.text('获得银币'), findsOneWidget);
  });

  testWidgets('three perfect challenges unlock the supernatural journey', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _completeFirstChallenge(tester);
    await _tapVisible(tester, find.text('进入语病修复'));

    await tester.enterText(
      find.byKey(const ValueKey('grammar-input')),
      '通过游览长廊，游客可以看到不同的风景。',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('grammar-submit')),
    );
    await _tapVisible(tester, find.text('进入补句挑战'));

    for (var index = 0; index < 3; index++) {
      await _tapVisible(
        tester,
        find.byKey(ValueKey<String>('fragment-$index')),
      );
    }
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('fragment-submit')),
    );
    await _tapVisible(tester, find.text('查看钱币与异境'));

    expect(find.textContaining('旅程值：9 点'), findsOneWidget);
    expect(find.byKey(const ValueKey('rare-rui-silver-coin')), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('unlock-special-journey')),
    );
    expect(find.byKey(const ValueKey('special-journey-intro')), findsOneWidget);

    await _tapVisible(tester, find.byKey(const ValueKey('special-start')));
    _solveNightOrder(tester);
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.byKey(const ValueKey('night-submit')));

    expect(find.byKey(const ValueKey('special-decision')), findsOneWidget);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('special-choice-keep')),
    );

    expect(find.text('结局：灯票守夜人'), findsOneWidget);
    expect(find.text('鬼市灯票'), findsOneWidget);
  });

  test('the web app exposes the coin journey prototype route', () {
    final source = File('lib/app.dart').readAsStringSync();

    expect(source, contains("queryParameters['prototype']"));
    expect(source, contains("prototype == 'coin-journey'"));
    expect(source, contains('CoinJourneyPrototypeScreen'));
  });
}
