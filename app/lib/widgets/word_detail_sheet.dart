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
    barrierColor: Colors.black26,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final size = MediaQuery.sizeOf(sheetContext);
      final sheetWidth = (size.width - 20).clamp(0.0, 560.0).toDouble();
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * .52),
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
  final PhoenixVocabularyService _vocabularyService =
      PhoenixVocabularyService();
  PhoenixVocabularyExample? _generatedExample;
  bool _isSpeaking = false;
  bool _speechUnavailable = false;
  bool _exampleLoading = false;
  int _exampleRequest = 0;

  WordEntry get _entry => widget.entries[_index];
  bool get _isFirst => _index == 0;
  bool get _isLast => _index == widget.entries.length - 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_speak());
      unawaited(_loadExample());
    });
  }

  @override
  void dispose() {
    _exampleRequest += 1;
    _vocabularyService.close();
    super.dispose();
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

  Future<void> _loadExample() async {
    final request = ++_exampleRequest;
    final entry = _entry;
    final state = context.read<AppState>();
    final contextData = _findVocabularyContext(state, entry);
    final curated = entry.examples.isEmpty ? null : entry.examples.first;
    final fallback = curated == null
        ? contextData.toFallback(language: state.translationLanguage)
        : PhoenixVocabularyExample(
            chinese: curated.chinese,
            pinyin: curated.pinyin,
            native: curated.nativeText(state.translationLanguage),
            english: curated.english,
            usageNote: '来自 Phoenix 已审核词库的实际应用例句。',
            isOfflineFallback: true,
          );

    setState(() {
      _exampleLoading = true;
      _generatedExample = null;
    });

    final result = await _vocabularyService.generateExample(
      entry: entry,
      language: state.translationLanguage,
      journeyId: contextData.journeyId,
      contextChinese: contextData.chinese,
      contextPinyin: contextData.pinyin,
      contextNative: contextData.nativeText(state.translationLanguage),
      contextEnglish: contextData.english,
      fallback: fallback,
    );
    if (!mounted || request != _exampleRequest || entry.word != _entry.word) {
      return;
    }
    setState(() {
      _generatedExample = result;
      _exampleLoading = false;
    });
  }

  Future<void> _previousWord() async {
    if (_isSpeaking || _isFirst) return;

    setState(() {
      _index -= 1;
      _speechUnavailable = false;
      _generatedExample = null;
    });
    unawaited(_loadExample());
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
      _generatedExample = null;
    });
    unawaited(_loadExample());
    await _speak();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entry = _entry;
    final isSaved = state.isWordSaved(entry.word);
    final language = state.translationLanguage;
    final generated = _generatedExample;
    final example = generated?.toWordExample(nativeLanguage: language);
    final compact = MediaQuery.sizeOf(context).height < 780;

    return Container(
      margin: EdgeInsets.fromLTRB(
        10,
        0,
        10,
        10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xB3120E0C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .38)),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: Colors.white,
          fontFamily: PhoenixTheme.chineseFontFamily,
          fontFamilyFallback: PhoenixTheme.chineseFontFallback,
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
                                color: Colors.white,
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
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          state.displayText(entry.partOfSpeech),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  NarrationSpeedStepper(
                    key: const ValueKey('word-detail-speed-control'),
                    controller: widget.narrationController,
                    compact: true,
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
                isLoading: _exampleLoading,
                isOfflineFallback: generated?.isOfflineFallback ?? false,
                qualityReviewed: generated?.qualityReviewed ?? false,
                usageNote: generated?.usageNote ?? '',
                onRetry: _loadExample,
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
                      key: const ValueKey('save-word-button'),
                      onPressed: () => state.toggleSavedWord(entry.word),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 16,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText(isSaved ? '已收藏' : '收藏单词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 10.5),
                        ),
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
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText('上一个单词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 10.5),
                        ),
                      ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: Icon(
                        _isLast
                            ? Icons.keyboard_arrow_down
                            : Icons.arrow_forward,
                        size: 16,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText(_isLast ? '完成并收起' : '下一个单词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
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
      ),
    );
  }
}

class _VocabularyContext {
  const _VocabularyContext({
    required this.journeyId,
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String journeyId;
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

  PhoenixVocabularyExample toFallback({required String language}) {
    return PhoenixVocabularyExample(
      chinese: chinese,
      pinyin: pinyin,
      native: nativeText(language),
      english: english,
      usageNote: chinese.isEmpty
          ? 'AI 暂时无法查询这个词的实际用法，请稍后重试。'
          : '来自当前旅程的真实语境；联网后会自动查询新的实际应用例句。',
      isOfflineFallback: true,
    );
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
        journeyId: journey.id,
        chinese: section.text,
        pinyin: annotation?.pinyin ?? '',
        vietnamese: annotation?.vietnamese ?? '',
        english: annotation?.english ?? '',
      );
    }
    for (final discovery in journey.discoveries) {
      if (!discovery.text.contains(entry.word)) continue;
      return _VocabularyContext(
        journeyId: journey.id,
        chinese: discovery.text,
        pinyin: discovery.pinyin,
        vietnamese: discovery.vietnamese,
        english: discovery.english,
      );
    }
  }

  return _VocabularyContext(
    journeyId: state.activeJourney.id,
    chinese: '',
    pinyin: '',
    vietnamese: '',
    english: '',
  );
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
    required this.isLoading,
    required this.isOfflineFallback,
    required this.qualityReviewed,
    required this.usageNote,
    required this.onRetry,
  });

  final WordExample? example;
  final String nativeLabel;
  final String nativeText;
  final bool compact;
  final bool isLoading;
  final bool isOfflineFallback;
  final bool qualityReviewed;
  final String usageNote;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 6 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .24)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 58,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('AI 正在查询实际用法…', style: TextStyle(fontSize: 10.5)),
                  ],
                ),
              ),
            )
          : example == null || example!.chinese.trim().isEmpty
          ? Row(
              children: [
                const Expanded(
                  child: Text(
                    'AI 暂时无法查询实际例句，请稍后重试。',
                    style: TextStyle(color: Colors.black54, fontSize: 10.5),
                  ),
                ),
                TextButton(
                  onPressed: () => unawaited(onRetry()),
                  child: const Text('重试'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      isOfflineFallback ? '旅程真实语境' : 'AI 实际用法',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    if (!isOfflineFallback)
                      Text(
                        qualityReviewed ? 'AI 已复核' : 'AI 生成',
                        style: const TextStyle(
                          color: PhoenixTheme.ai,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
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
                if (usageNote.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    state.displayText('用法：$usageNote'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 8.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
