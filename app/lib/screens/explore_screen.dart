import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journey_background.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/destination_background.dart';
import '../widgets/journey_picker_sheet.dart';
import 'journey_screen.dart';

@visibleForTesting
double compactExploreMapHeight(double viewportHeight) {
  if (viewportHeight < 700) return 160;
  if (viewportHeight < 820) return 174;
  return 188;
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final mapHeight = compactExploreMapHeight(viewportHeight);

    Future<void> openJourneyById(String journeyId) async {
      await state.activateJourney(journeyId);
      if (state.journeyCompleted) {
        await state.restartJourney();
      }
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => JourneyScreen(journeyId: journeyId)),
      );
    }

    Future<void> chooseJourney() async {
      final journeyId = await showJourneyPickerSheet(
        context: context,
        state: state,
      );
      if (journeyId != null) {
        await openJourneyById(journeyId);
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: _JourneyBackground(journeyId: state.activeJourneyId),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Column(
            children: [
              _TopBar(state: state),
              const SizedBox(height: 7),
              Text(
                state.displayText('欢迎回来，Explorer'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                state.displayText('世界很大，从一门语言开始。'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11.5,
                  height: 1.15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              _FlightMapCard(state: state, height: mapHeight),
              const SizedBox(height: 8),
              _JourneyCard(
                state: state,
                onOpen: () => unawaited(openJourneyById(state.activeJourneyId)),
                onChoose: () => unawaited(chooseJourney()),
              ),
              const SizedBox(height: 8),
              const _DiscoveryCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F2B28), PhoenixTheme.red],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  color: Color(0x18000000),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PHOENIX JOURNEYS',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .9,
                  ),
                ),
                Text(
                  state.displayText('你的语言旅行护照'),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.05,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: state.toggleScript,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.translate_rounded, size: 14),
            label: Text(
              state.isTraditional ? '繁體' : '简体',
              style: const TextStyle(fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyBackground extends StatelessWidget {
  const _JourneyBackground({required this.journeyId});

  final String journeyId;

  @override
  Widget build(BuildContext context) {
    return DestinationBackground(
      journeyId: journeyId,
      pageType: JourneyBackgroundPage.explore,
      scrimStrength: .28,
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}

class _FlightMapCard extends StatefulWidget {
  const _FlightMapCard({required this.state, required this.height});

  final AppState state;
  final double height;

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
      duration: const Duration(seconds: 7),
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
        ? '${state.activeJourney.city}已点亮 · 印章已获得'
        : state.hasJourneyInProgress
        ? '${state.activeJourneyStampEarned ? '印章已收藏 · ' : ''}旅程 ${state.beijingJourneyProgressPercent}%'
        : state.activeJourneyStampEarned
        ? '${state.activeJourney.city}印章已收藏 · 可以再次出发'
        : '${state.activeJourney.distanceLabel} · 学习航程';

    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2834), Color(0xFF124B54), Color(0xFF0C303A)],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Color(0x31000000),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final journeyProgress = state.journeyCompleted
                  ? 1.0
                  : state.hasJourneyInProgress
                  ? state.beijingJourneyProgress
                  : _controller.value;
              final flightT = state.journeyCompleted
                  ? 1.0
                  : Curves.easeInOutCubic.transform(_controller.value);
              final geometry = _FlightGeometry(
                Size(constraints.maxWidth, constraints.maxHeight),
              );
              final plane = geometry.pointAt(flightT);
              final angle = geometry.angleAt(flightT);

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PremiumMapPainter(
                        routeProgress: journeyProgress,
                        pulse: _controller.value,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 9,
                    right: 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.displayText('今日航线'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                state.displayText(
                                  '河内  →  ${state.activeJourney.city}',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFFFD879),
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                state.displayText('AI 旅程'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: plane.dx - 13,
                    top: plane.dy - 13,
                    child: Transform.rotate(
                      angle: angle,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD879),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD879,
                              ).withValues(alpha: .45),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flight_rounded,
                          color: Color(0xFF713016),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: geometry.hanoi.dx - 16,
                    top: geometry.hanoi.dy - 16,
                    child: _CityMarker(
                      label: state.displayText('河内'),
                      subtitle: 'HAN',
                      active: false,
                      pulse: _controller.value,
                    ),
                  ),
                  Positioned(
                    left: geometry.beijing.dx - 16,
                    top: geometry.beijing.dy - 16,
                    child: _CityMarker(
                      label: state.displayText(state.activeJourney.city),
                      subtitle: state.activeJourney.cityCode,
                      active: state.activeJourneyStampEarned,
                      pulse: _controller.value,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071D26).withValues(alpha: .70),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD879),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.displayText(status),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '${state.beijingJourneyProgressPercent}%',
                            style: const TextStyle(
                              color: Color(0xFFFFD879),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _FlightGeometry {
  _FlightGeometry(this.size)
    : hanoi = Offset(size.width * .23, size.height * .68),
      control = Offset(size.width * .48, size.height * .25),
      beijing = Offset(size.width * .78, size.height * .43);

  final Size size;
  final Offset hanoi;
  final Offset control;
  final Offset beijing;

  Offset pointAt(double t) {
    final oneMinus = 1 - t;
    return Offset(
      oneMinus * oneMinus * hanoi.dx +
          2 * oneMinus * t * control.dx +
          t * t * beijing.dx,
      oneMinus * oneMinus * hanoi.dy +
          2 * oneMinus * t * control.dy +
          t * t * beijing.dy,
    );
  }

  double angleAt(double t) {
    final dx =
        2 * (1 - t) * (control.dx - hanoi.dx) +
        2 * t * (beijing.dx - control.dx);
    final dy =
        2 * (1 - t) * (control.dy - hanoi.dy) +
        2 * t * (beijing.dy - control.dy);
    return math.atan2(dy, dx);
  }
}

class _CityMarker extends StatelessWidget {
  const _CityMarker({
    required this.label,
    required this.subtitle,
    required this.active,
    required this.pulse,
  });

  final String label;
  final String subtitle;
  final bool active;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final scale = 1 + math.sin(pulse * math.pi * 2) * .035;
    final color = active ? const Color(0xFFFFD879) : Colors.white;

    return Transform.scale(
      scale: scale,
      child: Column(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFF08252D).withValues(alpha: .88),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: .85),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: active ? .28 : .13),
                  blurRadius: active ? 10 : 6,
                  spreadRadius: active ? 1.5 : .5,
                ),
              ],
            ),
            child: Icon(
              active ? Icons.star_rounded : Icons.location_on_rounded,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF071D26).withValues(alpha: .84),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              '$label $subtitle',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.state,
    required this.onOpen,
    required this.onChoose,
  });

  final AppState state;
  final VoidCallback onOpen;
  final VoidCallback onChoose;

  String get _buttonText {
    if (state.journeyCompleted) return '再次探索${state.activeJourney.city}';
    if (state.hasJourneyInProgress) {
      return '继续${state.activeJourney.city} Journey';
    }
    return '开始${state.activeJourney.city} Journey';
  }

  IconData get _buttonIcon {
    if (state.journeyCompleted) return Icons.replay_rounded;
    if (state.hasJourneyInProgress) return Icons.play_arrow_rounded;
    return Icons.flight_takeoff;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                icon: Icons.place_outlined,
                text: state.displayText('中国 · ${state.activeJourney.city}'),
              ),
              const Spacer(),
              TextButton.icon(
                key: const ValueKey('choose-city-journey'),
                onPressed: onChoose,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.swap_horiz_rounded, size: 14),
                label: Text(
                  state.displayText('选择城市'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            state.displayText(state.activeJourney.headline),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 19,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            state.displayText(state.activeJourney.description),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, height: 1.15),
          ),
          if (state.hasJourneyInProgress || state.journeyCompleted) ...[
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.displayText(
                      state.journeyCompleted
                          ? '旅程完成 · ${state.activeJourney.place}印章已收入护照'
                          : '上次停在「${state.beijingJourneyStepLabel}」',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${state.beijingJourneyProgressPercent}%',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: state.beijingJourneyProgress,
                minHeight: 4,
                color: PhoenixTheme.red,
                backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              ),
            ),
          ] else if (state.activeJourneyStampEarned) ...[
            const SizedBox(height: 6),
            Text(
              state.displayText('${state.activeJourney.city}印章已收藏，可以随时再次体验。'),
              maxLines: 1,
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _FeatureChip(
                  icon: Icons.headphones,
                  text: state.displayText('自动朗读'),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _FeatureChip(
                  icon: Icons.touch_app,
                  text: state.displayText('点词释义'),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _FeatureChip(
                  icon: Icons.edit_note,
                  text: state.displayText('写作任务'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: PhoenixTheme.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: Icon(_buttonIcon, size: 18),
              label: Text(
                state.displayText(_buttonText),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
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
    final state = context.watch<AppState>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8C788)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF7B1E1E),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.displayText('Discovery · 今日发现'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.displayText(state.activeJourney.discoveryTeaser),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, height: 1.05),
                ),
                const SizedBox(height: 2),
                Text(
                  state.displayText('朗读后用探索者语言理解，再继续表达。'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 9.5,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.volume_up_outlined, size: 18),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E5D2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 3),
          Text(text, style: const TextStyle(fontSize: 10)),
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
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: PhoenixTheme.red),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumMapPainter extends CustomPainter {
  const _PremiumMapPainter({required this.routeProgress, required this.pulse});

  final double routeProgress;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawStars(canvas, size);
    _drawLand(canvas, size);
    _drawRoute(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .045)
      ..strokeWidth = .8;

    for (double x = 8; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 8; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final star = Paint()..color = Colors.white.withValues(alpha: .24);
    const points = <Offset>[
      Offset(.08, .18),
      Offset(.18, .33),
      Offset(.34, .17),
      Offset(.57, .13),
      Offset(.88, .22),
      Offset(.93, .58),
      Offset(.12, .54),
      Offset(.43, .68),
      Offset(.69, .72),
    ];
    for (final point in points) {
      canvas.drawCircle(
        Offset(size.width * point.dx, size.height * point.dy),
        1.2,
        star,
      );
    }
  }

  void _drawLand(Canvas canvas, Size size) {
    final land = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D6870), Color(0xFF1A4B55)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final coast = Paint()
      ..color = const Color(0xFF89ADB0).withValues(alpha: .40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final mainland = Path()
      ..moveTo(size.width * .31, size.height * .28)
      ..cubicTo(
        size.width * .43,
        size.height * .17,
        size.width * .67,
        size.height * .16,
        size.width * .89,
        size.height * .29,
      )
      ..lineTo(size.width * .91, size.height * .47)
      ..cubicTo(
        size.width * .84,
        size.height * .49,
        size.width * .82,
        size.height * .57,
        size.width * .72,
        size.height * .58,
      )
      ..cubicTo(
        size.width * .62,
        size.height * .59,
        size.width * .58,
        size.height * .67,
        size.width * .49,
        size.height * .63,
      )
      ..cubicTo(
        size.width * .39,
        size.height * .59,
        size.width * .37,
        size.height * .45,
        size.width * .31,
        size.height * .28,
      )
      ..close();
    canvas.drawPath(mainland, land);
    canvas.drawPath(mainland, coast);

    final peninsula = Path()
      ..moveTo(size.width * .43, size.height * .56)
      ..cubicTo(
        size.width * .46,
        size.height * .61,
        size.width * .43,
        size.height * .76,
        size.width * .35,
        size.height * .79,
      )
      ..cubicTo(
        size.width * .31,
        size.height * .72,
        size.width * .35,
        size.height * .62,
        size.width * .43,
        size.height * .56,
      )
      ..close();
    canvas.drawPath(peninsula, land);
    canvas.drawPath(peninsula, coast);

    final islands = Paint()
      ..color = const Color(0xFF316B72)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .83, size.height * .56),
        width: 7,
        height: 18,
      ),
      islands,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .47, size.height * .80),
        width: 18,
        height: 6,
      ),
      islands,
    );
    canvas.drawCircle(Offset(size.width * .54, size.height * .76), 4, islands);
  }

  void _drawRoute(Canvas canvas, Size size) {
    final geometry = _FlightGeometry(size);
    final route = Path()
      ..moveTo(geometry.hanoi.dx, geometry.hanoi.dy)
      ..quadraticBezierTo(
        geometry.control.dx,
        geometry.control.dy,
        geometry.beijing.dx,
        geometry.beijing.dy,
      );

    final glow = Paint()
      ..color = const Color(0xFFFFD879).withValues(alpha: .20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, glow);

    final dashed = Paint()
      ..color = Colors.white.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    _drawDashedPath(canvas, route, dashed);

    final metrics = route.computeMetrics().toList(growable: false);
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final visible = metric.extractPath(
      0,
      metric.length * routeProgress.clamp(0.0, 1.0),
    );
    final active = Paint()
      ..color = const Color(0xFFFFD879)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(visible, active);

    final halo = Paint()
      ..color = const Color(
        0xFFFFD879,
      ).withValues(alpha: .10 + (math.sin(pulse * math.pi * 2).abs() * .10))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(visible, halo);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumMapPainter oldDelegate) {
    return oldDelegate.routeProgress != routeProgress ||
        oldDelegate.pulse != pulse;
  }
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
