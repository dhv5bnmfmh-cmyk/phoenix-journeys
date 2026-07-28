import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/widgets/journey_level_selector_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.level': 5,
      'phoenix.languageProficiency': 'phoenix:5',
    });
    PhoenixLevelController.instance.setLevel(5);
  });

  testWidgets('plus and minus update the visible Phoenix level', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: JourneyLevelSelectorButton()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lv.5'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('phoenix-level-plus')));
    await tester.pumpAndSettle();
    expect(find.text('Lv.6'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('phoenix-level-minus')));
    await tester.pumpAndSettle();
    expect(find.text('Lv.5'), findsOneWidget);
  });

  testWidgets('boundary buttons disable at one and ten', (tester) async {
    PhoenixLevelController.instance.setLevel(1);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.level': 1,
      'phoenix.languageProficiency': 'phoenix:1',
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: JourneyLevelSelectorButton()),
      ),
    );
    await tester.pumpAndSettle();

    final minus = tester.widget<IconButton>(
      find.descendant(
        of: find.byKey(const ValueKey('phoenix-level-minus')),
        matching: find.byType(IconButton),
      ),
    );
    expect(minus.onPressed, isNull);

    PhoenixLevelController.instance.setLevel(10);
    await tester.pumpAndSettle();
    final plus = tester.widget<IconButton>(
      find.descendant(
        of: find.byKey(const ValueKey('phoenix-level-plus')),
        matching: find.byType(IconButton),
      ),
    );
    expect(plus.onPressed, isNull);
  });
}
