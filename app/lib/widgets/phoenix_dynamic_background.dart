import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/background_motion_preference.dart';

class PhoenixDynamicBackground extends StatefulWidget {
  const PhoenixDynamicBackground({
    required this.journeyId,
    required this.child,
    super.key,
  });

  final String journeyId;
  final Widget child;

  @override
  State<PhoenixDynamicBackground> createState() =>
      _PhoenixDynamicBackgroundState();
}

class _PhoenixDynamicBackgroundState extends State<PhoenixDynamicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _preference = BackgroundMotionPreference.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 38),
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

  bool get _reduceMotion {
    final media = MediaQuery.maybeOf(context);
    final systemReduced = media?.disableAnimations ?? false;
    final compactLowPower = media != null &&
        media.size.shortestSide < 340 &&
        media.devicePixelRatio > 2.5;
    final queryReduced = Uri.base.queryParameters['motion'] == 'off';
    final queryForced = Uri.base.queryParameters['motion'] == 'on';
    if (queryForced) return false;
    return queryReduced ||
        systemReduced ||
        compactLowPower ||
        _preference.reduceMotion;
  }

  void _syncMotion() {
    if (!mounted) return;
    if (_reduceMotion) {
      _controller.stop();
      _controller.value = .42;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final palette = PhoenixBackgroundPalette.forJourney(widget.journeyId);
    final reduceMotion = _reduceMotion;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _PhoenixEnvironmentPainter(
                  palette: palette,
                  progress: reduceMotion ? .42 : _controller.value,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .03),
                    Colors.transparent,
                    Colors.black.withValues(alpha: .12),
                  ],
                  stops: const [0, .52, 1],
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class PhoenixBackgroundPalette {
  const PhoenixBackgroundPalette({
    required this.sky,
    required this.haze,
    required this.land,
    required this.light,
    required this.water,
  });

  final Color sky;
  final Color haze;
  final Color land;
  final Color light;
  final bool water;

  factory PhoenixBackgroundPalette.forJourney(String journeyId) {
    final value = journeyId.codeUnits.fold<int>(17, (sum, item) => sum * 31 + item);
    final hue = (value.abs() % 360).toDouble();
    final water = journeyId.contains('lake') ||
        journeyId.contains('river') ||
        journeyId.contains('bund') ||
        journeyId.contains('stream') ||
        journeyId.contains('erhai') ||
        journeyId.contains('terraces') ||
        journeyId.contains('dujiangyan') ||
        journeyId.contains('kulangsu');
    final warm = journeyId.contains('dunhuang') ||
        journeyId.contains('wall') ||
        journeyId.contains('palace') ||
        journeyId.contains('pingyao') ||
        journeyId.contains('tulou');

    final baseHue = warm ? 34.0 : hue;
    return PhoenixBackgroundPalette(
      sky: HSLColor.fromAHSL(1, baseHue, .46, warm ? .72 : .76).toColor(),
      haze: HSLColor.fromAHSL(1, (baseHue + 24) % 360, .34, .54).toColor(),
      land: HSLColor.fromAHSL(1, (baseHue + 338) % 360, .34, .19).toColor(),
      light: HSLColor.fromAHSL(1, warm ? 43 : (baseHue + 48) % 360, .78, .70)
          .toColor(),
      water: water,
    );
  }
}

class _PhoenixEnvironmentPainter extends CustomPainter {
  const _PhoenixEnvironmentPainter({
    required this.palette,
    required this.progress,
  });

  final PhoenixBackgroundPalette palette;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = progress * math.pi * 2;
    final breathe = .5 + .5 * math.sin(phase);
    final drift = math.sin(phase) * size.width * .012;

    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [palette.sky, palette.haze, palette.land],
        stops: const [0, .58, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, skyPaint);

    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.light.withValues(alpha: .22 + breathe * .08),
          palette.light.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .72 + drift, size.height * .20),
          radius: size.shortestSide * .56,
        ),
      );
    canvas.drawRect(Offset.zero & size, lightPaint);

    _drawMountainLayer(
      canvas,
      size,
      baseline: .66,
      amplitude: .10,
      speed: .55,
      color: palette.land.withValues(alpha: .20),
      phase: phase,
    );
    _drawMountainLayer(
      canvas,
      size,
      baseline: .76,
      amplitude: .13,
      speed: .85,
      color: palette.land.withValues(alpha: .36),
      phase: phase + 1.4,
    );

    if (palette.water) {
      final waterRect = Rect.fromLTWH(0, size.height * .70, size.width, size.height * .30);
      final waterPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.haze.withValues(alpha: .24),
            palette.land.withValues(alpha: .72),
          ],
        ).createShader(waterRect);
      canvas.drawRect(waterRect, waterPaint);
      final shimmer = Paint()
        ..color = palette.light.withValues(alpha: .09 + breathe * .05)
        ..strokeWidth = 1.2;
      for (var index = 0; index < 7; index += 1) {
        final y = size.height * (.74 + index * .032);
        final width = size.width * (.18 + index * .05);
        final center = size.width * (.68 + .02 * math.sin(phase + index));
        canvas.drawLine(Offset(center - width / 2, y), Offset(center + width / 2, y), shimmer);
      }
    }

    final foreground = Paint()..color = palette.land.withValues(alpha: .76);
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * .88)
      ..quadraticBezierTo(
        size.width * .18 + drift * .5,
        size.height * .82,
        size.width * .38,
        size.height * .91,
      )
      ..quadraticBezierTo(
        size.width * .63,
        size.height * .98,
        size.width,
        size.height * .84,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, foreground);

    final hazePaint = Paint()..color = Colors.white.withValues(alpha: .035 + breathe * .018);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .35 - drift, size.height * .48),
        width: size.width * .84,
        height: size.height * .16,
      ),
      hazePaint,
    );
  }

  void _drawMountainLayer(
    Canvas canvas,
    Size size, {
    required double baseline,
    required double amplitude,
    required double speed,
    required Color color,
    required double phase,
  }) {
    final path = Path()..moveTo(0, size.height);
    for (var index = 0; index <= 8; index += 1) {
      final x = size.width * index / 8;
      final wave = math.sin(index * 1.17 + phase * speed) * amplitude;
      final y = size.height * (baseline + wave * .32);
      if (index == 0) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PhoenixEnvironmentPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.palette != palette;
  }
}

class BackgroundMotionSettingButton extends StatelessWidget {
  const BackgroundMotionSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final preference = BackgroundMotionPreference.instance;
    return ListenableBuilder(
      listenable: preference,
      builder: (context, _) {
        final reduced = preference.reduceMotion;
        return Tooltip(
          message: reduced ? '开启动态背景' : '减少动态效果',
          child: Material(
            color: Colors.black.withValues(alpha: .22),
            shape: const CircleBorder(),
            child: IconButton(
              key: const ValueKey('background-motion-setting'),
              onPressed: () => preference.setReduceMotion(!reduced),
              icon: Icon(
                reduced ? Icons.motion_photos_off_rounded : Icons.motion_photos_auto_rounded,
                color: Colors.white,
                size: 19,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }
}
