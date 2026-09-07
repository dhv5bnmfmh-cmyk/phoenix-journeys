import 'dart:async';
import 'dart:convert';

import 'package:flutter/rendering.dart';

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
const _wordSpeechFallbackTimeout = Duration(seconds: 4);

int _pjWordBuildCount = 0;

void _pjWordDiag(String marker, {required String variant, String? reason}) {
  final payload = <String, Object?>{
    'marker': marker,
    'variant': variant,
    if (reason != null) 'reason': reason,
    'timestamp': DateTime.now().toUtc().toIso8601String(),
  };
  debugPrint('$marker ${jsonEncode(payload)}');
}

class _PjLayoutProbe extends SingleChildRenderObjectWidget {
  const _PjLayoutProbe({required this.variant, required super.child});

  final String variant;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _PjRenderLayoutProbe(variant);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _PjRenderLayoutProbe renderObject,
  ) {
    renderObject.variant = variant;
  }
}

class _PjRenderLayoutProbe extends RenderProxyBox {
  _PjRenderLayoutProbe(this.variant);

  String variant;
  int _layoutCount = 0;
  bool _paintLogged = false;

  @override
  void performLayout() {
    _layoutCount += 1;
    final watch = Stopwatch()..start();
    if (_layoutCount <= 8) {
      _pjWordDiag(
        'PJ_WORD_LAYOUT_BEGIN',
        variant: variant,
        reason: 'count=$_layoutCount constraints=$constraints',
      );
    }
    super.performLayout();
    watch.stop();
    if (_layoutCount <= 8) {
      _pjWordDiag(
        'PJ_WORD_LAYOUT_END',
        variant: variant,
        reason: 'count=$_layoutCount elapsedUs=${watch.elapsedMicroseconds} size=$size',
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_paintLogged) {
      _paintLogged = true;
      _pjWordDiag('PJ_WORD_FIRST_PAINT', variant: variant, reason: 'size=$size');
    }
    super.paint(context, offset);
  }
}

class _PjPostFrameProbe extends StatefulWidget {
  const _PjPostFrameProbe({
    required this.variant,
    required this.child,
    this.actualSpeech,
  });

  final String variant;
  final Widget child;
  final Future<bool> Function()? actualSpeech;

  @override
  State<_PjPostFrameProbe> createState() => _PjPostFrameProbeState();
}

class _PjPostFrameProbeState extends State<_PjPostFrameProbe> {
  @override
  void initState() {
    super.initState();
    _pjWordDiag('PJ_WORD_POST_FRAME_CALLBACK_SCHEDULED', variant: widget.variant);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pjWordDiag('PJ_WORD_POST_FRAME_CALLBACK_ENTERED', variant: widget.variant);
      final speech = widget.actualSpeech;
      if (speech == null) return;
      _pjWordDiag('PJ_WORD_DIAG_SPEAK_CALL_BEGIN', variant: widget.variant);
      final watch = Stopwatch()..start();
      unawaited(
        speech().then<void>(
          (success) {
            watch.stop();
            _pjWordDiag(
              'PJ_WORD_DIAG_SPEAK_COMPLETE',
              variant: widget.variant,
              reason: 'success=$success elapsedMs=${watch.elapsedMilliseconds}',
            );
          },
          onError: (Object error, StackTrace stackTrace) {
            watch.stop();
            _pjWordDiag(
              'PJ_WORD_DIAG_SPEAK_ERROR',
              variant: widget.variant,
              reason: 'type=${error.runtimeType} elapsedMs=${watch.elapsedMilliseconds}',
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final count = ++_pjWordBuildCount;
    final watch = Stopwatch()..start();
    _pjWordDiag(
      'PJ_WORD_DETAIL_BUILD_BEGIN',
      variant: widget.variant,
      reason: 'count=$count',
    );
    final built = _PjLayoutProbe(variant: widget.variant, child: widget.child);
    watch.stop();
    _pjWordDiag(
      'PJ_WORD_DETAIL_BUILD_END',
      variant: widget.variant,
      reason: 'count=$count elapsedUs=${watch.elapsedMicroseconds}',
    );
    return built;
  }
}

Widget _pjVariantBody(
  BuildContext context,
  String variant,
  WordEntry entry,
  NarrationController controller,
) {
  final state = context.read<AppState>();
  final word = state.displayText(entry.word);
  final meaning = state.displayText(entry.simpleChinese);

  if (variant == 'empty') {
    return const SizedBox(
      height: 96,
      child: Center(child: Text('PJ EMPTY MODAL')),
    );
  }

  if (variant == 'static') {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(word), const SizedBox(height: 6), Text(meaning)],
      ),
    );
  }

  Widget structured({
    required bool reading,
    required bool innerFitted,
    required bool controls,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8 + MediaQuery.viewInsetsOf(context).bottom),
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
                    const SizedBox(width: 30, height: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: innerFitted
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(word, maxLines: 1),
                            )
                          : Text(word, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const Text('1 / 6'),
                  ],
                ),
                if (reading) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.pinyin, maxLines: 1),
                            Text(
                              state.displayText(entry.partOfSpeech),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      if (controls) ...[
                        NarrationSpeedStepper(
                          controller: controller,
                          compact: true,
                        ),
                        IconButton.filledTonal(
                          onPressed: () {},
                          visualDensity: VisualDensity.compact,
                          iconSize: 16,
                          icon: const Icon(Icons.volume_up_outlined),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(minHeight: 4, value: 1 / 6),
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 68, child: Text('中文')),
                const SizedBox(width: 7),
                Expanded(child: Text(meaning, maxLines: 2)),
              ],
            ),
          ),
          if (reading) ...[
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.pinyin, maxLines: 2),
                  Text(entry.englishDefinition, maxLines: 2),
                  Text(entry.nativeDefinition(state.translationLanguage), maxLines: 2),
                ],
              ),
            ),
          ],
          if (controls) ...[
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('收藏单词', maxLines: 1, softWrap: false),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('下一个单词', maxLines: 1, softWrap: false),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  return switch (variant) {
    'layout' => structured(reading: false, innerFitted: false, controls: false),
    'reading' => structured(reading: true, innerFitted: false, controls: false),
    'fitted' => structured(reading: true, innerFitted: true, controls: false),
    'controls' || 'hook' || 'speech' =>
      structured(reading: true, innerFitted: true, controls: true),
    _ => const SizedBox(height: 96, child: Center(child: Text('PJ UNKNOWN'))),
  };
}

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

  final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
  _pjWordDiag('PJ_WORD_SHOW_ENTER', variant: pjVariant, reason: 'word=${entry.word}');

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .42),
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final builderWatch = Stopwatch()..start();
      _pjWordDiag('PJ_WORD_ROUTE_BUILDER_BEGIN', variant: pjVariant);
      final size = MediaQuery.sizeOf(sheetContext);
      final sheetWidth = size.width;
      final onSpeakCurrent = narrationController == null
          ? () => speakLocally(entry)
          : onSpeak;
      final onSpeakCurrentEntry = narrationController == null
          ? speakLocally
          : onSpeakEntry;
      final production = pjVariant.startsWith('production');
      final body = production
          ? _WordDetailSheet(
              narrationController: controller,
              entries: studyEntries,
              initialIndex: safeIndex,
              onSpeak: onSpeakCurrent,
              onSpeakEntry: onSpeakCurrentEntry,
            )
          : _pjVariantBody(sheetContext, pjVariant, entry, controller);
      final actualSpeech = pjVariant == 'speech'
          ? () => onSpeakCurrentEntry == null
                ? onSpeakCurrent()
                : onSpeakCurrentEntry(entry)
          : null;
      final probed = _PjPostFrameProbe(
        variant: pjVariant,
        actualSpeech: actualSpeech,
        child: body,
      );
      final sized = SizedBox(width: sheetWidth, child: probed);
      final shell = pjVariant == 'production-no-outer-fitted'
          ? ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * .52),
              child: ClipRect(child: sized),
            )
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * .52),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: sized,
                ),
              ),
            );
      builderWatch.stop();
      _pjWordDiag(
        'PJ_WORD_ROUTE_BUILDER_END',
        variant: pjVariant,
        reason: 'elapsedUs=${builderWatch.elapsedMicroseconds}',
      );
      return shell;
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
    final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
    _pjWordDiag('PJ_WORD_PROD_INIT_BEGIN', variant: pjVariant);
    _index = widget.initialIndex;
    final exampleWatch = Stopwatch()..start();
    _pjWordDiag('PJ_WORD_EXAMPLE_RESOLVE_BEGIN', variant: pjVariant);
    if (pjVariant == 'production-bypass-example') {
      final entry = _entry;
      _example = PhoenixVocabularyExample(
        chinese: '${entry.word}是本次旅程中的重点词。',
        pinyin: entry.pinyin,
        native: entry.nativeDefinition(context.read<AppState>().translationLanguage),
        english: entry.englishDefinition,
        usageNote: 'PJ diagnostic bypass',
        isOfflineFallback: true,
      );
      _pjWordDiag('PJ_WORD_EXAMPLE_BYPASSED', variant: pjVariant);
    } else {
      _example = _resolveDownloadedExample(_entry);
    }
    exampleWatch.stop();
    _pjWordDiag(
      'PJ_WORD_EXAMPLE_RESOLVE_END',
      variant: pjVariant,
      reason: 'elapsedUs=${exampleWatch.elapsedMicroseconds}',
    );
    _pjWordDiag('PJ_WORD_PROD_POST_FRAME_SCHEDULED', variant: pjVariant);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pjWordDiag('PJ_WORD_PROD_POST_FRAME_ENTERED', variant: pjVariant);
      if (mounted) unawaited(_speak());
    });
    _pjWordDiag('PJ_WORD_PROD_INIT_END', variant: pjVariant);
  }

  PhoenixVocabularyExample _resolveDownloadedExample(WordEntry entry) {
    final state = context.read<AppState>();
    final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
    PhoenixVocabularyExample? bundled;
    if (pjVariant != 'production-bypass-bundled') {
      final bundledWatch = Stopwatch()..start();
      _pjWordDiag('PJ_WORD_BUNDLED_LOOKUP_BEGIN', variant: pjVariant);
      bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);
      bundledWatch.stop();
      _pjWordDiag(
        'PJ_WORD_BUNDLED_LOOKUP_END',
        variant: pjVariant,
        reason: 'hit=${bundled != null} elapsedUs=${bundledWatch.elapsedMicroseconds}',
      );
    } else {
      _pjWordDiag('PJ_WORD_BUNDLED_LOOKUP_BYPASSED', variant: pjVariant);
    }
    if (bundled != null) return bundled;

    _pjWordDiag(
      'PJ_WORD_ENTRY_EXAMPLES_CHECK',
      variant: pjVariant,
      reason: 'count=${entry.examples.length}',
    );
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

    if (pjVariant == 'production-bypass-context') {
      _pjWordDiag('PJ_WORD_CONTEXT_LOOKUP_BYPASSED', variant: pjVariant);
      return PhoenixVocabularyExample(
        chinese: '${entry.word}是本次旅程中的重点词。${entry.simpleChinese}',
        pinyin: entry.pinyin,
        native: entry.nativeDefinition(state.translationLanguage),
        english: '${entry.word}: ${entry.englishDefinition}',
        usageNote: 'PJ diagnostic context bypass',
        isOfflineFallback: true,
      );
    }

    final contextWatch = Stopwatch()..start();
    _pjWordDiag('PJ_WORD_CONTEXT_LOOKUP_BEGIN', variant: pjVariant);
    final contextData = _findVocabularyContext(state, entry);
    contextWatch.stop();
    _pjWordDiag(
      'PJ_WORD_CONTEXT_LOOKUP_END',
      variant: pjVariant,
      reason: 'hit=${contextData.chinese.isNotEmpty} elapsedUs=${contextWatch.elapsedMicroseconds}',
    );
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
    var success = false;
    try {
      final speech = callback == null ? widget.onSpeak() : callback(_entry);
      success = await speech.timeout(
        _wordSpeechFallbackTimeout,
        onTimeout: () => false,
      );
    } catch (_) {
      success = false;
    }
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
    final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
    final pjBuildCount = ++_pjWordBuildCount;
    final pjBuildWatch = Stopwatch()..start();
    _pjWordDiag(
      'PJ_WORD_PROD_BUILD_BEGIN',
      variant: pjVariant,
      reason: 'count=$pjBuildCount',
    );
    final state = context.watch<AppState>();
    final entry = _entry;
    final language = state.translationLanguage;
    final isSaved = state.isWordSaved(entry.word);
    final example = _example.toWordExample(nativeLanguage: language);

    final pjBuilt = Container(
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
    pjBuildWatch.stop();
    _pjWordDiag(
      'PJ_WORD_PROD_BUILD_END',
      variant: pjVariant,
      reason: 'count=$pjBuildCount elapsedUs=${pjBuildWatch.elapsedMicroseconds}',
    );
    return pjBuilt;
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
  final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
  final journeys = <DailyJourneyExperience>[state.activeJourney];
  if (pjVariant == 'production-active-only') {
    _pjWordDiag(
      'PJ_WORD_ALL_JOURNEYS_BYPASSED',
      variant: pjVariant,
      reason: 'active=${state.activeJourney.id}',
    );
  } else {
    final catalogWatch = Stopwatch()..start();
    _pjWordDiag(
      'PJ_WORD_ALL_JOURNEYS_MATERIALIZE_BEGIN',
      variant: pjVariant,
      reason: 'length=${dailyJourneyExperiences.length}',
    );
    for (var index = 0; index < dailyJourneyExperiences.length; index += 1) {
      final itemWatch = Stopwatch()..start();
      final journey = dailyJourneyExperiences[index];
      itemWatch.stop();
      if (itemWatch.elapsedMilliseconds >= 20) {
        _pjWordDiag(
          'PJ_WORD_JOURNEY_MATERIALIZE_SLOW',
          variant: pjVariant,
          reason: 'index=$index id=${journey.id} elapsedUs=${itemWatch.elapsedMicroseconds}',
        );
      }
      if (journey.id != state.activeJourney.id) journeys.add(journey);
    }
    catalogWatch.stop();
    _pjWordDiag(
      'PJ_WORD_ALL_JOURNEYS_MATERIALIZE_END',
      variant: pjVariant,
      reason: 'count=${journeys.length} elapsedUs=${catalogWatch.elapsedMicroseconds}',
    );
  }

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