import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../services/phoenix_vocabulary_service.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'narration_speed_stepper.dart';
import 'word_mark.dart';

const _ink = Color(0xFF2B1B0E);
const _muted = Color(0xFF68533C);
const _cream = Color(0xFFFFF4D8);
const _blue = Color(0xFFEAF3FF);
const _green = Color(0xFFEAF6E8);
const _goldLine = Color(0xFFE1B85D);

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
  final found = studyEntries.indexWhere((item) => item.word == entry.word);
  final requestedIndex = initialIndex ?? found;
  final safeIndex = requestedIndex < 0
      ? 0
      : requestedIndex.clamp(0, studyEntries.length - 1);
  final controller = narrationController ?? NarrationController();
  final appState = context.read<AppState>();

  Future<bool> speakLocally(WordEntry current) {
    return controller.speakWord(
      appState.displayText(current.word),
      languageCode: appState.isTraditional ? 'zh-TW' : 'zh-CN',
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .42),
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final size = MediaQuery.sizeOf(sheetContext);
      final sheetWidth = size.width;
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * .52),
        child: ClipRect(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: sheetWidth,
              child: _WordDetailSheet(
                narrationController: controller,
                entries: studyEntries,
                initialIndex: safeIndex,
                onSpeak: narrationController == null
                    ? () => speakLocally(entry)
                    : onSpeak,
                onSpeakEntry: narrationController == null
                    ? speakLocally
                    : onSpeakEntry,
              ),
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    if (narrationController == null) controller.dispose();
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
  late PhoenixVocabularyExample _example;
  bool _isSpeaking = false;
  bool _speechUnavailable = false;

  WordEntry get _entry => widget.entries[_index];
  bool get _isFirst => _index == 0;
  bool get _isLast => _index == widget.entries.length - 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _example = _resolveDownloadedExample(_entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_speak());
    });
  }

  PhoenixVocabularyExample _resolveDownloadedExample(WordEntry entry) {
    final state = context.read<AppState>();
    final bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);
    if (bundled != null) return bundled;

    if (entry.examples.isNotEmpty) {
      final item = entry.examples.first;
      return PhoenixVocabularyExample(
        chinese: item.chinese,
        pinyin: item.pinyin,
        native: item.nativeText(state.translationLanguage),
        english: item.english,
        usageNote: '来自 Phoenix 已审核并随旅程下载的实际应用例句。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );
    }

    final contextData = _findVocabularyContext(state, entry);
    if (contextData.chinese.isNotEmpty) {
      return PhoenixVocabularyExample(
        chinese: contextData.chinese,
        pinyin: contextData.pinyin,
        native: contextData.nativeText(state.translationLanguage),
        english: contextData.english,
        usageNote: '来自当前 Journey 已下载的真实语境。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );
    }

    return PhoenixVocabularyExample(
      chinese: '${entry.word}是本次旅程中的重点词。${entry.simpleChinese}',
      pinyin: entry.pinyin,
      native: entry.nativeDefinition(state.translationLanguage),
      english: '${entry.word}: ${entry.englishDefinition}',
      usageNote: '该说明已随旅程下载，可离线查看。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    );
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

  Future<void> _previousWord() async {
    if (_isSpeaking || _isFirst) return;
    setState(() {
      _index -= 1;
      _example = _resolveDownloadedExample(_entry);
      _speechUnavailable = false;
    });
    await _speak();
  }

  Future<void> _nextWord() async {
    if (_isSpeaking) return;
    if (_isLast) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _index += 1;
      _example = _resolveDownloadedExample(_entry);
      _speechUnavailable = false;
    });
    await _speak();
  }

  Widget _infoLine({
    required String label,
    required String text,
    required Color background,
    required Color accent,
    int maxLines = 2,
  }) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: .5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            child: Text(
              state.displayText(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PhoenixTheme.journeyMetaStyle.copyWith(
                color: accent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                shadows: const [],
              ),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              state.displayText(text),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: PhoenixTheme.journeyBodyStyle.copyWith(
                color: _ink,
                fontSize: 11.5,
                height: 1.2,
                shadows: const [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exampleLine(String label, String text) {
    final state = context.watch<AppState>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 68,
          child: Text(
            state.displayText(label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: PhoenixTheme.journeyMetaStyle.copyWith(
              color: PhoenixTheme.translation,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              shadows: const [],
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            state.displayText(text),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PhoenixTheme.journeyMetaStyle.copyWith(
              color: _ink,
              fontSize: 10.2,
              height: 1.2,
              shadows: const [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonLabel(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1, softWrap: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entry = _entry;
    final language = state.translationLanguage;
    final isSaved = state.isWordSaved(entry.word);
    final example = _example.toWordExample(nativeLanguage: language);

    return Container(
      margin: EdgeInsets.only(
        bottom: 8 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
      decoration: PhoenixTheme.journeySolidPanelDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6A3E12).withValues(alpha: .58),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE39A)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    WordMark(word: entry.word, size: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.displayText(entry.word),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PhoenixTheme.journeyWordTitleStyle.copyWith(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Text(
                      '${_index + 1} / ${widget.entries.length}',
                      style: PhoenixTheme.journeyMetaStyle.copyWith(
                        color: const Color(0xFFFFF2C9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.pinyin,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PhoenixTheme.journeyMetaStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            state.displayText(entry.partOfSpeech),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PhoenixTheme.journeyMetaStyle.copyWith(
                              color: const Color(0xFFFFE5A5),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    NarrationSpeedStepper(
                      key: const ValueKey('word-detail-speed-control'),
                      controller: widget.narrationController,
                      compact: true,
                    ),
                    const SizedBox(width: 3),
                    IconButton.filledTonal(
                      tooltip: _isSpeaking ? '正在朗读' : '重新朗读',
                      onPressed: _isSpeaking ? null : () => unawaited(_speak()),
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      icon: Icon(
                        _isSpeaking
                            ? Icons.graphic_eq
                            : Icons.volume_up_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 4,
              value: (_index + 1) / widget.entries.length,
              color: PhoenixTheme.red,
              backgroundColor: Colors.white.withValues(alpha: .34),
            ),
          ),
          const SizedBox(height: 7),
          _infoLine(
            label: '中文',
            text: entry.simpleChinese,
            background: _cream,
            accent: PhoenixTheme.red,
          ),
          const SizedBox(height: 4),
          _infoLine(
            label: 'English',
            text: entry.englishDefinition,
            background: _blue,
            accent: PhoenixTheme.translation,
          ),
          const SizedBox(height: 4),
          _infoLine(
            label: entry.nativeLabel(language),
            text: entry.nativeDefinition(language),
            background: _green,
            accent: const Color(0xFF39734A),
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PhoenixTheme.red.withValues(alpha: .45),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.displayText('已下载例句'),
                        style: PhoenixTheme.journeyMetaStyle.copyWith(
                          color: PhoenixTheme.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          shadows: const [],
                        ),
                      ),
                    ),
                    if (_example.qualityReviewed)
                      Text(
                        state.displayText('已审核'),
                        style: PhoenixTheme.journeyMetaStyle.copyWith(
                          color: const Color(0xFF39734A),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          shadows: const [],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  state.displayText(example.chinese),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: PhoenixTheme.journeyBodyStyle.copyWith(
                    color: _ink,
                    fontSize: 12,
                    height: 1.18,
                    fontWeight: FontWeight.w800,
                    shadows: const [],
                  ),
                ),
                const SizedBox(height: 3),
                _exampleLine('拼音', example.pinyin),
                const SizedBox(height: 2),
                _exampleLine(
                  entry.nativeLabel(language),
                  example.nativeText(language),
                ),
                const SizedBox(height: 2),
                _exampleLine('English', example.english),
                if (_example.usageNote.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    state.displayText('用法：${_example.usageNote}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PhoenixTheme.journeyMetaStyle.copyWith(
                      color: _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      shadows: const [],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_speechUnavailable) ...[
            const SizedBox(height: 4),
            Text(
              state.displayText('当前浏览器没有提供中文语音，请检查静音设置。'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PhoenixTheme.journeyMetaStyle.copyWith(
                color: const Color(0xFF5A1E1E),
                shadows: const [],
              ),
            ),
          ],
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('save-word-button'),
                  onPressed: () => state.toggleSavedWord(entry.word),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    foregroundColor: _ink,
                    backgroundColor: Colors.white.withValues(alpha: .78),
                    side: const BorderSide(color: _goldLine),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                    size: 16,
                  ),
                  label: _buttonLabel(
                    state.displayText(isSaved ? '已收藏' : '收藏单词'),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('previous-word-button'),
                  onPressed: _isSpeaking || _isFirst ? null : _previousWord,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    foregroundColor: _ink,
                    backgroundColor: Colors.white.withValues(alpha: .78),
                    side: const BorderSide(color: _goldLine),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: _buttonLabel(state.displayText('上一个单词')),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('next-word-button'),
                  onPressed: _isSpeaking ? null : _nextWord,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: PhoenixTheme.red,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    _isLast ? Icons.keyboard_arrow_down : Icons.arrow_forward,
                    size: 16,
                  ),
                  label: _buttonLabel(
                    state.displayText(
                      _isLast ? '完成并收起' : '下一个单词',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VocabularyContext {
  const _VocabularyContext({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;

  String nativeText(String language) {
    return switch (language) {
      '英语' => english,
      '中文解释' => chinese,
      _ => vietnamese,
    };
  }
}

_VocabularyContext _findVocabularyContext(AppState state, WordEntry entry) {
  final journeys = [
    state.activeJourney,
    ...dailyJourneyExperiences.where(
      (journey) => journey.id != state.activeJourney.id,
    ),
  ];

  for (final journey in journeys) {
    if (!journey.words.any((word) => word.word == entry.word)) continue;
    for (var index = 0; index < journey.content.sections.length; index += 1) {
      final section = journey.content.sections[index];
      if (!section.text.contains(entry.word)) continue;
      final annotation = index < journey.storyAnnotations.length
          ? journey.storyAnnotations[index]
          : null;
      return _VocabularyContext(
        chinese: section.text,
        pinyin: annotation?.pinyin ?? '',
        vietnamese: annotation?.vietnamese ?? '',
        english: annotation?.english ?? '',
      );
    }
    for (final discovery in journey.discoveries) {
      if (!discovery.text.contains(entry.word)) continue;
      return _VocabularyContext(
        chinese: discovery.text,
        pinyin: discovery.pinyin,
        vietnamese: discovery.vietnamese,
        english: discovery.english,
      );
    }
  }

  return const _VocabularyContext(
    chinese: '',
    pinyin: '',
    vietnamese: '',
    english: '',
  );
}
