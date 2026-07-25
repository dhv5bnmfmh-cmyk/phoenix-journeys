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

const _popupInk = Color(0xFF2B1B0E);
const _popupMuted = Color(0xFF68533C);
const _popupCream = Color(0xFFFFF4D8);
const _popupBlue = Color(0xFFEAF3FF);
const _popupGreen = Color(0xFFEAF6E8);
const _popupGoldLine = Color(0xFFE1B85D);

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
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .42),
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => FractionallySizedBox(
      heightFactor: .62,
      child: _WordDetailSheet(
        narrationController: speedController,
        entries: studyEntries,
        initialIndex: safeIndex,
        onSpeak: effectiveOnSpeak,
        onSpeakEntry: effectiveOnSpeakEntry,
      ),
    ),
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
      final curated = entry.examples.first;
      return PhoenixVocabularyExample(
        chinese: curated.chinese,
        pinyin: curated.pinyin,
        native: curated.nativeText(state.translationLanguage),
        english: curated.english,
        usageNote: '来自 Phoenix 已审核并随旅程下载的实际应用例句。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );
    }

    final contextData = _findVocabularyContext(state, entry);
    if (contextData.chinese.trim().isNotEmpty) {
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
      _speechUnavailable = false;
      _example = _resolveDownloadedExample(_entry);
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
      _speechUnavailable = false;
      _example = _resolveDownloadedExample(_entry);
    });
    await _speak();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entry = _entry;
    final isSaved = state.isWordSaved(entry.word);
    final language = state.translationLanguage;
    final example = _example.toWordExample(nativeLanguage: language);

    return Container(
      margin: EdgeInsets.only(
        bottom: 8 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: PhoenixTheme.journeySolidPanelDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _Header(
            entry: entry,
            currentIndex: _index,
            total: widget.entries.length,
            isSpeaking: _isSpeaking,
            narrationController: widget.narrationController,
            onSpeak: _speak,
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 4,
              value: (_index + 1) / widget.entries.length,
              color: PhoenixTheme.red,
              backgroundColor: Colors.white.withValues(alpha: .34),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _DefinitionRow(
                    label: '中文',
                    text: entry.simpleChinese,
                    background: _popupCream,
                    accent: PhoenixTheme.red,
                  ),
                  const SizedBox(height: 5),
                  _DefinitionRow(
                    label: 'English',
                    text: entry.englishDefinition,
                    background: _popupBlue,
                    accent: PhoenixTheme.translation,
                  ),
                  const SizedBox(height: 5),
                  _DefinitionRow(
                    label: entry.nativeLabel(language),
                    text: entry.nativeDefinition(language),
                    background: _popupGreen,
                    accent: const Color(0xFF39734A),
                  ),
                  const SizedBox(height: 8),
                  _DownloadedExampleCard(
                    example: example,
                    nativeLabel: entry.nativeLabel(language),
                    nativeText: example.nativeText(language),
                    usageNote: _example.usageNote,
                    qualityReviewed: _example.qualityReviewed,
                  ),
                  if (_speechUnavailable) ...[
                    const SizedBox(height: 6),
                    Text(
                      state.displayText('当前浏览器没有提供中文语音，请检查静音设置。'),
                      style: PhoenixTheme.journeyMetaStyle.copyWith(
                        color: const Color(0xFF5A1E1E),
                        shadows: const [],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('save-word-button'),
                  onPressed: () => state.toggleSavedWord(entry.word),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    foregroundColor: _popupInk,
                    backgroundColor: Colors.white.withValues(alpha: .78),
                    side: const BorderSide(color: _popupGoldLine),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                    size: 16,
                  ),
                  label: Text(
                    state.displayText(isSaved ? '已收藏' : '收藏单词'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('previous-word-button'),
                  onPressed: _isSpeaking || _isFirst ? null : _previousWord,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    foregroundColor: _popupInk,
                    backgroundColor: Colors.white.withValues(alpha: .78),
                    side: const BorderSide(color: _popupGoldLine),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: Text(
                    state.displayText('上一个'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 6),
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
                  label: Text(
                    state.displayText(_isLast ? '完成' : '下一个'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _Header extends StatelessWidget {
  const _Header({
    required this.entry,
    required this.currentIndex,
    required this.total,
    required this.isSpeaking,
    required this.narrationController,
    required this.onSpeak,
  });

  final WordEntry entry;
  final int currentIndex;
  final int total;
  final bool isSpeaking;
  final NarrationController narrationController;
  final Future<void> Function() onSpeak;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 7),
      decoration: BoxDecoration(
        color: const Color(0xFF6A3E12).withValues(alpha: .58),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE39A)),
      ),
      child: Column(
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
                '${currentIndex + 1} / $total',
                style: PhoenixTheme.journeyMetaStyle.copyWith(
                  color: const Color(0xFFFFF2C9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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
                controller: narrationController,
                compact: true,
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: isSpeaking ? '正在朗读' : '重新朗读',
                onPressed: isSpeaking ? null : () => unawaited(onSpeak()),
                visualDensity: VisualDensity.compact,
                iconSize: 17,
                icon: Icon(
                  isSpeaking ? Icons.graphic_eq : Icons.volume_up_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefinitionRow extends StatelessWidget {
  const _DefinitionRow({
    required this.label,
    required this.text,
    required this.background,
    required this.accent,
  });

  final String label;
  final String text;
  final Color background;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              style: PhoenixTheme.journeyBodyStyle.copyWith(
                color: _popupInk,
                fontSize: 11.5,
                height: 1.25,
                shadows: const [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadedExampleCard extends StatelessWidget {
  const _DownloadedExampleCard({
    required this.example,
    required this.nativeLabel,
    required this.nativeText,
    required this.usageNote,
    required this.qualityReviewed,
  });

  final WordExample example;
  final String nativeLabel;
  final String nativeText;
  final String usageNote;
  final bool qualityReviewed;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .45)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
              if (qualityReviewed)
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
          const SizedBox(height: 4),
          Text(
            state.displayText(example.chinese),
            style: PhoenixTheme.journeyBodyStyle.copyWith(
              color: _popupInk,
              fontSize: 12.5,
              height: 1.25,
              fontWeight: FontWeight.w800,
              shadows: const [],
            ),
          ),
          const SizedBox(height: 5),
          _ExampleLine(label: '拼音', text: example.pinyin),
          const SizedBox(height: 3),
          _ExampleLine(label: nativeLabel, text: nativeText),
          const SizedBox(height: 3),
          _ExampleLine(label: 'English', text: example.english),
          if (usageNote.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              state.displayText('用法：$usageNote'),
              style: PhoenixTheme.journeyMetaStyle.copyWith(
                color: _popupMuted,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                shadows: const [],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExampleLine extends StatelessWidget {
  const _ExampleLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 68,
          child: Text(
            state.displayText(label),
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
            style: PhoenixTheme.journeyMetaStyle.copyWith(
              color: _popupInk,
              fontSize: 10.5,
              height: 1.25,
              shadows: const [],
            ),
          ),
        ),
      ],
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
