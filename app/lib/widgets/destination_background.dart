import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';
const _summerPalaceFrameInterval = Duration(milliseconds: 50);
const _summerPalaceFrameCount = 400;

bool _summerPalaceReduceMotion(BuildContext context) {
  final forceMotion = Uri.base.queryParameters['motion'] == 'on';
  return !forceMotion &&
      (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
}

class DestinationBackground extends StatelessWidget {
  const DestinationBackground({
    required this.journeyId,
    required this.pageType,
    required this.child,
    this.localDate,
    this.scrimStrength = .24,
    super.key,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final Widget child;
  final DateTime? localDate;
  final double scrimStrength;

  @override
  Widget build(BuildContext context) {
    final location = requireJourneyLocation(journeyId);
    final asset = const JourneyBackgroundPolicy().select(
      journeyId: journeyId,
      locationPath: location.locationPath,
      page: pageType,
      localDate: localDate ?? DateTime.now(),
      catalog: journeyBackgroundCatalog,
    );
    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);

    if (journeyId == _summerPalaceJourneyId) {
      return _SummerPalaceDynamicBackground(
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (asset != null)
          ExcludeSemantics(
            child: Image.asset(
              asset.assetPath,
              key: ValueKey('journey-background-${asset.id}'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const _BackgroundFallback(),
            ),
          )
        else
          const _BackgroundFallback(),
        _JourneyBackgroundScrim(strength: visibleScrimStrength),
        child,
      ],
    );
  }
}

class _SummerPalaceDynamicBackground extends StatefulWidget {
  const _SummerPalaceDynamicBackground({
    required this.scrimStrength,
    required this.child,
  });

  final double scrimStrength;
  final Widget child;

  @override
  State<_SummerPalaceDynamicBackground> createState() =>
      _SummerPalaceDynamicBackgroundState();
}

class _SummerPalaceDynamicBackgroundState
    extends State<_SummerPalaceDynamicBackground> {
  final ValueNotifier<int> _frame = ValueNotifier<int>(70);
  Timer? _motionTimer;
  bool _motionActive = false;
  bool _preloaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  void _syncMotionPreference() {
    final shouldAnimate = !_summerPalaceReduceMotion(context) &&
        TickerMode.valuesOf(context).enabled;
    if (_motionActive == shouldAnimate) return;

    _motionActive = shouldAnimate;
    _motionTimer?.cancel();
    _motionTimer = null;

    if (shouldAnimate) {
      _motionTimer = Timer.periodic(_summerPalaceFrameInterval, (_) {
        if (!mounted) return;
        _frame.value = (_frame.value + 1) % _summerPalaceFrameCount;
      });
    } else {
      _frame.value = 70;
    }
  }

  void _preloadAsset() {
    if (_preloaded) return;
    _preloaded = true;
    precacheImage(
      const AssetImage(summerPalaceLivingBackgroundAssetPath),
      context,
    );
  }

  @override
  void dispose() {
    _motionTimer?.cancel();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _summerPalaceReduceMotion(context);
    return RepaintBoundary(
      key: const ValueKey('summer-palace-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(
              child: ValueListenableBuilder<int>(
                valueListenable: _frame,
                builder: (context, frame, _) {
                  final progress = reduceMotion
                      ? .175
                      : frame / _summerPalaceFrameCount;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _SummerPalaceCameraLayer(progress: progress),
                      if (!reduceMotion)
                        RepaintBoundary(
                          child: CustomPaint(
                            key: const ValueKey(
                              'summer-palace-living-layer',
                            ),
                            painter: _SummerPalaceLivingPainter(progress),
                            size: Size.infinite,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            _JourneyBackgroundScrim(strength: widget.scrimStrength),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _SummerPalaceCameraLayer extends StatelessWidget {
  const _SummerPalaceCameraLayer({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final cycle = progress * math.pi * 2;
    final horizontal = math.sin(cycle) * 6;
    final vertical = math.cos(cycle) * 2.5;
    final scale = 1.045 + (math.sin(cycle - math.pi / 2) + 1) * .006;

    return RepaintBoundary(
      key: const ValueKey('summer-palace-camera-layer'),
      child: Transform.translate(
        key: const ValueKey('summer-palace-camera-transform'),
        offset: Offset(horizontal, vertical),
        child: Transform.scale(
          scale: scale,
          child: Image.asset(
            summerPalaceLivingBackgroundAssetPath,
            key: const ValueKey('summer-palace-static-background'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const _BackgroundFallback(),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceLivingPainter extends CustomPainter {
  const _SummerPalaceLivingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cycle = progress * math.pi * 2;
    _paintCloudLight(canvas, size, cycle);
    _paintWater(canvas, size, cycle);
    _paintBoat(canvas, size, cycle);
    _paintVisitors(canvas, size, cycle);
  }

  void _paintCloudLight(Canvas canvas, Size size, double cycle) {
    final centerX = size.width * (.56 + math.sin(cycle) * .045);
    final rect = Rect.fromCircle(
      center: Offset(centerX, size.height * .17),
      radius: size.width * .48,
    );
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x24FFE4B6), Color(0x0DFFD69A), Colors.transparent],
        stops: [0, .42, 1],
      ).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintWater(Canvas canvas, Size size, double cycle) {
    final waterTop = size.height * .52;
    final waterRect = Rect.fromLTWH(
      0,
      waterTop,
      size.width,
      size.height - waterTop,
    );
    canvas.save();
    canvas.clipRect(waterRect);

    final shimmerX = size.width * (.22 + .13 * math.sin(cycle));
    final shimmerRect = Rect.fromLTWH(
      shimmerX,
      waterTop + size.height * .035,
      size.width * .42,
      size.height * .31,
    );
    final shimmer = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, Color(0x25FFE3AA), Colors.transparent],
        stops: [0, .5, 1],
      ).createShader(shimmerRect);
    canvas.drawRect(shimmerRect, shimmer);

    final bright = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x24FFE7B8);
    final soft = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7
      ..color = const Color(0x16FFFFFF);

    for (var row = 0; row < 8; row += 1) {
      final path = Path();
      final yBase = waterTop + size.height * (.035 + row * .047);
      final amplitude = 1.1 + (row % 3) * .45;
      final wavelength = 62.0 + row * 7;
      final phase = cycle * 1.35 + row * .76;

      for (var x = -12.0; x <= size.width + 12; x += 12) {
        final y = yBase +
            math.sin((x / wavelength) * math.pi * 2 + phase) * amplitude;
        if (x <= -12) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, row.isEven ? bright : soft);
    }

    canvas.restore();
  }

  void _paintBoat(Canvas canvas, Size size, double cycle) {
    final x = size.width * (.73 + .025 * math.sin(cycle * .72));
    final y = size.height * (.61 + .0025 * math.sin(cycle * 1.6));
    final hull = Paint()..color = const Color(0x98502F21);
    final roof = Paint()..color = const Color(0x9E35231A);
    final line = Paint()
      ..color = const Color(0xA8D6B77B)
      ..strokeWidth = 1;

    final hullPath = Path()
      ..moveTo(x - 12, y)
      ..lineTo(x + 13, y)
      ..lineTo(x + 8, y + 5)
      ..lineTo(x - 8, y + 5)
      ..close();
    canvas.drawPath(hullPath, hull);
    canvas.drawRect(Rect.fromLTWH(x - 8, y - 6, 16, 5), roof);
    canvas.drawLine(Offset(x - 7, y - 6), Offset(x - 9, y), line);
    canvas.drawLine(Offset(x + 7, y - 6), Offset(x + 9, y), line);
  }

  void _paintVisitors(Canvas canvas, Size size, double cycle) {
    final pathY = size.height * .505;
    final body = Paint()
      ..color = const Color(0x8E49382E)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    final head = Paint()..color = const Color(0x9BE8D4AE);

    for (var index = 0; index < 3; index += 1) {
      final drift = ((progress + index * .29) % 1) * size.width * .018;
      final x = size.width * (.35 + index * .045) + drift;
      final bob = math.sin(cycle * 2 + index) * .7;
      canvas.drawCircle(Offset(x, pathY - 4 + bob), 1.15, head);
      canvas.drawLine(
        Offset(x, pathY - 2.5 + bob),
        Offset(x, pathY + 3.5 + bob),
        body,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SummerPalaceLivingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _JourneyBackgroundScrim extends StatelessWidget {
  const _JourneyBackgroundScrim({required this.strength});

  final double strength;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhoenixTheme.paper.withValues(alpha: strength + .04),
            PhoenixTheme.paper.withValues(alpha: strength),
            PhoenixTheme.paper.withValues(alpha: strength + .07),
          ],
        ),
      ),
    );
  }
}

class _BackgroundFallback extends StatelessWidget {
  const _BackgroundFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1E6CF), Color(0xFFD7E3DA)],
        ),
      ),
    );
  }
}
