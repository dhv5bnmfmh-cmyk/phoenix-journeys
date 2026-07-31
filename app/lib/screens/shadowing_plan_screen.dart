import 'package:flutter/material.dart';

import '../data/shadowing_passage_catalog.dart';
import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

class ShadowingPlanScreen extends StatefulWidget {
  const ShadowingPlanScreen({
    super.key,
    required this.history,
    required this.weaknesses,
    required this.onStartTraining,
    required this.onOpenWeakness,
    required this.onOpenLibrary,
    required this.onOpenProgress,
  });

  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;
  final Future<void> Function() onOpenWeakness;
  final Future<void> Function() onOpenLibrary;
  final Future<void> Function() onOpenProgress;

  @override
  State<ShadowingPlanScreen> createState() => _ShadowingPlanScreenState();
}

class _ShadowingPlanScreenState extends State<ShadowingPlanScreen> {
  int _weeklyGoal = 5;

  @override
  Widget build(BuildContext context) {
    final sessions = widget.history.recentSessions;
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final weekSessions = sessions.where((session) {
      final day = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      return !day.isBefore(weekStart);
    }).toList(growable: false);
    final practicedDays = weekSessions
        .map((session) => DateTime(
              session.completedAt.year,
              session.completedAt.month,
              session.completedAt.day,
            ))
        .toSet();
    final goalProgress = (_weeklyGoal == 0
            ? 0.0
            : practicedDays.length / _weeklyGoal)
        .clamp(0.0, 1.0);
    final recentFive = sessions.take(5).toList(growable: false);
    final recentAverage = recentFive.isEmpty
        ? 0
        : (recentFive.fold<int>(0, (sum, item) => sum + item.score) /
                recentFive.length)
            .round();
    final metricCounts = widget.weaknesses.pendingMetricCounts;
    final primaryMetric = metricCounts.entries.fold<MapEntry<String, int>>(
      const MapEntry('准确度', 0),
      (best, item) => item.value > best.value ? item : best,
    );
    final recommendedLevel = _recommendedLevel(recentAverage);
    final recommendations = shadowingPassages
        .where((passage) => passage.level == recommendedLevel)
        .take(3)
        .toList(growable: false);
    final milestone = _nextMilestone(widget.history.totalSessions);

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('训练计划')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          children: [
            _PlanHero(
              practicedDays: practicedDays.length,
              weeklyGoal: _weeklyGoal,
              progress: goalProgress,
              onStart: widget.onStartTraining,
            ),
            const SizedBox(height: 16),
            _SectionTitle(
              title: '本周目标',
              trailing: PopupMenuButton<int>(
                initialValue: _weeklyGoal,
                onSelected: (value) => setState(() => _weeklyGoal = value),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 3, child: Text('每周 3 天')),
                  PopupMenuItem(value: 5, child: Text('每周 5 天')),
                  PopupMenuItem(value: 7, child: Text('每天训练')),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('调整', style: TextStyle(color: PhoenixTheme.red)),
                    Icon(Icons.expand_more_rounded, color: PhoenixTheme.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _WeekCalendar(
              weekStart: weekStart,
              practicedDays: practicedDays,
              today: DateTime(now.year, now.month, now.day),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricCard(
                  icon: Icons.equalizer_rounded,
                  label: '近期均分',
                  value: '$recentAverage',
                ),
                const SizedBox(width: 10),
                _MetricCard(
                  icon: Icons.local_fire_department_rounded,
                  label: '连续天数',
                  value: '${widget.history.currentStreak}',
                ),
                const SizedBox(width: 10),
                _MetricCard(
                  icon: Icons.healing_rounded,
                  label: '待复练',
                  value: '${widget.weaknesses.pendingCount}',
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _SectionTitle(title: '今日重点'),
            const SizedBox(height: 10),
            _FocusCard(
              metric: primaryMetric.key,
              count: primaryMetric.value,
              recentAverage: recentAverage,
              onOpenWeakness: widget.onOpenWeakness,
            ),
            const SizedBox(height: 18),
            const _SectionTitle(title: '弱项分布'),
            const SizedBox(height: 10),
            _WeaknessDistribution(counts: metricCounts),
            const SizedBox(height: 18),
            _SectionTitle(
              title: '推荐素材 · L$recommendedLevel',
              trailing: TextButton(
                onPressed: widget.onOpenLibrary,
                child: const Text('查看全部'),
              ),
            ),
            const SizedBox(height: 8),
            if (recommendations.isEmpty)
              const _SimpleCard(
                icon: Icons.menu_book_rounded,
                title: '素材正在整理',
                subtitle: '可以先进入自由选文，选择任意等级开始训练。',
              )
            else
              ...recommendations.map(
                (passage) => _RecommendationCard(
                  title: passage.title,
                  level: passage.level,
                  theme: passage.theme,
                  sentences: passage.sentences.length,
                  minutes: passage.estimatedMinutes,
                  onTap: widget.onOpenLibrary,
                ),
              ),
            const SizedBox(height: 18),
            const _SectionTitle(title: '近期趋势'),
            const SizedBox(height: 10),
            _ScoreTrend(sessions: recentFive.reversed.toList(growable: false)),
            const SizedBox(height: 18),
            const _SectionTitle(title: '下一个里程碑'),
            const SizedBox(height: 10),
            _MilestoneCard(
              title: milestone.$1,
              subtitle: milestone.$2,
              progress: milestone.$3,
            ),
            const SizedBox(height: 18),
            const _SectionTitle(title: '快捷入口'),
            const SizedBox(height: 10),
            Row(
              children: [
                _QuickAction(
                  icon: Icons.play_arrow_rounded,
                  label: '开始训练',
                  onTap: widget.onStartTraining,
                ),
                const SizedBox(width: 10),
                _QuickAction(
                  icon: Icons.healing_rounded,
                  label: '弱项复练',
                  onTap: widget.onOpenWeakness,
                ),
                const SizedBox(width: 10),
                _QuickAction(
                  icon: Icons.insights_rounded,
                  label: '历史进步',
                  onTap: widget.onOpenProgress,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _recommendedLevel(int average) {
    if (average == 0) return 1;
    if (average >= 90) return 8;
    if (average >= 85) return 7;
    if (average >= 80) return 6;
    if (average >= 75) return 5;
    if (average >= 70) return 4;
    if (average >= 60) return 3;
    return 2;
  }

  (String, String, double) _nextMilestone(int totalSessions) {
    const milestones = [5, 10, 20, 50, 100];
    final next = milestones.firstWhere(
      (value) => value > totalSessions,
      orElse: () => 150,
    );
    final previous = milestones.reversed.firstWhere(
      (value) => value <= totalSessions,
      orElse: () => 0,
    );
    final range = next - previous;
    final progress = range == 0
        ? 1.0
        : ((totalSessions - previous) / range).clamp(0.0, 1.0);
    return (
      '完成 $next 次训练',
      '还差 ${next - totalSessions} 次，解锁新的训练里程碑。',
      progress,
    );
  }
}

class _PlanHero extends StatelessWidget {
  const _PlanHero({
    required this.practicedDays,
    required this.weeklyGoal,
    required this.progress,
    required this.onStart,
  });

  final int practicedDays;
  final int weeklyGoal;
  final double progress;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            '本周训练航线',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '已完成 $practicedDays / $weeklyGoal 天',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .86),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: .18),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD879)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFD879),
                foregroundColor: const Color(0xFF542010),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                '开始今天的训练',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar({
    required this.weekStart,
    required this.practicedDays,
    required this.today,
  });

  final DateTime weekStart;
  final Set<DateTime> practicedDays;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      children: List.generate(7, (index) {
        final day = weekStart.add(Duration(days: index));
        final practiced = practicedDays.contains(day);
        final isToday = day == today;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 6 ? 0 : 7),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: practiced
                    ? const Color(0xFFFFE7BE)
                    : Colors.white.withValues(alpha: .84),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isToday
                      ? PhoenixTheme.red
                      : Colors.black.withValues(alpha: .04),
                ),
              ),
              child: Column(
                children: [
                  Text(labels[index],
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Icon(
                    practiced
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: practiced ? PhoenixTheme.red : Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
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
            Icon(icon, color: PhoenixTheme.red, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
    required this.metric,
    required this.count,
    required this.recentAverage,
    required this.onOpenWeakness,
  });

  final String metric;
  final int count;
  final int recentAverage;
  final Future<void> Function() onOpenWeakness;

  @override
  Widget build(BuildContext context) {
    final noWeakness = count == 0;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .14)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7BE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              noWeakness ? Icons.auto_awesome_rounded : Icons.track_changes_rounded,
              color: PhoenixTheme.red,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noWeakness ? '提升自然语速' : '优先修正$metric',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  noWeakness
                      ? '近期均分 $recentAverage，今天重点保持节奏与连贯。'
                      : '当前有 $count 个相关弱项，建议先慢速复练再回到原速。',
                  style: const TextStyle(color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
          if (!noWeakness)
            IconButton(
              onPressed: onOpenWeakness,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
        ],
      ),
    );
  }
}

class _WeaknessDistribution extends StatelessWidget {
  const _WeaknessDistribution({required this.counts});

  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final max = counts.values.fold<int>(1, (best, value) => value > best ? value : best);
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: counts.entries.map((entry) {
          final progress = entry.value / max;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  child: Text(entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: Colors.black.withValues(alpha: .06),
                      valueColor:
                          const AlwaysStoppedAnimation(PhoenixTheme.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text('${entry.value}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.level,
    required this.theme,
    required this.sentences,
    required this.minutes,
    required this.onTap,
  });

  final String title;
  final int level;
  final String theme;
  final int sentences;
  final int minutes;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: .84),
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFE7BE),
          foregroundColor: PhoenixTheme.red,
          child: Text('L$level', style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('$theme · $sentences 句 · 约 $minutes 分钟'),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _ScoreTrend extends StatelessWidget {
  const _ScoreTrend({required this.sessions});

  final List<ShadowingSession> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _SimpleCard(
        icon: Icons.show_chart_rounded,
        title: '还没有趋势数据',
        subtitle: '完成训练后，这里会显示最近五次成绩。',
      );
    }
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: sessions.map((session) {
          final height = 30.0 + session.score.clamp(0, 100) * .72;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${session.score}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      )),
                  const SizedBox(height: 5),
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: PhoenixTheme.red.withValues(alpha: .78),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded,
              color: Color(0xFFB7791F), size: 36),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.black54, height: 1.4)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.black.withValues(alpha: .06),
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFFB7791F)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: PhoenixTheme.red),
                const SizedBox(height: 7),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  const _SimpleCard({
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
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
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
