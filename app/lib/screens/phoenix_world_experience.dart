import 'dart:math' as math;

import 'package:flutter/material.dart';

class PhoenixWorldExperience extends StatefulWidget {
  const PhoenixWorldExperience({super.key});

  @override
  State<PhoenixWorldExperience> createState() => _PhoenixWorldExperienceState();
}

class _PhoenixWorldExperienceState extends State<PhoenixWorldExperience> {
  _Journey? active;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: active == null
          ? _WorldHall(
              key: const ValueKey('world-hall'),
              onOpen: (journey) => setState(() => active = journey),
            )
          : _JourneyPlayer(
              key: ValueKey(active!.title),
              journey: active!,
              onExit: () => setState(() => active = null),
            ),
    );
  }
}

class _WorldHall extends StatelessWidget {
  const _WorldHall({super.key, required this.onOpen});

  final ValueChanged<_Journey> onOpen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100D0B),
      body: Stack(
        children: [
          const Positioned.fill(child: _LivingBackdrop(kind: _SceneKind.dawn)),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _PhoenixMark(),
                            const Spacer(),
                            _wallet(),
                          ],
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          '世界不只被看见，\n也被你亲自走进。',
                          style: TextStyle(
                            color: Color(0xFFFFF4DA),
                            fontSize: 32,
                            height: 1.16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '从真实城市出发，赚取属于你的钱币；\n再选择一扇门，进入传说、文学与未解之境。',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _sectionHeader('今日一般旅程', '完成挑战，获得开启奇旅的钱币'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 264,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _generalJourneys.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, index) => _JourneyCard(
                              journey: _generalJourneys[index],
                              onTap: () => onOpen(_generalJourneys[index]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _sectionHeader('万象奇旅', '体验模式 · 所有旅程已为 Toni 开启'),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .76,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => _JourneyCard(
                        journey: _specialJourneys[index],
                        compact: true,
                        onTap: () => onOpen(_specialJourneys[index]),
                      ),
                      childCount: _specialJourneys.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: _FounderBanner(),
          ),
        ],
      ),
    );
  }

  Widget _wallet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0x55FFD97D)),
      ),
      child: const Row(
        children: [
          _CoinDot(color: Color(0xFFFFCF61), text: '金 4'),
          SizedBox(width: 8),
          _CoinDot(color: Color(0xFFD9E2ED), text: '银 3'),
          SizedBox(width: 8),
          _CoinDot(color: Color(0xFFC77A43), text: '铜 5'),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFE4A3),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      );
}

class _JourneyCard extends StatefulWidget {
  const _JourneyCard({
    required this.journey,
    required this.onTap,
    this.compact = false,
  });

  final _Journey journey;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<_JourneyCard> createState() => _JourneyCardState();
}

class _JourneyCardState extends State<_JourneyCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final journey = widget.journey;
    return AnimatedScale(
      scale: pressed ? .97 : 1,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapCancel: () => setState(() => pressed = false),
        onTapUp: (_) {
          setState(() => pressed = false);
          widget.onTap();
        },
        child: Container(
          width: widget.compact ? null : 212,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF251D18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: journey.accent.withValues(alpha: .35)),
            boxShadow: [
              BoxShadow(
                color: journey.accent.withValues(alpha: .12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: _LivingBackdrop(kind: journey.scene, quiet: true),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF120E0C).withValues(alpha: .35),
                        const Color(0xFF120E0C).withValues(alpha: .96),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Pill(
                          text: journey.category,
                          color: journey.accent,
                        ),
                        const Spacer(),
                        if (journey.cost != null)
                          _Pill(
                            text: journey.cost!,
                            color: const Color(0xFFFFD46D),
                            icon: Icons.lock_open_rounded,
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      journey.kicker,
                      style: TextStyle(
                        color: journey.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      journey.title,
                      style: const TextStyle(
                        color: Color(0xFFFFF2D7),
                        fontSize: 21,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      journey.summary,
                      maxLines: widget.compact ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          '进入旅程',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            size: 15, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyPlayer extends StatefulWidget {
  const _JourneyPlayer({
    super.key,
    required this.journey,
    required this.onExit,
  });

  final _Journey journey;
  final VoidCallback onExit;

  @override
  State<_JourneyPlayer> createState() => _JourneyPlayerState();
}

class _JourneyPlayerState extends State<_JourneyPlayer> {
  int step = 0;
  int attempts = 0;
  int selected = -1;
  bool resolved = false;
  final memory = TextEditingController();

  static const labels = ['故事', '生词', '发现', '挑战', '印象', '盖章'];

  @override
  void dispose() {
    memory.dispose();
    super.dispose();
  }

  void next() {
    if (step == 3 && !resolved) return;
    if (step == labels.length - 1) {
      widget.onExit();
      return;
    }
    setState(() => step += 1);
  }

  void answer(int index) {
    if (resolved) return;
    setState(() {
      selected = index;
      attempts += 1;
      if (index == widget.journey.correct || attempts >= 3) {
        resolved = true;
      }
    });
  }

  String get reward {
    if (!resolved) return '';
    if (selected != widget.journey.correct && attempts >= 3) return '碎银';
    if (attempts == 1) return '金币';
    if (attempts == 2) return '银币';
    return '铜币';
  }

  @override
  Widget build(BuildContext context) {
    final journey = widget.journey;
    return Scaffold(
      backgroundColor: const Color(0xFF100D0B),
      body: Stack(
        children: [
          Positioned.fill(child: _LivingBackdrop(kind: journey.scene)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .1),
                    const Color(0xFF100D0B).withValues(alpha: .72),
                    const Color(0xFF100D0B),
                  ],
                  stops: const [0, .56, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(journey),
                _progress(journey),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(.06, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Padding(
                      key: ValueKey(step),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: _content(),
                    ),
                  ),
                ),
                _bottomAction(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(_Journey journey) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 16, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: widget.onExit,
              icon: const Icon(Icons.close_rounded, color: Colors.white),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journey.category,
                    style: TextStyle(
                      color: journey.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    journey.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${step + 1}/6',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      );

  Widget _progress(_Journey journey) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: List.generate(
            labels.length,
            (index) => Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: index == 5 ? 0 : 4),
                decoration: BoxDecoration(
                  color: index <= step
                      ? journey.accent
                      : Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _content() {
    final journey = widget.journey;
    return switch (step) {
      0 => _StoryPage(journey: journey),
      1 => _VocabPage(journey: journey),
      2 => _DiscoveryPage(journey: journey),
      3 => _challenge(journey),
      4 => _memory(journey),
      _ => _stamp(journey),
    };
  }

  Widget _challenge(_Journey journey) {
    return ListView(
      children: [
        _eyebrow('钱币挑战 · 最多三次'),
        const SizedBox(height: 8),
        Text(
          journey.question,
          style: const TextStyle(
            color: Color(0xFFFFF2D7),
            fontSize: 23,
            height: 1.3,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...List.generate(journey.options.length, (index) {
          final isSelected = selected == index;
          final isCorrect = resolved && index == journey.correct;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              onPressed: resolved ? null : () => answer(index),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                foregroundColor: Colors.white,
                backgroundColor: isCorrect
                    ? const Color(0xFF2D6948)
                    : isSelected
                        ? const Color(0x55A33D35)
                        : Colors.black26,
                side: BorderSide(
                  color: isCorrect
                      ? const Color(0xFF6ED89D)
                      : isSelected
                          ? const Color(0xFFDF7769)
                          : Colors.white24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                journey.options[index],
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          );
        }),
        if (attempts > 0 && !resolved)
          Text(
            '这一次还没有找到线索。剩余 ${3 - attempts} 次，注意故事里的时间与因果。',
            style: const TextStyle(color: Color(0xFFFFB2A4), height: 1.5),
          ),
        if (resolved) _RewardReveal(reward: reward, journey: journey),
      ],
    );
  }

  Widget _memory(_Journey journey) => ListView(
        children: [
          _eyebrow('留下印象'),
          const SizedBox(height: 8),
          Text(
            journey.reflection,
            style: const TextStyle(
              color: Color(0xFFFFF2D7),
              fontSize: 24,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: memory,
            maxLines: 6,
            style: const TextStyle(color: Colors.white, height: 1.5),
            decoration: InputDecoration(
              hintText: '把这一刻写进你的护照……',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.black38,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: journey.accent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Phoenix 会保留你的原意。未来再回来时，你会看见自己的中文与目光怎样改变。',
            style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
          ),
        ],
      );

  Widget _stamp(_Journey journey) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.8, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (_, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Container(
                width: 172,
                height: 172,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: journey.accent.withValues(alpha: .1),
                  border: Border.all(color: journey.accent, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: journey.accent.withValues(alpha: .28),
                      blurRadius: 35,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(journey.icon, color: journey.accent, size: 42),
                      const SizedBox(height: 7),
                      Text(
                        journey.stamp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: journey.accent,
                          fontSize: 20,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '这不是完成一堂课，\n是你真正走过了一段旅程。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFF2D7),
                fontSize: 19,
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '限定纪念 · ${journey.prize}',
              style: TextStyle(
                color: journey.accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );

  Widget _bottomAction() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: step == 3 && !resolved ? null : next,
            style: FilledButton.styleFrom(
              backgroundColor: widget.journey.accent,
              foregroundColor: const Color(0xFF20140E),
              disabledBackgroundColor: Colors.white12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            child: Text(
              step == 5 ? '带着纪念返回旅程大厅' : '前往下一站 · ${labels[step + 1]}',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      );

  Widget _eyebrow(String text) => Text(
        text.toUpperCase(),
        style: TextStyle(
          color: widget.journey.accent,
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
        ),
      );
}

class _StoryPage extends StatefulWidget {
  const _StoryPage({required this.journey});
  final _Journey journey;

  @override
  State<_StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<_StoryPage> {
  int paragraph = 0;

  @override
  Widget build(BuildContext context) {
    final journey = widget.journey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '故事 · ${paragraph + 1}/${journey.story.length}',
          style: TextStyle(
            color: journey.accent,
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          child: Text(
            journey.story[paragraph],
            key: ValueKey(paragraph),
            style: const TextStyle(
              color: Color(0xFFFFF3DC),
              fontSize: 24,
              height: 1.62,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          '轻触文字，让故事继续',
          style: TextStyle(color: journey.accent.withValues(alpha: .7)),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => setState(
            () => paragraph = (paragraph + 1) % journey.story.length,
          ),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: LinearGradient(
                colors: [
                  journey.accent,
                  journey.accent.withValues(alpha: .15),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _VocabPage extends StatelessWidget {
  const _VocabPage({required this.journey});
  final _Journey journey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          '生词不是清单，\n是打开故事的钥匙。',
          style: TextStyle(
            color: journey.accent,
            fontSize: 22,
            height: 1.3,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...journey.words.map(
          (word) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Text(word.$1, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.$2,
                        style: const TextStyle(
                          color: Color(0xFFFFF2D7),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        word.$3,
                        style:
                            const TextStyle(color: Colors.white54, height: 1.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.volume_up_rounded, color: journey.accent),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscoveryPage extends StatelessWidget {
  const _DiscoveryPage({required this.journey});
  final _Journey journey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          '发现',
          style: TextStyle(
            color: Color(0xFFFFF2D7),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '事实、传说与想象，在这里各自有名字。',
          style: TextStyle(color: Colors.white54),
        ),
        const SizedBox(height: 18),
        ...journey.discoveries.asMap().entries.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      journey.accent.withValues(alpha: .15),
                      Colors.black38,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: journey.accent.withValues(alpha: .25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Pill(
                      text: entry.key == 0 ? '可验证事实' : '文化线索',
                      color: journey.accent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _RewardReveal extends StatelessWidget {
  const _RewardReveal({required this.reward, required this.journey});
  final String reward;
  final _Journey journey;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutBack,
      builder: (_, value, child) => Transform.scale(
        scale: value,
        child: Opacity(opacity: value.clamp(0, 1), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF261D15),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x66FFD46D)),
        ),
        child: Row(
          children: [
            const _SpinningCoin(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '获得 1 枚$reward',
                    style: const TextStyle(
                      color: Color(0xFFFFDD83),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward == '碎银'
                        ? '三次挑战结束，答案已展开。旅程继续，失败不会困住你。'
                        : '它会进入护照，用来开启你真正想了解的特别旅程。',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11.5,
                      height: 1.45,
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

class _SpinningCoin extends StatefulWidget {
  const _SpinningCoin();

  @override
  State<_SpinningCoin> createState() => _SpinningCoinState();
}

class _SpinningCoinState extends State<_SpinningCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(controller.value * math.pi * 2),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFF0A0), Color(0xFFD08B20)],
            ),
            border: Border.all(color: const Color(0xFFFFE89B), width: 2),
          ),
          child: const Center(
            child: Text(
              '旅',
              style: TextStyle(
                color: Color(0xFF6B3510),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LivingBackdrop extends StatefulWidget {
  const _LivingBackdrop({required this.kind, this.quiet = false});
  final _SceneKind kind;
  final bool quiet;

  @override
  State<_LivingBackdrop> createState() => _LivingBackdropState();
}

class _LivingBackdropState extends State<_LivingBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => CustomPaint(
        painter: _ScenePainter(
          kind: widget.kind,
          time: widget.quiet ? .2 : controller.value,
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter({required this.kind, required this.time});
  final _SceneKind kind;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final palette = switch (kind) {
      _SceneKind.dawn => [const Color(0xFF762E2B), const Color(0xFF151016)],
      _SceneKind.palace => [const Color(0xFF874830), const Color(0xFF171015)],
      _SceneKind.river => [const Color(0xFF1D6272), const Color(0xFF100E18)],
      _SceneKind.wall => [const Color(0xFF80613F), const Color(0xFF17110F)],
      _SceneKind.moon => [const Color(0xFF243A66), const Color(0xFF090910)],
      _SceneKind.mountain => [const Color(0xFF355A55), const Color(0xFF0C1110)],
      _SceneKind.lantern => [const Color(0xFF6D282C), const Color(0xFF130B10)],
    };
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: palette,
        ).createShader(Offset.zero & size),
    );
    final moonX = size.width * (.72 + math.sin(time * math.pi * 2) * .015);
    final moonY = size.height * .18;
    canvas.drawCircle(
      Offset(moonX, moonY),
      size.shortestSide * .095,
      Paint()
        ..color = const Color(0xFFFFE6A2).withValues(
          alpha: kind == _SceneKind.moon ? .9 : .25,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    final back = Path()
      ..moveTo(0, size.height * .58)
      ..quadraticBezierTo(
        size.width * .24,
        size.height * (.37 + math.sin(time * math.pi * 2) * .01),
        size.width * .48,
        size.height * .57,
      )
      ..quadraticBezierTo(
        size.width * .74,
        size.height * .34,
        size.width,
        size.height * .55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(back, Paint()..color = const Color(0xAA0E1111));
    final front = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .3,
        size.height * .53,
        size.width * .58,
        size.height * .75,
      )
      ..quadraticBezierTo(
        size.width * .82,
        size.height * .6,
        size.width,
        size.height * .7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(front, Paint()..color = const Color(0xE60A0B0B));
    if (kind == _SceneKind.palace ||
        kind == _SceneKind.lantern ||
        kind == _SceneKind.wall) {
      final baseY = size.height * .61;
      canvas.drawRect(
        Rect.fromLTWH(size.width * .18, baseY, size.width * .64, size.height),
        Paint()..color = const Color(0xEE0A0909),
      );
      final roof = Path()
        ..moveTo(size.width * .1, baseY)
        ..lineTo(size.width * .5, baseY - size.height * .13)
        ..lineTo(size.width * .9, baseY)
        ..close();
      canvas.drawPath(roof, Paint()..color = const Color(0xFF120C0B));
      for (var i = 0; i < 5; i++) {
        canvas.drawCircle(
          Offset(size.width * (.3 + i * .1), baseY + 18),
          3.5,
          Paint()
            ..color = const Color(0xFFFFA23E).withValues(
              alpha: .55 + math.sin(time * math.pi * 2 + i) * .2,
            ),
        );
      }
    }
    final mist = Paint()
      ..color = Colors.white.withValues(alpha: .035)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    for (var i = 0; i < 4; i++) {
      final x = ((time * size.width * .2) + i * size.width * .31) % size.width;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, size.height * (.45 + i * .06)),
          width: size.width * .45,
          height: 30,
        ),
        mist,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.kind != kind;
}

class _PhoenixMark extends StatelessWidget {
  const _PhoenixMark();
  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PHOENIX',
            style: TextStyle(
              color: Color(0xFFFFD978),
              fontSize: 17,
              letterSpacing: 3,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'JOURNEYS · 创始人体验',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 8,
              letterSpacing: 1.3,
            ),
          ),
        ],
      );
}

class _FounderBanner extends StatelessWidget {
  const _FounderBanner();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xE61D1714),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x55FFD978)),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 20),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFFFFD978), size: 18),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                '验收模式：全部旅程已开启 · 正式版仍按对应钱币消费',
                style: TextStyle(
                  color: Color(0xFFFFE6A7),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, this.icon});
  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xB3151210),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: color.withValues(alpha: .48)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 10, color: color),
              const SizedBox(width: 3),
            ],
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
}

class _CoinDot extends StatelessWidget {
  const _CoinDot({required this.color, required this.text});
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
}

enum _SceneKind { dawn, palace, river, wall, moon, mountain, lantern }

class _Journey {
  const _Journey({
    required this.title,
    required this.kicker,
    required this.category,
    required this.summary,
    required this.accent,
    required this.scene,
    required this.icon,
    required this.story,
    required this.words,
    required this.discoveries,
    required this.question,
    required this.options,
    required this.correct,
    required this.reflection,
    required this.stamp,
    required this.prize,
    this.cost,
  });

  final String title;
  final String kicker;
  final String category;
  final String summary;
  final Color accent;
  final _SceneKind scene;
  final IconData icon;
  final List<String> story;
  final List<(String, String, String)> words;
  final List<String> discoveries;
  final String question;
  final List<String> options;
  final int correct;
  final String reflection;
  final String stamp;
  final String prize;
  final String? cost;
}

const _sharedWords = [
  ('🕯️', '照见 zhàojiàn', '不只是看见，也像把隐藏的事照亮。'),
  ('🌫️', '若隐若现', '好像看得见，又好像看不清。'),
  ('📜', '相传 xiāngchuán', '表示故事来自长期流传，不等于已证实。'),
];

const _generalJourneys = <_Journey>[
  _Journey(
    title: '紫禁城 · 午门',
    kicker: '北京 · 清晨 07:10',
    category: '一般旅程',
    summary: '在城门开启前，听见一座宫城怎样安排空间、权力与人的脚步。',
    accent: Color(0xFFFFC45C),
    scene: _SceneKind.palace,
    icon: Icons.account_balance_rounded,
    story: [
      '天色刚亮，你站在午门前。城墙把远处的声音挡在外面，只留下脚步声一下一下靠近。',
      '抬头看，中央门洞正对着宫城深处。建筑没有说话，却用方向告诉每个人该走哪里。',
      '门缓缓开启。你第一次意识到：进入一座城，也是在进入它安排好的秩序。',
    ],
    words: _sharedWords,
    discoveries: [
      '午门是紫禁城的正门，现有建筑格局形成于明清时期。',
      '“午”在传统方位中指南方；午门位于紫禁城南端。',
    ],
    question: '故事中，建筑主要通过什么表达“秩序”？',
    options: ['门洞与方向的安排', '墙面的颜色', '清晨的天气'],
    correct: 0,
    reflection: '如果一座建筑能说话，你觉得午门会对你说什么？',
    stamp: '午门初启',
    prize: '晨光门钉拓片',
  ),
  _Journey(
    title: '外滩 · 两个时代',
    kicker: '上海 · 黄浦江风',
    category: '一般旅程',
    summary: '站在一条江的两岸之间，看旧建筑与新天际线如何彼此回答。',
    accent: Color(0xFF74D6D5),
    scene: _SceneKind.river,
    icon: Icons.water_rounded,
    story: [
      '江风从黄浦江上吹来，外滩的老建筑在晨光里慢慢显出轮廓。',
      '你转过身，浦东的高楼隔江相望。过去与未来没有争吵，只是同时倒映在水里。',
      '船驶过以后，水面重新平静。两个时代仍留在同一幅画中。',
    ],
    words: _sharedWords,
    discoveries: [
      '外滩是一段约一点五公里长的历史滨水区域。',
      '西岸历史建筑与东岸现代天际线形成上海代表性的城市景观。',
    ],
    question: '“隔江相望”在故事里连接了什么？',
    options: ['白天与夜晚', '过去与未来', '游客与船员'],
    correct: 1,
    reflection: '你的城市里，有没有两个时代同时出现的地方？',
    stamp: '双城相望',
    prize: '黄浦江微光瓶',
  ),
  _Journey(
    title: '西安 · 城墙暮色',
    kicker: '西安 · 日落之前',
    category: '一般旅程',
    summary: '沿着古城的时间边界前进，一边是旧街巷，一边是今日灯火。',
    accent: Color(0xFFE4B477),
    scene: _SceneKind.wall,
    icon: Icons.fort_rounded,
    story: [
      '你从永宁门登上城墙。夕阳把砖石的边缘染成温暖的金色。',
      '向内看，是街巷与老城；向外看，是道路、高楼和不断扩大的城市。',
      '你骑过一座角楼，仿佛短暂地沿着西安的时间边界前进。',
    ],
    words: _sharedWords,
    discoveries: [
      '西安现存城墙主要形成于明代，并经历多次修缮。',
      '城门、城楼、墙体与护城河共同组成古代防御体系。',
    ],
    question: '故事把城墙比作什么？',
    options: ['城市的时间边界', '一条河流', '一座市场'],
    correct: 0,
    reflection: '如果站在城墙上，你会先向城内看，还是向城外看？为什么？',
    stamp: '暮色巡城',
    prize: '城砖纹样章',
  ),
];

const _specialJourneys = <_Journey>[
  _Journey(
    title: '聊斋夜客',
    kicker: '子夜 · 客栈最后一盏灯',
    category: '志怪夜话',
    summary: '没有影子的客人留下一枚铜钱，只求你在鸡鸣前不要开门。',
    accent: Color(0xFFB8C8FF),
    scene: _SceneKind.moon,
    icon: Icons.nightlight_round,
    cost: '3 金币',
    story: [
      '子夜，一名没有影子的客人敲响木门。他站在雨里，衣角却没有湿。',
      '客人把一枚冰冷的铜钱放在柜上：“鸡鸣以前，无论听见谁叫你的名字，都不要开门。”',
      '三更过后，门外传来你最熟悉的声音。它叫了三次。铜钱在掌心里，慢慢变成一片湿叶。',
    ],
    words: _sharedWords,
    discoveries: [
      '《聊斋志异》是清代蒲松龄创作的文言短篇小说集。',
      '本旅程是受志怪文学气氛启发的原创故事，并非《聊斋志异》原篇。',
    ],
    question: '哪一项最早暗示夜客并非普通人？',
    options: ['他没有影子', '他说话很轻', '客栈正在下雨'],
    correct: 0,
    reflection: '如果门外传来你最想念的声音，你会守住承诺吗？',
    stamp: '守夜人',
    prize: '无影客的湿叶',
  ),
  _Journey(
    title: '月宫遗简',
    kicker: '神话寻踪 · 月落之前',
    category: '神话寻踪',
    summary: '一页从月宫飘落的残简，只留下“归去”二字和桂花的香气。',
    accent: Color(0xFFFFE6A6),
    scene: _SceneKind.moon,
    icon: Icons.brightness_2_rounded,
    cost: '2 金币',
    story: [
      '满月升起时，一页残简落在你窗前。纸上只有“归去”二字。',
      '你顺着桂花香走进山中，发现每一条路都通向同一片月光。',
      '天亮前，你必须决定：把残简送回月宫，还是留下它记住这场相遇。',
    ],
    words: _sharedWords,
    discoveries: [
      '嫦娥奔月有多个古代文献版本，人物动机与细节并不完全相同。',
      '月桂、玉兔与广寒宫等意象在后世文学艺术中逐渐丰富。',
    ],
    question: '故事中，哪一个线索一直为你指路？',
    options: ['钟声', '桂花香', '脚印'],
    correct: 1,
    reflection: '有些东西留下才能记住，有些东西送还才算完整。你会怎样选？',
    stamp: '月下拾简',
    prize: '会发光的桂叶',
  ),
  _Journey(
    title: '庄周梦蝶',
    kicker: '文学幻境 · 梦与醒之间',
    category: '文学幻境',
    summary: '醒来以后，你如何证明刚才是你梦见蝴蝶，而不是蝴蝶正在梦见你？',
    accent: Color(0xFF88D8C0),
    scene: _SceneKind.mountain,
    icon: Icons.flutter_dash_rounded,
    cost: '3 银币',
    story: [
      '你在树下醒来，一只蓝色蝴蝶停在手背。梦里，你曾拥有它的翅膀。',
      '风吹过以后，蝴蝶飞进竹林。你忽然记不起，究竟是谁先做了这个梦。',
      '山路分成两条：一条回到熟悉的人间，一条追随蝴蝶继续向前。',
    ],
    words: _sharedWords,
    discoveries: [
      '“庄周梦蝶”见于《庄子·齐物论》。',
      '这个寓言常被用来思考梦与现实、自我与变化的界限。',
    ],
    question: '“庄周梦蝶”主要触发哪一种思考？',
    options: ['如何捕捉蝴蝶', '梦与现实的界限', '竹林的方向'],
    correct: 1,
    reflection: '如果醒来后的你已经被一场梦改变，那场梦算不算真实？',
    stamp: '梦蝶未醒',
    prize: '一片梦中鳞粉',
  ),
  _Journey(
    title: '纸灯照骨',
    kicker: '民俗秘境 · 河灯尽头',
    category: '民俗秘境',
    summary: '老人说，今夜不要捞起逆流而上的纸灯——除非它写着你的名字。',
    accent: Color(0xFFFF917D),
    scene: _SceneKind.lantern,
    icon: Icons.local_fire_department_rounded,
    cost: '3 铜币',
    story: [
      '入夜后，河面漂满纸灯。只有一盏逆流而上，微弱的火光始终没有熄灭。',
      '它经过你身边时忽然停下。灯纸内侧，写着一个与你相同的名字。',
      '你伸出手，河水却映出一张比你年老许多的脸。',
    ],
    words: _sharedWords,
    discoveries: [
      '放河灯在不同地区有祈愿、祭祀或纪念等不同文化含义。',
      '本故事为民俗意象启发的原创幻想，不描述某一地区的固定仪式。',
    ],
    question: '故事中最不合常理的纸灯行为是什么？',
    options: ['发出微光', '写着名字', '逆流而上'],
    correct: 2,
    reflection: '如果灯里写着未来的你想说的一句话，你希望它是什么？',
    stamp: '逆流灯使',
    prize: '未来倒影碎片',
  ),
  _Journey(
    title: '一碗借来的梦',
    kicker: '碎银小旅 · 茶摊片刻',
    category: '碎银小旅',
    summary: '喝完这碗茶，你可以借走一个陌生人的梦，但必须留下自己的一个。',
    accent: Color(0xFFC9B9A7),
    scene: _SceneKind.dawn,
    icon: Icons.emoji_food_beverage_rounded,
    cost: '3 碎银',
    story: [
      '山路边的茶摊没有招牌。老板递来一只旧碗，说这里不收钱，只交换梦。',
      '碗底映出一座你从未去过的海边小城，还有一个人在等没有见过的你。',
      '茶快凉了。你要留下哪一个梦，才能把这段陌生的人生带走？',
    ],
    words: _sharedWords,
    discoveries: [
      '“黄粱一梦”等故事常借梦讨论欲望、人生与时间。',
      '本旅程为原创微型故事，让未通过挑战的探索者仍能继续发现。',
    ],
    question: '茶摊真正用来交换的是什么？',
    options: ['钱币', '名字', '梦'],
    correct: 2,
    reflection: '如果必须留下一场旧梦，你最舍不得哪一种感受？',
    stamp: '借梦茶客',
    prize: '陌生海岸的茶香',
  ),
];
