import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';
import 'five_fourth_journeys_screen.dart';
import 'five_more_journeys_screen.dart';
import 'five_new_journeys_screen.dart';
import 'journey_expedition_screen.dart';

class JourneyPassportScreen extends StatelessWidget {
  const JourneyPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const batches = <_JourneyBatch>[
      _JourneyBatch(
        title: '五城远征',
        subtitle: '海防、苏州、西安等首批城市旅程',
        count: 5,
        icon: Icons.explore_rounded,
        colors: [Color(0xFF7A1F1F), Color(0xFFC95B3B)],
        screen: JourneyExpeditionScreen(),
      ),
      _JourneyBatch(
        title: '山河新章',
        subtitle: '泉州、景德镇、敦煌、桂林、拉萨',
        count: 5,
        icon: Icons.landscape_rounded,
        colors: [Color(0xFF176B5B), Color(0xFF49A078)],
        screen: FiveMoreJourneysScreen(),
      ),
      _JourneyBatch(
        title: '古城新旅',
        subtitle: '第三批五座城市文化旅程',
        count: 5,
        icon: Icons.account_balance_rounded,
        colors: [Color(0xFF315A8A), Color(0xFF6D8FC0)],
        screen: FiveNewJourneysScreen(),
      ),
      _JourneyBatch(
        title: '华夏行记',
        subtitle: '第四批五座城市探索旅程',
        count: 5,
        icon: Icons.map_rounded,
        colors: [Color(0xFF76542E), Color(0xFFB68A55)],
        screen: FiveFourthJourneysScreen(),
      ),
    ];

    final total = batches.fold<int>(0, (sum, item) => sum + item.count);

    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('Phoenix · 旅程护照'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5E1717), Color(0xFFB74A31)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '旅程护照',
                  style: TextStyle(
                    color: Color(0xFFFFD879),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '所有新旅程，统一在这里出发',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '当前已同步 $total 个旅程 · 共 ${batches.length} 组',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .86),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final batch in batches) ...[
            _BatchCard(batch: batch),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({required this.batch});

  final _JourneyBatch batch;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => batch.screen),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: batch.colors),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(batch.icon, color: Colors.white, size: 31),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      batch.subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${batch.count} 个旅程',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyBatch {
  const _JourneyBatch({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.colors,
    required this.screen,
  });

  final String title;
  final String subtitle;
  final int count;
  final IconData icon;
  final List<Color> colors;
  final Widget screen;
}
