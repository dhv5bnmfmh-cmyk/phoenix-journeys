import 'dart:async';

import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../screens/journey_screen.dart';
import '../state/app_state.dart';

bool get _specialJourneyAllAccessPreview {
  final uri = Uri.base;
  return uri.queryParameters['unlock'] == 'all' ||
      uri.host.startsWith('phoenix-journeys-pr-');
}

class SpecialJourneyPassport extends StatelessWidget {
  const SpecialJourneyPassport({super.key, required this.state});

  final AppState state;

  static const _journeys = <_SpecialJourneyGate>[
    _SpecialJourneyGate(
      id: 'literary-roaming',
      chapter: '庄周梦蝶',
      stamp: '蝶',
      currency: '金币',
      cost: 2,
      accent: Color(0xFF28769A),
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      chapter: '月宫遗简',
      stamp: '月',
      currency: '金币',
      cost: 3,
      accent: Color(0xFF9A6A13),
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      chapter: '无影客栈',
      stamp: '客',
      currency: '银币',
      cost: 3,
      accent: Color(0xFFA33E2D),
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      chapter: '逆流河灯',
      stamp: '灯',
      currency: '铜币',
      cost: 4,
      accent: Color(0xFF9A5319),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('passport-special-journeys'),
      width: double.infinity,
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _journeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (context, index) =>
            _journeyTile(context, _journeys[index]),
      ),
    );
  }

  Widget _journeyTile(BuildContext context, _SpecialJourneyGate journey) {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);

    return Material(
      key: ValueKey('special-journey-${journey.id}'),
      color: Colors.transparent,
      child: InkWell(
        onTap: () => unawaited(_handleJourneyTap(context, journey)),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 106,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: journey.accent.withValues(
                      alpha: unlocked ? .82 : .42,
                    ),
                    width: 1.4,
                  ),
                ),
                child: Text(
                  state.displayText(journey.stamp),
                  style: TextStyle(
                    color: journey.accent.withValues(
                      alpha: unlocked ? .95 : .55,
                    ),
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  state.displayText(journey.chapter),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF2B211C),
                    fontSize: 10.5,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Color(0xCCFFF8E8), blurRadius: 7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleJourneyTap(
    BuildContext context,
    _SpecialJourneyGate journey,
  ) async {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);
    if (unlocked) {
      await _openFullJourney(context, journey.id);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(state.displayText('开启${journey.chapter}？')),
        content: Text(
          state.displayText(
            '开启后进入完整旅程，需要 ${journey.cost} 枚${journey.currency}。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.displayText('暂不开启')),
          ),
          FilledButton(
            key: ValueKey('confirm-special-journey-${journey.id}'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(state.displayText('确认开启')),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await state.unlockSpecialJourney(
      journeyId: journey.id,
      currency: journey.currency,
      cost: journey.cost,
    );
    if (!context.mounted) return;

    switch (result.status) {
      case SpecialJourneyUnlockStatus.unlocked:
      case SpecialJourneyUnlockStatus.alreadyUnlocked:
        await _openFullJourney(context, journey.id);
        return;
      case SpecialJourneyUnlockStatus.insufficientFunds:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.displayText(
                '${journey.currency}不足，还需要 ${result.missing} 枚。',
              ),
            ),
          ),
        );
        return;
      case SpecialJourneyUnlockStatus.busy:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.displayText('正在处理，请稍候再试。'))),
        );
        return;
    }
  }

  Future<void> _openFullJourney(BuildContext context, String journeyId) async {
    requireDailyJourneyExperience(journeyId);
    await state.activateJourney(journeyId);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JourneyScreen(journeyId: journeyId),
      ),
    );
  }
}

class _SpecialJourneyGate {
  const _SpecialJourneyGate({
    required this.id,
    required this.chapter,
    required this.stamp,
    required this.currency,
    required this.cost,
    required this.accent,
  });

  final String id;
  final String chapter;
  final String stamp;
  final String currency;
  final int cost;
  final Color accent;
}
