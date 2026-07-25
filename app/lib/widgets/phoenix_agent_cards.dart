import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/phoenix_ai_service.dart';
import '../theme/phoenix_theme.dart';

class PhoenixGuideReplyCard extends StatelessWidget {
  const PhoenixGuideReplyCard({required this.feedback, super.key});

  final PhoenixGuideFeedback feedback;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('phoenix-guide-reply'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PhoenixTheme.ai.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PhoenixTheme.ai.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: PhoenixTheme.ai,
                child: Icon(
                  Icons.explore_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'PhoenixGuideAgent',
                  style: TextStyle(
                    color: PhoenixTheme.ai,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _AgentStatusChip(
                isOffline: feedback.isOfflineFallback,
                provider: feedback.provider,
                qualityReviewed: feedback.qualityReviewed,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.reply,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14.5,
              height: 1.62,
            ),
          ),
        ],
      ),
    );
  }
}

class PhoenixWritingFeedbackCard extends StatelessWidget {
  const PhoenixWritingFeedbackCard({required this.feedback, super.key});

  final PhoenixWritingFeedback feedback;

  Future<void> _copyText(
    BuildContext context,
    String text,
    String label,
  ) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text.trim()));
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label已复制。返回输入框继续改写，再提交一次。'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final hasScore = feedback.learnerScore > 0;
    return Container(
      key: const ValueKey('phoenix-writing-feedback'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .32)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 7),
            color: Color(0x0E000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: PhoenixTheme.translation,
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 19,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'PhoenixWritingAgent',
                  style: TextStyle(
                    color: PhoenixTheme.translation,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (hasScore) ...[
                Tooltip(
                  message: 'Phoenix 内部练习分，不是 HSK 或 TOCFL 考试成绩。',
                  child: Container(
                    key: const ValueKey('phoenix-learner-writing-score'),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: PhoenixTheme.red.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '完成度 ${feedback.learnerScore}',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
              _AgentStatusChip(
                isOffline: feedback.isOfflineFallback,
                provider: feedback.provider,
                qualityReviewed: feedback.qualityReviewed,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (feedback.originalText.trim().isNotEmpty) ...[
            _FeedbackSection(
              icon: Icons.notes_rounded,
              title: '你的原文',
              text: feedback.originalText,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
          ],
          if (feedback.understanding.trim().isNotEmpty) ...[
            _FeedbackSection(
              icon: Icons.psychology_alt_outlined,
              title: 'AI 理解到的意思',
              text: feedback.understanding,
              color: PhoenixTheme.ai,
            ),
            const SizedBox(height: 12),
          ],
          _FeedbackSection(
            icon: Icons.check_circle_outline,
            title: '修改后',
            text: feedback.corrected,
            color: PhoenixTheme.red,
          ),
          const SizedBox(height: 12),
          _FeedbackSection(
            icon: Icons.lightbulb_outline,
            title: '为什么这样改',
            text: feedback.explanation,
            color: PhoenixTheme.gold,
          ),
          const SizedBox(height: 12),
          _FeedbackSection(
            icon: Icons.record_voice_over_outlined,
            title: '更自然的表达',
            text: feedback.natural,
            color: PhoenixTheme.ai,
          ),
          if (feedback.abilityFocus.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _FeedbackSection(
              icon: Icons.center_focus_strong_outlined,
              title: '这次最值得提升的能力',
              text: feedback.abilityFocus,
              color: PhoenixTheme.translation,
            ),
          ],
          if (feedback.rewriteTask.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _FeedbackSection(
              icon: Icons.restart_alt_rounded,
              title: '下一轮改写任务',
              text: feedback.rewriteTask,
              color: PhoenixTheme.red,
            ),
          ],
          const SizedBox(height: 12),
          _FeedbackSection(
            icon: Icons.local_fire_department_outlined,
            title: '给你的回应',
            text: feedback.encouragement,
            color: PhoenixTheme.translation,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PhoenixTheme.gold.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PhoenixTheme.gold.withValues(alpha: .18),
              ),
            ),
            child: const Text(
              '复制一个版本作为起点，返回表达页按“下一轮改写任务”修改，再提交一次。Phoenix 会继续结合前一次建议批改。',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 11.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('copy-corrected-writing'),
                onPressed: feedback.corrected.trim().isEmpty
                    ? null
                    : () => _copyText(context, feedback.corrected, '修改版'),
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('复制修改版'),
              ),
              OutlinedButton.icon(
                key: const ValueKey('copy-natural-writing'),
                onPressed: feedback.natural.trim().isEmpty
                    ? null
                    : () => _copyText(context, feedback.natural, '自然表达'),
                icon: const Icon(Icons.content_copy_rounded, size: 16),
                label: const Text('复制自然版'),
              ),
              FilledButton.icon(
                key: const ValueKey('return-to-rewrite'),
                onPressed: () => Navigator.of(context).maybePop(),
                style: FilledButton.styleFrom(
                  backgroundColor: PhoenixTheme.red,
                ),
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: const Text('返回改写'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgentStatusChip extends StatelessWidget {
  const _AgentStatusChip({
    required this.isOffline,
    required this.provider,
    required this.qualityReviewed,
  });

  final bool isOffline;
  final String provider;
  final bool qualityReviewed;

  String get _label {
    if (isOffline) return '本地建议';
    if (provider == 'openai' && qualityReviewed) return 'GPT · 已复核';
    if (qualityReviewed) return 'AI · 已复核';
    return provider == 'openai' ? 'GPT 在线' : 'AI 在线';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('phoenix-agent-status-$provider-$qualityReviewed'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOffline ? Colors.orange : Colors.green).withValues(
          alpha: .10,
        ),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: isOffline ? Colors.orange.shade800 : Colors.green.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13.5,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
