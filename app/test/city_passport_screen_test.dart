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

  testWidgets('Passport drills from continent to country and one city', (
    tester,
  ) async {
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
      find.byKey(const ValueKey('passport-continent-asia')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-country-china')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsNothing,
    );
    expect(find.text('北京收藏册'), findsNothing);
    expect(find.text('紫禁城'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('passport-country-china')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('passport-province-beijing')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(const ValueKey('passport-province-beijing')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('passport-city-option-beijing')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'passport-place-option-beijing-forbidden-city',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'passport-place-option-beijing-summer-palace',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-place-back')),
      findsOneWidget,
    );

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
    expect(find.text('紫禁城'), findsNWidgets(2));
    expect(find.text('颐和园'), findsNWidgets(2));
  });
}
