import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';
import 'special_realm_background.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';
const _forbiddenCityJourneyId = 'beijing-forbidden-city';
const _shanghaiBundJourneyId = 'shanghai-bund';

const _completeJourneyPages = <JourneyBackgroundPage>{
  JourneyBackgroundPage.story,
  JourneyBackgroundPage.vocabulary,
  JourneyBackgroundPage.discovery,
  JourneyBackgroundPage.reflection,
  JourneyBackgroundPage.memory,
};

const _specialCompleteAssets = <String, Map<JourneyBackgroundPage, String>>{
  'changan-last-bus': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/changan-last-bus-02-object.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/changan-last-bus-05-overlap.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/changan-last-bus-06-storm.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/changan-last-bus-07-memory.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/changan-last-bus-09-release.webp',
  },
  'tide-letter': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/tide-letter-02-object.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/tide-letter-05-overlap.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/tide-letter-06-storm.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/tide-letter-07-memory.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/tide-letter-09-release.webp',
  },
  'arcade-lost-property': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/arcade-lost-property-02-object.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/arcade-lost-property-05-overlap.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/arcade-lost-property-06-storm.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/arcade-lost-property-07-memory.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/arcade-lost-property-09-release.webp',
  },
  'tea-horse-echo': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/tea-horse-echo-02-object.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/tea-horse-echo-05-overlap.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/tea-horse-echo-06-storm.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/tea-horse-echo-07-memory.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/tea-horse-echo-09-release.webp',
  },
  'ice-city-star-map': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/ice-city-star-map-02-object.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/ice-city-star-map-05-overlap.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/ice-city-star-map-06-storm.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/ice-city-star-map-07-memory.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/ice-city-star-map-09-release.webp',
  },
  'literary-roaming': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/dream-butterfly-02.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/dream-butterfly-05.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/dream-butterfly-06.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/dream-butterfly-07.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/dream-butterfly-09.webp',
  },
  'myth-tracing': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/moon-letter-02.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/moon-letter-05.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/moon-letter-06.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/moon-letter-07.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/moon-letter-09.webp',
  },
  'strange-night-talks': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/shadowless-inn-02.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/shadowless-inn-05.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/shadowless-inn-06.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/shadowless-inn-07.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/shadowless-inn-09.webp',
  },
  'folk-secret-land': {
    JourneyBackgroundPage.story: 'assets/images/special-realms/ten-scene/upstream-lantern-02.webp',
    JourneyBackgroundPage.vocabulary: 'assets/images/special-realms/ten-scene/upstream-lantern-05.webp',
    JourneyBackgroundPage.discovery: 'assets/images/special-realms/ten-scene/upstream-lantern-06.webp',
    JourneyBackgroundPage.reflection: 'assets/images/special-realms/ten-scene/upstream-lantern-07.webp',
    JourneyBackgroundPage.memory: 'assets/images/special-realms/ten-scene/upstream-lantern-09.webp',
  },
};

const _remainingDynamicBackgrounds = <String, _CinematicBackgroundStyle>{
  'xian-city-wall': _CinematicBackgroundStyle(
    keyName: 'xian-city-wall',
    duration: Duration(seconds: 26),
    skyColor: Color(0xFFFFD58A),
    atmosphereColor: Color(0xFF8B5A38),
    foregroundColor: Color(0xFF2D1B16),
    cameraTravel: Offset(12, 7),
  ),
  'hangzhou-west-lake': _CinematicBackgroundStyle(
    keyName: 'hangzhou-west-lake',
    duration: Duration(seconds: 28),
    skyColor: Color(0xFFEAF6E9),
    atmosphereColor: Color(0xFF89B9AE),
    foregroundColor: Color(0xFF173C35),
    cameraTravel: Offset(9, 5),
    waterLight: true,
  ),
  'chengdu-kuanzhai-alley': _CinematicBackgroundStyle(
    keyName: 'chengdu-kuanzhai-alley',
    duration: Duration(seconds: 27),
    skyColor: Color(0xFFFFE0A6),
    atmosphereColor: Color(0xFFB56F46),
    foregroundColor: Color(0xFF321E19),
    cameraTravel: Offset(8, 10),
  ),
  'nanjing-qinhuai-river': _CinematicBackgroundStyle(
    keyName: 'nanjing-qinhuai-river',
    duration: Duration(seconds: 29),
    skyColor: Color(0xFFFFC573),
    atmosphereColor: Color(0xFFC9583E),
    foregroundColor: Color(0xFF24172D),
    cameraTravel: Offset(13, 5),
    waterLight: true,
  ),
  'guangzhou-chen-clan-academy': _CinematicBackgroundStyle(
    keyName: 'guangzhou-chen-clan-academy',
    duration: Duration(seconds: 26),
    skyColor: Color(0xFFFFE3A8),
    atmosphereColor: Color(0xFFB86D45),
    foregroundColor: Color(0xFF2B3025),
    cameraTravel: Offset(10, 8),
  ),
  'suzhou-humble-administrators-garden': _CinematicBackgroundStyle(
    keyName: 'suzhou-humble-administrators-garden',
    duration: Duration(seconds: 30),
    skyColor: Color(0xFFFFE9B9),
    atmosphereColor: Color(0xFF8DB5A1),
    foregroundColor: Color(0xFF18382B),
    cameraTravel: Offset(9, 7),
    waterLight: true,
  ),
  'luoyang-longmen-grottoes': _CinematicBackgroundStyle(
    keyName: 'luoyang-longmen-grottoes',
    duration: Duration(seconds: 28),
    skyColor: Color(0xFFFFD79C),
    atmosphereColor: Color(0xFFA47758),
    foregroundColor: Color(0xFF2D211B),
    cameraTravel: Offset(8, 11),
  ),
  'quanzhou-kaiyuan-temple': _CinematicBackgroundStyle(
    keyName: 'quanzhou-kaiyuan-temple',
    duration: Duration(seconds: 29),
    skyColor: Color(0xFFFFE2AD),
    atmosphereColor: Color(0xFF8DA783),
    foregroundColor: Color(0xFF243429),
    cameraTravel: Offset(11, 8),
  ),
  'datong-yungang-grottoes': _CinematicBackgroundStyle(
    keyName: 'datong-yungang-grottoes',
    duration: Duration(seconds: 31),
    skyColor: Color(0xFFFFD59A),
    atmosphereColor: Color(0xFFA87955),
    foregroundColor: Color(0xFF261B17),
    cameraTravel: Offset(8, 12),
  ),
  'lijiang-old-town': _CinematicBackgroundStyle(
    keyName: 'lijiang-old-town',
    duration: Duration(seconds: 32),
    skyColor: Color(0xFFD9E7F1),
    atmosphereColor: Color(0xFF6D93A2),
    foregroundColor: Color(0xFF172B32),
    cameraTravel: Offset(10, 7),
    waterLight: true,
  ),
  'jiangmen-kaiping-diaolou': _CinematicBackgroundStyle(
    keyName: 'jiangmen-kaiping-diaolou',
    duration: Duration(seconds: 30),
    skyColor: Color(0xFFFFE0A2),
    atmosphereColor: Color(0xFF8AA06F),
    foregroundColor: Color(0xFF24331F),
    cameraTravel: Offset(12, 8),
  ),
  'dunhuang-mogao-caves': _CinematicBackgroundStyle(
    keyName: 'dunhuang-mogao-caves',
    duration: Duration(seconds: 31),
    skyColor: Color(0xFFFFD38A),
    atmosphereColor: Color(0xFFB2794E),
    foregroundColor: Color(0xFF2A1D17),
    cameraTravel: Offset(10, 10),
  ),
  'chengde-mountain-resort': _CinematicBackgroundStyle(
    keyName: 'chengde-mountain-resort',
    duration: Duration(seconds: 32),
    skyColor: Color(0xFFE6F0DF),
    atmosphereColor: Color(0xFF73958A),
    foregroundColor: Color(0xFF17352D),
    cameraTravel: Offset(9, 7),
    waterLight: true,
  ),
  'xiamen-kulangsu': _CinematicBackgroundStyle(
    keyName: 'xiamen-kulangsu',
    duration: Duration(seconds: 30),
    skyColor: Color(0xFFFFD9A1),
    atmosphereColor: Color(0xFF5F9EAA),
    foregroundColor: Color(0xFF173A38),
    cameraTravel: Offset(11, 8),
    waterLight: true,
  ),
  'pingyao-ancient-city': _CinematicBackgroundStyle(
    keyName: 'pingyao-ancient-city',
    duration: Duration(seconds: 31),
    skyColor: Color(0xFFFFD39A),
    atmosphereColor: Color(0xFF76615A),
    foregroundColor: Color(0xFF211D1B),
    cameraTravel: Offset(10, 8),
  ),
  'qufu-confucius-sites': _CinematicBackgroundStyle(
    keyName: 'qufu-confucius-sites',
    duration: Duration(seconds: 30),
    skyColor: Color(0xFFFFE0AE),
    atmosphereColor: Color(0xFF7B8B6E),
    foregroundColor: Color(0xFF202B22),
    cameraTravel: Offset(8, 10),
  ),
  'leshan-giant-buddha': _CinematicBackgroundStyle(
    keyName: 'leshan-giant-buddha',
    duration: Duration(seconds: 32),
    skyColor: Color(0xFFFFD49B),
    atmosphereColor: Color(0xFF738C7A),
    foregroundColor: Color(0xFF172B28),
    cameraTravel: Offset(9, 9),
  ),
  'wuyishan-nine-bend-stream': _CinematicBackgroundStyle(
    keyName: 'wuyishan-nine-bend-stream',
    duration: Duration(seconds: 33),
    skyColor: Color(0xFFE5EEF0),
    atmosphereColor: Color(0xFF6B9B8A),
    foregroundColor: Color(0xFF12362D),
    cameraTravel: Offset(10, 7),
    waterLight: true,
  ),
  'honghe-hani-rice-terraces': _CinematicBackgroundStyle(
    keyName: 'honghe-hani-rice-terraces',
    duration: Duration(seconds: 32),
    skyColor: Color(0xFFFFB99F),
    atmosphereColor: Color(0xFF7296A8),
    foregroundColor: Color(0xFF173C2C),
    cameraTravel: Offset(11, 8),
    waterLight: true,
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

    if (_completeJourneyPages.contains(pageType)) {
      return _CompleteJourneyBackground(
        journeyId: journeyId,
        pageType: pageType,
        assetPath: _specialCompleteAssets[journeyId]?[pageType] ?? asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }

    if (SpecialRealmBackground.supports(journeyId)) {
      return SpecialRealmBackground(
        journeyId: journeyId,
        pageType: pageType,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }
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

    return _StaticJourneyBackground(
      assetPath: asset?.assetPath,
      imageKey: asset == null ? null : 'journey-background-${asset.id}',
      fit: BoxFit.cover,
      scrimStrength: visibleScrimStrength,
      child: child,
    );
  }
}

class _CompleteJourneyBackground extends StatelessWidget {
  const _CompleteJourneyBackground({
    required this.journeyId,
    required this.pageType,
    required this.assetPath,
    required this.scrimStrength,
    required this.child,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final String? assetPath;
  final double scrimStrength;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('journey-complete-background-$journeyId-${pageType.name}'),
      child: _StaticJourneyBackground(
        assetPath: assetPath,
        imageKey: 'journey-complete-image-$journeyId-${pageType.name}',
        fit: BoxFit.contain,
        scrimStrength: scrimStrength,
        child: child,
      ),
    );
  }
}

class _StaticJourneyBackground extends StatelessWidget {
  const _StaticJourneyBackground({
    required this.assetPath,
    required this.imageKey,
    required this.fit,
    required this.scrimStrength,
    required this.child,
  });

  final String? assetPath;
  final String? imageKey;
  final BoxFit fit;
  final double scrimStrength;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _BackgroundFallback(),
        if (assetPath != null)
          ExcludeSemantics(
            child: Image.asset(
              assetPath!,
              key: imageKey == null ? null : ValueKey(imageKey),
              fit: fit,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => const _BackgroundFallback(),
            ),
          ),
        _JourneyBackgroundScrim(strength: scrimStrength),
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
    if (_destinationReduceMotion(context)) {
      _motion
        ..stop()
        ..value = .46;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
    final path = widget.assetPath;
    if (path != null) precacheImage(AssetImage(path), context);
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
                final cameraProgress = .5 + .5 * math.sin(raw * math.pi * 2);
                final lightProgress = .5 + .5 * math.sin(raw * math.pi * 2 + 1.1);
                final shadowProgress = .5 + .5 * math.sin(raw * math.pi * 2 - .7);
                final depthProgress = .5 + .5 * math.sin(raw * math.pi * 3 + .4);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _MotionImageLayer(
                      assetPath: widget.assetPath,
                      transformKey: 'forbidden-city-camera-transform',
                      progress: cameraProgress,
                      travel: const Offset(12, 12),
                    ),
                    _MovingGlow(
                      keyName: 'forbidden-city-dawn-light',
                      progress: lightProgress,
                      color: const Color(0xFFFFC36E),
                    ),
                    _MovingShade(
                      keyName: 'forbidden-city-cloud-shadow',
                      progress: shadowProgress,
                    ),
                    _ForegroundDepth(
                      keyName: 'forbidden-city-gate-depth',
                      progress: depthProgress,
                      color: const Color(0xFF6E201C),
                    ),
                  ],
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
    if (_destinationReduceMotion(context)) {
      _motion
        ..stop()
        ..value = .47;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
    final path = widget.assetPath;
    if (path != null) precacheImage(AssetImage(path), context);
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
                final skylineProgress = .5 + .5 * math.sin(raw * math.pi * 2 + 1.35);
                final riverProgress = .5 + .5 * math.sin(raw * math.pi * 3 - .55);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _MotionImageLayer(
                      assetPath: widget.assetPath,
                      transformKey: 'shanghai-bund-camera-transform',
                      progress: sceneProgress,
                      travel: const Offset(14, 6),
                      filterQuality: FilterQuality.high,
                    ),
                    _MovingGlow(
                      keyName: 'shanghai-bund-skyline-glow',
                      progress: skylineProgress,
                      color: const Color(0xFFFFB86D),
                    ),
                    _MovingGlow(
                      keyName: 'shanghai-bund-river-light',
                      progress: riverProgress,
                      color: const Color(0xFF92D5E8),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
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
    if (_destinationReduceMotion(context)) {
      _motion.stop();
      _motion.value = .44;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
    final path = widget.assetPath;
    if (path != null) precacheImage(AssetImage(path), context);
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
                final cameraProgress = .5 + .5 * math.sin(raw * math.pi * 2);
                final gradeProgress = .5 + .5 * math.sin(raw * math.pi * 2 + .8);
                final lightProgress = .5 + .5 * math.sin(raw * math.pi * 2 + 1.5);
                final mistProgress = .5 + .5 * math.sin(raw * math.pi * 2 - .6);
                final waterProgress = .5 + .5 * math.sin(raw * math.pi * 3 + .25);
                final breathProgress = .5 + .5 * math.sin(raw * math.pi * 2.5 - 1.1);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _MotionImageLayer(
                      assetPath: widget.assetPath,
                      transformKey: 'summer-palace-camera-transform',
                      layerKey: 'summer-palace-camera-layer',
                      progress: cameraProgress,
                      travel: const Offset(10, 5),
                    ),
                    _ColorGrade(
                      keyName: 'summer-palace-cinematic-color-grade',
                      progress: gradeProgress,
                    ),
                    _MovingGlow(
                      keyName: 'summer-palace-cloud-light',
                      progress: lightProgress,
                      color: const Color(0xFFFFDCA3),
                    ),
                    _MistVeil(
                      keyName: 'summer-palace-mist-veil',
                      progress: mistProgress,
                    ),
                    _MovingGlow(
                      keyName: 'summer-palace-water-shimmer',
                      progress: waterProgress,
                      color: const Color(0xFFFFE4B0),
                      alignment: Alignment.bottomCenter,
                    ),
                    _ForegroundDepth(
                      keyName: 'summer-palace-foreground-breath',
                      progress: breathProgress,
                      color: const Color(0xFF17382E),
                    ),
                  ],
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
    _motion = AnimationController(vsync: this, duration: widget.style.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
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
                final cameraProgress = .5 + .5 * math.sin(raw * math.pi * 2);
                final lightProgress = .5 + .5 * math.sin(raw * math.pi * 2 + 1.15);
                final atmosphereProgress = .5 + .5 * math.sin(raw * math.pi * 2 - .65);
                final depthProgress = .5 + .5 * math.sin(raw * math.pi * 2.5 + .4);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _MotionImageLayer(
                      assetPath: widget.assetPath,
                      transformKey: '${style.keyName}-camera-transform',
                      layerKey: '${style.keyName}-camera-layer',
                      progress: cameraProgress,
                      travel: style.cameraTravel,
                    ),
                    _CinematicMovingLight(progress: lightProgress, style: style),
                    _CinematicAtmosphere(progress: atmosphereProgress, style: style),
                    _CinematicForegroundDepth(progress: depthProgress, style: style),
                    if (style.waterLight)
                      _CinematicWaterLight(progress: atmosphereProgress, style: style),
                  ],
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

class _CinematicMovingLight extends StatelessWidget {
  const _CinematicMovingLight({required this.progress, required this.style});
  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) => _MovingGlow(
        keyName: '${style.keyName}-moving-light',
        progress: progress,
        color: style.skyColor,
      );
}

class _CinematicAtmosphere extends StatelessWidget {
  const _CinematicAtmosphere({required this.progress, required this.style});
  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) => _MistVeil(
        keyName: '${style.keyName}-atmosphere',
        progress: progress,
        color: style.atmosphereColor,
      );
}

class _CinematicForegroundDepth extends StatelessWidget {
  const _CinematicForegroundDepth({required this.progress, required this.style});
  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) => _ForegroundDepth(
        keyName: '${style.keyName}-foreground-depth',
        progress: progress,
        color: style.foregroundColor,
      );
}

class _CinematicWaterLight extends StatelessWidget {
  const _CinematicWaterLight({required this.progress, required this.style});
  final double progress;
  final _CinematicBackgroundStyle style;

  @override
  Widget build(BuildContext context) => _MovingGlow(
        keyName: '${style.keyName}-water-light',
        progress: progress,
        color: style.skyColor,
        alignment: Alignment.bottomCenter,
      );
}

class _MotionImageLayer extends StatelessWidget {
  const _MotionImageLayer({
    required this.assetPath,
    required this.transformKey,
    required this.progress,
    required this.travel,
    this.layerKey,
    this.filterQuality = FilterQuality.high,
  });

  final String? assetPath;
  final String transformKey;
  final String? layerKey;
  final double progress;
  final Offset travel;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null) return const _BackgroundFallback();
    return RepaintBoundary(
      key: layerKey == null ? null : ValueKey(layerKey),
      child: Transform.translate(
        key: ValueKey(transformKey),
        offset: Offset(
          -travel.dx / 2 + travel.dx * progress,
          -travel.dy + travel.dy * progress,
        ),
        child: Transform.scale(
          scale: 1.06 + .022 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: filterQuality,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const _BackgroundFallback(),
          ),
        ),
      ),
    );
  }
}

class _MovingGlow extends StatelessWidget {
  const _MovingGlow({
    required this.keyName,
    required this.progress,
    required this.color,
    this.alignment = Alignment.topCenter,
  });

  final String keyName;
  final double progress;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: FractionallySizedBox(
          widthFactor: 1.6,
          heightFactor: .58,
          child: Transform.translate(
            offset: Offset(-72 + 144 * progress, -8 + 10 * progress),
            child: DecoratedBox(
              key: ValueKey(keyName),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.65 + 1.3 * progress, -.35),
                  radius: 1.05,
                  colors: [
                    color.withValues(alpha: .16),
                    Colors.white.withValues(alpha: .055),
                    Colors.transparent,
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

class _MovingShade extends StatelessWidget {
  const _MovingShade({required this.keyName, required this.progress});
  final String keyName;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 1.7,
        heightFactor: .56,
        child: Transform.translate(
          offset: Offset(110 - 220 * progress, 8 + 10 * progress),
          child: DecoratedBox(
            key: ValueKey(keyName),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF17202D).withValues(alpha: .10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForegroundDepth extends StatelessWidget {
  const _ForegroundDepth({
    required this.keyName,
    required this.progress,
    required this.color,
  });
  final String keyName;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: .46,
          child: Transform.translate(
            offset: Offset(0, 6 - 10 * progress),
            child: DecoratedBox(
              key: ValueKey(keyName),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    color.withValues(alpha: .04),
                    color.withValues(alpha: .14),
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

class _ColorGrade extends StatelessWidget {
  const _ColorGrade({required this.keyName, required this.progress});
  final String keyName;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        key: ValueKey(keyName),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFE7B8).withValues(alpha: .05 + .02 * progress),
              Colors.transparent,
              const Color(0xFF163E42).withValues(alpha: .03),
            ],
          ),
        ),
      ),
    );
  }
}

class _MistVeil extends StatelessWidget {
  const _MistVeil({
    required this.keyName,
    required this.progress,
    this.color = const Color(0xFFEAF3EF),
  });
  final String keyName;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, .1),
        child: FractionallySizedBox(
          widthFactor: 1.55,
          heightFactor: .42,
          child: Transform.translate(
            offset: Offset(42 - 84 * progress, 2 + 4 * progress),
            child: DecoratedBox(
              key: ValueKey(keyName),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    color.withValues(alpha: .04),
                    Colors.white.withValues(alpha: .08),
                    Colors.transparent,
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
