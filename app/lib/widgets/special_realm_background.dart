import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/journey_background.dart';

class SpecialRealmBackground extends StatefulWidget {
  const SpecialRealmBackground({
    super.key,
    required this.journeyId,
    required this.pageType,
    required this.child,
    required this.scrimStrength,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final Widget child;
  final double scrimStrength;

  static const supportedJourneyIds = <String>{
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  };

  static bool supports(String journeyId) {
    return supportedJourneyIds.contains(journeyId);
  }

  @override
  State<SpecialRealmBackground> createState() => _SpecialRealmBackgroundState();
}

class _SpecialRealmBackgroundState extends State<SpecialRealmBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  final Set<String> _precacheAttempted = <String>{};
  int _precacheGeneration = 0;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _schedulePlatePrecache();
  }

  @override
  void didUpdateWidget(covariant SpecialRealmBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.journeyId != widget.journeyId) {
      _precacheAttempted.clear();
      _precacheGeneration += 1;
    }
    if (oldWidget.journeyId != widget.journeyId ||
        oldWidget.pageType != widget.pageType) {
      _schedulePlatePrecache();
    }
  }

  void _syncMotionPreference() {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _motion
        ..stop()
        ..value = .42;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  void _schedulePlatePrecache() {
    final generation = ++_precacheGeneration;
    final journeyId = widget.journeyId;
    final pageType = widget.pageType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _precacheGeneration) return;
      unawaited(
        _precachePlates(
          journeyId: journeyId,
          pageType: pageType,
          generation: generation,
        ),
      );
    });
  }

  Future<void> _precachePlates({
    required String journeyId,
    required JourneyBackgroundPage pageType,
    required int generation,
  }) async {
    final assets = _PremiumRealmPlate.preloadOrderFor(journeyId, pageType);
    for (final asset in assets) {
      if (!mounted || generation != _precacheGeneration) return;
      if (!_precacheAttempted.add(asset)) continue;
      try {
        await precacheImage(AssetImage(asset), context);
      } catch (_) {
        // Image.asset has a retained-plate and gradient fallback. A failed
        // speculative decode must never block the Journey from opening.
      }
      await Future<void>.delayed(Duration.zero);
    }
  }

  @override
  void dispose() {
    _precacheGeneration += 1;
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('special-realm-background-${widget.journeyId}'),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _motion,
          builder: (context, _) => Stack(
            fit: StackFit.expand,
            children: [
              _PremiumRealmPlate(
                journeyId: widget.journeyId,
                pageType: widget.pageType,
                progress: _motion.value,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(
                        alpha: widget.scrimStrength * .35,
                      ),
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: widget.scrimStrength * .92,
                      ),
                    ],
                    stops: const [0, .46, 1],
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumRealmPlate extends StatelessWidget {
  const _PremiumRealmPlate({
    required this.journeyId,
    required this.pageType,
    required this.progress,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final double progress;

  static const _assets = <String, List<String>>{
    'literary-roaming': [
      'assets/images/special-realms/dream-butterfly-v3.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-02.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-03.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-04.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-05.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-06.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-07.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-08.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-09.webp',
      'assets/images/special-realms/ten-scene/dream-butterfly-10.webp',
    ],
    'myth-tracing': [
      'assets/images/special-realms/moon-letter-v2.webp',
      'assets/images/special-realms/ten-scene/moon-letter-02.webp',
      'assets/images/special-realms/ten-scene/moon-letter-03.webp',
      'assets/images/special-realms/ten-scene/moon-letter-04.webp',
      'assets/images/special-realms/ten-scene/moon-letter-05.webp',
      'assets/images/special-realms/ten-scene/moon-letter-06.webp',
      'assets/images/special-realms/ten-scene/moon-letter-07.webp',
      'assets/images/special-realms/ten-scene/moon-letter-08.webp',
      'assets/images/special-realms/ten-scene/moon-letter-09.webp',
      'assets/images/special-realms/ten-scene/moon-letter-10.webp',
    ],
    'strange-night-talks': [
      'assets/images/special-realms/shadowless-inn-v2.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-02.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-03.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-04.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-05.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-06.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-07.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-08.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-09.webp',
      'assets/images/special-realms/ten-scene/shadowless-inn-10.webp',
    ],
    'folk-secret-land': [
      'assets/images/special-realms/upstream-lantern-v3.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-02.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-03.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-04.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-05.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-06.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-07.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-08.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-09.webp',
      'assets/images/special-realms/ten-scene/upstream-lantern-10.webp',
    ],
  };

  static List<String> assetsFor(String journeyId) {
    return _assets[journeyId] ?? const <String>[];
  }

  static List<String> preloadOrderFor(
    String journeyId,
    JourneyBackgroundPage pageType,
  ) {
    final assets = assetsFor(journeyId);
    if (assets.isEmpty) return const <String>[];

    final priorityIndexes = pageType == JourneyBackgroundPage.story
        ? const <int>[1, 2, 3, 0, 4, 5, 6, 7, 8, 9]
        : <int>[
            _assetIndexFor(pageType, 0),
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
          ];
    final seen = <int>{};
    return [
      for (final index in priorityIndexes)
        if (index >= 0 && index < assets.length && seen.add(index)) assets[index],
    ];
  }

  static int _assetIndexFor(
    JourneyBackgroundPage pageType,
    double progress,
  ) {
    return switch (pageType) {
      JourneyBackgroundPage.story =>
        1 + (progress * 3).floor().clamp(0, 2).toInt(),
      JourneyBackgroundPage.vocabulary => 4,
      JourneyBackgroundPage.discovery => 5,
      JourneyBackgroundPage.reflection => 6,
      JourneyBackgroundPage.writing => 7,
      JourneyBackgroundPage.memory => 8,
      JourneyBackgroundPage.completion => 9,
      _ => 0,
    };
  }

  int get _assetIndex => _assetIndexFor(pageType, progress);

  double get _chapter =>
      JourneyBackgroundPage.values.indexOf(pageType) /
      (JourneyBackgroundPage.values.length - 1);

  @override
  Widget build(BuildContext context) {
    final assets = _assets[journeyId]!;
    final phase = progress * math.pi * 2;
    final chapterTravel = (_chapter - .5) * 10;
    final horizontalDrift = switch (journeyId) {
      'literary-roaming' => math.sin(phase) * 2.8,
      'myth-tracing' => math.cos(phase * .7) * 2.2,
      'strange-night-talks' => math.sin(phase * .55) * 1.2,
      'folk-secret-land' => math.sin(phase * .8) * 2.6,
      _ => 0.0,
    };
    final verticalDrift = switch (journeyId) {
      'literary-roaming' => chapterTravel + math.cos(phase * .7) * 1.6,
      'myth-tracing' => -chapterTravel + math.sin(phase * .6) * 1.4,
      'strange-night-talks' => chapterTravel * .35,
      'folk-secret-land' => -chapterTravel * .45 + math.cos(phase * .5) * 1.5,
      _ => 0.0,
    };
    final scale = 1.06 + _chapter * .025 + math.sin(phase * .5) * .002;
    final tone = switch (pageType) {
      JourneyBackgroundPage.story => const Color(0x0AFFF0CD),
      JourneyBackgroundPage.vocabulary => const Color(0x089BD9FF),
      JourneyBackgroundPage.discovery => const Color(0x0CFFF1B8),
      JourneyBackgroundPage.reflection => const Color(0x0D3C7DFF),
      JourneyBackgroundPage.writing => const Color(0x0AE8A4FF),
      JourneyBackgroundPage.memory => const Color(0x0CE8A4FF),
      JourneyBackgroundPage.completion => const Color(0x12FFD36B),
      _ => Colors.transparent,
    };
    final assetPath = assets[_assetIndex];

    return ExcludeSemantics(
      child: Transform.translate(
        offset: Offset(horizontalDrift, verticalDrift),
        child: Transform.scale(
          scale: scale,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1800),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                child: Image.asset(
                  assetPath,
                  key: ValueKey(
                    'special-realm-plate-$journeyId-$_assetIndex',
                  ),
                  fit: BoxFit.cover,
                  alignment: _alignmentForChapter,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => _RetainedRealmPlate(
                    assetPath: assets.first,
                    alignment: _alignmentForChapter,
                  ),
                ),
              ),
              ColoredBox(color: tone),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .035 + _chapter * .015),
                      Colors.transparent,
                      Colors.black.withValues(alpha: .15),
                    ],
                    stops: const [0, .56, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Alignment get _alignmentForChapter {
    final y = -.16 + _chapter * .3;
    return switch (journeyId) {
      'literary-roaming' => Alignment(.08 - _chapter * .14, y),
      'myth-tracing' => Alignment(.15 - _chapter * .18, y),
      'strange-night-talks' => Alignment(.1 - _chapter * .1, y),
      'folk-secret-land' => Alignment(-.06 + _chapter * .12, y),
      _ => Alignment(0, y),
    };
  }
}

class _RetainedRealmPlate extends StatelessWidget {
  const _RetainedRealmPlate({
    required this.assetPath,
    required this.alignment,
  });

  final String assetPath;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      alignment: alignment,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => const _PremiumPlateFallback(),
    );
  }
}

class _PremiumPlateFallback extends StatelessWidget {
  const _PremiumPlateFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      key: ValueKey('special-realm-premium-fallback'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111A2B),
            Color(0xFF30223D),
            Color(0xFF171A24),
          ],
        ),
      ),
    );
  }
}
