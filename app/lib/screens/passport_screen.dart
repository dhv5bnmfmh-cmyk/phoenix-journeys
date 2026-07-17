import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/forbidden_city_stamp.dart';
import 'journey_screen.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        Text('探索护照', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        const Text(
          '每完成一段 Journey，就会在这里留下一个永久城市印章。',
          style: TextStyle(color: Colors.black54, height: 1.45),
        ),
        const SizedBox(height: 20),
        _PassportMap(state: state),
        const SizedBox(height: 20),
        _BeijingStampCard(state: state),
      ],
    );
  }
}

class _PassportMap extends StatelessWidget {
  const _PassportMap({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF173B3C), Color(0xFF285758)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            blurRadius: 22,
            offset: Offset(0, 12),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 20,
            top: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHINA PASSPORT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '中国探索地图',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Icon(
              Icons.public,
              size: 112,
              color: Colors.white.withValues(alpha: .08),
            ),
          ),
          Positioned(
            top: 82,
            right: 72,
            child: AnimatedOpacity(
              opacity: state.beijingStampEarned ? 1 : .38,
              duration: const Duration(milliseconds: 350),
              child: Column(
                children: [
                  Icon(
                    state.beijingStampEarned
                        ? Icons.location_pin
                        : Icons.lock_outline,
                    color: state.beijingStampEarned
                        ? const Color(0xFFFFD47D)
                        : Colors.white54,
                    size: 38,
                  ),
                  const Text(
                    '北京',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 16,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                state.beijingStampEarned
                    ? '已点亮 1 座城市 · 北京'
                    : state.hasJourneyInProgress
                        ? '北京探索中 · ${state.beijingJourneyProgressPercent}%'
                        : '第一枚印章正在北京等待你',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeijingStampCard extends StatelessWidget {
  const _BeijingStampCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final earned = state.beijingStampEarned;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: earned
              ? PhoenixTheme.red.withValues(alpha: .30)
              : PhoenixTheme.gold.withValues(alpha: .32),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForbiddenCityStamp(size: 118, isUnlocked: earned),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '北京 · 紫禁城',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      earned
                          ? '印章已永久收入护照。重新体验北京也不会消失。'
                          : state.hasJourneyInProgress
                              ? '你已到达「${state.beijingJourneyStepLabel}」，结束旅程后正式盖章。'
                              : '完成故事、生词、发现、思考、表达与回忆后获得。',
                      style: const TextStyle(color: Colors.black54, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: earned
                            ? PhoenixTheme.red.withValues(alpha: .08)
                            : PhoenixTheme.gold.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        earned
                            ? '已获得'
                            : state.hasJourneyInProgress
                                ? '探索中 ${state.beijingJourneyProgressPercent}%'
                                : '尚未获得',
                        style: TextStyle(
                          color: earned ? PhoenixTheme.red : Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!earned) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const JourneyScreen()),
                  );
                },
                icon: Icon(
                  state.hasJourneyInProgress
                      ? Icons.play_arrow_rounded
                      : Icons.flight_takeoff,
                ),
                label: Text(
                  state.hasJourneyInProgress ? '继续北京 Journey' : '开始北京 Journey',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
