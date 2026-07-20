import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class JourneyProgressHeader extends StatelessWidget {
  const JourneyProgressHeader({
    required this.currentStep,
    required this.furthestStep,
    required this.isCompleted,
    required this.labels,
    required this.onStepSelected,
    super.key,
  });

  final int currentStep;
  final int furthestStep;
  final bool isCompleted;
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
        onTap: isCompleted
            ? () => _showSteps(context)
            : () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('请按顺序完成课程；全部完成后可自由选择页面。'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },
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
                    isCompleted
                        ? '课程已完成 · 可自由选择'
                        : currentStep == labels.length - 1
                            ? '完成最后一步'
                            : '下一步 $nextLabel',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    isCompleted ? Icons.expand_more : Icons.lock_outline,
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
              Text(
                isCompleted ? '选择学习步骤 · 课程已完成' : '请按顺序完成课程',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              ...labels.asMap().entries.map((entry) {
                final index = entry.key;
                final enabled = isCompleted;
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
