import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/screens/me_screen.dart';
import 'package:phoenix_journeys/services/language_level_preference_store.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PhoenixLevelController.instance.setLevel(
      PhoenixLevelController.defaultLevel,
    );
  });

  test('Me level persists and a new Journey snapshots latest level', () async {
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

  test('mounted Journey and narration stay bound to the Lv5 session snapshot',
      () async {
    const store = LanguageLevelPreferenceStore();
    const agent = PhoenixLanguageLevelAgent();

    await store.savePhoenixLevel(5);
    final mountedSession =
        snapshotJourneySessionProfile(PhoenixLevelController.instance);
    final mountedRate = agent.planFor(mountedSession).speechRate;

    await store.savePhoenixLevel(7);
    final nextSession =
        snapshotJourneySessionProfile(PhoenixLevelController.instance);
    final nextRate = agent.planFor(nextSession).speechRate;

    expect(PhoenixLevelController.instance.level, 7);
    expect(mountedSession.phoenixLevel, 5);
    expect(mountedRate, .92);
    expect(nextSession.phoenixLevel, 7);
    expect(nextRate, .98);

    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
    expect(
      journey,
      contains('late final ChineseProficiencyProfile _sessionLanguageProfile;'),
    );
    expect(
      journey,
      contains('snapshotJourneySessionProfile(_phoenixLevelController)'),
    );
    expect(
      journey,
      contains(
        '_languageLevelAgent.planFor(_sessionLanguageProfile).speechRate',
      ),
    );
    expect(
      journey,
      isNot(contains('addListener(_handlePhoenixLevelChanged)')),
    );
  });

  testWidgets('Me exposes one canonical level and language preferences', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final state = AppState();
    await state.load();
    state.setTab(3);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: MeScreen())),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const ValueKey('me-learning-settings')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('global-journey-level-selector')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('phoenix-level-minus')), findsOneWidget);
    expect(find.byKey(const ValueKey('phoenix-level-plus')), findsOneWidget);
    expect(find.byKey(const ValueKey('settings-script-mode')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('settings-translation-language')),
      findsOneWidget,
    );
    expect(find.text('Phoenix 中文等级'), findsOneWidget);
    expect(find.textContaining('下一次进入旅程时应用'), findsOneWidget);
    expect(find.textContaining('HSK'), findsNothing);
    expect(find.textContaining('TOCFL'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('phoenix-level-plus')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final preferences = await SharedPreferences.getInstance();
    expect(PhoenixLevelController.instance.level, 6);
    expect(preferences.getInt('phoenix.level'), 6);
    expect(find.text('Lv.6'), findsOneWidget);
  });

  test('Home and Journey source enforce Me-only configured level control', () {
    final home = File('lib/screens/home_shell.dart').readAsStringSync();
    final me = File('lib/screens/me_screen.dart').readAsStringSync();
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();

    expect(home, isNot(contains('SettingsScreen()')));
    expect(home, isNot(contains("state.displayText('设置')")));
    expect(home, isNot(contains('state.selectedTab == 4')));
    expect(home, isNot(contains('state.setTab(4)')));
    expect(home, isNot(contains('settings_outlined')));
    expect(home, isNot(contains('Positioned(\n              top: 6')));

    expect(
      RegExp(r'JourneyLevelSelectorButton\(').allMatches(me).length,
      1,
    );
    expect(me, contains("ValueKey('me-learning-settings')"));
    expect(me, isNot(contains('HSK／TOCFL 能力设置')));
    expect(me, isNot(contains('_chooseLevel')));

    expect(journey, contains("ValueKey('journey-session-level-badge')"));
    expect(journey, contains('snapshotJourneySessionProfile('));
    expect(journey, isNot(contains('addListener(_handlePhoenixLevelChanged)')));
    expect(journey, isNot(contains('_applyPhoenixLevelChange')));
    expect(journey, isNot(contains('_settlePhoenixLevelChange')));
    expect(journey, isNot(contains("ValueKey('phoenix-level-minus')")));
    expect(journey, isNot(contains("ValueKey('phoenix-level-plus')")));
    expect(journey, contains('final page = switch (step) {'));
  });

  test('Home navigation clamps selected tab to Me range', () {
    final state = AppState();
    state.setTab(3);
    expect(state.selectedTab, 3);
    state.setTab(99);
    expect(state.selectedTab, 3);
    state.setTab(-1);
    expect(state.selectedTab, 0);
  });
}
