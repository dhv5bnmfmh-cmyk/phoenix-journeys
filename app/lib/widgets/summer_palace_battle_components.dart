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
            ? const Color(0xFF8E2F2A).withValues(alpha: .34)
            : Colors.black.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: const Color(0xFFC79B57).withValues(alpha: active ? .5 : .18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: active ? const Color(0xFFE7C07B) : Colors.white70,
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

class _SealLabel extends StatelessWidget {
  const _SealLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF8F3029).withValues(alpha: .78),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFD9B16E).withValues(alpha: .5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFE6B0),
          fontSize: 8,
          letterSpacing: .7,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EquipmentOriginCard extends StatelessWidget {
  const _EquipmentOriginCard({required this.item});

  final _LoreEquipment item;

  @override
  Widget build(BuildContext context) {
    final fromPast = item.knowledgeWord != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: fromPast
            ? const Color(0xFF17332D).withValues(alpha: .72)
            : const Color(0xFF211C17).withValues(alpha: .78),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (fromPast ? const Color(0xFF78A990) : const Color(0xFFC79B57))
              .withValues(alpha: .42),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFC79B57).withValues(alpha: .13),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: const Color(0xFFC79B57).withValues(alpha: .3),
              ),
            ),
            child: Icon(item.icon, color: const Color(0xFFE9C47E), size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SealLabel(text: item.source),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFFE7B7),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .72),
                    fontSize: 8.6,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            fromPast ? Icons.history_edu_rounded : Icons.check_circle_rounded,
            color: fromPast ? const Color(0xFF8FC4A7) : const Color(0xFFE7C07B),
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
        color: const Color(0xFF8E2F2A).withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFC79B57).withValues(alpha: .45),
        ),
      ),
      child: Row(
        children: [
          Icon(rule.icon, color: const Color(0xFFE7C07B), size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '今日江湖规矩 · ${rule.title}\n',
                    style: const TextStyle(
                      color: Color(0xFFE7C07B),
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

class _BossIntentPanel extends StatelessWidget {
  const _BossIntentPanel({required this.round});

  final _DistortionRound round;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B2522).withValues(alpha: .48),
            const Color(0xFF1A1714).withValues(alpha: .86),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC79B57).withValues(alpha: .42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF8F3029).withValues(alpha: .55),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE7C07B).withValues(alpha: .55)),
            ),
            child: const Icon(
              Icons.visibility_rounded,
              color: Color(0xFFFFDFA1),
              size: 17,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '妖物招式预告',
                      style: TextStyle(
                        color: Color(0xFFE7C07B),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _SealLabel(text: round.form),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  round.intent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.4,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
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

class _ComboSlots extends StatelessWidget {
  const _ComboSlots({
    required this.comboIds,
    required this.equipment,
    required this.onRemove,
  });

  final List<String> comboIds;
  final List<_LoreEquipment> equipment;
  final ValueChanged<String> onRemove;

  _LoreEquipment? _find(String id) {
    for (final item in equipment) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ComboSlot(
            key: const ValueKey('lore-combo-slot-0'),
            label: '起手式',
            item: comboIds.isNotEmpty ? _find(comboIds[0]) : null,
            onRemove: comboIds.isNotEmpty ? () => onRemove(comboIds[0]) : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFE7C07B),
                size: 17,
              ),
              Text(
                '运气',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .5),
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _ComboSlot(
            key: const ValueKey('lore-combo-slot-1'),
            label: '收势式',
            item: comboIds.length > 1 ? _find(comboIds[1]) : null,
            onRemove: comboIds.length > 1 ? () => onRemove(comboIds[1]) : null,
          ),
        ),
      ],
    );
  }
}

class _ComboSlot extends StatelessWidget {
  const _ComboSlot({
    super.key,
    required this.label,
    required this.item,
    required this.onRemove,
  });

  final String label;
  final _LoreEquipment? item;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final active = item != null;
    return InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFC79B57).withValues(alpha: .16)
              : Colors.black.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? const Color(0xFFE7C07B)
                : Colors.white.withValues(alpha: .16),
          ),
        ),
        child: Row(
          children: [
            Icon(
              item?.icon ?? Icons.add_rounded,
              color: active ? const Color(0xFFE7C07B) : Colors.white38,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFE7C07B),
                      fontSize: 7.8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    item?.title ?? '点选下方武学',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white38,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentBattleCard extends StatelessWidget {
  const _EquipmentBattleCard({
    super.key,
    required this.item,
    required this.slotIndex,
    required this.disabled,
    required this.onTap,
  });

  final _LoreEquipment item;
  final int? slotIndex;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = slotIndex != null;
    final fromPast = item.knowledgeWord != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 88,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFC79B57).withValues(alpha: .2)
                : (fromPast
                    ? const Color(0xFF17332D).withValues(alpha: .68)
                    : Colors.black.withValues(alpha: .24)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFFE7C07B)
                  : (fromPast
                          ? const Color(0xFF78A990)
                          : Colors.white)
                      .withValues(alpha: .18),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xFFE7C07B).withValues(alpha: .2),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: selected
                          ? const Color(0xFFE7C07B)
                          : Colors.white70,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.8,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFFE7C07B)
                            : Colors.white.withValues(alpha: .52),
                        fontSize: 7.3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 19,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9A322C),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${slotIndex! + 1}',
                      style: const TextStyle(
                        color: Color(0xFFFFE5A8),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
            color: Color(0xFFFFE7B7),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          caption,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .55),
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
        Expanded(child: _SummaryCell(label: '护体罡气', value: '$armor')),
        const SizedBox(width: 6),
        Expanded(child: _SummaryCell(label: '魔障', value: '$distortion/3')),
        const SizedBox(width: 6),
        Expanded(child: _SummaryCell(label: '出招次数', value: '$attempts')),
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
        color: Colors.black.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC79B57).withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE7C07B),
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
