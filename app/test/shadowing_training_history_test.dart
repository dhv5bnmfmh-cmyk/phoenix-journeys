import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_training_history.dart';

void main() {
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
}
