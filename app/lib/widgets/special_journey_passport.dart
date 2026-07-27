import 'dart:async';

import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../screens/journey_screen.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

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
      subtitle: '梦与醒之间的竹林',
      currency: '金币',
      cost: 2,
      icon: Icons.auto_stories_rounded,
      accent: Color(0xFF7FC6E8),
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      title: '神话寻踪',
      chapter: '月宫遗简',
      subtitle: '沿桂香寻找月中旧信',
      currency: '金币',
      cost: 3,
      icon: Icons.brightness_7_rounded,
      accent: Color(0xFFFFD46B),
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      title: '志怪夜话',
      chapter: '无影客栈',
      subtitle: '鸡鸣以前不要开门',
      currency: '银币',
      cost: 3,
      icon: Icons.nights_stay_rounded,
      accent: Color(0xFFFF7654),
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      title: '民俗秘境',
      chapter: '逆流河灯',
      subtitle: '接住未来留下的灯火',
      currency: '铜币',
      cost: 4,
      icon: Icons.temple_buddhist_rounded,
      accent: Color(0xFFFFA654),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('passport-special-journeys'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
      decoration: BoxDecoration(
        color: const Color(0xFF171122).withValues(alpha: .56),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PhoenixTheme.gold.withValues(alpha: .30),
          width: .8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: PhoenixTheme.gold.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: PhoenixTheme.gold,
                  size: 14,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText('护照 · 特别旅程'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      state.displayText('四个异境，完整旅程，限定收藏章'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              if (_specialJourneyAllAccessPreview)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: PhoenixTheme.gold.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    state.displayText('全开'),
                    style: const TextStyle(
                      color: PhoenixTheme.gold,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _journeys.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) =>
                  _journeyCard(context, _journeys[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _journeyCard(BuildContext context, _SpecialJourneyGate journey) {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);

    return Material(
      key: ValueKey('special-journey-${journey.id}'),
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => unawaited(_handleJourneyTap(context, journey)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 126,
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                journey.accent.withValues(alpha: unlocked ? .20 : .09),
                Colors.black.withValues(alpha: .15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: journey.accent.withValues(alpha: unlocked ? .50 : .22),
              width: .8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      color: journey.accent.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(journey.icon, color: journey.accent, size: 14),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      state.displayText(journey.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    unlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                    color: unlocked ? journey.accent : Colors.white30,
                    size: 12,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                state.displayText(journey.chapter),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                state.displayText(journey.subtitle),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 7.5,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      state.displayText(
                        unlocked
                            ? '进入旅程'
                            : '${journey.cost} ${journey.currency}开启',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: unlocked ? journey.accent : Colors.white46,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: unlocked ? journey.accent : Colors.white30,
                    size: 9,
                  ),
                ],
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
            '开启后会进入与普通旅程相同的完整流程，并永久收藏限定印章。\n\n需要 ${journey.cost} 枚${journey.currency}。',
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
    required this.title,
    required this.chapter,
    required this.subtitle,
    required this.currency,
    required this.cost,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String title;
  final String chapter;
  final String subtitle;
  final String currency;
  final int cost;
  final IconData icon;
  final Color accent;
}
