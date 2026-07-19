import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/forbidden_city_stamp.dart';
import '../widgets/journey_share_button.dart';
import 'journey_screen.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 650;
        return Padding(
          padding: EdgeInsets.fromLTRB(14, compact ? 8 : 12, 14, 8),
          child: Column(
            children: [
              _PassportHeader(state: state),
              SizedBox(height: compact ? 6 : 9),
              Expanded(
                flex: compact ? 5 : 6,
                child: _PassportMap(state: state),
              ),
              SizedBox(height: compact ? 6 : 9),
              Expanded(
                flex: compact ? 5 : 4,
                child: _BeijingStampCard(state: state, compact: compact),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PassportHeader extends StatelessWidget {
  const _PassportHeader({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: PhoenixTheme.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('探索护照'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                state.displayText('完成 Journey，永久收藏城市印章。'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            state.beijingStampEarned ? '1 枚' : '0 枚',
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _PassportMap extends StatelessWidget {
  const _PassportMap({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final status = state.beijingStampEarned
        ? '已点亮 1 座城市 · 北京'
        : state.hasJourneyInProgress
        ? '北京探索中 · ${state.beijingJourneyProgressPercent}%'
        : '第一枚印章正在北京等待你';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12353A), Color(0xFF285E61), Color(0xFF143B40)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 7),
            color: Color(0x1D000000),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final markerTop = (height * .34).clamp(52.0, 92.0);
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _PassportGridPainter()),
              ),
              Positioned(
                left: 13,
                top: 10,
                right: 13,
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHINA PASSPORT',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '中国探索地图',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.public_rounded,
                      size: 27,
                      color: Colors.white.withValues(alpha: .35),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: markerTop,
                right: constraints.maxWidth * .22,
                child: AnimatedOpacity(
                  opacity: state.beijingStampEarned ? 1 : .42,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF102E33),
                          border: Border.all(
                            color: state.beijingStampEarned
                                ? const Color(0xFFFFD879)
                                : Colors.white38,
                            width: 2,
                          ),
                          boxShadow: state.beijingStampEarned
                              ? const [
                                  BoxShadow(
                                    color: Color(0x66FFD879),
                                    blurRadius: 14,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          state.beijingStampEarned
                              ? Icons.star_rounded
                              : state.hasJourneyInProgress
                              ? Icons.flight_rounded
                              : Icons.lock_outline_rounded,
                          color: state.beijingStampEarned
                              ? const Color(0xFFFFD879)
                              : Colors.white70,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '北京 PEK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
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
                    color: const Color(0xFF071D26).withValues(alpha: .68),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD879),
                        ),
                      ),
                      const SizedBox(width: 6),
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BeijingStampCard extends StatelessWidget {
  const _BeijingStampCard({required this.state, required this.compact});

  final AppState state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final earned = state.beijingStampEarned;
    final description = earned
        ? '印章已永久收入护照，重新体验也不会消失。'
        : state.hasJourneyInProgress
        ? '已到达「${state.beijingJourneyStepLabel}」，完成旅程后盖章。'
        : '完成故事、生词、发现、思考、表达与回忆后获得。';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: earned
              ? PhoenixTheme.red.withValues(alpha: .30)
              : PhoenixTheme.gold.withValues(alpha: .34),
        ),
      ),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: ForbiddenCityStamp(
              size: compact ? 82 : 96,
              isUnlocked: earned,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.displayText('北京 · 紫禁城'),
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: earned
                            ? PhoenixTheme.red.withValues(alpha: .08)
                            : PhoenixTheme.gold.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        earned
                            ? '已获得'
                            : state.hasJourneyInProgress
                            ? '${state.beijingJourneyProgressPercent}%'
                            : '未获得',
                        style: TextStyle(
                          color: earned ? PhoenixTheme.red : Colors.black54,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  state.displayText(description),
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10.5,
                    height: 1.25,
                  ),
                ),
                if (earned) ...[
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: JourneyShareButton(
                      isTraditional: state.isTraditional,
                      compact: true,
                      label: state.displayText('分享北京印章'),
                    ),
                  ),
                ],
                if (!earned) ...[
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JourneyScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhoenixTheme.red,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        state.hasJourneyInProgress
                            ? Icons.play_arrow_rounded
                            : Icons.flight_takeoff_rounded,
                        size: 17,
                      ),
                      label: Text(
                        state.displayText(
                          state.hasJourneyInProgress
                              ? '继续北京 Journey'
                              : '开始北京 Journey',
                        ),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PassportGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .045)
      ..strokeWidth = .8;
    for (double x = 8; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 8; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final land = Paint()
      ..color = const Color(0xFF4D7A79).withValues(alpha: .48)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width * .22, size.height * .38)
      ..cubicTo(
        size.width * .42,
        size.height * .18,
        size.width * .79,
        size.height * .22,
        size.width * .88,
        size.height * .42,
      )
      ..cubicTo(
        size.width * .79,
        size.height * .58,
        size.width * .57,
        size.height * .60,
        size.width * .44,
        size.height * .73,
      )
      ..cubicTo(
        size.width * .31,
        size.height * .68,
        size.width * .29,
        size.height * .50,
        size.width * .22,
        size.height * .38,
      )
      ..close();
    canvas.drawPath(path, land);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
