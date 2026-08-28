import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/screens/settings_screen.dart';
import 'package:phoenix_journeys/services/language_level_preference_store.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PhoenixLevelController.instance.setLevel(
      PhoenixLevelController.defaultLevel,
    );
  });

  test('Settings level persists and a new Journey snapshots latest level', () async {
    const store = LanguageLevelPreferenceStore();

    await store.savePhoenixLevel(5);
    final firstSession =
        snapshotJourneySessionProfile(PhoenixLevelController.instance);

    await store.savePhoenixLevel(7);
    final secondSession =
        snapshotJourneySessionProfile(PhoenixLevelController.instance);
    final preferences = await SharedPreferences.getInstance();

    expect(preferences.getInt('phoenix.level'), 7);
    expect(firstSession.phoenixLevel, 5);
    expect(secondSession.phoenixLevel, 7);
  });

  testWidgets('Settings exposes configured level and existing language preferences', (
    tester,
  ) async {
    final state = AppState();
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('settings-screen')), findsOneWidget);
    expect(find.byKey(const ValueKey('global-journey-level-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('phoenix-level-minus')), findsOneWidget);
    expect(find.byKey(const ValueKey('phoenix-level-plus')), findsOneWidget);
    expect(find.byKey(const ValueKey('settings-script-mode')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('settings-translation-language')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('phoenix-level-plus')));
    await tester.pump();
    expect(PhoenixLevelController.instance.level, 6);
  });

  test('Home and Journey source enforce Settings-only live level control', () {
    final home = File('lib/screens/home_shell.dart').readAsStringSync();
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();

    expect(home, contains('SettingsScreen()'));
    expect(home, contains("state.displayText('设置')"));
    expect(home, contains('state.selectedTab == 4'));
    expect(home, isNot(contains('Positioned(\n              top: 6')));
    expect(
      home,
      isNot(contains("widgets/journey_level_selector_button.dart")),
    );

    expect(journey, contains("ValueKey('journey-session-level-badge')"));
    expect(journey, contains("snapshotJourneySessionProfile("));
    expect(journey, isNot(contains('addListener(_handlePhoenixLevelChanged)')));
    expect(journey, isNot(contains('_applyPhoenixLevelChange')));
    expect(journey, isNot(contains('_settlePhoenixLevelChange')));
    expect(journey, isNot(contains("ValueKey('phoenix-level-minus')")));
    expect(journey, isNot(contains("ValueKey('phoenix-level-plus')")));
    expect(journey, contains('final page = switch (step) {'));
  });

  test('Home navigation clamps selected tab to Settings range', () {
    final state = AppState();
    state.setTab(4);
    expect(state.selectedTab, 4);
    state.setTab(99);
    expect(state.selectedTab, 4);
    state.setTab(-1);
    expect(state.selectedTab, 0);
  });
}
