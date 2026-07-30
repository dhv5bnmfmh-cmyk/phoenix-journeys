import 'dart:convert';

import 'shadowing_score.dart';

class ShadowingWeaknessItem {
  const ShadowingWeaknessItem({
    required this.id,
    required this.passageId,
    required this.passageTitle,
    required this.sentenceIndex,
    required this.sentence,
    required this.focusCharacters,
    required this.weakestMetric,
    required this.bestScore,
    required this.lastScore,
    required this.accuracy,
    required this.completeness,
    required this.fluency,
    required this.omittedCharacters,
    required this.wrongCharacters,
    required this.extraCharacters,
    required this.attempts,
    required this.consecutiveStrongAttempts,
    required this.lastPracticedAt,
    this.masteredAt,
  });

  final String id;
  final String passageId;
  final String passageTitle;
  final int sentenceIndex;
  final String sentence;
  final String focusCharacters;
  final String weakestMetric;
  final int bestScore;
  final int lastScore;
  final int accuracy;
  final int completeness;
  final int fluency;
  final int omittedCharacters;
  final int wrongCharacters;
  final int extraCharacters;
  final int attempts;
  final int consecutiveStrongAttempts;
  final DateTime lastPracticedAt;
  final DateTime? masteredAt;

  bool get mastered => masteredAt != null;
  int get issueCount => omittedCharacters + wrongCharacters + extraCharacters;
  int get severity =>
      ((100 - lastScore) * 2 + issueCount * 8 + attempts.clamp(0, 10))
          .clamp(0, 260)
          .toInt();

  String get issueSummary =>
      '漏读 $omittedCharacters · 错读 $wrongCharacters · 多读 $extraCharacters';

  Map<String, Object?> toJson() => {
    'id': id,
    'passageId': passageId,
    'passageTitle': passageTitle,
    'sentenceIndex': sentenceIndex,
    'sentence': sentence,
    'focusCharacters': focusCharacters,
    'weakestMetric': weakestMetric,
    'bestScore': bestScore,
    'lastScore': lastScore,
    'accuracy': accuracy,
    'completeness': completeness,
    'fluency': fluency,
    'omittedCharacters': omittedCharacters,
    'wrongCharacters': wrongCharacters,
    'extraCharacters': extraCharacters,
    'attempts': attempts,
    'consecutiveStrongAttempts': consecutiveStrongAttempts,
    'lastPracticedAt': lastPracticedAt.toIso8601String(),
    'masteredAt': masteredAt?.toIso8601String(),
  };

  factory ShadowingWeaknessItem.fromJson(Map<String, dynamic> json) {
    return ShadowingWeaknessItem(
      id: json['id'] as String? ?? '',
      passageId: json['passageId'] as String? ?? '',
      passageTitle: json['passageTitle'] as String? ?? '',
      sentenceIndex: (json['sentenceIndex'] as num?)?.toInt() ?? 0,
      sentence: json['sentence'] as String? ?? '',
      focusCharacters: json['focusCharacters'] as String? ?? '',
      weakestMetric: json['weakestMetric'] as String? ?? '准确度',
      bestScore: (json['bestScore'] as num?)?.toInt() ?? 0,
      lastScore: (json['lastScore'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toInt() ?? 0,
      completeness: (json['completeness'] as num?)?.toInt() ?? 0,
      fluency: (json['fluency'] as num?)?.toInt() ?? 0,
      omittedCharacters: (json['omittedCharacters'] as num?)?.toInt() ?? 0,
      wrongCharacters: (json['wrongCharacters'] as num?)?.toInt() ?? 0,
      extraCharacters: (json['extraCharacters'] as num?)?.toInt() ?? 0,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      consecutiveStrongAttempts:
          (json['consecutiveStrongAttempts'] as num?)?.toInt() ?? 0,
      lastPracticedAt:
          DateTime.tryParse(json['lastPracticedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      masteredAt: DateTime.tryParse(json['masteredAt'] as String? ?? ''),
    );
  }
}

class ShadowingWeaknessLibrary {
  const ShadowingWeaknessLibrary({this.items = const []});

  final List<ShadowingWeaknessItem> items;

  int get pendingCount => items.where((item) => !item.mastered).length;
  int get masteredCount => items.where((item) => item.mastered).length;

  Map<String, int> get pendingMetricCounts {
    final counts = <String, int>{'准确度': 0, '完整度': 0, '流利度': 0};
    for (final item in items.where((item) => !item.mastered)) {
      counts[item.weakestMetric] = (counts[item.weakestMetric] ?? 0) + 1;
    }
    return counts;
  }

  List<ShadowingWeaknessItem> dailyQueue({int limit = 5}) {
    final queue = items.where((item) => !item.mastered).toList();
    queue.sort((left, right) {
      final bySeverity = right.severity.compareTo(left.severity);
      if (bySeverity != 0) return bySeverity;
      return left.lastPracticedAt.compareTo(right.lastPracticedAt);
    });
    return queue.take(limit).toList(growable: false);
  }

  ShadowingWeaknessLibrary recordAttempt({
    required String passageId,
    required String passageTitle,
    required int sentenceIndex,
    required String sentence,
    required String recognized,
    required ShadowingScore score,
    required DateTime practicedAt,
  }) {
    final id = '$passageId::$sentenceIndex';
    ShadowingWeaknessItem? existing;
    for (final item in items) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }

    final strongAttempt =
        score.overall >= 85 &&
        score.accuracy >= 80 &&
        score.completeness >= 85 &&
        score.fluency >= 75 &&
        score.omittedCharacters == 0 &&
        score.wrongCharacters == 0 &&
        score.extraCharacters == 0;
    if (existing == null && strongAttempt) return this;

    final consecutiveStrongAttempts = strongAttempt
        ? (existing?.consecutiveStrongAttempts ?? 0) + 1
        : 0;
    final masteredAt = consecutiveStrongAttempts >= 2
        ? practicedAt
        : strongAttempt
        ? existing?.masteredAt
        : null;
    final focusCharacters = _focusCharacters(
      reference: sentence,
      recognized: recognized,
    );
    final bestScore = existing == null || score.overall > existing.bestScore
        ? score.overall
        : existing.bestScore;
    final updated = ShadowingWeaknessItem(
      id: id,
      passageId: passageId,
      passageTitle: passageTitle,
      sentenceIndex: sentenceIndex,
      sentence: sentence,
      focusCharacters: focusCharacters.isEmpty
          ? existing?.focusCharacters ?? ''
          : focusCharacters,
      weakestMetric: score.weakestMetric,
      bestScore: bestScore,
      lastScore: score.overall,
      accuracy: score.accuracy,
      completeness: score.completeness,
      fluency: score.fluency,
      omittedCharacters: score.omittedCharacters,
      wrongCharacters: score.wrongCharacters,
      extraCharacters: score.extraCharacters,
      attempts: (existing?.attempts ?? 0) + 1,
      consecutiveStrongAttempts: consecutiveStrongAttempts,
      lastPracticedAt: practicedAt,
      masteredAt: masteredAt,
    );
    return ShadowingWeaknessLibrary(
      items: <ShadowingWeaknessItem>[
        updated,
        ...items.where((item) => item.id != id),
      ].take(80).toList(growable: false),
    );
  }

  String encode() =>
      jsonEncode({'items': items.map((item) => item.toJson()).toList()});

  factory ShadowingWeaknessLibrary.decode(String? value) {
    if (value == null || value.isEmpty) {
      return const ShadowingWeaknessLibrary();
    }
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      return ShadowingWeaknessLibrary(
        items: (json['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ShadowingWeaknessItem.fromJson)
            .where(
              (item) =>
                  item.id.isNotEmpty &&
                  item.passageId.isNotEmpty &&
                  item.sentence.isNotEmpty,
            )
            .take(80)
            .toList(growable: false),
      );
    } catch (_) {
      return const ShadowingWeaknessLibrary();
    }
  }
}

String _focusCharacters({
  required String reference,
  required String recognized,
}) {
  final feedback = buildShadowingReferenceFeedback(
    reference: reference,
    recognized: recognized,
  );
  final seen = <String>{};
  final focus = <String>[];
  for (final unit in feedback) {
    if (!unit.matched && seen.add(unit.text)) focus.add(unit.text);
    if (focus.length >= 8) break;
  }
  return focus.join(' · ');
}
