import 'package:flutter/material.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';

class ShadowingProfileScreen extends StatelessWidget {
  const ShadowingProfileScreen({
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
    final recent = history.recentSessions.take(10).toList(growable: false);
    final average = recent.isEmpty
        ? 0
        : (recent.fold<int>(0, (sum, item) => sum + item.score) / recent.length)
            .round();
    final counts = weaknesses.pendingMetricCounts;
    final pending = weaknesses.items.where((item) => !item.mastered).toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
    final strongest = _strongestMetric(counts);
    final weakest = _weakestMetric(counts);
    final focusCharacters = <String>[];
    for (final item in pending) {
      for (final token in item.focusCharacters.split(' · ')) {
        final value = token.trim();
        if (value.isNotEmpty && !focusCharacters.contains(value)) {
          focusCharacters.add(value);
        }
        if (focusCharacters.length >= 10) break;
      }
      if (focusCharacters.length >= 10) break;
    }

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('个人发音档案')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          children: [
            _ProfileHero(
              average: average,
              totalSessions: history.totalSessions,
              strongest: strongest,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricTile(label: '累计训练', value: '${history.totalSessions}'),
                const SizedBox(width: 10),
                _MetricTile(label: '待修复', value: '${weaknesses.pendingCount}'),
                const SizedBox(width: 10),
                _MetricTile(label: '已掌握', value: '${weaknesses.masteredCount}'),
              ],
            ),
            const SizedBox(height: 18),
            const _SectionTitle('三维能力档案'),
            const SizedBox(height: 10),
            _AbilityPanel(counts: counts),
            const SizedBox(height: 18),
            const _SectionTitle('当前诊断'),
            const SizedBox(height: 10),
            _DiagnosisCard(
              weakest: weakest,
              pending: weaknesses.pendingCount,
              average: average,
            ),
            const SizedBox(height: 18),
            const _SectionTitle('常错字与重点音'),
            const SizedBox(height: 10),
            _FocusCharacters(characters: focusCharacters),
            const SizedBox(height: 18),
            const _SectionTitle('高优先级弱项'),
            const SizedBox(height: 10),
            if (pending.isEmpty)
              const _EmptyCard(
                icon: Icons.check_circle_rounded,
                title: '当前没有待修复弱项',
                subtitle: '继续训练，系统会持续更新你的个人发音档案。',
              )
            else
              ...pending.take(5).map(
                    (item) => _WeaknessCard(
                      title: item.passageTitle,
                      sentence: item.sentence,
                      metric: item.weakestMetric,
                      score: item.lastScore,
                      issueSummary: item.issueSummary,
                    ),
                  ),
            const SizedBox(height: 18),
            const _SectionTitle('改善建议'),
            const SizedBox(height: 10),
            _AdviceCard(metric: weakest, pending: weaknesses.pendingCount),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: weaknesses.pendingCount > 0
                  ? onOpenWeakness
                  : onStartTraining,
              icon: Icon(
                weaknesses.pendingCount > 0
                    ? Icons.healing_rounded
                    : Icons.play_arrow_rounded,
              ),
              label: Text(
                weaknesses.pendingCount > 0 ? '开始针对性复练' : '开始一次新训练',
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _weakestMetric(Map<String, int> counts) {
    var result = '准确度';
    var max = -1;
    for (final entry in counts.entries) {
      if (entry.value > max) {
        result = entry.key;
        max = entry.value;
      }
    }
    return result;
  }

  static String _strongestMetric(Map<String, int> counts) {
    var result = '流利度';
    var min = 1 << 30;
    for (final entry in counts.entries) {
      if (entry.value < min) {
        result = entry.key;
        min = entry.value;
      }
    }
    return result;
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.average,
    required this.totalSessions,
    required this.strongest,
  });

  final int average;
  final int totalSessions;
  final String strongest;

  @override
  Widget build(BuildContext context) {
    final title = totalSessions == 0
        ? '等待建立发音基线'
        : average >= 85
            ? '声音表现稳定'
            : average >= 70
                ? '正在进入稳定区间'
                : '基础能力正在形成';
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
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD879),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$average',
              style: const TextStyle(
                color: Color(0xFF542010),
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalSessions == 0
                      ? '完成第一次训练后生成长期能力画像。'
                      : '当前相对优势：$strongest · 基于最近 10 次训练',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .84),
                    height: 1.4,
                    fontWeight: FontWeight.w600,
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

class _AbilityPanel extends StatelessWidget {
  const _AbilityPanel({required this.counts});
  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final max = counts.values.fold<int>(1, (a, b) => b > a ? b : a);
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: counts.entries.map((entry) {
          final strength = 1 - (entry.value / (max + 1));
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: strength.clamp(0.08, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.black.withValues(alpha: .06),
                      valueColor:
                          const AlwaysStoppedAnimation(PhoenixTheme.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${entry.value} 项',
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({
    required this.weakest,
    required this.pending,
    required this.average,
  });
  final String weakest;
  final int pending;
  final int average;

  @override
  Widget build(BuildContext context) {
    return _EmptyCard(
      icon: pending == 0 ? Icons.auto_awesome_rounded : Icons.biotech_rounded,
      title: pending == 0 ? '当前能力较均衡' : '$weakest是当前主要突破口',
      subtitle: pending == 0
          ? '继续保持原速训练，重点提升自然表达。'
          : '近期均分 $average，共有 $pending 个待修复弱项。建议先慢速拆句，再恢复完整语速。',
    );
  }
}

class _FocusCharacters extends StatelessWidget {
  const _FocusCharacters({required this.characters});
  final List<String> characters;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const _EmptyCard(
        icon: Icons.text_fields_rounded,
        title: '暂未发现稳定常错字',
        subtitle: '完成更多训练后，这里会自动聚合需要重点纠正的字音。',
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 9,
        runSpacing: 9,
        children: characters
            .map(
              (character) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .88),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  character,
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _WeaknessCard extends StatelessWidget {
  const _WeaknessCard({
    required this.title,
    required this.sentence,
    required this.metric,
    required this.score,
    required this.issueSummary,
  });
  final String title;
  final String sentence;
  final String metric;
  final int score;
  final String issueSummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: .85),
      margin: const EdgeInsets.only(bottom: 9),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('《$title》 · $metric',
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
                Text('$score 分',
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontWeight: FontWeight.w900,
                    )),
              ],
            ),
            const SizedBox(height: 7),
            Text(sentence, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 6),
            Text(issueSummary,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard({required this.metric, required this.pending});
  final String metric;
  final int pending;

  @override
  Widget build(BuildContext context) {
    final advice = pending == 0
        ? '使用 1.0× 原速连续跟读，逐步提升自然停顿与语气。'
        : switch (metric) {
            '准确度' => '先逐字听辨，再用 0.7× 慢速复练，最后恢复完整句。',
            '完整度' => '按短语分段朗读，确保句首、句尾与虚词不漏读。',
            '流利度' => '先听节奏，再使用 0.9× 连续跟读，减少停顿与回读。',
            _ => '先慢速拆句，再恢复完整语速进行连续跟读。',
          };
    return _EmptyCard(
      icon: Icons.lightbulb_rounded,
      title: pending == 0 ? '进入自然表达训练' : '$metric专项方案',
      subtitle: advice,
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
          color: Colors.white.withValues(alpha: .85),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      );
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
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .85),
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
