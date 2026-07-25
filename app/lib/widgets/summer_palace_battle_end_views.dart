part of 'summer_palace_journey_arsenal.dart';

extension _SummerPalaceBattleEndViews on _SummerPalaceLoreBattleState {
  Widget _arena(bool compact) {
    final height = compact ? 122.0 : 145.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -.1),
          radius: 1.25,
          colors: [
            PhoenixTheme.red.withValues(alpha: .19),
            Colors.black.withValues(alpha: .08),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .1)),
        ),
      ),
      child: AnimatedBuilder(
        animation: _idleController,
        builder: (context, _) {
          final p = _idleController.value;
          final attacking = _effect == _BattleEffect.playerAttack;
          final recoil = _effect == _BattleEffect.playerRecoil;
          final bossHit = _effect == _BattleEffect.bossHit;
          final counter = _effect == _BattleEffect.bossCounter;
          final bossShake = bossHit ? math.sin(p * math.pi * 10) * 7 : 0.0;
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArenaLinesPainter(progress: p),
                ),
              ),
              Positioned(
                left: compact ? 18 : 28,
                top: compact ? 20 : 25,
                child: Transform.translate(
                  offset: Offset(
                    attacking
                        ? 24
                        : recoil
                            ? -10
                            : 0,
                    math.sin(p * math.pi * 2) * 3,
                  ),
                  child: AnimatedScale(
                    scale: recoil ? .86 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: _PhoenixCharacter(
                      progress: p,
                      size: compact ? 70 : 86,
                      charged: attacking,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: compact ? 16 : 25,
                top: compact ? 14 : 19,
                child: Transform.translate(
                  offset: Offset(
                    bossShake + (counter ? -8 : 0),
                    math.cos(p * math.pi * 2) * 2,
                  ),
                  child: AnimatedOpacity(
                    opacity: _bossArmor <= 0 ? .25 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedScale(
                      scale: bossHit ? .88 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: _BeastCharacter(
                        progress: p,
                        armor: _bossArmor,
                        size: compact ? 82 : 100,
                        hit: bossHit,
                        countering: counter,
                      ),
                    ),
                  ),
                ),
              ),
              if (attacking)
                Positioned(
                  left: compact ? 92 : 118,
                  right: compact ? 92 : 118,
                  top: height / 2 - 8,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 540),
                    builder: (_, value, __) => Transform.scale(
                      scaleX: value,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          gradient: const LinearGradient(
                            colors: [
                              PhoenixTheme.gold,
                              Colors.white,
                              PhoenixTheme.red,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: PhoenixTheme.gold.withValues(alpha: .65),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 5,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '小凰 · 旅程守护者',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _currentRound.title,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: PhoenixTheme.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _defeatView(bool compact) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? 12 : 18),
      child: Column(
        children: [
          SizedBox(height: compact ? 8 : 16),
          AnimatedBuilder(
            animation: _idleController,
            builder: (_, __) => Transform.translate(
              offset: Offset(
                math.sin(_idleController.value * math.pi * 2) * 3,
                0,
              ),
              child: _BeastCharacter(
                progress: _idleController.value,
                armor: _bossArmor,
                size: compact ? 100 : 124,
                countering: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '这次失真占了上风',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .8),
              fontSize: 11,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _BattleSummary(
            armor: _bossArmor,
            distortion: _distortion,
            attempts: _attempts,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const ValueKey('lore-battle-retry'),
            onPressed: () => _restart(rotateScenario: false),
            style: FilledButton.styleFrom(backgroundColor: PhoenixTheme.red),
            icon: const Icon(Icons.replay_rounded),
            label: const Text(
              '保留装备 · 重新配装',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _victoryView(bool compact) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? 11 : 17),
      child: Column(
        children: [
          SizedBox(height: compact ? 2 : 8),
          AnimatedBuilder(
            animation: _idleController,
            builder: (_, __) {
              final p = _idleController.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: compact ? 120 : 148,
                    height: compact ? 120 : 148,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          PhoenixTheme.gold.withValues(alpha: .28),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, math.sin(p * math.pi * 2) * 4 - 4),
                    child: _PhoenixCharacter(
                      progress: p,
                      size: compact ? 92 : 116,
                      charged: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const Text(
            '失序巨兽已被净化',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '你没有用战力压过它，而是用故事、词义与文化关系让世界恢复秩序。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PhoenixTheme.gold.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: PhoenixTheme.gold.withValues(alpha: .45),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: PhoenixTheme.gold,
                  size: 25,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '装备共鸣解锁',
                        style: TextStyle(
                          color: PhoenixTheme.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '长廊回声卷 × 借景符文 × 昆明湖罗盘',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          OutlinedButton.icon(
            key: const ValueKey('lore-battle-restart'),
            onPressed: _restart,
            icon: const Icon(Icons.shuffle_rounded),
            label: const Text('更换失真顺序再战'),
          ),
        ],
      ),
    );
  }
}
