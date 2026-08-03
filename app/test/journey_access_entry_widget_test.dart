import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/state/access_controlled_app_state.dart';
import 'package:phoenix_journeys/widgets/journey_picker_sheet.dart';
import 'package:phoenix_journeys/widgets/special_journey_passport.dart';
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
}
