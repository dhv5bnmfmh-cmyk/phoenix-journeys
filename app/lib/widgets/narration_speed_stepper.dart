import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

typedef NarrationRateChange = Future<void> Function(double rate);

class NarrationSpeedStepper extends StatelessWidget {
  const NarrationSpeedStepper({
    required this.controller,
    this.onRateChange,
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final NarrationController controller;
  final NarrationRateChange? onRateChange;
  final bool dark;
  final bool compact;

  void _setRate(double? rate) {
    if (rate == null) return;
    final callback = onRateChange;
    if (callback == null) {
      unawaited(controller.setSpeechRate(rate));
    } else {
      unawaited(callback(rate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final foreground = dark ? Colors.white : PhoenixTheme.red;
        final muted = dark ? Colors.white38 : Colors.black26;
        final background = dark
            ? Colors.white.withValues(alpha: .13)
            : PhoenixTheme.red.withValues(alpha: .08);
        final border = dark
            ? Colors.white.withValues(alpha: .16)
            : PhoenixTheme.red.withValues(alpha: .16);

        return Semantics(
          container: true,
          label: '当前朗读速度 ${controller.speedLabel}，可减速或加速',
          child: Container(
            key: const ValueKey('narration-speed-stepper'),
            padding: EdgeInsets.fromLTRB(
              compact ? 5 : 7,
              compact ? 3 : 4,
              compact ? 5 : 7,
              compact ? 2 : 3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.speedLabel,
                  key: const ValueKey('narration-current-speed'),
                  style: TextStyle(
                    color: foreground,
                    fontSize: compact ? 9 : 10,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SpeedAction(
                      key: const ValueKey('narration-slow-down'),
                      label: '减速',
                      enabled: controller.canDecreaseSpeechRate,
                      foreground: foreground,
                      disabled: muted,
                      onPressed: () => _setRate(controller.slowerSpeechRate),
                    ),
                    Container(
                      width: 1,
                      height: 11,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: border,
                    ),
                    _SpeedAction(
                      key: const ValueKey('narration-speed-up'),
                      label: '加速',
                      enabled: controller.canIncreaseSpeechRate,
                      foreground: foreground,
                      disabled: muted,
                      onPressed: () => _setRate(controller.fasterSpeechRate),
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
}

class _SpeedAction extends StatelessWidget {
  const _SpeedAction({
    required this.label,
    required this.enabled,
    required this.foreground,
    required this.disabled,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool enabled;
  final Color foreground;
  final Color disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? foreground : disabled,
            fontSize: 7.5,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
