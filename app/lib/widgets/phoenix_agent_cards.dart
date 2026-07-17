import 'package:flutter/material.dart';

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
              _AgentStatusChip(isOffline: feedback.isOfflineFallback),
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

  @override
  Widget build(BuildContext context) {
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
              _AgentStatusChip(isOffline: feedback.isOfflineFallback),
            ],
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 12),
          _FeedbackSection(
            icon: Icons.local_fire_department_outlined,
            title: '给你的回应',
            text: feedback.encouragement,
            color: PhoenixTheme.translation,
          ),
        ],
      ),
    );
  }
}

class _AgentStatusChip extends StatelessWidget {
  const _AgentStatusChip({required this.isOffline});

  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOffline ? Colors.orange : Colors.green).withValues(alpha: .10),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isOffline ? '本地建议' : 'AI 在线',
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
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
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
