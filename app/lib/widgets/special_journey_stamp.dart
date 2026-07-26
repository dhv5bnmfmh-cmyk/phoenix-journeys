import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/daily_journey_experience.dart';

class SpecialJourneyStamp extends StatelessWidget {
  const SpecialJourneyStamp({
    super.key,
    required this.journey,
    required this.isUnlocked,
    required this.size,
    required this.transparentInk,
  });

  final DailyJourneyExperience journey;
  final bool isUnlocked;
  final double size;
  final bool transparentInk;

  static bool supports(String journeyId) {
    return const {
      'literary-roaming',
      'myth-tracing',
      'strange-night-talks',
      'folk-secret-land',
    }.contains(journeyId);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${journey.place}限定收藏章',
      child: SizedBox.square(
        key: ValueKey('special-journey-stamp-${journey.id}'),
        dimension: size,
        child: CustomPaint(
          painter: _SpecialStampPainter(
            journeyId: journey.id,
            symbol: journey.stampSymbol,
            title: journey.place,
            isUnlocked: isUnlocked,
            transparentInk: transparentInk,
          ),
        ),
      ),
    );
  }
}

class _SpecialStampPainter extends CustomPainter {
  const _SpecialStampPainter({
    required this.journeyId,
    required this.symbol,
    required this.title,
    required this.isUnlocked,
    required this.transparentInk,
  });

  final String journeyId;
  final String symbol;
  final String title;
  final bool isUnlocked;
  final bool transparentInk;

  double get _alpha => transparentInk ? .7 : 1;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * .46;
    if (!isUnlocked) {
      _paintLocked(canvas, center, radius);
      return;
    }

    switch (journeyId) {
      case 'literary-roaming':
        _paintButterfly(canvas, center, radius);
      case 'myth-tracing':
        _paintMoon(canvas, center, radius);
      case 'strange-night-talks':
        _paintNightLantern(canvas, center, radius);
      case 'folk-secret-land':
        _paintRiverLantern(canvas, center, radius);
    }
  }

  void _paintLocked(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.black.withValues(alpha: .06),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .07
        ..color = Colors.black26,
    );
    final painter = TextPainter(
      text: const TextSpan(
        text: '锁',
        style: TextStyle(
          color: Colors.black38,
          fontSize: 34,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  void _paintButterfly(Canvas canvas, Offset center, double radius) {
    final glowRect = Rect.fromCircle(center: center, radius: radius * 1.08);
    canvas.drawCircle(
      center,
      radius * 1.04,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF2C8).withValues(alpha: .62 * _alpha),
            const Color(0xFF91E6FF).withValues(alpha: .28 * _alpha),
            Colors.transparent,
          ],
        ).createShader(glowRect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    Path wing(bool left, bool upper) {
      final side = left ? -1.0 : 1.0;
      final v = upper ? -1.0 : 1.0;
      return Path()
        ..moveTo(center.dx, center.dy)
        ..cubicTo(
          center.dx + side * radius * .18,
          center.dy + v * radius * .18,
          center.dx + side * radius * 1.05,
          center.dy + v * radius * .78,
          center.dx + side * radius * .88,
          center.dy + v * radius * 1.16,
        )
        ..cubicTo(
          center.dx + side * radius * .52,
          center.dy + v * radius * 1.2,
          center.dx + side * radius * .12,
          center.dy + v * radius * .5,
          center.dx,
          center.dy,
        )
        ..close();
    }

    final shaderRect = Rect.fromCircle(center: center, radius: radius * 1.25);
    for (final entry in <(bool, bool)>[
      (true, true),
      (false, true),
      (true, false),
      (false, false),
    ]) {
      canvas.drawPath(
        wing(entry.$1, entry.$2),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF2C5).withValues(alpha: _alpha),
              const Color(0xFF6DE1FF).withValues(alpha: _alpha),
              const Color(0xFF8B68F2).withValues(alpha: _alpha),
              const Color(0xFFFF72C5).withValues(alpha: _alpha),
            ],
            stops: const [0, .35, .68, 1],
          ).createShader(shaderRect)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        wing(entry.$1, entry.$2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * .035
          ..color = const Color(0xFF51357F).withValues(alpha: .72 * _alpha),
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: radius * .18,
          height: radius * 1.48,
        ),
        Radius.circular(radius),
      ),
      Paint()..color = const Color(0xFF2B1A48).withValues(alpha: _alpha),
    );
    _paintSparkles(canvas, center, radius, const Color(0xFFFFF0A8));
    _paintLabel(canvas, center + Offset(0, radius * .78), '蝶');
  }

  void _paintMoon(Canvas canvas, Offset center, double radius) {
    final outer = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.35, -.35),
          colors: [
            const Color(0xFFFFF7D4).withValues(alpha: _alpha),
            const Color(0xFFFFD778).withValues(alpha: _alpha),
            const Color(0xFF8BA9DC).withValues(alpha: _alpha),
          ],
        ).createShader(outer)
        ..maskFilter = transparentInk
            ? null
            : const MaskFilter.blur(BlurStyle.normal, .5),
    );
    canvas.drawCircle(
      center + Offset(radius * .34, -radius * .08),
      radius * .82,
      Paint()..color = const Color(0xFF253359).withValues(alpha: .92 * _alpha),
    );

    final branch = Paint()
      ..color = const Color(0xFF6F4520).withValues(alpha: .9 * _alpha)
      ..strokeWidth = radius * .055
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center + Offset(-radius * .72, radius * .46),
      center + Offset(radius * .5, -radius * .52),
      branch,
    );
    for (var index = 0; index < 7; index++) {
      final t = index / 6;
      final point = Offset.lerp(
        center + Offset(-radius * .62, radius * .4),
        center + Offset(radius * .42, -radius * .45),
        t,
      )!;
      for (var petal = 0; petal < 4; petal++) {
        final angle = petal * math.pi / 2;
        canvas.drawOval(
          Rect.fromCenter(
            center: point + Offset(math.cos(angle), math.sin(angle)) * radius * .07,
            width: radius * .12,
            height: radius * .06,
          ),
          Paint()..color = const Color(0xFFFFE58A).withValues(alpha: _alpha),
        );
      }
    }
    _paintLabel(canvas, center + Offset(0, radius * .64), '月');
  }

  void _paintNightLantern(Canvas canvas, Offset center, double radius) {
    final lantern = Path()
      ..moveTo(center.dx - radius * .5, center.dy - radius * .55)
      ..quadraticBezierTo(
        center.dx,
        center.dy - radius * .82,
        center.dx + radius * .5,
        center.dy - radius * .55,
      )
      ..lineTo(center.dx + radius * .66, center.dy + radius * .34)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * .68,
        center.dx - radius * .66,
        center.dy + radius * .34,
      )
      ..close();
    final bounds = lantern.getBounds();
    canvas.drawPath(
      lantern,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE18D).withValues(alpha: _alpha),
            const Color(0xFFFF6A39).withValues(alpha: _alpha),
            const Color(0xFF7D1022).withValues(alpha: _alpha),
          ],
        ).createShader(bounds)
        ..maskFilter = transparentInk
            ? null
            : const MaskFilter.blur(BlurStyle.normal, 1),
    );
    canvas.drawPath(
      lantern,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .075
        ..color = const Color(0xFF431018).withValues(alpha: _alpha),
    );
    for (var line = -1; line <= 1; line++) {
      canvas.drawLine(
        center + Offset(line * radius * .22, -radius * .61),
        center + Offset(line * radius * .28, radius * .48),
        Paint()
          ..color = const Color(0xFF5B1420).withValues(alpha: .75 * _alpha)
          ..strokeWidth = radius * .035,
      );
    }
    canvas.drawLine(
      center + Offset(0, -radius * .94),
      center + Offset(0, -radius * .64),
      Paint()
        ..color = const Color(0xFFE2B56F).withValues(alpha: _alpha)
        ..strokeWidth = radius * .05,
    );
    _paintLabel(canvas, center + Offset(0, radius * .03), '夜');
  }

  void _paintRiverLantern(Canvas canvas, Offset center, double radius) {
    for (var petal = 0; petal < 12; petal++) {
      final angle = petal * math.pi * 2 / 12;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -radius * .48),
          width: radius * .34,
          height: radius * .92,
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF1A8).withValues(alpha: _alpha),
              const Color(0xFFFFA04E).withValues(alpha: _alpha),
              const Color(0xFFFF5F72).withValues(alpha: _alpha),
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: radius,
              height: radius * 1.4,
            ),
          ),
      );
      canvas.restore();
    }
    canvas.drawCircle(
      center,
      radius * .35,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: _alpha),
            const Color(0xFFFFD96F).withValues(alpha: _alpha),
            const Color(0xFFFF744D).withValues(alpha: _alpha),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * .35)),
    );
    final water = Path()
      ..moveTo(center.dx - radius * .82, center.dy + radius * .62)
      ..cubicTo(
        center.dx - radius * .35,
        center.dy + radius * .48,
        center.dx + radius * .22,
        center.dy + radius * .78,
        center.dx + radius * .86,
        center.dy + radius * .58,
      );
    canvas.drawPath(
      water,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .06
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF50D7E8).withValues(alpha: .2 * _alpha),
            const Color(0xFF70A8FF).withValues(alpha: _alpha),
            const Color(0xFF50D7E8).withValues(alpha: .2 * _alpha),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    _paintLabel(canvas, center + Offset(0, radius * .08), '灯');
  }

  void _paintSparkles(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    for (var index = 0; index < 9; index++) {
      final angle = index * math.pi * 2 / 9;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius * .92;
      canvas.drawCircle(
        point,
        radius * (.025 + (index % 3) * .012),
        Paint()..color = color.withValues(alpha: .72 * _alpha),
      );
    }
  }

  void _paintLabel(Canvas canvas, Offset center, String value) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: Colors.white.withValues(alpha: .94 * _alpha),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          shadows: const [Shadow(blurRadius: 5, color: Colors.black45)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SpecialStampPainter oldDelegate) {
    return oldDelegate.journeyId != journeyId ||
        oldDelegate.isUnlocked != isUnlocked ||
        oldDelegate.transparentInk != transparentInk;
  }
}
