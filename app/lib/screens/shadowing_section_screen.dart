import 'package:flutter/material.dart';

import '../data/shadowing_passage_catalog.dart';
import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

enum ShadowingSection { daily, weakness, library, progress }
enum _LibrarySort { level, shortest, bestScore }

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
                  weaknesses: weaknesses,
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
          '按你的等级、历史成绩与薄弱点，安排今天最值得练的内容。',
        ),
      ShadowingSection.weakness => (
          Icons.healing_rounded,
          '把错读、漏读和不流畅的句子逐个练熟。',
        ),
      ShadowingSection.library => (
          Icons.menu_book_rounded,
          '搜索、筛选并预览训练素材，再选择适合今天的一篇。',
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
  const _DailyBody({
    required this.history,
    required this.weaknesses,
    required this.onStartTraining,
  });

  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;

  @override
  Widget build(BuildContext context) {
    final recent = history.recentSessions.take(5).toList(growable: false);
    final average = recent.isEmpty
        ? 0
        : (recent.fold<int>(0, (sum, item) => sum + item.score) / recent.length)
            .round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _MetricTile(label: '近期均分', value: '$average'),
            const SizedBox(width: 10),
            _MetricTile(label: '连续天数', value: '${history.currentStreak}'),
            const SizedBox(width: 10),
            _MetricTile(label: '待复练', value: '${weaknesses.pendingCount}'),
          ],
        ),
        const SizedBox(height: 14),
        _InfoCard(
          icon: Icons.route_rounded,
          title: history.totalSessions == 0 ? '从第一次训练开始' : '继续今天的训练路线',
          subtitle: history.totalSessions == 0
              ? '系统会先建立你的发音基线，再逐步调整难度。'
              : weaknesses.pendingCount > 0
                  ? '今天会优先穿插 ${weaknesses.pendingCount} 个待修正弱项。'
                  : '目前没有待复练弱项，今天重点提升连贯度与自然语速。',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onStartTraining,
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(history.totalSessions == 0 ? '开始第一次训练' : '继续今日训练'),
        ),
      ],
    );
  }
}

class _WeaknessBody extends StatefulWidget {
  const _WeaknessBody({required this.weaknesses, required this.onStartTraining});

  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartTraining;

  @override
  State<_WeaknessBody> createState() => _WeaknessBodyState();
}

class _WeaknessBodyState extends State<_WeaknessBody> {
  String? _metric;

  @override
  Widget build(BuildContext context) {
    final all = widget.weaknesses.dailyQueue();
    if (all.isEmpty) {
      return _EmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: '暂时没有待复练句子',
        subtitle: '完成一次跟读后，系统会自动收集最需要修正的句子。',
        buttonLabel: '开始一次跟读',
        onPressed: widget.onStartTraining,
      );
    }

    final metrics = all.map((item) => item.weakestMetric).toSet().toList();
    final queue = all
        .where((item) => _metric == null || item.weakestMetric == _metric)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: Text('全部 ${all.length}'),
              selected: _metric == null,
              onSelected: (_) => setState(() => _metric = null),
            ),
            ...metrics.map(
              (metric) => ChoiceChip(
                label: Text(metric),
                selected: _metric == metric,
                onSelected: (_) => setState(() => _metric = metric),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...queue.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .84),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: item.lastScore < 60
                    ? PhoenixTheme.red.withValues(alpha: .22)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '《${item.passageTitle}》 · ${item.weakestMetric}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    _ScoreBadge(score: item.lastScore),
                  ],
                ),
                const SizedBox(height: 7),
                Text(item.sentence, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 7),
                Text(
                  item.issueSummary,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: widget.onStartTraining,
          icon: const Icon(Icons.replay_rounded),
          label: Text('进入弱项训练 · ${queue.length} 句'),
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
  String _query = '';
  _LibrarySort _sort = _LibrarySort.level;

  ShadowingPassage? get _selectedPassage {
    for (final passage in shadowingPassages) {
      if (passage.id == _selectedPassageId) return passage;
    }
    return null;
  }

  Map<String, int> get _bestScores {
    final scores = <String, int>{};
    for (final session in widget.history.recentSessions) {
      final previous = scores[session.passageId] ?? 0;
      if (session.score > previous) scores[session.passageId] = session.score;
    }
    return scores;
  }

  @override
  Widget build(BuildContext context) {
    final bestScores = _bestScores;
    final normalizedQuery = _query.trim().toLowerCase();
    final passages = shadowingPassages.where((passage) {
      final levelMatches =
          _selectedLevel == null || passage.level == _selectedLevel;
      final queryMatches = normalizedQuery.isEmpty ||
          passage.title.toLowerCase().contains(normalizedQuery) ||
          passage.theme.toLowerCase().contains(normalizedQuery) ||
          passage.text.toLowerCase().contains(normalizedQuery);
      return levelMatches && queryMatches;
    }).toList(growable: false)
      ..sort((left, right) {
        return switch (_sort) {
          _LibrarySort.level => left.level.compareTo(right.level),
          _LibrarySort.shortest =>
            left.characterCount.compareTo(right.characterCount),
          _LibrarySort.bestScore =>
            (bestScores[right.id] ?? -1).compareTo(bestScores[left.id] ?? -1),
        };
      });
    final selectedPassage = _selectedPassage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey('shadowing-library-search'),
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: '搜索标题、主题或句子',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white.withValues(alpha: .86),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '找到 ${passages.length} 篇',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            DropdownButton<_LibrarySort>(
              value: _sort,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(
                  value: _LibrarySort.level,
                  child: Text('按等级'),
                ),
                DropdownMenuItem(
                  value: _LibrarySort.shortest,
                  child: Text('最短优先'),
                ),
                DropdownMenuItem(
                  value: _LibrarySort.bestScore,
                  child: Text('最高分优先'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (passages.isEmpty)
          const _EmptyState(
            icon: Icons.search_off_rounded,
            title: '没有找到匹配内容',
            subtitle: '试试清除关键词，或切换到其他等级。',
          )
        else
          ...passages.map((passage) {
            final selected = _selectedPassageId == passage.id;
            final bestScore = bestScores[passage.id];
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
                          _ScoreBadge(score: bestScore)
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
            bestScore: bestScores[selectedPassage.id],
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
              if (bestScore != null) _ScoreBadge(score: bestScore),
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

class _ProgressBody extends StatelessWidget {
  const _ProgressBody({required this.history});

  final ShadowingTrainingHistory history;

  @override
  Widget build(BuildContext context) {
    final sessions = history.recentSessions;
    final recent = sessions.take(5).toList(growable: false);
    final average = recent.isEmpty
        ? 0
        : (recent.fold<int>(0, (sum, item) => sum + item.score) / recent.length)
            .round();
    final trend = recent.length < 2 ? 0 : recent.first.score - recent.last.score;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _MetricTile(label: '训练次数', value: '${history.totalSessions}'),
            const SizedBox(width: 10),
            _MetricTile(label: '近期均分', value: '$average'),
            const SizedBox(width: 10),
            _MetricTile(label: '最佳连续', value: '${history.bestStreak}'),
          ],
        ),
        const SizedBox(height: 14),
        if (sessions.isNotEmpty)
          _InfoCard(
            icon: trend >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            title: trend == 0
                ? '近期成绩保持稳定'
                : trend > 0
                    ? '近期提升 $trend 分'
                    : '近期波动 ${trend.abs()} 分',
            subtitle: trend >= 0
                ? '继续保持当前节奏，系统会逐步提高训练难度。'
                : '建议先回到弱项复练，稳定准确度后再提升语速。',
          ),
        if (sessions.isNotEmpty) const SizedBox(height: 14),
        if (sessions.isEmpty)
          const _EmptyState(
            icon: Icons.insights_rounded,
            title: '还没有训练记录',
            subtitle: '完成第一篇短文后，这里会出现成绩与进步轨迹。',
          )
        else
          ...sessions.take(20).map(
            (session) => Card(
              elevation: 0,
              color: Colors.white.withValues(alpha: .84),
              margin: const EdgeInsets.only(bottom: 9),
              child: ExpansionTile(
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
                  '${session.completedAt.year}年${session.completedAt.month}月${session.completedAt.day}日',
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 17),
                      const SizedBox(width: 7),
                      Text(
                        '${session.completedAt.hour.toString().padLeft(2, '0')}:${session.completedAt.minute.toString().padLeft(2, '0')}',
                      ),
                      const Spacer(),
                      if (session.dailyRecommendationLevel != null)
                        Text('当日推荐 L${session.dailyRecommendationLevel}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
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

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: PhoenixTheme.red.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        '$score 分',
        style: const TextStyle(
          color: PhoenixTheme.red,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
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
