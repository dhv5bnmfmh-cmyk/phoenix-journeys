import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class JourneyProgressHeader extends StatelessWidget {
  const JourneyProgressHeader({
    required this.currentStep,
    required this.furthestStep,
    required this.labels,
    required this.onStepSelected,
    super.key,
  });

  final int currentStep;
  final int furthestStep;
  final List<String> labels;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / labels.length;
    final nextLabel = currentStep < labels.length - 1
        ? labels[currentStep + 1]
        : '旅程完成';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .34)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PhoenixTheme.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${currentStep + 1}',
                  style: const TextStyle(
                    color: Colors.white,
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
                      labels[currentStep],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentStep == labels.length - 1
                          ? '所有步骤已完成'
                          : '下一站：$nextLabel',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.cloud_done_outlined, color: PhoenixTheme.red),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              color: PhoenixTheme.red,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: labels.asMap().entries.map((entry) {
                final index = entry.key;
                final enabled = index <= furthestStep;
                final selected = index == currentStep;

                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    selected: selected,
                    onSelected: enabled ? (_) => onStepSelected(index) : null,
                    avatar: Icon(
                      index < currentStep
                          ? Icons.check_circle
                          : enabled
                              ? Icons.circle_outlined
                              : Icons.lock_outline,
                      size: 17,
                      color: selected || index < currentStep
                          ? PhoenixTheme.red
                          : Colors.black38,
                    ),
                    label: Text(entry.value),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '进度与草稿会自动保存在这台设备上。',
            style: TextStyle(color: Colors.black45, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
