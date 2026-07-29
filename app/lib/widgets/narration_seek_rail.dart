import 'package:flutter/material.dart';

class NarrationSeekRail extends StatefulWidget {
  const NarrationSeekRail({
    required this.value,
    required this.minHeight,
    this.enabled = true,
    this.onSeekStart,
    this.onSeekUpdate,
    this.onSeekEnd,
    super.key,
  });

  final double value;
  final double minHeight;
  final bool enabled;
  final ValueChanged<double>? onSeekStart;
  final ValueChanged<double>? onSeekUpdate;
  final ValueChanged<double>? onSeekEnd;

  @override
  State<NarrationSeekRail> createState() => _NarrationSeekRailState();
}

class _NarrationSeekRailState extends State<NarrationSeekRail> {
  double? _gestureProgress;

  double _progressFor(Offset localPosition, double width) {
    if (width <= 0) return 0;
    return (localPosition.dx / width).clamp(0.0, 1.0).toDouble();
  }

  void _start(double progress) {
    _gestureProgress = progress;
    widget.onSeekStart?.call(progress);
  }

  void _update(double progress) {
    _gestureProgress = progress;
    widget.onSeekUpdate?.call(progress);
  }

  void _finish([double? progress]) {
    final value = progress ?? _gestureProgress ?? widget.value;
    _gestureProgress = null;
    widget.onSeekEnd?.call(value.clamp(0.0, 1.0).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.value.clamp(0.0, 1.0).toDouble();

    return Semantics(
      slider: true,
      enabled: widget.enabled,
      value: '${(progress * 100).round()}%',
      label: '朗读进度，可拖动跳转',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: widget.enabled && widget.onSeekStart != null
                ? (details) {
                    final next = _progressFor(details.localPosition, width);
                    _start(next);
                    _finish(next);
                  }
                : null,
            onHorizontalDragStart:
                widget.enabled && widget.onSeekStart != null
                ? (details) => _start(
                    _progressFor(details.localPosition, width),
                  )
                : null,
            onHorizontalDragUpdate:
                widget.enabled && widget.onSeekUpdate != null
                ? (details) => _update(
                    _progressFor(details.localPosition, width),
                  )
                : null,
            onHorizontalDragEnd: widget.enabled && widget.onSeekEnd != null
                ? (_) => _finish()
                : null,
            onHorizontalDragCancel: widget.enabled && widget.onSeekEnd != null
                ? _finish
                : null,
            child: SizedBox(
              height: widget.minHeight + 12,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: SizedBox(
                    height: widget.minHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: Colors.white24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress,
                            child: const ColoredBox(
                              color: Color(0xFFFFD879),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
