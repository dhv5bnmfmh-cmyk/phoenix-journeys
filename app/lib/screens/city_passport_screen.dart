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
        Image.asset(
          'assets/images/maps/china-passport-atlas-v2.webp',
          key: const ValueKey('passport-hd-atlas-image'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x24FFF8E8),
                Color(0x08FFF8E8),
                Color(0x16FFF8E8),
              ],
            ),
          ),
        ),
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
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          for (final city in journeyCityCatalog)
            _CityMapMarker(
              state: state,
              city: city,
              mapSize: constraints.biggest,
            ),
        ],
      ),
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
    return Offset(
      mapSize.width * (.10 + longitudeRatio * .78),
      mapSize.height * (.08 + (1 - latitudeRatio) * .82),
    );
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
      left: (point.dx - 29).clamp(0, mapSize.width - 70),
      top: (point.dy - 25).clamp(0, mapSize.height - 58),
      child: Semantics(
        button: true,
        label: state.displayText('${city.name}旅程地点'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => unawaited(_showCityJourneys(context)),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 4, 7, 4),
              decoration: BoxDecoration(
                color: const Color(0xEFFFF8E8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: earned
                      ? PhoenixTheme.gold
                      : PhoenixTheme.red.withValues(alpha: .52),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x26000000), blurRadius: 8),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CityJourneyStamp(
                    journey: city.primaryDestination,
                    isUnlocked: earned || _passportAllAccessPreview,
                    size: 27,
                    transparentInk: true,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state.displayText(city.name),
                    style: const TextStyle(
                      color: Color(0xFF2B211C),
                      fontSize: 10,
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
                CityJourneyStamp(
                  journey: journey,
                  isUnlocked: earned || _passportAllAccessPreview,
                  size: 36,
                  transparentInk: true,
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
