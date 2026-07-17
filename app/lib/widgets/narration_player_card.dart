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
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .97),
                  const Color(0xFF651418),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 16,
                  offset: Offset(0, 8),
                  color: Color(0x1A000000),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        isPlaying ? Icons.graphic_eq_rounded : Icons.headphones,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasError
                                ? controller.errorMessage ?? '朗读暂时不可用'
                                : currentLabel ?? subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const ValueKey('narration-main-control'),
                      tooltip: _mainButtonTooltip(status),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PhoenixTheme.red,
                        minimumSize: const Size(46, 46),
                        maximumSize: const Size(46, 46),
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
                      iconSize: 28,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      currentItem == null || itemCount == 0
                          ? '—/—'
                          : '${currentItem + 1}/$itemCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _CompactControl(
                      tooltip: '重新播放',
                      icon: Icons.replay_rounded,
                      label: '重播',
                      onPressed: canControl
                          ? () => unawaited(controller.restart())
                          : null,
                    ),
                    const SizedBox(width: 2),
                    _CompactControl(
                      key: const ValueKey('narration-stop-control'),
                      tooltip: '停止朗读',
                      icon: Icons.stop_rounded,
                      label: '停止',
                      onPressed: canControl && status != NarrationStatus.idle
                          ? () => unawaited(controller.stop())
                          : null,
                    ),
                    const Spacer(),
                    PopupMenuButton<double>(
                      key: const ValueKey('narration-speed-control'),
                      tooltip: '调整朗读语速',
                      onSelected: (rate) {
                        unawaited(controller.setSpeechRate(rate));
                      },
                      itemBuilder: (context) => NarrationController.speedOptions
                          .map(
                            (option) => PopupMenuItem<double>(
                              value: option.rate,
                              child: Row(
                                children: [
                                  Icon(
                                    (option.rate - controller.speechRate).abs() <
                                            .001
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    size: 18,
                                    color: PhoenixTheme.red,
                                  ),
                                  const SizedBox(width: 9),
                                  Text('${option.label} 语速'),
                                ],
                              ),
                            ),
                          )
                          .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.speed_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              controller.speedLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ],
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
      NarrationStatus.idle => '点击播放开始朗读',
      NarrationStatus.error => '朗读暂时不可用',
    };
  }
}

class _CompactControl extends StatelessWidget {
  const _CompactControl({
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white30,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}
