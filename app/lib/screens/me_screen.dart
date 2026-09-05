import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_data.dart';
import '../models/journey_memory_entry.dart';
import '../services/narration_controller.dart';
import '../services/journey_memory_photo_picker.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_level_selector_button.dart';
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

  List<WordEntry> _resolveSavedEntries(AppState state) {
    final savedEntries = allDailyJourneyWords
        .where((entry) => state.savedWords.contains(entry.word))
        .toList(growable: false);
    return savedEntries;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final savedEntries = state.selectedTab == 3 && state.savedWords.isNotEmpty
        ? _resolveSavedEntries(state)
        : const <WordEntry>[];

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
              _LearningSettingsCard(state: state),
              SizedBox(height: compact ? 5 : 7),
              _MeSectionSwitch(
                state: state,
                selected: _section,
                vocabularyCount: savedEntries.length,
                memoryCount: state.journeyMemories.length,
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
            label: state.displayText('我的单词 · $vocabularyCount'),
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

class _LearningSettingsCard extends StatelessWidget {
  const _LearningSettingsCard({required this.state});

  static const _translationLanguages = <String>[
    '越南语',
    '英语',
    '中文解释',
    '双语',
  ];

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('me-learning-settings'),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 17,
                color: PhoenixTheme.red,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  state.displayText('学习设置'),
                  style: const TextStyle(
                    color: Color(0xFF35211D),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(
            height: 1,
            color: PhoenixTheme.gold.withValues(alpha: .18),
          ),
          _LearningSettingRow(
            icon: Icons.local_fire_department_rounded,
            title: state.displayText('Phoenix 中文等级'),
            subtitle: state.displayText('新的等级将在下一次进入旅程时应用'),
            trailing: const JourneyLevelSelectorButton(),
          ),
          Divider(
            height: 1,
            color: PhoenixTheme.gold.withValues(alpha: .14),
          ),
          _LearningSettingRow(
            icon: Icons.translate_rounded,
            title: state.displayText('中文字体'),
            trailing: SegmentedButton<ScriptMode>(
              key: const ValueKey('settings-script-mode'),
              segments: const [
                ButtonSegment(value: ScriptMode.simplified, label: Text('简')),
                ButtonSegment(value: ScriptMode.traditional, label: Text('繁')),
              ],
              selected: <ScriptMode>{state.scriptMode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                if (selection.single != state.scriptMode) {
                  unawaited(state.toggleScript());
                }
              },
            ),
          ),
          Divider(
            height: 1,
            color: PhoenixTheme.gold.withValues(alpha: .14),
          ),
          _LearningSettingRow(
            icon: Icons.language_rounded,
            title: state.displayText('翻译语言'),
            trailing: DropdownButton<String>(
              key: const ValueKey('settings-translation-language'),
              value: state.translationLanguage,
              underline: const SizedBox.shrink(),
              isDense: true,
              items: [
                for (final language in _translationLanguages)
                  DropdownMenuItem(
                    value: language,
                    child: Text(
                      language == '英语'
                          ? 'English'
                          : language == '中文解释'
                              ? '中文'
                              : language,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  unawaited(state.setTranslationLanguage(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningSettingRow extends StatelessWidget {
  const _LearningSettingRow({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 41),
      child: Row(
        children: [
          Icon(icon, size: 17, color: PhoenixTheme.red),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF35211D),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 9.5,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
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
                state.displayText('查看全部 ${entries.length} 个单词'),
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

  @override
  Widget build(BuildContext context) {
    if (state.journeyMemories.isEmpty) return const _EmptyMemoryCard();
    return ListView.separated(
      key: const ValueKey('journey-memory-timeline'),
      itemCount: state.journeyMemories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final entry = state.journeyMemories[index];
        return ListTile(
          key: ValueKey('journey-memory-${entry.id}'),
          tileColor: Colors.white.withValues(alpha: .94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onTap: () => showModalBottomSheet<void>(
            context: context, isScrollControlled: true, useSafeArea: true,
            builder: (_) => _MemoryDetailEditor(state: state, initial: entry),
          ),
          leading: entry.photoRefs.isEmpty ? const Text('📖', style: TextStyle(fontSize: 22)) : _MemoryThumbnail(state: state, ref: entry.photoRefs.first),
          title: Text(entry.place.isEmpty ? entry.journeyTitle : '${entry.city} · ${entry.place}', style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${entry.initialCreatedAt.toLocal().toString().split(' ').first}  ·  Lv.${entry.sessionLevel}\n${entry.note.isEmpty ? '尚未写下文字' : entry.note}\n${entry.isVisited ? '我来过这里' : '线上探索'}', maxLines: 4, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.chevron_right_rounded),
        );
      },
    );
  }
}

class _MemoryThumbnail extends StatelessWidget {
  const _MemoryThumbnail({required this.state, required this.ref});
  final AppState state;
  final String ref;
  @override Widget build(BuildContext context) => FutureBuilder<Uint8List?>(
    future: state.journeyMemoryPhoto(ref),
    builder: (_, snapshot) => snapshot.data == null ? const Icon(Icons.photo_outlined) : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(snapshot.data!, width: 48, height: 48, fit: BoxFit.cover)),
  );
}

class _MemoryDetailEditor extends StatefulWidget {
  const _MemoryDetailEditor({required this.state, required this.initial});
  final AppState state;
  final JourneyMemoryEntry initial;
  @override State<_MemoryDetailEditor> createState() => _MemoryDetailEditorState();
}

class _MemoryDetailEditorState extends State<_MemoryDetailEditor> {
  late JourneyMemoryEntry entry = widget.initial;
  late final TextEditingController note = TextEditingController(text: entry.note);
  late final TextEditingController visitNote = TextEditingController(text: entry.visitNote);
  @override void dispose() { note.dispose(); visitNote.dispose(); super.dispose(); }
  Future<void> save() async {
    entry = entry.copyWith(updatedNote: note.text.trim(), updatedAt: DateTime.now(), visitNote: visitNote.text.trim());
    await widget.state.saveJourneyMemory(entry);
    if (mounted) Navigator.pop(context);
  }
  @override Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(18, 8, 18, MediaQuery.viewInsetsOf(context).bottom + 18),
    child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('${entry.city} · ${entry.place}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      Text('${entry.journeyTitle}  ·  Lv.${entry.sessionLevel}'),
      const SizedBox(height: 8),
      const Text('当前回忆保存在此设备。', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 12),
      TextField(key: const ValueKey('memory-detail-note'), controller: note, minLines: 4, maxLines: 8, decoration: const InputDecoration(labelText: '我的回忆', border: OutlineInputBorder())),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [for (final ref in entry.photoRefs) Stack(children: [_MemoryThumbnail(state: widget.state, ref: ref), Positioned(right: 0, child: IconButton(tooltip: '删除照片', icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () async { await widget.state.deleteJourneyMemoryPhoto(entry, ref); entry = widget.state.journeyMemories.firstWhere((item) => item.id == entry.id); if (mounted) setState(() {}); }))])]),
      OutlinedButton.icon(key: const ValueKey('memory-detail-add-photo'), onPressed: () async { final bytes = await pickJourneyMemoryPhoto(); if (bytes == null) return; await widget.state.replaceJourneyMemoryPhoto(entry, bytes); entry = widget.state.journeyMemories.firstWhere((item) => item.id == entry.id); if (mounted) setState(() {}); }, icon: const Icon(Icons.add_photo_alternate_outlined), label: Text(entry.photoRefs.isEmpty ? '添加照片' : '更换照片')),
      SwitchListTile(key: const ValueKey('memory-visited-switch'), contentPadding: EdgeInsets.zero, title: const Text('我真的来到这里了'), value: entry.isVisited, onChanged: (value) => setState(() => entry = entry.copyWith(isVisited: value, visitedAt: value ? (entry.visitedAt ?? DateTime.now()) : null, clearVisitedAt: !value))),
      if (entry.isVisited) ...[
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('到访日期'), subtitle: Text((entry.visitedAt ?? DateTime.now()).toLocal().toString().split(' ').first), trailing: const Icon(Icons.calendar_today_outlined), onTap: () async { final date = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), initialDate: entry.visitedAt ?? DateTime.now()); if (date != null) setState(() => entry = entry.copyWith(visitedAt: date)); }),
        TextField(key: const ValueKey('memory-visit-note'), controller: visitNote, minLines: 2, maxLines: 5, decoration: const InputDecoration(labelText: '现场感受', border: OutlineInputBorder())),
      ],
      const SizedBox(height: 12),
      FilledButton(key: const ValueKey('memory-detail-save'), onPressed: save, child: const Text('保存修改')),
    ])),
  );
}

class _EmptyVocabularyCard extends StatelessWidget {
  const _EmptyVocabularyCard();

  @override
  Widget build(BuildContext context) {
    return const _CompactEmptyCard(
      icon: '🔖',
      title: '还没有收藏单词',
      text: '在 Journey 点红色词语，再加入单词本。',
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
