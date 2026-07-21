import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/screens/me_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('the shared vocabulary library contains words from every journey', () {
    final catalogWords = allDailyJourneyWords.map((entry) => entry.word).toSet();

    for (final journey in dailyJourneyExperiences) {
      for (final entry in journey.words) {
        expect(catalogWords, contains(entry.word));
      }
    }

    expect(catalogWords, contains('牌坊'));
    expect(catalogWords.length, allDailyJourneyWords.length);
  });

  testWidgets('a saved Nanjing word appears in My Vocabulary', (tester) async {
    final state = AppState(clock: () => DateTime(2026, 7, 21));
    await state.load();
    await state.toggleSavedWord('牌坊');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: MeScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('我的生词 · 1'), findsOneWidget);
    expect(find.text('牌坊'), findsOneWidget);
  });
}
