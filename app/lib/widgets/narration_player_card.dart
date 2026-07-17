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
        final currentItem = isCurrent ? controller.currentItemIndex : null;
        final itemCount = isCurrent ? controller.itemCount : 0;
        final canControl = isCurrent && controller.hasContent;

        return Semantics(
          container: true,
          label: '$title，$subtitle，${_statusText(status)}',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(11, 8, 10, 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .97),
                  const Color(0xFF651418),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 5),
                  color: Color(0x14000000),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      isPlaying ? Icons.graphic_eq_rounded : Icons.headphones,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            hasError
                                ? controller.errorMessage ?? '朗读暂时不可用'
                                : subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9.5,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      key: const ValueKey('narration-main-control'),
                      tooltip: _mainButtonTooltip(status),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PhoenixTheme.red,
                        minimumSize: const Size(38, 38),
                        maximumSize: const Size(38, 38),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      iconSize: 23,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                    const SizedBox(width: 3),
                    _MiniIconButton(
                      key: const ValueKey('narration-stop-control'),
                      tooltip: '停止朗读',
                      icon: Icons.stop_rounded,
                      onPressed: canControl && status != NarrationStatus.idle
                          ? () => unawaited(controller.stop())
                          : null,
                    ),
                    PopupMenuButton<double>(
                      key: const ValueKey('narration-speed-control'),
                      tooltip: '调整朗读语速',
                      padding: EdgeInsets.zero,
                      onSelected: (rate) {
                        unawaited(controller.setSpeechRate(rate));
                      },
                      itemBuilder: (context) => NarrationController.speedOptions
                          .map(
                            (option) => PopupMenuItem<double>(
                              value: option.rate,
                              child: Text('${option.label} 语速'),
                            ),
                          )
                          .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          controller.speedLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      currentItem == null || itemCount == 0
                          ? '—/—'
                          : '${currentItem + 1}/$itemCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 3),
                    _MiniIconButton(
                      tooltip: '重新播放',
                      icon: Icons.replay_rounded,
                      onPressed: canControl
                          ? () => unawaited(controller.restart())
                          : null,
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

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      icon: Icon(icon, size: 17),
      color: Colors.white,
      disabledColor: Colors.white30,
    );
  }
}
