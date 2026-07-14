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

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF4E6D3), PhoenixTheme.paper],
              ),
            ),
          ),
        ),
        Positioned(
          top: 18,
          right: 18,
          child: OutlinedButton(
            onPressed: state.toggleScript,
            child: Text(
              state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.fromLTRB(24, 84, 24, 32),
          children: [
            Text('欢迎，Explorer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '世界很大，从一门语言开始。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .5)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    color: Color(0x22000000),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🇨🇳  中国 · 北京'),
                  const SizedBox(height: 14),
                  Text(
                    '第一次走进紫禁城',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text('故事、语言、历史与一段属于你的回忆'),
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
                      icon: const Icon(Icons.temple_buddhist_outlined),
                      label: const Text('开启故宫之门'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JourneyScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
