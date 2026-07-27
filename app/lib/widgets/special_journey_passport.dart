import 'dart:async';

import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../screens/journey_screen.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'special_journey_stamp.dart';

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
      title: '文学漫游',
      chapter: '庄周梦蝶',
      currency: '金币',
      cost: 2,
      icon: Icons.auto_stories_rounded,
      accent: Color(0xFF70BFE6),
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      title: '神话寻踪',
      chapter: '月宫遗简',
      currency: '金币',
      cost: 3,
      icon: Icons.brightness_7_rounded,
      accent: Color(0xFFE4AD34),
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      title: '志怪夜话',
      chapter: '无影客栈',
      currency: '银币',
      cost: 3,
      icon: Icons.nights_stay_rounded,
      accent: Color(0xFFD85F47),
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      title: '民俗秘境',
      chapter: '逆流河灯',
      currency: '铜币',
      cost: 4,
      icon: Icons.temple_buddhist_rounded,
      accent: Color(0xFFD98532),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('passport-special-journeys'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
      decoration: BoxDecoration(
        color: const Color(0xFF24182D).withValues(alpha: .07),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: PhoenixTheme.gold.withValues(alpha: .10),
          width: .6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: PhoenixTheme.gold.withValues(alpha: .74),
                size: 11,
              ),
              const SizedBox(width: 3.5),
              Expanded(
                child: Text(
                  state.displayText('特别旅程'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_specialJourneyAllAccessPreview)
                Text(
                  state.displayText('全开'),
                  style: TextStyle(
                    color: PhoenixTheme.gold.withValues(alpha: .80),
                    fontSize: 6.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
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
                      child: _journeyTile(context, journey),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _journeyTile(BuildContext context, _SpecialJourneyGate gate) {
    final unlocked = _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(gate.id);
    final journey = requireDailyJourneyExperience(gate.id);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        key: ValueKey('special-journey-${gate.id}'),
        onTap: () => unawaited(_handleJourneyTap(context, gate)),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: gate.accent.withValues(alpha: unlocked ? .045 : .015),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: gate.accent.withValues(alpha: unlocked ? .12 : .045),
              width: .6,
            ),
          ),
          child: Row(
            children: [
              SpecialJourneyStamp(
                journey: journey,
                isUnlocked: unlocked,
                size: 30,
                transparentInk: true,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText(gate.chapter),
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
                      state.displayText(
                        unlocked ? gate.title : '${gate.cost} ${gate.currency}',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: unlocked
                            ? gate.accent.withValues(alpha: .80)
                            : Colors.black38,
                        fontSize: 6.5,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked
                    ? Icons.chevron_right_rounded
                    : Icons.lock_outline_rounded,
                color: unlocked
                    ? gate.accent.withValues(alpha: .62)
                    : Colors.black26,
                size: 12,
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
    final unlocked = _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);
    if (unlocked) {
      await _openFullJourney(context, journey.id);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(journey.icon, color: journey.accent, size: 30),
        title: Text(state.displayText('开启${journey.chapter}？')),
        content: Text(
          state.displayText(
            '开启后进入完整特别旅程，并永久收藏限定印章。\n\n需要 ${journey.cost} 枚${journey.currency}。',
          ),
          style: const TextStyle(height: 1.45),
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
    required this.title,
    required this.chapter,
    required this.currency,
    required this.cost,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String title;
  final String chapter;
  final String currency;
  final int cost;
  final IconData icon;
  final Color accent;
}
