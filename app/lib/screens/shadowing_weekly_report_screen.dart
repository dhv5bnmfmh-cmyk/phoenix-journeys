import 'package:flutter/material.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

class ShadowingWeeklyReportScreen extends StatelessWidget {
  const ShadowingWeeklyReportScreen({
    super.key,
    required this.history,
    required this.weaknesses,
    required this.onStartTraining,
    required this.onOpenWeakness,
  });

  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;
  final Future<void> Function() onOpenWeakness;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: now.weekday - 1));
    final previousWeekStart = weekStart.subtract(const Duration(days: 7));

    final current = history.recentSessions.where((session) {
      final day = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      return !day.isBefore(weekStart);
    }).toList(growable: false);

    final previous = history.recentSessions.where((session) {
      final day = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      return !day.isBefore(previousWeekStart) && day.isBefore(weekStart);
    }).toList(growable: false);

    final currentAverage = _average(current);
    final previousAverage = _average(previous);
    final delta = currentAverage - previousAverage;
    final practicedDays = current
        .map((session) => DateTime(
              session.completedAt.year,
              session.completedAt.month,
              session.completedAt.day,
            ))
        .toSet()
        .length;
    final best = current.isEmpty
        ? null
        : current.reduce((a, b) => a.score >= b.score ? a : b);
    final recommendation = _recommendation(
      currentAverage: currentAverage,
      pendingWeaknesses: weaknesses.pendingCount,
      practicedDays: practicedDays,
    );

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('本周复盘')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          children: [
            _ReportHero(
              average: currentAverage,
              delta: delta,
              sessions: current.length,
              practicedDays: practicedDays,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricTile(label: '本周训练', value: '${current.length}'),
                const SizedBox(width: 10),
                _MetricTile(label: '训练天数', value: '$practicedDays'),
                const SizedBox(width: 10),
                _MetricTile(label: '连续天数', value: '${history.currentStreak}'),
              ],
            ),
            const SizedBox(height: 18),
            const _SectionTitle('七日训练轨迹'),
            const SizedBox(height: 10),
            _WeekTrack(
              weekStart: weekStart,
              sessions: current,
              today: today,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('与上周相比'),
            const SizedBox(height: 10),
            _ComparisonCard(
              currentAverage: currentAverage,
              previousAverage: previousAverage,
              delta: delta,
              previousSessions: previous.length,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('本周最佳表现'),
            const SizedBox(height: 10),
            _BestPerformance(session: best),
            const SizedBox(height: 18),
            const _SectionTitle('弱项变化'),
            const SizedBox(height: 10),
            _WeaknessSummary(
              pending: weaknesses.pendingCount,
              mastered: weaknesses.masteredCount,
              counts: weaknesses.pendingMetricCounts,
              onOpenWeakness: onOpenWeakness,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('下周训练建议'),
            const SizedBox(height: 10),
            _RecommendationCard(
              title: recommendation.$1,
              subtitle: recommendation.$2,
              onStartTraining: onStartTraining,
            ),
          ],
        ),
      ),
    );
  }

  static int _average(List<ShadowingSession> sessions) {
    if (sessions.isEmpty) return 0;
    return (sessions.fold<int>(0, (sum, item) => sum + item.score) /
            sessions.length)
        .round();
  }

  static (String, String) _recommendation({
    required int currentAverage,
    required int pendingWeaknesses,
    required int practicedDays,
  }) {
    if (practicedDays < 3) {
      return ('先稳住训练频率', '下周至少完成 3 天训练，每次保持 5 到 10 分钟。');
    }
    if (pendingWeaknesses >= 5) {
      return ('优先清理高频弱项', '先完成弱项复练，再回到原速材料巩固。');
    }
    if (currentAverage >= 88) {
      return ('挑战自然语速', '保持准确度，同时增加连读、停顿与语气训练。');
    }
    if (currentAverage >= 75) {
      return ('提升稳定性', '选择同等级材料，连续三次保持 80 分以上。');
    }
    return ('放慢速度打基础', '使用 0.7× 到 0.9× 示范，逐句修正后再连读。');
  }
}

class _ReportHero extends StatelessWidget {
  const _ReportHero({
    required this.average,
    required this.delta,
    required this.sessions,
    required this.practicedDays,
  });

  final int average;
  final int delta;
  final int sessions;
  final int practicedDays;

  @override
  Widget build(BuildContext context) {
    final trend = delta > 0 ? '提升 $delta 分' : delta < 0 ? '下降 ${delta.abs()} 分' : '与上周持平';
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F1D1D), Color(0xFFB23A2A)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.summarize_rounded,
              color: Color(0xFFFFD879), size: 40),
          const SizedBox(height: 12),
          const Text(
            '你的本周声音报告',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$average',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 7, left: 4),
                child: Text('平均分', style: TextStyle(color: Colors.white70)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    color: Color(0xFFFFD879),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '完成 $sessions 次训练，覆盖 $practicedDays 天。',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .84),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      );
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .84),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _WeekTrack extends StatelessWidget {
  const _WeekTrack({
    required this.weekStart,
    required this.sessions,
    required this.today,
  });

  final DateTime weekStart;
  final List<ShadowingSession> sessions;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final day = weekStart.add(Duration(days: index));
          final daySessions = sessions.where((session) {
            final d = session.completedAt;
            return d.year == day.year && d.month == day.month && d.day == day.day;
          }).toList(growable: false);
          final best = daySessions.isEmpty
              ? 0
              : daySessions.fold<int>(0, (value, item) => item.score > value ? item.score : value);
          return Expanded(
            child: Column(
              children: [
                Text(labels[index],
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 56,
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 18,
                    height: best == 0 ? 6 : 12 + best * .42,
                    decoration: BoxDecoration(
                      color: best == 0
                          ? Colors.black12
                          : day == today
                              ? PhoenixTheme.red
                              : PhoenixTheme.red.withValues(alpha: .64),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(best == 0 ? '—' : '$best',
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.currentAverage,
    required this.previousAverage,
    required this.delta,
    required this.previousSessions,
  });

  final int currentAverage;
  final int previousAverage;
  final int delta;
  final int previousSessions;

  @override
  Widget build(BuildContext context) {
    final positive = delta >= 0;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: positive ? const Color(0xFF2E7D32) : PhoenixTheme.red,
            size: 34,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  previousSessions == 0
                      ? '上周暂无可比较数据'
                      : positive
                          ? '整体表现正在上升'
                          : '本周需要重新稳住节奏',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '本周 $currentAverage 分 · 上周 $previousAverage 分',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            delta == 0 ? '0' : '${delta > 0 ? '+' : ''}$delta',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: positive ? const Color(0xFF2E7D32) : PhoenixTheme.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestPerformance extends StatelessWidget {
  const _BestPerformance({required this.session});
  final ShadowingSession? session;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const _EmptyCard(
        icon: Icons.workspace_premium_rounded,
        title: '本周还没有训练记录',
        subtitle: '完成一次训练后，这里会显示本周最佳表现。',
      );
    }
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded,
              color: Color(0xFFB7791F), size: 38),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session!.title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  '${session!.completedAt.month} 月 ${session!.completedAt.day} 日完成',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Text('${session!.score}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _WeaknessSummary extends StatelessWidget {
  const _WeaknessSummary({
    required this.pending,
    required this.mastered,
    required this.counts,
    required this.onOpenWeakness,
  });

  final int pending;
  final int mastered;
  final Map<String, int> counts;
  final Future<void> Function() onOpenWeakness;

  @override
  Widget build(BuildContext context) {
    final primary = counts.entries.fold<MapEntry<String, int>>(
      const MapEntry('准确度', 0),
      (best, item) => item.value > best.value ? item : best,
    );
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _MiniStat(label: '待复练', value: '$pending'),
              _MiniStat(label: '已掌握', value: '$mastered'),
              _MiniStat(label: '主要弱项', value: primary.value == 0 ? '无' : primary.key),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenWeakness,
              icon: const Icon(Icons.healing_rounded),
              label: const Text('查看弱项复练'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      );
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.onStartTraining,
  });

  final String title;
  final String subtitle;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(color: Colors.black54, height: 1.45)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStartTraining,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('开始下一次训练'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: PhoenixTheme.red, size: 34),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
