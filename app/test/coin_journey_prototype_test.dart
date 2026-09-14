import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/coin_journey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _identity(String value) => value;

String _traditional(String value) {
  const replacements = <String, String>{
    '金币': '金幣',
    '银币': '銀幣',
    '铜币': '銅幣',
    '钱币': '錢幣',
    '答对': '答對',
    '获得': '獲得',
    '收藏': '收藏',
    '旅程值': '旅程值',
    '点': '點',
  };
  var result = value;
  for (final entry in replacements.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }
  return result;
}

Widget _app({
  String Function(String) text = _identity,
  bool persistRewards = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: CoinJourneyGame(
        text: text,
        persistRewards: persistRewards,
      ),
    ),
  );
}

Future<void> _pumpPhoneApp(
  WidgetTester tester, {
  String Function(String) text = _identity,
  bool persistRewards = true,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    _app(text: text, persistRewards: persistRewards),
  );
  await tester.pumpAndSettle();
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    220,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await _reveal(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _solveParagraph(WidgetTester tester) async {
  final ids = ['overview', 'walk', 'windows'];
  if (find.byKey(const ValueKey('paragraph-choice-borrow')).evaluate().isNotEmpty) {
    ids.add('borrow');
  }
  for (final id in ids) {
    await _tapVisible(
      tester,
      find.byKey(ValueKey<String>('paragraph-choice-$id')),
    );
  }
  await _tapVisible(tester, find.text('提交答案'));
}

Future<void> _openGrammar(WidgetTester tester) async {
  await _tapVisible(tester, find.text('进入语病修复'));
}

Future<void> _solveGrammar(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const ValueKey('grammar-input')),
    '通过游览长廊，游客可以看到不同的风景。',
  );
  await _tapVisible(tester, find.text('提交答案'));
}

Future<void> _solveFragments(WidgetTester tester) async {
  for (final id in ['time', 'subject', 'result']) {
    await _tapVisible(
      tester,
      find.byKey(ValueKey<String>('fragment-choice-$id')),
    );
  }
  await _tapVisible(tester, find.text('提交答案'));
}

Future<void> _reachSummary(WidgetTester tester) async {
  await _tapVisible(
    tester,
    find.byKey(const ValueKey('coin-start-challenges')),
  );
  await _solveParagraph(tester);
  await _openGrammar(tester);
  await _solveGrammar(tester);
  await _tapVisible(tester, find.text('进入补句挑战'));
  await _solveFragments(tester);
  await _tapVisible(tester, find.text('查看钱币与异境'));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('the prototype explains the coin and hidden journey loop', (
    tester,
  ) async {
    await _pumpPhoneApp(tester);

    expect(find.text('学习闯关 · 钱币收藏 · 万象奇旅'), findsOneWidget);
    await _reveal(tester, find.text('普通挑战：颐和园'));
    expect(find.text('普通挑战：颐和园'), findsOneWidget);
    await _reveal(tester, find.text('万象奇旅 · 神话寻踪'));
    expect(find.text('万象奇旅 · 神话寻踪'), findsOneWidget);
    expect(find.textContaining('第一次答对'), findsOneWidget);
    expect(find.textContaining('金币 · 面值 3'), findsOneWidget);
    expect(find.textContaining('银币 · 面值 2'), findsOneWidget);
    expect(find.textContaining('铜币 · 面值 1'), findsOneWidget);
  });

  testWidgets('a corrected grammar sentence receives a clear explanation', (
    tester,
  ) async {
    await _pumpPhoneApp(tester, persistRewards: false);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('coin-start-challenges')),
    );
    await _solveParagraph(tester);
    await _openGrammar(tester);

    await _tapVisible(tester, find.text('提交答案'));
    expect(find.byKey(const ValueKey('grammar-explanation')), findsNothing);
    expect(find.textContaining('没有明确主语'), findsOneWidget);

    await _solveGrammar(tester);
    await _reveal(
      tester,
      find.byKey(const ValueKey('grammar-explanation')),
    );

    expect(find.text('成分残缺：主语缺失'), findsOneWidget);
    expect(find.textContaining('两个结构叠在一起'), findsOneWidget);
    expect(find.textContaining('删除“使”'), findsOneWidget);
    expect(find.byKey(const ValueKey('coin-reward-silver')), findsOneWidget);
  });

  testWidgets('the third wrong paragraph answer reveals the solution and awards bronze', (
    tester,
  ) async {
    await _pumpPhoneApp(tester, persistRewards: false);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('coin-start-challenges')),
    );

    for (var attempt = 0; attempt < 3; attempt++) {
      for (final id in ['walk', 'overview', 'windows']) {
        await _tapVisible(
          tester,
          find.byKey(ValueKey<String>('paragraph-choice-$id')),
        );
      }
      await _tapVisible(tester, find.text('提交答案'));
    }

    expect(find.textContaining('系统已排出正确顺序'), findsOneWidget);
    expect(find.byKey(const ValueKey('coin-reward-bronze')), findsOneWidget);
    expect(find.text('进入语病修复'), findsOneWidget);
    expect(find.textContaining('1. 颐和园长廊连接着湖边的多个景点。'), findsOneWidget);
  });

  testWidgets('paragraph difficulty follows the explorer ability score', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.coinJourney.ability.v1': 8,
    });
    await _pumpPhoneApp(tester);

    expect(find.textContaining('探索者能力：探索'), findsOneWidget);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('coin-start-challenges')),
    );
    expect(
      find.byKey(const ValueKey('paragraph-choice-borrow')),
      findsOneWidget,
    );
  });

  testWidgets('fragment choices are visibly shuffled from the answer key', (
    tester,
  ) async {
    await _pumpPhoneApp(tester, persistRewards: false);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('coin-start-challenges')),
    );
    await _solveParagraph(tester);
    await _openGrammar(tester);
    await _solveGrammar(tester);
    await _tapVisible(tester, find.text('进入补句挑战'));

    final firstDisplayed = find.byKey(
      const ValueKey('fragment-choice-position-0'),
    );
    await _reveal(tester, firstDisplayed);
    expect(
      find.descendant(
        of: firstDisplayed,
        matching: find.text('都会发生变化。'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('earned coins survive recreation and keep the journey unlocked', (
    tester,
  ) async {
    await _pumpPhoneApp(tester);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('coin-start-challenges')),
    );
    await _solveParagraph(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _reveal(
      tester,
      find.text('已收藏 1 枚钱币 · 可用币值 3'),
    );
    expect(find.text('已收藏 1 枚钱币 · 可用币值 3'), findsOneWidget);
    await _reveal(
      tester,
      find.byKey(const ValueKey('enter-persisted-special')),
    );
    expect(
      find.byKey(const ValueKey('enter-persisted-special')),
      findsOneWidget,
    );
  });

  testWidgets('three perfect challenges unlock the supernatural journey', (
    tester,
  ) async {
    await _pumpPhoneApp(tester);
    await _reachSummary(tester);

    await _reveal(tester, find.text('已收藏 4 枚钱币 · 可用币值 9'));
    expect(find.text('已收藏 4 枚钱币 · 可用币值 9'), findsOneWidget);
    expect(find.byKey(const ValueKey('rare-rui-silver-coin')), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('unlock-special-journey')),
    );
    expect(find.byKey(const ValueKey('special-journey-intro')), findsOneWidget);
    expect(find.textContaining('万象奇旅 · 神话寻踪'), findsOneWidget);
    expect(find.textContaining('亲身进入故事'), findsOneWidget);

    await _tapVisible(tester, find.byKey(const ValueKey('special-start')));
    for (final id in ['knock', 'mirror', 'promise', 'leaf']) {
      await _tapVisible(
        tester,
        find.byKey(ValueKey<String>('night-choice-$id')),
      );
    }
    await _tapVisible(tester, find.byKey(const ValueKey('night-submit')));

    expect(find.byKey(const ValueKey('special-decision')), findsOneWidget);
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('special-choice-keep')),
    );

    expect(find.text('结局：灯票守夜人'), findsOneWidget);
    expect(find.text('鬼市灯票'), findsOneWidget);
  });

  testWidgets('reward labels follow the selected Traditional script', (
    tester,
  ) async {
    await _pumpPhoneApp(
      tester,
      text: _traditional,
      persistRewards: false,
    );

    expect(find.textContaining('錢幣收藏'), findsOneWidget);
    expect(find.textContaining('第一次答對'), findsOneWidget);
    expect(find.textContaining('已收藏 0 枚錢幣'), findsOneWidget);
  });

  test('the web app exposes the coin journey prototype route', () {
    final source = File('lib/app.dart').readAsStringSync();

    expect(source, contains("queryParameters['prototype']"));
    expect(source, contains("prototype == 'coin-journey'"));
    expect(source, contains('CoinJourneyPrototypeScreen'));
  });
}
