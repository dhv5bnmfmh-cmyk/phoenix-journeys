import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';

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
        assetPath: asset?.assetPath,
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
    required this.assetPath,
    required this.scrimStrength,
    required this.child,
  });

  final String? assetPath;
  final double scrimStrength;
  final Widget child;

  @override
  State<_SummerPalaceDynamicBackground> createState() =>
      _SummerPalaceDynamicBackgroundState();
}

class _SummerPalaceDynamicBackgroundState
    extends State<_SummerPalaceDynamicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  String? _preloadedAssetPath;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  @override
  void didUpdateWidget(covariant _SummerPalaceDynamicBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _preloadedAssetPath = null;
      _preloadAsset();
    }
  }

  void _syncMotionPreference() {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final tickerEnabled = TickerMode.of(context);
    if (reduceMotion || !tickerEnabled) {
      _motion.stop();
      _motion.value = .42;
    } else if (!_motion.isAnimating) {
      _motion.repeat(reverse: true);
    }
  }

  void _preloadAsset() {
    final path = widget.assetPath;
    if (path == null || path == _preloadedAssetPath) return;
    _preloadedAssetPath = path;
    precacheImage(AssetImage(path), context);
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return RepaintBoundary(
      key: const ValueKey('summer-palace-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .42 : _motion.value;
                final progress = Curves.easeInOutSine.transform(raw);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _SummerPalaceCameraLayer(
                        assetPath: widget.assetPath,
                        progress: progress,
                      ),
                      _SummerPalaceCloudLight(progress: progress),
                      _SummerPalaceWaterShimmer(progress: progress),
                      _SummerPalaceForegroundBreath(progress: progress),
                    ],
                  ),
                );
              },
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
  const _SummerPalaceCameraLayer({
    required this.assetPath,
    required this.progress,
  });

  final String? assetPath;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null) return const _BackgroundFallback();

    return RepaintBoundary(
      key: const ValueKey('summer-palace-camera-layer'),
      child: Transform.translate(
        offset: Offset(-8 + 16 * progress, -7 + 6 * progress),
        child: Transform.scale(
          scale: 1.085 + .035 * progress,
          child: Image.asset(
            path,
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

class _SummerPalaceCloudLight extends StatelessWidget {
  const _SummerPalaceCloudLight({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1.35,
          heightFactor: .62,
          child: Transform.translate(
            offset: Offset(-42 + 84 * progress, -3 + 6 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-cloud-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.58 + 1.16 * progress, -.32),
                  radius: 1.14,
                  colors: [
                    Colors.white.withValues(alpha: .12),
                    const Color(0xFFFFD89B).withValues(alpha: .055),
                    Colors.transparent,
                  ],
                  stops: const [0, .34, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceWaterShimmer extends StatelessWidget {
  const _SummerPalaceWaterShimmer({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1.42,
          heightFactor: .55,
          child: Transform.translate(
            offset: Offset(58 - 116 * progress, 2 - 4 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-water-shimmer'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.2, -.8),
                  end: const Alignment(1.2, .8),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: .018),
                    const Color(0xFFFFE1A9).withValues(alpha: .08),
                    Colors.white.withValues(alpha: .024),
                    Colors.transparent,
                  ],
                  stops: const [0, .28, .5, .72, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceForegroundBreath extends StatelessWidget {
  const _SummerPalaceForegroundBreath({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: .42,
          child: Transform.translate(
            offset: Offset(0, 4 - 8 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-foreground-breath'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF17382E).withValues(alpha: .025),
                    const Color(0xFF0A211B).withValues(alpha: .10),
                  ],
                  stops: const [0, .58, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
          colors: [Color(0xFFFFF7EA), Color(0xFFF2DFCA), PhoenixTheme.paper],
        ),
      ),
    );
  }
}
