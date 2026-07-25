import 'package:flutter/material.dart';

class RoleAdventurePrototype extends StatefulWidget {
  const RoleAdventurePrototype({
    super.key,
    required this.text,
    this.learnedWords = const <String>{},
  });

  final String Function(String) text;
  final Set<String> learnedWords;

  @override
  State<RoleAdventurePrototype> createState() =>
      _RoleAdventurePrototypeState();
}

class _RoleAdventurePrototypeState extends State<RoleAdventurePrototype> {
  final TextEditingController _dialogueController = TextEditingController();
  _RoleStage _stage = _RoleStage.route;
  _RoleRoute? _route;
  double _viewPosition = .5;
  String? _hint;

  String t(String value) => widget.text(value);

  @override
  void dispose() {
    _dialogueController.dispose();
    super.dispose();
  }

  void _chooseRoute(_RoleRoute route) {
    setState(() {
      _route = route;
      _stage = _RoleStage.observe;
      _viewPosition = .5;
      _hint = null;
    });
  }

  void _confirmView() {
    final route = _route!;
    final target = route.target;
    if (_viewPosition >= target.$1 && _viewPosition <= target.$2) {
      setState(() {
        _stage = _RoleStage.dialogue;
        _hint = null;
      });
      return;
    }
    setState(() {
      _hint = _viewPosition < target.$1
          ? '再向右一点，让重要景物进入同一幅画。'
          : '稍微向左退一点，画面会更完整。';
    });
  }

  bool _matchesDisplayedKeyword(String answer, String keyword) {
    return answer.contains(keyword) || answer.contains(t(keyword));
  }

  void _submitDialogue() {
    final route = _route!;
    final answer = _dialogueController.text.trim();
    final matched = route.keywords.any(
      (keyword) => _matchesDisplayedKeyword(answer, keyword),
    );
    if (answer.length >= 6 && matched) {
      setState(() {
        _stage = _RoleStage.ending;
        _hint = null;
      });
      return;
    }
    setState(() {
      _hint = answer.isEmpty
          ? '先对阿澄说一句话，说明这里为什么值得画。'
          : '加入一个画面中的具体关系，例如“${t(route.keywords.first)}”。';
    });
  }

  void _restart() {
    _dialogueController.clear();
    setState(() {
      _stage = _RoleStage.route;
      _route = null;
      _viewPosition = .5;
      _hint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1712), Color(0xFF2B1D16)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: switch (_stage) {
          _RoleStage.route => _routeView(),
          _RoleStage.observe => _observeView(),
          _RoleStage.dialogue => _dialogueView(),
          _RoleStage.ending => _endingView(),
        },
      ),
    );
  }

  Widget _routeView() {
    return ListView(
      key: const ValueKey('role-adventure-route'),
      padding: const EdgeInsets.all(16),
      children: [
        _RoleHeader(
          step: t('任务 1 / 3'),
          title: t('陪小画师寻找取景地'),
          subtitle: t('路线没有唯一答案。你的选择会改变最后留下的画。'),
          icon: Icons.map_rounded,
        ),
        const SizedBox(height: 13),
        for (final route in _RoleRoute.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RoleActionCard(
              key: ValueKey<String>('role-route-${route.name}'),
              title: t(route.title),
              subtitle: t(route.subtitle),
              icon: route.icon,
              onTap: () => _chooseRoute(route),
            ),
          ),
      ],
    );
  }

  Widget _observeView() {
    final route = _route!;
    return ListView(
      key: const ValueKey('role-adventure-observe'),
      padding: const EdgeInsets.all(16),
      children: [
        _RoleHeader(
          step: t('任务 2 / 3'),
          title: t('移动取景框'),
          subtitle: t(route.task),
          icon: Icons.crop_free_rounded,
        ),
        const SizedBox(height: 13),
        Container(
          height: 270,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF2E1B8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD4A55D)),
          ),
          child: CustomPaint(
            painter: _RoleScenePainter(
              route: route,
              position: _viewPosition,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t('拖动滑杆，让金色方框找到最有意义的画面。'),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        Slider(
          key: const ValueKey('role-view-slider'),
          value: _viewPosition,
          activeColor: const Color(0xFFD9A84F),
          inactiveColor: Colors.white24,
          onChanged: (value) => setState(() {
            _viewPosition = value;
            _hint = null;
          }),
        ),
        _RoleHint(text: _hint == null ? null : t(_hint!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('role-confirm-view'),
          onPressed: _confirmView,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFAF4335),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.camera_alt_rounded),
          label: Text(
            t('就在这里取景'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _dialogueView() {
    final route = _route!;
    final relatedWords = widget.learnedWords
        .where(
          (word) => route.keywords.any(
            (keyword) => word.contains(keyword) || word.contains(t(keyword)),
          ),
        )
        .take(3)
        .toList(growable: false);
    return ListView(
      key: const ValueKey('role-adventure-dialogue'),
      padding: const EdgeInsets.all(16),
      children: [
        _RoleHeader(
          step: t('任务 3 / 3'),
          title: t('亲自告诉小画师'),
          subtitle: t('不用背标准答案。用一句自己的话说明这里为什么值得画。'),
          icon: Icons.chat_bubble_rounded,
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0DEB3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            t('阿澄：“我已经架好画板了。你为什么选这里？”'),
            style: const TextStyle(
              color: Color(0xFF3C2E23),
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (relatedWords.isNotEmpty) ...[
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final word in relatedWords)
                ActionChip(
                  label: Text(t(word)),
                  onPressed: () {
                    final current = _dialogueController.text.trim();
                    _dialogueController.text = current.isEmpty
                        ? t(word)
                        : '$current，${t(word)}';
                  },
                ),
            ],
          ),
        ],
        const SizedBox(height: 11),
        TextField(
          key: const ValueKey('role-dialogue-input'),
          controller: _dialogueController,
          minLines: 3,
          maxLines: 5,
          onChanged: (_) {
            if (_hint != null) setState(() => _hint = null);
          },
          decoration: InputDecoration(
            hintText: t(route.sample),
            filled: true,
            fillColor: const Color(0xFFFFF7E3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        _RoleHint(text: _hint == null ? null : t(_hint!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('role-submit-dialogue'),
          onPressed: _submitDialogue,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFAF4335),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          icon: const Icon(Icons.send_rounded),
          label: Text(
            t('告诉阿澄'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _endingView() {
    final route = _route!;
    return ListView(
      key: const ValueKey('role-adventure-ending'),
      padding: const EdgeInsets.all(18),
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          color: Color(0xFFFFD36B),
          size: 58,
        ),
        Text(
          t('你的画完成了'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 27,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: const Color(0xFFF0DEB3),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Icon(route.icon, size: 58, color: const Color(0xFF9D3A31)),
              const SizedBox(height: 8),
              Text(
                t(route.ending),
                style: const TextStyle(
                  color: Color(0xFF7B2D28),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                t(route.endingText),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4B392B),
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        OutlinedButton.icon(
          key: const ValueKey('role-adventure-restart'),
          onPressed: _restart,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD98B),
            side: const BorderSide(color: Color(0xFFD4A55D)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.route_rounded),
          label: Text(
            t('换一条路线再玩'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

enum _RoleStage { route, observe, dialogue, ending }

enum _RoleRoute {
  corridor,
  lake,
  hill;

  String get title => switch (this) {
        corridor => '走进长廊',
        lake => '沿着湖岸',
        hill => '登上山坡',
      };
  String get subtitle => switch (this) {
        corridor => '用廊窗把远山变成移动的画。',
        lake => '观察桥、水面与倒影的关系。',
        hill => '从高处看清园林整体层次。',
      };
  String get task => switch (this) {
        corridor => '让廊窗、湖面和远山同时进入取景框。',
        lake => '让桥、湖面和倒影形成完整关系。',
        hill => '让远近景物和游览路线都能看清。',
      };
  String get sample => switch (this) {
        corridor => '例如：廊窗可以借景，把远山放进画面。',
        lake => '例如：湖面有倒影，桥和远山看起来连在一起。',
        hill => '例如：站在高处，可以看清园林的层次和路线。',
      };
  String get ending => switch (this) {
        corridor => '结局：廊窗远山',
        lake => '结局：湖光倒影',
        hill => '结局：高处全景',
      };
  String get endingText => switch (this) {
        corridor => '每一扇窗都把远处重新带到眼前，画面随着脚步变化。',
        lake => '真实的桥和水中倒影彼此回应，湖面成为故事的一部分。',
        hill => '山、水、建筑和路线都有清楚位置，整座园林一目了然。',
      };
  IconData get icon => switch (this) {
        corridor => Icons.window_rounded,
        lake => Icons.water_rounded,
        hill => Icons.terrain_rounded,
      };
  (double, double) get target => switch (this) {
        corridor => (.65, .8),
        lake => (.42, .58),
        hill => (.17, .33),
      };
  List<String> get keywords => switch (this) {
        corridor => ['借景', '远山', '廊窗'],
        lake => ['湖面', '倒影', '桥'],
        hill => ['高处', '层次', '路线'],
      };
}

class _RoleHeader extends StatelessWidget {
  const _RoleHeader({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String step;
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
        border: Border.all(color: const Color(0xFFD6AD67).withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFAF4335).withValues(alpha: .35),
            child: Icon(icon, color: const Color(0xFFFFD98B)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: const TextStyle(
                    color: Color(0xFFD9A84F),
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

class _RoleActionCard extends StatelessWidget {
  const _RoleActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
            color: const Color(0xFF282119),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFD9A84F).withValues(alpha: .16),
                child: Icon(icon, color: const Color(0xFFFFD98B)),
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
                        fontWeight: FontWeight.w600,
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

class _RoleHint extends StatelessWidget {
  const _RoleHint({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: text == null
          ? const SizedBox(height: 5)
          : Container(
              key: ValueKey<String>(text!),
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF72362F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text!,
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

class _RoleScenePainter extends CustomPainter {
  const _RoleScenePainter({required this.route, required this.position});

  final _RoleRoute route;
  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFD7DDD0));
    final mountain = Path()
      ..moveTo(0, size.height * .62)
      ..lineTo(size.width * .18, size.height * .3)
      ..lineTo(size.width * .36, size.height * .57)
      ..lineTo(size.width * .55, size.height * .25)
      ..lineTo(size.width * .75, size.height * .58)
      ..lineTo(size.width, size.height * .38)
      ..lineTo(size.width, size.height * .67)
      ..lineTo(0, size.height * .67)
      ..close();
    canvas.drawPath(mountain, Paint()..color = const Color(0xFF627767));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .62, size.width, size.height * .38),
      Paint()..color = const Color(0xFF91B0A8),
    );
    if (route == _RoleRoute.corridor) {
      final wood = Paint()..color = const Color(0xFF81372F);
      for (var index = 0; index < 6; index++) {
        canvas.drawRect(
          Rect.fromLTWH(index * size.width / 5 - 5, 0, 10, size.height),
          wood,
        );
      }
    } else if (route == _RoleRoute.lake) {
      canvas.drawArc(
        Rect.fromLTWH(
          size.width * .25,
          size.height * .52,
          size.width * .5,
          size.height * .3,
        ),
        3.14,
        3.14,
        false,
        Paint()
          ..color = const Color(0xFFF0DDAF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12,
      );
    } else {
      canvas.drawLine(
        Offset(size.width * .1, size.height),
        Offset(size.width * .68, size.height * .2),
        Paint()
          ..color = const Color(0xFFD7BE88)
          ..strokeWidth = 24
          ..strokeCap = StrokeCap.round,
      );
    }

    final frameWidth = size.width * .28;
    final rect = Rect.fromLTWH(
      (size.width - frameWidth) * position,
      size.height * .18,
      frameWidth,
      size.height * .62,
    );
    final shade = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(shade, Paint()..color = Colors.black.withValues(alpha: .32));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()
        ..color = const Color(0xFFFFD05D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant _RoleScenePainter oldDelegate) {
    return route != oldDelegate.route || position != oldDelegate.position;
  }
}
