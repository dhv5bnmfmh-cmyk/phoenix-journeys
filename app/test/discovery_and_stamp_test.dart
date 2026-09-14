import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/widgets/forbidden_city_stamp.dart';

void main() {
  test('Discovery provides pinyin and Explorer-language support', () {
    final discovery = discoveries.first;

    expect(discovery.text, contains('故宫'));
    expect(discovery.pinyin, contains('Gùgōng'));
    expect(discovery.supportLabel('越南语'), '探索者母语 · 越南语');
    expect(discovery.supportText('越南语'), contains('Cố Cung'));
    expect(discovery.supportText('英语'), contains('Forbidden City'));
    expect(discovery.supportText('双语'), contains('\n'));
    expect(discovery.supportText('中文解释'), contains('许多建筑'));
  });

  testWidgets('earned Forbidden City stamp uses original Phoenix artwork',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: ForbiddenCityStamp()),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('forbidden-city-stamp')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('original-phoenix-stamp-art')),
      findsOneWidget,
    );
    expect(find.text('北京'), findsOneWidget);
    expect(find.text('紫禁城'), findsOneWidget);
    expect(find.text('PHOENIX JOURNEYS'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance), findsNothing);
  });

  testWidgets('animated stamp drops from above and leaves an imprint',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: AnimatedForbiddenCityStamp()),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('animated-forbidden-city-stamp')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('animated-stamp-tool')), findsOneWidget);
    expect(find.byKey(const ValueKey('animated-stamp-imprint')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('北京'), findsOneWidget);
    expect(find.text('紫禁城'), findsOneWidget);
  });

  testWidgets('locked stamp clearly stays unavailable before completion',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: ForbiddenCityStamp(isUnlocked: false),
          ),
        ),
      ),
    );

    expect(find.text('待探索'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
