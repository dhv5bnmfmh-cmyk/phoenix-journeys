import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/shadowing_passage_catalog.dart';
import 'package:phoenix_journeys/services/shadowing_training_history.dart';

void main() {
  setUp(resetShadowingTrainingRuntimeState);

  test('catalog provides short multi-sentence passages', () {
    expect(shadowingPassages.length, greaterThanOrEqualTo(12));
    for (final passage in shadowingPassages) {
      expect(passage.sentences.length, greaterThanOrEqualTo(3));
      expect(passage.estimatedMinutes, inInclusiveRange(1, 9));
    }
  });

  test('level filter grows with the learner level', () {
    expect(
      shadowingPassagesForLevel(10).length,
      greaterThan(shadowingPassagesForLevel(1).length),
    );
  });

  test('expanded library covers Phoenix travel and growth themes', () {
    final themes = shadowingPassages.map((passage) => passage.theme).toSet();
    expect(themes, contains('旅行启程'));
    expect(themes, contains('勤学成长'));
    expect(themes, contains('古今相遇'));
    expect(themes, contains('勤工俭学'));
    expect(themes, contains('古今想象'));
  });

  test('every Phoenix level can access at least two passages', () {
    for (var level = 1; level <= 10; level += 1) {
      expect(shadowingPassagesForLevel(level).length, greaterThanOrEqualTo(2));
    }
  });

  test('daily recommendation stays stable during the same day', () {
    final morning = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 30, 8),
    );
    final evening = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 30, 20),
    );
    expect(evening.id, morning.id);
  });

  test('daily recommendation rotates on the next day', () {
    final today = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 30),
    );
    final tomorrow = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 31),
    );
    expect(tomorrow.id, isNot(today.id));
  });

  test('daily recommendation stays near the learner level', () {
    for (var level = 1; level <= 10; level += 1) {
      final recommendation = recommendedShadowingPassageForLevel(
        level,
        date: DateTime(2026, 8, level),
      );
      expect((recommendation.level - level).abs(), lessThanOrEqualTo(1));
    }
  });

  test('daily recommendation prioritizes an uncompleted passage', () {
    final recommendation = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 30),
      bestScores: const {
        'museum-time-bridge': 88,
        'lake-evening': 91,
        'work-study-journey': 0,
      },
    );
    expect(recommendation.id, 'work-study-journey');
  });

  test('daily recommendation revisits the lowest scoring nearby passage', () {
    final recommendation = recommendedShadowingPassageForLevel(
      6,
      date: DateTime(2026, 7, 30),
      bestScores: const {
        'museum-time-bridge': 82,
        'lake-evening': 64,
        'work-study-journey': 76,
      },
    );
    expect(recommendation.id, 'lake-evening');
  });

  test('daily card stays fixed after completion and shows todays score', () {
    final day = DateTime(2026, 7, 30);
    final before = shadowingPassagesForLevel(
      6,
      date: day,
      bestScores: const {
        'museum-time-bridge': 82,
        'lake-evening': 64,
        'work-study-journey': 76,
      },
    );
    final recommended = before.first;

    const ShadowingTrainingHistory().record(
      passageId: recommended.id,
      title: recommended.title,
      score: 92,
      completedAt: DateTime(2026, 7, 30, 20),
    );

    final after = shadowingPassagesForLevel(
      6,
      date: day,
      bestScores: const {
        'museum-time-bridge': 99,
        'lake-evening': 99,
        'work-study-journey': 99,
      },
    );
    expect(after.first.id, recommended.id);
    expect(after.first.theme, contains('✓ 今日已完成 92 分'));
    expect(
      after.where((passage) => passage.id == recommended.id),
      hasLength(1),
    );
  });

  test('library uses recent history when explicit best scores are absent', () {
    var history = const ShadowingTrainingHistory().record(
      passageId: 'museum-time-bridge',
      title: '博物馆里的时间桥',
      score: 82,
      completedAt: DateTime(2026, 7, 27),
    );
    history = history.record(
      passageId: 'lake-evening',
      title: '湖边的傍晚',
      score: 64,
      completedAt: DateTime(2026, 7, 28),
    );
    history = history.record(
      passageId: 'work-study-journey',
      title: '边工作边看世界',
      score: 76,
      completedAt: DateTime(2026, 7, 29),
    );

    expect(history.totalSessions, 3);
    final cards = shadowingPassagesForLevel(
      6,
      date: DateTime(2026, 7, 31),
    );
    expect(cards.first.id, 'lake-evening');
    expect(cards.first.theme, contains('薄弱内容巩固'));
  });
}
