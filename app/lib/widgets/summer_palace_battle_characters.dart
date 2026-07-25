part of 'summer_palace_journey_arsenal.dart';

class _PhoenixCharacter extends StatelessWidget {
  const _PhoenixCharacter({
    required this.progress,
    required this.size,
    this.charged = false,
  });

  final double progress;
  final double size;
  final bool charged;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _PhoenixWuxiaPainter(
          progress: progress,
          charged: charged,
        ),
      ),
    );
  }
}

class _PhoenixWuxiaPainter extends CustomPainter {
  const _PhoenixWuxiaPainter({required this.progress, required this.charged});

  final double progress;
  final bool charged;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .5);
    final pulse = 1 + math.sin(progress * math.pi * 2) * .04;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(pulse);
    canvas.translate(-center.dx, -center.dy);

    final aura = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE7C07B).withValues(alpha: charged ? .32 : .13),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * .48));
    canvas.drawCircle(center, size.width * .47, aura);

    final ink = Paint()
      ..color = const Color(0xFF191714)
      ..style = PaintingStyle.fill;
    final cinnabar = Paint()
      ..color = const Color(0xFF9A322C)
      ..style = PaintingStyle.fill;
    final gold = Paint()
      ..color = const Color(0xFFE7C07B)
      ..style = PaintingStyle.fill;
    final pale = Paint()
      ..color = const Color(0xFFFFE7B7)
      ..style = PaintingStyle.fill;

    final wingLift = math.sin(progress * math.pi * 2) * size.width * .035;
    final leftWing = Path()
      ..moveTo(size.width * .43, size.height * .46)
      ..quadraticBezierTo(
        size.width * .16,
        size.height * (.24 + wingLift / size.height),
        size.width * .11,
        size.height * .58,
      )
      ..quadraticBezierTo(
        size.width * .25,
        size.height * .48,
        size.width * .43,
        size.height * .61,
      )
      ..close();
    final rightWing = Path()
      ..moveTo(size.width * .57, size.height * .46)
      ..quadraticBezierTo(
        size.width * .84,
        size.height * (.24 - wingLift / size.height),
        size.width * .89,
        size.height * .58,
      )
      ..quadraticBezierTo(
        size.width * .75,
        size.height * .48,
        size.width * .57,
        size.height * .61,
      )
      ..close();
    canvas.drawPath(leftWing, cinnabar);
    canvas.drawPath(rightWing, cinnabar);

    final cloak = Path()
      ..moveTo(size.width * .36, size.height * .45)
      ..quadraticBezierTo(
        size.width * .26,
        size.height * .71,
        size.width * .34,
        size.height * .86,
      )
      ..lineTo(size.width * .5, size.height * .74)
      ..lineTo(size.width * .66, size.height * .86)
      ..quadraticBezierTo(
        size.width * .74,
        size.height * .71,
        size.width * .64,
        size.height * .45,
      )
      ..close();
    canvas.drawPath(cloak, ink);

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .57),
        width: size.width * .28,
        height: size.height * .38,
      ),
      Radius.circular(size.width * .15),
    );
    canvas.drawRRect(body, gold);

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .32),
      size.width * .14,
      pale,
    );
    final beak = Path()
      ..moveTo(size.width * .61, size.height * .31)
      ..lineTo(size.width * .74, size.height * .36)
      ..lineTo(size.width * .61, size.height * .4)
      ..close();
    canvas.drawPath(beak, gold);
    canvas.drawCircle(
      Offset(size.width * .55, size.height * .3),
      size.width * .018,
      ink,
    );

    final headband = Paint()
      ..color = const Color(0xFF9A322C)
      ..strokeWidth = size.width * .035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .39, size.height * .24),
      Offset(size.width * .62, size.height * .24),
      headband,
    );
    final ribbon = Path()
      ..moveTo(size.width * .41, size.height * .25)
      ..quadraticBezierTo(
        size.width * .17,
        size.height * (.3 + math.sin(progress * math.pi * 2) * .03),
        size.width * .12,
        size.height * .17,
      );
    canvas.drawPath(
      ribbon,
      Paint()
        ..color = const Color(0xFF9A322C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .035
        ..strokeCap = StrokeCap.round,
    );

    final sword = Paint()
      ..color = const Color(0xFFFFE7B7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .025
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .62, size.height * .5),
      Offset(size.width * .82, size.height * .73),
      sword,
    );
    canvas.drawLine(
      Offset(size.width * .67, size.height * .58),
      Offset(size.width * .73, size.height * .52),
      sword,
    );

    if (charged) {
      final sparkPaint = Paint()..color = const Color(0xFFFFE7B7);
      for (var index = 0; index < 6; index++) {
        final angle = progress * math.pi * 2 + index * math.pi / 3;
        final point = Offset(
          center.dx + math.cos(angle) * size.width * .43,
          center.dy + math.sin(angle) * size.height * .43,
        );
        canvas.drawCircle(point, size.width * .025, sparkPaint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhoenixWuxiaPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.charged != charged;
}

class _BeastCharacter extends StatelessWidget {
  const _BeastCharacter({
    required this.progress,
    required this.armor,
    required this.size,
    this.hit = false,
    this.countering = false,
  });

  final double progress;
  final int armor;
  final double size;
  final bool hit;
  final bool countering;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _InkNightmarePainter(
          progress: progress,
          armor: armor,
          hit: hit,
          countering: countering,
        ),
      ),
    );
  }
}

class _InkNightmarePainter extends CustomPainter {
  const _InkNightmarePainter({
    required this.progress,
    required this.armor,
    required this.hit,
    required this.countering,
  });

  final double progress;
  final int armor;
  final bool hit;
  final bool countering;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .53);
    final shake = hit ? math.sin(progress * math.pi * 12) * size.width * .03 : 0.0;
    canvas.save();
    canvas.translate(shake, 0);

    final smoke = Paint()
      ..color = (countering ? const Color(0xFF8F3029) : const Color(0xFF26342F))
          .withValues(alpha: .23)
      ..style = PaintingStyle.fill;
    for (var index = 0; index < 5; index++) {
      final angle = progress * math.pi * 2 + index * 1.25;
      canvas.drawCircle(
        Offset(
          center.dx + math.cos(angle) * size.width * .31,
          center.dy + math.sin(angle) * size.height * .27,
        ),
        size.width * (.15 + index * .008),
        smoke,
      );
    }

    final ink = Paint()
      ..color = hit ? const Color(0xFF7A312A) : const Color(0xFF151714)
      ..style = PaintingStyle.fill;
    final body = Path()
      ..moveTo(size.width * .22, size.height * .43)
      ..quadraticBezierTo(
        size.width * .18,
        size.height * .18,
        size.width * .39,
        size.height * .2,
      )
      ..lineTo(size.width * .5, size.height * .08)
      ..lineTo(size.width * .61, size.height * .2)
      ..quadraticBezierTo(
        size.width * .82,
        size.height * .18,
        size.width * .78,
        size.height * .43,
      )
      ..quadraticBezierTo(
        size.width * .88,
        size.height * .69,
        size.width * .68,
        size.height * .86,
      )
      ..lineTo(size.width * .32, size.height * .86)
      ..quadraticBezierTo(
        size.width * .12,
        size.height * .69,
        size.width * .22,
        size.height * .43,
      )
      ..close();
    canvas.drawPath(body, ink);

    final hornPaint = Paint()
      ..color = const Color(0xFFC79B57)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .055
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * .19,
        size.height * .08,
        size.width * .3,
        size.height * .36,
      ),
      math.pi * 1.1,
      math.pi * .75,
      false,
      hornPaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * .51,
        size.height * .08,
        size.width * .3,
        size.height * .36,
      ),
      math.pi * 1.15,
      -math.pi * .75,
      false,
      hornPaint,
    );

    final eyePaint = Paint()
      ..color = countering
          ? const Color(0xFFFFE7B7)
          : const Color(0xFFE7C07B)
      ..style = PaintingStyle.fill;
    final eyeWidth = size.width * .12;
    final eyeHeight = size.height * .055;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .37, size.height * .44),
        width: eyeWidth,
        height: eyeHeight,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .63, size.height * .44),
        width: eyeWidth,
        height: eyeHeight,
      ),
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = const Color(0xFF8F3029)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .025
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .66),
        width: size.width * .28,
        height: size.height * .16,
      ),
      0,
      math.pi,
      false,
      mouthPaint,
    );

    for (var index = 0; index < armor; index++) {
      final x = index == 0 ? size.width * .18 : size.width * .82;
      final y = size.height * (.52 + math.sin(progress * math.pi * 2 + index) * .04);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * math.pi * 2 * (index == 0 ? 1 : -1));
      final sealRect = Rect.fromCenter(
        center: Offset.zero,
        width: size.width * .2,
        height: size.width * .2,
      );
      canvas.drawRect(
        sealRect,
        Paint()
          ..color = const Color(0xFF8F3029)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        sealRect,
        Paint()
          ..color = const Color(0xFFE7C07B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * .018,
      );
      canvas.drawLine(
        Offset(-size.width * .06, 0),
        Offset(size.width * .06, 0),
        Paint()
          ..color = const Color(0xFFFFE7B7)
          ..strokeWidth = size.width * .018,
      );
      canvas.drawLine(
        Offset(0, -size.width * .06),
        Offset(0, size.width * .06),
        Paint()
          ..color = const Color(0xFFFFE7B7)
          ..strokeWidth = size.width * .018,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InkNightmarePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.armor != armor ||
      oldDelegate.hit != hit ||
      oldDelegate.countering != countering;
}

class _WuxiaPanelPainter extends CustomPainter {
  const _WuxiaPanelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final mountainPaint = Paint()
      ..color = const Color(0xFFC79B57).withValues(alpha: .045)
      ..style = PaintingStyle.fill;
    final mountain = Path()
      ..moveTo(0, size.height * .78)
      ..lineTo(size.width * .18, size.height * .55)
      ..lineTo(size.width * .31, size.height * .72)
      ..lineTo(size.width * .49, size.height * .43)
      ..lineTo(size.width * .7, size.height * .71)
      ..lineTo(size.width * .86, size.height * .57)
      ..lineTo(size.width, size.height * .76)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mountain, mountainPaint);

    final cloudPaint = Paint()
      ..color = const Color(0xFFE7C07B).withValues(alpha: .035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (var row = 0; row < 4; row++) {
      final y = size.height * (.16 + row * .2);
      final cloud = Path()..moveTo(-20, y);
      for (var x = -20.0; x <= size.width + 20; x += 16) {
        cloud.quadraticBezierTo(x + 8, y - 5, x + 16, y);
      }
      canvas.drawPath(cloud, cloudPaint);
    }

    final sealPaint = Paint()
      ..color = const Color(0xFF8F3029).withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.save();
    canvas.translate(size.width * .84, size.height * .12);
    canvas.rotate(-.12);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 48, height: 48),
      sealPaint,
    );
    canvas.drawCircle(Offset.zero, 14, sealPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArenaLinesPainter extends CustomPainter {
  const _ArenaLinesPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final mountainPaint = Paint()
      ..color = const Color(0xFFC79B57).withValues(alpha: .1)
      ..style = PaintingStyle.fill;
    final mountains = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * .15, size.height * .62)
      ..lineTo(size.width * .28, size.height * .78)
      ..lineTo(size.width * .46, size.height * .48)
      ..lineTo(size.width * .62, size.height * .76)
      ..lineTo(size.width * .8, size.height * .58)
      ..lineTo(size.width, size.height * .8)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(mountains, mountainPaint);

    final cloudPaint = Paint()
      ..color = const Color(0xFFFFE7B7).withValues(alpha: .1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 3; index++) {
      final y = size.height * (.22 + index * .22);
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += 14) {
        final wave = math.sin(x / 30 + progress * math.pi * 2 + index) * 2.4;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, cloudPaint);
    }

    final swordPaint = Paint()
      ..color = const Color(0xFFE7C07B).withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final travel = (progress * (size.width + 120)) - 60;
    canvas.drawLine(
      Offset(travel - 45, size.height * .36),
      Offset(travel + 45, size.height * .28),
      swordPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArenaLinesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
