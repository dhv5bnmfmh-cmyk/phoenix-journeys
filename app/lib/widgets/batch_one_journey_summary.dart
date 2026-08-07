import 'package:flutter/material.dart';

import '../data/batch_one_adaptive_story_levels.dart';
import '../data/batch_one_journey_remediation.dart';
import '../theme/phoenix_theme.dart';

class BatchOneJourneySummary extends StatelessWidget {
  const BatchOneJourneySummary({
    super.key,
    required this.spec,
    required this.words,
    required this.challengeCompleted,
    required this.displayText,
    this.completion = false,
  });

  final BatchOneJourneyMemorySpec spec;
  final List<String> words;
  final bool challengeCompleted;
  final String Function(String) displayText;
  final bool completion;

  String t(String value) => displayText(value);

  IconData _reviewIcon(RemediatedMemoryReview review) => switch (review.category) {
        'protagonist' => Icons.person_outline_rounded,
        'events' => Icons.route_rounded,
        'history' => Icons.history_edu_rounded,
        'culture' => Icons.account_balance_outlined,
        'architecture' => Icons.foundation_rounded,
        'vocabulary' => Icons.menu_book_rounded,
        _ => Icons.bookmark_border_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final levelVocabulary =
        words.isEmpty ? '本级重点词已复习' : words.take(6).join(' · ');
    final challenge = challengeCompleted
        ? '短文复原 · 语病修复 · 补回句子：三种模式全部完成'
        : '三种 Challenge 的结果将在完成后自动记入本次旅程';

    final reviewRows = spec.reviews
        .map(
          (review) => (
            icon: _reviewIcon(review),
            label: review.prompt,
            value: review.category == 'vocabulary'
                ? '${review.answer}\n本级复习：$levelVocabulary'
                : review.answer,
          ),
        )
        .toList(growable: false);

    final rows = <({IconData icon, String label, String value})>[
      ...reviewRows,
      (
        icon: Icons.task_alt_rounded,
        label: 'Challenge 表现',
        value: challenge,
      ),
      (
        icon: Icons.bookmark_added_outlined,
        label: '长期记忆点',
        value: spec.longTermAnchor,
      ),
      if (completion)
        (
          icon: Icons.auto_awesome_rounded,
          label: '旅程结果',
          value: spec.storyResult,
        ),
      if (completion)
        (
          icon: Icons.verified_rounded,
          label: '旅程收束',
          value: spec.completionSummary,
        ),
      if (completion)
        (
          icon: Icons.explore_rounded,
          label: '继续探索',
          value: '把这个记忆锚点带进下一段 Journey，继续用中文观察、判断和表达。',
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth,
            child: Container(
              key: ValueKey(
                completion
                    ? 'batch-one-completion-summary'
                    : 'batch-one-memory-summary',
              ),
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
              decoration: PhoenixTheme.journeyWritingPanelDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t(completion ? '这段旅程留下了什么' : 'Phoenix 已为你整理这段旅程'),
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  for (var index = 0; index < rows.length; index++) ...[
                    _SummaryRow(
                      icon: rows[index].icon,
                      label: t(rows[index].label),
                      value: t(rows[index].value),
                    ),
                    if (index < rows.length - 1) const SizedBox(height: 5),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: PhoenixTheme.gold.withValues(alpha: .26),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: PhoenixTheme.red),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF332B26),
                    fontSize: 10.3,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
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
