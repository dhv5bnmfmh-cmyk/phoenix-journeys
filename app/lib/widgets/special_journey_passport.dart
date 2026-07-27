import 'dart:async';
import 'dart:math' as math;

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
      currency: '金币',
      cost: 2,
      accent: Color(0xFF28769A),
      symbol: _JourneySymbol.butterfly,
    ),
    _SpecialJourneyGate(
      id: 'myth-tracing',
      realm: '神话遗踪',
      chapter: '月宫遗简',
      currency: '金币',
      cost: 3,
      accent: Color(0xFF9A6A13),
      symbol: _JourneySymbol.moonPalace,
    ),
    _SpecialJourneyGate(
      id: 'strange-night-talks',
      realm: '志怪夜谈',
      chapter: '无影客栈',
      currency: '银币',
      cost: 3,
      accent: Color(0xFFA33E2D),
      symbol: _JourneySymbol.shadowInn,
    ),
    _SpecialJourneyGate(
      id: 'folk-secret-land',
      realm: '民间秘境',
      chapter: '逆流河灯',
      currency: '铜币',
      cost: 4,
      accent: Color(0xFF9A5319),
      symbol: _JourneySymbol.riverLantern,
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
          child: Row(
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
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .72,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFAEE), Color(0xFFF1DCBC)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 28,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x55815E3D),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _RealmSeal(size: 42),
                    const SizedBox(width: 9),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            state.displayText('以旅程钱币开启夜色与传说中的故事。'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6F5A49),
                              fontSize: 10.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _walletLedger(),
                const SizedBox(height: 7),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xA6FFFDF7),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0x55A87938)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: PhoenixTheme.red,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              state.displayText('旅程钱袋'),
              style: const TextStyle(
                color: Color(0xFF3B2C22),
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _ledgerValue('金', state.goldCoins, const Color(0xFF9A6A13)),
          const SizedBox(width: 7),
          _ledgerValue('银', state.silverCoins, const Color(0xFF667482)),
          const SizedBox(width: 7),
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
      height: 58,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .92),
            journey.accent.withValues(alpha: unlocked ? .13 : .06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: journey.accent.withValues(alpha: unlocked ? .64 : .32),
          width: unlocked ? 1.15 : .85,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x183A2418),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        key: ValueKey('special-journey-${journey.id}'),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => unawaited(_handleJourneyTap(context, journey)),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 5, 6, 5),
            child: Row(
              children: [
                _JourneySymbolTile(journey: journey, unlocked: unlocked),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 13.2,
                                height: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            state.displayText(journey.realm),
                            style: TextStyle(
                              color: journey.accent,
                              fontSize: 8,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
                          fontSize: 8.8,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 42,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: journey.accent.withValues(alpha: unlocked ? .14 : .08),
                    borderRadius: BorderRadius.circular(11),
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
                        size: 16,
                      ),
                      Text(
                        state.displayText(unlocked ? '进入' : '${journey.cost}'),
                        style: TextStyle(
                          color: journey.accent,
                          fontSize: 7.5,
                          height: .9,
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
            _JourneySymbolTile(
              journey: journey,
              unlocked: false,
              size: 66,
            ),
            const SizedBox(height: 10),
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

class _JourneySymbolTile extends StatelessWidget {
  const _JourneySymbolTile({
    required this.journey,
    required this.unlocked,
    this.size = 46,
  });

  final _SpecialJourneyGate journey;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .25),
        border: Border.all(
          color: journey.accent.withValues(alpha: unlocked ? .90 : .58),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: journey.accent.withValues(alpha: unlocked ? .22 : .10),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * .22),
        child: CustomPaint(
          painter: _JourneySymbolPainter(
            symbol: journey.symbol,
            accent: journey.accent,
            unlocked: unlocked,
          ),
        ),
      ),
    );
  }
}

class _JourneySymbolPainter extends CustomPainter {
  const _JourneySymbolPainter({
    required this.symbol,
    required this.accent,
    required this.unlocked,
  });

  final _JourneySymbol symbol;
  final Color accent;
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _backgroundColors(symbol),
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final glow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-.20, -.30),
        radius: 1.05,
        colors: [
          Colors.white.withValues(alpha: unlocked ? .30 : .18),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, glow);

    switch (symbol) {
      case _JourneySymbol.butterfly:
        _paintButterfly(canvas, size);
      case _JourneySymbol.moonPalace:
        _paintMoonPalace(canvas, size);
      case _JourneySymbol.shadowInn:
        _paintShadowInn(canvas, size);
      case _JourneySymbol.riverLantern:
        _paintRiverLantern(canvas, size);
    }

    if (!unlocked) {
      canvas.drawRect(
        rect,
        Paint()..color = const Color(0x330F0A08),
      );
    }
  }

  List<Color> _backgroundColors(_JourneySymbol value) => switch (value) {
        _JourneySymbol.butterfly => const [
            Color(0xFF071B3C),
            Color(0xFF113E68),
            Color(0xFF0A203B),
          ],
        _JourneySymbol.moonPalace => const [
            Color(0xFF071326),
            Color(0xFF233553),
            Color(0xFF11172A),
          ],
        _JourneySymbol.shadowInn => const [
            Color(0xFF21100D),
            Color(0xFF5B211A),
            Color(0xFF1A0D0B),
          ],
        _JourneySymbol.riverLantern => const [
            Color(0xFF071F24),
            Color(0xFF16484B),
            Color(0xFF0A1A1D),
          ],
      };

  void _paintButterfly(Canvas canvas, Size size) {
    final cx = size.width * .50;
    final cy = size.height * .52;
    final wing = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF63E6FF), Color(0xFF3D7BFF), Color(0xFF8E6CFF)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final gold = Paint()
      ..color = const Color(0xFFFFD782)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .025;

    final left = Path()
      ..moveTo(cx - size.width * .03, cy)
      ..cubicTo(
        cx - size.width * .34,
        cy - size.height * .32,
        cx - size.width * .42,
        cy + size.height * .02,
        cx - size.width * .09,
        cy + size.height * .12,
      )
      ..cubicTo(
        cx - size.width * .30,
        cy + size.height * .16,
        cx - size.width * .22,
        cy + size.height * .34,
        cx - size.width * .02,
        cy + size.height * .08,
      )
      ..close();
    final right = Path()
      ..moveTo(cx + size.width * .03, cy)
      ..cubicTo(
        cx + size.width * .34,
        cy - size.height * .32,
        cx + size.width * .42,
        cy + size.height * .02,
        cx + size.width * .09,
        cy + size.height * .12,
      )
      ..cubicTo(
        cx + size.width * .30,
        cy + size.height * .16,
        cx + size.width * .22,
        cy + size.height * .34,
        cx + size.width * .02,
        cy + size.height * .08,
      )
      ..close();
    canvas.drawPath(left, wing);
    canvas.drawPath(right, wing);
    canvas.drawPath(left, gold);
    canvas.drawPath(right, gold);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, cy + size.height * .04),
          width: size.width * .07,
          height: size.height * .34,
        ),
        Radius.circular(size.width * .04),
      ),
      Paint()..color = const Color(0xFFFFD782),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx - size.width * .05, cy - size.height * .13),
        width: size.width * .16,
        height: size.height * .17,
      ),
      math.pi * 1.15,
      math.pi * .65,
      false,
      gold,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx + size.width * .05, cy - size.height * .13),
        width: size.width * .16,
        height: size.height * .17,
      ),
      math.pi * 1.20,
      -math.pi * .65,
      false,
      gold,
    );
    _paintStars(canvas, size, const Color(0xFFFFE5A6));
  }

  void _paintMoonPalace(Canvas canvas, Size size) {
    final moon = Paint()..color = const Color(0xFFFFEAB0);
    canvas.drawCircle(
      Offset(size.width * .34, size.height * .30),
      size.width * .22,
      moon,
    );
    canvas.drawCircle(
      Offset(size.width * .42, size.height * .24),
      size.width * .20,
      Paint()..color = const Color(0xFF16243D),
    );

    final gold = Paint()
      ..color = const Color(0xFFFFD17C)
      ..style = PaintingStyle.fill;
    final dark = Paint()..color = const Color(0xFF10131D);
    final baseY = size.height * .77;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .22,
        baseY - size.height * .23,
        size.width * .56,
        size.height * .23,
      ),
      dark,
    );
    for (var level = 0; level < 3; level += 1) {
      final y = baseY - size.height * (.15 + level * .12);
      final halfWidth = size.width * (.31 - level * .055);
      final roof = Path()
        ..moveTo(size.width * .50 - halfWidth, y)
        ..lineTo(size.width * .50, y - size.height * .10)
        ..lineTo(size.width * .50 + halfWidth, y)
        ..lineTo(size.width * .50 + halfWidth * .82, y + size.height * .03)
        ..lineTo(size.width * .50 - halfWidth * .82, y + size.height * .03)
        ..close();
      canvas.drawPath(roof, gold);
    }
    canvas.drawLine(
      Offset(size.width * .50, size.height * .32),
      Offset(size.width * .50, baseY),
      Paint()
        ..color = const Color(0xFFFFD17C)
        ..strokeWidth = size.width * .025,
    );
    _paintStars(canvas, size, const Color(0xFFFFE8AF));
  }

  void _paintShadowInn(Canvas canvas, Size size) {
    final gold = Paint()..color = const Color(0xFFFFB45F);
    final dark = Paint()..color = const Color(0xFF190B09);
    final red = Paint()..color = const Color(0xFF8B251C);

    final roof = Path()
      ..moveTo(size.width * .09, size.height * .35)
      ..lineTo(size.width * .50, size.height * .15)
      ..lineTo(size.width * .91, size.height * .35)
      ..lineTo(size.width * .79, size.height * .40)
      ..lineTo(size.width * .50, size.height * .28)
      ..lineTo(size.width * .21, size.height * .40)
      ..close();
    canvas.drawPath(roof, dark);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .15, size.height * .38)
        ..lineTo(size.width * .85, size.height * .38)
        ..lineTo(size.width * .78, size.height * .48)
        ..lineTo(size.width * .22, size.height * .48)
        ..close(),
      red,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .22,
        size.height * .47,
        size.width * .56,
        size.height * .37,
      ),
      dark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .38,
          size.height * .53,
          size.width * .24,
          size.height * .31,
        ),
        Radius.circular(size.width * .03),
      ),
      Paint()..color = const Color(0xFF5A211A),
    );
    for (final x in <double>[.25, .75]) {
      canvas.drawCircle(
        Offset(size.width * x, size.height * .57),
        size.width * .07,
        Paint()..color = const Color(0xFFFF6D35),
      );
      canvas.drawCircle(
        Offset(size.width * x, size.height * .57),
        size.width * .035,
        Paint()..color = const Color(0xFFFFE39A),
      );
      canvas.drawLine(
        Offset(size.width * x, size.height * .42),
        Offset(size.width * x, size.height * .50),
        gold..strokeWidth = size.width * .015,
      );
    }
    canvas.drawLine(
      Offset(size.width * .18, size.height * .84),
      Offset(size.width * .82, size.height * .84),
      Paint()
        ..color = const Color(0xFFFFB45F)
        ..strokeWidth = size.width * .025,
    );
  }

  void _paintRiverLantern(Canvas canvas, Size size) {
    final water = Paint()
      ..color = const Color(0xFF75D1D6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .018;
    for (var index = 0; index < 4; index += 1) {
      final y = size.height * (.67 + index * .07);
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * .50, y),
          width: size.width * (.58 - index * .08),
          height: size.height * .10,
        ),
        0,
        math.pi,
        false,
        water..color = const Color(0xFF75D1D6).withValues(alpha: .8 - index * .14),
      );
    }

    final lantern = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF0A8), Color(0xFFFF9D3B), Color(0xFFC84A22)],
      ).createShader(Offset.zero & size);
    final lanternRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .31,
        size.height * .24,
        size.width * .38,
        size.height * .39,
      ),
      Radius.circular(size.width * .08),
    );
    canvas.drawRRect(lanternRect, lantern);
    final frame = Paint()
      ..color = const Color(0xFFFFE0A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .025;
    canvas.drawRRect(lanternRect, frame);
    canvas.drawLine(
      Offset(size.width * .38, size.height * .24),
      Offset(size.width * .38, size.height * .63),
      frame,
    );
    canvas.drawLine(
      Offset(size.width * .62, size.height * .24),
      Offset(size.width * .62, size.height * .63),
      frame,
    );
    canvas.drawLine(
      Offset(size.width * .50, size.height * .12),
      Offset(size.width * .50, size.height * .24),
      frame,
    );
    canvas.drawLine(
      Offset(size.width * .43, size.height * .13),
      Offset(size.width * .57, size.height * .13),
      frame,
    );
    canvas.drawCircle(
      Offset(size.width * .50, size.height * .45),
      size.width * .09,
      Paint()..color = const Color(0xFFFFF4B8).withValues(alpha: .72),
    );
  }

  void _paintStars(Canvas canvas, Size size, Color color) {
    final paint = Paint()..color = color;
    const points = <Offset>[
      Offset(.16, .18),
      Offset(.78, .18),
      Offset(.82, .48),
      Offset(.17, .74),
    ];
    for (final point in points) {
      final center = Offset(size.width * point.dx, size.height * point.dy);
      canvas.drawCircle(center, size.width * .018, paint);
      canvas.drawLine(
        center - Offset(size.width * .035, 0),
        center + Offset(size.width * .035, 0),
        Paint()
          ..color = color.withValues(alpha: .65)
          ..strokeWidth = size.width * .008,
      );
      canvas.drawLine(
        center - Offset(0, size.height * .035),
        center + Offset(0, size.height * .035),
        Paint()
          ..color = color.withValues(alpha: .65)
          ..strokeWidth = size.width * .008,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JourneySymbolPainter oldDelegate) {
    return oldDelegate.symbol != symbol ||
        oldDelegate.accent != accent ||
        oldDelegate.unlocked != unlocked;
  }
}

Color _currencyColor(String currency) => switch (currency) {
      '金币' => const Color(0xFF9A6A13),
      '银币' => const Color(0xFF667482),
      '铜币' => const Color(0xFF9A5319),
      _ => PhoenixTheme.red,
    };

enum _JourneySymbol { butterfly, moonPalace, shadowInn, riverLantern }

class _SpecialJourneyGate {
  const _SpecialJourneyGate({
    required this.id,
    required this.realm,
    required this.chapter,
    required this.currency,
    required this.cost,
    required this.accent,
    required this.symbol,
  });

  final String id;
  final String realm;
  final String chapter;
  final String currency;
  final int cost;
  final Color accent;
  final _JourneySymbol symbol;
}
