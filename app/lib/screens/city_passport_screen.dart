import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_city_catalog.dart';
import '../services/journey_location_binding.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_symbol_badge.dart';
import '../widgets/special_journey_passport.dart';
import 'journey_screen.dart';

bool get _passportAllAccessPreview {
  final uri = Uri.base;
  return uri.queryParameters['unlock'] == 'all' ||
      uri.host.startsWith('phoenix-journeys-pr-');
}

class CityPassportScreen extends StatelessWidget {
  const CityPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Stack(
      key: const ValueKey('passport-hd-atlas-page'),
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFF2E2BD)),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 7),
          child: Column(
            children: [
              _PassportHeader(state: state),
              const SizedBox(height: 7),
              SpecialJourneyPassport(state: state),
              const SizedBox(height: 7),
              Expanded(child: _PassportMap(state: state)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PassportHeader extends StatelessWidget {
  const _PassportHeader({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .88),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            state.displayText('探索护照'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 17,
              height: 1,
              fontWeight: FontWeight.w900,
              shadows: const [
                Shadow(color: Color(0x99FFF8E8), blurRadius: 8),
              ],
            ),
          ),
        ),
        Text(
          _passportAllAccessPreview
              ? state.displayText('全开放')
              : '${state.earnedStampCount} 枚',
          style: const TextStyle(
            color: PhoenixTheme.red,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PassportMap extends StatelessWidget {
  const _PassportMap({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapSize = constraints.biggest;
        final markerPlacements = _resolveCityMarkerPlacements(mapSize);
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: InteractiveViewer(
            key: const ValueKey('passport-pinch-zoom-map'),
            minScale: .85,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(90),
            panEnabled: true,
            scaleEnabled: true,
            clipBehavior: Clip.hardEdge,
            child: SizedBox.fromSize(
              size: mapSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        1.12, -.04, -.04, 0, 0,
                        -.04, 1.12, -.04, 0, 0,
                        -.04, -.04, 1.12, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                      child: Image.asset(
                        'assets/images/maps/china-passport-atlas-v2.webp',
                        key: const ValueKey('passport-hd-atlas-image'),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(.18, -.20),
                          radius: 1.12,
                          colors: [
                            Color(0x00FFF8E8),
                            Color(0x120D4A45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  for (final city in journeyCityCatalog)
                    _CityMapMarker(
                      state: state,
                      city: city,
                      placement: markerPlacements[city.id]!,
                    ),
                  Positioned(
                    left: 9,
                    bottom: 9,
                    child: IgnorePointer(
                      child: Container(
                        key: const ValueKey('passport-pinch-hint'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xD92A2019),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          state.displayText('双指缩放 · 拖动地图'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CityMarkerPlacement {
  const _CityMarkerPlacement({required this.rect, required this.labelOnLeft});

  final Rect rect;
  final bool labelOnLeft;
}

Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Size mapSize) {
  const markerSize = Size(51, 23);
  const mapPadding = 5.0;
  final occupied = <Rect>[];
  final placements = <String, _CityMarkerPlacement>{};

  for (final city in journeyCityCatalog) {
    final binding = requireJourneyLocation(city.primaryDestination.id);
    final longitudeRatio = ((binding.longitude - 73) / (135 - 73)).clamp(0, 1);
    final latitudeRatio = ((binding.latitude - 18) / (54 - 18)).clamp(0, 1);
    final anchor = Offset(
      mapSize.width * (.10 + longitudeRatio * .78),
      mapSize.height * (.08 + (1 - latitudeRatio) * .82),
    );
    final candidates = <({Offset offset, bool labelOnLeft})>[
      (offset: const Offset(-5, -11.5), labelOnLeft: false),
      (offset: const Offset(-46, -11.5), labelOnLeft: true),
      (offset: const Offset(-5, -36), labelOnLeft: false),
      (offset: const Offset(-46, -36), labelOnLeft: true),
      (offset: const Offset(-5, 13), labelOnLeft: false),
      (offset: const Offset(-46, 13), labelOnLeft: true),
      (offset: const Offset(9, -24), labelOnLeft: false),
      (offset: const Offset(-60, 1), labelOnLeft: true),
    ];

    _CityMarkerPlacement? selected;
    for (final candidate in candidates) {
      final rawRect = candidate.offset & markerSize;
      final translated = rawRect.shift(anchor);
      final rect = Rect.fromLTWH(
        translated.left.clamp(mapPadding, mapSize.width - markerSize.width - mapPadding),
        translated.top.clamp(mapPadding, mapSize.height - markerSize.height - mapPadding),
        markerSize.width,
        markerSize.height,
      );
      final paddedRect = rect.inflate(3);
      if (occupied.every((other) => !other.overlaps(paddedRect))) {
        selected = _CityMarkerPlacement(
          rect: rect,
          labelOnLeft: candidate.labelOnLeft,
        );
        break;
      }
    }

    selected ??= _CityMarkerPlacement(
      rect: Rect.fromLTWH(
        (anchor.dx - markerSize.width / 2)
            .clamp(mapPadding, mapSize.width - markerSize.width - mapPadding),
        (anchor.dy - markerSize.height / 2)
            .clamp(mapPadding, mapSize.height - markerSize.height - mapPadding),
        markerSize.width,
        markerSize.height,
      ),
      labelOnLeft: false,
    );
    occupied.add(selected.rect.inflate(3));
    placements[city.id] = selected;
  }

  return placements;
}

class _CityMapMarker extends StatelessWidget {
  const _CityMapMarker({
    required this.state,
    required this.city,
    required this.placement,
  });

  final AppState state;
  final JourneyCityCatalogEntry city;
  final _CityMarkerPlacement placement;

  Future<void> _showCityJourneys(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF3),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('${city.name} · 选择旅程'),
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                state.displayText('点击地点，打开它的故事与学习旅程。'),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 12),
              for (final journey in city.destinations)
                _DestinationStampTile(state: state, journey: journey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = city.destinations.any(
      (journey) => state.isJourneyStampEarned(journey.id),
    );
    final pin = Container(
      key: ValueKey('passport-city-pin-${city.id}'),
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: earned ? PhoenixTheme.gold : PhoenixTheme.red,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFF7E5), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x55000000), blurRadius: 4),
        ],
      ),
    );
    final label = Text(
      state.displayText(city.name),
      maxLines: 1,
      overflow: TextOverflow.visible,
      style: const TextStyle(
        color: Color(0xFF2B211C),
        fontSize: 8.5,
        height: 1,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(color: Color(0xFFFFF8E8), blurRadius: 5),
          Shadow(color: Color(0xFFFFF8E8), blurRadius: 9),
        ],
      ),
    );

    return Positioned(
      key: ValueKey('passport-city-${city.id}'),
      left: placement.rect.left,
      top: placement.rect.top,
      width: placement.rect.width,
      height: placement.rect.height,
      child: Semantics(
        button: true,
        label: state.displayText('${city.name}旅程地点'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => unawaited(_showCityJourneys(context)),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                mainAxisAlignment: placement.labelOnLeft
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: placement.labelOnLeft
                    ? [label, const SizedBox(width: 3), pin]
                    : [pin, const SizedBox(width: 3), label],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationStampTile extends StatelessWidget {
  const _DestinationStampTile({required this.state, required this.journey});

  final AppState state;
  final DailyJourneyExperience journey;

  Future<void> _openJourney(BuildContext context) async {
    Navigator.of(context).pop();
    await state.activateJourney(journey.id);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JourneyScreen(journeyId: journey.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = state.isJourneyStampEarned(journey.id);
    final active = state.activeJourneyId == journey.id;
    final isToday = state.todayJourney.id == journey.id;
    final enabled = _passportAllAccessPreview || isToday || active || earned;

    return Semantics(
      button: true,
      enabled: enabled,
      label: state.displayText('${journey.place}旅程'),
      child: Material(
        key: ValueKey('passport-destination-${journey.id}'),
        color: const Color(0x0FFFFFFF),
        child: InkWell(
          onTap: enabled ? () => unawaited(_openJourney(context)) : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: PhoenixTheme.red.withValues(alpha: .08),
          highlightColor: PhoenixTheme.gold.withValues(alpha: .06),
          child: SizedBox(
            height: 58,
            child: Row(
              children: [
                JourneySymbolBadge(
                  journeyId: journey.id,
                  isUnlocked: enabled,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.displayText(journey.place),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: enabled
                          ? const Color(0xFF251A15)
                          : Colors.black45,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(color: Color(0xCCFFF8E8), blurRadius: 7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
