import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A resolution-independent, layered miniature emblem for a Phoenix journey.
///
/// The badge is intentionally painted as vectors instead of using emoji or a
/// small raster asset, so it stays crisp on high-density phone displays.
class JourneySymbolBadge extends StatelessWidget {
  const JourneySymbolBadge({
    super.key,
    required this.journeyId,
    this.size = 42,
    this.isUnlocked = true,
  });

  final String journeyId;
  final double size;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '旅程象征徽章',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: isUnlocked ? 1 : .52,
        child: RepaintBoundary(
          child: CustomPaint(
            key: ValueKey('journey-symbol-$journeyId'),
            size: Size.square(size),
            painter: _JourneySymbolPainter(
              motif: _motifFor(journeyId),
              palette: _paletteFor(journeyId),
            ),
          ),
        ),
      ),
    );
  }
}

enum _JourneyMotif {
  palace,
  pavilion,
  skyline,
  cityWall,
  lakeBridge,
  alley,
  lanternBoat,
  ancestralHall,
  butterfly,
  moonScroll,
  shadowInn,
  riverLantern,
}

class _BadgePalette {
  const _BadgePalette(this.sky, this.horizon, this.ink, this.glow);

  final Color sky;
  final Color horizon;
  final Color ink;
  final Color glow;
}

_JourneyMotif _motifFor(String id) {
  if (id.contains('summer-palace')) return _JourneyMotif.pavilion;
  if (id.contains('forbidden-city')) return _JourneyMotif.palace;
  if (id.contains('shanghai')) return _JourneyMotif.skyline;
  if (id.contains('xian')) return _JourneyMotif.cityWall;
  if (id.contains('hangzhou')) return _JourneyMotif.lakeBridge;
  if (id.contains('chengdu')) return _JourneyMotif.alley;
  if (id.contains('nanjing')) return _JourneyMotif.lanternBoat;
  if (id.contains('guangzhou')) return _JourneyMotif.ancestralHall;
  if (id == 'literary-roaming') return _JourneyMotif.butterfly;
  if (id == 'myth-tracing') return _JourneyMotif.moonScroll;
  if (id == 'strange-night-talks') return _JourneyMotif.shadowInn;
  if (id == 'folk-secret-land') return _JourneyMotif.riverLantern;
  return _JourneyMotif.palace;
}

_BadgePalette _paletteFor(String id) {
  if (id.contains('summer-palace')) {
    return const _BadgePalette(
      Color(0xFF86C8C2),
      Color(0xFF174C5A),
      Color(0xFF092E35),
      Color(0xFFFFD97A),
    );
  }
  if (id.contains('shanghai')) {
    return const _BadgePalette(
      Color(0xFF7CB5C9),
      Color(0xFF304C6D),
      Color(0xFF14263D),
      Color(0xFFFFD47A),
    );
  }
  if (id.contains('xian')) {
    return const _BadgePalette(
      Color(0xFFD49B65),
      Color(0xFF7B3928),
      Color(0xFF3C1C1A),
      Color(0xFFFFCB68),
    );
  }
  if (id.contains('hangzhou')) {
    return const _BadgePalette(
      Color(0xFF9ACFC0),
      Color(0xFF477C72),
      Color(0xFF173D3A),
      Color(0xFFFFE4A3),
    );
  }
  if (id.contains('chengdu')) {
    return const _BadgePalette(
      Color(0xFFB9A58A),
      Color(0xFF68513E),
      Color(0xFF30241D),
      Color(0xFFE9C77E),
    );
  }
  if (id.contains('nanjing')) {
    return const _BadgePalette(
      Color(0xFF7098A8),
      Color(0xFF754B58),
      Color(0xFF2D2635),
      Color(0xFFFFBA68),
    );
  }
  if (id.contains('guangzhou')) {
    return const _BadgePalette(
      Color(0xFFE39D7B),
      Color(0xFF8D3D35),
      Color(0xFF44201F),
      Color(0xFFFFD27C),
    );
  }
  if (id == 'literary-roaming') {
    return const _BadgePalette(
      Color(0xFF88D2E4),
      Color(0xFF326E9A),
      Color(0xFF163D6C),
      Color(0xFFE8F8FF),
    );
  }
  if (id == 'myth-tracing') {
    return const _BadgePalette(
      Color(0xFF5E6693),
      Color(0xFF2D315B),
      Color(0xFF161936),
      Color(0xFFFFE4A0),
    );
  }
  if (id == 'strange-night-talks') {
    return const _BadgePalette(
      Color(0xFF8F615C),
      Color(0xFF472D35),
      Color(0xFF211922),
      Color(0xFFFF9C64),
    );
  }
  if (id == 'folk-secret-land') {
    return const _BadgePalette(
      Color(0xFF4B8795),
      Color(0xFF245264),
      Color(0xFF142E3B),
      Color(0xFFFFB84D),
    );
  }
  return const _BadgePalette(
    Color(0xFFE0AA72),
    Color(0xFF8E3E32),
    Color(0xFF4A1F1D),
    Color(0xFFFFD36D),
  );
}

class _JourneySymbolPainter extends CustomPainter {
  const _JourneySymbolPainter({required this.motif, required this.palette});

  final _JourneyMotif motif;
  final _BadgePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(s / 2, s / 2);
    final outer = Rect.fromCircle(center: center, radius: s * .49);
    final inner = Rect.fromCircle(center: center, radius: s * .405);

    canvas.drawCircle(
      center + Offset(0, s * .045),
      s * .455,
      Paint()
        ..color = Colors.black.withValues(alpha: .28)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .07),
    );
    canvas.drawCircle(
      center,
      s * .485,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0B6),
            Color(0xFFC68B34),
            Color(0xFFFFD87D),
            Color(0xFF82511E),
          ],
          stops: [0, .34, .62, 1],
        ).createShader(outer),
    );
    canvas.drawCircle(center, s * .435, Paint()..color = const Color(0xFF5A321A));

    canvas.save();
    canvas.clipPath(Path()..addOval(inner));
    canvas.drawRect(
      inner,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.sky, palette.horizon],
        ).createShader(inner),
    );
    canvas.drawCircle(
      Offset(s * .67, s * .29),
      s * .115,
      Paint()
        ..color = palette.glow.withValues(alpha: .9)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .035),
    );
    _paintDistantLayers(canvas, s);
    _paintMotif(canvas, s);
    canvas.drawOval(
      Rect.fromLTWH(s * .15, s * .12, s * .35, s * .17),
      Paint()
        ..color = Colors.white.withValues(alpha: .24)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .035),
    );
    canvas.restore();

    canvas.drawCircle(
      center,
      s * .408,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, s * .025)
        ..color = const Color(0xFFFFE4A0).withValues(alpha: .88),
    );
    canvas.drawArc(
      outer.deflate(s * .025),
      math.pi * 1.04,
      math.pi * .68,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = s * .035
        ..color = Colors.white.withValues(alpha: .52),
    );
  }

  void _paintDistantLayers(Canvas canvas, double s) {
    final back = Path()
      ..moveTo(s * .08, s * .60)
      ..lineTo(s * .28, s * .36)
      ..lineTo(s * .41, s * .52)
      ..lineTo(s * .57, s * .32)
      ..lineTo(s * .84, s * .60)
      ..lineTo(s * .95, s * .68)
      ..lineTo(s * .95, s * .84)
      ..lineTo(s * .08, s * .84)
      ..close();
    canvas.drawPath(back, Paint()..color = palette.ink.withValues(alpha: .23));
    canvas.drawOval(
      Rect.fromLTWH(s * .08, s * .69, s * .85, s * .28),
      Paint()..color = palette.ink.withValues(alpha: .28),
    );
  }

  void _paintMotif(Canvas canvas, double s) {
    switch (motif) {
      case _JourneyMotif.palace:
      case _JourneyMotif.ancestralHall:
        _paintRoof(canvas, s, ornate: motif == _JourneyMotif.ancestralHall);
        break;
      case _JourneyMotif.pavilion:
        _paintPavilion(canvas, s);
        break;
      case _JourneyMotif.skyline:
        _paintSkyline(canvas, s);
        break;
      case _JourneyMotif.cityWall:
        _paintCityWall(canvas, s);
        break;
      case _JourneyMotif.lakeBridge:
        _paintLakeBridge(canvas, s);
        break;
      case _JourneyMotif.alley:
        _paintAlley(canvas, s);
        break;
      case _JourneyMotif.lanternBoat:
        _paintLanternBoat(canvas, s);
        break;
      case _JourneyMotif.butterfly:
        _paintButterfly(canvas, s);
        break;
      case _JourneyMotif.moonScroll:
        _paintMoonScroll(canvas, s);
        break;
      case _JourneyMotif.shadowInn:
        _paintShadowInn(canvas, s);
        break;
      case _JourneyMotif.riverLantern:
        _paintRiverLantern(canvas, s);
        break;
    }
  }

  Paint _ink() => Paint()
    ..color = palette.ink
    ..style = PaintingStyle.fill
    ..strokeJoin = StrokeJoin.round;

  void _paintRoof(Canvas canvas, double s, {bool ornate = false}) {
    final ink = _ink();
    final roof = Path()
      ..moveTo(s * .19, s * .58)
      ..quadraticBezierTo(s * .31, s * .55, s * .36, s * .43)
      ..lineTo(s * .64, s * .43)
      ..quadraticBezierTo(s * .69, s * .55, s * .82, s * .58)
      ..quadraticBezierTo(s * .68, s * .61, s * .50, s * .55)
      ..quadraticBezierTo(s * .32, s * .61, s * .19, s * .58)
      ..close();
    canvas.drawPath(roof, ink);
    canvas.drawRect(Rect.fromLTWH(s * .31, s * .58, s * .38, s * .22), ink);
    for (final x in [.37, .50, .63]) {
      canvas.drawRect(
        Rect.fromLTWH(s * x - s * .018, s * .59, s * .036, s * .21),
        Paint()..color = palette.glow.withValues(alpha: .68),
      );
    }
    if (ornate) {
      canvas.drawCircle(Offset(s * .50, s * .40), s * .035, ink);
    }
  }

  void _paintPavilion(Canvas canvas, double s) {
    _paintRoof(canvas, s);
    canvas.drawOval(
      Rect.fromLTWH(s * .12, s * .76, s * .76, s * .10),
      Paint()..color = palette.glow.withValues(alpha: .25),
    );
  }

  void _paintSkyline(Canvas canvas, double s) {
    final ink = _ink();
    canvas.drawRect(Rect.fromLTWH(s * .21, s * .55, s * .13, s * .28), ink);
    canvas.drawRect(Rect.fromLTWH(s * .39, s * .47, s * .15, s * .36), ink);
    canvas.drawRect(Rect.fromLTWH(s * .59, s * .37, s * .10, s * .46), ink);
    canvas.drawRect(Rect.fromLTWH(s * .735, s * .50, s * .09, s * .33), ink);
    canvas.drawLine(
      Offset(s * .64, s * .24),
      Offset(s * .64, s * .39),
      Paint()
        ..color = palette.glow
        ..strokeWidth = s * .025,
    );
    for (final x in [.25, .44, .63, .77]) {
      canvas.drawCircle(
        Offset(s * x, s * .64),
        s * .015,
        Paint()..color = palette.glow,
      );
    }
  }

  void _paintCityWall(Canvas canvas, double s) {
    final ink = _ink();
    canvas.drawRect(Rect.fromLTWH(s * .20, s * .58, s * .60, s * .23), ink);
    for (final x in [.20, .32, .56, .68]) {
      canvas.drawRect(Rect.fromLTWH(s * x, s * .51, s * .12, s * .10), ink);
    }
    canvas.drawArc(
      Rect.fromLTWH(s * .40, s * .65, s * .20, s * .22),
      math.pi,
      math.pi,
      true,
      Paint()..color = palette.glow.withValues(alpha: .7),
    );
  }

  void _paintLakeBridge(Canvas canvas, double s) {
    final stroke = Paint()
      ..color = palette.ink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = s * .075;
    canvas.drawArc(
      Rect.fromLTWH(s * .18, s * .47, s * .64, s * .44),
      math.pi,
      math.pi,
      false,
      stroke,
    );
    canvas.drawLine(Offset(s * .17, s * .70), Offset(s * .83, s * .70), stroke);
    canvas.drawLine(
      Offset(s * .22, s * .79),
      Offset(s * .78, s * .79),
      Paint()
        ..color = palette.glow.withValues(alpha: .45)
        ..strokeWidth = s * .025,
    );
  }

  void _paintAlley(Canvas canvas, double s) {
    final ink = _ink();
    final left = Path()
      ..moveTo(s * .16, s * .52)
      ..lineTo(s * .40, s * .39)
      ..lineTo(s * .42, s * .82)
      ..lineTo(s * .18, s * .82)
      ..close();
    final right = Path()
      ..moveTo(s * .84, s * .52)
      ..lineTo(s * .60, s * .39)
      ..lineTo(s * .58, s * .82)
      ..lineTo(s * .82, s * .82)
      ..close();
    canvas.drawPath(left, ink);
    canvas.drawPath(right, ink);
    canvas.drawPath(
      Path()
        ..moveTo(s * .43, s * .82)
        ..lineTo(s * .50, s * .55)
        ..lineTo(s * .57, s * .82)
        ..close(),
      Paint()..color = palette.glow.withValues(alpha: .58),
    );
  }

  void _paintLanternBoat(Canvas canvas, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(s * .18, s * .70)
        ..quadraticBezierTo(s * .50, s * .89, s * .82, s * .70)
        ..lineTo(s * .73, s * .82)
        ..lineTo(s * .29, s * .82)
        ..close(),
      _ink(),
    );
    canvas.drawLine(
      Offset(s * .50, s * .42),
      Offset(s * .50, s * .72),
      Paint()
        ..color = palette.ink
        ..strokeWidth = s * .035,
    );
    canvas.drawCircle(
      Offset(s * .50, s * .50),
      s * .10,
      Paint()
        ..color = palette.glow
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .025),
    );
  }

  void _paintButterfly(Canvas canvas, double s) {
    final wings = Paint()
      ..shader = RadialGradient(
        colors: [palette.glow, const Color(0xFF63C6E5), palette.ink],
      ).createShader(Rect.fromLTWH(s * .18, s * .28, s * .64, s * .52));
    final path = Path()
      ..moveTo(s * .49, s * .58)
      ..cubicTo(s * .30, s * .28, s * .12, s * .38, s * .27, s * .63)
      ..cubicTo(s * .13, s * .76, s * .34, s * .84, s * .49, s * .65)
      ..moveTo(s * .51, s * .58)
      ..cubicTo(s * .70, s * .28, s * .88, s * .38, s * .73, s * .63)
      ..cubicTo(s * .87, s * .76, s * .66, s * .84, s * .51, s * .65);
    canvas.drawPath(path, wings);
    canvas.drawOval(Rect.fromLTWH(s * .47, s * .45, s * .06, s * .30), _ink());
  }

  void _paintMoonScroll(Canvas canvas, double s) {
    canvas.drawCircle(
      Offset(s * .50, s * .42),
      s * .22,
      Paint()
        ..color = palette.glow
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .025),
    );
    final scroll = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * .27, s * .57, s * .46, s * .24),
      Radius.circular(s * .045),
    );
    canvas.drawRRect(scroll, Paint()..color = const Color(0xFFFFE5A7));
    for (final y in [.63, .69, .75]) {
      canvas.drawLine(
        Offset(s * .35, s * y),
        Offset(s * .65, s * y),
        Paint()
          ..color = palette.ink.withValues(alpha: .64)
          ..strokeWidth = s * .018,
      );
    }
  }

  void _paintShadowInn(Canvas canvas, double s) {
    _paintRoof(canvas, s);
    canvas.drawCircle(
      Offset(s * .50, s * .69),
      s * .065,
      Paint()
        ..color = palette.glow
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .035),
    );
  }

  void _paintRiverLantern(Canvas canvas, double s) {
    for (var i = 0; i < 3; i++) {
      final y = s * (.66 + i * .07);
      canvas.drawArc(
        Rect.fromLTWH(s * .14, y, s * .72, s * .08),
        0,
        math.pi,
        false,
        Paint()
          ..color = Colors.white.withValues(alpha: .36 - i * .07)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * .018,
      );
    }
    final lantern = Path()
      ..moveTo(s * .50, s * .35)
      ..lineTo(s * .64, s * .57)
      ..lineTo(s * .50, s * .70)
      ..lineTo(s * .36, s * .57)
      ..close();
    canvas.drawPath(
      lantern,
      Paint()
        ..color = palette.glow
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .025),
    );
    canvas.drawPath(
      lantern,
      Paint()
        ..color = const Color(0xFFFFD66B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * .025,
    );
  }

  @override
  bool shouldRepaint(covariant _JourneySymbolPainter oldDelegate) =>
      oldDelegate.motif != motif || oldDelegate.palette != palette;
}
