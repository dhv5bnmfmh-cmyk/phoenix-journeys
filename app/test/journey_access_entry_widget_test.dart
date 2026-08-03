import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_geography_catalog.dart';
import 'package:phoenix_journeys/screens/city_passport_screen.dart';
import 'package:phoenix_journeys/state/access_controlled_app_state.dart';
import 'package:phoenix_journeys/widgets/journey_picker_sheet.dart';
import 'package:phoenix_journeys/widgets/special_journey_passport.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const seed =
      '0101010101010101010101010101010101010101010101010101010101010101';

  Future<AccessControlledAppState> loadProductionState() async {
    SharedPreferences.setMockInitialValues({});
    final state = AccessControlledAppState(
      clock: () => DateTime(2026, 8, 3, 10),
      debugBuild: false,
      runtimeUri: Uri.parse(
        'https://phoenix.example.com/?unlock=all&prototype=journeys',
      ),
      explorerSeedGenerator: () => seed,
    );
    await state.load();
    return state;
  }

  testWidgets('production unlock query cannot open Special Journey menu items', (
    tester,
  ) async {
    final state = await loadProductionState();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpecialJourneyPassport(state: state),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('open-special-journey-menu')));
    await tester.pumpAndSettle();

    expect(find.textContaining('2 枚金币'), findsOneWidget);
    expect(find.textContaining('已开启 · 点击进入'), findsNothing);
    expect(state.canOpenJourney('literary-roaming'), isFalse);
  });

  testWidgets('Journey Picker disables unreleased regular Journey', (
    tester,
  ) async {
    final state = await loadProductionState();
    final lockedJourney = dailyJourneyExperiences.firstWhere(
      (journey) => !state.canOpenJourney(journey.id),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () {
                  showJourneyPickerSheet(
                    context: context,
                    state: state,
                    initialCityId: lockedJourney.cityId,
                    lockToInitialCity: true,
                  );
                },
                child: const Text('open picker'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open picker'));
    await tester.pumpAndSettle();

    final lockedTile = tester.widget<InkWell>(
      find.byKey(ValueKey('journey-destination-${lockedJourney.id}')),
    );
    expect(lockedTile.onTap, isNull);
    expect(find.text('今日未开放'), findsWidgets);
  });

  testWidgets('Journey Picker keeps the released morning Journey actionable', (
    tester,
  ) async {
    final state = await loadProductionState();
    final releasedJourney = requireDailyJourneyExperience(
      state.dailyAssignment.morningJourneyId,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () {
                  showJourneyPickerSheet(
                    context: context,
                    state: state,
                    initialCityId: releasedJourney.cityId,
                    lockToInitialCity: true,
                  );
                },
                child: const Text('open picker'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open picker'));
    await tester.pumpAndSettle();

    final releasedTile = tester.widget<InkWell>(
      find.byKey(ValueKey('journey-destination-${releasedJourney.id}')),
    );
    expect(releasedTile.onTap, isNotNull);
    expect(find.textContaining('上午旅程 · 已开放'), findsOneWidget);
  });

  testWidgets('Passport ignores production unlock query and disables locked entry', (
    tester,
  ) async {
    final state = await loadProductionState();
    final lockedJourney = dailyJourneyExperiences.firstWhere(
      (journey) => !state.canOpenJourney(journey.id),
    );
    final province = chinaProvinceCatalog.singleWhere(
      (entry) => entry.cityIds.contains(lockedJourney.cityId),
    );

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(body: CityPassportScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('全开放'), findsNothing);
    expect(find.text('${state.earnedStampCount} 枚'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('passport-country-china')));
    await tester.pumpAndSettle();

    final provinceFinder = find.byKey(
      ValueKey('passport-province-${province.id}'),
    );
    await tester.ensureVisible(provinceFinder);
    await tester.tap(provinceFinder);
    await tester.pumpAndSettle();

    if (!province.isMunicipality) {
      final cityFinder = find.byKey(
        ValueKey('passport-city-option-${lockedJourney.cityId}'),
      );
      await tester.ensureVisible(cityFinder);
      await tester.tap(cityFinder);
      await tester.pumpAndSettle();
    }

    final destinationFinder = find.byKey(
      ValueKey('passport-place-option-${lockedJourney.id}'),
    );
    await tester.ensureVisible(destinationFinder);
    final destinationTap = tester.widget<InkWell>(
      find.descendant(
        of: destinationFinder,
        matching: find.byType(InkWell),
      ),
    );

    expect(destinationTap.onTap, isNull);
    expect(state.activeJourneyId, isNot(lockedJourney.id));
  });
}
