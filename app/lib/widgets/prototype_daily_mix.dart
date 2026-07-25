import 'package:flutter/material.dart';

class DailyMixPrototype extends StatefulWidget {
  const DailyMixPrototype({
    super.key,
    required this.text,
    this.learnedWords = const <String>{},
  });

  final String Function(String) text;
  final Set<String> learnedWords;

  @override
  State<DailyMixPrototype> createState() => _DailyMixPrototypeState();
}

class _DailyMixPrototypeState extends State<DailyMixPrototype> {
  final TextEditingController _sentenceController = TextEditingController();
  final List<String?> _layerSlots = <String?>[null, null, null];
  int _gameIndex = 0;
  String? _selectedLayer;
  String? _message;
  bool _wrongAnomaly = false;

  static const List<String> _layerCards = ['远山', '湖面', '廊窗'];
  static const List<String> _correctLayers = ['廊窗', '湖面', '远山'];

  String get _targetWord {
    for (final word in ['借景', '层次', '规划']) {
      if (widget.learnedWords.contains(word) ||
          (word == '层次' && widget.learnedWords.contains('層次'))) {
        return word;
      }
    }
    return '借景';
  }

  String t(String value) => widget.text(value);

  @override
  void dispose() {
    _sentenceController.dispose();
    super.dispose();
  }

  void _placeLayer(int slot) {
    final selected = _selectedLayer;
    if (selected == null) {
      setState(() => _message = '先点选一张景物卡，再放进位置。');
      return;
    }
    setState(() {
      for (var index = 0; index < _layerSlots.length; index++) {
        if (_layerSlots[index] == selected) _layerSlots[index] = null;
      }
      _layerSlots[slot] = selected;
      _selectedLayer = null;
      _message = null;
    });
  }

  void _checkLayers() {
    if (_layerSlots.any((item) => item == null)) {
      setState(() => _message = '三个位置都放好后，再检查画面。');
      return;
    }
    if (_layerSlots.join('|') == _correctLayers.join('|')) {
      setState(() {
        _gameIndex = 1;
        _message = null;
      });
      return;
    }
    setState(() => _message = '想想离你最近的是廊窗，最远的才是远山。可以继续调整。');
  }

  void _tapAnomaly(bool correct) {
    if (correct) {
      setState(() {
        _gameIndex = 2;
        _message = null;
        _wrongAnomaly = false;
      });
      return;
    }
    setState(() {
      _wrongAnomaly = true;
      _message = '这里本来就是合理景色。再找一处阻断观看关系的地方。';
    });
  }

  void _checkSentence() {
    final sentence = _sentenceController.text.trim();
    if (sentence.length >= 8 && sentence.contains(_targetWord)) {
      setState(() {
        _gameIndex = 3;
        _message = null;
      });
      return;
    }
    setState(() {
      _message = sentence.isEmpty
          ? '写一句自己的话，再把“$_targetWord”放进去。'
          : '再补充一点场景，让“$_targetWord”真正用在句子里。';
    });
  }

  void _restart() {
    _sentenceController.clear();
    setState(() {
      _gameIndex = 0;
      _selectedLayer = null;
      _message = null;
      _wrongAnomaly = false;
      for (var index = 0; index < _layerSlots.length; index++) {
        _layerSlots[index] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10211D), Color(0xFF1B1612)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 230),
        child: switch (_gameIndex) {
          0 => _buildLayerGame(),
          1 => _buildAnomalyGame(),
          2 => _buildSentenceGame(),
          _ => _buildComplete(),
        },
      ),
    );
  }

  Widget _buildLayerGame() {
    return ListView(
      key: const ValueKey('daily-mix-layers'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _DailyHeader(
          progress: '1 / 3',
          title: t('层次拼景'),
          subtitle: t('点一张景物卡，再放进近景、中景或远景。'),
          icon: Icons.layers_rounded,
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final card in _layerCards)
              ChoiceChip(
                key: ValueKey<String>('daily-layer-card-$card'),
                selected: _selectedLayer == card,
                onSelected: (_) => setState(() {
                  _selectedLayer = card;
                  _message = null;
                }),
                avatar: Icon(
                  card == '远山'
                      ? Icons.landscape_rounded
                      : card == '湖面'
                          ? Icons.water_rounded
                          : Icons.window_rounded,
                  size: 18,
                ),
                label: Text(
                  t(card),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E0B8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              for (var index = 0; index < 3; index++) ...[
                _LayerSlot(
                  key: ValueKey<String>('daily-layer-slot-$index'),
                  position: ['近景', '中景', '远景'][index],
                  value: _layerSlots[index],
                  text: widget.text,
                  onTap: () => _placeLayer(index),
                ),
                if (index < 2) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        _DailyMessage(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const ValueKey('daily-check-layers'),
          onPressed: _checkLayers,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2F7566),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.visibility_rounded),
          label: Text(
            t('检查画面层次'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildAnomalyGame() {
    return ListView(
      key: const ValueKey('daily-mix-anomaly'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _DailyHeader(
          progress: '2 / 3',
          title: t('找出异常'),
          subtitle: t('画面里有一处设计让游客看不到景色。直接点出来。'),
          icon: Icons.search_rounded,
        ),
        const SizedBox(height: 13),
        Container(
          height: 330,
          decoration: BoxDecoration(
            color: const Color(0xFFF0E0B8),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: const Color(0xFFD3AA67)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _AnomalyScenePainter()),
              ),
              Positioned(
                left: 15,
                top: 35,
                child: _HotspotButton(
                  key: const ValueKey('daily-anomaly-window'),
                  label: t('封死的廊窗'),
                  icon: Icons.window_rounded,
                  warning: _wrongAnomaly,
                  onTap: () => _tapAnomaly(true),
                ),
              ),
              Positioned(
                right: 16,
                top: 95,
                child: _HotspotButton(
                  key: const ValueKey('daily-anomaly-mountain'),
                  label: t('远山'),
                  icon: Icons.landscape_rounded,
                  warning: false,
                  onTap: () => _tapAnomaly(false),
                ),
              ),
              Positioned(
                right: 46,
                bottom: 27,
                child: _HotspotButton(
                  key: const ValueKey('daily-anomaly-water'),
                  label: t('湖面倒影'),
                  icon: Icons.water_rounded,
                  warning: false,
                  onTap: () => _tapAnomaly(false),
                ),
              ),
            ],
          ),
        ),
        _DailyMessage(message: _message == null ? null : t(_message!)),
      ],
    );
  }

  Widget _buildSentenceGame() {
    return ListView(
      key: const ValueKey('daily-mix-sentence'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _DailyHeader(
          progress: '3 / 3',
          title: t('一句话创作'),
          subtitle: t('最后不选答案。用你自己的话，把今天的知识放进一个真实场景。'),
          icon: Icons.edit_note_rounded,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E0B8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('本轮必须使用'),
                style: const TextStyle(
                  color: Color(0xFF66503B),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F7566),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  t(_targetWord),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const ValueKey('daily-sentence-input'),
                controller: _sentenceController,
                minLines: 3,
                maxLines: 5,
                onChanged: (_) {
                  if (_message != null) setState(() => _message = null);
                },
                decoration: InputDecoration(
                  hintText: t('例如：长廊的窗户把远山借景到眼前。'),
                  filled: true,
                  fillColor: const Color(0xFFFFF8E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        _DailyMessage(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const ValueKey('daily-check-sentence'),
          onPressed: _checkSentence,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2F7566),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.auto_awesome_rounded),
          label: Text(
            t('完成今日挑战'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    return ListView(
      key: const ValueKey('daily-mix-complete'),
      padding: const EdgeInsets.fromLTRB(15, 24, 15, 30),
      children: [
        const Icon(
          Icons.celebration_rounded,
          size: 62,
          color: Color(0xFFFFD467),
        ),
        const SizedBox(height: 8),
        Text(
          t('今日三练完成'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          t('同一份知识，经过排序、观察和创作三种不同操作。'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        for (final result in const [
          ('层次拼景', Icons.layers_rounded),
          ('找出异常', Icons.search_rounded),
          ('一句话创作', Icons.edit_note_rounded),
        ])
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E0B8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF2F7566),
                  child: Icon(result.$2, color: Colors.white),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    t(result.$1),
                    style: const TextStyle(
                      color: Color(0xFF3C3025),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF2F7566),
                ),
              ],
            ),
          ),
        const SizedBox(height: 5),
        OutlinedButton.icon(
          key: const ValueKey('daily-mix-restart'),
          onPressed: _restart,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD98B),
            side: const BorderSide(color: Color(0xFF5BA593)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.replay_rounded),
          label: Text(
            t('再玩一轮'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _DailyHeader extends StatelessWidget {
  const _DailyHeader({
    required this.progress,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String progress;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF5BA593).withValues(alpha: .4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF2F7566).withValues(alpha: .35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF9ED8C9)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progress,
                  style: const TextStyle(
                    color: Color(0xFF83C7B6),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFE8B8),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
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

class _LayerSlot extends StatelessWidget {
  const _LayerSlot({
    super.key,
    required this.position,
    required this.value,
    required this.text,
    required this.onTap,
  });

  final String position;
  final String? value;
  final String Function(String) text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: value == null
                ? Colors.white.withValues(alpha: .45)
                : const Color(0xFFD6E4D9),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: value == null
                  ? const Color(0xFFBEA273)
                  : const Color(0xFF2F7566),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 45,
                child: Text(
                  text(position),
                  style: const TextStyle(
                    color: Color(0xFF6F5138),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value == null ? text('点这里放入') : text(value!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: value == null
                        ? const Color(0xFF8B7861)
                        : const Color(0xFF205A4E),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                value == null ? Icons.add_rounded : Icons.swap_horiz_rounded,
                color: const Color(0xFF2F7566),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotspotButton extends StatelessWidget {
  const _HotspotButton({
    super.key,
    required this.label,
    required this.icon,
    required this.warning,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool warning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: warning
                ? const Color(0xFF9D3A31)
                : const Color(0xFF241A13).withValues(alpha: .82),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFFFD98B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: const Color(0xFFFFD98B)),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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

class _DailyMessage extends StatelessWidget {
  const _DailyMessage({required this.message});

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
                color: const Color(0xFF31584F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.tips_and_updates_rounded,
                    color: Color(0xFFA9E0D2),
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

class _AnomalyScenePainter extends CustomPainter {
  const _AnomalyScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0E0B8));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * .6),
      Paint()..color = const Color(0xFFD5DDD0),
    );

    final mountains = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .2, size.height * .29)
      ..lineTo(size.width * .35, size.height * .54)
      ..lineTo(size.width * .55, size.height * .24)
      ..lineTo(size.width * .72, size.height * .56)
      ..lineTo(size.width, size.height * .35)
      ..lineTo(size.width, size.height * .65)
      ..lineTo(0, size.height * .65)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF657B69));

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .6, size.width, size.height * .4),
      Paint()..color = const Color(0xFF8EB1AB),
    );

    final wood = Paint()..color = const Color(0xFF84362F);
    canvas.drawRect(Rect.fromLTWH(0, 0, 20, size.height), wood);
    canvas.drawRect(Rect.fromLTWH(size.width * .33, 0, 20, size.height), wood);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * .4, 22), wood);
    canvas.drawRect(
      Rect.fromLTWH(20, 22, size.width * .28, size.height * .5),
      Paint()..color = const Color(0xFF514941),
    );
    for (var index = 0; index < 7; index++) {
      final y = size.height * (.68 + index * .035);
      canvas.drawLine(
        Offset(size.width * .43, y),
        Offset(size.width * .9, y),
        Paint()
          ..color = Colors.white.withValues(alpha: .28)
          ..strokeWidth = 1.3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
