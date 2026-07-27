import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_city_catalog.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/city_journey_stamp.dart';
import '../widgets/journey_share_button.dart';
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      child: Column(
        children: [
          _PassportHeader(state: state),
          const SizedBox(height: 6),
          _CityOverview(state: state),
          const SizedBox(height: 6),
          SpecialJourneyPassport(state: state),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: journeyCityCatalog.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _CityCollection(
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
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .88),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 17,
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
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                state.displayText(
                  _passportAllAccessPreview
                      ? '体验版已开放全部城市与地点。'
                      : '收藏每个地点的旅程印章。',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .46),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: PhoenixTheme.red.withValues(alpha: .14),
              width: .8,
            ),
          ),
          child: Text(
            _passportAllAccessPreview
                ? state.displayText('全开放')
                : '${state.earnedStampCount} 枚',
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CityOverview extends StatelessWidget {
  const _CityOverview({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF12353A).withValues(alpha: .76),
            const Color(0xFF285E61).withValues(alpha: .68),
            const Color(0xFF143B40).withValues(alpha: .74),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: .16),
          width: .8,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.displayText('城市收藏地图'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                state.displayText('${journeyCityCatalog.length} 座城市'),
                style: const TextStyle(
                  color: Color(0xFFFFD879),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 51,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: journeyCityCatalog.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final city = journeyCityCatalog[index];
                final earnedCount = city.destinations
                    .where((journey) => state.isJourneyStampEarned(journey.id))
                    .length;
                final today = state.todayJourney.cityId == city.id;
                final available =
                    _passportAllAccessPreview || earnedCount > 0 || today;

                return SizedBox(
                  width: 48,
                  child: Column(
                    children: [
                      Container(
                        width: 29,
                        height: 29,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF102E33).withValues(alpha: .64),
                          border: Border.all(
                            color: available
                                ? const Color(0xFFFFD879).withValues(alpha: .80)
                                : Colors.white24,
                            width: today ? 1.8 : 1,
                          ),
                        ),
                        child: Text(
                          earnedCount > 0 || _passportAllAccessPreview
                              ? city.primaryDestination.stampSymbol
                              : (today ? '今' : '锁'),
                          style: TextStyle(
                            color: available
                                ? const Color(0xFFFFD879)
                                : Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.displayText(city.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$earnedCount/${city.destinationCount}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCollection extends StatelessWidget {
  const _CityCollection({required this.state, required this.city});

  final AppState state;
  final JourneyCityCatalogEntry city;

  @override
  Widget build(BuildContext context) {
    final earnedCount = city.destinations
        .where((journey) => state.isJourneyStampEarned(journey.id))
        .length;
    final progress = earnedCount / city.destinationCount;
    final active = state.activeJourney.cityId == city.id;
    final today = state.todayJourney.cityId == city.id;
    final complete = earnedCount == city.destinationCount;

    return Column(
      key: ValueKey('passport-city-${city.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: active
                  ? [
                      const Color(0xFF7B1E1E).withValues(alpha: .74),
                      const Color(0xFFA83A32).withValues(alpha: .68),
                    ]
                  : [
                      Colors.white.withValues(alpha: .50),
                      const Color(0xFFFFF8EC).withValues(alpha: .34),
                    ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? PhoenixTheme.red.withValues(alpha: .38)
                  : PhoenixTheme.gold.withValues(alpha: .24),
              width: .8,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white.withValues(alpha: .10)
                          : PhoenixTheme.red.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      city.cityCode,
                      style: TextStyle(
                        color: active ? Colors.white : PhoenixTheme.red,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                state.displayText('${city.name}收藏册'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: active ? Colors.white : Colors.black87,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (today) ...[
                              const SizedBox(width: 5),
                              _TodayBadge(active: active),
                            ],
                          ],
                        ),
                        Text(
                          state.displayText(
                            '${city.destinationCount} 个地点 · $earnedCount 枚印章',
                          ),
                          style: TextStyle(
                            color: active ? Colors.white60 : Colors.black45,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white.withValues(alpha: .09)
                          : Colors.white.withValues(alpha: .32),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          complete
                              ? Icons.verified_rounded
                              : Icons.auto_stories_rounded,
                          color: active
                              ? const Color(0xFFFFD879)
                              : PhoenixTheme.red,
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '$earnedCount/${city.destinationCount}',
                          style: TextStyle(
                            color: active ? Colors.white : PhoenixTheme.red,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  color: active ? const Color(0xFFFFD879) : PhoenixTheme.red,
                  backgroundColor: active
                      ? Colors.white.withValues(alpha: .12)
                      : PhoenixTheme.gold.withValues(alpha: .12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        for (var index = 0; index < city.destinations.length; index++) ...[
          if (index > 0) const SizedBox(height: 5),
          _DestinationStampCard(
            state: state,
            journey: city.destinations[index],
          ),
        ],
      ],
    );
  }
}

class _TodayBadge extends StatelessWidget {
  const _TodayBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFD879).withValues(alpha: .14)
            : PhoenixTheme.red.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        state.displayText('今日'),
        style: TextStyle(
          color: active ? const Color(0xFFFFD879) : PhoenixTheme.red,
          fontSize: 7,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DestinationStampCard extends StatelessWidget {
  const _DestinationStampCard({required this.state, required this.journey});

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
    final status = earned
        ? '已获得'
        : active && state.hasJourneyInProgress
            ? '${state.journeyProgressPercent}%'
            : allAccess
                ? '体验开放'
                : isToday
                    ? '今日旅程'
                    : '等待轮换';

    return Container(
      key: ValueKey('passport-destination-${journey.id}'),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .46),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: earned
              ? PhoenixTheme.red.withValues(alpha: .20)
              : allAccess || isToday
                  ? PhoenixTheme.gold.withValues(alpha: .42)
                  : PhoenixTheme.gold.withValues(alpha: .18),
          width: .8,
        ),
      ),
      child: Row(
        children: [
          CityJourneyStamp(
            journey: journey,
            isUnlocked: earned || allAccess,
            size: 48,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.displayText(journey.place),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: earned
                            ? PhoenixTheme.red.withValues(alpha: .06)
                            : PhoenixTheme.gold.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        state.displayText(status),
                        style: TextStyle(
                          color: earned ? PhoenixTheme.red : Colors.black45,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  state.displayText(journey.description),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 9,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 29,
                  child: earned
                      ? Row(
                          children: [
                            Expanded(
                              child: JourneyShareButton(
                                isTraditional: state.isTraditional,
                                city: journey.city,
                                place: journey.place,
                                compact: true,
                                label: state.displayText('分享印章'),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => unawaited(_openJourney(context)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  visualDensity: VisualDensity.compact,
                                ),
                                icon: const Icon(Icons.replay_rounded, size: 13),
                                label: Text(
                                  state.displayText('再次体验'),
                                  style: const TextStyle(fontSize: 8.5),
                                ),
                              ),
                            ),
                          ],
                        )
                      : FilledButton.icon(
                          onPressed: allAccess || isToday || active
                              ? () => unawaited(_openJourney(context))
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: PhoenixTheme.red,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: Icon(
                            active && state.hasJourneyInProgress
                                ? Icons.play_arrow_rounded
                                : Icons.flight_takeoff_rounded,
                            size: 13,
                          ),
                          label: Text(
                            state.displayText(
                              active && state.hasJourneyInProgress
                                  ? '继续旅程'
                                  : allAccess
                                      ? '开始体验'
                                      : isToday
                                          ? '开始今日旅程'
                                          : '等待成为今日旅程',
                            ),
                            style: const TextStyle(fontSize: 8.8),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
