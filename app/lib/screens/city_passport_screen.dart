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
      padding: const EdgeInsets.fromLTRB(7, 6, 7, 4),
      child: Column(
        children: [
          _PassportHeader(state: state),
          const SizedBox(height: 4),
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
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .68),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            state.displayText('探索护照'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14.5,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: PhoenixTheme.red.withValues(alpha: .07),
              width: .6,
            ),
          ),
          child: Text(
            _passportAllAccessPreview
                ? state.displayText('全部开放')
                : state.displayText('${state.earnedStampCount} 枚印章'),
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
            ),
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
    final today = state.todayJourney.cityId == city.id;

    return Container(
      key: ValueKey('passport-city-${city.id}'),
      padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
      decoration: BoxDecoration(
        color: active
            ? PhoenixTheme.red.withValues(alpha: .05)
            : Colors.white.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: active
              ? PhoenixTheme.red.withValues(alpha: .12)
              : PhoenixTheme.gold.withValues(alpha: .08),
          width: .6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 19,
                height: 19,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PhoenixTheme.red.withValues(alpha: .04),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  city.cityCode,
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  state.displayText(city.name),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (today)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    state.displayText('今日'),
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              Text(
                '$earnedCount/${city.destinationCount}',
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 6.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
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
    final allAccess = _passportAllAccessPreview;
    final available = earned || active || isToday || allAccess;
    final status = earned
        ? '已盖章'
        : active && state.hasJourneyInProgress
            ? '${state.journeyProgressPercent}%'
            : allAccess
                ? '可体验'
                : isToday
                    ? '今日'
                    : '未开放';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        key: ValueKey('passport-destination-${journey.id}'),
        onTap: available ? () => unawaited(_openJourney(context)) : null,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: active
                ? PhoenixTheme.red.withValues(alpha: .045)
                : Colors.white.withValues(alpha: .055),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: earned
                  ? PhoenixTheme.red.withValues(alpha: .11)
                  : available
                      ? PhoenixTheme.gold.withValues(alpha: .10)
                      : Colors.black.withValues(alpha: .025),
              width: .6,
            ),
          ),
          child: Row(
            children: [
              CityJourneyStamp(
                journey: journey,
                isUnlocked: earned || allAccess,
                size: 30,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText(journey.place),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      state.displayText(status),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: earned
                            ? PhoenixTheme.red.withValues(alpha: .76)
                            : Colors.black38,
                        fontSize: 6.5,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (available)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black.withValues(alpha: .15),
                  size: 12,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
