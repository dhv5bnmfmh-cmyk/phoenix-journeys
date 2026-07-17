import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

class NarrationPlayerCard extends StatelessWidget {
  const NarrationPlayerCard({
    required this.controller,
    required this.contentId,
    required this.title,
    required this.subtitle,
    required this.onPlay,
    super.key,
  });

  final NarrationController controller;
  final String contentId;
  final String title;
  final String subtitle;
  final Future<void> Function() onPlay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isCurrent = controller.contentId == contentId;
        final status = isCurrent ? controller.status : NarrationStatus.idle;
        final isPlaying = status == NarrationStatus.playing;
        final isPaused = status == NarrationStatus.paused;
        final hasError = status == NarrationStatus.error;
        final progress = isCurrent ? controller.progress : 0.0;
        final currentLabel = isCurrent ? controller.currentItemLabel : null;

        return Semantics(
          container: true,
          label: '$title，$subtitle',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .96),
                  const Color(0xFF6E171A),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 22,
                  offset: Offset(0, 12),
                  color: Color(0x22000000),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isPlaying ? Icons.graphic_eq : Icons.headphones,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      tooltip: _mainButtonTooltip(status),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PhoenixTheme.red,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          unawaited(controller.pause());
                        } else if (isPaused) {
                          unawaited(controller.resume());
                        } else {
                          unawaited(onPlay());
                        }
                      },
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.volume_up_rounded,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: '重新播放',
                      onPressed: isCurrent && controller.hasContent
                          ? () => unawaited(controller.restart())
                          : null,
                      icon: const Icon(Icons.replay_rounded),
                      color: Colors.white,
                      disabledColor: Colors.white38,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      hasError
                          ? Icons.error_outline
                          : isPaused
                              ? Icons.pause_circle_outline
                              : isPlaying
                                  ? Icons.volume_up_outlined
                                  : Icons.play_circle_outline,
                      color: Colors.white70,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        hasError
                            ? controller.errorMessage ?? '朗读暂时不可用。'
                            : currentLabel ?? _statusText(status),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _mainButtonTooltip(NarrationStatus status) {
    return switch (status) {
      NarrationStatus.playing => '暂停朗读',
      NarrationStatus.paused => '继续朗读',
      NarrationStatus.idle => '开始朗读',
      NarrationStatus.error => '重新尝试朗读',
    };
  }

  String _statusText(NarrationStatus status) {
    return switch (status) {
      NarrationStatus.playing => '正在朗读',
      NarrationStatus.paused => '朗读已暂停',
      NarrationStatus.idle => '点击播放，使用慢速普通话朗读全部内容',
      NarrationStatus.error => '朗读暂时不可用',
    };
  }
}
