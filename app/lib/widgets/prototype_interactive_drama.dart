import 'package:flutter/material.dart';

class InteractiveDramaPrototype extends StatefulWidget {
  const InteractiveDramaPrototype({
    super.key,
    required this.text,
    this.learnedWords = const <String>{},
  });

  final String Function(String) text;
  final Set<String> learnedWords;

  @override
  State<InteractiveDramaPrototype> createState() =>
      _InteractiveDramaPrototypeState();
}

class _InteractiveDramaPrototypeState
    extends State<InteractiveDramaPrototype> {
  int _episode = 0;
  _DramaAlly? _ally;
  final Set<_DramaClue> _clues = <_DramaClue>{};
  _DramaDecision? _decision;
  String? _message;

  String t(String value) => widget.text(value);

  void _chooseAlly(_DramaAlly ally) {
    setState(() {
      _ally = ally;
      _episode = 1;
      _message = null;
    });
  }

  void _collectClue(_DramaClue clue) {
    setState(() {
      _clues.add(clue);
      _message = clue.discovery;
    });
  }

  void _continueFromClues() {
    if (_clues.isEmpty) {
      setState(() => _message = '先在场景里找到至少一条证据。');
      return;
    }
    setState(() {
      _episode = 2;
      _message = null;
    });
  }

  void _decide(_DramaDecision decision) {
    setState(() {
      _decision = decision;
      _episode = 3;
      _message = null;
    });
  }

  void _restart() {
    setState(() {
      _episode = 0;
      _ally = null;
      _clues.clear();
      _decision = null;
      _message = null;
    });
  }

  _DramaEnding get _ending {
    final decision = _decision!;
    final hasBoth = _clues.length == _DramaClue.values.length;
    if (decision == _DramaDecision.spreadRumor) {
      return const _DramaEnding(
        title: '结局：传说扩散',
        subtitle: '一句未经核对的话传遍了湖岸。故事热闹了，真相却更模糊。',
        seal: '轻信',
        icon: Icons.campaign_rounded,
        accent: Color(0xFFB44A3C),
      );
    }
    if (decision == _DramaDecision.verify && hasBoth) {
      return const _DramaEnding(
        title: '结局：真相守护者',
        subtitle: '纸张水印与旧印章互相证明，这页画稿来自后来的临摹，并非宫廷原作。',
        seal: '求证',
        icon: Icons.verified_rounded,
        accent: Color(0xFF2F7566),
      );
    }
    if (decision == _DramaDecision.keepQuestion) {
      return const _DramaEnding(
        title: '结局：未完手卷',
        subtitle: '你没有急着给出答案，而是把疑问写进游记，等待下一座城市出现新证据。',
        seal: '存疑',
        icon: Icons.menu_book_rounded,
        accent: Color(0xFF6652A5),
      );
    }
    return const _DramaEnding(
      title: '结局：谨慎的判断',
      subtitle: '你根据现有证据作出判断，同时明确告诉众人：目前仍缺少另一条证据。',
      seal: '谨慎',
      icon: Icons.balance_rounded,
      accent: Color(0xFFD09A3E),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF18131E), Color(0xFF261B19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: switch (_episode) {
          0 => _buildOpening(),
          1 => _buildInvestigation(),
          2 => _buildDecision(),
          _ => _buildEnding(),
        },
      ),
    );
  }

  Widget _buildOpening() {
    return ListView(
      key: const ValueKey('drama-opening'),
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 28),
      children: [
        _EpisodeHeader(
          episode: '第一幕',
          title: t('湖边出现一页神秘画稿'),
          subtitle: t('有人说它是宫廷原作，也有人认为只是后来临摹。你必须选择先跟谁行动。'),
        ),
        const SizedBox(height: 13),
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: const Color(0xFFCDA660)),
          ),
          clipBehavior: Clip.antiAlias,
          child: const CustomPaint(painter: _DramaOpeningPainter()),
        ),
        const SizedBox(height: 13),
        _AllyCard(
          key: const ValueKey('drama-ally-guide'),
          name: t('守园人 福伯'),
          quote: t('“我在园里四十年，这印章的样子我见过。”'),
          detail: t('擅长旧物、故事与园林记忆'),
          icon: Icons.park_rounded,
          accent: const Color(0xFF8C5B35),
          onTap: () => _chooseAlly(_DramaAlly.guide),
        ),
        const SizedBox(height: 9),
        _AllyCard(
          key: const ValueKey('drama-ally-painter'),
          name: t('青年画师 阿澄'),
          quote: t('“先别相信传说。纸张本身会留下年代的痕迹。”'),
          detail: t('擅长材料、画法与细节观察'),
          icon: Icons.brush_rounded,
          accent: const Color(0xFF6652A5),
          onTap: () => _chooseAlly(_DramaAlly.painter),
        ),
      ],
    );
  }

  Widget _buildInvestigation() {
    final ally = _ally!;
    return ListView(
      key: const ValueKey('drama-investigation'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _EpisodeHeader(
          episode: '第二幕',
          title: t('搜查画稿'),
          subtitle: t('${ally.displayName}陪你调查。点击场景中的可疑位置，证据会进入随身卷袋。'),
        ),
        const SizedBox(height: 12),
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: const Color(0xFFCDA660)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _DramaEvidencePainter()),
              ),
              Positioned(
                left: 25,
                top: 48,
                child: _EvidenceHotspot(
                  key: const ValueKey('drama-clue-seal'),
                  label: t('朱砂印章'),
                  collected: _clues.contains(_DramaClue.seal),
                  icon: Icons.approval_rounded,
                  onTap: () => _collectClue(_DramaClue.seal),
                ),
              ),
              Positioned(
                right: 24,
                bottom: 46,
                child: _EvidenceHotspot(
                  key: const ValueKey('drama-clue-watermark'),
                  label: t('纸张水印'),
                  collected: _clues.contains(_DramaClue.watermark),
                  icon: Icons.water_drop_rounded,
                  onTap: () => _collectClue(_DramaClue.watermark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _ClueBag(clues: _clues, text: widget.text),
        _DramaMessage(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const ValueKey('drama-continue-evidence'),
          onPressed: _continueFromClues,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6652A5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(
            t('带着证据去见众人'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildDecision() {
    final ally = _ally!;
    return ListView(
      key: const ValueKey('drama-decision'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _EpisodeHeader(
          episode: '第三幕',
          title: t('众人等待你的判断'),
          subtitle: t('你的选择会改变这页画稿以后被怎样讲述。没有系统替你决定。'),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ally.accent,
                    child: Icon(ally.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t(ally.decisionQuote),
                      style: const TextStyle(
                        color: Color(0xFF3F3026),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                t('你掌握的证据：${_clues.map((clue) => clue.label).join('、')}'),
                style: const TextStyle(
                  color: Color(0xFF70523B),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _DecisionCard(
          key: const ValueKey('drama-decision-verify'),
          title: t('先核对，再公开'),
          subtitle: t('让两条证据互相证明，再给出结论。'),
          icon: Icons.fact_check_rounded,
          accent: const Color(0xFF2F7566),
          onTap: () => _decide(_DramaDecision.verify),
        ),
        const SizedBox(height: 9),
        _DecisionCard(
          key: const ValueKey('drama-decision-question'),
          title: t('保留疑问，继续追查'),
          subtitle: t('把不确定写进游记，让后续旅程继续寻找答案。'),
          icon: Icons.help_outline_rounded,
          accent: const Color(0xFF6652A5),
          onTap: () => _decide(_DramaDecision.keepQuestion),
        ),
        const SizedBox(height: 9),
        _DecisionCard(
          key: const ValueKey('drama-decision-rumor'),
          title: t('先把宫廷传说讲出去'),
          subtitle: t('故事最吸引人，但证据可能还不够。'),
          icon: Icons.campaign_rounded,
          accent: const Color(0xFFB44A3C),
          onTap: () => _decide(_DramaDecision.spreadRumor),
        ),
      ],
    );
  }

  Widget _buildEnding() {
    final ending = _ending;
    return ListView(
      key: const ValueKey('drama-ending'),
      padding: const EdgeInsets.fromLTRB(15, 23, 15, 30),
      children: [
        Icon(ending.icon, size: 66, color: ending.accent),
        const SizedBox(height: 8),
        Text(
          t(ending.title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          t(ending.subtitle),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: ending.accent, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 82,
                height: 82,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ending.accent.withValues(alpha: .12),
                  border: Border.all(color: ending.accent, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t(ending.seal),
                  style: TextStyle(
                    color: ending.accent,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                t('同一集故事会因为盟友、证据和最后判断而进入不同结局。'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF5E4938),
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.learnedWords.isNotEmpty) ...[
                const SizedBox(height: 9),
                Text(
                  t('你带着 ${widget.learnedWords.length} 个已收藏词进入了这一集。'),
                  style: const TextStyle(
                    color: Color(0xFF78614D),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 13),
        OutlinedButton.icon(
          key: const ValueKey('drama-restart'),
          onPressed: _restart,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD98B),
            side: const BorderSide(color: Color(0xFF8A73C7)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.replay_rounded),
          label: Text(
            t('换一种选择重演'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

enum _DramaAlly {
  guide,
  painter;

  String get displayName => switch (this) {
        guide => '福伯',
        painter => '阿澄',
      };

  IconData get icon => switch (this) {
        guide => Icons.park_rounded,
        painter => Icons.brush_rounded,
      };

  Color get accent => switch (this) {
        guide => const Color(0xFF8C5B35),
        painter => const Color(0xFF6652A5),
      };

  String get decisionQuote => switch (this) {
        guide => '福伯说：“老故事值得尊重，但我也想知道证据究竟怎么说。”',
        painter => '阿澄说：“画法可以模仿，材料年代却很难说谎。”',
      };
}

enum _DramaClue {
  seal,
  watermark;

  String get label => switch (this) {
        seal => '朱砂印章',
        watermark => '纸张水印',
      };

  String get discovery => switch (this) {
        seal => '印章的字形与宫廷旧印不同，更像后人仿刻。',
        watermark => '迎光能看到近代纸厂水印，年代比传说晚得多。',
      };

  IconData get icon => switch (this) {
        seal => Icons.approval_rounded,
        watermark => Icons.water_drop_rounded,
      };
}

enum _DramaDecision { verify, keepQuestion, spreadRumor }

class _DramaEnding {
  const _DramaEnding({
    required this.title,
    required this.subtitle,
    required this.seal,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String seal;
  final IconData icon;
  final Color accent;
}

class _EpisodeHeader extends StatelessWidget {
  const _EpisodeHeader({
    required this.episode,
    required this.title,
    required this.subtitle,
  });

  final String episode;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8A73C7).withValues(alpha: .42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            episode,
            style: const TextStyle(
              color: Color(0xFFAA92E1),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFE8B8),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllyCard extends StatelessWidget {
  const _AllyCard({
    super.key,
    required this.name,
    required this.quote,
    required this.detail,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String name;
  final String quote;
  final String detail;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF28211F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withValues(alpha: .7)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: accent,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFFFFE8B8),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      quote,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: TextStyle(
                        color: accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFFFD98B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EvidenceHotspot extends StatelessWidget {
  const _EvidenceHotspot({
    super.key,
    required this.label,
    required this.collected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool collected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: collected
                ? const Color(0xFF2F7566)
                : const Color(0xFF241A13).withValues(alpha: .86),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFFFD98B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                collected ? Icons.check_rounded : icon,
                size: 17,
                color: const Color(0xFFFFD98B),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClueBag extends StatelessWidget {
  const _ClueBag({required this.clues, required this.text});

  final Set<_DramaClue> clues;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_rounded,
            color: Color(0xFFFFD98B),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: clues.isEmpty
                ? Text(
                    text('随身卷袋还是空的'),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Wrap(
                    spacing: 7,
                    runSpacing: 6,
                    children: [
                      for (final clue in clues)
                        Chip(
                          avatar: Icon(clue.icon, size: 16),
                          label: Text(
                            text(clue.label),
                            style: const TextStyle(fontWeight: FontWeight.w800),
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

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFF29221F),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: accent.withValues(alpha: .75)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withValues(alpha: .28),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFE8B8),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10.5,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFFFD98B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DramaMessage extends StatelessWidget {
  const _DramaMessage({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: message == null
          ? const SizedBox(height: 5)
          : Container(
              key: ValueKey<String>(message!),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3B66),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: Color(0xFFC6B3F3),
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DramaOpeningPainter extends CustomPainter {
  const _DramaOpeningPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEAD8AE));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * .62),
      Paint()..color = const Color(0xFFD4DDD1),
    );
    final mountains = Path()
      ..moveTo(0, size.height * .6)
      ..lineTo(size.width * .2, size.height * .3)
      ..lineTo(size.width * .38, size.height * .57)
      ..lineTo(size.width * .55, size.height * .26)
      ..lineTo(size.width * .74, size.height * .58)
      ..lineTo(size.width, size.height * .4)
      ..lineTo(size.width, size.height * .68)
      ..lineTo(0, size.height * .68)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF667A68));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .62, size.width, size.height * .38),
      Paint()..color = const Color(0xFF90ADA7),
    );
    final paperRect = Rect.fromCenter(
      center: Offset(size.width * .52, size.height * .58),
      width: size.width * .42,
      height: size.height * .52,
    );
    canvas.save();
    canvas.translate(paperRect.center.dx, paperRect.center.dy);
    canvas.rotate(-.08);
    canvas.translate(-paperRect.center.dx, -paperRect.center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(paperRect, const Radius.circular(5)),
      Paint()..color = const Color(0xFFFFF3D0),
    );
    canvas.drawPath(
      Path()
        ..moveTo(paperRect.left + 20, paperRect.bottom - 25)
        ..lineTo(paperRect.left + 65, paperRect.top + 35)
        ..lineTo(paperRect.center.dx, paperRect.bottom - 32)
        ..lineTo(paperRect.right - 35, paperRect.top + 45),
      Paint()
        ..color = const Color(0xFF6A756A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawCircle(
      Offset(paperRect.right - 28, paperRect.bottom - 28),
      15,
      Paint()..color = const Color(0xFFB7493D),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DramaEvidencePainter extends CustomPainter {
  const _DramaEvidencePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEAD8AE));
    final desk = Rect.fromLTWH(0, size.height * .64, size.width, size.height * .36);
    canvas.drawRect(desk, Paint()..color = const Color(0xFF77513A));
    final paperRect = Rect.fromLTWH(
      size.width * .12,
      size.height * .12,
      size.width * .74,
      size.height * .68,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(paperRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFFFFF2CF),
    );
    canvas.drawPath(
      Path()
        ..moveTo(paperRect.left + 24, paperRect.bottom - 35)
        ..lineTo(paperRect.left + 90, paperRect.top + 55)
        ..lineTo(paperRect.center.dx, paperRect.bottom - 45)
        ..lineTo(paperRect.right - 45, paperRect.top + 65),
      Paint()
        ..color = const Color(0xFF667469)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    canvas.drawCircle(
      Offset(paperRect.left + 55, paperRect.top + 60),
      23,
      Paint()..color = const Color(0xFFB6483D).withValues(alpha: .86),
    );
    for (var index = 0; index < 4; index++) {
      final y = paperRect.top + 105 + index * 28;
      canvas.drawLine(
        Offset(paperRect.left + 35, y),
        Offset(paperRect.right - 35, y),
        Paint()
          ..color = const Color(0xFF8FA9A4).withValues(alpha: .5)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
