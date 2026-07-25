import 'dart:math' as math;

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
  _AdventureStage _stage = _AdventureStage.route;
  _AdventureRoute? _route;
  double _framePosition = .5;
  String? _hint;

  @override
  void dispose() {
    _dialogueController.dispose();
    super.dispose();
  }

  String t(String value) => widget.text(value);

  void _chooseRoute(_AdventureRoute route) {
    setState(() {
      _route = route;
      _framePosition = .5;
      _hint = null;
      _stage = _AdventureStage.observe;
    });
  }

  void _confirmViewpoint() {
    final route = _route!;
    final target = route.target;
    if (_framePosition >= target.$1 && _framePosition <= target.$2) {
      setState(() {
        _hint = null;
        _stage = _AdventureStage.dialogue;
      });
      return;
    }

    setState(() {
      _hint = _framePosition < target.$1
          ? '再向右移动一点，那里能把路线与远景连起来。'
          : '向左退一点，画面会更完整。';
    });
  }

  void _submitDialogue() {
    final route = _route!;
    final answer = _dialogueController.text.trim();
    final matched = route.keywords.any(answer.contains);
    if (answer.length >= 6 && matched) {
      setState(() {
        _hint = null;
        _stage = _AdventureStage.ending;
      });
      return;
    }

    setState(() {
      _hint = answer.isEmpty
          ? '先对小画师说一句话，说明这里为什么值得画。'
          : '已经很接近了。试着加入“${route.keywords.take(2).join('”或“')}”这样的观察。';
    });
  }

  void _restart() {
    _dialogueController.clear();
    setState(() {
      _stage = _AdventureStage.route;
      _route = null;
      _framePosition = .5;
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
        duration: const Duration(milliseconds: 240),
        child: switch (_stage) {
          _AdventureStage.route => _buildRouteSelection(),
          _AdventureStage.observe => _buildObservation(),
          _AdventureStage.dialogue => _buildDialogue(),
          _AdventureStage.ending => _buildEnding(),
        },
      ),
    );
  }

  Widget _buildRouteSelection() {
    return ListView(
      key: const ValueKey('role-adventure-route'),
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 28),
      children: [
        _MissionHeader(
          step: '任务 1 / 3',
          title: t('陪小画师寻找取景地'),
          subtitle: t('没有正确路线。你选择的路，会决定最后留下哪一幅画。'),
          icon: Icons.map_rounded,
        ),
        const SizedBox(height: 13),
        for (final route in _AdventureRoute.values) ...[
          _RouteCard(
            key: ValueKey<String>('role-route-${route.name}'),
            route: route,
            text: widget.text,
            onTap: () => _chooseRoute(route),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildObservation() {
    final route = _route!;
    return ListView(
      key: const ValueKey('role-adventure-observe'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _MissionHeader(
          step: '任务 2 / 3',
          title: t('移动取景框'),
          subtitle: t(route.observationTask),
          icon: Icons.crop_free_rounded,
        ),
        const SizedBox(height: 12),
        Container(
          height: 270,
          decoration: BoxDecoration(
            color: const Color(0xFFF1E2BD),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: const Color(0xFFD4A55D), width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(
            painter: _AdventureScenePainter(
              route: route,
              framePosition: _framePosition,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.swipe_rounded,
              color: Color(0xFFFFD98B),
              size: 21,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                t('拖动滑杆，让金色取景框找到最有意义的位置。'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Slider(
          key: const ValueKey('role-view-slider'),
          value: _framePosition,
          onChanged: (value) => setState(() {
            _framePosition = value;
            _hint = null;
          }),
          activeColor: const Color(0xFFD9A84F),
          inactiveColor: Colors.white24,
        ),
        _HintLine(text: _hint == null ? null : t(_hint!)),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const ValueKey('role-confirm-view'),
          onPressed: _confirmViewpoint,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFAF4335),
            foregroundColor: Colors.white,
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

  Widget _buildDialogue() {
    final route = _route!;
    final learned = widget.learnedWords
        .where((word) => route.keywords.any(word.contains))
        .take(3)
        .toList(growable: false);
    return ListView(
      key: const ValueKey('role-adventure-dialogue'),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
      children: [
        _MissionHeader(
          step: '任务 3 / 3',
          title: t('亲自告诉小画师'),
          subtitle: t('不用背标准答案。用一句自己的话，说清楚这里为什么值得画。'),
          icon: Icons.chat_bubble_rounded,
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0DEB3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF9D3A31),
                child: Icon(
                  Icons.brush_rounded,
                  color: Color(0xFFFFE4A5),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('小画师 阿澄'),
                      style: const TextStyle(
                        color: Color(0xFF7B2D28),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t('“我已经架好画板了。你为什么选这里？”'),
                      style: const TextStyle(
                        color: Color(0xFF3C2E23),
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (learned.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            t('你以前收藏过的词：'),
            style: const TextStyle(
              color: Color(0xFFFFD98B),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 7,
            children: [
              for (final word in learned)
                ActionChip(
                  label: Text(t(word)),
                  onPressed: () {
                    final current = _dialogueController.text.trim();
                    _dialogueController.text = current.isEmpty
                        ? word
                        : '$current，$word';
                    _dialogueController.selection = TextSelection.collapsed(
                      offset: _dialogueController.text.length,
                    );
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
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_hint != null) setState(() => _hint = null);
          },
          decoration: InputDecoration(
            hintText: t(route.sampleLine),
            filled: true,
            fillColor: const Color(0xFFF8EFD8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        _HintLine(text: _hint == null ? null : t(_hint!)),
        const SizedBox(height: 9),
        FilledButton.icon(
          key: const ValueKey('role-submit-dialogue'),
          onPressed: _submitDialogue,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFAF4335),
            foregroundColor: Colors.white,
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

  Widget _buildEnding() {
    final route = _route!;
    return ListView(
      key: const ValueKey('role-adventure-ending'),
      padding: const EdgeInsets.fromLTRB(15, 21, 15, 30),
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          color: Color(0xFFFFD36B),
          size: 58,
        ),
        const SizedBox(height: 7),
        Text(
          t('你的画完成了'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFFE8B8),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          t('路线、观察位置和你说的话，共同决定了这次结局。'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFFF0DEB3),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD4A55D), width: 1.4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _AdventureScenePainter(
                    route: route,
                    framePosition: (route.target.$1 + route.target.$2) / 2,
                    finished: true,
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF241A13).withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(route.endingTitle),
                        style: const TextStyle(
                          color: Color(0xFFFFDA8D),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t(route.endingDescription),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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

enum _AdventureStage { route, observe, dialogue, ending }

enum _AdventureRoute {
  corridor,
  lake,
  hill;

  String get title => switch (this) {
        corridor => '走进长廊',
        lake => '沿着湖岸',
        hill => '登上山坡',
      };

  String get subtitle => switch (this) {
        corridor => '廊窗会把远山切成一幅幅移动的画。',
        lake => '水面、倒影与桥梁会进入同一个画面。',
        hill => '从高处观察园林整体的方向与层次。',
      };

  IconData get icon => switch (this) {
        corridor => Icons.window_rounded,
        lake => Icons.water_rounded,
        hill => Icons.terrain_rounded,
      };

  (double, double) get target => switch (this) {
        corridor => (.64, .79),
        lake => (.41, .57),
        hill => (.17, .33),
      };

  String get observationTask => switch (this) {
        corridor => '寻找一个位置，让廊窗、湖面和远山同时进入画面。',
        lake => '寻找一个位置，让桥、湖面和倒影形成完整关系。',
        hill => '寻找一个位置，让远近景物和游览路线都能看清。',
      };

  List<String> get keywords => switch (this) {
        corridor => ['借景', '远山', '廊窗', '变化'],
        lake => ['湖面', '倒影', '水', '桥'],
        hill => ['高处', '全景', '层次', '路线'],
      };

  String get sampleLine => switch (this) {
        corridor => '例如：从廊窗看出去，可以把远山借进画里。',
        lake => '例如：湖面有倒影，桥和远山看起来连在一起。',
        hill => '例如：站在高处，可以看清园林的层次和路线。',
      };

  String get endingTitle => switch (this) {
        corridor => '结局：廊窗远山',
        lake => '结局：湖光倒影',
        hill => '结局：高处全景',
      };

  String get endingDescription => switch (this) {
        corridor => '阿澄画下了行走中的景色。每一扇窗，都把远处重新带到眼前。',
        lake => '阿澄保留了水面的安静。真实的桥与倒影，在画中彼此回应。',
        hill => '阿澄画下了园林的整体结构。山、水、建筑与路线都有清楚的位置。',
      };
}

class _MissionHeader extends StatelessWidget {
  const _MissionHeader({
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
        border: Border.all(color: const Color(0xFFD6AD67).withValues(alpha: .32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFAF4335).withValues(alpha: .24),
              borderRadius: BorderRadius.circular(14),
            ),
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

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    super.key,
    required this.route,
    required this.text,
    required this.onTap,
  });

  final _AdventureRoute route;
  final String Function(String) text;
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
                radius: 27,
                backgroundColor: const Color(0xFFD9A84F).withValues(alpha: .16),
                child: Icon(route.icon, color: const Color(0xFFFFD98B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text(route.title),
                      style: const TextStyle(
                        color: Color(0xFFFFE8B8),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      text(route.subtitle),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        height: 1.35,
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

class _HintLine extends StatelessWidget {
  const _HintLine({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: text == null
          ? const SizedBox(height: 5)
          : Container(
              key: ValueKey<String>(text!),
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF72362F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: Color(0xFFFFD98B),
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      text!,
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

class _AdventureScenePainter extends CustomPainter {
  const _AdventureScenePainter({
    required this.route,
    required this.framePosition,
    this.finished = false,
  });

  final _AdventureRoute route;
  final double framePosition;
  final bool finished;

  @override
  void paint(Canvas canvas, Size size) {
    final paper = Paint()..color = const Color(0xFFF1E2BD);
    canvas.drawRect(Offset.zero & size, paper);

    final sky = Rect.fromLTWH(0, 0, size.width, size.height * .58);
    canvas.drawRect(sky, Paint()..color = const Color(0xFFD9DDCC));

    final mountain = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .12, size.height * .35)
      ..lineTo(size.width * .23, size.height * .51)
      ..lineTo(size.width * .36, size.height * .27)
      ..lineTo(size.width * .49, size.height * .55)
      ..lineTo(size.width * .64, size.height * .31)
      ..lineTo(size.width * .79, size.height * .56)
      ..lineTo(size.width, size.height * .4)
      ..lineTo(size.width, size.height * .66)
      ..lineTo(0, size.height * .66)
      ..close();
    canvas.drawPath(
      mountain,
      Paint()..color = const Color(0xFF607767).withValues(alpha: .85),
    );

    final waterRect = Rect.fromLTWH(
      0,
      size.height * .59,
      size.width,
      size.height * .41,
    );
    canvas.drawRect(waterRect, Paint()..color = const Color(0xFF91B0A8));
    for (var line = 0; line < 8; line++) {
      final y = size.height * (.64 + line * .035);
      canvas.drawLine(
        Offset(size.width * .05, y),
        Offset(size.width * (.4 + math.sin(line) * .12), y),
        Paint()
          ..color = Colors.white.withValues(alpha: .28)
          ..strokeWidth = 1.2,
      );
    }

    if (route == _AdventureRoute.corridor) {
      final wood = Paint()..color = const Color(0xFF7F342D);
      canvas.drawRect(
        Rect.fromLTWH(0, size.height * .12, size.width, 21),
        wood,
      );
      for (var index = 0; index < 7; index++) {
        final x = index * size.width / 6;
        canvas.drawRect(
          Rect.fromLTWH(x - 6, size.height * .12, 12, size.height * .88),
          wood,
        );
      }
    } else if (route == _AdventureRoute.lake) {
      final bridge = Paint()
        ..color = const Color(0xFFE7D3A4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12;
      canvas.drawArc(
        Rect.fromLTWH(
          size.width * .25,
          size.height * .55,
          size.width * .5,
          size.height * .28,
        ),
        math.pi,
        math.pi,
        false,
        bridge,
      );
    } else {
      final path = Paint()
        ..color = const Color(0xFFD8C18E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(
        Path()
          ..moveTo(size.width * .08, size.height)
          ..quadraticBezierTo(
            size.width * .38,
            size.height * .72,
            size.width * .26,
            size.height * .5,
          )
          ..quadraticBezierTo(
            size.width * .5,
            size.height * .38,
            size.width * .67,
            size.height * .16,
          ),
        path,
      );
    }

    final frameWidth = size.width * .28;
    final frameLeft = (size.width - frameWidth) * framePosition;
    final frameRect = Rect.fromLTWH(
      frameLeft,
      size.height * .18,
      frameWidth,
      size.height * .61,
    );
    final shade = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(8)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      shade,
      Paint()..color = Colors.black.withValues(alpha: finished ? .08 : .34),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(8)),
      Paint()
        ..color = const Color(0xFFFFD05D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = finished ? 5 : 3,
    );

    if (finished) {
      canvas.drawCircle(
        Offset(frameRect.center.dx, frameRect.top + 22),
        8,
        Paint()..color = const Color(0xFFFFD05D),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AdventureScenePainter oldDelegate) {
    return route != oldDelegate.route ||
        framePosition != oldDelegate.framePosition ||
        finished != oldDelegate.finished;
  }
}
