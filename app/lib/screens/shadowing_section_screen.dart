import 'package:flutter/material.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

enum ShadowingSection { daily, weakness, library, progress }

class ShadowingSectionScreen extends StatelessWidget {
  const ShadowingSectionScreen({
    super.key,
    required this.section,
    required this.history,
    required this.weaknesses,
    required this.onStartTraining,
  });

  final ShadowingSection section;
  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    final title = switch (section) {
      ShadowingSection.daily => '今日训练',
      ShadowingSection.weakness => '弱项复练',
      ShadowingSection.library => '自由选文',
      ShadowingSection.progress => '历史进步',
    };

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          children: [
            _SectionHero(section: section),
            const SizedBox(height: 18),
            switch (section) {
              ShadowingSection.daily => _DailyBody(
                  history: history,
                  onStartTraining: onStartTraining,
                ),
              ShadowingSection.weakness => _WeaknessBody(
                  weaknesses: weaknesses,
                  onStartTraining: onStartTraining,
                ),
              ShadowingSection.library => _LibraryBody(
                  onStartTraining: onStartTraining,
                ),
              ShadowingSection.progress => _ProgressBody(history: history),
            },
          ],
        ),
      ),
    );
  }
}

class _SectionHero extends StatelessWidget {
  const _SectionHero({required this.section});

  final ShadowingSection section;

  @override
  Widget build(BuildContext context) {
    final data = switch (section) {
      ShadowingSection.daily => (
          Icons.auto_awesome_rounded,
          '按你的等级与薄弱点，安排今天最值得练的内容。',
        ),
      ShadowingSection.weakness => (
          Icons.healing_rounded,
          '把错读、漏读和不流畅的句子逐个练熟。',
        ),
      ShadowingSection.library => (
          Icons.menu_book_rounded,
          '从短句到短文，按难度自由选择训练素材。',
        ),
      ShadowingSection.progress => (
          Icons.insights_rounded,
          '查看训练次数、连续天数和最近成绩变化。',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F1D1D), Color(0xFFB23A2A)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(data.$1, color: const Color(0xFFFFD879), size: 38),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              data.$2,
              style: const TextStyle(
                color: Colors.white,
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyBody extends StatelessWidget {
  const _DailyBody({required this.history, required this.onStartTraining});

  final ShadowingTrainingHistory history;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          icon: Icons.route_rounded,
          title: history.totalSessions == 0 ? '从第一次训练开始' : '继续今天的训练路线',
          subtitle: history.totalSessions == 0
              ? '系统会先建立你的发音基线，再逐步调整难度。'
              : '已累计 ${history.totalSessions} 次训练，当前连续 ${history.currentStreak} 天。',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onStartTraining,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('开始今日训练'),
        ),
      ],
    );
  }
}

class _WeaknessBody extends StatelessWidget {
  const _WeaknessBody({required this.weaknesses, required this.onStartTraining});

  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    final queue = weaknesses.dailyQueue();
    if (queue.isEmpty) {
      return _EmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: '暂时没有待复练句子',
        subtitle: '完成一次跟读后，系统会自动收集最需要修正的句子。',
        buttonLabel: '开始一次跟读',
        onPressed: onStartTraining,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...queue.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .84),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '《${item.passageTitle}》 · ${item.weakestMetric}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(item.sentence, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 6),
                Text(
                  '最近 ${item.lastScore} 分 · ${item.issueSummary}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: onStartTraining,
          icon: const Icon(Icons.replay_rounded),
          label: Text('开始复练 ${queue.length} 句'),
        ),
      ],
    );
  }
}

class _LibraryBody extends StatelessWidget {
  const _LibraryBody({required this.onStartTraining});

  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    const levels = [
      ('基础短句', '适合热身与纠正单句节奏', Icons.short_text_rounded),
      ('生活对话', '训练自然语速与常用表达', Icons.forum_rounded),
      ('短文跟读', '练习连贯表达与停顿', Icons.article_rounded),
    ];
    return Column(
      children: [
        ...levels.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _InfoCard(icon: item.$3, title: item.$1, subtitle: item.$2),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onStartTraining,
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('进入选文库'),
          ),
        ),
      ],
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody({required this.history});

  final ShadowingTrainingHistory history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _MetricTile(label: '训练次数', value: '${history.totalSessions}'),
            const SizedBox(width: 10),
            _MetricTile(label: '连续天数', value: '${history.currentStreak}'),
            const SizedBox(width: 10),
            _MetricTile(label: '最佳成绩', value: '${history.bestRecentScore}'),
          ],
        ),
        const SizedBox(height: 16),
        if (history.recentSessions.isEmpty)
          const _EmptyState(
            icon: Icons.insights_rounded,
            title: '还没有训练记录',
            subtitle: '完成第一篇短文后，这里会出现成绩与进步轨迹。',
          )
        else
          ...history.recentSessions.take(12).map(
            (session) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFE7BE),
                foregroundColor: PhoenixTheme.red,
                child: Text('${session.score}'),
              ),
              title: Text(session.title, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${session.completedAt.month}月${session.completedAt.day}日'),
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: PhoenixTheme.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(height: 1.4, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: PhoenixTheme.red),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(height: 1.45)),
          if (buttonLabel != null && onPressed != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel!)),
          ],
        ],
      ),
    );
  }
}
