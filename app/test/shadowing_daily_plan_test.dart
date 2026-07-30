import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_daily_plan.dart';
import 'package:phoenix_journeys/services/shadowing_score.dart';
import 'package:phoenix_journeys/services/shadowing_weakness_library.dart';

ShadowingScore score({
  required int overall,
  int accuracy = 85,
  int completeness = 90,
  int fluency = 80,
}) {
  return ShadowingScore(
    overall: overall,
    accuracy: accuracy,
    completeness: completeness,
    fluency: fluency,
    confidence: 90,
    matchedCharacters: 8,
    referenceCharacters: 8,
    recognizedCharacters: 8,
    omittedCharacters: 0,
    wrongCharacters: 0,
    extraCharacters: 0,
  );
}

void main() {
  test('daily plan combines warmup, weakness review, and challenge', () {
    const weakScore = ShadowingScore(
      overall: 60,
      accuracy: 65,
      completeness: 70,
      fluency: 68,
      confidence: 70,
      matchedCharacters: 5,
      referenceCharacters: 8,
      recognizedCharacters: 6,
      omittedCharacters: 2,
      wrongCharacters: 1,
      extraCharacters: 0,
    );
    final library = const ShadowingWeaknessLibrary().recordAttempt(
      passageId: 'station-first-trip',
      passageTitle: '第一次独自出发',
      sentenceIndex: 1,
      sentence: '车票、手机和水都已经准备好了。',
      recognized: '车票手机都准备好了',
      score: weakScore,
      practicedAt: DateTime(2026, 7, 29),
    );

    final plan = ShadowingDailyPlan.generate(
      date: DateTime(2026, 7, 30),
      level: 4,
      weaknessLibrary: library,
    );

    expect(plan.steps.length, greaterThanOrEqualTo(4));
    expect(plan.steps.first.kind, 'warmup');
    expect(plan.steps.any((step) => step.kind == 'focus'), isTrue);
    expect(plan.steps.last.kind, 'challenge');
    expect(plan.totalMinutes, greaterThanOrEqualTo(8));
  });

  test('same-day encoded plan restores its progress', () {
    final original = ShadowingDailyPlan.generate(
      date: DateTime(2026, 7, 30),
      level: 6,
      weaknessLibrary: const ShadowingWeaknessLibrary(),
    );
    final first = original.steps.first;
    final progressed = original.recordAttempt(
      stepId: first.id,
      passageId: first.passageId,
      sentenceIndex: first.sentenceIndex,
      score: score(overall: 82),
    );

    final restored = ShadowingDailyPlan.restoreOrGenerate(
      encoded: progressed.encode(),
      date: DateTime(2026, 7, 30, 22),
      level: 6,
      weaknessLibrary: const ShadowingWeaknessLibrary(),
    );

    expect(restored.completedCount, 1);
    expect(restored.isStepCompleted(first.id), isTrue);
    expect(
      restored.steps.map((step) => step.id),
      original.steps.map((step) => step.id),
    );
  });

  test('new calendar day regenerates the route and clears completion', () {
    final original = ShadowingDailyPlan.generate(
      date: DateTime(2026, 7, 30),
      level: 6,
      weaknessLibrary: const ShadowingWeaknessLibrary(),
    );
    final first = original.steps.first;
    final progressed = original.recordAttempt(
      stepId: first.id,
      passageId: first.passageId,
      sentenceIndex: first.sentenceIndex,
      score: score(overall: 82),
    );

    final nextDay = ShadowingDailyPlan.restoreOrGenerate(
      encoded: progressed.encode(),
      date: DateTime(2026, 7, 31),
      level: 6,
      weaknessLibrary: const ShadowingWeaknessLibrary(),
    );

    expect(nextDay.dayKey, '2026-07-31');
    expect(nextDay.completedCount, 0);
  });

  test('focus and challenge steps enforce adaptive targets', () {
    const focus = ShadowingDailyPlanStep(
      id: 'focus',
      kind: 'focus',
      title: '重点复练',
      passageId: 'p',
      sentenceIndex: 0,
      focusMetric: '完整度',
      targetScore: 85,
      estimatedMinutes: 2,
    );
    const challenge = ShadowingDailyPlanStep(
      id: 'challenge',
      kind: 'challenge',
      title: '流利冲刺',
      passageId: 'p',
      sentenceIndex: 1,
      focusMetric: '流利度',
      targetScore: 88,
      estimatedMinutes: 3,
    );

    expect(
      focus.accepts(
        score(overall: 88, accuracy: 79, completeness: 95, fluency: 90),
      ),
      isFalse,
    );
    expect(
      focus.accepts(
        score(overall: 88, accuracy: 82, completeness: 90, fluency: 70),
      ),
      isTrue,
    );
    expect(
      challenge.accepts(
        score(overall: 92, accuracy: 95, completeness: 95, fluency: 72),
      ),
      isFalse,
    );
  });
}
