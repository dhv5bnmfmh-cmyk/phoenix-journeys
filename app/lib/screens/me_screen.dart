import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/word_detail_sheet.dart';
import '../widgets/word_mark.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  Future<void> _openSavedWord(
    BuildContext context,
    AppState state,
    WordEntry entry,
  ) async {
    final narration = NarrationController();
    try {
      await showWordDetail(
        context,
        entry,
        onSpeak: () => narration.speakWord(
          state.displayText(entry.word),
          languageCode: state.isTraditional ? 'zh-TW' : 'zh-CN',
        ),
      );
    } finally {
      narration.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final savedEntries = words
        .where((entry) => state.savedWords.contains(entry.word))
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        Text('我的旅程', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        if (kIsWeb) ...[
          const _InstallAppCard(),
          const SizedBox(height: 18),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.translate),
              title: const Text('解释语言'),
              subtitle: Text(state.translationLanguage),
              trailing: DropdownButton<String>(
                value: state.translationLanguage,
                underline: const SizedBox.shrink(),
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
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                '我的生词',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: PhoenixTheme.red.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '${savedEntries.length} 个',
                style: const TextStyle(
                  color: PhoenixTheme.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (savedEntries.isEmpty)
          const _EmptyVocabularyCard()
        else
          ...savedEntries.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                onTap: () => _openSavedWord(context, state, entry),
                leading: WordMark(word: entry.word, size: 44),
                title: Text(
                  entry.word,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(entry.pinyin),
                trailing: const Icon(Icons.volume_up_outlined),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text('回忆时间轴', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (state.memories.isEmpty)
          const _EmptyMemoryCard()
        else
          ...state.memories.asMap().entries.map(
                (entry) => Card(
                  child: ListTile(
                    leading: const Text('📖'),
                    title: Text(entry.value),
                    subtitle: Text(
                      '第 ${state.memories.length - entry.key} 次北京之旅',
                    ),
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

class _InstallAppCard extends StatelessWidget {
  const _InstallAppCard();

  String get _instruction {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => '在 Safari 点“分享”，再选择“添加到主屏幕”。',
      TargetPlatform.android => '打开浏览器菜单，选择“安装应用”或“添加到主屏幕”。',
      _ => '点击浏览器地址栏的安装图标，或在浏览器菜单中选择安装应用。',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1E1E), PhoenixTheme.red],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 10),
            color: Color(0x24000000),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.install_mobile, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '安装 Phoenix 到手机',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _instruction,
                  style: const TextStyle(color: Colors.white, height: 1.45),
                ),
                const SizedBox(height: 7),
                const Text(
                  '安装后可从桌面全屏打开，使用起来更像 App。',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyVocabularyCard extends StatelessWidget {
  const _EmptyVocabularyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PhoenixTheme.gold.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .28)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🔖', style: TextStyle(fontSize: 28)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '在 Journey 中长按词语，再点“加入生词本”。以后可以从这里随时复习和朗读。',
              style: TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMemoryCard extends StatelessWidget {
  const _EmptyMemoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .32)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🧭', style: TextStyle(fontSize: 28)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '完成第一段旅程后，每一次感受都会自动出现在这里。',
              style: TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
