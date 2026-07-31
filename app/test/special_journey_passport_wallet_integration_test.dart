import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/special_journey_passport.dart';

void main() {
  testWidgets('special journey entry shows all four wallet balances', (
    tester,
  ) async {
    final state = AppState()
      ..goldCoins = 2
      ..silverCoins = 3
      ..bronzeCoins = 4
      ..silverFragments = 5;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpecialJourneyPassport(state: state)),
      ),
    );

    expect(find.text('金2'), findsOneWidget);
    expect(find.text('银3'), findsOneWidget);
    expect(find.text('铜4'), findsOneWidget);
    expect(find.text('碎5'), findsOneWidget);
  });

  testWidgets('special journey menu shows wallet legend and affordability', (
    tester,
  ) async {
    final state = AppState()
      ..goldCoins = 2
      ..silverCoins = 0
      ..bronzeCoins = 1
      ..silverFragments = 6;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpecialJourneyPassport(state: state)),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-special-journey-menu')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('special-journey-currency-legend')),
      findsOneWidget,
    );
    expect(find.text('金币 2'), findsOneWidget);
    expect(find.text('银币 0'), findsOneWidget);
    expect(find.text('铜币 1'), findsOneWidget);
    expect(find.text('碎银 6'), findsOneWidget);
    expect(find.textContaining('余额充足'), findsWidgets);
    expect(find.textContaining('还差'), findsWidgets);
  });

  testWidgets('insufficient balance gives direct feedback without dialog', (
    tester,
  ) async {
    final state = AppState();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SpecialJourneyPassport(state: state)),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-special-journey-menu')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('special-journey-literary-roaming')),
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.textContaining('金币不足'), findsOneWidget);
  });
}
