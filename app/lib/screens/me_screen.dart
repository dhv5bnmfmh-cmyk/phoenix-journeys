import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('我的旅程', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.translate),
          title: const Text('解释语言'),
          subtitle: Text(state.translationLanguage),
          trailing: DropdownButton<String>(
            value: state.translationLanguage,
            items: const [
              DropdownMenuItem(value: '越南语', child: Text('越南语')),
              DropdownMenuItem(value: '英语', child: Text('英语')),
              DropdownMenuItem(value: '中文解释', child: Text('中文')),
              DropdownMenuItem(value: '双语', child: Text('双语')),
            ],
            onChanged: (value) {
              if (value != null) {
                state.setTranslationLanguage(value);
              }
            },
          ),
        ),
        const Divider(),
        Text('回忆时间轴', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (state.memories.isEmpty)
          const Text('完成第一段旅程后，每一次感受都会自动出现在这里。')
        else
          ...state.memories.asMap().entries.map(
                (entry) => Card(
                  child: ListTile(
                    leading: const Text('📖'),
                    title: Text(entry.value),
                    subtitle: Text('第 ${state.memories.length - entry.key} 次北京之旅'),
                  ),
                ),
              ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.forum_outlined),
          label: const Text('一起打造 Phoenix'),
        ),
      ],
    );
  }
}
