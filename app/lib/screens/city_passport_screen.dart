import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_city_catalog.dart';
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
              const SizedBox(height: 5),
              SpecialJourneyPassport(state: state),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: journeyCityCatalog.length,
                  itemBuilder: (context, index) => _CityCollection(
                    state: state,
                    city: journeyCityCatalog[index],
                  ),
                ),
              ),
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

class _CityCollection extends StatelessWidget {
  const _CityCollection({required this.state, required this.city});

  final AppState state;
  final JourneyCityCatalogEntry city;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('passport-city-${city.id}'),
      children: [
        for (final journey in city.destinations)
          _DestinationStampTile(state: state, journey: journey),
      ],
    );
  }
}

class _DestinationStampTile extends StatelessWidget {
  const _DestinationStampTile({required this.state, required this.journey});

  final AppState state;
  final DailyJourneyExperience journey;

  Future<void> _openJourney(BuildContext context) async {
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
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => unawaited(_openJourney(context)) : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: PhoenixTheme.red.withValues(alpha: .08),
          highlightColor: PhoenixTheme.gold.withValues(alpha: .06),
          child: SizedBox(
            height: 52,
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
