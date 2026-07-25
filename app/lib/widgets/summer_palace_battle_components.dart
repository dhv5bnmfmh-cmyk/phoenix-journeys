part of 'summer_palace_journey_arsenal.dart';

class _MiniMeter extends StatelessWidget {
  const _MiniMeter({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: active
            ? PhoenixTheme.red.withValues(alpha: .24)
            : Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: active ? PhoenixTheme.gold : Colors.white70,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentOriginCard extends StatelessWidget {
  const _EquipmentOriginCard({required this.item});

  final _LoreEquipment item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white.withValues(alpha: .13)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: PhoenixTheme.gold.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(item.icon, color: PhoenixTheme.gold, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: PhoenixTheme.red.withValues(alpha: .23),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '来自${item.source}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    fontSize: 8.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: PhoenixTheme.gold,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class _RulePanel extends StatelessWidget {
  const _RulePanel({required this.rule});

  final _DailyBattleRule rule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: PhoenixTheme.red.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .45)),
      ),
      child: Row(
        children: [
          Icon(rule.icon, color: PhoenixTheme.gold, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '今日规则 · ${rule.title}\n',
                    style: const TextStyle(
                      color: PhoenixTheme.gold,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: rule.description),
                ],
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9.2,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentBattleCard extends StatelessWidget {
  const _EquipmentBattleCard({
    super.key,
    required this.item,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final _LoreEquipment item;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 90,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: selected
                ? PhoenixTheme.gold.withValues(alpha: .2)
                : Colors.black.withValues(alpha: .23),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected
                  ? PhoenixTheme.gold
                  : Colors.white.withValues(alpha: .15),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: PhoenixTheme.gold.withValues(alpha: .22),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 23,
                color: selected ? PhoenixTheme.gold : Colors.white70,
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.4,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.source,
                style: TextStyle(
                  color: selected
                      ? PhoenixTheme.gold
                      : Colors.white.withValues(alpha: .58),
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CharacterStage extends StatelessWidget {
  const _CharacterStage({
    required this.name,
    required this.caption,
    required this.child,
  });

  final String name;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: child)),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          caption,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .58),
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BattleSummary extends StatelessWidget {
  const _BattleSummary({
    required this.armor,
    required this.distortion,
    required this.attempts,
  });

  final int armor;
  final int distortion;
  final int attempts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SummaryCell(label: '剩余护甲', value: '$armor')),
        const SizedBox(width: 6),
        Expanded(child: _SummaryCell(label: '失真值', value: '$distortion/3')),
        const SizedBox(width: 6),
        Expanded(child: _SummaryCell(label: '尝试次数', value: '$attempts')),
      ],
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: PhoenixTheme.gold,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
