import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/journey_background.dart';
import 'special_realm_cinematic_overlay.dart';

class SpecialRealmBackground extends StatefulWidget {
  const SpecialRealmBackground({
    super.key,
    required this.journeyId,
    required this.pageType,
    required this.child,
    required this.scrimStrength,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final Widget child;
  final double scrimStrength;

  static const supportedJourneyIds = <String>{
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  };

  static bool supports(String journeyId) {
    return supportedJourneyIds.contains(journeyId);
  }

  @override
  State<SpecialRealmBackground> createState() => _SpecialRealmBackgroundState();
}

class _SpecialRealmBackgroundState extends State<SpecialRealmBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _motion.stop();
      _motion.value = .42;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('special-realm-background-${widget.journeyId}'),
      child: AnimatedBuilder(
        animation: _motion,
        builder: (context, _) => Stack(
          fit: StackFit.expand,
          children: [
            _PremiumRealmPlate(
              journeyId: widget.journeyId,
              pageType: widget.pageType,
              progress: _motion.value,
            ),
            // The premium plates for Dream Butterfly and Upstream Lantern
            // already carry their story detail. Keep them calm and readable:
            // the old procedural overlay added a synthetic butterfly, lotus,
            // and dark foreground shapes that obscured the finished artwork.
            if (widget.journeyId != 'literary-roaming' &&
                widget.journeyId != 'folk-secret-land')
              SpecialRealmCinematicOverlay(
                journeyId: widget.journeyId,
                pageType: widget.pageType,
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: widget.scrimStrength * .35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: widget.scrimStrength * .92),
                  ],
                  stops: const [0, .46, 1],
                ),
              ),
            ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _PremiumRealmPlate extends StatelessWidget {
  const _PremiumRealmPlate({
    required this.journeyId,
    required this.pageType,
    required this.progress,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final double progress;

  static const _assets = <String, List<String>>{
    'literary-roaming': [
      'assets/images/special-realms/dream-butterfly-v3.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-02.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-03.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-04.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-05.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-06.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-07.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-08.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-09.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-10.webp',
    ],
    'myth-tracing': [
      'assets/images/special-realms/moon-letter-v2.webp',
      'assets/images/special-realms/ten-scene/moon-letter-02.webp',
      'assets/images/special-realms/ten-scene/moon-letter-03.webp',
      'assets/images/special-realms/ten-scene/moon-letter-04.webp',
      'assets/images/special-realms/ten-scene/moon-letter-05.webp',
      'assets/images/special-realms/ten-scene/moon-letter-06.webp',
      'assets/images/special-realms/ten-scene/moon-letter-07.webp',
      'assets/images/special-realms/ten-scene/moon-letter-08.webp',
      'assets/images/special-realms/ten-scene/moon-letter-09.webp',
      'assets/images/special-realms/ten-scene/moon-letter-10.webp',
    ],
    'strange-night-talks': [
      'assets/images/special-realms/shadowless-inn-v2.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-02.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-03.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-04.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-05.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-06.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-07.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-08.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-09.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-10.webp',
    ],
    'folk-secret-land': [
      'assets/images/special-realms/upstream-lantern-v3.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-02.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-03.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-04.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-05.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-06.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-07.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-08.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-09.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-10.webp',
    ],
  };

  int get _assetIndex {
    return switch (pageType) {
      JourneyBackgroundPage.story =>
          1 + (progress * 3).floor().clamp(0, 2).toInt(),
      JourneyBackgroundPage.vocabulary => 4,
      JourneyBackgroundPage.discovery => 5,
      JourneyBackgroundPage.reflection => 6,
      JourneyBackgroundPage.writing => 7,
      JourneyBackgroundPage.memory => 8,
      JourneyBackgroundPage.completion => 9,
      _ => 0,
    };
  }

  double get _chapter =>
      JourneyBackgroundPage.values.indexOf(pageType) /
      (JourneyBackgroundPage.values.length - 1);

  @override
  Widget build(BuildContext context) {
    final phase = progress * math.pi * 2;
    final chapterTravel = (_chapter - .5) * 18;
    final horizontalDrift = switch (journeyId) {
      'literary-roaming' => math.sin(phase) * 5,
      'myth-tracing' => math.cos(phase * .7) * 4,
      'strange-night-talks' => math.sin(phase * .55) * 3,
      'folk-secret-land' => math.sin(phase * .8) * 6,
      _ => 0.0,
    };
    final verticalDrift = switch (journeyId) {
      'literary-roaming' => chapterTravel + math.cos(phase * .7) * 4,
      'myth-tracing' => -chapterTravel + math.sin(phase * .6) * 3,
      'strange-night-talks' => chapterTravel * .45,
      'folk-secret-land' => -chapterTravel * .55 + math.cos(phase * .5) * 3,
      _ => 0.0,
    };
    final scale = 1.08 + _chapter * .035 + math.sin(phase * .5) * .004;
    final tone = switch (pageType) {
      JourneyBackgroundPage.story => const Color(0x0DFFF0CD),
      JourneyBackgroundPage.vocabulary => const Color(0x0A9BD9FF),
      JourneyBackgroundPage.discovery => const Color(0x0FFFF1B8),
      JourneyBackgroundPage.reflection => const Color(0x123C7DFF),
      JourneyBackgroundPage.memory => const Color(0x0FE8A4FF),
      JourneyBackgroundPage.completion => const Color(0x16FFD36B),
      _ => Colors.transparent,
    };

    return ClipRect(
      child: Transform.translate(
        offset: Offset(horizontalDrift, verticalDrift),
        child: Transform.scale(
          scale: scale,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _assets[journeyId]![_assetIndex],
                fit: BoxFit.cover,
                alignment: _alignmentForChapter,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
              ),
              ColoredBox(color: tone),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .04 + _chapter * .02),
                      Colors.transparent,
                      Colors.black.withValues(alpha: .16),
                    ],
                    stops: const [0, .56, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Alignment get _alignmentForChapter {
    final y = -.18 + _chapter * .34;
    return switch (journeyId) {
      'literary-roaming' => Alignment(.1 - _chapter * .18, y),
      'myth-tracing' => Alignment(.18 - _chapter * .22, y),
      'strange-night-talks' => Alignment(.12 - _chapter * .14, y),
      'folk-secret-land' => Alignment(-.08 + _chapter * .16, y),
      _ => Alignment(0, y),
    };
  }
}

// Kept as a fallback for devices that cannot decode the premium WebP plates.
// ignore: unused_element
class _SpecialRealmPainter extends CustomPainter {
  const _SpecialRealmPainter({
    required this.journeyId,
    required this.pageType,
    required this.progress,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final double progress;

  double get _chapter =>
      JourneyBackgroundPage.values.indexOf(pageType) /
      (JourneyBackgroundPage.values.length - 1);

  @override
  void paint(Canvas canvas, Size size) {
    switch (journeyId) {
      case 'literary-roaming':
        _paintDreamButterfly(canvas, size);
        return;
      case 'myth-tracing':
        _paintMoonLetter(canvas, size);
        return;
      case 'strange-night-talks':
        _paintShadowlessInn(canvas, size);
        return;
      case 'folk-secret-land':
        _paintUpstreamLantern(canvas, size);
        return;
    }
  }

  void _paintDreamButterfly(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF102C4A),
          Color(0xFF315B72),
          Color(0xFFE5C58B),
          Color(0xFF486A54),
        ],
        stops: [0, .34, .7, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    _paintChapterLight(
      canvas,
      size,
      const Color(0xFF7CE4FF),
      Alignment(-.82 + _chapter * 1.64, -.62 + _chapter * .34),
    );

    final mist = Paint()
      ..shader = RadialGradient(
        center: Alignment(-.7 + .25 * math.sin(progress * math.pi * 2), -.55),
        radius: 1.2,
        colors: [
          const Color(0xFFFFEBC5).withValues(alpha: .34),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, mist);

    final bamboo = Paint()
      ..color = const Color(0xFF102D27).withValues(alpha: .78)
      ..strokeWidth = math.max(5, size.width * .018)
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 9; index++) {
      final x = size.width * (-.05 + index * .135);
      final sway = math.sin(progress * math.pi * 2 + index) * 5;
      canvas.drawLine(
        Offset(x + sway, size.height * 1.03),
        Offset(x - 18 + sway, size.height * .08),
        bamboo,
      );
      for (var node = 1; node < 6; node++) {
        final y = size.height * (1 - node * .15);
        canvas.drawLine(
          Offset(x + sway - node * 3, y),
          Offset(x + sway + 30, y - 22),
          bamboo..strokeWidth = 2.2,
        );
        bamboo.strokeWidth = math.max(5, size.width * .018);
      }
    }

    final pathPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFEAD3A1).withValues(alpha: .05),
          const Color(0xFFEAD3A1).withValues(alpha: .72),
        ],
      ).createShader(Offset.zero & size);
    final path = Path()
      ..moveTo(size.width * .48, size.height * .48)
      ..cubicTo(
        size.width * .43,
        size.height * .63,
        size.width * .63,
        size.height * .76,
        size.width * .18,
        size.height * 1.05,
      )
      ..lineTo(size.width * .82, size.height * 1.05)
      ..cubicTo(
        size.width * .65,
        size.height * .78,
        size.width * .58,
        size.height * .64,
        size.width * .52,
        size.height * .48,
      )
      ..close();
    canvas.drawPath(path, pathPaint);

    for (var index = 0; index < 18; index++) {
      final phase = (progress + index / 13) % 1;
      final x = size.width * (.12 + .75 * ((index * .37 + phase * .22) % 1));
      final y = size.height * (.15 + .62 * ((index * .23 + phase) % 1));
      final scale =
          3.5 + _chapter * 4 + 4 * math.sin((phase + index) * math.pi).abs();
      _paintButterfly(
        canvas,
        Offset(x, y),
        scale,
        const Color(0xFF78C8F0).withValues(alpha: .72),
        math.sin(progress * math.pi * 10 + index) * .5,
      );
    }
  }

  void _paintMoonLetter(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF071426), Color(0xFF192D52), Color(0xFF5D5064)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);
    _paintChapterLight(
      canvas,
      size,
      const Color(0xFFFFE5A0),
      Alignment(.78 - _chapter * 1.15, -.72 + _chapter * .42),
    );

    final moonCenter = Offset(
      size.width * (.68 + .018 * math.sin(progress * math.pi * 2)),
      size.height * .22,
    );
    final moonRadius = size.width * (.19 + _chapter * .07);
    canvas.drawCircle(
      moonCenter,
      moonRadius * 1.45,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                const Color(0xFFFFF1B7).withValues(alpha: .32),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: moonCenter, radius: moonRadius * 1.45),
            ),
    );
    canvas.drawCircle(
      moonCenter,
      moonRadius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-.35, -.35),
          colors: [Color(0xFFFFF8DB), Color(0xFFE4D2A7), Color(0xFFB7A57E)],
        ).createShader(Rect.fromCircle(center: moonCenter, radius: moonRadius)),
    );

    final mountain = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .2,
        size.height * .55,
        size.width * .38,
        size.height * .75,
      )
      ..quadraticBezierTo(
        size.width * .62,
        size.height * .48,
        size.width,
        size.height * .76,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      mountain,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF203044), Color(0xFF09131E)],
        ).createShader(Offset.zero & size),
    );

    final branch = Paint()
      ..color = const Color(0xFF17140E).withValues(alpha: .9)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-20, size.height * .18),
      Offset(size.width * .54, size.height * .46),
      branch,
    );
    for (var index = 0; index < 8; index++) {
      final start = Offset(
        size.width * (.03 + index * .065),
        size.height * (.2 + index * .03),
      );
      final end = start + Offset(36 + index * 2, index.isEven ? -48 : 38);
      canvas.drawLine(start, end, branch..strokeWidth = 2.6);
      for (var flower = 0; flower < 4; flower++) {
        final t = (flower + 1) / 5;
        final point = Offset.lerp(start, end, t)!;
        canvas.drawCircle(
          point,
          2.3,
          Paint()..color = const Color(0xFFFFD46B).withValues(alpha: .8),
        );
      }
    }

    for (var index = 0; index < 30; index++) {
      final phase = (progress * .35 + index / 30) % 1;
      final x = size.width * ((index * .618 + .1 * math.sin(index)) % 1);
      final y = size.height * (phase * 1.08 - .04);
      canvas.drawCircle(
        Offset(x, y),
        1.3 + (index % 3) * .7,
        Paint()
          ..color = const Color(
            0xFFFFD46B,
          ).withValues(alpha: .18 + .46 * math.sin(phase * math.pi).abs()),
      );
    }

    final doorRect = Rect.fromCenter(
      center: Offset(size.width * .5, size.height * .56),
      width: size.width * .16,
      height: size.height * .23,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(doorRect, const Radius.circular(40)),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF3C7).withValues(alpha: .76),
            const Color(0xFF93B8D6).withValues(alpha: .24),
            Colors.transparent,
          ],
        ).createShader(doorRect.inflate(24)),
    );
  }

  void _paintShadowlessInn(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF080B12), Color(0xFF17202B), Color(0xFF0E1215)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);
    _paintChapterLight(
      canvas,
      size,
      _chapter > .58 ? const Color(0xFF9DCBFF) : const Color(0xFFFF6A3D),
      Alignment(.72 - _chapter * 1.42, -.2 + _chapter * .65),
    );

    final innBody = Rect.fromLTWH(
      size.width * .08,
      size.height * .34,
      size.width * .84,
      size.height * .62,
    );
    canvas.drawRect(innBody, Paint()..color = const Color(0xFF241914));

    final roof = Path()
      ..moveTo(size.width * .01, size.height * .38)
      ..quadraticBezierTo(
        size.width * .5,
        size.height * .2,
        size.width * .99,
        size.height * .38,
      )
      ..lineTo(size.width * .88, size.height * .43)
      ..quadraticBezierTo(
        size.width * .5,
        size.height * .31,
        size.width * .12,
        size.height * .43,
      )
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFF0B0A0A));

    final door = Rect.fromLTWH(
      size.width * .39,
      size.height * .53,
      size.width * .22,
      size.height * .43,
    );
    canvas.drawRect(door, Paint()..color = const Color(0xFF080707));
    canvas.drawRect(
      door.deflate(5),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF5A2B21).withValues(alpha: .2), Colors.black],
        ).createShader(door),
    );

    final lanternCenter = Offset(size.width * .72, size.height * .5);
    canvas.drawCircle(
      lanternCenter,
      size.width * .17,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                const Color(0xFFFF7A3A).withValues(alpha: .35),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: lanternCenter, radius: size.width * .17),
            ),
    );
    final lanternRect = Rect.fromCenter(
      center: lanternCenter,
      width: size.width * .09,
      height: size.height * .13,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(lanternRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFFD64A2F).withValues(alpha: .85),
    );
    canvas.drawLine(
      Offset(lanternCenter.dx, size.height * .35),
      Offset(lanternCenter.dx, lanternRect.top),
      Paint()
        ..color = const Color(0xFF17100D)
        ..strokeWidth = 2,
    );

    final rain = Paint()
      ..color = const Color(0xFFA8C8DD).withValues(alpha: .22)
      ..strokeWidth = 1.2;
    for (var index = 0; index < 80 + (_chapter * 55).round(); index++) {
      final x = size.width * ((index * .618 + progress * .34) % 1);
      final y = size.height * ((index * .347 + progress * 1.8) % 1);
      canvas.drawLine(Offset(x, y), Offset(x - 6, y + 18), rain);
    }

    final footprint = Paint()
      ..color = const Color(0xFF9FB2B5).withValues(alpha: .17);
    for (var index = 0; index < 6; index++) {
      final y = size.height * (.93 - index * .08);
      final x = size.width * (.5 + (index.isEven ? -.035 : .035));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(index.isEven ? -.12 : .12);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 13, height: 25),
        footprint,
      );
      canvas.restore();
    }
  }

  void _paintUpstreamLantern(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF130D25), Color(0xFF35234F), Color(0xFF261534)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);
    _paintChapterLight(
      canvas,
      size,
      const Color(0xFFFF9A5A),
      Alignment(-.72 + _chapter * 1.44, .62 - _chapter * .78),
    );

    final farBank = Path()
      ..moveTo(0, size.height * .34)
      ..quadraticBezierTo(
        size.width * .22,
        size.height * .27,
        size.width * .45,
        size.height * .35,
      )
      ..quadraticBezierTo(
        size.width * .74,
        size.height * .23,
        size.width,
        size.height * .34,
      )
      ..lineTo(size.width, size.height * .44)
      ..lineTo(0, size.height * .44)
      ..close();
    canvas.drawPath(farBank, Paint()..color = const Color(0xFF120E17));

    final riverRect = Rect.fromLTWH(
      0,
      size.height * .37,
      size.width,
      size.height * .63,
    );
    canvas.drawRect(
      riverRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2844), Color(0xFF151328), Color(0xFF070A15)],
        ).createShader(riverRect),
    );

    final waterLine = Paint()
      ..color = const Color(0xFFB7A5D8).withValues(alpha: .12)
      ..strokeWidth = 1;
    for (var line = 0; line < 18; line++) {
      final y = size.height * (.4 + line * .035);
      final offset = math.sin(progress * math.pi * 2 + line) * 24;
      canvas.drawLine(
        Offset(size.width * .06 + offset, y),
        Offset(size.width * .72 + offset, y),
        waterLine,
      );
    }

    for (var index = 0; index < 28 + (_chapter * 18).round(); index++) {
      final downstream = (progress * .18 + index / 28) % 1;
      final perspective = .38 + .58 * downstream;
      final x = size.width * ((index * .357 + downstream * .28) % 1);
      final y = size.height * (.42 + .52 * downstream);
      _paintLantern(
        canvas,
        Offset(x, y),
        3.5 + 8 * perspective,
        const Color(0xFFFFB04E).withValues(alpha: .38 + .4 * perspective),
      );
    }

    final reverse = (1 - progress * .25) % 1;
    final specialCenter = Offset(
      size.width * (.5 + .08 * math.sin(progress * math.pi * 2)),
      size.height * (.72 - .18 * reverse),
    );
    canvas.drawCircle(
      specialCenter,
      size.width * .22,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                const Color(0xFFFF7A42).withValues(alpha: .28),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: specialCenter, radius: size.width * .22),
            ),
    );
    _paintLantern(canvas, specialCenter, 22, const Color(0xFFFF7442));

    final reflection = Path()
      ..moveTo(specialCenter.dx - 10, specialCenter.dy + 18)
      ..quadraticBezierTo(
        specialCenter.dx - 34,
        specialCenter.dy + 70,
        specialCenter.dx - 8,
        size.height,
      )
      ..lineTo(specialCenter.dx + 14, size.height)
      ..quadraticBezierTo(
        specialCenter.dx + 38,
        specialCenter.dy + 70,
        specialCenter.dx + 10,
        specialCenter.dy + 18,
      )
      ..close();
    canvas.drawPath(
      reflection,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFF7543).withValues(alpha: .3),
            Colors.transparent,
          ],
        ).createShader(reflection.getBounds()),
    );
  }

  void _paintChapterLight(
    Canvas canvas,
    Size size,
    Color color,
    Alignment center,
  ) {
    final pulse = .86 + .14 * math.sin(progress * math.pi * 2);
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: center,
          radius: .48 + _chapter * .32,
          colors: [
            color.withValues(alpha: (.16 + _chapter * .18) * pulse),
            color.withValues(alpha: .035),
            Colors.transparent,
          ],
          stops: const [0, .48, 1],
        ).createShader(rect),
    );
  }

  void _paintButterfly(
    Canvas canvas,
    Offset center,
    double scale,
    Color color,
    double rotation,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final wing = Paint()..color = color;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-scale * .55, 0),
        width: scale,
        height: scale * .72,
      ),
      wing,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(scale * .55, 0),
        width: scale,
        height: scale * .72,
      ),
      wing,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: scale * .18,
        height: scale * .9,
      ),
      Paint()..color = color.withValues(alpha: .9),
    );
    canvas.restore();
  }

  void _paintLantern(Canvas canvas, Offset center, double size, Color color) {
    final glowRect = Rect.fromCircle(center: center, radius: size * 2.8);
    canvas.drawCircle(
      center,
      size * 2.8,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: .28), Colors.transparent],
        ).createShader(glowRect),
    );
    final body = Rect.fromCenter(
      center: center,
      width: size * .9,
      height: size * .7,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(size * .12)),
      Paint()..color = color.withValues(alpha: .86),
    );
    canvas.drawLine(
      Offset(body.left, body.top),
      Offset(body.right, body.top),
      Paint()
        ..color = const Color(0xFF2B1510).withValues(alpha: .8)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _SpecialRealmPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.journeyId != journeyId ||
        oldDelegate.pageType != pageType;
  }
}
