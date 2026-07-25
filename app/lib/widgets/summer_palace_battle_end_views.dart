part of 'summer_palace_journey_arsenal.dart';

extension _SummerPalaceBattleEndViews on _SummerPalaceLoreBattleState {
  Widget _arena(bool compact) {
    final height = compact ? 126.0 : 150.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -.1),
          radius: 1.25,
          colors: [
            const Color(0xFF8F3029).withValues(alpha: .2),
            const Color(0xFF0E1512).withValues(alpha: .2),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFC79B57).withValues(alpha: .24),
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: _idleController,
        builder: (context, _) {
          final p = _idleController.value;
          final attacking = _effect == _BattleEffect.playerAttack;
          final insight = _effect == _BattleEffect.insight;
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
                        ? 28
                        : recoil
                            ? -10
                            : 0,
                    math.sin(p * math.pi * 2) * 3,
                  ),
                  child: AnimatedScale(
                    scale: recoil ? .86 : insight ? 1.08 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: _PhoenixCharacter(
                      progress: p,
                      size: compact ? 72 : 88,
                      charged: attacking || insight,
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
                        size: compact ? 84 : 102,
                        hit: bossHit,
                        countering: counter,
                      ),
                    ),
                  ),
                ),
              ),
              if (attacking)
                Positioned(
                  left: compact ? 90 : 115,
                  right: compact ? 88 : 112,
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
                              Color(0xFFE7C07B),
                              Color(0xFFFFF0C9),
                              Color(0xFF9A322C),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE7C07B).withValues(alpha: .65),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (insight)
                Positioned(
                  left: compact ? 78 : 100,
                  top: compact ? 15 : 18,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: .3, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (_, value, __) => Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: value,
                        child: const Icon(
                          Icons.flare_rounded,
                          color: Color(0xFFFFE7B7),
                          size: 28,
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
                        '小凰少侠 · 金羽引路',
                        style: TextStyle(
                          color: Color(0xFFFFE7B7),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${_currentRound.form} · ${_currentRound.title}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFFE7C07B),
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
                size: compact ? 104 : 128,
                countering: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '此阵暂未破',
            style: TextStyle(
              color: Color(0xFFFFE7B7),
              fontSize: 20,
              letterSpacing: 1.2,
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
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8F3029),
              foregroundColor: const Color(0xFFFFE7B7),
            ),
            icon: const Icon(Icons.replay_rounded),
            label: const Text(
              '武学不失 · 重新运功',
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
                    width: compact ? 126 : 154,
                    height: compact ? 126 : 154,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFE7C07B).withValues(alpha: .28),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, math.sin(p * math.pi * 2) * 4 - 4),
                    child: _PhoenixCharacter(
                      progress: p,
                      size: compact ? 96 : 120,
                      charged: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const Text(
            '幻阵已破',
            style: TextStyle(
              color: Color(0xFFFFE7B7),
              fontSize: 21,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '你用已经学过的故事、字诀与文化发现贯通两式，失序魇兽无法继续扭曲这段记忆。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC79B57).withValues(alpha: .11),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFC79B57).withValues(alpha: .48),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFE7C07B),
                  size: 25,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '侠游武学共鸣',
                        style: TextStyle(
                          color: Color(0xFFE7C07B),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '长廊回声卷 × 借景字诀 × 昆明湖山水盘',
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
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE7C07B),
              side: const BorderSide(color: Color(0xFFC79B57)),
            ),
            icon: const Icon(Icons.shuffle_rounded),
            label: const Text('换一座幻阵再破'),
          ),
        ],
      ),
    );
  }
}
