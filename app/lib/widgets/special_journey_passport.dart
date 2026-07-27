import 'dart:async';

import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../screens/journey_screen.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'journey_symbol_badge.dart';

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
      accent: Color(0xFF28769A),
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      chapter: '月宫遗简',
      currency: '金币',
      cost: 3,
      accent: Color(0xFF9A6A13),
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      chapter: '无影客栈',
      currency: '银币',
      cost: 3,
      accent: Color(0xFFA33E2D),
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      chapter: '逆流河灯',
      currency: '铜币',
      cost: 4,
      accent: Color(0xFF9A5319),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const ValueKey('passport-special-journeys'),
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('open-special-journey-menu'),
        onTap: () => unawaited(_showSpecialJourneys(context)),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7E171D), Color(0xFFB83A32), Color(0xFF6C1118)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFD879), width: 1.2),
            boxShadow: const [
              BoxShadow(color: Color(0x3D5A1015), blurRadius: 12, offset: Offset(0, 5)),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD879), size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.displayText('特别旅程'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              _walletBadge('金', state.goldCoins, const Color(0xFFFFD879)),
              const SizedBox(width: 4),
              _walletBadge('银', state.silverCoins, const Color(0xFFE3E8EE)),
              const SizedBox(width: 4),
              _walletBadge('铜', state.bronzeCoins, const Color(0xFFD98A54)),
              const SizedBox(width: 7),
              const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletBadge(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '$label$value',
        style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.w900),
      ),
    );
  }

  Future<void> _showSpecialJourneys(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF3),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('万象奇旅 · 特别旅程'),
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                  color: PhoenixTheme.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.displayText('使用旅程钱币开启，解锁后即可进入完整故事。'),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 12),
              for (final journey in _journeys)
                _journeyTile(sheetContext, journey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _journeyTile(BuildContext context, _SpecialJourneyGate journey) {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);

    return Material(
      key: ValueKey('special-journey-${journey.id}'),
      color: const Color(0x0FFFFFFF),
      child: InkWell(
        onTap: () => unawaited(_handleJourneyTap(context, journey)),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              JourneySymbolBadge(
                journeyId: journey.id,
                size: 42,
                isUnlocked: unlocked,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText(journey.chapter),
                      style: const TextStyle(
                        color: Color(0xFF2B211C),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      unlocked
                          ? state.displayText('已开启 · 点击进入')
                          : state.displayText(
                              '${journey.cost} 枚${journey.currency} · 当前 ${state.walletBalance(journey.currency)} 枚',
                            ),
                      style: TextStyle(
                        color: unlocked ? PhoenixTheme.red : Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked ? Icons.play_circle_fill_rounded : Icons.lock_open_rounded,
                color: journey.accent,
                size: 22,
              ),
              const SizedBox(width: 4),
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
    required this.currency,
    required this.cost,
    required this.accent,
  });

  final String id;
  final String chapter;
  final String currency;
  final int cost;
  final Color accent;
}
