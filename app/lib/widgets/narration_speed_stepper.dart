import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';
import 'narration_follow_status.dart';
import 'narration_voice_picker_button.dart';

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
            ? Colors.white.withValues(alpha: .11)
            : Colors.white.withValues(alpha: .88);
        final border = dark
            ? Colors.white.withValues(alpha: .22)
            : PhoenixTheme.red.withValues(alpha: .24);

        final controls = Row(
          key: const ValueKey('narration-control-row'),
          mainAxisSize: MainAxisSize.min,
          children: [
            NarrationVoicePickerButton(
              controller: controller,
              dark: dark,
              compact: compact,
            ),
            SizedBox(width: compact ? 4 : 6),
            Container(
              key: const ValueKey('narration-speed-stepper'),
              padding: EdgeInsets.all(compact ? 2 : 3),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(compact ? 11 : 13),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? .12 : .08),
                    blurRadius: compact ? 4 : 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                key: const ValueKey('narration-speed-group'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SpeedAction(
                    key: const ValueKey('narration-slow-down'),
                    icon: Icons.remove_rounded,
                    label: '减速',
                    enabled: controller.canDecreaseSpeechRate,
                    foreground: foreground,
                    disabled: muted,
                    compact: compact,
                    onPressed: () => _setRate(controller.slowerSpeechRate),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minWidth: compact ? 34 : 42,
                      minHeight: compact ? 27 : 32,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: compact ? 2 : 3),
                    padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 5),
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.black.withValues(alpha: .14)
                          : PhoenixTheme.red.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(compact ? 8 : 9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.speedLabel,
                          key: const ValueKey('narration-current-speed'),
                          style: TextStyle(
                            color: foreground,
                            fontSize: compact ? 9 : 10.5,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: compact ? 1 : 2),
                        Text(
                          '速度',
                          style: TextStyle(
                            color: foreground.withValues(alpha: .66),
                            fontSize: compact ? 6.5 : 7.5,
                            height: 1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SpeedAction(
                    key: const ValueKey('narration-speed-up'),
                    icon: Icons.add_rounded,
                    label: '加速',
                    enabled: controller.canIncreaseSpeechRate,
                    foreground: foreground,
                    disabled: muted,
                    compact: compact,
                    onPressed: () => _setRate(controller.fasterSpeechRate),
                  ),
                ],
              ),
            ),
          ],
        );

        return Semantics(
          container: true,
          label: '声线与朗读速度控制，当前速度 ${controller.speedLabel}',
          child: Column(
            key: ValueKey(
              compact
                  ? 'compact-narration-controls-with-follow-status'
                  : 'narration-controls-with-follow-status',
            ),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: compact
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.stretch,
            children: [
              controls,
              SizedBox(height: compact ? 3 : 4),
              NarrationFollowStatus(
                controller: controller,
                dark: dark,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpeedAction extends StatefulWidget {
  const _SpeedAction({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.foreground,
    required this.disabled,
    required this.compact,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final Color foreground;
  final Color disabled;
  final bool compact;
  final VoidCallback onPressed;

  @override
  State<_SpeedAction> createState() => _SpeedActionState();
}

class _SpeedActionState extends State<_SpeedAction> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    final foreground = enabled ? widget.foreground : widget.disabled;
    final size = widget.compact ? 27.0 : 32.0;

    return Tooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: widget.label,
        child: AnimatedScale(
          scale: _pressed && enabled ? .90 : 1,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: enabled
                  ? widget.foreground.withValues(alpha: _pressed ? .25 : .10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(widget.compact ? 8 : 9),
              border: Border.all(
                color: enabled
                    ? widget.foreground.withValues(alpha: _pressed ? .50 : .20)
                    : widget.disabled.withValues(alpha: .15),
              ),
              boxShadow: enabled && !_pressed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : const [],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.compact ? 8 : 9),
              child: InkWell(
                onTap: enabled ? widget.onPressed : null,
                onTapDown: enabled ? (_) => _setPressed(true) : null,
                onTapUp: enabled ? (_) => _setPressed(false) : null,
                onTapCancel: enabled ? () => _setPressed(false) : null,
                borderRadius: BorderRadius.circular(widget.compact ? 8 : 9),
                splashColor: widget.foreground.withValues(alpha: .22),
                highlightColor: widget.foreground.withValues(alpha: .12),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: foreground,
                    size: widget.compact ? 16 : 19,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
