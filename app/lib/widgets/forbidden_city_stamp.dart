import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../agents/phoenix_stamp_agent.dart';
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
    final color = isUnlocked ? PhoenixTheme.red : Colors.black38;

    return Semantics(
      label: isUnlocked ? '北京紫禁城旅程原创印章，已获得' : '北京紫禁城旅程印章，尚未获得',
      child: Transform.rotate(
        angle: isUnlocked ? -math.pi / 42 : 0,
        child: AnimatedOpacity(
          opacity: isUnlocked ? 1 : .48,
          duration: const Duration(milliseconds: 350),
          child: Container(
            key: const ValueKey('forbidden-city-stamp'),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? PhoenixTheme.red.withValues(alpha: .035)
                  : Colors.black.withValues(alpha: .025),
            ),
            child: CustomPaint(
              key: const ValueKey('original-phoenix-stamp-art'),
              painter: _PhoenixSealPainter(color: color),
              child: Center(
                child: isUnlocked
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '北京',
                            style: TextStyle(
                              color: color,
                              fontSize: size * .12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: size * .018,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: size * .32),
                          Text(
                            '紫禁城',
                            style: TextStyle(
                              color: color,
                              fontSize: size * .105,
                              fontWeight: FontWeight.w900,
                              letterSpacing: size * .008,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: size * .025),
                          Text(
                            'PHOENIX JOURNEYS',
                            style: TextStyle(
                              color: color,
                              fontSize: size * .043,
                              fontWeight: FontWeight.w900,
                              letterSpacing: size * .003,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: color,
                            size: size * .22,
                          ),
                          SizedBox(height: size * .05),
                          Text(
                            '待探索',
                            style: TextStyle(
                              color: color,
                              fontSize: size * .12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedForbiddenCityStamp extends StatefulWidget {
  const AnimatedForbiddenCityStamp({
    this.size = 166,
    this.autoPlay = true,
    this.onCompleted,
    super.key,
  });

  final double size;
  final bool autoPlay;
  final VoidCallback? onCompleted;

  @override
  State<AnimatedForbiddenCityStamp> createState() =>
      _AnimatedForbiddenCityStampState();
}

class _AnimatedForbiddenCityStampState extends State<AnimatedForbiddenCityStamp>
    with SingleTickerProviderStateMixin {
  late final PhoenixStampAgent _agent;

  @override
  void initState() {
    super.initState();
    _agent = PhoenixStampAgent(vsync: this);
    _agent.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted?.call();
    });

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_agent.play());
      });
    }
  }

  @override
  void dispose() {
    _agent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasHeight = widget.size * 1.72;

    return Semantics(
      label: '原创北京紫禁城印章正在从上方盖下',
      child: SizedBox(
        key: const ValueKey('animated-forbidden-city-stamp'),
        width: widget.size * 1.35,
        height: canvasHeight,
        child: AnimatedBuilder(
          animation: _agent.controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 8,
                  child: Container(
                    width: widget.size * 1.25,
                    height: widget.size * .93,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFCF4),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: PhoenixTheme.gold.withValues(alpha: .28),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 10),
                          color: Color(0x14000000),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: widget.size * .28,
                  child: Opacity(
                    opacity: _agent.impactShadow.value,
                    child: Container(
                      width: widget.size * .78,
                      height: widget.size * .17,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: widget.size * .10,
                  child: Opacity(
                    key: const ValueKey('animated-stamp-imprint'),
                    opacity: _agent.imprintOpacity.value,
                    child: Transform.scale(
                      scale: _agent.imprintScale.value,
                      child: ForbiddenCityStamp(size: widget.size),
                    ),
                  ),
                ),
                Positioned(
                  top: _agent.pressOffset.value,
                  child: Transform.rotate(
                    angle: _agent.pressRotation.value,
                    child: Transform.scale(
                      scale: _agent.pressScale.value,
                      child: _StampTool(
                        key: const ValueKey('animated-stamp-tool'),
                        size: widget.size,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StampTool extends StatelessWidget {
  const _StampTool({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size * .32,
            height: size * .50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD49B58), Color(0xFF8A4E24)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(size * .17),
                bottom: Radius.circular(size * .07),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 7),
                  color: Color(0x28000000),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: size * .09,
                height: size * .30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          Container(
            width: size * .70,
            height: size * .16,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D1C20), Color(0xFF641114)],
              ),
              borderRadius: BorderRadius.circular(size * .05),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 6),
                  color: Color(0x30000000),
                ),
              ],
            ),
          ),
          Container(
            width: size * .76,
            height: size * .12,
            decoration: BoxDecoration(
              color: const Color(0xFF4E0B0E),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(size * .06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoenixSealPainter extends CustomPainter {
  const _PhoenixSealPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outer = Paint()
      ..color = color.withValues(alpha: .86)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .026;
    final inner = Paint()
      ..color = color.withValues(alpha: .55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .010;

    canvas.drawCircle(center, size.width * .472, outer);
    canvas.drawCircle(center, size.width * .405, inner);

    final dashPaint = Paint()
      ..color = color.withValues(alpha: .36)
      ..strokeWidth = size.width * .016
      ..strokeCap = StrokeCap.round;

    const dashCount = 28;
    for (var index = 0; index < dashCount; index += 1) {
      final angle = index * math.pi * 2 / dashCount;
      final innerPoint = Offset(
        center.dx + math.cos(angle) * size.width * .431,
        center.dy + math.sin(angle) * size.width * .431,
      );
      final outerPoint = Offset(
        center.dx + math.cos(angle) * size.width * .451,
        center.dy + math.sin(angle) * size.width * .451,
      );
      canvas.drawLine(innerPoint, outerPoint, dashPaint);
    }

    final artRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - size.height * .015),
      width: size.width * .44,
      height: size.height * .44,
    );
    PhoenixStampAgent.paintOriginalPhoenix(canvas, artRect, color);

    final distress = Paint()..color = color.withValues(alpha: .12);
    final dots = <Offset>[
      Offset(size.width * .22, size.height * .30),
      Offset(size.width * .77, size.height * .33),
      Offset(size.width * .29, size.height * .72),
      Offset(size.width * .70, size.height * .75),
      Offset(size.width * .18, size.height * .55),
      Offset(size.width * .83, size.height * .58),
    ];
    for (final dot in dots) {
      canvas.drawCircle(dot, size.width * .016, distress);
    }
  }

  @override
  bool shouldRepaint(covariant _PhoenixSealPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
