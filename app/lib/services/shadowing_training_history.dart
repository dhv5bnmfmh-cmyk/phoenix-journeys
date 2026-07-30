import 'dart:convert';

ShadowingTrainingHistory _runtimeHistory = const ShadowingTrainingHistory();
final Map<String, String> _runtimeDailyRecommendations = <String, String>{};

String _calendarDayKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

bool _sameCalendarDay(DateTime left, DateTime right) =>
    left.year == right.year &&
    left.month == right.month &&
    left.day == right.day;

String _dailyRecommendationKey(int level, DateTime day) =>
    '${_calendarDayKey(day)}:${level.clamp(1, 10)}';

void resetShadowingTrainingRuntimeState() {
  _runtimeHistory = const ShadowingTrainingHistory();
  _runtimeDailyRecommendations.clear();
}

void rememberShadowingDailyRecommendation({
  required int level,
  required String passageId,
  DateTime? date,
}) {
  _runtimeDailyRecommendations[
    _dailyRecommendationKey(level, date ?? DateTime.now())
  ] = passageId;
}

String? rememberedShadowingDailyRecommendationForLevel(
  int level, {
  DateTime? date,
}) {
  final day = date ?? DateTime.now();
  final key = _dailyRecommendationKey(level, day);
  final remembered = _runtimeDailyRecommendations[key];
  if (remembered != null) return remembered;

  for (final session in _runtimeHistory.recentSessions) {
    if (session.dailyRecommendationLevel == level.clamp(1, 10) &&
        _sameCalendarDay(session.completedAt, day)) {
      _runtimeDailyRecommendations[key] = session.passageId;
      return session.passageId;
    }
  }
  return null;
}

Map<String, int> recentBestShadowingScores() {
  final scores = <String, int>{};
  for (final session in _runtimeHistory.recentSessions) {
    final previous = scores[session.passageId] ?? 0;
    if (session.score > previous) scores[session.passageId] = session.score;
  }
  return scores;
}

int? shadowingScoreCompletedOnDay(
  String passageId, {
  DateTime? date,
}) {
  final day = date ?? DateTime.now();
  int? best;
  for (final session in _runtimeHistory.recentSessions) {
    if (session.passageId == passageId &&
        _sameCalendarDay(session.completedAt, day) &&
        (best == null || session.score > best)) {
      best = session.score;
    }
  }
  return best;
}

int? _rememberedLevelForPassage(String passageId, DateTime completedAt) {
  final prefix = '${_calendarDayKey(completedAt)}:';
  for (final entry in _runtimeDailyRecommendations.entries) {
    if (entry.key.startsWith(prefix) && entry.value == passageId) {
      return int.tryParse(entry.key.substring(prefix.length));
    }
  }
  return null;
}

void _activateRuntimeHistory(ShadowingTrainingHistory history) {
  _runtimeHistory = history;
  for (final session in history.recentSessions) {
    final level = session.dailyRecommendationLevel;
    if (level == null) continue;
    _runtimeDailyRecommendations.putIfAbsent(
      _dailyRecommendationKey(level, session.completedAt),
      () => session.passageId,
    );
  }
}

class ShadowingSession {
  const ShadowingSession({
    required this.passageId,
    required this.title,
    required this.score,
    required this.completedAt,
    this.dailyRecommendationLevel,
  });

  final String passageId;
  final String title;
  final int score;
  final DateTime completedAt;
  final int? dailyRecommendationLevel;

  Map<String, Object?> toJson() => {
        'passageId': passageId,
        'title': title,
        'score': score,
        'completedAt': completedAt.toIso8601String(),
        'dailyRecommendationLevel': dailyRecommendationLevel,
      };

  factory ShadowingSession.fromJson(Map<String, dynamic> json) {
    final recommendationLevel =
        (json['dailyRecommendationLevel'] as num?)?.toInt();
    return ShadowingSession(
      passageId: json['passageId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      completedAt:
          DateTime.tryParse(json['completedAt'] as String? ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0),
      dailyRecommendationLevel:
          recommendationLevel != null && recommendationLevel > 0
              ? recommendationLevel.clamp(1, 10)
              : null,
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
    final dayDifference =
        previous == null ? null : day.difference(previous).inDays;
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
        dailyRecommendationLevel:
            _rememberedLevelForPassage(passageId, completedAt),
      ),
      ...recentSessions,
    ].take(20).toList(growable: false);

    final next = ShadowingTrainingHistory(
      totalSessions: totalSessions + 1,
      currentStreak: nextStreak,
      bestStreak: nextStreak > bestStreak ? nextStreak : bestStreak,
      lastPracticeDay: day,
      recentSessions: sessions,
    );
    _activateRuntimeHistory(next);
    return next;
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
      const empty = ShadowingTrainingHistory();
      _activateRuntimeHistory(empty);
      return empty;
    }
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      final sessions = (json['recentSessions'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ShadowingSession.fromJson)
          .toList(growable: false);
      final history = ShadowingTrainingHistory(
        totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
        currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
        bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
        lastPracticeDay:
            DateTime.tryParse(json['lastPracticeDay'] as String? ?? ''),
        recentSessions: sessions,
      );
      _activateRuntimeHistory(history);
      return history;
    } catch (_) {
      const empty = ShadowingTrainingHistory();
      _activateRuntimeHistory(empty);
      return empty;
    }
  }
}
