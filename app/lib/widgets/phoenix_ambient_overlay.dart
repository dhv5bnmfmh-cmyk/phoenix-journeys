import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/background_motion_preference.dart';
import 'phoenix_dynamic_background.dart';

class PhoenixAmbientOverlay extends StatefulWidget {
  const PhoenixAmbientOverlay({required this.journeyId, super.key});

  final String journeyId;

  @override
  State<PhoenixAmbientOverlay> createState() => _PhoenixAmbientOverlayState();
}

class _PhoenixAmbientOverlayState extends State<PhoenixAmbientOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _preference = BackgroundMotionPreference.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 42),
    );
    _preference.addListener(_syncMotion);
    _preference.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void dispose() {
    _preference.removeListener(_syncMotion);
    _controller.dispose();
    super.dispose();
  }

  bool get _reduced {
    final media = MediaQuery.maybeOf(context);
    final query = Uri.base.queryParameters['motion'];
    if (query == 'on') return false;
    return query == 'off' ||
        (media?.disableAnimations ?? false) ||
        _preference.reduceMotion;
  }

  void _syncMotion() {
    if (!mounted) return;
    if (_reduced) {
      _controller.stop();
      _controller.value = .37;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final palette = PhoenixBackgroundPalette.forJourney(widget.journeyId);
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            key: ValueKey('phoenix-ambient-${widget.journeyId}'),
            painter: _AmbientPainter(
              palette: palette,
              progress: _reduced ? .37 : _controller.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _AmbientPainter extends CustomPainter {
  const _AmbientPainter({required this.palette, required this.progress});

  final PhoenixBackgroundPalette palette;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = progress * math.pi * 2;
    final drift = math.sin(phase) * size.width * .035;
    final breathe = .5 + .5 * math.sin(phase + .8);

    final topLight = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.light.withValues(alpha: .055 + breathe * .025),
          palette.light.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .72 + drift, size.height * .16),
          radius: size.shortestSide * .52,
        ),
      );
    canvas.drawRect(Offset.zero & size, topLight);

    final mistPaint = Paint()
      ..color = palette.sky.withValues(alpha: .018 + breathe * .012);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .32 - drift * .7, size.height * .56),
        width: size.width * 1.08,
        height: size.height * .18,
      ),
      mistPaint,
    );

    final foregroundPaint = Paint()
      ..color = palette.land.withValues(alpha: .045);
    final foreground = Path()
      ..moveTo(-20, size.height)
      ..lineTo(-20, size.height * .92)
      ..quadraticBezierTo(
        size.width * .18 + drift * .25,
        size.height * .84,
        size.width * .44,
        size.height * .95,
      )
      ..quadraticBezierTo(
        size.width * .74,
        size.height * 1.02,
        size.width + 20,
        size.height * .88,
      )
      ..lineTo(size.width + 20, size.height)
      ..close();
    canvas.drawPath(foreground, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _AmbientPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.palette != palette;
  }
}
