import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/special_journey_currency_legend.dart';

void main() {
  testWidgets('shows all four special journey currencies', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpecialJourneyCurrencyLegend(
            wallet: const SpecialJourneyWallet(
              gold: 3,
              silver: 4,
              bronze: 5,
              shards: 6,
            ),
            displayText: (value) => value,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('special-currency-gold')), findsOneWidget);
    expect(find.byKey(const ValueKey('special-currency-silver')), findsOneWidget);
    expect(find.byKey(const ValueKey('special-currency-bronze')), findsOneWidget);
    expect(find.byKey(const ValueKey('special-currency-shards')), findsOneWidget);
    expect(find.text('金币 3'), findsOneWidget);
    expect(find.text('银币 4'), findsOneWidget);
    expect(find.text('铜币 5'), findsOneWidget);
    expect(find.text('碎银 6'), findsOneWidget);
  });
}
