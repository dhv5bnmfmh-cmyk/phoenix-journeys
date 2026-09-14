import 'dart:convert';

class ShadowingSession {
  const ShadowingSession({
    required this.passageId,
    required this.title,
    required this.score,
    required this.completedAt,
  });

  final String passageId;
  final String title;
  final int score;
  final DateTime completedAt;

  Map<String, Object> toJson() => {
        'passageId': passageId,
        'title': title,
        'score': score,
        'completedAt': completedAt.toIso8601String(),
      };

  factory ShadowingSession.fromJson(Map<String, dynamic> json) {
    return ShadowingSession(
      passageId: json['passageId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      completedAt:
          DateTime.tryParse(json['completedAt'] as String? ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class ShadowingTrainingHistory {
  const ShadowingTrainingHistory({
    this.totalSessions = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastPracticeDay,
    this.recentSessions = const [],
  });

  final int totalSessions;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPracticeDay;
  final List<ShadowingSession> recentSessions;

  int get bestRecentScore => recentSessions.fold(
        0,
        (best, session) => session.score > best ? session.score : best,
      );

  ShadowingTrainingHistory record({
    required String passageId,
    required String title,
    required int score,
    required DateTime completedAt,
  }) {
    final day = DateTime(completedAt.year, completedAt.month, completedAt.day);
    final previous = lastPracticeDay == null
        ? null
        : DateTime(
            lastPracticeDay!.year,
            lastPracticeDay!.month,
            lastPracticeDay!.day,
          );
    final dayDifference = previous == null ? null : day.difference(previous).inDays;
    final nextStreak = switch (dayDifference) {
      null => 1,
      0 => currentStreak == 0 ? 1 : currentStreak,
      1 => currentStreak + 1,
      _ => 1,
    };
    final sessions = [
      ShadowingSession(
        passageId: passageId,
        title: title,
        score: score.clamp(0, 100),
        completedAt: completedAt,
      ),
      ...recentSessions,
    ].take(20).toList(growable: false);

    return ShadowingTrainingHistory(
      totalSessions: totalSessions + 1,
      currentStreak: nextStreak,
      bestStreak: nextStreak > bestStreak ? nextStreak : bestStreak,
      lastPracticeDay: day,
      recentSessions: sessions,
    );
  }

  String encode() => jsonEncode({
        'totalSessions': totalSessions,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastPracticeDay': lastPracticeDay?.toIso8601String(),
        'recentSessions':
            recentSessions.map((session) => session.toJson()).toList(),
      });

  factory ShadowingTrainingHistory.decode(String? value) {
    if (value == null || value.isEmpty) {
      return const ShadowingTrainingHistory();
    }
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      final sessions = (json['recentSessions'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ShadowingSession.fromJson)
          .toList(growable: false);
      return ShadowingTrainingHistory(
        totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
        currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
        bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
        lastPracticeDay:
            DateTime.tryParse(json['lastPracticeDay'] as String? ?? ''),
        recentSessions: sessions,
      );
    } catch (_) {
      return const ShadowingTrainingHistory();
    }
  }
}
