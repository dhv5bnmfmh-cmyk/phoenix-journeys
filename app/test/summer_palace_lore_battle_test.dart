import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/summer_palace_lore_battle.dart';

void main() {
  testWidgets('culture evidence defeats the Summer Palace boss', (tester) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 720,
            child: SummerPalaceLoreBattle(
              onCompleted: () => completed = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('失序巨兽出现了'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('lore-battle-start')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('lore-weapon-0')));
    await tester.pump();
    await tester.tap(find.text('释放借景之镜'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('lore-rumor-1')));
    await tester.pump();
    await tester.tap(find.text('击破谣言护盾'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('lore-evidence-0')));
    await tester.tap(find.byKey(const ValueKey('lore-evidence-2')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('lore-forge-submit')));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(find.text('失序巨兽已被净化'), findsOneWidget);
    expect(find.text('借景之镜'), findsOneWidget);
  });
}
