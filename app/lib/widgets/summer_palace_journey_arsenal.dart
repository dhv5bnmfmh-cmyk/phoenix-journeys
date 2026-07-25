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
    this.learnedWords = const <String>{},
  });

  final VoidCallback onCompleted;
  final bool completed;
  final int? scenarioSeed;
  final int? ruleSeed;
  final Set<String> learnedWords;

  @override
  State<SummerPalaceLoreBattle> createState() =>
      _SummerPalaceLoreBattleState();
}

class _SummerPalaceLoreBattleState extends State<SummerPalaceLoreBattle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleController;
  late final List<_LoreEquipment> _equipment;
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
  bool _insightUsed = false;

  int _round = 0;
  int _bossArmor = 2;
  int _distortion = 0;
  int _focus = 5;
  int _attempts = 0;
  final List<String> _comboSlots = <String>[];
  String _message = '先温习旅途中获得的武学，再观察妖物如何出招。';
  _BattleEffect _effect = _BattleEffect.idle;

  static const List<_LoreEquipment> _baseEquipment = [
    _LoreEquipment(
      id: 'story-scroll',
      source: '故事心法',
      title: '长廊回声卷',
      description: '恢复人物行动与前后因果，适合破除断章幻术',
      icon: Icons.menu_book_rounded,
    ),
    _LoreEquipment(
      id: 'word-rune',
      source: '生词字诀',
      title: '借景字诀',
      description: '用准确词义为招式收势，锁定文化关系',
      icon: Icons.auto_awesome_rounded,
    ),
    _LoreEquipment(
      id: 'discovery-compass',
      source: '发现奇器',
      title: '昆明湖山水盘',
      description: '重排山、水、桥与建筑，寻找幻阵阵眼',
      icon: Icons.explore_rounded,
    ),
  ];

  static const List<List<_DistortionRound>> _scenarios = [
    [
      _DistortionRound(
        title: '因果断层',
        form: '断章相',
        intent: '断章掌：先抹去故事行动，再偷换文化结论',
        claim: '“长廊只是装饰，没有改变任何人的观看方式。”',
        hint: '起手先恢复故事行动，收势再用准确字诀说明变化。',
        requiredSequence: ['story-scroll', 'word-rune'],
        success: '回声卷重现脚步与转身，借景字诀封住了妖物的断章掌。',
      ),
      _DistortionRound(
        title: '空间错位',
        form: '乱景相',
        intent: '移山换景阵：打乱远近，再让词义失去方向',
        claim: '“远山和湖面只是背景，与眼前建筑毫无关系。”',
        hint: '先找回山水位置，再用已经学过的空间词义完成收势。',
        requiredSequence: ['discovery-compass', 'word-rune'],
        success: '山水盘定住远近，字诀贯通廊窗、湖面与远山。',
      ),
    ],
    [
      _DistortionRound(
        title: '布局崩解',
        form: '乱景相',
        intent: '散景阵：拆散山水层次，让所有景物彼此无关',
        claim: '“山、水、桥和建筑只是随意堆在一起。”',
        hint: '先寻找阵眼与方向，再用空间字诀说清层次。',
        requiredSequence: ['discovery-compass', 'word-rune'],
        success: '山水盘重建方向，层次与借景重新组成完整布局。',
      ),
      _DistortionRound(
        title: '词义迷雾',
        form: '迷言相',
        intent: '偷义诀：保留熟悉的字，却换掉它在故事中的含义',
        claim: '“借景就是把漂亮景色搬到眼前。”',
        hint: '回到故事情境，再用准确字诀封住被偷换的含义。',
        requiredSequence: ['story-scroll', 'word-rune'],
        success: '故事情境照亮词义，借景恢复为组织视线的方法。',
      ),
    ],
    [
      _DistortionRound(
        title: '空间错位',
        form: '迷言相',
        intent: '遮目阵：把“框景”伪装成“挡住风景”',
        claim: '“廊窗挡住了视线，所以它破坏了风景。”',
        hint: '先用山水奇器辨认阵眼，再以空间字诀收势。',
        requiredSequence: ['discovery-compass', 'word-rune'],
        success: '廊窗不再是阻挡，远山被框成不断变化的画面。',
      ),
      _DistortionRound(
        title: '因果断层',
        form: '断章相',
        intent: '无踪步：切断人物路线与观看感受之间的联系',
        claim: '“游客在哪里停下都一样，路线不会影响感受。”',
        hint: '先恢复人物移动，再用学过的字诀解释观看变化。',
        requiredSequence: ['story-scroll', 'word-rune'],
        success: '脚步、停留与视线重新连接，妖物的无踪步失效。',
      ),
    ],
  ];

  static const List<_DailyBattleRule> _rules = [
    _DailyBattleRule(
      title: '回声运功',
      description: '第一次正确使用故事心法，返还 1 点内力。',
      icon: Icons.graphic_eq_rounded,
    ),
    _DailyBattleRule(
      title: '字诀通脉',
      description: '正确连招中含生词字诀时，少消耗 1 点内力。',
      icon: Icons.bolt_rounded,
    ),
    _DailyBattleRule(
      title: '金羽护心',
      description: '第一次错误连招不会增加魔障。',
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
    _equipment = <_LoreEquipment>[
      ..._baseEquipment,
      ..._pastKnowledgeEquipment(widget.learnedWords),
    ];
    _victory = widget.completed;
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  List<_LoreEquipment> _pastKnowledgeEquipment(Set<String> words) {
    final normalized = words.map((word) => word.trim()).toSet();
    final result = <_LoreEquipment>[];
    if (normalized.contains('层次') || normalized.contains('層次')) {
      result.add(
        const _LoreEquipment(
          id: 'legacy-layer',
          source: '旧游字诀',
          title: '层次身法',
          description: '调用过去保存的“层次”，替代借景字诀破解空间幻阵',
          icon: Icons.layers_rounded,
          knowledgeWord: '层次',
        ),
      );
    }
    if (normalized.contains('借景')) {
      result.add(
        const _LoreEquipment(
          id: 'legacy-borrowed-scene',
          source: '旧游心诀',
          title: '借景心诀',
          description: '把过去掌握的“借景”带回战场，封住词义迷雾',
          icon: Icons.landscape_rounded,
          knowledgeWord: '借景',
        ),
      );
    }
    if (normalized.contains('规划') || normalized.contains('規劃')) {
      result.add(
        const _LoreEquipment(
          id: 'legacy-plan',
          source: '旧游阵图',
          title: '规划阵图',
          description: '调用过去保存的“规划”，辅助重建混乱布局',
          icon: Icons.account_tree_rounded,
          knowledgeWord: '规划',
        ),
      );
    }
    return result.take(2).toList(growable: false);
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
      _message = '观察妖物招式，按顺序装入“起手式”和“收势式”。';
    });
  }

  _LoreEquipment? _equipmentById(String id) {
    for (final item in _equipment) {
      if (item.id == id) return item;
    }
    return null;
  }

  void _toggleEquipment(String id) {
    if (_resolving || _defeated || _isComplete) return;
    setState(() {
      if (_comboSlots.contains(id)) {
        _comboSlots.remove(id);
      } else if (_comboSlots.length < 2) {
        _comboSlots.add(id);
      } else {
        _message = '两式已满。点一下招式卸下，再重新组合。';
      }
    });
  }

  bool _sameSequence(List<String> left, List<String> right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) return false;
    }
    return true;
  }

  bool _isCorrectCombo(List<String> combo) {
    if (_sameSequence(combo, _currentRound.requiredSequence)) return true;
    final title = _currentRound.title;
    if (title == '空间错位') {
      return _sameSequence(combo, const ['discovery-compass', 'legacy-layer']) ||
          _sameSequence(
            combo,
            const ['discovery-compass', 'legacy-borrowed-scene'],
          );
    }
    if (title == '布局崩解') {
      return _sameSequence(combo, const ['legacy-plan', 'discovery-compass']) ||
          _sameSequence(combo, const ['discovery-compass', 'legacy-layer']);
    }
    if (title == '词义迷雾') {
      return _sameSequence(
        combo,
        const ['story-scroll', 'legacy-borrowed-scene'],
      );
    }
    return false;
  }

  int _focusCostFor(List<String> selected, {required bool correct}) {
    var cost = selected.length;
    if (!correct) return 1;
    if (_ruleIndex == 1 &&
        selected.any(
          (id) => id == 'word-rune' || id == 'legacy-borrowed-scene',
        )) {
      cost -= 1;
    }
    return math.max(0, cost);
  }

  void _useInsight() {
    if (_insightUsed || _resolving || _isComplete || _defeated) return;
    final opening = _currentRound.requiredSequence.first;
    final equipment = _equipmentById(opening);
    setState(() {
      _insightUsed = true;
      if (_comboSlots.isEmpty) {
        _comboSlots.add(opening);
      } else {
        _comboSlots[0] = opening;
        if (_comboSlots.length == 2 && _comboSlots[1] == opening) {
          _comboSlots.removeAt(1);
        }
      }
      _message = '小凰以金羽点亮阵眼：起手式应当是“${equipment?.title ?? '旅程心法'}”。';
      _effect = _BattleEffect.insight;
    });
  }

  Future<void> _castCombo() async {
    if (_resolving ||
        _comboSlots.length != 2 ||
        _defeated ||
        _isComplete) {
      return;
    }

    final selected = List<String>.of(_comboSlots);
    final correct = _isCorrectCombo(selected);
    final cost = _focusCostFor(selected, correct: correct);
    if (_focus < cost) {
      setState(() {
        _message = '内力不足。重新配招，或重新挑战恢复内力。';
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
          selected.contains('story-scroll')) {
        _freeStoryUseConsumed = true;
        refunded = 1;
      }

      final nextArmor = _bossArmor - 1;
      setState(() {
        _focus = math.min(5, _focus + refunded);
        _bossArmor = nextArmor;
        _comboSlots.clear();
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
        _message = '第一重护体罡气已破。妖物换相出招，重新观察阵眼。';
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
      _comboSlots.clear();
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
            ? '魔障已满。小凰护住全部武学，可以重新运功破阵。'
            : '内力暂时耗尽。武学不会丢失，重新挑战即可恢复。';
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
      _message = '故事心法、文化字诀与山水奇器贯通，失序魇兽的幻阵已经瓦解。';
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
      _insightUsed = false;
      _round = 0;
      _bossArmor = 2;
      _distortion = 0;
      _focus = 5;
      _attempts = 0;
      _comboSlots.clear();
      _message = '武学仍在。静观新的妖相，再决定起手与收势。';
      _effect = _BattleEffect.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC79B57).withValues(alpha: .55)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xF2171715), Color(0xF2291714), Color(0xF20F1715)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .32),
            blurRadius: 20,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _WuxiaPanelPainter())),
          Column(
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
        ],
      ),
    );
  }
}

enum _BattleEffect {
  idle,
  insight,
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
    this.knowledgeWord,
  });

  final String id;
  final String source;
  final String title;
  final String description;
  final IconData icon;
  final String? knowledgeWord;
}

class _DistortionRound {
  const _DistortionRound({
    required this.title,
    required this.form,
    required this.intent,
    required this.claim,
    required this.hint,
    required this.requiredSequence,
    required this.success,
  });

  final String title;
  final String form;
  final String intent;
  final String claim;
  final String hint;
  final List<String> requiredSequence;
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
