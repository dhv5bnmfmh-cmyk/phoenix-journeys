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

  testWidgets('Passport groups every destination under its city collection', (
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
      find.byKey(const ValueKey('passport-city-beijing')),
      findsOneWidget,
    );
    expect(find.text('北京收藏册'), findsOneWidget);
    expect(
      find.byKey(
        const ValueKey('passport-destination-beijing-forbidden-city'),
      ),
      findsOneWidget,
    );
    expect(find.text('紫禁城'), findsOneWidget);
  });
}
