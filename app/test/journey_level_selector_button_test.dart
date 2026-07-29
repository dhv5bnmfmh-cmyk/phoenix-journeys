import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/widgets/journey_level_selector_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Finder control(String key) => find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(IconButton),
      );

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.level': 5,
      'phoenix.languageProficiency': 'phoenix:5',
    });
    PhoenixLevelController.instance.setLevel(5);
  });

  test('reading load labels stay meaningful across all ten levels', () {
    expect(phoenixLevelReadingModeLabel(1), '轻松起步');
    expect(phoenixLevelReadingModeLabel(4), '稳步进阶');
    expect(phoenixLevelReadingModeLabel(6), '完整阅读');
    expect(phoenixLevelReadingModeLabel(8), '深度阅读');
    expect(phoenixLevelReadingModeLabel(10), '高阶沉浸');
    expect(phoenixLevelReadingTimeLabel(1), '约 1–2 分钟');
    expect(phoenixLevelReadingTimeLabel(5), '约 3 分钟');
    expect(phoenixLevelReadingTimeLabel(10), '约 4–5 分钟');
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
    await tester.tap(control('phoenix-level-plus'));
    await tester.pumpAndSettle();
    expect(find.text('Lv.6'), findsOneWidget);

    await tester.tap(control('phoenix-level-minus'));
    await tester.pumpAndSettle();
    expect(find.text('Lv.5'), findsOneWidget);
  });

  testWidgets('tapping the level opens the current reading guide',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: JourneyLevelSelectorButton()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('phoenix-level-guide')));
    await tester.pumpAndSettle();

    expect(find.text('Phoenix Lv.5'), findsOneWidget);
    expect(find.text('完整阅读'), findsOneWidget);
    expect(find.text('380–500 字'), findsOneWidget);
    expect(find.text('2 段短文'), findsOneWidget);
    expect(find.text('约 3 分钟'), findsOneWidget);
    expect(find.textContaining('当前故事、重点词汇、文化发现'), findsOneWidget);
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

    expect(
      tester.widget<IconButton>(control('phoenix-level-minus')).onPressed,
      isNull,
    );

    PhoenixLevelController.instance.setLevel(10);
    await tester.pumpAndSettle();
    expect(
      tester.widget<IconButton>(control('phoenix-level-plus')).onPressed,
      isNull,
    );
  });
}
