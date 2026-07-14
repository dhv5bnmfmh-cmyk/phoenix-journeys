import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class PassportScreen extends StatelessWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('探索护照', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: PhoenixTheme.gold),
          ),
          child: Stack(
            children: [
              const Center(
                child: Text(
                  '中国探索地图\n（下一步替换为原创矢量地图）',
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 58,
                right: 84,
                child: AnimatedOpacity(
                  opacity: state.journeyCompleted ? 1 : .25,
                  duration: const Duration(milliseconds: 400),
                  child: const Column(
                    children: [
                      Icon(Icons.location_pin, color: PhoenixTheme.red, size: 34),
                      Text('北京'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: Text(
              state.journeyCompleted ? '🏯' : '🔒',
              style: const TextStyle(fontSize: 34),
            ),
            title: const Text('紫禁城艺术印章'),
            subtitle: Text(state.journeyCompleted ? '已获得' : '完成旅程后获得'),
          ),
        ),
      ],
    );
  }
}
