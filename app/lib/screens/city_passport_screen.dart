import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_city_catalog.dart';
import '../services/journey_location_binding.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/city_journey_stamp.dart';
import '../widgets/special_journey_passport.dart';
import '../widgets/journey_symbol_badge.dart';
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
                      mapSize: mapSize,
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

class _CityMapMarker extends StatelessWidget {
  const _CityMapMarker({
    required this.state,
    required this.city,
    required this.mapSize,
  });

  final AppState state;
  final JourneyCityCatalogEntry city;
  final Size mapSize;

  Offset get _mapPoint {
    final binding = requireJourneyLocation(city.primaryDestination.id);
    final longitudeRatio = ((binding.longitude - 73) / (135 - 73)).clamp(0, 1);
    final latitudeRatio = ((binding.latitude - 18) / (54 - 18)).clamp(0, 1);
    final anchor = Offset(
      mapSize.width * (.10 + longitudeRatio * .78),
      mapSize.height * (.08 + (1 - latitudeRatio) * .82),
    );
    return anchor + _collisionOffset;
  }

  Offset get _collisionOffset {
    switch (city.id) {
      case 'xian':
        return const Offset(-18, -8);
      case 'chengdu':
        return const Offset(-44, 16);
      case 'nanjing':
        return const Offset(24, -14);
      case 'hangzhou':
        return const Offset(48, 18);
      default:
        return Offset.zero;
    }
  }

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
    final point = _mapPoint;
    final earned = city.destinations.any(
      (journey) => state.isJourneyStampEarned(journey.id),
    );
    return Positioned(
      key: ValueKey('passport-city-${city.id}'),
      left: (point.dx - 23).clamp(0, mapSize.width - 56),
      top: (point.dy - 19).clamp(0, mapSize.height - 44),
      child: Semantics(
        button: true,
        label: state.displayText('${city.name}旅程地点'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => unawaited(_showCityJourneys(context)),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
              decoration: BoxDecoration(
                color: const Color(0xE8FFF8E8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: earned
                      ? PhoenixTheme.gold
                      : PhoenixTheme.red.withValues(alpha: .52),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x26000000), blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CityJourneyStamp(
                    journey: city.primaryDestination,
                    isUnlocked: earned || _passportAllAccessPreview,
                    size: 21,
                    transparentInk: true,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    state.displayText(city.name),
                    style: const TextStyle(
                      color: Color(0xFF2B211C),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
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
                  size: 42,
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
