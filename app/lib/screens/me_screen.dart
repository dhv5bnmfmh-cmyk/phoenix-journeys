import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/compact_pager.dart';
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

    return DefaultTabController(
      length: 2,
      child: LayoutBuilder(
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
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: PhoenixTheme.gold.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: PhoenixTheme.red,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                    tabs: [
                      Tab(
                        text: state.displayText(
                          '我的生词 · ${savedEntries.length}',
                        ),
                      ),
                      Tab(
                        text: state.displayText(
                          '回忆时间轴 · ${state.memories.length}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Expanded(
                  child: TabBarView(
                    children: [
                      _VocabularyPanel(
                        state: state,
                        entries: savedEntries,
                        onOpen: (entry) =>
                            _openSavedWord(context, state, entry),
                      ),
                      _MemoryPanel(state: state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
  });

  final AppState state;
  final List<WordEntry> entries;
  final ValueChanged<WordEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const _EmptyVocabularyCard();
    final chunks = compactChunks(entries, 6);

    return CompactPager(
      semanticLabel: state.displayText('生词分页'),
      pages: chunks
          .map((pageEntries) {
            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 2),
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 2.15,
              children: pageEntries
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
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            );
          })
          .toList(growable: false),
    );
  }
}

class _MemoryPanel extends StatelessWidget {
  const _MemoryPanel({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    if (state.memories.isEmpty) return const _EmptyMemoryCard();
    final chunks = compactChunks(state.memories, 4);

    return CompactPager(
      semanticLabel: state.displayText('回忆分页'),
      pages: chunks
          .map((memories) {
            return Column(
              children: memories
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
            );
          })
          .toList(growable: false),
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
