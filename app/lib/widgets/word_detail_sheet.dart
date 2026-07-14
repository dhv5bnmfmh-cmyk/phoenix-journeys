import 'package:flutter/material.dart';
import '../data/journey_data.dart';
import '../theme/phoenix_theme.dart';

Future<void> showWordDetail(BuildContext context, WordEntry entry) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(entry.symbol, style: const TextStyle(fontSize: 38)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.word,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(entry.pinyin),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('中文解释', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(entry.simpleChinese),
            const SizedBox(height: 16),
            Text(
              '辅助翻译',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PhoenixTheme.translation,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              entry.translation,
              style: const TextStyle(color: PhoenixTheme.translation),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('加入生词本'),
            ),
          ],
        ),
      );
    },
  );
}
