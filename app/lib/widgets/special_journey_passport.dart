import 'dart:async';

import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../screens/journey_screen.dart';
import 'city_journey_stamp.dart';

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
      currency: '金币',
      cost: 2,
      icon: Icons.auto_stories_rounded,
      accent: Color(0xFF7FC6E8),
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      chapter: '月宫遗简',
      currency: '金币',
      cost: 3,
      icon: Icons.brightness_7_rounded,
      accent: Color(0xFFFFD46B),
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      chapter: '无影客栈',
      currency: '银币',
      cost: 3,
      icon: Icons.nights_stay_rounded,
      accent: Color(0xFFFF7654),
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      chapter: '逆流河灯',
      currency: '铜币',
      cost: 4,
      icon: Icons.temple_buddhist_rounded,
      accent: Color(0xFFFFA654),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('passport-special-journeys'),
      padding: const EdgeInsets.fromLTRB(3, 2, 3, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.displayText('万象奇旅'),
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
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
                  for (final journey in _journeys)
                    SizedBox(
                      width: tileWidth,
                      child: _journeyCard(context, journey),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _journeyCard(BuildContext context, _SpecialJourneyGate journey) {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);
    final experience = requireDailyJourneyExperience(journey.id);
    return Material(
      key: ValueKey('special-journey-${journey.id}'),
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => unawaited(_handleJourneyTap(context, journey)),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(
            color: unlocked
                ? journey.accent.withValues(alpha: .045)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CityJourneyStamp(
                journey: experience,
                isUnlocked: unlocked,
                size: 28,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  state.displayText(journey.chapter),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: unlocked ? Colors.black87 : Colors.black45,
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
        icon: Icon(journey.icon, color: journey.accent, size: 34),
        title: Text(state.displayText('开启${journey.chapter}？')),
        content: Text(
          state.displayText(
            '这不是预览页。开启后会进入与普通 Journey 相同的完整流程，并永久收藏。\n\n需要 ${journey.cost} 枚${journey.currency}。',
          ),
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.displayText('暂不开启')),
          ),
          FilledButton(
            key: ValueKey('confirm-special-journey-${journey.id}'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(state.displayText('确认扣币并进入')),
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
    required this.currency,
    required this.cost,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String chapter;
  final String currency;
  final int cost;
  final IconData icon;
  final Color accent;
}
