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
      realm: '文学幻境',
      chapter: '庄周梦蝶',
      stamp: '蝶',
      currency: '金币',
      cost: 2,
      accent: Color(0xFF28769A),
      icon: Icons.air_rounded,
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      realm: '神话遗踪',
      chapter: '月宫遗简',
      stamp: '月',
      currency: '金币',
      cost: 3,
      accent: Color(0xFF9A6A13),
      icon: Icons.nightlight_round,
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      realm: '志怪夜谈',
      chapter: '无影客栈',
      stamp: '客',
      currency: '银币',
      cost: 3,
      accent: Color(0xFFA33E2D),
      icon: Icons.cottage_rounded,
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      realm: '民间秘境',
      chapter: '逆流河灯',
      stamp: '灯',
      currency: '铜币',
      cost: 4,
      accent: Color(0xFF9A5319),
      icon: Icons.local_fire_department_rounded,
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
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF691017),
                Color(0xFFB83A32),
                Color(0xFF76141C),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD879), width: 1.25),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D5A1015),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
              BoxShadow(color: Color(0x36FFE8A8), blurRadius: 8),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 42,
                top: -35,
                child: IgnorePointer(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0x55FFE5A0), Color(0x00FFE5A0)],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  const _RealmSeal(),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.displayText('万象奇旅'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            height: 1,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.displayText('文学 · 神话 · 志怪 · 民间'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFFFE7B0),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _walletBadge('金', state.goldCoins, const Color(0xFFFFD879)),
                  const SizedBox(width: 4),
                  _walletBadge('银', state.silverCoins, const Color(0xFFE3E8EE)),
                  const SizedBox(width: 4),
                  _walletBadge('铜', state.bronzeCoins, const Color(0xFFD98A54)),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletBadge(String label, int value, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 27),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .38), width: .7),
      ),
      child: Text(
        '$label$value',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 8.2,
          height: 1,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Future<void> _showSpecialJourneys(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xAA1A0D0C),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Container(
          key: const ValueKey('special-journey-unlock-sheet'),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .82,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFAEE), Color(0xFFF1DCBC)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 28,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x55815E3D),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RealmSeal(size: 46),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.displayText('万象奇旅 · 特别旅程'),
                            style: Theme.of(sheetContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: PhoenixTheme.red,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            state.displayText('以旅程钱币开启一卷只在夜色与传说中出现的故事。'),
                            style: const TextStyle(
                              color: Color(0xFF6F5A49),
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _walletLedger(),
                const SizedBox(height: 12),
                for (final journey in _journeys)
                  _journeyTile(sheetContext, journey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _walletLedger() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xA6FFFDF7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0x55A87938)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: PhoenixTheme.red,
            size: 17,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              state.displayText('旅程钱袋'),
              style: const TextStyle(
                color: Color(0xFF3B2C22),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _ledgerValue('金', state.goldCoins, const Color(0xFF9A6A13)),
          const SizedBox(width: 8),
          _ledgerValue('银', state.silverCoins, const Color(0xFF667482)),
          const SizedBox(width: 8),
          _ledgerValue('铜', state.bronzeCoins, const Color(0xFF9A5319)),
        ],
      ),
    );
  }

  Widget _ledgerValue(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: .16),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 7,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '$value',
          style: const TextStyle(
            color: Color(0xFF46362B),
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _journeyTile(BuildContext context, _SpecialJourneyGate journey) {
    final unlocked =
        _specialJourneyAllAccessPreview ||
        state.isSpecialJourneyUnlocked(journey.id);
    final balance = state.walletBalance(journey.currency);
    final affordable = balance >= journey.cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .90),
            journey.accent.withValues(alpha: unlocked ? .15 : .07),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: journey.accent.withValues(alpha: unlocked ? .64 : .32),
          width: unlocked ? 1.2 : .9,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F3A2418),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        key: ValueKey('special-journey-${journey.id}'),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => unawaited(_handleJourneyTap(context, journey)),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 9, 9),
            child: Row(
              children: [
                _JourneySeal(journey: journey, unlocked: unlocked),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.displayText(journey.chapter),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2B211C),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            state.displayText(journey.realm),
                            style: TextStyle(
                              color: journey.accent,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        unlocked
                            ? state.displayText('封印已开 · 进入完整旅程')
                            : affordable
                                ? state.displayText(
                                    '${journey.cost} 枚${journey.currency}即可开启 · 当前 $balance 枚',
                                  )
                                : state.displayText(
                                    '还差 ${journey.cost - balance} 枚${journey.currency} · 当前 $balance 枚',
                                  ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: unlocked
                              ? PhoenixTheme.red
                              : affordable
                                  ? const Color(0xFF6B543F)
                                  : const Color(0xFF9B3E31),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: journey.accent.withValues(alpha: unlocked ? .16 : .09),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: journey.accent.withValues(alpha: .38),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        unlocked
                            ? Icons.play_arrow_rounded
                            : affordable
                                ? Icons.lock_open_rounded
                                : Icons.lock_outline_rounded,
                        color: journey.accent,
                        size: 18,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        state.displayText(unlocked ? '进入' : '${journey.cost}'),
                        style: TextStyle(
                          color: journey.accent,
                          fontSize: 8,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

    final balance = state.walletBalance(journey.currency);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xA8120808),
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: journey.accent.withValues(alpha: .52),
            width: 1.2,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        actionsPadding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        title: Column(
          children: [
            _JourneySeal(journey: journey, unlocked: false, size: 60),
            const SizedBox(height: 11),
            Text(
              state.displayText('开启《${journey.chapter}》？'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2F2119),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.displayText('开启后会扣除钱币，此后可从护照反复进入完整故事。'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF745E4C),
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x44A9783E)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.displayText('需要 ${journey.cost} 枚${journey.currency}'),
                    style: TextStyle(
                      color: _currencyColor(journey.currency),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 1,
                    height: 15,
                    color: const Color(0x33906F4A),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    state.displayText('当前 $balance 枚'),
                    style: const TextStyle(
                      color: Color(0xFF4F3B2E),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (balance < journey.cost) ...[
              const SizedBox(height: 8),
              Text(
                state.displayText(
                  '钱币不足，还差 ${journey.cost - balance} 枚${journey.currency}。',
                ),
                style: const TextStyle(
                  color: Color(0xFFA13C32),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.displayText('暂不开启')),
          ),
          FilledButton.icon(
            key: ValueKey('confirm-special-journey-${journey.id}'),
            onPressed: balance >= journey.cost
                ? () => Navigator.of(dialogContext).pop(true)
                : null,
            icon: const Icon(Icons.lock_open_rounded, size: 17),
            label: Text(
              state.displayText(
                balance >= journey.cost ? '确认开启' : '钱币不足',
              ),
            ),
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

class _RealmSeal extends StatelessWidget {
  const _RealmSeal({this.size = 38});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-.25, -.30),
          colors: [Color(0xFFFFF0B8), Color(0xFFD49B35), Color(0xFF8E4A18)],
        ),
        border: Border.all(color: const Color(0xFFFFE8A5), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: const Color(0xFF74151A),
        size: size * .48,
      ),
    );
  }
}

class _JourneySeal extends StatelessWidget {
  const _JourneySeal({
    required this.journey,
    required this.unlocked,
    this.size = 48,
  });

  final _SpecialJourneyGate journey;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-.25, -.35),
          colors: [
            Colors.white.withValues(alpha: unlocked ? .98 : .82),
            journey.accent.withValues(alpha: unlocked ? .24 : .10),
          ],
        ),
        border: Border.all(
          color: journey.accent.withValues(alpha: unlocked ? .90 : .52),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: journey.accent.withValues(alpha: unlocked ? .22 : .10),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            journey.icon,
            color: journey.accent.withValues(alpha: .17),
            size: size * .66,
          ),
          Text(
            journey.stamp,
            style: TextStyle(
              color: journey.accent,
              fontSize: size * .30,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

Color _currencyColor(String currency) => switch (currency) {
  '金币' => const Color(0xFF9A6A13),
  '银币' => const Color(0xFF667482),
  '铜币' => const Color(0xFF9A5319),
  _ => PhoenixTheme.red,
};

class _SpecialJourneyGate {
  const _SpecialJourneyGate({
    required this.id,
    required this.realm,
    required this.chapter,
    required this.stamp,
    required this.currency,
    required this.cost,
    required this.accent,
    required this.icon,
  });

  final String id;
  final String realm;
  final String chapter;
  final String stamp;
  final String currency;
  final int cost;
  final Color accent;
  final IconData icon;
}
