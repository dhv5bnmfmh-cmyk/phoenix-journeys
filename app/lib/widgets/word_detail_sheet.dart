import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'word_mark.dart';

Future<void> showWordDetail(
  BuildContext context,
  WordEntry entry, {
  NarrationController? narrationController,
  required Future<bool> Function() onSpeak,
  List<WordEntry>? entries,
  int? initialIndex,
  Future<bool> Function(WordEntry entry)? onSpeakEntry,
}) {
  final studyEntries = entries == null || entries.isEmpty
      ? <WordEntry>[entry]
      : List<WordEntry>.unmodifiable(entries);
  final matchingIndex = studyEntries.indexWhere(
    (candidate) => candidate.word == entry.word,
  );
  final requestedIndex = initialIndex ?? matchingIndex;
  final safeIndex = requestedIndex < 0
      ? 0
      : requestedIndex.clamp(0, studyEntries.length - 1);
  final speedController = narrationController ?? NarrationController();
  final appState = context.read<AppState>();

  Future<bool> speakWithController(WordEntry currentEntry) {
    return speedController.speakWord(
      appState.displayText(currentEntry.word),
      languageCode: appState.isTraditional ? 'zh-TW' : 'zh-CN',
    );
  }

  final effectiveOnSpeak = narrationController == null
      ? () => speakWithController(entry)
      : onSpeak;
  final effectiveOnSpeakEntry = narrationController == null
      ? speakWithController
      : onSpeakEntry;

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final size = MediaQuery.sizeOf(sheetContext);
      final sheetWidth = (size.width - 20).clamp(0.0, 560.0).toDouble();
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * .48),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: sheetWidth,
            child: _WordDetailSheet(
              narrationController: speedController,
              entries: studyEntries,
              initialIndex: safeIndex,
              onSpeak: effectiveOnSpeak,
              onSpeakEntry: effectiveOnSpeakEntry,
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    if (narrationController == null) speedController.dispose();
  });
}

class _WordDetailSheet extends StatefulWidget {
  const _WordDetailSheet({
    required this.narrationController,
    required this.entries,
    required this.initialIndex,
    required this.onSpeak,
    required this.onSpeakEntry,
  });

  final NarrationController narrationController;
  final List<WordEntry> entries;
  final int initialIndex;
  final Future<bool> Function() onSpeak;
  final Future<bool> Function(WordEntry entry)? onSpeakEntry;

  @override
  State<_WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<_WordDetailSheet> {
  late int _index;
  bool _isSpeaking = false;
  bool _speechUnavailable = false;

  WordEntry get _entry => widget.entries[_index];
  bool get _isLast => _index == widget.entries.length - 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_speak());
    });
  }

  Future<void> _speak() async {
    if (_isSpeaking) return;
    setState(() {
      _isSpeaking = true;
      _speechUnavailable = false;
    });

    final callback = widget.onSpeakEntry;
    final success = callback == null
        ? await widget.onSpeak()
        : await callback(_entry);
    if (!mounted) return;
    setState(() {
      _isSpeaking = false;
      _speechUnavailable = !success;
    });
  }

  Future<void> _nextWord() async {
    if (_isSpeaking) return;
    if (_isLast) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _index += 1;
      _speechUnavailable = false;
    });
    await _speak();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entry = _entry;
    final isSaved = state.isWordSaved(entry.word);
    final language = state.translationLanguage;
    final example = entry.studyExamples.isEmpty
        ? null
        : entry.studyExamples.first;
    final compact = MediaQuery.sizeOf(context).height < 780;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        0,
        10,
        10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  WordMark(word: entry.word, size: compact ? 28 : 31),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.displayText(entry.word),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: compact ? 16 : 17.5,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '${_index + 1} / ${widget.entries.length}',
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.pinyin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          state.displayText(entry.partOfSpeech),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedBuilder(
                    animation: widget.narrationController,
                    builder: (context, _) => PopupMenuButton<double>(
                      key: const ValueKey('word-detail-speed-control'),
                      tooltip: '调整朗读语速',
                      onSelected: (rate) => unawaited(
                        widget.narrationController.setSpeechRate(rate),
                      ),
                      itemBuilder: (context) => NarrationController.speedOptions
                          .map(
                            (option) => PopupMenuItem<double>(
                              value: option.rate,
                              child: Text('${option.label} 语速'),
                            ),
                          )
                          .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.red.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          widget.narrationController.speedLabel,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filledTonal(
                    tooltip: _isSpeaking ? '正在朗读' : '重新朗读',
                    onPressed: _isSpeaking ? null : _speak,
                    visualDensity: VisualDensity.compact,
                    iconSize: 16,
                    icon: Icon(
                      _isSpeaking ? Icons.graphic_eq : Icons.volume_up_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  value: (_index + 1) / widget.entries.length,
                  color: PhoenixTheme.red,
                  backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
                ),
              ),
              const SizedBox(height: 7),
              _CompactDefinitionLine(
                label: '中文',
                text: entry.simpleChinese,
                color: PhoenixTheme.ink,
              ),
              const SizedBox(height: 4),
              _CompactDefinitionLine(
                label: 'English',
                text: entry.englishDefinition,
                color: PhoenixTheme.ai,
              ),
              const SizedBox(height: 4),
              _CompactDefinitionLine(
                label: entry.nativeLabel(language),
                text: entry.nativeDefinition(language),
                color: PhoenixTheme.translation,
              ),
              const SizedBox(height: 7),
              _CoreExampleCard(
                example: example,
                nativeLabel: entry.nativeLabel(language),
                nativeText: example?.nativeText(language) ?? '',
                compact: compact,
              ),
              if (_speechUnavailable) ...[
                const SizedBox(height: 4),
                Text(
                  state.displayText('当前浏览器没有提供中文语音，请检查静音设置。'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 9.5),
                ),
              ],
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => state.toggleSavedWord(entry.word),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 17,
                      ),
                      label: Text(
                        state.displayText(isSaved ? '已收藏' : '收藏生词'),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      key: const ValueKey('next-word-button'),
                      onPressed: _isSpeaking ? null : _nextWord,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: PhoenixTheme.red,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(
                        _isLast
                            ? Icons.keyboard_arrow_down
                            : Icons.arrow_forward,
                        size: 18,
                      ),
                      label: Text(
                        state.displayText(_isLast ? '完成并收起' : '下一个单词'),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactDefinitionLine extends StatelessWidget {
  const _CompactDefinitionLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .065),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(
              state.displayText(label),
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              state.displayText(text),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.2, height: 1.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoreExampleCard extends StatelessWidget {
  const _CoreExampleCard({
    required this.example,
    required this.nativeLabel,
    required this.nativeText,
    required this.compact,
  });

  final WordExample? example;
  final String nativeLabel;
  final String nativeText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (example == null) {
      return const Center(
        child: Text('暂无例句', style: TextStyle(color: Colors.black45)),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 6 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '核心例句',
            style: TextStyle(
              color: PhoenixTheme.red,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            state.displayText(example!.chinese),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              height: 1.18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          _CompactExampleLine(label: '拼音', text: example!.pinyin),
          const SizedBox(height: 2),
          _CompactExampleLine(label: nativeLabel, text: nativeText),
          const SizedBox(height: 2),
          _CompactExampleLine(label: 'English', text: example!.english),
        ],
      ),
    );
  }
}

class _CompactExampleLine extends StatelessWidget {
  const _CompactExampleLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Text(
            state.displayText(label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Text(
            state.displayText(text),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9.8, height: 1.15),
          ),
        ),
      ],
    );
  }
}
