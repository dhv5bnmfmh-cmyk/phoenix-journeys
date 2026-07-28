import 'package:flutter/material.dart';

class NarrationSeekRail extends StatelessWidget {
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

  double _progressFor(Offset localPosition, double width) {
    if (width <= 0) return 0;
    return (localPosition.dx / width).clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0).toDouble();

    return Semantics(
      slider: true,
      enabled: enabled,
      value: '${(progress * 100).round()}%',
      label: '朗读进度，可拖动跳转',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled && onSeekStart != null
                ? (details) {
                    final next = _progressFor(details.localPosition, width);
                    onSeekStart!(next);
                    onSeekEnd?.call(next);
                  }
                : null,
            onHorizontalDragStart: enabled && onSeekStart != null
                ? (details) => onSeekStart!(
                    _progressFor(details.localPosition, width),
                  )
                : null,
            onHorizontalDragUpdate: enabled && onSeekUpdate != null
                ? (details) => onSeekUpdate!(
                    _progressFor(details.localPosition, width),
                  )
                : null,
            onHorizontalDragEnd: enabled && onSeekEnd != null
                ? (_) => onSeekEnd!(progress)
                : null,
            child: SizedBox(
              height: minHeight + 12,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: SizedBox(
                    height: minHeight,
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
