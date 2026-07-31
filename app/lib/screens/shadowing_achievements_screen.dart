import 'package:flutter/material.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

class ShadowingAchievementsScreen extends StatelessWidget {
  const ShadowingAchievementsScreen({
    super.key,
    required this.history,
    required this.weaknesses,
    required this.onStartTraining,
  });

  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    final sessions = history.recentSessions;
    final recent = sessions.take(10).toList(growable: false);
    final average = recent.isEmpty
        ? 0
        : (recent.fold<int>(0, (sum, item) => sum + item.score) / recent.length)
            .round();
    final bestScore = sessions.isEmpty
        ? 0
        : sessions.fold<int>(0, (best, item) => item.score > best ? item.score : best);
    final level = _growthLevel(history.totalSessions, average);
    final levelProgress = _levelProgress(history.totalSessions);
    final badges = _buildBadges(
      totalSessions: history.totalSessions,
      currentStreak: history.currentStreak,
      bestStreak: history.bestStreak,
      bestScore: bestScore,
      average: average,
      masteredWeaknesses: weaknesses.masteredCount,
    );
    final unlocked = badges.where((badge) => badge.unlocked).length;
    final nextBadge = badges.cast<_AchievementBadge?>().firstWhere(
          (badge) => badge != null && !badge.unlocked,
          orElse: () => null,
        );

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('成就与成长')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          children: [
            _GrowthHero(
              level: level,
              progress: levelProgress,
              unlocked: unlocked,
              total: badges.length,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricTile(label: '训练次数', value: '${history.totalSessions}'),
                const SizedBox(width: 10),
                _MetricTile(label: '最高分', value: '$bestScore'),
                const SizedBox(width: 10),
                _MetricTile(label: '已修复', value: '${weaknesses.masteredCount}'),
              ],
            ),
            const SizedBox(height: 18),
            const _SectionTitle('能力称号'),
            const SizedBox(height: 10),
            _AbilityTitleCard(
              title: _abilityTitle(average, bestScore),
              subtitle: _abilitySubtitle(average, weaknesses.pendingCount),
              icon: _abilityIcon(average),
            ),
            const SizedBox(height: 18),
            const _SectionTitle('成就徽章'),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (_, index) => _BadgeCard(badge: badges[index]),
            ),
            const SizedBox(height: 18),
            const _SectionTitle('连续训练轨迹'),
            const SizedBox(height: 10),
            _StreakCard(
              currentStreak: history.currentStreak,
              bestStreak: history.bestStreak,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('弱项修复进度'),
            const SizedBox(height: 10),
            _RecoveryCard(
              mastered: weaknesses.masteredCount,
              pending: weaknesses.pendingCount,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('下一目标'),
            const SizedBox(height: 10),
            _NextGoalCard(
              badge: nextBadge,
              onStartTraining: onStartTraining,
            ),
          ],
        ),
      ),
    );
  }

  static String _growthLevel(int sessions, int average) {
    if (sessions >= 100 && average >= 85) return '声音领航者';
    if (sessions >= 50) return '流利探索家';
    if (sessions >= 20) return '节奏修炼者';
    if (sessions >= 5) return '跟读旅行者';
    return '声音启程者';
  }

  static double _levelProgress(int sessions) {
    const levels = [0, 5, 20, 50, 100, 150];
    var previous = 0;
    var next = 5;
    for (var index = 1; index < levels.length; index++) {
      if (sessions < levels[index]) {
        previous = levels[index - 1];
        next = levels[index];
        break;
      }
      previous = levels[index];
      next = levels[index] + 50;
    }
    return ((sessions - previous) / (next - previous)).clamp(0.0, 1.0);
  }

  static String _abilityTitle(int average, int bestScore) {
    if (bestScore >= 95 && average >= 88) return '自然表达者';
    if (average >= 82) return '稳定发音者';
    if (average >= 72) return '节奏进阶者';
    if (average > 0) return '声音练习者';
    return '等待第一声';
  }

  static String _abilitySubtitle(int average, int pending) {
    if (average == 0) return '完成第一次跟读后，系统会生成你的能力称号。';
    if (pending == 0) return '当前弱项已清空，可以继续挑战更自然的语速。';
    return '近期均分 $average，仍有 $pending 个弱项等待修复。';
  }

  static IconData _abilityIcon(int average) {
    if (average >= 88) return Icons.graphic_eq_rounded;
    if (average >= 75) return Icons.record_voice_over_rounded;
    return Icons.mic_rounded;
  }

  static List<_AchievementBadge> _buildBadges({
    required int totalSessions,
    required int currentStreak,
    required int bestStreak,
    required int bestScore,
    required int average,
    required int masteredWeaknesses,
  }) {
    return [
      _AchievementBadge(
        icon: Icons.flag_rounded,
        title: '第一声',
        description: '完成首次跟读',
        unlocked: totalSessions >= 1,
        progress: totalSessions.clamp(0, 1).toDouble(),
      ),
      _AchievementBadge(
        icon: Icons.repeat_rounded,
        title: '渐入佳境',
        description: '累计训练 10 次',
        unlocked: totalSessions >= 10,
        progress: (totalSessions / 10).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.local_fire_department_rounded,
        title: '三日火种',
        description: '连续训练 3 天',
        unlocked: bestStreak >= 3,
        progress: (bestStreak / 3).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.bolt_rounded,
        title: '七日节奏',
        description: '连续训练 7 天',
        unlocked: bestStreak >= 7,
        progress: (bestStreak / 7).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.stars_rounded,
        title: '高分一刻',
        description: '单次达到 90 分',
        unlocked: bestScore >= 90,
        progress: (bestScore / 90).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.auto_graph_rounded,
        title: '稳定输出',
        description: '近期均分达到 85',
        unlocked: average >= 85,
        progress: (average / 85).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.healing_rounded,
        title: '修音匠人',
        description: '修复 5 个弱项',
        unlocked: masteredWeaknesses >= 5,
        progress: (masteredWeaknesses / 5).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.workspace_premium_rounded,
        title: '百炼之声',
        description: '累计训练 100 次',
        unlocked: totalSessions >= 100,
        progress: (totalSessions / 100).clamp(0.0, 1.0),
      ),
      _AchievementBadge(
        icon: Icons.whatshot_rounded,
        title: '今日不断线',
        description: '保持当前连续训练',
        unlocked: currentStreak >= 1,
        progress: currentStreak >= 1 ? 1 : 0,
      ),
    ];
  }
}

class _AchievementBadge {
  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.progress,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;
  final double progress;
}

class _GrowthHero extends StatelessWidget {
  const _GrowthHero({
    required this.level,
    required this.progress,
    required this.unlocked,
    required this.total,
  });

  final String level;
  final double progress;
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
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
          const Icon(Icons.emoji_events_rounded,
              color: Color(0xFFFFD879), size: 40),
          const SizedBox(height: 12),
          Text(
            level,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '已解锁 $unlocked / $total 枚徽章',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .85),
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

class _AbilityTitleCard extends StatelessWidget {
  const _AbilityTitleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
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
            child: Icon(icon, color: PhoenixTheme.red),
          ),
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

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge});
  final _AchievementBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: badge.unlocked
            ? const Color(0xFFFFF4D8)
            : Colors.white.withValues(alpha: .74),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: badge.unlocked
              ? PhoenixTheme.red.withValues(alpha: .14)
              : Colors.black.withValues(alpha: .04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                badge.icon,
                color: badge.unlocked ? PhoenixTheme.red : Colors.black26,
              ),
              const Spacer(),
              Icon(
                badge.unlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
                size: 18,
                color: badge.unlocked ? PhoenixTheme.red : Colors.black26,
              ),
            ],
          ),
          const Spacer(),
          Text(badge.title,
              style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(
            badge.description,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: badge.progress,
              minHeight: 6,
              backgroundColor: Colors.black.withValues(alpha: .06),
              valueColor: AlwaysStoppedAnimation(
                badge.unlocked ? PhoenixTheme.red : Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.currentStreak, required this.bestStreak});
  final int currentStreak;
  final int bestStreak;

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
          const Icon(Icons.local_fire_department_rounded,
              color: PhoenixTheme.red, size: 40),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('当前连续 $currentStreak 天',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('历史最佳 $bestStreak 天，继续保持今天不断线。',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  const _RecoveryCard({required this.mastered, required this.pending});
  final int mastered;
  final int pending;

  @override
  Widget build(BuildContext context) {
    final total = mastered + pending;
    final progress = total == 0 ? 0.0 : mastered / total;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('已修复 $mastered · 待复练 $pending',
              style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.black.withValues(alpha: .06),
              valueColor: const AlwaysStoppedAnimation(PhoenixTheme.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextGoalCard extends StatelessWidget {
  const _NextGoalCard({required this.badge, required this.onStartTraining});
  final _AchievementBadge? badge;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    final target = badge;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            target == null ? '所有徽章已解锁' : target.title,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            target == null ? '继续训练，保持你的声音状态。' : target.description,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 13),
          FilledButton.icon(
            onPressed: onStartTraining,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('继续训练'),
          ),
        ],
      ),
    );
  }
}
