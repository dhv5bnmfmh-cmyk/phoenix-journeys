import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class LostScrollPrototypeScreen extends StatelessWidget {
  const LostScrollPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF17140F),
          appBar: AppBar(
            backgroundColor: const Color(0xFF241A13),
            foregroundColor: const Color(0xFFFFE9BA),
            title: const Text(
              'Phoenix · 失落画卷',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: LostScrollGame(learnedWords: state.savedWords),
          ),
        );
      },
    );
  }
}

class LostScrollGame extends StatefulWidget {
  const LostScrollGame({
    super.key,
    this.learnedWords = const <String>{},
    this.completed = false,
    this.onCompleted,
  });

  final Set<String> learnedWords;
  final bool completed;
  final VoidCallback? onCompleted;

  @override
  State<LostScrollGame> createState() => _LostScrollGameState();
}

class _LostScrollGameState extends State<LostScrollGame>
    with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final AnimationController _revealController;

  int _sceneIndex = 0;
  int _restoredCount = 0;
  bool _finished = false;
  bool _replaying = false;
  bool _resolving = false;
  String? _wrongChoiceId;

  static const List<_ScrollScene> _scenes = [
    _ScrollScene(
      title: '远山消失了',
      problem: '廊窗外只剩一团墨雾，远山无法进入眼前的画面。',
      question: '哪一个已学知识能把远景重新带回画卷？',
      correctId: 'borrow-scene',
      hint: '想想“把远处景物纳入眼前构图”的方法。',
      success: '借景让廊窗变成画框，远山重新进入视线。',
      choices: [
        _KnowledgeChoice(
          id: 'borrow-scene',
          label: '借景',
          source: '生词',
          explanation: '把远处景物纳入眼前构图',
          icon: Icons.landscape_rounded,
        ),
        _KnowledgeChoice(
          id: 'repair-building',
          label: '修建',
          source: '干扰线索',
          explanation: '改变建筑本身，并不能找回远景',
          icon: Icons.home_repair_service_rounded,
        ),
        _KnowledgeChoice(
          id: 'busy-scene',
          label: '热闹',
          source: '干扰线索',
          explanation: '描述气氛，不会改变观看关系',
          icon: Icons.groups_rounded,
        ),
      ],
    ),
    _ScrollScene(
      title: '山水挤成一团',
      problem: '山、水、桥和建筑失去了远近关系，全部堆在同一个位置。',
      question: '哪一个已学知识能让景物重新有前后与高低？',
      correctId: 'layers',
      hint: '这个词表示事物具有前后、高低或深浅的安排。',
      success: '层次重新分开近景、中景和远景，画面有了呼吸。',
      choices: [
        _KnowledgeChoice(
          id: 'layers',
          label: '层次',
          source: '生词＋发现',
          explanation: '让不同景物形成清楚的远近关系',
          icon: Icons.layers_rounded,
        ),
        _KnowledgeChoice(
          id: 'same-place',
          label: '放在一起',
          source: '妖气误导',
          explanation: '只会让画面继续拥挤',
          icon: Icons.dashboard_customize_rounded,
        ),
        _KnowledgeChoice(
          id: 'more-buildings',
          label: '增加建筑',
          source: '妖气误导',
          explanation: '数量更多，不代表布局更清楚',
          icon: Icons.apartment_rounded,
        ),
      ],
    ),
    _ScrollScene(
      title: '游人的脚步断开了',
      problem: '长廊里的人停在原地，景色也不再随着脚步逐段展开。',
      question: '故事里哪一条线索能让人物和风景重新流动？',
      correctId: 'moving-view',
      hint: '回想故事中，游客边走边看时发生了什么。',
      success: '脚步再次前进，每一扇廊窗都展开一幅不同的风景。',
      choices: [
        _KnowledgeChoice(
          id: 'moving-view',
          label: '边走边看，景色不断变化',
          source: '故事线索',
          explanation: '路线和观看感受彼此相连',
          icon: Icons.directions_walk_rounded,
        ),
        _KnowledgeChoice(
          id: 'stay-still',
          label: '停在哪里都一样',
          source: '妖气误导',
          explanation: '这正是画卷被破坏后的错误状态',
          icon: Icons.pause_circle_rounded,
        ),
        _KnowledgeChoice(
          id: 'close-window',
          label: '把廊窗全部关上',
          source: '妖气误导',
          explanation: '会让人物更看不到外面的景色',
          icon: Icons.window_rounded,
        ),
      ],
    ),
  ];

  bool get _isFinished => !_replaying && (widget.completed || _finished);
  _ScrollScene get _scene => _scenes[_sceneIndex];

  @override
  void initState() {
    super.initState();
    _finished = widget.completed;
    _restoredCount = widget.completed ? _scenes.length : 0;
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
  }

  @override
  void didUpdateWidget(covariant LostScrollGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.completed && !oldWidget.completed && !_replaying) {
      setState(() {
        _finished = true;
        _restoredCount = _scenes.length;
      });
    }
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  bool _isOldMemory(String label) {
    final normalized = widget.learnedWords.map((word) => word.trim()).toSet();
    if (label == '层次') {
      return normalized.contains('层次') || normalized.contains('層次');
    }
    return normalized.contains(label);
  }

  Future<void> _choose(_KnowledgeChoice choice) async {
    if (_resolving || _isFinished) return;
    if (choice.id != _scene.correctId) {
      setState(() => _wrongChoiceId = choice.id);
      return;
    }

    setState(() {
      _wrongChoiceId = null;
      _resolving = true;
    });
    await _revealController.forward(from: 0);
    if (!mounted) return;

    final nextRestored = _restoredCount + 1;
    if (nextRestored >= _scenes.length) {
      setState(() {
        _restoredCount = _scenes.length;
        _finished = true;
        _replaying = false;
        _resolving = false;
      });
      widget.onCompleted?.call();
      return;
    }

    setState(() {
      _restoredCount = nextRestored;
      _sceneIndex += 1;
      _resolving = false;
    });
    _revealController.reset();
  }

  void _restart() {
    setState(() {
      _sceneIndex = 0;
      _restoredCount = 0;
      _finished = false;
      _replaying = true;
      _resolving = false;
      _wrongChoiceId = null;
    });
    _revealController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: CustomPaint(painter: _SilkBackdropPainter())),
        AnimatedBuilder(
          animation: Listenable.merge([
            _ambientController,
            _revealController,
          ]),
          builder: (context, _) {
            return _isFinished
                ? _buildFinished(context)
                : _buildGame(context);
          },
        ),
      ],
    );
  }

  Widget _buildGame(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(14, compact ? 10 : 16, 14, 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGuideHeader(compact),
              SizedBox(height: compact ? 8 : 12),
              Text(
                '修复失落画卷',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFFE7B7),
                  fontSize: compact ? 22 : 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '看缺口，选一个已学知识，小凰会立刻把它写回画卷。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: compact ? 8 : 12),
              _buildProgress(),
              const SizedBox(height: 8),
              SizedBox(
                height: compact ? 190 : 225,
                child: CustomPaint(
                  painter: _LostScrollPainter(
                    restoredCount: _restoredCount,
                    activeReveal: _revealController.value,
                    ambient: _ambientController.value,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildProblemCard(),
              const SizedBox(height: 8),
              for (final choice in _scene.choices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: _buildChoice(choice),
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _wrongChoiceId == null
                    ? const SizedBox.shrink()
                    : _HintCard(
                        key: ValueKey<String>('hint-$_sceneIndex'),
                        text: _scene.hint,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideHeader(bool compact) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF3DFB5).withValues(alpha: .08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD7AD68).withValues(alpha: .3),
        ),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: compact ? 54 : 62,
            child: CustomPaint(
              painter: _PhoenixPainter(progress: _ambientController.value),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小凰画师',
                  style: TextStyle(
                    color: Color(0xFFFFE7B7),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '“别背规则。找到能修好眼前缺口的知识就行。”',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
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

  Widget _buildProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < _scenes.length; index++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: index < _restoredCount ? 36 : 24,
            height: 7,
            decoration: BoxDecoration(
              color: index < _restoredCount
                  ? const Color(0xFFD7AD68)
                  : index == _sceneIndex
                      ? const Color(0xFF9E3E35)
                      : Colors.white24,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          if (index < _scenes.length - 1) const SizedBox(width: 6),
        ],
        const SizedBox(width: 9),
        Text(
          '已修复 $_restoredCount / ${_scenes.length}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildProblemCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E5C5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1A35C)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '画卷缺口 ${_sceneIndex + 1} · ${_scene.title}',
            style: const TextStyle(
              color: Color(0xFF8E342D),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _scene.problem,
            style: const TextStyle(
              color: Color(0xFF2B2119),
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _scene.question,
            style: const TextStyle(
              color: Color(0xFF5D4937),
              fontSize: 11.5,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoice(_KnowledgeChoice choice) {
    final wrong = _wrongChoiceId == choice.id;
    final oldMemory = _isOldMemory(choice.label);
    return AnimatedScale(
      duration: const Duration(milliseconds: 170),
      scale: wrong ? .975 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey<String>('lost-scroll-choice-${choice.id}'),
          onTap: _resolving ? null : () => _choose(choice),
          borderRadius: BorderRadius.circular(13),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: wrong
                  ? const Color(0xFF71312C).withValues(alpha: .78)
                  : const Color(0xFF2B241C).withValues(alpha: .94),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: wrong
                    ? const Color(0xFFE59B83)
                    : oldMemory
                        ? const Color(0xFFE4C376)
                        : Colors.white.withValues(alpha: .13),
                width: oldMemory ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7AD68).withValues(alpha: .13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    choice.icon,
                    color: const Color(0xFFE4C376),
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              choice.label,
                              style: const TextStyle(
                                color: Color(0xFFFFE7B7),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (oldMemory) ...[
                            const SizedBox(width: 6),
                            const _SmallBadge(text: '旧游印记'),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${choice.source} · ${choice.explanation}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  wrong ? Icons.refresh_rounded : Icons.brush_rounded,
                  color: wrong ? const Color(0xFFFFC1AD) : Colors.white38,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinished(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(14, compact ? 12 : 20, 14, 22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            children: [
              SizedBox.square(
                dimension: compact ? 72 : 88,
                child: CustomPaint(
                  painter: _PhoenixPainter(
                    progress: _ambientController.value,
                    celebrating: true,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '画卷已复原',
                style: TextStyle(
                  color: Color(0xFFFFE7B7),
                  fontSize: 27,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '你用故事、生词和文化发现，让颐和园重新流动起来。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: compact ? 235 : 280,
                child: CustomPaint(
                  painter: _LostScrollPainter(
                    restoredCount: _scenes.length,
                    activeReveal: 0,
                    ambient: _ambientController.value,
                    completed: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DFB5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD1A35C)),
                ),
                child: const Column(
                  children: [
                    _SmallBadge(text: '体验纪念'),
                    SizedBox(height: 7),
                    Text(
                      '颐和园 · 借景长卷',
                      style: TextStyle(
                        color: Color(0xFF7F2D28),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '借景 · 层次 · 移步换景',
                      style: TextStyle(
                        color: Color(0xFF5D4937),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const ValueKey('lost-scroll-restart'),
                  onPressed: _restart,
                  style: FilledButton.styleFrom(
                    backgroundColor: PhoenixTheme.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text(
                    '再修复一次',
                    style: TextStyle(fontWeight: FontWeight.w900),
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

class _HintCard extends StatelessWidget {
  const _HintCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF6D302B).withValues(alpha: .72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD58C75)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFD59E), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '小凰提示：$text',
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
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF9B392F),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFE7B7),
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ScrollScene {
  const _ScrollScene({
    required this.title,
    required this.problem,
    required this.question,
    required this.correctId,
    required this.hint,
    required this.success,
    required this.choices,
  });

  final String title;
  final String problem;
  final String question;
  final String correctId;
  final String hint;
  final String success;
  final List<_KnowledgeChoice> choices;
}

class _KnowledgeChoice {
  const _KnowledgeChoice({
    required this.id,
    required this.label,
    required this.source,
    required this.explanation,
    required this.icon,
  });

  final String id;
  final String label;
  final String source;
  final String explanation;
  final IconData icon;
}

class _LostScrollPainter extends CustomPainter {
  const _LostScrollPainter({
    required this.restoredCount,
    required this.activeReveal,
    required this.ambient,
    this.completed = false,
  });

  final int restoredCount;
  final double activeReveal;
  final double ambient;
  final bool completed;

  double _progressFor(int segment) {
    if (segment < restoredCount) return 1;
    if (segment == restoredCount) return activeReveal;
    return 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paperRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(12, 8, size.width - 24, size.height - 16),
      const Radius.circular(13),
    );
    final paper = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF6E8C8), Color(0xFFE8D09E), Color(0xFFF3DFB5)],
      ).createShader(paperRect.outerRect);
    canvas.drawRRect(paperRect, paper);
    canvas.drawRRect(
      paperRect,
      Paint()
        ..color = const Color(0xFF8D5D34).withValues(alpha: .46)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final clip = Path()..addRRect(paperRect.deflate(5));
    canvas.save();
    canvas.clipPath(clip);

    _drawMountainSegment(canvas, size, _progressFor(0));
    _drawLakeSegment(canvas, size, _progressFor(1));
    _drawCorridorSegment(canvas, size, _progressFor(2));

    for (var index = 0; index < 3; index++) {
      final progress = _progressFor(index);
      if (progress >= .98) continue;
      final left = size.width * (.08 + index * .3);
      final width = size.width * .3;
      final haze = Paint()
        ..color = const Color(0xFF27302B).withValues(alpha: .58 * (1 - progress));
      for (var blob = 0; blob < 5; blob++) {
        final drift = math.sin(ambient * math.pi * 2 + blob + index) * 5;
        canvas.drawCircle(
          Offset(
            left + width * (.18 + blob * .16) + drift,
            size.height * (.37 + (blob.isEven ? .08 : -.02)),
          ),
          width * (.16 + blob * .012),
          haze,
        );
      }
    }

    if (activeReveal > 0 && restoredCount < 3) {
      final segmentLeft = size.width * (.07 + restoredCount * .3);
      final brushX = segmentLeft + size.width * .29 * activeReveal;
      final brushPaint = Paint()
        ..color = const Color(0xFFE3B75F).withValues(alpha: 1 - activeReveal * .25)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(brushX, size.height * .2),
        Offset(brushX - 16, size.height * .75),
        brushPaint,
      );
      for (var index = 0; index < 5; index++) {
        canvas.drawCircle(
          Offset(
            brushX + math.cos(index * 1.3) * 15,
            size.height * (.3 + index * .09),
          ),
          2.2,
          Paint()..color = const Color(0xFFFFE09A),
        );
      }
    }

    if (completed) {
      final glow = Paint()
        ..color = const Color(0xFFFFD77A).withValues(
          alpha: .12 + math.sin(ambient * math.pi * 2).abs() * .08,
        );
      canvas.drawRect(paperRect.outerRect, glow);
    }

    canvas.restore();

    _drawSeal(canvas, Offset(size.width - 43, size.height - 42));
    _drawRoller(canvas, size);
  }

  void _drawMountainSegment(Canvas canvas, Size size, double progress) {
    final gray = const Color(0xFF686D65);
    final mountainColor = Color.lerp(gray, const Color(0xFF52715F), progress)!;
    final path = Path()
      ..moveTo(size.width * .05, size.height * .62)
      ..lineTo(size.width * .15, size.height * .3)
      ..lineTo(size.width * .22, size.height * .52)
      ..lineTo(size.width * .31, size.height * .22)
      ..lineTo(size.width * .4, size.height * .61)
      ..close();
    canvas.drawPath(path, Paint()..color = mountainColor.withValues(alpha: .9));
    canvas.drawCircle(
      Offset(size.width * .18, size.height * .22),
      size.shortestSide * .045,
      Paint()
        ..color = Color.lerp(
          const Color(0xFF8A857A),
          const Color(0xFFBE4A3E),
          progress,
        )!,
    );
  }

  void _drawLakeSegment(Canvas canvas, Size size, double progress) {
    final lake = Paint()
      ..color = Color.lerp(
        const Color(0xFF8B8B82),
        const Color(0xFF6CA3A1),
        progress,
      )!.withValues(alpha: .82);
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .26,
        size.height * .54,
        size.width * .5,
        size.height * .25,
      ),
      lake,
    );
    final bridgePaint = Paint()
      ..color = Color.lerp(
        const Color(0xFF6D6961),
        const Color(0xFFC68A52),
        progress,
      )!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final bridge = Path()
      ..moveTo(size.width * .43, size.height * .64)
      ..quadraticBezierTo(
        size.width * .55,
        size.height * .48,
        size.width * .69,
        size.height * .64,
      );
    canvas.drawPath(bridge, bridgePaint);
  }

  void _drawCorridorSegment(Canvas canvas, Size size, double progress) {
    final wood = Paint()
      ..color = Color.lerp(
        const Color(0xFF625E57),
        const Color(0xFF9B3C33),
        progress,
      )!;
    final roof = Path()
      ..moveTo(size.width * .58, size.height * .42)
      ..lineTo(size.width * .93, size.height * .32)
      ..lineTo(size.width * .98, size.height * .42)
      ..lineTo(size.width * .63, size.height * .51)
      ..close();
    canvas.drawPath(roof, wood);
    for (var index = 0; index < 5; index++) {
      final x = size.width * (.64 + index * .065);
      canvas.drawRect(
        Rect.fromLTWH(x, size.height * .45, 5, size.height * .34),
        wood,
      );
    }
    final floorPaint = Paint()
      ..color = Color.lerp(
        const Color(0xFF7C776F),
        const Color(0xFFD2B071),
        progress,
      )!
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .61, size.height * .79),
      Offset(size.width * .96, size.height * .79),
      floorPaint,
    );
    final walkerPaint = Paint()
      ..color = Color.lerp(
        const Color(0xFF77736D),
        const Color(0xFF2E3C36),
        progress,
      )!
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 2; index++) {
      final x = size.width * (.72 + index * .1);
      canvas.drawCircle(
        Offset(x, size.height * .6),
        5,
        walkerPaint,
      );
      canvas.drawLine(
        Offset(x, size.height * .63),
        Offset(x + 3, size.height * .72),
        walkerPaint,
      );
      canvas.drawLine(
        Offset(x + 3, size.height * .72),
        Offset(x - 4, size.height * .78),
        walkerPaint,
      );
      canvas.drawLine(
        Offset(x + 3, size.height * .72),
        Offset(x + 10, size.height * .77),
        walkerPaint,
      );
    }
  }

  void _drawSeal(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFF9E3E35).withValues(alpha: .88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawRect(Rect.fromCenter(center: center, width: 28, height: 28), paint);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '凰',
        style: TextStyle(
          color: Color(0xFF9E3E35),
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawRoller(Canvas canvas, Size size) {
    final rollerPaint = Paint()..color = const Color(0xFF6B4027);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 2, 18, size.height - 4),
        const Radius.circular(8),
      ),
      rollerPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - 20, 2, 18, size.height - 4),
        const Radius.circular(8),
      ),
      rollerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LostScrollPainter oldDelegate) {
    return oldDelegate.restoredCount != restoredCount ||
        oldDelegate.activeReveal != activeReveal ||
        oldDelegate.ambient != ambient ||
        oldDelegate.completed != completed;
  }
}

class _PhoenixPainter extends CustomPainter {
  const _PhoenixPainter({required this.progress, this.celebrating = false});

  final double progress;
  final bool celebrating;

  @override
  void paint(Canvas canvas, Size size) {
    final bob = math.sin(progress * math.pi * 2) * size.height * .035;
    canvas.save();
    canvas.translate(0, bob);
    final center = Offset(size.width * .48, size.height * .5);
    canvas.drawCircle(
      center,
      size.width * .42,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE2B85F).withValues(alpha: celebrating ? .35 : .18),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width * .42)),
    );

    final wingLift = math.sin(progress * math.pi * 2) * .06;
    final wingPaint = Paint()..color = const Color(0xFF9E3E35);
    final leftWing = Path()
      ..moveTo(size.width * .43, size.height * .48)
      ..quadraticBezierTo(
        size.width * .12,
        size.height * (.18 + wingLift),
        size.width * .17,
        size.height * .62,
      )
      ..quadraticBezierTo(
        size.width * .3,
        size.height * .52,
        size.width * .43,
        size.height * .68,
      )
      ..close();
    canvas.drawPath(leftWing, wingPaint);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .58),
        width: size.width * .27,
        height: size.height * .42,
      ),
      Paint()..color = const Color(0xFFE2B85F),
    );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .33),
      size.width * .13,
      Paint()..color = const Color(0xFFFFE1A0),
    );
    final beak = Path()
      ..moveTo(size.width * .6, size.height * .33)
      ..lineTo(size.width * .76, size.height * .38)
      ..lineTo(size.width * .6, size.height * .42)
      ..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFD98036));
    canvas.drawCircle(
      Offset(size.width * .54, size.height * .31),
      size.width * .017,
      Paint()..color = const Color(0xFF201A15),
    );

    final brush = Paint()
      ..color = const Color(0xFFF6E8C8)
      ..strokeWidth = size.width * .04
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .58, size.height * .55),
      Offset(size.width * .82, size.height * .78),
      brush,
    );
    canvas.drawCircle(
      Offset(size.width * .84, size.height * .8),
      size.width * .055,
      Paint()..color = const Color(0xFF25231F),
    );

    if (celebrating) {
      for (var index = 0; index < 7; index++) {
        final angle = progress * math.pi * 2 + index * math.pi * 2 / 7;
        canvas.drawCircle(
          Offset(
            center.dx + math.cos(angle) * size.width * .42,
            center.dy + math.sin(angle) * size.height * .42,
          ),
          size.width * .025,
          Paint()..color = const Color(0xFFFFD77A),
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhoenixPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.celebrating != celebrating;
  }
}

class _SilkBackdropPainter extends CustomPainter {
  const _SilkBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD7AD68).withValues(alpha: .045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var y = 0.0; y < size.height; y += 22) {
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += 18) {
        path.lineTo(x, y + math.sin(x / 34 + y / 55) * 3);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SilkBackdropPainter oldDelegate) => false;
}
