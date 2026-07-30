import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/shadowing_passage_catalog.dart';

void main() {
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
}
