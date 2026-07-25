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
  final List<String?> _slots = <String?>[null, null, null];
  int _stage = 0;
  String? _selectedCard;
  String? _message;

  static const List<String> _cards = ['远山', '湖面', '廊窗'];
  static const List<String> _correctOrder = ['廊窗', '湖面', '远山'];

  String t(String value) => widget.text(value);

  String get _targetWord {
    for (final word in const ['借景', '层次', '规划']) {
      if (widget.learnedWords.contains(word) ||
          widget.learnedWords.contains(t(word))) {
        return word;
      }
    }
    return '借景';
  }

  @override
  void dispose() {
    _sentenceController.dispose();
    super.dispose();
  }

  void _placeCard(int index) {
    final card = _selectedCard;
    if (card == null) {
      setState(() => _message = '先选择一张景物卡。');
      return;
    }
    setState(() {
      for (var slot = 0; slot < _slots.length; slot++) {
        if (_slots[slot] == card) _slots[slot] = null;
      }
      _slots[index] = card;
      _selectedCard = null;
      _message = null;
    });
  }

  void _checkOrder() {
    if (_slots.any((item) => item == null)) {
      setState(() => _message = '三个位置都放好后再检查。');
      return;
    }
    if (_slots.join('|') == _correctOrder.join('|')) {
      setState(() {
        _stage = 1;
        _message = null;
      });
      return;
    }
    setState(() => _message = '离你最近的是廊窗，最远的是远山。继续调整就好。');
  }

  void _chooseAnomaly(bool correct) {
    if (correct) {
      setState(() {
        _stage = 2;
        _message = null;
      });
      return;
    }
    setState(() => _message = '这部分本来合理。再找一处阻断游客观看的地方。');
  }

  void _checkSentence() {
    final answer = _sentenceController.text.trim();
    final displayedTarget = t(_targetWord);
    final containsTarget =
        answer.contains(_targetWord) || answer.contains(displayedTarget);
    if (answer.length >= 8 && containsTarget) {
      setState(() {
        _stage = 3;
        _message = null;
      });
      return;
    }
    setState(() {
      _message = answer.isEmpty
          ? '写一句自己的话，并使用“$displayedTarget”。'
          : '再补充一点场景，让“$displayedTarget”真正进入句子。';
    });
  }

  void _restart() {
    _sentenceController.clear();
    setState(() {
      _stage = 0;
      _selectedCard = null;
      _message = null;
      for (var index = 0; index < _slots.length; index++) {
        _slots[index] = null;
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
        duration: const Duration(milliseconds: 220),
        child: switch (_stage) {
          0 => _orderView(),
          1 => _anomalyView(),
          2 => _sentenceView(),
          _ => _completeView(),
        },
      ),
    );
  }

  Widget _orderView() {
    return ListView(
      key: const ValueKey('daily-mix-layers'),
      padding: const EdgeInsets.all(16),
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
            for (final card in _cards)
              ChoiceChip(
                key: ValueKey<String>('daily-layer-card-$card'),
                selected: _selectedCard == card,
                onSelected: (_) => setState(() {
                  _selectedCard = card;
                  _message = null;
                }),
                label: Text(
                  t(card),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
          ],
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E0B8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              for (var index = 0; index < _slots.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SlotCard(
                    key: ValueKey<String>('daily-layer-slot-$index'),
                    position: t(['近景', '中景', '远景'][index]),
                    value: _slots[index] == null ? null : t(_slots[index]!),
                    onTap: () => _placeCard(index),
                  ),
                ),
            ],
          ),
        ),
        _DailyHint(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('daily-check-layers'),
          onPressed: _checkOrder,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2F7566),
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

  Widget _anomalyView() {
    return ListView(
      key: const ValueKey('daily-mix-anomaly'),
      padding: const EdgeInsets.all(16),
      children: [
        _DailyHeader(
          progress: '2 / 3',
          title: t('找出异常'),
          subtitle: t('画面里有一处设计让游客看不到景色。直接点出来。'),
          icon: Icons.search_rounded,
        ),
        const SizedBox(height: 13),
        Container(
          height: 320,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF0E0B8),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _DailyScenePainter()),
              ),
              Positioned(
                left: 18,
                top: 38,
                child: _Hotspot(
                  key: const ValueKey('daily-anomaly-window'),
                  label: t('封死的廊窗'),
                  onTap: () => _chooseAnomaly(true),
                ),
              ),
              Positioned(
                right: 20,
                top: 90,
                child: _Hotspot(
                  key: const ValueKey('daily-anomaly-mountain'),
                  label: t('远山'),
                  onTap: () => _chooseAnomaly(false),
                ),
              ),
              Positioned(
                right: 43,
                bottom: 30,
                child: _Hotspot(
                  key: const ValueKey('daily-anomaly-water'),
                  label: t('湖面倒影'),
                  onTap: () => _chooseAnomaly(false),
                ),
              ),
            ],
          ),
        ),
        _DailyHint(message: _message == null ? null : t(_message!)),
      ],
    );
  }

  Widget _sentenceView() {
    return ListView(
      key: const ValueKey('daily-mix-sentence'),
      padding: const EdgeInsets.all(16),
      children: [
        _DailyHeader(
          progress: '3 / 3',
          title: t('一句话创作'),
          subtitle: t('最后不选答案。用自己的话把知识放进真实场景。'),
          icon: Icons.edit_note_rounded,
        ),
        const SizedBox(height: 13),
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
                t('必须使用'),
                style: const TextStyle(
                  color: Color(0xFF65503C),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Chip(
                backgroundColor: const Color(0xFF2F7566),
                label: Text(
                  t(_targetWord),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 9),
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
        _DailyHint(message: _message == null ? null : t(_message!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('daily-check-sentence'),
          onPressed: _checkSentence,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2F7566),
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

  Widget _completeView() {
    return ListView(
      key: const ValueKey('daily-mix-complete'),
      padding: const EdgeInsets.all(18),
      children: [
        const Icon(
          Icons.celebration_rounded,
          color: Color(0xFFFFD467),
          size: 62,
        ),
        Text(
          t('今日三练完成'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          t('同一份知识，经过排序、观察和创作三种不同操作。'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
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
                Icon(result.$2, color: const Color(0xFF2F7566)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t(result.$1),
                    style: const TextStyle(
                      color: Color(0xFF3C3025),
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
        OutlinedButton.icon(
          key: const ValueKey('daily-mix-restart'),
          onPressed: _restart,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD98B),
            side: const BorderSide(color: Color(0xFF5BA593)),
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
          CircleAvatar(
            backgroundColor: const Color(0xFF2F7566).withValues(alpha: .4),
            child: Icon(icon, color: const Color(0xFFA7DCCF)),
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFE8B8),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
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

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    super.key,
    required this.position,
    required this.value,
    required this.onTap,
  });

  final String position;
  final String? value;
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
                ? Colors.white.withValues(alpha: .5)
                : const Color(0xFFD7E4DA),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFF2F7566)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 46,
                child: Text(
                  position,
                  style: const TextStyle(
                    color: Color(0xFF6F5138),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value ?? '＋',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF205A4E),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hotspot extends StatelessWidget {
  const _Hotspot({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
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
            color: const Color(0xFF241A13).withValues(alpha: .84),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0xFFFFD98B)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyHint extends StatelessWidget {
  const _DailyHint({required this.message});

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
                color: const Color(0xFF31584F),
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

class _DailyScenePainter extends CustomPainter {
  const _DailyScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFD7DDD0));
    final mountain = Path()
      ..moveTo(0, size.height * .62)
      ..lineTo(size.width * .2, size.height * .3)
      ..lineTo(size.width * .38, size.height * .58)
      ..lineTo(size.width * .56, size.height * .25)
      ..lineTo(size.width * .74, size.height * .58)
      ..lineTo(size.width, size.height * .38)
      ..lineTo(size.width, size.height * .68)
      ..lineTo(0, size.height * .68)
      ..close();
    canvas.drawPath(mountain, Paint()..color = const Color(0xFF627767));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .62, size.width, size.height * .38),
      Paint()..color = const Color(0xFF91B0A8),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * .33, size.height * .58),
      Paint()..color = const Color(0xFF504841),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * .33, 0, 16, size.height),
      Paint()..color = const Color(0xFF81372F),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
