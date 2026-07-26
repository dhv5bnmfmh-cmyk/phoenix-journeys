import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpecialRealmCinematicOverlay extends StatefulWidget {
  const SpecialRealmCinematicOverlay({super.key, required this.journeyId});

  final String journeyId;

  @override
  State<SpecialRealmCinematicOverlay> createState() =>
      _SpecialRealmCinematicOverlayState();
}

class _SpecialRealmCinematicOverlayState
    extends State<SpecialRealmCinematicOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disabled = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disabled) {
      _controller
        ..stop()
        ..value = .37;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        key: ValueKey('special-realm-cinematic-${widget.journeyId}'),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _CinematicRealmPainter(
              journeyId: widget.journeyId,
              progress: _controller.value,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _CinematicRealmPainter extends CustomPainter {
  const _CinematicRealmPainter({
    required this.journeyId,
    required this.progress,
  });

  final String journeyId;
  final double progress;

  double get _wave => math.sin(progress * math.pi * 2);

  @override
  void paint(Canvas canvas, Size size) {
    _paintVignette(canvas, size);
    switch (journeyId) {
      case 'literary-roaming':
        _paintButterflyDream(canvas, size);
      case 'myth-tracing':
        _paintMoonArchive(canvas, size);
      case 'strange-night-talks':
        _paintInnNight(canvas, size);
      case 'folk-secret-land':
        _paintLanternRiver(canvas, size);
    }
    _paintFilmGrain(canvas, size);
  }

  void _paintVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          radius: .92,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: .08),
            Colors.black.withValues(alpha: .36),
          ],
          stops: const [.35, .72, 1],
        ).createShader(rect),
    );
  }

  void _paintButterflyDream(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final aurora = Path()
      ..moveTo(-size.width * .15, size.height * (.24 + _wave * .03))
      ..cubicTo(
        size.width * .18,
        size.height * .07,
        size.width * .52,
        size.height * .38,
        size.width * 1.15,
        size.height * .12,
      )
      ..lineTo(size.width * 1.15, size.height * .28)
      ..cubicTo(
        size.width * .62,
        size.height * .48,
        size.width * .18,
        size.height * .21,
        -size.width * .15,
        size.height * .38,
      )
      ..close();
    canvas.drawPath(
      aurora,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0x0000D5FF),
            Color(0x6659C7FF),
            Color(0x557B67F1),
            Color(0x00FFB8E7),
          ],
        ).createShader(rect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    for (var index = 0; index < 24; index++) {
      final phase = (progress * (.2 + index % 4 * .025) + index / 24) % 1;
      final x = size.width * (.06 + .9 * ((index * .417 + phase * .16) % 1));
      final y = size.height * (.12 + .67 * ((index * .263 + phase) % 1));
      final radius = 1.1 + (index % 4) * .65;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF8BE7FF),
            const Color(0xFFFFA9E8),
            (index % 7) / 6,
          )!.withValues(alpha: .18 + .42 * math.sin(phase * math.pi).abs())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2),
      );
    }

    final heroCenter = Offset(
      size.width * (.73 + .025 * math.sin(progress * math.pi * 2)),
      size.height * (.32 + .018 * math.cos(progress * math.pi * 4)),
    );
    _paintPremiumButterfly(
      canvas,
      heroCenter,
      size.width * .11,
      progress * math.pi * 2,
    );

    final foreground = Paint()
      ..color = const Color(0xFF061B22).withValues(alpha: .66)
      ..style = PaintingStyle.fill;
    for (var index = 0; index < 6; index++) {
      final x = size.width * (-.08 + index * .23);
      final sway = math.sin(progress * math.pi * 2 + index) * 7;
      final leaf = Path()
        ..moveTo(x + sway, size.height)
        ..quadraticBezierTo(
          x + 16 + sway,
          size.height * .78,
          x - 4 + sway,
          size.height * .56,
        )
        ..quadraticBezierTo(
          x - 34 + sway,
          size.height * .77,
          x + sway,
          size.height,
        );
      canvas.drawPath(leaf, foreground);
    }
  }

  void _paintMoonArchive(Canvas canvas, Size size) {
    final moonCenter = Offset(size.width * .7, size.height * .22);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var ring = 0; ring < 5; ring++) {
      final pulse = (progress + ring * .16) % 1;
      final radius = size.width * (.19 + pulse * .18);
      ringPaint.color = const Color(
        0xFFFFE8A8,
      ).withValues(alpha: .22 * (1 - pulse));
      canvas.drawCircle(moonCenter, radius, ringPaint);
    }

    for (var index = 0; index < 34; index++) {
      final phase = (progress * .28 + index / 34) % 1;
      final angle = index * 2.399 + progress * .35;
      final radius = size.width * (.12 + .5 * phase);
      final point =
          moonCenter + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(angle + progress * 2);
      final petal = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 3 + index % 3, height: 7),
        const Radius.circular(8),
      );
      canvas.drawRRect(
        petal,
        Paint()
          ..color = const Color(
            0xFFFFD670,
          ).withValues(alpha: .12 + .55 * (1 - phase)),
      );
      canvas.restore();
    }

    final glyphPaint = Paint()
      ..color = const Color(0xFFFFF2BC).withValues(alpha: .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var index = 0; index < 7; index++) {
      final x = size.width * (.09 + index * .13);
      final y =
          size.height * (.54 + .04 * math.sin(progress * math.pi * 2 + index));
      final glyph = Path()
        ..moveTo(x - 7, y)
        ..lineTo(x + 7, y)
        ..moveTo(x, y - 7)
        ..lineTo(x, y + 7)
        ..addOval(Rect.fromCircle(center: Offset(x, y), radius: 10));
      canvas.drawPath(glyph, glyphPaint);
    }

    final cloudPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFB9D7F4).withValues(alpha: .18),
          const Color(0xFFFFE6B8).withValues(alpha: .12),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    for (var index = 0; index < 4; index++) {
      final y = size.height * (.35 + index * .12);
      final x = size.width * (((progress * .08 + index * .27) % 1) - .2);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size.width * .58,
          height: size.height * .07,
        ),
        cloudPaint,
      );
    }
  }

  void _paintInnNight(Canvas canvas, Size size) {
    final lightningPhase = math.sin(progress * math.pi * 12);
    if (lightningPhase > .92) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = const Color(0xFFB9D9FF).withValues(alpha: .11),
      );
    }

    final fogPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFB3C3CA).withValues(alpha: .16),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    for (var index = 0; index < 5; index++) {
      final x =
          size.width *
          (((progress * (.06 + index * .01) + index * .24) % 1) - .3);
      final y = size.height * (.55 + index * .075);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size.width * .72,
          height: size.height * .085,
        ),
        fogPaint,
      );
    }

    final lanternGlow = Offset(size.width * .72, size.height * .5);
    final glow = Rect.fromCircle(center: lanternGlow, radius: size.width * .28);
    canvas.drawCircle(
      lanternGlow,
      size.width * .28,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFF7A3A).withValues(alpha: .26 + _wave.abs() * .1),
            const Color(0xFFD52D24).withValues(alpha: .08),
            Colors.transparent,
          ],
        ).createShader(glow),
    );

    final silhouette = Path()
      ..moveTo(size.width * .48, size.height * .91)
      ..quadraticBezierTo(
        size.width * .5,
        size.height * .67,
        size.width * .52,
        size.height * .91,
      )
      ..close();
    canvas.drawPath(
      silhouette,
      Paint()
        ..color = const Color(0xFF020303).withValues(alpha: .72)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 8; index++) {
      final phase = (progress * .9 + index / 8) % 1;
      ripplePaint.color = const Color(
        0xFFBFD4DD,
      ).withValues(alpha: .18 * (1 - phase));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * .5, size.height * .92),
          width: 22 + phase * size.width * .55,
          height: 5 + phase * 18,
        ),
        ripplePaint,
      );
    }
  }

  void _paintLanternRiver(Canvas canvas, Size size) {
    final current = Path()
      ..moveTo(-size.width * .2, size.height * (.66 + _wave * .02))
      ..cubicTo(
        size.width * .12,
        size.height * .5,
        size.width * .58,
        size.height * .82,
        size.width * 1.2,
        size.height * .58,
      );
    canvas.drawPath(
      current,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .16
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [
            Color(0x0016CDE0),
            Color(0x3348CBE1),
            Color(0x446E77F2),
            Color(0x00FF8A69),
          ],
        ).createShader(Offset.zero & size)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    for (var index = 0; index < 32; index++) {
      final phase = (progress * (.12 + index % 4 * .02) + index / 32) % 1;
      final x = size.width * ((index * .381 + phase * .32) % 1);
      final y = size.height * (.43 + .5 * ((index * .237 + phase) % 1));
      final glow = 1.5 + (index % 5) * .65;
      canvas.drawCircle(
        Offset(x, y),
        glow,
        Paint()
          ..color = Color.lerp(
            const Color(0xFFFFD56A),
            const Color(0xFFFF7A52),
            (index % 5) / 4,
          )!.withValues(alpha: .18 + .45 * math.sin(phase * math.pi).abs())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }

    final lotusCenter = Offset(
      size.width * (.23 + .02 * math.sin(progress * math.pi * 2)),
      size.height * (.76 + .015 * math.cos(progress * math.pi * 4)),
    );
    for (var petal = 0; petal < 10; petal++) {
      final angle = petal * math.pi * 2 / 10 + progress * .1;
      canvas.save();
      canvas.translate(lotusCenter.dx, lotusCenter.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, -13), width: 10, height: 28),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE09A), Color(0xFFFF7A6E)],
          ).createShader(const Rect.fromLTWH(-6, -28, 12, 32)),
      );
      canvas.restore();
    }
    canvas.drawCircle(
      lotusCenter,
      9,
      Paint()
        ..color = const Color(0xFFFFF0AA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  void _paintPremiumButterfly(
    Canvas canvas,
    Offset center,
    double radius,
    double phase,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.sin(phase) * .12);
    final flap = .78 + .22 * math.sin(phase * 2).abs();

    Path wing(bool left, bool upper) {
      final side = left ? -1.0 : 1.0;
      final vertical = upper ? -1.0 : 1.0;
      return Path()
        ..moveTo(0, 0)
        ..cubicTo(
          side * radius * .2,
          vertical * radius * .22,
          side * radius * 1.18 * flap,
          vertical * radius * .92,
          side * radius * 1.02 * flap,
          vertical * radius * 1.35,
        )
        ..cubicTo(
          side * radius * .55,
          vertical * radius * 1.42,
          side * radius * .18,
          vertical * radius * .6,
          0,
          0,
        )
        ..close();
    }

    final wingRect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2.6,
      height: radius * 3,
    );
    for (final entry in <(bool, bool)>[
      (true, true),
      (false, true),
      (true, false),
      (false, false),
    ]) {
      canvas.drawPath(
        wing(entry.$1, entry.$2),
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-.25, -.2),
            colors: [
              Color(0xFFFFF0C7),
              Color(0xFF70D7FF),
              Color(0xFF8B69ED),
              Color(0xFFFF78C6),
            ],
            stops: [0, .38, .72, 1],
          ).createShader(wingRect)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .7),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: radius * .18,
          height: radius * 1.65,
        ),
        Radius.circular(radius),
      ),
      Paint()..color = const Color(0xFF281A42),
    );
    canvas.restore();
  }

  void _paintFilmGrain(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .025);
    for (var index = 0; index < 90; index++) {
      final x = size.width * ((index * .754877 + progress * .07) % 1);
      final y = size.height * ((index * .569841 + progress * .11) % 1);
      canvas.drawCircle(Offset(x, y), .55 + index % 2 * .25, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CinematicRealmPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.journeyId != journeyId;
  }
}
