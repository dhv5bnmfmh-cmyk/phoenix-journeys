import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

enum _ArsenalScene { intro, loadout, battle, victory, defeat }

enum _DistortionType { cause, space, layout }

class SummerPalaceJourneyArsenal extends StatefulWidget {
  const SummerPalaceJourneyArsenal({
    super.key,
    required this.onCompleted,
    this.completed = false,
    this.encounterSeed,
  });

  final VoidCallback onCompleted;
  final bool completed;
  final int? encounterSeed;

  @override
  State<SummerPalaceJourneyArsenal> createState() =>
      _SummerPalaceJourneyArsenalState();
}

class _SummerPalaceJourneyArsenalState
    extends State<SummerPalaceJourneyArsenal> {
  _ArsenalScene _scene = _ArsenalScene.intro;
  int _runeTarget = 0;
  int _round = 0;
  int _focus = 3;
  int _distortion = 0;
  int _armor = 2;
  final Set<int> _spentGear = <int>{};
  bool _busy = false;
  bool _heroLunging = false;
  bool _heroHit = false;
  bool _bossHit = false;
  bool _projectileVisible = false;
  bool _completedNotified = false;
  bool _replaying = false;
  String _feedback = '先看清今日的两种失真，再决定把「借景」符文镶在哪里。';

  static const _gear = <_JourneyGear>[
    _JourneyGear(
      title: '长廊回声卷',
      source: '故事获得',
      description: '恢复人物行动与故事因果',
      baseCounter: _DistortionType.cause,
      icon: Icons.menu_book_rounded,
    ),
    _JourneyGear(
      title: '昆明湖罗盘',
      source: '发现获得',
      description: '重排山、水、桥与建筑关系',
      baseCounter: _DistortionType.layout,
      icon: Icons.explore_rounded,
    ),
  ];

  int get _seed => widget.encounterSeed ?? DateTime.now().day;

  List<_DistortionType> get _encounter => switch (_seed % 3) {
        0 => const [_DistortionType.cause, _DistortionType.space],
        1 => const [_DistortionType.space, _DistortionType.layout],
        _ => const [_DistortionType.cause, _DistortionType.layout],
      };

  bool get _isComplete =>
      !_replaying && (widget.completed || _scene == _ArsenalScene.victory);

  _DistortionType get _currentDistortion => _encounter[_round];

  @override
  void initState() {
    super.initState();
    if (widget.completed) {
      _scene = _ArsenalScene.victory;
      _armor = 0;
    }
  }

  @override
  void didUpdateWidget(covariant SummerPalaceJourneyArsenal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.completed && !oldWidget.completed && !_replaying) {
      setState(() {
        _scene = _ArsenalScene.victory;
        _armor = 0;
      });
    }
  }

  _DistortionData _dataFor(_DistortionType type) => switch (type) {
        _DistortionType.cause => const _DistortionData(
            title: '因果断层',
            claim: '「长廊只是装饰，人物不会因为空间而改变行动。」',
            hint: '恢复故事中的行动和前后关系。',
            icon: Icons.link_off_rounded,
          ),
        _DistortionType.space => const _DistortionData(
            title: '空间失真',
            claim: '「远山和湖面只是背景，与眼前建筑没有关系。」',
            hint: '用“借景”理解远近如何进入同一画面。',
            icon: Icons.blur_on_rounded,
          ),
        _DistortionType.layout => const _DistortionData(
            title: '布局混乱',
            claim: '「山、水、桥和建筑只是随意放在一起。」',
            hint: '重新辨认整体布局与层次。',
            icon: Icons.grid_view_rounded,
          ),
      };

  Set<_DistortionType> _countersFor(int gearIndex) => <_DistortionType>{
        _gear[gearIndex].baseCounter,
        if (_runeTarget == gearIndex) _DistortionType.space,
      };

  void _openLoadout() {
    setState(() {
      _scene = _ArsenalScene.loadout;
      _replaying = false;
      _feedback = '每件装备只能成功发动一次。符文放错位置，第二层可能无装备可用。';
    });
  }

  void _selectRuneTarget(int index) {
    if (_busy) return;
    setState(() {
      _runeTarget = index;
      _feedback = '「借景」符文已镶入 ${_gear[index].title}，它现在也能破解空间失真。';
    });
  }

  void _beginBattle() {
    setState(() {
      _scene = _ArsenalScene.battle;
      _round = 0;
      _focus = 3;
      _distortion = 0;
      _armor = 2;
      _spentGear.clear();
      _busy = false;
      _heroLunging = false;
      _heroHit = false;
      _bossHit = false;
      _projectileVisible = false;
      _feedback = '小凰进入战场。先看怪物扭曲了什么，再发动对应装备。';
    });
  }

  Future<void> _useGear(int index) async {
    if (_busy ||
        _scene != _ArsenalScene.battle ||
        _spentGear.contains(index)) {
      return;
    }

    final target = _currentDistortion;
    final correct = _countersFor(index).contains(target);
    setState(() {
      _busy = true;
      _heroLunging = true;
      _projectileVisible = true;
      _feedback = '小凰正在发动「${_gear[index].title}」…';
    });

    await Future<void>.delayed(const Duration(milliseconds: 230));
    if (!mounted) return;

    if (correct) {
      setState(() {
        _bossHit = true;
        _armor -= 1;
        _spentGear.add(index);
        _feedback = switch (target) {
          _DistortionType.cause =>
            '回声卷恢复了被切断的行动：空间会影响人物如何观看与行走。',
          _DistortionType.space =>
            '借景符文点亮远山与湖面，它们进入了眼前的构图。',
          _DistortionType.layout =>
            '罗盘重新排列山、水、桥与建筑，混乱恢复成整体层次。',
        };
      });
    } else {
      setState(() {
        _heroHit = true;
        _focus -= 1;
        _distortion += 1;
        _feedback = '属性不对应。巨兽反击，专注 -1、失真 +1；装备未消耗，可以重新判断。';
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 430));
    if (!mounted) return;

    if (correct && _armor <= 0) {
      setState(() {
        _scene = _ArsenalScene.victory;
        _replaying = false;
        _busy = false;
        _heroLunging = false;
        _bossHit = false;
        _projectileVisible = false;
      });
      if (!_completedNotified) {
        _completedNotified = true;
        widget.onCompleted();
      }
      return;
    }

    if (!correct && (_distortion >= 3 || _focus <= 0)) {
      setState(() {
        _scene = _ArsenalScene.defeat;
        _busy = false;
        _heroLunging = false;
        _heroHit = false;
        _projectileVisible = false;
      });
      return;
    }

    setState(() {
      if (correct) _round += 1;
      _busy = false;
      _heroLunging = false;
      _heroHit = false;
      _bossHit = false;
      _projectileVisible = false;
    });
  }

  void _returnToLoadout() {
    setState(() {
      _scene = _ArsenalScene.loadout;
      _feedback = '战斗记录已清空。重新观察两层失真，再调整符文位置。';
      _busy = false;
      _heroLunging = false;
      _heroHit = false;
      _bossHit = false;
      _projectileVisible = false;
    });
  }

  void _restart() {
    setState(() {
      _scene = _ArsenalScene.intro;
      _replaying = true;
      _runeTarget = 0;
      _round = 0;
      _focus = 3;
      _distortion = 0;
      _armor = 2;
      _spentGear.clear();
      _feedback = '先看清今日的两种失真，再决定把「借景」符文镶在哪里。';
      _completedNotified = false;
      _busy = false;
      _heroLunging = false;
      _heroHit = false;
      _bossHit = false;
      _projectileVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    final scene = _isComplete ? _ArsenalScene.victory : _scene;
    return Container(
      decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .18)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _StatusHeader(
            scene: scene,
            armor: _armor,
            focus: _focus,
            distortion: _distortion,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              child: Padding(
                key: ValueKey<_ArsenalScene>(scene),
                padding: EdgeInsets.all(compact ? 8 : 12),
                child: switch (scene) {
                  _ArsenalScene.intro => _intro(compact),
                  _ArsenalScene.loadout => _loadout(compact),
                  _ArsenalScene.battle => _battle(compact),
                  _ArsenalScene.victory => _victory(compact),
                  _ArsenalScene.defeat => _defeat(compact),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _intro(bool compact) {
    return Column(
      children: [
        Expanded(
          child: _ActorStage(
            heroLunging: false,
            heroHit: false,
            bossHit: false,
            projectileVisible: false,
            bossVisible: true,
            label: '失序巨兽正在吞噬颐和园的文化关系',
          ),
        ),
        SizedBox(height: compact ? 5 : 9),
        Text(
          '旅程武装',
          style: TextStyle(
            color: PhoenixTheme.gold,
            fontSize: compact ? 16 : 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '你在故事、生词和发现中获得的装备，将在挑战里真正派上用场。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .82),
            fontSize: compact ? 10 : 12,
            height: 1.35,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        const _CollectedGearStrip(),
        SizedBox(height: compact ? 6 : 10),
        FilledButton.icon(
          key: const ValueKey('lore-battle-start'),
          onPressed: _openLoadout,
          style: FilledButton.styleFrom(backgroundColor: PhoenixTheme.red),
          icon: const Icon(Icons.inventory_2_rounded, size: 18),
          label: const Text(
            '检查装备与规则',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _loadout(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '今日 Boss 预告',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            for (var index = 0; index < _encounter.length; index++) ...[
              Expanded(
                child: _EncounterPreview(
                  data: _dataFor(_encounter[index]),
                  index: index + 1,
                ),
              ),
              if (index == 0) const SizedBox(width: 6),
            ],
          ],
        ),
        SizedBox(height: compact ? 6 : 9),
        const _RulePanel(),
        SizedBox(height: compact ? 6 : 9),
        const Text(
          '把「借景」符文镶入一件装备',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Row(
            children: [
              for (var index = 0; index < _gear.length; index++) ...[
                Expanded(
                  child: _LoadoutCard(
                    key: ValueKey('lore-rune-target-$index'),
                    gear: _gear[index],
                    selected: _runeTarget == index,
                    counters: _countersFor(index),
                    onTap: () => _selectRuneTarget(index),
                  ),
                ),
                if (index == 0) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: 5),
        _FeedbackBar(text: _feedback),
        const SizedBox(height: 6),
        FilledButton.icon(
          key: const ValueKey('lore-battle-begin'),
          onPressed: _beginBattle,
          style: FilledButton.styleFrom(backgroundColor: PhoenixTheme.red),
          icon: const Icon(Icons.sports_martial_arts_rounded, size: 18),
          label: const Text(
            '带着这套装备出战',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _battle(bool compact) {
    final target = _dataFor(_currentDistortion);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: compact ? 4 : 5,
          child: _ActorStage(
            heroLunging: _heroLunging,
            heroHit: _heroHit,
            bossHit: _bossHit,
            projectileVisible: _projectileVisible,
            bossVisible: true,
            label: '第 ${_round + 1} 层 · ${target.title}',
          ),
        ),
        SizedBox(height: compact ? 4 : 7),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .28),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(target.icon, color: PhoenixTheme.gold, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    target.title,
                    style: const TextStyle(
                      color: PhoenixTheme.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                target.claim,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 9.7 : 11,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '小凰提示：${target.hint}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .65),
                  fontSize: compact ? 8.2 : 9.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 4 : 7),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              for (var index = 0; index < _gear.length; index++) ...[
                Expanded(
                  child: _BattleGearCard(
                    key: ValueKey('lore-equipment-$index'),
                    gear: _gear[index],
                    runeAttached: _runeTarget == index,
                    spent: _spentGear.contains(index),
                    busy: _busy,
                    counters: _countersFor(index),
                    onUse: () => unawaited(_useGear(index)),
                  ),
                ),
                if (index == 0) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        _FeedbackBar(text: _feedback),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const ValueKey('lore-return-loadout'),
            onPressed: _busy ? null : _returnToLoadout,
            icon: const Icon(Icons.tune_rounded, size: 14),
            label: const Text(
              '撤退并重新配装',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _victory(bool compact) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _ActorStage(
            heroLunging: false,
            heroHit: false,
            bossHit: true,
            projectileVisible: false,
            bossVisible: false,
            label: '文化关系恢复，失序巨兽被净化',
          ),
        ),
        const Icon(
          Icons.workspace_premium_rounded,
          color: PhoenixTheme.gold,
          size: 45,
        ),
        const Text(
          '旅程武装完成觉醒',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '故事武器、借景符文与发现遗物形成了真正的战斗组合。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .76),
            fontSize: compact ? 9.8 : 11.2,
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        OutlinedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.replay_rounded, size: 16),
          label: const Text('重新挑战'),
        ),
      ],
    );
  }

  Widget _defeat(bool compact) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _ActorStage(
            heroLunging: false,
            heroHit: true,
            bossHit: false,
            projectileVisible: false,
            bossVisible: true,
            label: '失真值达到上限，小凰暂时撤退',
          ),
        ),
        const Icon(
          Icons.shield_moon_rounded,
          color: PhoenixTheme.gold,
          size: 43,
        ),
        const Text(
          '配装逻辑需要调整',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '每件装备只能成功发动一次。让借景符文补上另一件装备缺少的能力。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .74),
            fontSize: compact ? 9.5 : 10.8,
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        FilledButton.icon(
          onPressed: _returnToLoadout,
          icon: const Icon(Icons.tune_rounded, size: 16),
          label: const Text('重新配装'),
        ),
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.scene,
    required this.armor,
    required this.focus,
    required this.distortion,
  });

  final _ArsenalScene scene;
  final int armor;
  final int focus;
  final int distortion;

  @override
  Widget build(BuildContext context) {
    final inBattle = scene == _ArsenalScene.battle || scene == _ArsenalScene.defeat;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
      color: Colors.black.withValues(alpha: .28),
      child: Row(
        children: [
          const _PhoenixMiniAvatar(),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scene == _ArsenalScene.loadout
                      ? '小凰 · 配装中'
                      : scene == _ArsenalScene.victory
                          ? '小凰 · 守护完成'
                          : '小凰 · 旅程伙伴',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  inBattle ? '专注 $focus/3 · 失真 $distortion/3' : '故事 × 生词 × 发现',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .62),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (inBattle)
            for (var index = 0; index < 2; index++)
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Icon(
                  index < armor ? Icons.shield_rounded : Icons.shield_outlined,
                  color: index < armor
                      ? PhoenixTheme.gold
                      : Colors.white.withValues(alpha: .24),
                  size: 17,
                ),
              ),
        ],
      ),
    );
  }
}

class _ActorStage extends StatelessWidget {
  const _ActorStage({
    required this.heroLunging,
    required this.heroHit,
    required this.bossHit,
    required this.projectileVisible,
    required this.bossVisible,
    required this.label,
  });

  final bool heroLunging;
  final bool heroHit;
  final bool bossHit;
  final bool projectileVisible;
  final bool bossVisible;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 115),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x443A8B96), Color(0x66130D17)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _LakePainter())),
          Positioned(
            left: 8,
            top: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .34),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOutBack,
            left: heroLunging ? 94 : (heroHit ? 3 : 22),
            bottom: heroHit ? 13 : 17,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 170),
              turns: heroHit ? -.04 : 0,
              child: const _PhoenixCompanion(),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            left: projectileVisible ? 164 : 90,
            bottom: 52,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: projectileVisible ? 1 : 0,
              child: const _KnowledgeProjectile(),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 17,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: bossVisible ? 1 : 0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 160),
                scale: bossHit ? .83 : 1,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: bossHit ? .025 : 0,
                  child: const _DistortionBeast(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoenixCompanion extends StatelessWidget {
  const _PhoenixCompanion();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 21,
            child: Transform.rotate(
              angle: -.5,
              child: Icon(
                Icons.air_rounded,
                size: 38,
                color: PhoenixTheme.gold.withValues(alpha: .8),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 21,
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: -.5,
                child: Icon(
                  Icons.air_rounded,
                  size: 38,
                  color: PhoenixTheme.gold.withValues(alpha: .8),
                ),
              ),
            ),
          ),
          Container(
            width: 42,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD56A), Color(0xFFCF3E2E)],
              ),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: Colors.white.withValues(alpha: .65)),
              boxShadow: const [BoxShadow(color: Color(0x66FFD56A), blurRadius: 13)],
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const Positioned(
            bottom: 0,
            child: Text(
              '小凰',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistortionBeast extends StatelessWidget {
  const _DistortionBeast();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 89,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 1,
            left: 7,
            child: Icon(Icons.change_history_rounded, size: 34, color: Color(0xFF7E455F)),
          ),
          const Positioned(
            top: 1,
            right: 7,
            child: Icon(Icons.change_history_rounded, size: 34, color: Color(0xFF7E455F)),
          ),
          Container(
            width: 63,
            height: 68,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFF6E2843), Color(0xFF1E101B)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFB86A84)),
              boxShadow: const [BoxShadow(color: Color(0x886E2843), blurRadius: 17)],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.circle, size: 9, color: Color(0xFFFFC857)),
                Icon(Icons.circle, size: 9, color: Color(0xFFFFC857)),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            child: Text(
              '失序巨兽',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KnowledgeProjectile extends StatelessWidget {
  const _KnowledgeProjectile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 12,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x00FFD56A), Color(0xFFFFD56A)],
        ),
        borderRadius: BorderRadius.circular(99),
        boxShadow: const [BoxShadow(color: Color(0xAAFFD56A), blurRadius: 11)],
      ),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 13),
      ),
    );
  }
}

class _PhoenixMiniAvatar extends StatelessWidget {
  const _PhoenixMiniAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFFFFD56A), Color(0xFFB52831)]),
      ),
      child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 18),
    );
  }
}

class _CollectedGearStrip extends StatelessWidget {
  const _CollectedGearStrip();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('故事', '长廊回声卷', Icons.menu_book_rounded),
      ('生词', '借景符文', Icons.diamond_rounded),
      ('发现', '昆明湖罗盘', Icons.explore_rounded),
    ];
    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .24),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: index == 1
                      ? PhoenixTheme.gold.withValues(alpha: .55)
                      : Colors.white.withValues(alpha: .14),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    items[index].$3,
                    size: 18,
                    color: index == 1 ? PhoenixTheme.gold : Colors.white,
                  ),
                  Text(
                    items[index].$1,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .62),
                      fontSize: 7.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    items[index].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (index < items.length - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

class _EncounterPreview extends StatelessWidget {
  const _EncounterPreview({required this.data, required this.index});

  final _DistortionData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: .13)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: PhoenixTheme.red.withValues(alpha: .24),
            child: Icon(data.icon, color: PhoenixTheme.gold, size: 15),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '第 $index 层',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .55),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
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

class _RulePanel extends StatelessWidget {
  const _RulePanel();

  @override
  Widget build(BuildContext context) {
    const rules = [
      '两件装备各只能成功发动一次',
      '借景符文让一件装备额外克制空间失真',
      '误用会消耗专注并增加失真',
    ];
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: PhoenixTheme.gold.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .25)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rules.length; index++)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 2),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: PhoenixTheme.red.withValues(alpha: .35),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      rules[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                      ),
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

class _LoadoutCard extends StatelessWidget {
  const _LoadoutCard({
    super.key,
    required this.gear,
    required this.selected,
    required this.counters,
    required this.onTap,
  });

  final _JourneyGear gear;
  final bool selected;
  final Set<_DistortionType> counters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: selected
                ? PhoenixTheme.gold.withValues(alpha: .16)
                : Colors.black.withValues(alpha: .25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? PhoenixTheme.gold : Colors.white.withValues(alpha: .14),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(gear.icon, color: selected ? PhoenixTheme.gold : Colors.white, size: 28),
              const SizedBox(height: 4),
              Text(
                gear.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                gear.source,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .54),
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 3,
                runSpacing: 3,
                children: counters.map((type) => _CounterChip(type: type)).toList(),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.diamond_rounded, size: 12, color: PhoenixTheme.gold),
                  const SizedBox(width: 2),
                  Text(
                    selected ? '符文已镶入' : '点击镶入符文',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BattleGearCard extends StatelessWidget {
  const _BattleGearCard({
    super.key,
    required this.gear,
    required this.runeAttached,
    required this.spent,
    required this.busy,
    required this.counters,
    required this.onUse,
  });

  final _JourneyGear gear;
  final bool runeAttached;
  final bool spent;
  final bool busy;
  final Set<_DistortionType> counters;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: spent ? .42 : 1,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .27),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: runeAttached
                ? PhoenixTheme.gold.withValues(alpha: .65)
                : Colors.white.withValues(alpha: .15),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(gear.icon, size: 18, color: spent ? Colors.white38 : PhoenixTheme.gold),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    gear.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (runeAttached)
                  const Icon(Icons.diamond_rounded, color: PhoenixTheme.gold, size: 12),
              ],
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: counters.map((type) => _CounterChip(type: type)).toList(),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 27,
              child: FilledButton(
                onPressed: spent || busy ? null : onUse,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: PhoenixTheme.red,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  spent ? '本场已发动' : '发动装备',
                  style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterChip extends StatelessWidget {
  const _CounterChip({required this.type});

  final _DistortionType type;

  String get label => switch (type) {
        _DistortionType.cause => '因果断层',
        _DistortionType.space => '空间失真',
        _DistortionType.layout => '布局混乱',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FeedbackBar extends StatelessWidget {
  const _FeedbackBar({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: PhoenixTheme.red.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_rounded, color: PhoenixTheme.gold, size: 13),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.3,
                height: 1.22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()
      ..color = const Color(0x553A9AA3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (var index = 0; index < 5; index++) {
      final y = size.height * (.55 + index * .075);
      canvas.drawArc(Rect.fromLTWH(-10, y, size.width + 20, 18), 0, 3.14, false, water);
    }
    final mountain = Paint()
      ..color = const Color(0x55406A55)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .22, size.height * .26)
      ..lineTo(size.width * .42, size.height * .58)
      ..lineTo(size.width * .65, size.height * .34)
      ..lineTo(size.width, size.height * .58)
      ..close();
    canvas.drawPath(path, mountain);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _JourneyGear {
  const _JourneyGear({
    required this.title,
    required this.source,
    required this.description,
    required this.baseCounter,
    required this.icon,
  });

  final String title;
  final String source;
  final String description;
  final _DistortionType baseCounter;
  final IconData icon;
}

class _DistortionData {
  const _DistortionData({
    required this.title,
    required this.claim,
    required this.hint,
    required this.icon,
  });

  final String title;
  final String claim;
  final String hint;
  final IconData icon;
}
