import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/screens/city_passport_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<AppState> pumpPassport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState(clock: () => DateTime(2026, 7, 22));
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(body: CityPassportScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('Passport opens city journeys from geographic map markers', (
    tester,
  ) async {
    await pumpPassport(tester);

    expect(find.text('探索护照'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('passport-hd-atlas-image')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-pinch-zoom-map')),
      findsOneWidget,
    );
    expect(find.text('双指缩放 · 拖动地图'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsOneWidget,
    );
    expect(find.text('北京收藏册'), findsNothing);
    expect(find.text('紫禁城'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('passport-city-beijing')));
    await tester.pumpAndSettle();

    expect(find.text('北京 · 选择旅程'), findsOneWidget);
    expect(
      find.byKey(
        const ValueKey('passport-destination-beijing-forbidden-city'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('passport-destination-beijing-summer-palace'),
      ),
      findsOneWidget,
    );
    expect(find.text('紫禁城'), findsOneWidget);
    expect(find.text('颐和园'), findsOneWidget);
  });

  testWidgets('Passport opens the refined special journey unlock sheet', (
    tester,
  ) async {
    await pumpPassport(tester);

    expect(find.text('万象奇旅'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('open-special-journey-menu')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('open-special-journey-menu')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('special-journey-unlock-sheet')),
      findsOneWidget,
    );
    expect(find.text('万象奇旅 · 特别旅程'), findsOneWidget);
    expect(find.text('旅程钱袋'), findsOneWidget);
    expect(find.text('文学幻境'), findsOneWidget);
    expect(find.text('神话遗踪'), findsOneWidget);
    expect(find.text('志怪夜谈'), findsOneWidget);
    expect(find.text('民间秘境'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('special-journey-literary-roaming')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('special-journey-folk-secret-land')),
      findsOneWidget,
    );
  });
}
