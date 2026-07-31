import 'package:flutter/material.dart';

@immutable
class SpecialJourneyWallet {
  const SpecialJourneyWallet({
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.shards,
  });

  final int gold;
  final int silver;
  final int bronze;
  final int shards;
}

class SpecialJourneyCurrencyLegend extends StatelessWidget {
  const SpecialJourneyCurrencyLegend({
    required this.wallet,
    required this.displayText,
    super.key,
  });

  final SpecialJourneyWallet wallet;
  final String Function(String) displayText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: displayText(
        '特别旅程共 9 个。向上滑动查看全部。金币 ${wallet.gold}，银币 ${wallet.silver}，铜币 ${wallet.bronze}，碎银 ${wallet.shards}',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            key: const ValueKey('special-journey-currency-legend'),
            spacing: 6,
            runSpacing: 6,
            children: [
              _CurrencyChip(
                key: const ValueKey('special-currency-gold'),
                label: displayText('金币'),
                value: wallet.gold,
                icon: Icons.workspace_premium_rounded,
                tint: const Color(0xFFD89B17),
              ),
              _CurrencyChip(
                key: const ValueKey('special-currency-silver'),
                label: displayText('银币'),
                value: wallet.silver,
                icon: Icons.brightness_5_rounded,
                tint: const Color(0xFF8997A5),
              ),
              _CurrencyChip(
                key: const ValueKey('special-currency-bronze'),
                label: displayText('铜币'),
                value: wallet.bronze,
                icon: Icons.shield_rounded,
                tint: const Color(0xFFB76D3C),
              ),
              _CurrencyChip(
                key: const ValueKey('special-currency-shards'),
                label: displayText('碎银'),
                value: wallet.shards,
                icon: Icons.auto_awesome_rounded,
                tint: const Color(0xFF6F7E95),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            key: const ValueKey('special-journey-count-hint'),
            children: [
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 17,
                color: Color(0xFF9A3B2E),
              ),
              const SizedBox(width: 3),
              Text(
                displayText('共 9 个特别旅程 · 向上滑动查看全部'),
                style: const TextStyle(
                  color: Color(0xFF9A3B2E),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    super.key,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withValues(alpha: .35)),
        boxShadow: const [
          BoxShadow(color: Color(0x16000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: tint),
            const SizedBox(width: 4),
            Text(
              '$label $value',
              style: const TextStyle(
                color: Color(0xFF2E211A),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
