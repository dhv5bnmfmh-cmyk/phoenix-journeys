import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/city_journey_stamp.dart';
import '../widgets/journey_share_button.dart';
import 'journey_screen.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Column(
        children: [
          _PassportHeader(state: state),
          const SizedBox(height: 8),
          _PassportMap(state: state),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: dailyJourneyExperiences.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _CityStampCard(
                  state: state,
                  journey: dailyJourneyExperiences[index],
                );
              },
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: PhoenixTheme.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('探索护照'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 1),
              Text(
                state.displayText('每天完成一段 Journey，收藏一座城市。'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            '${state.earnedStampCount} 枚',
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12353A), Color(0xFF285E61), Color(0xFF143B40)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 7),
            color: Color(0x1D000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHINA DAILY JOURNEYS',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.displayText('每日探索地图'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                state.displayText('今日 · ${state.todayJourney.city}'),
                style: const TextStyle(
                  color: Color(0xFFFFD879),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: dailyJourneyExperiences.map((journey) {
              final earned = state.isJourneyStampEarned(journey.id);
              final isToday = state.todayJourney.id == journey.id;
              return Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF102E33),
                        border: Border.all(
                          color: earned || isToday
                              ? const Color(0xFFFFD879)
                              : Colors.white30,
                          width: isToday ? 2.2 : 1.4,
                        ),
                        boxShadow: earned
                            ? const [
                                BoxShadow(
                                  color: Color(0x55FFD879),
                                  blurRadius: 11,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          earned ? journey.stampSymbol : (isToday ? '今' : '锁'),
                          style: TextStyle(
                            color: earned || isToday
                                ? const Color(0xFFFFD879)
                                : Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      state.displayText('${journey.city} ${journey.cityCode}'),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _CityStampCard extends StatelessWidget {
  const _CityStampCard({required this.state, required this.journey});

  final AppState state;
  final DailyJourneyExperience journey;

  Future<void> _openJourney(BuildContext context) async {
    await state.activateJourney(journey.id);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JourneyScreen(journeyId: journey.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = state.isJourneyStampEarned(journey.id);
    final active = state.activeJourneyId == journey.id;
    final isToday = state.todayJourney.id == journey.id;
    final status = earned
        ? '已获得'
        : active && state.hasJourneyInProgress
            ? '${state.journeyProgressPercent}%'
            : isToday
                ? '今日旅程'
                : '等待轮换';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: earned
              ? PhoenixTheme.red.withValues(alpha: .30)
              : isToday
                  ? PhoenixTheme.gold.withValues(alpha: .70)
                  : PhoenixTheme.gold.withValues(alpha: .28),
        ),
      ),
      child: Row(
        children: [
          CityJourneyStamp(
            journey: journey,
            isUnlocked: earned,
            size: 82,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.displayText(journey.stampTitle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: earned
                            ? PhoenixTheme.red.withValues(alpha: .08)
                            : PhoenixTheme.gold.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        state.displayText(status),
                        style: TextStyle(
                          color: earned ? PhoenixTheme.red : Colors.black54,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  state.displayText(journey.description),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10.5,
                    height: 1.22,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 34,
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
                            const SizedBox(width: 6),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => unawaited(_openJourney(context)),
                                icon: const Icon(Icons.replay_rounded, size: 16),
                                label: Text(
                                  state.displayText('再次体验'),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        )
                      : FilledButton.icon(
                          onPressed: isToday || active
                              ? () => unawaited(_openJourney(context))
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: PhoenixTheme.red,
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: Icon(
                            active && state.hasJourneyInProgress
                                ? Icons.play_arrow_rounded
                                : Icons.flight_takeoff_rounded,
                            size: 16,
                          ),
                          label: Text(
                            state.displayText(
                              active && state.hasJourneyInProgress
                                  ? '继续旅程'
                                  : isToday
                                      ? '开始今日旅程'
                                      : '等待成为今日旅程',
                            ),
                            style: const TextStyle(fontSize: 10.5),
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
