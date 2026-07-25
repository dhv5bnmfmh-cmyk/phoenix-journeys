import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

part 'summer_palace_battle_components.dart';
part 'summer_palace_battle_characters.dart';
part 'summer_palace_battle_views.dart';
part 'summer_palace_battle_end_views.dart';

class SummerPalaceLoreBattle extends StatefulWidget {
  const SummerPalaceLoreBattle({
    super.key,
    required this.onCompleted,
    this.completed = false,
    this.scenarioSeed,
    this.ruleSeed,
  });

  final VoidCallback onCompleted;
  final bool completed;
  final int? scenarioSeed;
  final int? ruleSeed;

  @override
  State<SummerPalaceLoreBattle> createState() =>
      _SummerPalaceLoreBattleState();
}

class _SummerPalaceLoreBattleState extends State<SummerPalaceLoreBattle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleController;
  late int _scenarioIndex;
  late int _ruleIndex;

  bool _started = false;
  bool _victory = false;
  bool _defeated = false;
  bool _replaying = false;
  bool _resolving = false;
  bool _completedNotified = false;
  bool _freeStoryUseConsumed = false;
  bool _guardianUsed = false;

  int _round = 0;
  int _bossArmor = 2;
  int _distortion = 0;
  int _focus = 5;
  int _attempts = 0;
  final Set<String> _selectedEquipment = <String>{};
  String _message = '先查看旅途中获得的装备，再决定怎样出战。';
  _BattleEffect _effect = _BattleEffect.idle;

  final List<_LoreEquipment> _equipment = const [
    _LoreEquipment(
      id: 'story-scroll',
      source: '故事',
      title: '长廊回声卷',
      description: '恢复被删去的人物行动与前后因果',
      icon: Icons.menu_book_rounded,
    ),
    _LoreEquipment(
      id: 'word-rune',
      source: '生词',
      title: '借景符文',
      description: '把“借景、层次”等词义转化为战斗关系',
      icon: Icons.auto_awesome_rounded,
    ),
    _LoreEquipment(
      id: 'discovery-compass',
      source: '发现',
      title: '昆明湖罗盘',
      description: '重新排列山、水、桥与建筑的空间秩序',
      icon: Icons.explore_rounded,
    ),
  ];

  static const List<List<_DistortionRound>> _scenarios = [
    [
      _DistortionRound(
        title: '因果断层',
        claim: '“长廊只是装饰，没有改变任何人的观看方式。”',
        hint: '先恢复故事里人物走进长廊后的行动变化。',
        requiredEquipment: {'story-scroll'},
        success: '长廊中的脚步与转身重新出现，怪物失去一层因果护甲。',
      ),
      _DistortionRound(
        title: '空间错位',
        claim: '“远山和湖面只是背景，与眼前建筑毫无关系。”',
        hint: '需要一个空间工具，再用准确词义锁定关系。',
        requiredEquipment: {'discovery-compass', 'word-rune'},
        success: '罗盘重排近景与远景，借景符文将它们连接成完整构图。',
      ),
    ],
    [
      _DistortionRound(
        title: '布局崩解',
        claim: '“山、水、桥和建筑只是随意堆在一起。”',
        hint: '寻找能够重建空间秩序的旅程遗物。',
        requiredEquipment: {'discovery-compass'},
        success: '昆明湖罗盘恢复了山水与建筑的方向，失序开始崩解。',
      ),
      _DistortionRound(
        title: '词义迷雾',
        claim: '“借景就是把漂亮景色搬到眼前。”',
        hint: '用故事情境与词义符文共同证明它不是“搬运”。',
        requiredEquipment: {'story-scroll', 'word-rune'},
        success: '故事情境照亮词义，借景重新成为组织视线的方法。',
      ),
    ],
    [
      _DistortionRound(
        title: '空间错位',
        claim: '“廊窗挡住了视线，所以它破坏了风景。”',
        hint: '空间关系需要工具与词义一起解释。',
        requiredEquipment: {'discovery-compass', 'word-rune'},
        success: '廊窗不再是阻挡，它把远山框成不断变化的画面。',
      ),
      _DistortionRound(
        title: '因果断层',
        claim: '“游客在哪里停下都一样，路线不会影响感受。”',
        hint: '回到故事，恢复人物移动与观察之间的联系。',
        requiredEquipment: {'story-scroll'},
        success: '被切断的行动重新连起，路线与观看体验恢复因果。',
      ),
    ],
  ];

  static const List<_DailyBattleRule> _rules = [
    _DailyBattleRule(
      title: '回声潮',
      description: '第一次正确使用故事装备，返还 1 点专注。',
      icon: Icons.graphic_eq_rounded,
    ),
    _DailyBattleRule(
      title: '符文共鸣',
      description: '正确组合中含有生词符文时，少消耗 1 点专注。',
      icon: Icons.bolt_rounded,
    ),
    _DailyBattleRule(
      title: '小凰守护',
      description: '第一次错误组合不会增加失真值。',
      icon: Icons.shield_rounded,
    ),
  ];

  List<_DistortionRound> get _activeScenario => _scenarios[_scenarioIndex];
  _DistortionRound get _currentRound => _activeScenario[_round];
  _DailyBattleRule get _dailyRule => _rules[_ruleIndex];
  bool get _isComplete =>
      !_replaying && (widget.completed || _victory || _bossArmor <= 0);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final daySeed = now.difference(DateTime(now.year, 1, 1)).inDays + now.year;
    _scenarioIndex = (widget.scenarioSeed ?? daySeed) % _scenarios.length;
    _ruleIndex = (widget.ruleSeed ?? daySeed) % _rules.length;
    _victory = widget.completed;
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant SummerPalaceLoreBattle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.completed && !oldWidget.completed && !_replaying) {
      setState(() {
        _victory = true;
        _bossArmor = 0;
      });
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _started = true;
      _victory = false;
      _defeated = false;
      _message = '选择 1 至 2 件装备。知识来源和怪物弱点必须对应。';
    });
  }

  void _toggleEquipment(String id) {
    if (_resolving || _defeated || _isComplete) return;
    setState(() {
      if (_selectedEquipment.contains(id)) {
        _selectedEquipment.remove(id);
      } else if (_selectedEquipment.length < 2) {
        _selectedEquipment.add(id);
      } else {
        _message = '最多同时发动两件装备。先卸下一件再重新配装。';
      }
    });
  }

  int _focusCostFor(Set<String> selected, {required bool correct}) {
    var cost = selected.length;
    if (!correct) return 1;
    if (_ruleIndex == 1 &&
        selected.contains('word-rune') &&
        selected.length > 1) {
      cost -= 1;
    }
    return math.max(0, cost);
  }

  Future<void> _castCombo() async {
    if (_resolving ||
        _selectedEquipment.isEmpty ||
        _defeated ||
        _isComplete) {
      return;
    }

    final required = _currentRound.requiredEquipment;
    final correct = required.length == _selectedEquipment.length &&
        required.containsAll(_selectedEquipment);
    final cost = _focusCostFor(_selectedEquipment, correct: correct);
    if (_focus < cost) {
      setState(() {
        _message = '专注不足。减少装备数量，或重新挑战恢复专注。';
      });
      return;
    }

    setState(() {
      _resolving = true;
      _attempts += 1;
      _focus = math.max(0, _focus - cost);
      _effect =
          correct ? _BattleEffect.playerAttack : _BattleEffect.bossCounter;
      _message = correct ? _currentRound.success : _currentRound.hint;
    });

    await Future<void>.delayed(const Duration(milliseconds: 620));
    if (!mounted) return;

    if (correct) {
      var refunded = 0;
      if (_ruleIndex == 0 &&
          !_freeStoryUseConsumed &&
          _selectedEquipment.contains('story-scroll')) {
        _freeStoryUseConsumed = true;
        refunded = 1;
      }

      final nextArmor = _bossArmor - 1;
      setState(() {
        _focus = math.min(5, _focus + refunded);
        _bossArmor = nextArmor;
        _selectedEquipment.clear();
        _effect = _BattleEffect.bossHit;
      });

      await Future<void>.delayed(const Duration(milliseconds: 760));
      if (!mounted) return;

      if (nextArmor <= 0) {
        _completeBattle();
        return;
      }

      setState(() {
        _round += 1;
        _resolving = false;
        _effect = _BattleEffect.idle;
        _message = '第一层护甲已破。怪物改变了失真方式，重新配装。';
      });
      return;
    }

    var distortionGain = 1;
    if (_ruleIndex == 2 && !_guardianUsed) {
      _guardianUsed = true;
      distortionGain = 0;
    }
    final nextDistortion = _distortion + distortionGain;

    setState(() {
      _distortion = nextDistortion;
      _selectedEquipment.clear();
      _effect = _BattleEffect.playerRecoil;
    });

    await Future<void>.delayed(const Duration(milliseconds: 620));
    if (!mounted) return;

    if (nextDistortion >= 3 || _focus <= 0) {
      setState(() {
        _defeated = true;
        _resolving = false;
        _effect = _BattleEffect.bossCounter;
        _message = nextDistortion >= 3
            ? '失真值达到上限。小凰护住了你的装备，可以重新配装再战。'
            : '专注已经耗尽。装备仍会保留，重新挑战即可恢复。';
      });
    } else {
      setState(() {
        _resolving = false;
        _effect = _BattleEffect.idle;
      });
    }
  }

  void _completeBattle() {
    setState(() {
      _victory = true;
      _defeated = false;
      _replaying = false;
      _resolving = false;
      _effect = _BattleEffect.victory;
      _message = '两段文化逻辑连接完成，失序巨兽恢复为颐和园的记忆守卫。';
    });
    if (!_completedNotified) {
      _completedNotified = true;
      widget.onCompleted();
    }
  }

  void _restart({bool rotateScenario = true}) {
    setState(() {
      if (rotateScenario) {
        _scenarioIndex = (_scenarioIndex + 1) % _scenarios.length;
      }
      _started = false;
      _victory = false;
      _defeated = false;
      _replaying = true;
      _resolving = false;
      _completedNotified = false;
      _freeStoryUseConsumed = false;
      _guardianUsed = false;
      _round = 0;
      _bossArmor = 2;
      _distortion = 0;
      _focus = 5;
      _attempts = 0;
      _selectedEquipment.clear();
      _message = '装备仍在。观察新的失真顺序，再决定配装。';
      _effect = _BattleEffect.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xE61C1721), Color(0xE62C1118)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .24),
            blurRadius: 18,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          this._statusHeader(compact),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey<String>(
                  _isComplete
                      ? 'victory'
                      : _defeated
                          ? 'defeat'
                          : _started
                              ? 'battle-$_round'
                              : 'loadout',
                ),
                child: _isComplete
                    ? this._victoryView(compact)
                    : _defeated
                        ? this._defeatView(compact)
                        : _started
                            ? this._battleView(compact)
                            : this._loadoutView(compact),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _BattleEffect {
  idle,
  playerAttack,
  bossHit,
  bossCounter,
  playerRecoil,
  victory,
}

class _LoreEquipment {
  const _LoreEquipment({
    required this.id,
    required this.source,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String source;
  final String title;
  final String description;
  final IconData icon;
}

class _DistortionRound {
  const _DistortionRound({
    required this.title,
    required this.claim,
    required this.hint,
    required this.requiredEquipment,
    required this.success,
  });

  final String title;
  final String claim;
  final String hint;
  final Set<String> requiredEquipment;
  final String success;
}

class _DailyBattleRule {
  const _DailyBattleRule({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
