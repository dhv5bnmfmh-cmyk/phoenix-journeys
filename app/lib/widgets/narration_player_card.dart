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
        final currentItem = isCurrent ? controller.currentItemIndex : null;
        final itemCount = isCurrent ? controller.itemCount : 0;
        final canControl = isCurrent && controller.hasContent;

        return Semantics(
          container: true,
          label: '$title，$subtitle，${_statusText(status)}',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .97),
                  const Color(0xFF651418),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 22,
                  offset: Offset(0, 12),
                  color: Color(0x22000000),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        isPlaying ? Icons.graphic_eq_rounded : Icons.headphones,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 14),
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
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasError
                            ? controller.errorMessage ?? '朗读暂时不可用。'
                            : currentLabel ?? _statusText(status),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentItem == null || itemCount == 0
                          ? '— / —'
                          : '${currentItem + 1} / $itemCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: '重新播放',
                      onPressed: canControl
                          ? () => unawaited(controller.restart())
                          : null,
                      icon: const Icon(Icons.replay_rounded),
                      color: Colors.white,
                      disabledColor: Colors.white30,
                      iconSize: 27,
                    ),
                    const SizedBox(width: 18),
                    IconButton.filled(
                      key: const ValueKey('narration-main-control'),
                      tooltip: _mainButtonTooltip(status),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PhoenixTheme.red,
                        disabledBackgroundColor: Colors.white70,
                        minimumSize: const Size(66, 66),
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
                      iconSize: 36,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                    const SizedBox(width: 18),
                    IconButton(
                      tooltip: '停止朗读',
                      onPressed: canControl && status != NarrationStatus.idle
                          ? () => unawaited(controller.stop())
                          : null,
                      icon: const Icon(Icons.stop_rounded),
                      color: Colors.white,
                      disabledColor: Colors.white30,
                      iconSize: 27,
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
      NarrationStatus.idle => '点击播放开始朗读',
      NarrationStatus.error => '朗读暂时不可用',
    };
  }
}
