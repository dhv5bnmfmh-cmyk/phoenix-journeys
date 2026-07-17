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
        : '已完成';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('journey-progress-strip'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSteps(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${currentStep + 1}/${labels.length}',
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      labels[currentStep],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    currentStep == labels.length - 1
                        ? '旅程完成'
                        : '下一步 $nextLabel',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.expand_more,
                    size: 17,
                    color: Colors.black38,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
                  color: PhoenixTheme.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSteps(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              const Text(
                '选择学习步骤',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              ...labels.asMap().entries.map((entry) {
                final index = entry.key;
                final enabled = index <= furthestStep;
                final selected = index == currentStep;

                return ListTile(
                  enabled: enabled,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    selected
                        ? Icons.radio_button_checked
                        : index < currentStep
                            ? Icons.check_circle_outline
                            : enabled
                                ? Icons.circle_outlined
                                : Icons.lock_outline,
                    color: selected || index < currentStep
                        ? PhoenixTheme.red
                        : Colors.black38,
                  ),
                  title: Text(entry.value),
                  trailing: Text('${index + 1}/${labels.length}'),
                  onTap: enabled
                      ? () {
                          Navigator.of(sheetContext).pop();
                          onStepSelected(index);
                        }
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
