import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'journey_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    Future<void> openJourney() async {
      if (state.journeyCompleted) {
        await state.restartJourney();
      }
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const JourneyScreen()),
      );
    }

    return Stack(
      children: [
        const Positioned.fill(child: _JourneyBackground()),
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          children: [
            _TopBar(
              isSimplified: state.scriptMode == ScriptMode.simplified,
              onToggleScript: state.toggleScript,
            ),
            const SizedBox(height: 28),
            Text(
              '欢迎回来，Explorer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '世界很大，从一门语言开始。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _FlightMapCard(state: state),
            const SizedBox(height: 20),
            _JourneyCard(state: state, onOpen: openJourney),
            const SizedBox(height: 20),
            const _DiscoveryCard(),
          ],
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isSimplified,
    required this.onToggleScript,
  });

  final bool isSimplified;
  final VoidCallback onToggleScript;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: PhoenixTheme.red,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                offset: Offset(0, 8),
                color: Color(0x22000000),
              ),
            ],
          ),
          child: const Icon(Icons.local_fire_department, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PHOENIX JOURNEYS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text('你的语言旅行护照'),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onToggleScript,
          child: Text(isSimplified ? '简 / 繁' : '繁 / 简'),
        ),
      ],
    );
  }
}

class _JourneyBackground extends StatelessWidget {
  const _JourneyBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7EA),
            Color(0xFFF6E7D4),
            PhoenixTheme.paper,
          ],
        ),
      ),
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}

class _FlightMapCard extends StatefulWidget {
  const _FlightMapCard({required this.state});

  final AppState state;

  @override
  State<_FlightMapCard> createState() => _FlightMapCardState();
}

class _FlightMapCardState extends State<_FlightMapCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final status = state.journeyCompleted
        ? '北京已点亮 · 印章已获得'
        : state.hasJourneyInProgress
            ? '${state.beijingStampEarned ? '印章已收藏 · ' : ''}旅程 ${state.beijingJourneyProgressPercent}%'
            : state.beijingStampEarned
                ? '北京印章已收藏 · 可以再次出发'
                : '1,670 km · 学习航程';

    return Container(
      height: 245,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF173B3C),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Color(0x26000000),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          const Positioned(
            left: 20,
            top: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今日航线',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  '河内  →  北京',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = state.journeyCompleted
                    ? 1.0
                    : Curves.easeInOut.transform(_controller.value);
                final width = MediaQuery.sizeOf(context)
                    .width
                    .clamp(280.0, 760.0)
                    .toDouble();
                final x = 64.0 + (width - 150.0) * t;
                final y = 172.0 - math.sin(t * math.pi) * 70.0;
                return Stack(
                  children: [
                    Positioned(
                      left: x,
                      top: y,
                      child: Transform.rotate(
                        angle: -0.18,
                        child: const Icon(
                          Icons.flight,
                          color: Color(0xFFFFD47D),
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Positioned(
            left: 24,
            bottom: 24,
            child: _MapPin(label: '河内', active: false),
          ),
          Positioned(
            right: 24,
            top: 90,
            child: _MapPin(label: '北京', active: state.beijingStampEarned),
          ),
          Positioned(
            right: 18,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.location_on,
          color: active ? const Color(0xFFFFD47D) : Colors.white70,
          size: active ? 32 : 26,
        ),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.state, required this.onOpen});

  final AppState state;
  final VoidCallback onOpen;

  String get _buttonText {
    if (state.journeyCompleted) return '再次探索北京';
    if (state.hasJourneyInProgress) return '继续北京 Journey';
    return '开始北京 Journey';
  }

  IconData get _buttonIcon {
    if (state.journeyCompleted) return Icons.replay_rounded;
    if (state.hasJourneyInProgress) return Icons.play_arrow_rounded;
    return Icons.flight_takeoff;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _Pill(icon: Icons.place_outlined, text: '中国 · 北京'),
              Spacer(),
              Text('第一站', style: TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '第一次走进紫禁城',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          const Text('跟随 AI 导游，用故事、词汇和文化打开北京。'),
          if (state.hasJourneyInProgress || state.journeyCompleted) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.journeyCompleted
                        ? '旅程完成 · 北京紫禁城印章已收入护照'
                        : '上次停在「${state.beijingJourneyStepLabel}」',
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${state.beijingJourneyProgressPercent}%',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: state.beijingJourneyProgress,
                minHeight: 7,
                color: PhoenixTheme.red,
                backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              ),
            ),
          ] else if (state.beijingStampEarned) ...[
            const SizedBox(height: 18),
            const Text(
              '北京印章已收藏，可以随时再次体验。',
              style: TextStyle(
                color: PhoenixTheme.red,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeatureChip(icon: Icons.headphones, text: '自动朗读'),
              _FeatureChip(icon: Icons.touch_app, text: '长按查词'),
              _FeatureChip(icon: Icons.edit_note, text: '写作任务'),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: PhoenixTheme.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: Icon(_buttonIcon),
              label: Text(_buttonText),
              onPressed: onOpen,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE8C788)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF7B1E1E),
            child: Icon(Icons.auto_awesome, color: Colors.white),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discovery · 今日发现',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                SizedBox(height: 7),
                Text('为什么故宫的屋顶大多是黄色？'),
                SizedBox(height: 8),
                Text(
                  '中文朗读下方会显示探索者的解释语言，理解后再继续思考与表达。',
                  style: TextStyle(color: Colors.black54, height: 1.45),
                ),
              ],
            ),
          ),
          Icon(Icons.volume_up_outlined),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E5D2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: PhoenixTheme.red),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .07)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final route = Paint()
      ..color = const Color(0xFFFFD47D).withValues(alpha: .75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(54, size.height - 54)
      ..quadraticBezierTo(
        size.width * .5,
        size.height * .25,
        size.width - 54,
        110,
      );

    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .34);
    canvas.drawCircle(Offset(size.width * .08, 170), 65, paint);
    canvas.drawCircle(Offset(size.width * .92, 360), 90, paint);
    canvas.drawCircle(Offset(size.width * .18, size.height * .8), 75, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
