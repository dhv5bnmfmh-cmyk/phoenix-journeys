import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class SummerPalaceLoreBattle extends StatefulWidget {
  const SummerPalaceLoreBattle({
    super.key,
    required this.onCompleted,
    this.completed = false,
  });

  final VoidCallback onCompleted;
  final bool completed;

  @override
  State<SummerPalaceLoreBattle> createState() =>
      _SummerPalaceLoreBattleState();
}

class _SummerPalaceLoreBattleState extends State<SummerPalaceLoreBattle> {
  int _phase = 0;
  int? _selectedWeapon;
  int? _selectedReply;
  final Set<int> _selectedEvidence = <int>{};
  String? _feedback;
  bool _completedNotified = false;

  static const _weapons = <_BattleChoice>[
    _BattleChoice(
      title: '借景之镜',
      subtitle: '让远处的山水成为眼前构图的一部分',
      icon: Icons.filter_hdr_rounded,
    ),
    _BattleChoice(
      title: '华丽之刃',
      subtitle: '只看装饰是否漂亮',
      icon: Icons.auto_awesome_rounded,
    ),
    _BattleChoice(
      title: '年代之锤',
      subtitle: '用年代数字直接解决所有问题',
      icon: Icons.history_edu_rounded,
    ),
  ];

  static const _replies = <_BattleChoice>[
    _BattleChoice(
      title: '直接否定',
      subtitle: '“你说错了。”',
      icon: Icons.close_rounded,
    ),
    _BattleChoice(
      title: '用文化证据破盾',
      subtitle: '山、水、长廊通过层次与借景形成整体设计',
      icon: Icons.shield_outlined,
    ),
    _BattleChoice(
      title: '换一个话题',
      subtitle: '只介绍颐和园很大、游客很多',
      icon: Icons.alt_route_rounded,
    ),
  ];

  static const _evidence = <String>[
    '廊窗把远山框入视线',
    '装饰颜色非常丰富',
    '湖面连接近景与远景',
    '建筑数量很多',
  ];

  bool get _isComplete => widget.completed || _phase >= 4;

  @override
  void didUpdateWidget(covariant SummerPalaceLoreBattle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.completed && !oldWidget.completed) {
      setState(() => _phase = 4);
    }
  }

  void _start() {
    setState(() {
      _phase = 1;
      _feedback = null;
    });
  }

  void _chooseWeapon(int index) {
    setState(() {
      _selectedWeapon = index;
      if (index == 0) {
        _feedback = '命中弱点：借景不是装饰，而是一种组织视线的方法。';
      } else {
        _feedback = '护甲没有破。提示：这只怪物把“空间关系”说成了“随意堆放”。';
      }
    });
  }

  void _advanceFromWeapon() {
    if (_selectedWeapon != 0) return;
    setState(() {
      _phase = 2;
      _feedback = null;
    });
  }

  void _chooseReply(int index) {
    setState(() {
      _selectedReply = index;
      if (index == 1) {
        _feedback = '护盾裂开了：你不仅判断了真假，还说明了为什么。';
      } else {
        _feedback = '攻击被挡住。真正有效的文化武器需要“结论 + 证据”。';
      }
    });
  }

  void _advanceFromReply() {
    if (_selectedReply != 1) return;
    setState(() {
      _phase = 3;
      _feedback = null;
    });
  }

  void _toggleEvidence(int index) {
    setState(() {
      if (_selectedEvidence.contains(index)) {
        _selectedEvidence.remove(index);
      } else if (_selectedEvidence.length < 2) {
        _selectedEvidence.add(index);
      } else {
        _feedback = '一次连招只能装入两块证据。先移除一块再选择。';
      }
    });
  }

  void _forge() {
    final correct = _selectedEvidence.length == 2 &&
        _selectedEvidence.contains(0) &&
        _selectedEvidence.contains(2);
    if (!correct) {
      setState(() {
        _feedback = '连招还不完整。寻找一条“视线”证据和一条“远近层次”证据。';
      });
      return;
    }

    setState(() {
      _phase = 4;
      _feedback = null;
    });
    if (!_completedNotified) {
      _completedNotified = true;
      widget.onCompleted();
    }
  }

  void _restart() {
    setState(() {
      _phase = 0;
      _selectedWeapon = null;
      _selectedReply = null;
      _selectedEvidence.clear();
      _feedback = null;
      _completedNotified = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    return Container(
      decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          _BossHeader(phase: _isComplete ? 4 : _phase),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Padding(
                key: ValueKey<int>(_isComplete ? 4 : _phase),
                padding: EdgeInsets.fromLTRB(
                  compact ? 10 : 14,
                  compact ? 8 : 12,
                  compact ? 10 : 14,
                  compact ? 8 : 12,
                ),
                child: _buildPhase(compact),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase(bool compact) {
    if (_isComplete) return _victory(compact);
    return switch (_phase) {
      0 => _intro(compact),
      1 => _weaponRound(compact),
      2 => _rumorRound(compact),
      3 => _forgeRound(compact),
      _ => _intro(compact),
    };
  }

  Widget _intro(bool compact) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: compact ? 66 : 82,
          height: compact ? 66 : 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF6D2633), Color(0xFF21141A)],
            ),
            boxShadow: [
              BoxShadow(
                color: PhoenixTheme.red.withValues(alpha: .35),
                blurRadius: 26,
              ),
            ],
          ),
          child: Icon(
            Icons.blur_on_rounded,
            size: compact ? 38 : 48,
            color: PhoenixTheme.gold,
          ),
        ),
        SizedBox(height: compact ? 10 : 16),
        const Text(
          '失序巨兽出现了',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '它把颐和园说成“漂亮景物的随意堆放”。\n用故事、生词和文化发现击破三层误解。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .86),
            fontSize: compact ? 11 : 13,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: compact ? 12 : 20),
        FilledButton.icon(
          key: const ValueKey('lore-battle-start'),
          onPressed: _start,
          style: FilledButton.styleFrom(
            backgroundColor: PhoenixTheme.red,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
          icon: const Icon(Icons.local_fire_department_rounded),
          label: const Text(
            '进入文化战场',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _weaponRound(bool compact) {
    return _roundLayout(
      eyebrow: '第一层 · 选择武器',
      prompt: '怪物扭曲了园林的空间关系。哪件文化武器能看穿它？',
      compact: compact,
      body: Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: _weapons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) => _ChoiceTile(
            key: ValueKey('lore-weapon-$index'),
            choice: _weapons[index],
            selected: _selectedWeapon == index,
            correct: _selectedWeapon == index && index == 0,
            onTap: () => _chooseWeapon(index),
          ),
        ),
      ),
      action: FilledButton.icon(
        onPressed: _selectedWeapon == 0 ? _advanceFromWeapon : null,
        icon: const Icon(Icons.flash_on_rounded, size: 18),
        label: const Text('释放借景之镜'),
      ),
    );
  }

  Widget _rumorRound(bool compact) {
    return _roundLayout(
      eyebrow: '第二层 · 谣言护盾',
      prompt: '怪物说：“山、水和长廊只是把漂亮东西放在一起。”你怎样反击？',
      compact: compact,
      body: Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: _replies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) => _ChoiceTile(
            key: ValueKey('lore-rumor-$index'),
            choice: _replies[index],
            selected: _selectedReply == index,
            correct: _selectedReply == index && index == 1,
            onTap: () => _chooseReply(index),
          ),
        ),
      ),
      action: FilledButton.icon(
        onPressed: _selectedReply == 1 ? _advanceFromReply : null,
        icon: const Icon(Icons.gpp_good_rounded, size: 18),
        label: const Text('击破谣言护盾'),
      ),
    );
  }

  Widget _forgeRound(bool compact) {
    return _roundLayout(
      eyebrow: '第三层 · 锻造连招',
      prompt: '选择两块能够共同证明“园林有意组织视线与层次”的证据。',
      compact: compact,
      body: Expanded(
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: _evidence.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, index) {
            final selected = _selectedEvidence.contains(index);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                key: ValueKey('lore-evidence-$index'),
                onTap: () => _toggleEvidence(index),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selected
                        ? PhoenixTheme.gold.withValues(alpha: .2)
                        : Colors.black.withValues(alpha: .24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? PhoenixTheme.gold
                          : Colors.white.withValues(alpha: .16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.hexagon_outlined,
                        color: selected
                            ? PhoenixTheme.gold
                            : Colors.white70,
                        size: 21,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _evidence[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      action: FilledButton.icon(
        key: const ValueKey('lore-forge-submit'),
        onPressed: _selectedEvidence.length == 2 ? _forge : null,
        icon: const Icon(Icons.whatshot_rounded, size: 18),
        label: const Text('发动文化连招'),
      ),
    );
  }

  Widget _roundLayout({
    required String eyebrow,
    required String prompt,
    required bool compact,
    required Widget body,
    required Widget action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: PhoenixTheme.gold,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          prompt,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 13 : 15,
            height: 1.35,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: compact ? 7 : 10),
        body,
        if (_feedback != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .28),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
            ),
            child: Text(
              _feedback!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        const SizedBox(height: 7),
        SizedBox(height: 38, child: action),
      ],
    );
  }

  Widget _victory(bool compact) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: compact ? 62 : 78,
          color: PhoenixTheme.gold,
        ),
        const SizedBox(height: 8),
        const Text(
          '失序巨兽已被净化',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '你用“借景 + 层次 + 证据”完成了第一套文化连招。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .86),
            fontSize: compact ? 11 : 13,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: PhoenixTheme.gold.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .7)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_hdr_rounded, color: PhoenixTheme.gold),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '获得文化武器',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '借景之镜',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.replay_rounded, size: 17),
          label: const Text('重新挑战'),
          style: TextButton.styleFrom(foregroundColor: Colors.white70),
        ),
      ],
    );
  }
}

class _BossHeader extends StatelessWidget {
  const _BossHeader({required this.phase});

  final int phase;

  @override
  Widget build(BuildContext context) {
    final remaining = (4 - phase).clamp(0, 3);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF190F14).withValues(alpha: .86),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .12)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PhoenixTheme.red.withValues(alpha: .2),
              border: Border.all(color: PhoenixTheme.red.withValues(alpha: .8)),
            ),
            child: const Icon(
              Icons.blur_on_rounded,
              size: 20,
              color: PhoenixTheme.gold,
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BOSS · 失序巨兽',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '弱点：空间、证据、表达',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List<Widget>.generate(3, (index) {
              final alive = index < remaining;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 22,
                height: 7,
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  color: alive
                      ? PhoenixTheme.red
                      : PhoenixTheme.gold.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    super.key,
    required this.choice,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  final _BattleChoice choice;
  final bool selected;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = correct
        ? PhoenixTheme.gold
        : selected
            ? Colors.white
            : Colors.white54;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: .14)
                : Colors.black.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accent : Colors.white.withValues(alpha: .13),
            ),
          ),
          child: Row(
            children: [
              Icon(choice.icon, color: accent, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      choice.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      choice.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .7),
                        fontSize: 9.5,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.help_rounded,
                  color: accent,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BattleChoice {
  const _BattleChoice({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
