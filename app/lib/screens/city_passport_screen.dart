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

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 5),
      child: Column(
        children: [
          _PassportHeader(state: state),
          const SizedBox(height: 5),
          SpecialJourneyPassport(state: state),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: journeyCityCatalog.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) => _CityStampSection(
                state: state,
                city: journeyCityCatalog[index],
              ),
            ),
          ),
        ],
      ),
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
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .90),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('探索护照'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 17,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                state.displayText('点击旅程名或印章即可出发'),
                style: const TextStyle(fontSize: 9.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        Text(
          _passportAllAccessPreview
              ? state.displayText('全开放')
              : '${state.earnedStampCount} 枚',
          style: const TextStyle(
            color: PhoenixTheme.red,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _CityStampSection extends StatelessWidget {
  const _CityStampSection({required this.state, required this.city});

  final AppState state;
  final JourneyCityCatalogEntry city;

  @override
  Widget build(BuildContext context) {
    final earnedCount = city.destinations
        .where((journey) => state.isJourneyStampEarned(journey.id))
        .length;
    final active = state.activeJourney.cityId == city.id;

    return Container(
      key: ValueKey('passport-city-${city.id}'),
      padding: const EdgeInsets.fromLTRB(3, 2, 3, 3),
      decoration: BoxDecoration(
        color: active
            ? PhoenixTheme.red.withValues(alpha: .045)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Text(
                  state.displayText(city.name),
                  style: TextStyle(
                    color: active ? PhoenixTheme.red : Colors.black87,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  '$earnedCount/${city.destinationCount}',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 4) / 2;
              return Wrap(
                spacing: 4,
                runSpacing: 3,
                children: [
                  for (final journey in city.destinations)
                    SizedBox(
                      width: tileWidth,
                      child: _DestinationStampTile(
                        state: state,
                        journey: journey,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DestinationStampTile extends StatelessWidget {
  const _DestinationStampTile({
    required this.state,
    required this.journey,
  });

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
    final available =
        earned || active || isToday || _passportAllAccessPreview;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        key: ValueKey('passport-destination-${journey.id}'),
        onTap: available ? () => unawaited(_openJourney(context)) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(
            color: active
                ? PhoenixTheme.red.withValues(alpha: .055)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CityJourneyStamp(
                journey: journey,
                isUnlocked: earned || _passportAllAccessPreview,
                size: 28,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  state.displayText(journey.place),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: available ? Colors.black87 : Colors.black38,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
