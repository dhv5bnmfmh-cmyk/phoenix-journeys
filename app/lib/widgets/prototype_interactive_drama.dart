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
  int _stage = 0;
  _Ally? _ally;
  final Set<_Clue> _clues = <_Clue>{};
  _Decision? _decision;
  String? _message;

  String t(String value) => widget.text(value);

  void _chooseAlly(_Ally ally) {
    setState(() {
      _ally = ally;
      _stage = 1;
      _message = null;
    });
  }

  void _collect(_Clue clue) {
    setState(() {
      _clues.add(clue);
      _message = clue.discovery;
    });
  }

  void _continueEvidence() {
    if (_clues.isEmpty) {
      setState(() => _message = '先找到至少一条证据。');
      return;
    }
    setState(() {
      _stage = 2;
      _message = null;
    });
  }

  void _chooseDecision(_Decision decision) {
    setState(() {
      _decision = decision;
      _stage = 3;
      _message = null;
    });
  }

  void _restart() {
    setState(() {
      _stage = 0;
      _ally = null;
      _clues.clear();
      _decision = null;
      _message = null;
    });
  }

  _Ending get _ending {
    final ally = _ally!;
    final decision = _decision!;
    final hasBoth = _clues.length == _Clue.values.length;

    if (decision == _Decision.rumor) {
      return _Ending(
        title: ally == _Ally.guide ? '结局：旧闻成真' : '结局：画坛轰动',
        subtitle: ally == _Ally.guide
            ? '你和福伯把老故事讲了出去。听众越来越多，证据却被热闹淹没。'
            : '你和阿澄让画稿迅速走红。它得到关注，也引来更多真假难辨的说法。',
        seal: '传闻',
        icon: Icons.campaign_rounded,
        accent: const Color(0xFFB44A3C),
      );
    }

    if (decision == _Decision.verify && hasBoth) {
      return _Ending(
        title: ally == _Ally.guide ? '结局：旧园证言' : '结局：真相守护者',
        subtitle: ally == _Ally.guide
            ? '福伯用园林记忆解释印章来源，你用水印补上年代证据，口述与实物终于互相证明。'
            : '阿澄比对材料和画法，你用印章补上出处证据，确认它是后来的临摹作品。',
        seal: ally == _Ally.guide ? '见证' : '求证',
        icon: ally == _Ally.guide
            ? Icons.record_voice_over_rounded
            : Icons.verified_rounded,
        accent: const Color(0xFF2F7566),
      );
    }

    if (decision == _Decision.question) {
      return _Ending(
        title: ally == _Ally.guide ? '结局：福伯的约定' : '结局：未完手卷',
        subtitle: ally == _Ally.guide
            ? '你和福伯把疑问写进园志，约定找到更多旧照片后再继续讲述。'
            : '你和阿澄保留画稿，让下一座城市的纸张专家继续调查。',
        seal: '存疑',
        icon: Icons.menu_book_rounded,
        accent: const Color(0xFF6652A5),
      );
    }

    return _Ending(
      title: ally == _Ally.guide ? '结局：谨慎的口述' : '结局：谨慎的鉴定',
      subtitle: ally == _Ally.guide
          ? '福伯讲出记忆，你明确标注目前只有一条证据，不把回忆当成最终结论。'
          : '阿澄提出材料判断，你明确标注证据仍不完整，等待进一步核对。',
      seal: '谨慎',
      icon: Icons.balance_rounded,
      accent: const Color(0xFFD09A3E),
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
        duration: const Duration(milliseconds: 220),
        child: switch (_stage) {
          0 => _openingView(),
          1 => _evidenceView(),
          2 => _decisionView(),
          _ => _endingView(),
        },
      ),
    );
  }

  Widget _openingView() {
    return ListView(
      key: const ValueKey('drama-opening'),
      padding: const EdgeInsets.all(16),
      children: [
        _DramaHeader(
          episode: t('第一幕'),
          title: t('湖边出现一页神秘画稿'),
          subtitle: t('有人说它是宫廷原作，也有人认为只是后来的临摹。先选择同行者。'),
        ),
        const SizedBox(height: 13),
        Container(
          height: 225,
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(21),
          ),
          child: const CustomPaint(painter: _OpeningPainter()),
        ),
        const SizedBox(height: 13),
        _DramaChoiceCard(
          key: const ValueKey('drama-ally-guide'),
          title: t('守园人 福伯'),
          subtitle: t('熟悉旧物、口述故事和园林记忆。'),
          quote: t('“这枚印章，我年轻时似乎见过。”'),
          icon: Icons.park_rounded,
          accent: const Color(0xFF8C5B35),
          onTap: () => _chooseAlly(_Ally.guide),
        ),
        const SizedBox(height: 9),
        _DramaChoiceCard(
          key: const ValueKey('drama-ally-painter'),
          title: t('青年画师 阿澄'),
          subtitle: t('熟悉纸张、画法和材料细节。'),
          quote: t('“先看纸张，材料比传说更难伪装。”'),
          icon: Icons.brush_rounded,
          accent: const Color(0xFF6652A5),
          onTap: () => _chooseAlly(_Ally.painter),
        ),
      ],
    );
  }

  Widget _evidenceView() {
    final ally = _ally!;
    return ListView(
      key: const ValueKey('drama-investigation'),
      padding: const EdgeInsets.all(16),
      children: [
        _DramaHeader(
          episode: t('第二幕'),
          title: t('搜查画稿'),
          subtitle: t('${ally.name}陪你调查。点击场景中的可疑位置，把证据放进卷袋。'),
        ),
        const SizedBox(height: 13),
        Container(
          height: 330,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _EvidencePainter()),
              ),
              Positioned(
                left: 22,
                top: 48,
                child: _EvidenceButton(
                  key: const ValueKey('drama-clue-seal'),
                  label: t('朱砂印章'),
                  collected: _clues.contains(_Clue.seal),
                  onTap: () => _collect(_Clue.seal),
                ),
              ),
              Positioned(
                right: 22,
                bottom: 45,
                child: _EvidenceButton(
                  key: const ValueKey('drama-clue-watermark'),
                  label: t('纸张水印'),
                  collected: _clues.contains(_Clue.watermark),
                  onTap: () => _collect(_Clue.watermark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              Text(
                t('卷袋：'),
                style: const TextStyle(
                  color: Color(0xFFFFD98B),
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (_clues.isEmpty)
                Text(
                  t('还没有证据'),
                  style: const TextStyle(color: Colors.white60),
                ),
              for (final clue in _clues)
                Chip(label: Text(t(clue.label))),
            ],
          ),
        ),
        _DramaHint(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('drama-continue-evidence'),
          onPressed: _continueEvidence,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6652A5),
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

  Widget _decisionView() {
    final ally = _ally!;
    return ListView(
      key: const ValueKey('drama-decision'),
      padding: const EdgeInsets.all(16),
      children: [
        _DramaHeader(
          episode: t('第三幕'),
          title: t('众人等待你的判断'),
          subtitle: t('最后的决定会和同行者、证据一起改变结局。'),
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAD8AE),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            t(ally.quote),
            style: const TextStyle(
              color: Color(0xFF423126),
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _DramaChoiceCard(
          key: const ValueKey('drama-decision-verify'),
          title: t('先核对，再公开'),
          subtitle: t('让现有证据互相证明，再给出判断。'),
          quote: t('“故事可以动人，但结论必须站得住。”'),
          icon: Icons.fact_check_rounded,
          accent: const Color(0xFF2F7566),
          onTap: () => _chooseDecision(_Decision.verify),
        ),
        const SizedBox(height: 9),
        _DramaChoiceCard(
          key: const ValueKey('drama-decision-question'),
          title: t('保留疑问，继续追查'),
          subtitle: t('把不确定写进游记，让未来旅程继续寻找答案。'),
          quote: t('“不知道，也可以是诚实的答案。”'),
          icon: Icons.help_outline_rounded,
          accent: const Color(0xFF6652A5),
          onTap: () => _chooseDecision(_Decision.question),
        ),
        const SizedBox(height: 9),
        _DramaChoiceCard(
          key: const ValueKey('drama-decision-rumor'),
          title: t('先把宫廷传说讲出去'),
          subtitle: t('故事最吸引人，但证据可能还不够。'),
          quote: t('“先让大家听见，真假以后再说。”'),
          icon: Icons.campaign_rounded,
          accent: const Color(0xFFB44A3C),
          onTap: () => _chooseDecision(_Decision.rumor),
        ),
      ],
    );
  }

  Widget _endingView() {
    final ending = _ending;
    return ListView(
      key: const ValueKey('drama-ending'),
      padding: const EdgeInsets.all(18),
      children: [
        Icon(ending.icon, size: 66, color: ending.accent),
        Text(
          t(ending.title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          t(ending.subtitle),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(18),
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
              const SizedBox(height: 11),
              Text(
                t('同行者、找到的证据和最后判断，都真实参与了这个结局。'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF5E4938),
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.learnedWords.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  t('本集带入 ${widget.learnedWords.length} 个已收藏词。'),
                  style: const TextStyle(
                    color: Color(0xFF78614D),
                    fontSize: 10.5,
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

enum _Ally {
  guide,
  painter;

  String get name => switch (this) {
        guide => '福伯',
        painter => '阿澄',
      };
  String get quote => switch (this) {
        guide => '福伯：“老故事值得尊重，但我也想知道证据怎么说。”',
        painter => '阿澄：“画法可以模仿，材料年代却很难说谎。”',
      };
}

enum _Clue {
  seal,
  watermark;

  String get label => switch (this) {
        seal => '朱砂印章',
        watermark => '纸张水印',
      };
  String get discovery => switch (this) {
        seal => '印章字形与宫廷旧印不同，更像后人仿刻。',
        watermark => '迎光能看到近代纸厂水印，年代比传说晚。',
      };
}

enum _Decision { verify, question, rumor }

class _Ending {
  const _Ending({
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

class _DramaHeader extends StatelessWidget {
  const _DramaHeader({
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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFE8B8),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
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

class _DramaChoiceCard extends StatelessWidget {
  const _DramaChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String quote;
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
            border: Border.all(color: accent.withValues(alpha: .72)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: accent,
                child: Icon(icon, color: Colors.white),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      quote,
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

class _EvidenceButton extends StatelessWidget {
  const _EvidenceButton({
    super.key,
    required this.label,
    required this.collected,
    required this.onTap,
  });

  final String label;
  final bool collected;
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
          child: Text(
            collected ? '✓ $label' : label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _DramaHint extends StatelessWidget {
  const _DramaHint({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: message == null
          ? const SizedBox(height: 5)
          : Container(
              key: ValueKey<String>(message!),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3B66),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}

class _OpeningPainter extends CustomPainter {
  const _OpeningPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFD7DDD0));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .62, size.width, size.height * .38),
      Paint()..color = const Color(0xFF91B0A8),
    );
    final paper = Rect.fromCenter(
      center: Offset(size.width * .52, size.height * .55),
      width: size.width * .42,
      height: size.height * .58,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(paper, const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFF3D0),
    );
    canvas.drawCircle(
      Offset(paper.right - 25, paper.bottom - 25),
      15,
      Paint()..color = const Color(0xFFB7493D),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EvidencePainter extends CustomPainter {
  const _EvidencePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF77513A));
    final paper = Rect.fromLTWH(
      size.width * .12,
      size.height * .11,
      size.width * .76,
      size.height * .72,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(paper, const Radius.circular(8)),
      Paint()..color = const Color(0xFFFFF2CF),
    );
    canvas.drawCircle(
      Offset(paper.left + 52, paper.top + 52),
      22,
      Paint()..color = const Color(0xFFB6483D),
    );
    for (var index = 0; index < 4; index++) {
      final y = paper.top + 115 + index * 30;
      canvas.drawLine(
        Offset(paper.left + 36, y),
        Offset(paper.right - 36, y),
        Paint()
          ..color = const Color(0xFF91AAA5).withValues(alpha: .55)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
