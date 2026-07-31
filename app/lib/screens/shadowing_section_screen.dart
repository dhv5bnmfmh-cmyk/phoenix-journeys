import 'package:flutter/material.dart';

import '../data/shadowing_passage_catalog.dart';
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
                  history: history,
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

class _LibraryBody extends StatefulWidget {
  const _LibraryBody({required this.history, required this.onStartTraining});

  final ShadowingTrainingHistory history;
  final Future<void> Function() onStartTraining;

  @override
  State<_LibraryBody> createState() => _LibraryBodyState();
}

class _LibraryBodyState extends State<_LibraryBody> {
  int? _selectedLevel;
  String? _selectedPassageId;

  ShadowingPassage? get _selectedPassage {
    for (final passage in shadowingPassages) {
      if (passage.id == _selectedPassageId) return passage;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final passages = shadowingPassages
        .where(
          (passage) =>
              _selectedLevel == null || passage.level == _selectedLevel,
        )
        .toList(growable: false);
    final recentScores = <String, int>{};
    for (final session in widget.history.recentSessions) {
      final previous = recentScores[session.passageId] ?? 0;
      if (session.score > previous) recentScores[session.passageId] = session.score;
    }
    final selectedPassage = _selectedPassage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _LevelChip(
                label: '全部',
                selected: _selectedLevel == null,
                onTap: () => setState(() => _selectedLevel = null),
              ),
              for (var level = 1; level <= 10; level++)
                _LevelChip(
                  label: 'L$level',
                  selected: _selectedLevel == level,
                  onTap: () => setState(() => _selectedLevel = level),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...passages.map((passage) {
          final selected = _selectedPassageId == passage.id;
          final bestScore = recentScores[passage.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: selected
                  ? const Color(0xFFFFE7BE)
                  : Colors.white.withValues(alpha: .84),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => _selectedPassageId = passage.id),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PhoenixTheme.red.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'L${passage.level}',
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              passage.title,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${passage.theme} · ${passage.sentences.length} 句 · 约 ${passage.estimatedMinutes} 分钟',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (bestScore != null)
                        Text(
                          '$bestScore 分',
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      else
                        Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.chevron_right_rounded,
                          color: selected ? PhoenixTheme.red : Colors.black38,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (selectedPassage != null) ...[
          const SizedBox(height: 4),
          _PassagePreview(
            passage: selectedPassage,
            bestScore: recentScores[selectedPassage.id],
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          onPressed: selectedPassage == null ? null : widget.onStartTraining,
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(
            selectedPassage == null
                ? '先选择一篇内容'
                : '开始《${selectedPassage.title}》',
          ),
        ),
      ],
    );
  }
}

class _PassagePreview extends StatelessWidget {
  const _PassagePreview({required this.passage, this.bestScore});

  final ShadowingPassage passage;
  final int? bestScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('shadowing-library-preview'),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility_rounded, color: PhoenixTheme.red),
              const SizedBox(width: 8),
              const Text(
                '训练内容预览',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              if (bestScore != null)
                Text(
                  '最佳 $bestScore 分',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < passage.sentences.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE7BE),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      passage.sentences[index],
                      style: const TextStyle(height: 1.45),
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

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
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
              title: Text(
                session.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                '${session.completedAt.month}月${session.completedAt.day}日',
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
                Text(
                  subtitle,
                  style: const TextStyle(height: 1.4, color: Colors.black54),
                ),
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
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
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
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.45),
          ),
          if (buttonLabel != null && onPressed != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel!)),
          ],
        ],
      ),
    );
  }
}
