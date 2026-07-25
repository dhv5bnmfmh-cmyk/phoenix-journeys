part of 'summer_palace_journey_arsenal.dart';

extension _SummerPalaceBattleViews on _SummerPalaceLoreBattleState {
  Widget _statusHeader(bool compact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 12,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF12120F).withValues(alpha: .82),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFC79B57).withValues(alpha: .3),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.temple_buddhist_rounded,
            size: 18,
            color: Color(0xFFE7C07B),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              '侠游破阵 · 颐和园',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFFFFE7B7),
                fontSize: 12,
                letterSpacing: .5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _MiniMeter(
            icon: Icons.blur_on_rounded,
            label: '魔障 $_distortion/3',
            active: _distortion > 0,
          ),
          const SizedBox(width: 5),
          _MiniMeter(
            icon: Icons.local_fire_department_rounded,
            label: '内力 $_focus',
            active: _focus <= 2,
          ),
        ],
      ),
    );
  }

  Widget _loadoutView(bool compact) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        compact ? 10 : 14,
        compact ? 8 : 12,
        compact ? 10 : 14,
        compact ? 8 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _introCharacters(compact),
          SizedBox(height: compact ? 7 : 11),
          const Text(
            '所学皆可成武学',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFE7B7),
              fontSize: 16,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '故事炼成心法，生词化作字诀，发现铸成奇器。旧日保存的生词也可能在此化为新招。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .75),
              fontSize: 10.2,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: compact ? 8 : 11),
          ..._equipment.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _EquipmentOriginCard(item: item),
            ),
          ),
          const SizedBox(height: 2),
          _RulePanel(rule: _dailyRule),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFC79B57).withValues(alpha: .22),
              ),
            ),
            child: const Text(
              '破阵法则：妖物先亮招。按顺序选“起手式＋收势式”，击破两重护体罡气即可获胜；三重魔障则败。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 9,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const ValueKey('lore-battle-start'),
            onPressed: _start,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8F3029),
              foregroundColor: const Color(0xFFFFE7B7),
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(color: Color(0xFFC79B57)),
              ),
            ),
            icon: const Icon(Icons.sports_martial_arts_rounded, size: 19),
            label: const Text(
              '携武学 · 入幻阵',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: .7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introCharacters(bool compact) {
    return SizedBox(
      height: compact ? 100 : 120,
      child: AnimatedBuilder(
        animation: _idleController,
        builder: (context, _) {
          final progress = _idleController.value;
          return Row(
            children: [
              Expanded(
                child: _CharacterStage(
                  name: '小凰少侠',
                  caption: '金羽引路 · 点破阵眼',
                  child: Transform.translate(
                    offset: Offset(0, math.sin(progress * math.pi * 2) * 3),
                    child: _PhoenixCharacter(
                      progress: progress,
                      size: compact ? 66 : 80,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '破',
                    style: TextStyle(
                      color: Color(0xFFE7C07B),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Icon(
                    Icons.double_arrow_rounded,
                    color: const Color(0xFFC79B57).withValues(alpha: .8),
                    size: compact ? 22 : 28,
                  ),
                ],
              ),
              Expanded(
                child: _CharacterStage(
                  name: '失序魇兽',
                  caption: '吞食记忆 · 扭曲文化',
                  child: Transform.rotate(
                    angle: math.sin(progress * math.pi * 2) * .025,
                    child: _BeastCharacter(
                      progress: progress,
                      armor: 2,
                      size: compact ? 70 : 86,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _battleView(bool compact) {
    return Column(
      children: [
        _arena(compact),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              compact ? 9 : 12,
              compact ? 6 : 9,
              compact ? 9 : 12,
              compact ? 7 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '第 ${_round + 1} 阵 · ${_currentRound.title}',
                        style: const TextStyle(
                          color: Color(0xFFE7C07B),
                          fontSize: 11,
                          letterSpacing: .6,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      '护体罡气 $_bossArmor / 2',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _BossIntentPanel(round: _currentRound),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2DFB5).withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: const Color(0xFFC79B57).withValues(alpha: .2),
                    ),
                  ),
                  child: Text(
                    _currentRound.claim,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 11.5 : 13,
                      height: 1.3,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                _ComboSlots(
                  comboIds: _comboSlots,
                  equipment: _equipment,
                  onRemove: _toggleEquipment,
                ),
                const SizedBox(height: 7),
                _visibleRules(),
                const SizedBox(height: 7),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _equipment.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.02,
                  ),
                  itemBuilder: (context, index) {
                    final item = _equipment[index];
                    final slotIndex = _comboSlots.indexOf(item.id);
                    return _EquipmentBattleCard(
                      key: ValueKey<String>('lore-equipment-${item.id}'),
                      item: item,
                      slotIndex: slotIndex < 0 ? null : slotIndex,
                      disabled: _resolving,
                      onTap: () => _toggleEquipment(item.id),
                    );
                  },
                ),
                const SizedBox(height: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  decoration: BoxDecoration(
                    color: _effect == _BattleEffect.bossCounter ||
                            _effect == _BattleEffect.playerRecoil
                        ? const Color(0xFF8F3029).withValues(alpha: .22)
                        : _effect == _BattleEffect.insight
                            ? const Color(0xFF173D31).withValues(alpha: .45)
                            : Colors.black.withValues(alpha: .24),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFC79B57).withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _effect == _BattleEffect.insight
                            ? Icons.lightbulb_rounded
                            : _effect == _BattleEffect.bossCounter ||
                                    _effect == _BattleEffect.playerRecoil
                                ? Icons.warning_amber_rounded
                                : Icons.history_edu_rounded,
                        size: 16,
                        color: const Color(0xFFE7C07B),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const ValueKey('lore-use-insight'),
                        onPressed: !_insightUsed && !_resolving ? _useInsight : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE7C07B),
                          side: BorderSide(
                            color: const Color(0xFFC79B57).withValues(alpha: .55),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.flare_rounded, size: 17),
                        label: Text(
                          _insightUsed ? '金羽点拨已用' : '小凰点拨',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        key: const ValueKey('lore-cast-combo'),
                        onPressed: _comboSlots.length == 2 && !_resolving
                            ? _castCombo
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF8F3029),
                          foregroundColor: const Color(0xFFFFE7B7),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: _resolving
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.flash_on_rounded, size: 18),
                        label: Text(
                          _resolving
                              ? '剑气贯阵中…'
                              : '施展连招 · ${_comboSlots.length}/2',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _visibleRules() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC79B57).withValues(alpha: .09),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFC79B57).withValues(alpha: .3),
        ),
      ),
      child: const Text(
        '招式有先后：先用心法或奇器找到阵眼，再用字诀收势。正确破一重罡气，错招魔障 +1。',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.7,
          height: 1.25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
