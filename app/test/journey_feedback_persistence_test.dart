import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Agent feedback persists separately for each city journey', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 7, 20));
    await state.load();

    await state.saveGuideFeedback(
      reply: '西安的城墙让城市边界变得清楚。',
      isOfflineFallback: false,
    );
    await state.saveWritingFeedback(
      corrected: '我想从城墙上看古城。',
      explanation: '补充了完整标点。',
      natural: '我想站在城墙上看看古城。',
      encouragement: '表达很清楚。',
      isOfflineFallback: false,
    );

    final restored = AppState(clock: () => DateTime(2026, 7, 20));
    await restored.load();
    expect(restored.hasGuideFeedback, isTrue);
    expect(restored.guideFeedbackReply, contains('城墙'));
    expect(restored.hasWritingFeedback, isTrue);
    expect(restored.writingFeedbackNatural, contains('城墙'));

    final otherJourneyId = dailyJourneyExperiences
        .firstWhere((journey) => journey.id != restored.activeJourneyId)
        .id;
    await restored.activateJourney(otherJourneyId);
    expect(restored.hasGuideFeedback, isFalse);
    expect(restored.hasWritingFeedback, isFalse);
  });
}
