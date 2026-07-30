import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';
import 'special_realm_background.dart';

const _completeJourneyPages = <JourneyBackgroundPage>{
  JourneyBackgroundPage.story,
  JourneyBackgroundPage.vocabulary,
  JourneyBackgroundPage.discovery,
  JourneyBackgroundPage.reflection,
  JourneyBackgroundPage.memory,
};

const _specialCompleteAssets =
    <String, Map<JourneyBackgroundPage, String>>{
  'changan-last-bus': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/changan-last-bus-02-object.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/changan-last-bus-05-overlap.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/changan-last-bus-06-storm.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/changan-last-bus-07-memory.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/changan-last-bus-09-release.webp',
  },
  'tide-letter': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/tide-letter-02-object.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/tide-letter-05-overlap.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/tide-letter-06-storm.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/tide-letter-07-memory.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/tide-letter-09-release.webp',
  },
  'arcade-lost-property': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/arcade-lost-property-02-object.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/arcade-lost-property-05-overlap.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/arcade-lost-property-06-storm.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/arcade-lost-property-07-memory.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/arcade-lost-property-09-release.webp',
  },
  'tea-horse-echo': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/tea-horse-echo-02-object.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/tea-horse-echo-05-overlap.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/tea-horse-echo-06-storm.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/tea-horse-echo-07-memory.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/tea-horse-echo-09-release.webp',
  },
  'ice-city-star-map': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/ice-city-star-map-02-object.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/ice-city-star-map-05-overlap.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/ice-city-star-map-06-storm.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/ice-city-star-map-07-memory.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/ice-city-star-map-09-release.webp',
  },
  'literary-roaming': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/dream-butterfly-02.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/dream-butterfly-05.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/dream-butterfly-06.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/dream-butterfly-07.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/dream-butterfly-09.webp',
  },
  'myth-tracing': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/moon-letter-02.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/moon-letter-05.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/moon-letter-06.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/moon-letter-07.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/moon-letter-09.webp',
  },
  'strange-night-talks': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/shadowless-inn-02.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/shadowless-inn-05.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/shadowless-inn-06.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/shadowless-inn-07.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/shadowless-inn-09.webp',
  },
  'folk-secret-land': {
    JourneyBackgroundPage.story:
        'assets/images/special-realms/ten-scene/upstream-lantern-02.webp',
    JourneyBackgroundPage.vocabulary:
        'assets/images/special-realms/ten-scene/upstream-lantern-05.webp',
    JourneyBackgroundPage.discovery:
        'assets/images/special-realms/ten-scene/upstream-lantern-06.webp',
    JourneyBackgroundPage.reflection:
        'assets/images/special-realms/ten-scene/upstream-lantern-07.webp',
    JourneyBackgroundPage.memory:
        'assets/images/special-realms/ten-scene/upstream-lantern-09.webp',
  },
};

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
    final selectedAsset = const JourneyBackgroundPolicy().select(
      journeyId: journeyId,
      locationPath: location.locationPath,
      page: pageType,
      localDate: localDate ?? DateTime.now(),
      catalog: journeyBackgroundCatalog,
    );
    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);
    final complete = _completeJourneyPages.contains(pageType);

    if (!complete && SpecialRealmBackground.supports(journeyId)) {
      return SpecialRealmBackground(
        journeyId: journeyId,
        pageType: pageType,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }

    final specialAsset = _specialCompleteAssets[journeyId]?[pageType];
    final assetPath = specialAsset ?? selectedAsset?.assetPath;
    final imageKey = specialAsset != null
        ? 'special-realm-plate-$journeyId-${pageType.name}'
        : selectedAsset == null
            ? 'journey-background-$journeyId-${pageType.name}'
            : 'journey-background-${selectedAsset.id}';

    return RepaintBoundary(
      key: ValueKey('journey-background-frame-$journeyId-${pageType.name}'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundFallback(),
          if (assetPath != null)
            ExcludeSemantics(
              child: Image.asset(
                assetPath,
                key: ValueKey(imageKey),
                fit: complete ? BoxFit.contain : BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => const _BackgroundFallback(),
              ),
            ),
          _JourneyBackgroundScrim(strength: visibleScrimStrength),
          child,
        ],
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
