import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';
const _forbiddenCityJourneyId = 'beijing-forbidden-city';
const _shanghaiBundJourneyId = 'shanghai-bund';
const _xianCityWallJourneyId = 'xian-city-wall';
const _hangzhouWestLakeJourneyId = 'hangzhou-west-lake';
const _chengduKuanzhaiJourneyId = 'chengdu-kuanzhai-alley';
const _nanjingQinhuaiJourneyId = 'nanjing-qinhuai-river';
const _guangzhouChenClanJourneyId = 'guangzhou-chen-clan-academy';

const _remainingDynamicBackgrounds = <String, _CinematicBackgroundStyle>{
  _xianCityWallJourneyId: _CinematicBackgroundStyle(
    keyName: 'xian-city-wall',
    duration: Duration(seconds: 26),
    skyColor: Color(0xFFFFD58A),
    atmosphereColor: Color(0xFF8B5A38),
    foregroundColor: Color(0xFF2D1B16),
    cameraTravel: Offset(12, 7),
  ),
  _hangzhouWestLakeJourneyId: _CinematicBackgroundStyle(
    keyName: 'hangzhou-west-lake',
    duration: Duration(seconds: 28),
    skyColor: Color(0xFFEAF6E9),
    atmosphereColor: Color(0xFF89B9AE),
    foregroundColor: Color(0xFF173C35),
    cameraTravel: Offset(9, 5),
    waterLight: true,
  ),
  _chengduKuanzhaiJourneyId: _CinematicBackgroundStyle(
    keyName: 'chengdu-kuanzhai-alley',
    duration: Duration(seconds: 27),
    skyColor: Color(0xFFFFE0A6),
    atmosphereColor: Color(0xFFB56F46),
    foregroundColor: Color(0xFF321E19),
    cameraTravel: Offset(8, 10),
  ),
  _nanjingQinhuaiJourneyId: _CinematicBackgroundStyle(
    keyName: 'nanjing-qinhuai-river',
    duration: Duration(seconds: 29),
    skyColor: Color(0xFFFFC573),
    atmosphereColor: Color(0xFFC9583E),
    foregroundColor: Color(0xFF24172D),
    cameraTravel: Offset(13, 5),
    waterLight: true,
  ),
  _guangzhouChenClanJourneyId: _CinematicBackgroundStyle(
    keyName: 'guangzhou-chen-clan-academy',
    duration: Duration(seconds: 26),
    skyColor: Color(0xFFFFE3A8),
    atmosphereColor: Color(0xFFB86D45),
    foregroundColor: Color(0xFF2B3025),
    cameraTravel: Offset(10, 8),
  ),
};

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
    final cinematicStyle = _remainingDynamicBackgrounds[journeyId];
    if (cinematicStyle != null) {
      return _CinematicDestinationBackground(
        assetPath: asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        style: cinematicStyle,
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
      duration: const Duration(seconds: 24),
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
      key: const ValueKey('forbidden-city-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .46 : _motion.value;
                final cameraProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2);
                final lightProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 + 1.1);
                final shadowProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 - .7);
                final depthProgress =
                    .5 + .5 * math.sin(raw * math.pi * 3 + .4);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ForbiddenCityCameraLayer(
                        assetPath: widget.assetPath,
                        progress: cameraProgress,
                      ),
                      _ForbiddenCityDawnLight(progress: lightProgress),
                      _ForbiddenCityCloudShadow(progress: shadowProgress),
                      _ForbiddenCityGateDepth(progress: depthProgress),
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
        offset: Offset(-6 + 12 * progress, -10 + 12 * progress),
        child: Transform.scale(
          scale: 1.065 + .025 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
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
      duration: const Duration(seconds: 24),
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
                final skylineProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 + 1.35);
                final riverProgress =
                    .5 + .5 * math.sin(raw * math.pi * 3 - .55);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ShanghaiBundCameraLayer(
                        assetPath: widget.assetPath,
                        progress: sceneProgress,
                      ),
                      _ShanghaiBundSkylineGlow(progress: skylineProgress),
                      _ShanghaiBundRiverLight(progress: riverProgress),
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
        offset: Offset(-7 + 14 * progress, -5 + 6 * progress),
        child: Transform.scale(
          scale: 1.06 + .025 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
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
      duration: const Duration(seconds: 28),
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
      _motion.value = .44;
    } else if (!_motion.isAnimating) {
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
      key: const ValueKey('summer-palace-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .44 : _motion.value;
                final cameraProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2);
                final gradeProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 + .8);
                final lightProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 + 1.5);
                final mistProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 - .6);
                final waterProgress =
                    .5 + .5 * math.sin(raw * math.pi * 3 + .25);
                final breathProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2.5 - 1.1);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _SummerPalaceCameraLayer(
                        assetPath: widget.assetPath,
                        progress: cameraProgress,
                      ),
                      _SummerPalaceColorGrade(progress: gradeProgress),
                      _SummerPalaceCloudLight(progress: lightProgress),
                      _SummerPalaceMistVeil(progress: mistProgress),
                      _SummerPalaceWaterShimmer(progress: waterProgress),
                      _SummerPalaceForegroundBreath(
                        progress: breathProgress,
                      ),
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
        offset: Offset(-5 + 10 * progress, -4 + 5 * progress),
        child: Transform.scale(
          scale: 1.065 + .022 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const _BackgroundFallback(),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceColorGrade extends StatelessWidget {
  const _SummerPalaceColorGrade({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        key: const ValueKey('summer-palace-cinematic-color-grade'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFE7B8).withValues(alpha: .055 + .025 * progress),
              Colors.transparent,
              const Color(
                0xFF163E42,
              ).withValues(alpha: .035 + .02 * (1 - progress)),
            ],
            stops: const [0, .52, 1],
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
          widthFactor: 1.7,
          heightFactor: .72,
          child: Transform.translate(
            offset: Offset(-68 + 136 * progress, -12 + 10 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-cloud-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.74 + 1.48 * progress, -.42),
                  radius: 1.12,
                  colors: [
                    Colors.white.withValues(alpha: .16),
                    const Color(0xFFFFDCA3).withValues(alpha: .09),
                    Colors.transparent,
                  ],
                  stops: const [0, .42, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceMistVeil extends StatelessWidget {
  const _SummerPalaceMistVeil({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, .18),
        child: FractionallySizedBox(
          widthFactor: 1.55,
          heightFactor: .4,
          child: Transform.translate(
            offset: Offset(42 - 84 * progress, 2 + 4 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-mist-veil'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.2, -.1),
                  end: const Alignment(1.2, .15),
                  colors: [
                    Colors.transparent,
                    const Color(0xFFEAF3EF).withValues(alpha: .04),
                    Colors.white.withValues(alpha: .09),
                    const Color(0xFFDDEBE8).withValues(alpha: .035),
                    Colors.transparent,
                  ],
                  stops: const [0, .22, .5, .78, 1],
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
          widthFactor: 1.5,
          heightFactor: .56,
          child: Transform.translate(
            offset: Offset(70 - 140 * progress, 8 - 7 * progress),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-water-shimmer'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.55 + 1.1 * progress, -.08),
                  radius: .95,
                  colors: [
                    const Color(0xFFFFE4B0).withValues(alpha: .115),
                    Colors.white.withValues(alpha: .055),
                    const Color(0xFFB9D9D5).withValues(alpha: .022),
                    Colors.transparent,
                  ],
                  stops: const [0, .3, .6, 1],
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
          heightFactor: .46,
          child: Transform.translate(
            offset: Offset(0, 5 - 10 * progress),
            child: Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: 1 + .012 * progress,
              child: DecoratedBox(
                key: const ValueKey('summer-palace-foreground-breath'),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF17382E).withValues(alpha: .035),
                      const Color(0xFF081C18).withValues(alpha: .12),
                    ],
                    stops: const [0, .58, 1],
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

class _CinematicBackgroundStyle {
  const _CinematicBackgroundStyle({
    required this.keyName,
    required this.duration,
    required this.skyColor,
    required this.atmosphereColor,
    required this.foregroundColor,
    required this.cameraTravel,
    this.waterLight = false,
  });

  final String keyName;
  final Duration duration;
  final Color skyColor;
  final Color atmosphereColor;
  final Color foregroundColor;
  final Offset cameraTravel;
  final bool waterLight;
}

class _CinematicDestinationBackground extends StatefulWidget {
  const _CinematicDestinationBackground({
    required this.assetPath,
    required this.scrimStrength,
    required this.style,
    required this.child,
  });

  final String? assetPath;
  final double scrimStrength;
  final _CinematicBackgroundStyle style;
  final Widget child;

  @override
  State<_CinematicDestinationBackground> createState() =>
      _CinematicDestinationBackgroundState();
}

class _CinematicDestinationBackgroundState
    extends State<_CinematicDestinationBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  String? _preloadedAssetPath;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: widget.style.duration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  @override
  void didUpdateWidget(covariant _CinematicDestinationBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style.duration != widget.style.duration) {
      _motion.duration = widget.style.duration;
    }
    if (oldWidget.assetPath != widget.assetPath) {
      _preloadedAssetPath = null;
      _preloadAsset();
    }
  }

  void _syncMotionPreference() {
    if (_destinationReduceMotion(context)) {
      _motion
        ..stop()
        ..value = .42;
    } else if (!_motion.isAnimating) {
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
    final style = widget.style;
    final reduceMotion = _destinationReduceMotion(context);
    return RepaintBoundary(
      key: ValueKey('${style.keyName}-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .42 : _motion.value;
                final cameraProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2);
                final lightProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 + 1.15);
                final atmosphereProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2 - .65);
                final depthProgress =
                    .5 + .5 * math.sin(raw * math.pi * 2.5 + .4);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _CinematicCameraLayer(
                        assetPath: widget.assetPath,
                        progress: cameraProgress,
                        style: style,
                      ),
                      _CinematicMovingLight(
                        progress: lightProgress,
                        style: style,
                      ),
                      _CinematicAtmosphere(
                        progress: atmosphereProgress,
                        style: style,
                      ),
                      _CinematicForegroundDepth(
                        progress: depthProgress,
                        style: style,
                      ),
                      if (style.waterLight)
                        _CinematicWaterLight(
                          progress: atmosphereProgress,
                          style: style,
                        ),
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

class _CinematicCameraLayer extends StatelessWidget {
  const _CinematicCameraLayer({
    required this.assetPath,
    required this.progress,
    required this.style,
  });

  final String? assetPath;
  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null) return const _BackgroundFallback();
    return RepaintBoundary(
      key: ValueKey('${style.keyName}-camera-layer'),
      child: Transform.translate(
        key: ValueKey('${style.keyName}-camera-transform'),
        offset: Offset(
          -style.cameraTravel.dx / 2 + style.cameraTravel.dx * progress,
          -style.cameraTravel.dy + style.cameraTravel.dy * progress,
        ),
        child: Transform.scale(
          scale: 1.06 + .022 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const _BackgroundFallback(),
          ),
        ),
      ),
    );
  }
}

class _CinematicMovingLight extends StatelessWidget {
  const _CinematicMovingLight({
    required this.progress,
    required this.style,
  });

  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1.65,
          heightFactor: .72,
          child: Transform.translate(
            offset: Offset(-78 + 156 * progress, -14 + 10 * progress),
            child: DecoratedBox(
              key: ValueKey('${style.keyName}-moving-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.72 + 1.35 * progress, -.46),
                  radius: 1.08,
                  colors: [
                    style.skyColor.withValues(alpha: .18),
                    Colors.white.withValues(alpha: .075),
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

class _CinematicAtmosphere extends StatelessWidget {
  const _CinematicAtmosphere({
    required this.progress,
    required this.style,
  });

  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FractionallySizedBox(
        alignment: const Alignment(0, -.12),
        widthFactor: 1.7,
        heightFactor: .66,
        child: Transform.translate(
          offset: Offset(92 - 184 * progress, 4 + 8 * progress),
          child: DecoratedBox(
            key: ValueKey('${style.keyName}-atmosphere'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.2, -.6),
                end: const Alignment(1.2, .6),
                colors: [
                  Colors.transparent,
                  style.atmosphereColor.withValues(alpha: .035),
                  Colors.white.withValues(alpha: .07),
                  style.atmosphereColor.withValues(alpha: .055),
                  Colors.transparent,
                ],
                stops: const [0, .22, .48, .74, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CinematicForegroundDepth extends StatelessWidget {
  const _CinematicForegroundDepth({
    required this.progress,
    required this.style,
  });

  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: .48,
          child: Transform.translate(
            offset: Offset(0, 6 - 10 * progress),
            child: DecoratedBox(
              key: ValueKey('${style.keyName}-foreground-depth'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    style.foregroundColor.withValues(alpha: .035),
                    style.foregroundColor.withValues(alpha: .14),
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

class _CinematicWaterLight extends StatelessWidget {
  const _CinematicWaterLight({
    required this.progress,
    required this.style,
  });

  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1.55,
          heightFactor: .44,
          child: Transform.translate(
            offset: Offset(72 - 144 * progress, 6 - 7 * progress),
            child: DecoratedBox(
              key: ValueKey('${style.keyName}-water-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.55 + 1.1 * progress, -.08),
                  radius: .95,
                  colors: [
                    style.skyColor.withValues(alpha: .11),
                    Colors.white.withValues(alpha: .045),
                    style.atmosphereColor.withValues(alpha: .025),
                    Colors.transparent,
                  ],
                  stops: const [0, .3, .62, 1],
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
