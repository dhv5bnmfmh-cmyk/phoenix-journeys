import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class ForbiddenCityStamp extends StatelessWidget {
  const ForbiddenCityStamp({
    this.size = 150,
    this.isUnlocked = true,
    super.key,
  });

  final double size;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final stamp = Container(
      key: const ValueKey('forbidden-city-stamp'),
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .075),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? PhoenixTheme.red.withValues(alpha: .06)
            : Colors.black.withValues(alpha: .035),
        border: Border.all(
          color: isUnlocked ? PhoenixTheme.red : Colors.black26,
          width: size * .026,
        ),
      ),
      child: CustomPaint(
        painter: _StampRingPainter(
          color: isUnlocked ? PhoenixTheme.red : Colors.black26,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '北京',
                style: TextStyle(
                  color: isUnlocked ? PhoenixTheme.red : Colors.black38,
                  fontSize: size * .15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: size * .015,
                  height: 1,
                ),
              ),
              SizedBox(height: size * .035),
              Icon(
                isUnlocked ? Icons.account_balance : Icons.lock_outline,
                color: isUnlocked ? PhoenixTheme.red : Colors.black38,
                size: size * .23,
              ),
              SizedBox(height: size * .025),
              Text(
                isUnlocked ? '紫禁城' : '待探索',
                style: TextStyle(
                  color: isUnlocked ? PhoenixTheme.red : Colors.black38,
                  fontSize: size * .12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: size * .008,
                  height: 1,
                ),
              ),
              SizedBox(height: size * .035),
              Text(
                'PHOENIX JOURNEYS',
                style: TextStyle(
                  color: isUnlocked ? PhoenixTheme.red : Colors.black38,
                  fontSize: size * .052,
                  fontWeight: FontWeight.w900,
                  letterSpacing: size * .004,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      label: isUnlocked ? '北京紫禁城旅程印章，已获得' : '北京紫禁城旅程印章，尚未获得',
      child: Transform.rotate(
        angle: isUnlocked ? -math.pi / 36 : 0,
        child: AnimatedOpacity(
          opacity: isUnlocked ? 1 : .52,
          duration: const Duration(milliseconds: 350),
          child: stamp,
        ),
      ),
    );
  }
}

class _StampRingPainter extends CustomPainter {
  const _StampRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .012;

    canvas.drawCircle(center, size.width * .42, paint);

    final dashPaint = Paint()
      ..color = color.withValues(alpha: .38)
      ..strokeWidth = size.width * .018
      ..strokeCap = StrokeCap.round;

    const dashCount = 24;
    for (var index = 0; index < dashCount; index += 1) {
      final angle = index * math.pi * 2 / dashCount;
      final inner = Offset(
        center.dx + math.cos(angle) * size.width * .455,
        center.dy + math.sin(angle) * size.width * .455,
      );
      final outer = Offset(
        center.dx + math.cos(angle) * size.width * .485,
        center.dy + math.sin(angle) * size.width * .485,
      );
      canvas.drawLine(inner, outer, dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StampRingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
