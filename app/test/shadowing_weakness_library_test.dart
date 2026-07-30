import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_score.dart';
import 'package:phoenix_journeys/services/shadowing_weakness_library.dart';

ShadowingScore score({
  required int overall,
  int accuracy = 70,
  int completeness = 70,
  int fluency = 70,
  int omitted = 0,
  int wrong = 0,
  int extra = 0,
}) {
  return ShadowingScore(
    overall: overall,
    accuracy: accuracy,
    completeness: completeness,
    fluency: fluency,
    confidence: 80,
    matchedCharacters: 6,
    referenceCharacters: 8,
    recognizedCharacters: 7,
    omittedCharacters: omitted,
    wrongCharacters: wrong,
    extraCharacters: extra,
  );
}

void main() {
  test('weak attempts enter the personal review library', () {
    final library = const ShadowingWeaknessLibrary().recordAttempt(
      passageId: 'station',
      passageTitle: '第一次独自出发',
      sentenceIndex: 0,
      sentence: '我背好小包，提前来到车站。',
      recognized: '我背好包来到车站',
      score: score(overall: 62, completeness: 68, omitted: 2),
      practicedAt: DateTime(2026, 7, 30, 8),
    );

    expect(library.pendingCount, 1);
    expect(library.items.single.passageId, 'station');
    expect(library.items.single.focusCharacters, isNotEmpty);
    expect(library.items.single.issueCount, 2);
  });

  test('two strong retries mark a weakness as mastered', () {
    var library = const ShadowingWeaknessLibrary().recordAttempt(
      passageId: 'station',
      passageTitle: '第一次独自出发',
      sentenceIndex: 0,
      sentence: '我背好小包，提前来到车站。',
      recognized: '我背好小包来到车站',
      score: score(overall: 60, omitted: 2),
      practicedAt: DateTime(2026, 7, 30, 8),
    );
    final strong = score(
      overall: 92,
      accuracy: 95,
      completeness: 100,
      fluency: 88,
    );
    for (var index = 0; index < 2; index += 1) {
      library = library.recordAttempt(
        passageId: 'station',
        passageTitle: '第一次独自出发',
        sentenceIndex: 0,
        sentence: '我背好小包，提前来到车站。',
        recognized: '我背好小包提前来到车站',
        score: strong,
        practicedAt: DateTime(2026, 7, 30, 9 + index),
      );
    }

    expect(library.pendingCount, 0);
    expect(library.masteredCount, 1);
    expect(library.items.single.mastered, isTrue);
  });

  test('a regression reopens a mastered weakness', () {
    var library = const ShadowingWeaknessLibrary();
    final weak = score(overall: 55, omitted: 3);
    final strong = score(
      overall: 94,
      accuracy: 96,
      completeness: 100,
      fluency: 90,
    );
    final attempts = [weak, strong, strong, weak];
    for (var index = 0; index < attempts.length; index += 1) {
      final attempt = attempts[index];
      library = library.recordAttempt(
        passageId: 'station',
        passageTitle: '第一次独自出发',
        sentenceIndex: 0,
        sentence: '我背好小包，提前来到车站。',
        recognized: attempt.overall > 80 ? '我背好小包提前来到车站' : '我来到车站',
        score: attempt,
        practicedAt: DateTime(2026, 7, 30, 8 + index),
      );
    }

    expect(library.pendingCount, 1);
    expect(library.items.single.mastered, isFalse);
  });

  test('daily queue prioritizes severe unresolved sentences and persists', () {
    var library = const ShadowingWeaknessLibrary();
    library = library.recordAttempt(
      passageId: 'mild',
      passageTitle: '较轻弱项',
      sentenceIndex: 0,
      sentence: '今天的天气很好。',
      recognized: '今天天气很好',
      score: score(overall: 74, omitted: 1),
      practicedAt: DateTime(2026, 7, 29),
    );
    library = library.recordAttempt(
      passageId: 'severe',
      passageTitle: '重点弱项',
      sentenceIndex: 1,
      sentence: '列车开动时我看着窗外。',
      recognized: '列车窗外',
      score: score(overall: 42, omitted: 5, wrong: 1),
      practicedAt: DateTime(2026, 7, 30),
    );

    expect(library.dailyQueue(limit: 1).single.passageId, 'severe');
    expect(ShadowingWeaknessLibrary.decode(library.encode()).items.length, 2);
  });
}
