import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';
const _forbiddenCityJourneyId = 'beijing-forbidden-city';
const _shanghaiBundJourneyId = 'shanghai-bund';

bool _destinationReduceMotion(BuildContext context) {
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
        assetPath: asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }
    if (journeyId == _forbiddenCityJourneyId) {
      return _ForbiddenCityDynamicBackground(
        assetPath: asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }
    if (journeyId == _shanghaiBundJourneyId) {
      return _ShanghaiBundDynamicBackground(
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

class _ForbiddenCityDynamicBackground extends StatefulWidget {
  const _ForbiddenCityDynamicBackground({
    required this.assetPath,
    required this.scrimStrength,
    required this.child,
  });

  final String? assetPath;
  final double scrimStrength;
  final Widget child;

  @override
  State<_ForbiddenCityDynamicBackground> createState() =>
      _ForbiddenCityDynamicBackgroundState();
}

class _ForbiddenCityDynamicBackgroundState
    extends State<_ForbiddenCityDynamicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  String? _preloadedAssetPath;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  @override
  void didUpdateWidget(covariant _ForbiddenCityDynamicBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _preloadedAssetPath = null;
      _preloadAsset();
    }
  }

  void _syncMotionPreference() {
    final reduceMotion = _destinationReduceMotion(context);
    if (reduceMotion) {
      _motion.stop();
      _motion.value = .46;
    } else if (!_motion.isAnimating) {
      _motion.value = .1;
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
    final reduceMotion = _destinationReduceMotion(context);
    return RepaintBoundary(
      key: const ValueKey('forbidden-city-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .46 : _motion.value;
                final progress = Curves.easeInOutSine.transform(raw);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ForbiddenCityCameraLayer(
                        assetPath: widget.assetPath,
                        progress: progress,
                      ),
                      _ForbiddenCityDawnLight(progress: progress),
                      _ForbiddenCityCloudShadow(progress: progress),
                      _ForbiddenCityGateDepth(progress: progress),
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

class _ForbiddenCityCameraLayer extends StatelessWidget {
  const _ForbiddenCityCameraLayer({
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
      key: const ValueKey('forbidden-city-camera-layer'),
      child: Transform.translate(
        key: const ValueKey('forbidden-city-camera-transform'),
        offset: Offset(-10 + 20 * progress, -18 + 22 * progress),
        child: Transform.scale(
          scale: 1.045 + .07 * progress,
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

class _ForbiddenCityDawnLight extends StatelessWidget {
  const _ForbiddenCityDawnLight({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1.55,
          heightFactor: .72,
          child: Transform.translate(
            offset: Offset(-86 + 150 * progress, -18 + 12 * progress),
            child: DecoratedBox(
              key: const ValueKey('forbidden-city-dawn-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.78 + 1.1 * progress, -.55),
                  radius: 1.05,
                  colors: [
                    const Color(0xFFFFF4D2).withValues(alpha: .24),
                    const Color(0xFFFFC36E).withValues(alpha: .13),
                    Colors.transparent,
                  ],
                  stops: const [0, .4, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForbiddenCityCloudShadow extends StatelessWidget {
  const _ForbiddenCityCloudShadow({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 1.8,
        heightFactor: .62,
        child: Transform.translate(
          offset: Offset(130 - 260 * progress, 8 + 12 * progress),
          child: DecoratedBox(
            key: const ValueKey('forbidden-city-cloud-shadow'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.2, -.65),
                end: const Alignment(1.2, .7),
                colors: [
                  Colors.transparent,
                  const Color(0xFF293342).withValues(alpha: .035),
                  const Color(0xFF17202D).withValues(alpha: .11),
                  Colors.white.withValues(alpha: .035),
                  Colors.transparent,
                ],
                stops: const [0, .24, .48, .72, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForbiddenCityGateDepth extends StatelessWidget {
  const _ForbiddenCityGateDepth({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: .48,
          child: Transform.translate(
            offset: Offset(0, 6 - 12 * progress),
            child: DecoratedBox(
              key: const ValueKey('forbidden-city-gate-depth'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF6E201C).withValues(alpha: .04),
                    const Color(0xFF24120F).withValues(alpha: .15),
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

class _ShanghaiBundDynamicBackground extends StatefulWidget {
  const _ShanghaiBundDynamicBackground({
    required this.assetPath,
    required this.scrimStrength,
    required this.child,
  });

  final String? assetPath;
  final double scrimStrength;
  final Widget child;

  @override
  State<_ShanghaiBundDynamicBackground> createState() =>
      _ShanghaiBundDynamicBackgroundState();
}

class _ShanghaiBundDynamicBackgroundState
    extends State<_ShanghaiBundDynamicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  String? _preloadedAssetPath;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  @override
  void didUpdateWidget(covariant _ShanghaiBundDynamicBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _preloadedAssetPath = null;
      _preloadAsset();
    }
  }

  void _syncMotionPreference() {
    final reduceMotion = _destinationReduceMotion(context);
    if (reduceMotion) {
      _motion.stop();
      _motion.value = .47;
    } else if (!_motion.isAnimating) {
      _motion.value = .06;
      _motion.repeat();
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
    final reduceMotion = _destinationReduceMotion(context);
    return RepaintBoundary(
      key: const ValueKey('shanghai-bund-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .47 : _motion.value;
                final sceneProgress = Curves.easeInOutSine.transform(
                  raw <= .5 ? raw * 2 : (1 - raw) * 2,
                );
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ShanghaiBundCameraLayer(
                        assetPath: widget.assetPath,
                        progress: sceneProgress,
                      ),
                      _ShanghaiBundSkylineGlow(progress: sceneProgress),
                      _ShanghaiBundRiverLight(progress: sceneProgress),
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

class _ShanghaiBundCameraLayer extends StatelessWidget {
  const _ShanghaiBundCameraLayer({
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
      key: const ValueKey('shanghai-bund-camera-layer'),
      child: Transform.translate(
        key: const ValueKey('shanghai-bund-camera-transform'),
        offset: Offset(-12 + 24 * progress, -8 + 10 * progress),
        child: Transform.scale(
          scale: 1.035 + .055 * progress,
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

class _ShanghaiBundSkylineGlow extends StatelessWidget {
  const _ShanghaiBundSkylineGlow({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1.5,
          heightFactor: .72,
          child: Transform.translate(
            offset: Offset(-68 + 136 * progress, -10 + 8 * progress),
            child: DecoratedBox(
              key: const ValueKey('shanghai-bund-skyline-glow'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.68 + 1.18 * progress, -.28),
                  radius: 1.08,
                  colors: [
                    const Color(0xFFFFE8B6).withValues(alpha: .18),
                    const Color(0xFFFFB86D).withValues(alpha: .095),
                    const Color(0xFF79B7D7).withValues(alpha: .035),
                    Colors.transparent,
                  ],
                  stops: const [0, .34, .62, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShanghaiBundRiverLight extends StatelessWidget {
  const _ShanghaiBundRiverLight({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1.74,
          heightFactor: .5,
          child: Transform.translate(
            offset: Offset(110 - 220 * progress, 4 - 8 * progress),
            child: DecoratedBox(
              key: const ValueKey('shanghai-bund-river-light'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.2, -.75),
                  end: const Alignment(1.2, .8),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: .03),
                    const Color(0xFFFFD28C).withValues(alpha: .14),
                    const Color(0xFF92D5E8).withValues(alpha: .07),
                    Colors.white.withValues(alpha: .035),
                    Colors.transparent,
                  ],
                  stops: const [0, .2, .43, .62, .8, 1],
                ),
              ),
            ),
          ),
        ),
      ),
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
      duration: const Duration(seconds: 13),
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
    final reduceMotion = _destinationReduceMotion(context);
    if (reduceMotion) {
      _motion.stop();
      _motion.value = .42;
    } else if (!_motion.isAnimating) {
      _motion.value = .08;
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
    final reduceMotion = _destinationReduceMotion(context);
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
        key: const ValueKey('summer-palace-camera-transform'),
        offset: Offset(-18 + 36 * progress, -13 + 15 * progress),
        child: Transform.scale(
          scale: 1.075 + .075 * progress,
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
          widthFactor: 1.55,
          heightFactor: .66,
          child: Transform.translate(
            offset: Offset(-80 + 160 * progress, -7 + 14 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-cloud-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.72 + 1.44 * progress, -.34),
                  radius: 1.05,
                  colors: [
                    Colors.white.withValues(alpha: .19),
                    const Color(0xFFFFD89B).withValues(alpha: .105),
                    Colors.transparent,
                  ],
                  stops: const [0, .38, 1],
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
          widthFactor: 1.62,
          heightFactor: .58,
          child: Transform.translate(
            offset: Offset(92 - 184 * progress, 5 - 10 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-water-shimmer'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.2, -.8),
                  end: const Alignment(1.2, .8),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: .035),
                    const Color(0xFFFFE1A9).withValues(alpha: .15),
                    Colors.white.withValues(alpha: .055),
                    Colors.transparent,
                  ],
                  stops: const [0, .25, .5, .75, 1],
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
          heightFactor: .44,
          child: Transform.translate(
            offset: Offset(0, 8 - 16 * progress),
            child: Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: 1 + .022 * progress,
              child: DecoratedBox(
                key: const ValueKey('summer-palace-foreground-breath'),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF17382E).withValues(alpha: .045),
                      const Color(0xFF0A211B).withValues(alpha: .14),
                    ],
                    stops: const [0, .55, 1],
                  ),
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
