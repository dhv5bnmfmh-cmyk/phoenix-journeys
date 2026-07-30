import 'dart:convert';

import '../data/shadowing_passage_catalog.dart';
import 'shadowing_score.dart';
import 'shadowing_weakness_library.dart';

String _dailyPlanDayKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

class ShadowingDailyPlanStep {
  const ShadowingDailyPlanStep({
    required this.id,
    required this.kind,
    required this.title,
    required this.passageId,
    required this.sentenceIndex,
    required this.focusMetric,
    required this.targetScore,
    required this.estimatedMinutes,
  });

  final String id;
  final String kind;
  final String title;
  final String passageId;
  final int sentenceIndex;
  final String focusMetric;
  final int targetScore;
  final int estimatedMinutes;

  bool matches(String candidatePassageId, int candidateSentenceIndex) =>
      passageId == candidatePassageId && sentenceIndex == candidateSentenceIndex;

  bool accepts(ShadowingScore score) {
    if (score.overall < targetScore) return false;
    if (kind == 'focus') {
      return score.accuracy >= 80 && score.completeness >= 85;
    }
    if (kind == 'challenge') return score.fluency >= 75;
    return true;
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'kind': kind,
        'title': title,
        'passageId': passageId,
        'sentenceIndex': sentenceIndex,
        'focusMetric': focusMetric,
        'targetScore': targetScore,
        'estimatedMinutes': estimatedMinutes,
      };

  factory ShadowingDailyPlanStep.fromJson(Map<String, dynamic> json) {
    return ShadowingDailyPlanStep(
      id: json['id'] as String? ?? '',
      kind: json['kind'] as String? ?? 'strengthen',
      title: json['title'] as String? ?? '今日训练',
      passageId: json['passageId'] as String? ?? '',
      sentenceIndex: (json['sentenceIndex'] as num?)?.toInt() ?? 0,
      focusMetric: json['focusMetric'] as String? ?? '综合',
      targetScore: ((json['targetScore'] as num?)?.toInt() ?? 80).clamp(0, 100),
      estimatedMinutes:
          ((json['estimatedMinutes'] as num?)?.toInt() ?? 2).clamp(1, 9),
    );
  }
}

class ShadowingDailyPlan {
  const ShadowingDailyPlan({
    required this.dayKey,
    required this.level,
    required this.steps,
    this.completedStepIds = const <String>{},
  });

  final String dayKey;
  final int level;
  final List<ShadowingDailyPlanStep> steps;
  final Set<String> completedStepIds;

  int get completedCount =>
      steps.where((step) => completedStepIds.contains(step.id)).length;
  int get totalMinutes =>
      steps.fold(0, (total, step) => total + step.estimatedMinutes);
  bool get completed => steps.isNotEmpty && completedCount == steps.length;
  double get progress => steps.isEmpty ? 0 : completedCount / steps.length;

  ShadowingDailyPlanStep? get firstIncompleteStep {
    for (final step in steps) {
      if (!completedStepIds.contains(step.id)) return step;
    }
    return null;
  }

  ShadowingDailyPlanStep? stepById(String? stepId) {
    if (stepId == null) return null;
    for (final step in steps) {
      if (step.id == stepId) return step;
    }
    return null;
  }

  bool isStepCompleted(String stepId) => completedStepIds.contains(stepId);

  ShadowingDailyPlan recordAttempt({
    required String stepId,
    required String passageId,
    required int sentenceIndex,
    required ShadowingScore score,
  }) {
    final step = stepById(stepId);
    if (step == null || !step.matches(passageId, sentenceIndex)) return this;
    if (!step.accepts(score) || completedStepIds.contains(step.id)) return this;
    return ShadowingDailyPlan(
      dayKey: dayKey,
      level: level,
      steps: steps,
      completedStepIds: <String>{...completedStepIds, step.id},
    );
  }

  String encode() => jsonEncode({
        'dayKey': dayKey,
        'level': level,
        'steps': steps.map((step) => step.toJson()).toList(),
        'completedStepIds': completedStepIds.toList(),
      });

  factory ShadowingDailyPlan.decode(String value) {
    final json = jsonDecode(value) as Map<String, dynamic>;
    return ShadowingDailyPlan(
      dayKey: json['dayKey'] as String? ?? '',
      level: ((json['level'] as num?)?.toInt() ?? 1).clamp(1, 10),
      steps: (json['steps'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ShadowingDailyPlanStep.fromJson)
          .where((step) => step.id.isNotEmpty && step.passageId.isNotEmpty)
          .toList(growable: false),
      completedStepIds:
          (json['completedStepIds'] as List<dynamic>? ?? const [])
              .whereType<String>()
              .toSet(),
    );
  }

  static ShadowingDailyPlan restoreOrGenerate({
    required String? encoded,
    required DateTime date,
    required int level,
    required ShadowingWeaknessLibrary weaknessLibrary,
    Map<String, int> bestScores = const <String, int>{},
  }) {
    final dayKey = _dailyPlanDayKey(date);
    final safeLevel = level.clamp(1, 10);
    if (encoded != null && encoded.isNotEmpty) {
      try {
        final restored = ShadowingDailyPlan.decode(encoded);
        if (restored.dayKey == dayKey &&
            restored.level == safeLevel &&
            restored.steps.isNotEmpty) {
          return restored;
        }
      } catch (_) {
        // Invalid or old plans are regenerated below.
      }
    }
    return generate(
      date: date,
      level: safeLevel,
      weaknessLibrary: weaknessLibrary,
      bestScores: bestScores,
    );
  }

  static ShadowingDailyPlan generate({
    required DateTime date,
    required int level,
    required ShadowingWeaknessLibrary weaknessLibrary,
    Map<String, int> bestScores = const <String, int>{},
  }) {
    final dayKey = _dailyPlanDayKey(date);
    final safeLevel = level.clamp(1, 10);
    final available = shadowingPassagesForLevel(
      safeLevel,
      date: date,
      bestScores: bestScores,
    );
    final recommended = recommendedShadowingPassageForLevel(
      safeLevel,
      date: date,
      bestScores: bestScores,
    );
    final steps = <ShadowingDailyPlanStep>[];
    final seen = <String>{};

    void addStep({
      required String kind,
      required String title,
      required String passageId,
      required int sentenceIndex,
      required String focusMetric,
      required int targetScore,
      int estimatedMinutes = 2,
    }) {
      final identity = '$passageId::$sentenceIndex';
      if (!seen.add(identity)) return;
      steps.add(
        ShadowingDailyPlanStep(
          id: '$dayKey:$kind:$identity',
          kind: kind,
          title: title,
          passageId: passageId,
          sentenceIndex: sentenceIndex,
          focusMetric: focusMetric,
          targetScore: targetScore,
          estimatedMinutes: estimatedMinutes,
        ),
      );
    }

    addStep(
      kind: 'warmup',
      title: '热身启动',
      passageId: recommended.id,
      sentenceIndex: 0,
      focusMetric: '自然开口',
      targetScore: 75,
    );

    for (final item in weaknessLibrary.dailyQueue(limit: 3)) {
      addStep(
        kind: 'focus',
        title: '重点复练 · ${item.weakestMetric}',
        passageId: item.passageId,
        sentenceIndex: item.sentenceIndex,
        focusMetric: item.weakestMetric,
        targetScore: 85,
      );
    }

    for (final passage in available) {
      for (var index = 0; index < passage.sentences.length; index += 1) {
        if (steps.length >= 4) break;
        addStep(
          kind: 'strengthen',
          title: '稳定巩固',
          passageId: passage.id,
          sentenceIndex: index,
          focusMetric: '综合',
          targetScore: 80,
        );
      }
      if (steps.length >= 4) break;
    }

    final challengeCandidates = shadowingPassages
        .where((passage) => passage.level <= safeLevel + 1)
        .toList(growable: false);
    final dayOffset = DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(2026))
        .inDays;
    for (var offset = 0; offset < challengeCandidates.length; offset += 1) {
      final index = (dayOffset + safeLevel * 5 + offset).abs() %
          challengeCandidates.length;
      final passage = challengeCandidates[index];
      final before = steps.length;
      addStep(
        kind: 'challenge',
        title: '流利冲刺',
        passageId: passage.id,
        sentenceIndex: passage.sentences.length - 1,
        focusMetric: '流利度',
        targetScore: 88,
        estimatedMinutes: 3,
      );
      if (steps.length > before) break;
    }

    return ShadowingDailyPlan(
      dayKey: dayKey,
      level: safeLevel,
      steps: steps.take(5).toList(growable: false),
    );
  }
}
