part of 'summer_palace_journey_arsenal.dart';

extension _SummerPalaceBattleViews on _SummerPalaceLoreBattleState {
  Widget _statusHeader(bool compact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 12,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .12)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 18,
            color: PhoenixTheme.gold,
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              '旅程武装 · 失序之战',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _MiniMeter(
            icon: Icons.visibility_off_rounded,
            label: '失真 $_distortion/3',
            active: _distortion > 0,
          ),
          const SizedBox(width: 5),
          _MiniMeter(
            icon: Icons.psychology_rounded,
            label: '专注 $_focus',
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
            '这段旅程已经把知识变成装备',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '故事、生词和发现不是三张练习页。它们会一起进入后面的战斗。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .76),
              fontSize: 10.5,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: compact ? 7 : 10),
          ..._SummerPalaceLoreBattleState._equipment.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _EquipmentOriginCard(item: item),
            ),
          ),
          const SizedBox(height: 2),
          _RulePanel(rule: _dailyRule),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const ValueKey('lore-battle-start'),
            onPressed: _start,
            style: FilledButton.styleFrom(
              backgroundColor: PhoenixTheme.red,
              padding: const EdgeInsets.symmetric(vertical: 11),
            ),
            icon: const Icon(Icons.sports_martial_arts_rounded, size: 19),
            label: const Text(
              '带上装备进入战场',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introCharacters(bool compact) {
    return SizedBox(
      height: compact ? 95 : 116,
      child: AnimatedBuilder(
        animation: _idleController,
        builder: (context, _) {
          final progress = _idleController.value;
          return Row(
            children: [
              Expanded(
                child: _CharacterStage(
                  name: '小凰',
                  caption: '旅程守护者',
                  child: Transform.translate(
                    offset: Offset(0, math.sin(progress * math.pi * 2) * 3),
                    child: _PhoenixCharacter(
                      progress: progress,
                      size: compact ? 62 : 76,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: PhoenixTheme.gold.withValues(alpha: .8),
                size: compact ? 26 : 32,
              ),
              Expanded(
                child: _CharacterStage(
                  name: '失序巨兽',
                  caption: '扭曲文化关系',
                  child: Transform.rotate(
                    angle: math.sin(progress * math.pi * 2) * .025,
                    child: _BeastCharacter(
                      progress: progress,
                      armor: 2,
                      size: compact ? 62 : 76,
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
                        '第 ${_round + 1} 回合 · ${_currentRound.title}',
                        style: const TextStyle(
                          color: PhoenixTheme.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      '护甲 $_bossArmor / 2',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _currentRound.claim,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 12 : 13.5,
                    height: 1.3,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                _visibleRules(),
                const SizedBox(height: 7),
                Row(
                  children: [
                    for (
                      var index = 0;
                      index < _SummerPalaceLoreBattleState._equipment.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(width: 6),
                      Expanded(
                        child: _EquipmentBattleCard(
                          key: ValueKey<String>(
                            'lore-equipment-${_SummerPalaceLoreBattleState._equipment[index].id}',
                          ),
                          item: _SummerPalaceLoreBattleState._equipment[index],
                          selected: _selectedEquipment.contains(
                            _SummerPalaceLoreBattleState._equipment[index].id,
                          ),
                          disabled: _resolving,
                          onTap: () => _toggleEquipment(
                            _SummerPalaceLoreBattleState._equipment[index].id,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _effect == _BattleEffect.bossCounter ||
                            _effect == _BattleEffect.playerRecoil
                        ? PhoenixTheme.red.withValues(alpha: .2)
                        : Colors.black.withValues(alpha: .23),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _effect == _BattleEffect.bossCounter ||
                                _effect == _BattleEffect.playerRecoil
                            ? Icons.warning_amber_rounded
                            : Icons.chat_bubble_outline_rounded,
                        size: 16,
                        color: PhoenixTheme.gold,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.8,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                FilledButton.icon(
                  key: const ValueKey('lore-cast-combo'),
                  onPressed: _selectedEquipment.isNotEmpty && !_resolving
                      ? _castCombo
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: PhoenixTheme.red,
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
                        ? '文化连招发动中…'
                        : '发动组合 · 消耗 ${math.max(1, _selectedEquipment.length)} 专注',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
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
        color: PhoenixTheme.gold.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .35)),
      ),
      child: const Text(
        '规则：选 1–2 件装备。命中弱点破 1 层护甲；错配失真 +1。破 2 层获胜，失真达到 3 则失败。',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          height: 1.25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
