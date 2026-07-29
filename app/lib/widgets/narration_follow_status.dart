import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

@visibleForTesting
String narrationFollowStatusLabel({
  required NarrationStatus status,
  required bool hasContent,
  required String? currentItemLabel,
  required String? currentWord,
  required int currentOffset,
  required int totalCharacters,
}) {
  if (status == NarrationStatus.error) return '朗读暂不可用';
  if (!hasContent) return '准备朗读';

  final item = currentItemLabel?.trim();
  final word = currentWord?.trim();
  final itemLabel = item == null || item.isEmpty ? '当前段落' : item;

  if (status == NarrationStatus.playing) {
    if (word != null && word.isNotEmpty) return '$itemLabel · $word';
    return '$itemLabel · 跟读中';
  }
  if (status == NarrationStatus.paused) return '$itemLabel · 已暂停';
  if (totalCharacters > 0 && currentOffset >= totalCharacters) {
    return '本次朗读完成';
  }
  return item == null || item.isEmpty ? '准备朗读' : item;
}

class NarrationFollowStatus extends StatelessWidget {
  const NarrationFollowStatus({
    required this.controller,
    this.dark = false,
    super.key,
  });

  final NarrationController controller;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final status = controller.status;
    final playing = status == NarrationStatus.playing;
    final paused = status == NarrationStatus.paused;
    final error = status == NarrationStatus.error;
    final label = narrationFollowStatusLabel(
      status: status,
      hasContent: controller.hasContent,
      currentItemLabel: controller.currentItemLabel,
      currentWord: controller.highlightSnapshot?.word,
      currentOffset: controller.currentOffset,
      totalCharacters: controller.totalCharacters,
    );
    final foreground = dark ? Colors.white : PhoenixTheme.red;
    final muted = dark ? Colors.white70 : Colors.black54;
    final activeColor = error
        ? Colors.orange
        : playing
        ? const Color(0xFFFFC45E)
        : foreground;
    final icon = error
        ? Icons.error_outline_rounded
        : playing
        ? Icons.graphic_eq_rounded
        : paused
        ? Icons.pause_circle_outline_rounded
        : Icons.auto_stories_rounded;

    return Semantics(
      liveRegion: true,
      label: '朗读跟读状态：$label',
      child: AnimatedContainer(
        key: const ValueKey('narration-follow-status'),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(minHeight: 22),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: dark
              ? Colors.black.withValues(alpha: playing ? .20 : .12)
              : PhoenixTheme.red.withValues(alpha: playing ? .09 : .05),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: activeColor.withValues(alpha: playing ? .38 : .18),
          ),
          boxShadow: playing
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: .12),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              key: const ValueKey('narration-follow-pulse'),
              tween: Tween<double>(begin: .72, end: playing ? 1 : .78),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Icon(icon, size: 13, color: activeColor),
            ),
            const SizedBox(width: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 154),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Text(
                  label,
                  key: ValueKey('narration-follow-$label'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: playing ? foreground : muted,
                    fontSize: 8.5,
                    height: 1,
                    fontWeight: playing ? FontWeight.w900 : FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
