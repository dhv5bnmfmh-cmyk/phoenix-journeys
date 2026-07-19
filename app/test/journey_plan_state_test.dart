import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('journey plan persists across app reloads', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    await state.saveJourneyPlan(
      origin: '海防',
      date: DateTime(2026, 8, 20),
      focus: '表达',
    );

    final restored = AppState();
    await restored.load();

    expect(restored.journeyOrigin, '海防');
    expect(restored.plannedJourneyDate, DateTime(2026, 8, 20));
    expect(restored.journeyLearningFocus, '表达');
    expect(restored.hasJourneyPlan, isTrue);
    expect(restored.journeyPlanDateLabel, '8月20日');
  });
}
