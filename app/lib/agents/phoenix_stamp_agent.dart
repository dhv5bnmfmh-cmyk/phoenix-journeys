import 'package:flutter/material.dart';

class PhoenixStampAgent {
  PhoenixStampAgent({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 1850),
  }) : controller = AnimationController(vsync: vsync, duration: duration) {
    pressOffset = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -215.0, end: 20.0).chain(
          CurveTween(curve: Curves.easeInCubic),
        ),
        weight: 39,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 20.0, end: 12.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 12.0, end: 20.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 20.0, end: -48.0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -48.0, end: -145.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 27,
      ),
    ]).animate(controller);

    pressScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1), weight: 36),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: .91).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: .91, end: 1.02).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
        weight: 16,
      ),
      TweenSequenceItem(tween: ConstantTween(1.02), weight: 40),
    ]).animate(controller);

    pressRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -.045, end: .015),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween(begin: .015, end: -.012),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -.012, end: 0),
        weight: 50,
      ),
    ]).animate(controller);

    imprintOpacity = CurvedAnimation(
      parent: controller,
      curve: const Interval(.38, .53, curve: Curves.easeOut),
    );

    imprintScale = Tween<double>(begin: .84, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(.37, .58, curve: Curves.easeOutBack),
      ),
    );

    impactShadow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: .62), weight: 39),
      TweenSequenceItem(tween: Tween(begin: .62, end: .18), weight: 12),
      TweenSequenceItem(tween: Tween(begin: .18, end: 0), weight: 49),
    ]).animate(controller);

    toolOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1), weight: 66),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeInCubic),
        ),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(0), weight: 14),
    ]).animate(controller);
  }

  final AnimationController controller;
  late final Animation<double> pressOffset;
  late final Animation<double> pressScale;
  late final Animation<double> pressRotation;
  late final Animation<double> imprintOpacity;
  late final Animation<double> imprintScale;
  late final Animation<double> impactShadow;
  late final Animation<double> toolOpacity;

  Future<void> play() async {
    await controller.forward(from: 0);
  }

  void reset() {
    controller.reset();
  }

  void dispose() {
    controller.dispose();
  }

  static void paintOriginalPhoenix(
    Canvas canvas,
    Rect bounds,
    Color color,
  ) {
    final width = bounds.width;
    final height = bounds.height;
    final center = bounds.center;

    final wingPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * .055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leftWing = Path()
      ..moveTo(center.dx - width * .02, center.dy + height * .08)
      ..cubicTo(
        center.dx - width * .18,
        center.dy - height * .03,
        center.dx - width * .31,
        center.dy - height * .02,
        center.dx - width * .39,
        center.dy - height * .20,
      )
      ..cubicTo(
        center.dx - width * .25,
        center.dy - height * .18,
        center.dx - width * .17,
        center.dy - height * .25,
        center.dx - width * .08,
        center.dy - height * .35,
      );

    final rightWing = Path()
      ..moveTo(center.dx + width * .02, center.dy + height * .08)
      ..cubicTo(
        center.dx + width * .18,
        center.dy - height * .03,
        center.dx + width * .31,
        center.dy - height * .02,
        center.dx + width * .39,
        center.dy - height * .20,
      )
      ..cubicTo(
        center.dx + width * .25,
        center.dy - height * .18,
        center.dx + width * .17,
        center.dy - height * .25,
        center.dx + width * .08,
        center.dy - height * .35,
      );

    final body = Path()
      ..moveTo(center.dx, center.dy - height * .31)
      ..cubicTo(
        center.dx + width * .08,
        center.dy - height * .17,
        center.dx + width * .05,
        center.dy + height * .01,
        center.dx,
        center.dy + height * .17,
      )
      ..cubicTo(
        center.dx - width * .05,
        center.dy + height * .01,
        center.dx - width * .08,
        center.dy - height * .17,
        center.dx,
        center.dy - height * .31,
      );

    final tailLeft = Path()
      ..moveTo(center.dx, center.dy + height * .13)
      ..quadraticBezierTo(
        center.dx - width * .15,
        center.dy + height * .22,
        center.dx - width * .18,
        center.dy + height * .38,
      );
    final tailRight = Path()
      ..moveTo(center.dx, center.dy + height * .13)
      ..quadraticBezierTo(
        center.dx + width * .15,
        center.dy + height * .22,
        center.dx + width * .18,
        center.dy + height * .38,
      );

    canvas.drawPath(leftWing, wingPaint);
    canvas.drawPath(rightWing, wingPaint);
    canvas.drawPath(body, wingPaint);
    canvas.drawPath(tailLeft, wingPaint);
    canvas.drawPath(tailRight, wingPaint);

    final headPaint = Paint()..color = color;
    canvas.drawCircle(
      Offset(center.dx, center.dy - height * .35),
      width * .045,
      headPaint,
    );

    final beak = Path()
      ..moveTo(center.dx + width * .035, center.dy - height * .36)
      ..lineTo(center.dx + width * .12, center.dy - height * .33)
      ..lineTo(center.dx + width * .035, center.dy - height * .30)
      ..close();
    canvas.drawPath(beak, headPaint);
  }
}
