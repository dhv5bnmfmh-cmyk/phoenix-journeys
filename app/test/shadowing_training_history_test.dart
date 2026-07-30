import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_training_history.dart';

void main() {
  setUp(resetShadowingTrainingRuntimeState);

  test('records consecutive practice days and recent scores', () {
    var history = const ShadowingTrainingHistory();
    history = history.record(
      passageId: 'first',
      title: '第一篇',
      score: 76,
      completedAt: DateTime(2026, 7, 28),
    );
    history = history.record(
      passageId: 'second',
      title: '第二篇',
      score: 91,
      completedAt: DateTime(2026, 7, 29),
    );

    expect(history.totalSessions, 2);
    expect(history.currentStreak, 2);
    expect(history.bestStreak, 2);
    expect(history.bestRecentScore, 91);
  });

  test('same-day practice keeps the streak and increases completions', () {
    var history = const ShadowingTrainingHistory().record(
      passageId: 'first',
      title: '第一篇',
      score: 80,
      completedAt: DateTime(2026, 7, 29, 8),
    );
    history = history.record(
      passageId: 'second',
      title: '第二篇',
      score: 84,
      completedAt: DateTime(2026, 7, 29, 20),
    );

    expect(history.currentStreak, 1);
    expect(history.totalSessions, 2);
  });

  test('history survives serialization', () {
    final original = const ShadowingTrainingHistory().record(
      passageId: 'market',
      title: '清晨的市场',
      score: 88,
      completedAt: DateTime(2026, 7, 29),
    );
    final restored = ShadowingTrainingHistory.decode(original.encode());

    expect(restored.totalSessions, 1);
    expect(restored.currentStreak, 1);
    expect(restored.recentSessions.single.title, '清晨的市场');
    expect(restored.recentSessions.single.score, 88);
  });

  test('daily completion score only applies to the matching calendar day', () {
    const passageId = 'lake-evening';
    const ShadowingTrainingHistory().record(
      passageId: passageId,
      title: '湖边的傍晚',
      score: 86,
      completedAt: DateTime(2026, 7, 30, 21),
    );

    expect(
      shadowingScoreCompletedOnDay(
        passageId,
        date: DateTime(2026, 7, 30, 8),
      ),
      86,
    );
    expect(
      shadowingScoreCompletedOnDay(
        passageId,
        date: DateTime(2026, 7, 31),
      ),
      isNull,
    );
  });

  test('daily recommendation identity survives history serialization', () {
    rememberShadowingDailyRecommendation(
      level: 6,
      passageId: 'lake-evening',
      date: DateTime(2026, 7, 30),
    );
    final original = const ShadowingTrainingHistory().record(
      passageId: 'lake-evening',
      title: '湖边的傍晚',
      score: 90,
      completedAt: DateTime(2026, 7, 30, 20),
    );

    resetShadowingTrainingRuntimeState();
    ShadowingTrainingHistory.decode(original.encode());

    expect(
      rememberedShadowingDailyRecommendationForLevel(
        6,
        date: DateTime(2026, 7, 30, 8),
      ),
      'lake-evening',
    );
  });

  test('recent best scores keep the strongest result for each passage', () {
    var history = const ShadowingTrainingHistory().record(
      passageId: 'market',
      title: '清晨的市场',
      score: 72,
      completedAt: DateTime(2026, 7, 28),
    );
    history = history.record(
      passageId: 'market',
      title: '清晨的市场',
      score: 89,
      completedAt: DateTime(2026, 7, 29),
    );
    history = history.record(
      passageId: 'lake',
      title: '湖边的傍晚',
      score: 81,
      completedAt: DateTime(2026, 7, 30),
    );

    expect(history.totalSessions, 3);
    expect(recentBestShadowingScores(), {
      'market': 89,
      'lake': 81,
    });
  });
}
