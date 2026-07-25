import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/lost_scroll_prototype_screen.dart';

Widget _app({Set<String> learnedWords = const <String>{}}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 390,
        height: 900,
        child: LostScrollGame(learnedWords: learnedWords),
      ),
    ),
  );
}

Future<void> _tapChoice(WidgetTester tester, String id) async {
  final finder = find.byKey(ValueKey<String>('lost-scroll-choice-$id'));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _finishReveal(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 780));
  await tester.pump(const Duration(milliseconds: 40));
}

void main() {
  testWidgets('the player immediately sees one clear restoration task', (
    tester,
  ) async {
    await tester.pumpWidget(_app(learnedWords: const {'借景'}));

    expect(find.text('修复失落画卷'), findsOneWidget);
    expect(find.textContaining('远山消失了'), findsOneWidget);
    expect(find.text('借景'), findsOneWidget);
    expect(find.text('旧游印记'), findsOneWidget);
    expect(find.text('已修复 0 / 3'), findsOneWidget);
  });

  testWidgets('a wrong choice gives a clue without failing the player', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await _tapChoice(tester, 'repair-building');

    expect(find.textContaining('小凰提示'), findsOneWidget);
    expect(find.textContaining('把远处景物纳入眼前构图'), findsOneWidget);
    expect(find.text('已修复 0 / 3'), findsOneWidget);
    expect(find.textContaining('远山消失了'), findsOneWidget);
  });

  testWidgets('three learned clues restore the full scroll', (tester) async {
    await tester.pumpWidget(_app());

    await _tapChoice(tester, 'borrow-scene');
    await _finishReveal(tester);
    expect(find.textContaining('山水挤成一团'), findsOneWidget);
    expect(find.text('已修复 1 / 3'), findsOneWidget);

    await _tapChoice(tester, 'layers');
    await _finishReveal(tester);
    expect(find.textContaining('游人的脚步断开了'), findsOneWidget);
    expect(find.text('已修复 2 / 3'), findsOneWidget);

    await _tapChoice(tester, 'moving-view');
    await _finishReveal(tester);

    expect(find.text('画卷已复原'), findsOneWidget);
    expect(find.text('颐和园 · 借景长卷'), findsOneWidget);
  });

  testWidgets('the restored scroll can be replayed', (tester) async {
    await tester.pumpWidget(_app());

    for (final id in ['borrow-scene', 'layers', 'moving-view']) {
      await _tapChoice(tester, id);
      await _finishReveal(tester);
    }

    final restart = find.byKey(const ValueKey('lost-scroll-restart'));
    await tester.ensureVisible(restart);
    await tester.tap(restart);
    await tester.pump();

    expect(find.text('画卷已复原'), findsNothing);
    expect(find.textContaining('远山消失了'), findsOneWidget);
    expect(find.text('已修复 0 / 3'), findsOneWidget);
  });

  test('the web prototype has a direct query route', () {
    final source = File('lib/app.dart').readAsStringSync();

    expect(source, contains("queryParameters['prototype']"));
    expect(source, contains("prototype == 'lost-scroll'"));
    expect(source, contains('LostScrollPrototypeScreen'));
  });
}
