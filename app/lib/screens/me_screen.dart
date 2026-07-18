import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/word_detail_sheet.dart';
import '../widgets/word_mark.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  int _section = 0;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 650;
        return Padding(
          padding: EdgeInsets.fromLTRB(14, compact ? 8 : 12, 14, 8),
          child: Column(
            children: [
              _MeHeader(state: state),
              SizedBox(height: compact ? 6 : 8),
              if (kIsWeb) ...[
                const _InstallAppStrip(),
                SizedBox(height: compact ? 5 : 7),
              ],
              _LanguageControl(state: state),
              SizedBox(height: compact ? 5 : 7),
              _MeSectionSwitch(
                state: state,
                selected: _section,
                vocabularyCount: savedEntries.length,
                memoryCount: state.memories.length,
                onSelected: (value) => setState(() => _section = value),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _section == 0
                      ? _VocabularyPanel(
                          key: const ValueKey('me-vocabulary-panel'),
                          state: state,
                          entries: savedEntries,
                          onOpen: (entry) =>
                              _openSavedWord(context, state, entry),
                        )
                      : _MemoryPanel(
                          key: const ValueKey('me-memory-panel'),
                          state: state,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MeSectionSwitch extends StatelessWidget {
  const _MeSectionSwitch({
    required this.state,
    required this.selected,
    required this.vocabularyCount,
    required this.memoryCount,
    required this.onSelected,
  });

  final AppState state;
  final int selected;
  final int vocabularyCount;
  final int memoryCount;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: PhoenixTheme.gold.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _SectionButton(
            selected: selected == 0,
            label: state.displayText('我的生词 · $vocabularyCount'),
            onTap: () => onSelected(0),
          ),
          const SizedBox(width: 3),
          _SectionButton(
            selected: selected == 1,
            label: state.displayText('回忆时间轴 · $memoryCount'),
            onTap: () => onSelected(1),
          ),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? PhoenixTheme.red : Colors.black54,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MeHeader extends StatelessWidget {
  const _MeHeader({required this.state});

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
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('我的旅程'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                state.displayText('设置、复习和回忆都在一屏内切换。'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 30),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.forum_outlined, size: 14),
          label: Text(
            state.displayText('共建'),
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _LanguageControl extends StatelessWidget {
  const _LanguageControl({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .28)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.translate_rounded,
            size: 18,
            color: PhoenixTheme.red,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              state.displayText('探索者解释语言'),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
          DropdownButton<String>(
            value: state.translationLanguage,
            underline: const SizedBox.shrink(),
            isDense: true,
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            items: const [
              DropdownMenuItem(value: '越南语', child: Text('越南语')),
              DropdownMenuItem(value: '英语', child: Text('English')),
              DropdownMenuItem(value: '中文解释', child: Text('中文')),
              DropdownMenuItem(value: '双语', child: Text('双语')),
            ],
            onChanged: (value) {
              if (value != null) state.setTranslationLanguage(value);
            },
          ),
        ],
      ),
    );
  }
}

class _InstallAppStrip extends StatelessWidget {
  const _InstallAppStrip();

  String get _instruction {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 'Safari 分享 → 添加到主屏幕',
      TargetPlatform.android => '浏览器菜单 → 安装应用',
      _ => '浏览器地址栏或菜单 → 安装应用',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1E1E), PhoenixTheme.red],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.install_mobile_rounded,
              color: Colors.white,
              size: 17,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '安装 Phoenix',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _instruction,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white70, fontSize: 9.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabularyPanel extends StatelessWidget {
  const _VocabularyPanel({
    required this.state,
    required this.entries,
    required this.onOpen,
    super.key,
  });

  final AppState state;
  final List<WordEntry> entries;
  final ValueChanged<WordEntry> onOpen;

  Future<void> _showAll(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: .82,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              dense: true,
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: WordMark(word: entry.word, size: 34),
              title: Text(
                state.displayText(entry.word),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(entry.pinyin),
              onTap: () {
                Navigator.of(sheetContext).pop();
                onOpen(entry);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const _EmptyVocabularyCard();
    final preview = entries.take(6).toList(growable: false);

    return Column(
      children: [
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2.15,
            children: preview
                .map((entry) {
                  return Material(
                    color: Colors.white.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => onOpen(entry),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: PhoenixTheme.gold.withValues(alpha: .25),
                          ),
                        ),
                        child: Row(
                          children: [
                            WordMark(word: entry.word, size: 34),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.displayText(entry.word),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    entry.pinyin,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
        if (entries.length > preview.length) ...[
          const SizedBox(height: 5),
          SizedBox(
            height: 32,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAll(context),
              icon: const Icon(Icons.view_list_rounded, size: 16),
              label: Text(
                state.displayText('查看全部 ${entries.length} 个生词'),
                style: const TextStyle(fontSize: 10.5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MemoryPanel extends StatelessWidget {
  const _MemoryPanel({required this.state, super.key});

  final AppState state;

  Future<void> _showAll(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .78,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
          itemCount: state.memories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final memory = state.memories[index];
            return ListTile(
              dense: true,
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Text('📖', style: TextStyle(fontSize: 21)),
              title: Text(memory),
              subtitle: Text(
                state.displayText('第 ${state.memories.length - index} 次北京之旅'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (state.memories.isEmpty) return const _EmptyMemoryCard();
    final preview = state.memories.take(4).toList(growable: false);

    return Column(
      children: [
        Expanded(
          child: Column(
            children: preview
                .asMap()
                .entries
                .map((entry) {
                  final index = state.memories.indexOf(entry.value);
                  return Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: PhoenixTheme.gold.withValues(alpha: .24),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('📖', style: TextStyle(fontSize: 21)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.displayText(
                                    '第 ${state.memories.length - index} 次北京之旅',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
        if (state.memories.length > preview.length) ...[
          const SizedBox(height: 5),
          SizedBox(
            height: 32,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAll(context),
              icon: const Icon(Icons.history_rounded, size: 16),
              label: Text(
                state.displayText('查看全部 ${state.memories.length} 条回忆'),
                style: const TextStyle(fontSize: 10.5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyVocabularyCard extends StatelessWidget {
  const _EmptyVocabularyCard();

  @override
  Widget build(BuildContext context) {
    return const _CompactEmptyCard(
      icon: '🔖',
      title: '还没有收藏生词',
      text: '在 Journey 点红色词语，再加入生词本。',
    );
  }
}

class _EmptyMemoryCard extends StatelessWidget {
  const _EmptyMemoryCard();

  @override
  Widget build(BuildContext context) {
    return const _CompactEmptyCard(
      icon: '🧭',
      title: '还没有旅程回忆',
      text: '完成第一段 Journey 后，感受会自动出现在这里。',
    );
  }
}

class _CompactEmptyCard extends StatelessWidget {
  const _CompactEmptyCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final String icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PhoenixTheme.gold.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .28)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
