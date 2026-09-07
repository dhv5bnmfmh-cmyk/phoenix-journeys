from pathlib import Path

journey_path = Path('app/lib/screens/journey_screen.dart')
word_path = Path('app/lib/widgets/word_detail_sheet.dart')

journey = journey_path.read_text()
word = word_path.read_text()

# Mandatory no-auto-open control. Diagnostic query only; default behavior unchanged.
old = """    _pjDiagnostic('PJ_FIRST_WORD_OPEN_BEGIN');\n    await _openWord(_levelContent.words.first);\n    _pjDiagnostic('PJ_FIRST_WORD_OPEN_END');"""
new = """    if (Uri.base.queryParameters['pjNoAutoOpen'] == '1') {\n      _pjDiagnostic('PJ_FIRST_WORD_AUTO_OPEN_SKIPPED');\n      return;\n    }\n    _pjDiagnostic('PJ_FIRST_WORD_OPEN_BEGIN');\n    await _openWord(_levelContent.words.first);\n    _pjDiagnostic('PJ_FIRST_WORD_OPEN_END');"""
if journey.count(old) != 1:
    raise SystemExit(f'journey no-auto-open anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)
journey_path.write_text(journey)

# Word Detail diagnostic imports.
old = "import 'dart:async';\n"
new = "import 'dart:async';\nimport 'dart:convert';\n\nimport 'package:flutter/rendering.dart';\n"
if word.count(old) != 1:
    raise SystemExit(f'import anchor count={word.count(old)}')
word = word.replace(old, new, 1)

# Lightweight timing probes. Console markers are captured by Playwright; no DOM/screenshot work.
anchor = "const _wordSpeechFallbackTimeout = Duration(seconds: 4);\n\n"
helpers = r'''const _wordSpeechFallbackTimeout = Duration(seconds: 4);

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

'''
if word.count(anchor) != 1:
    raise SystemExit(f'helper anchor count={word.count(anchor)}')
word = word.replace(anchor, helpers, 1)

# Replace only the modal builder while preserving the production route mechanism/options.
old = r'''  return showModalBottomSheet<void>(
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
'''
new = r'''  final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';
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
      final production = pjVariant == 'production' ||
          pjVariant == 'production-no-outer-fitted';
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
'''
if word.count(old) != 1:
    raise SystemExit(f'modal builder anchor count={word.count(old)}')
word = word.replace(old, new, 1)

# Production subtree init/post-frame/example timing.
old = r'''  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _example = _resolveDownloadedExample(_entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_speak());
    });
  }
'''
new = r'''  void initState() {
    super.initState();
    const pjVariant = 'production';
    _pjWordDiag('PJ_WORD_PROD_INIT_BEGIN', variant: pjVariant);
    _index = widget.initialIndex;
    final exampleWatch = Stopwatch()..start();
    _pjWordDiag('PJ_WORD_EXAMPLE_RESOLVE_BEGIN', variant: pjVariant);
    _example = _resolveDownloadedExample(_entry);
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
'''
if word.count(old) != 1:
    raise SystemExit(f'production init anchor count={word.count(old)}')
word = word.replace(old, new, 1)

# Production build begin/end count and synchronous duration.
old = """  @override\n  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();"""
new = """  @override\n  Widget build(BuildContext context) {\n    const pjVariant = 'production';\n    final pjBuildCount = ++_pjWordBuildCount;\n    final pjBuildWatch = Stopwatch()..start();\n    _pjWordDiag(\n      'PJ_WORD_PROD_BUILD_BEGIN',\n      variant: pjVariant,\n      reason: 'count=$pjBuildCount',\n    );\n    final state = context.watch<AppState>();"""
if word.count(old) != 1:
    raise SystemExit(f'production build begin anchor count={word.count(old)}')
word = word.replace(old, new, 1)

old = """          ),\n        ],\n      ),\n    );\n  }\n}\n\nclass _VocabularyContext {"""
new = """          ),\n        ],\n      ),\n    );\n    pjBuildWatch.stop();\n    _pjWordDiag(\n      'PJ_WORD_PROD_BUILD_END',\n      variant: pjVariant,\n      reason: 'count=$pjBuildCount elapsedUs=${pjBuildWatch.elapsedMicroseconds}',\n    );\n    return pjBuilt;\n  }\n}\n\nclass _VocabularyContext {"""
# Convert the production return before patching the tail.
prod_start = word.index("  @override\n  Widget build(BuildContext context) {\n    const pjVariant = 'production';")
return_pos = word.index("    return Container(\n", prod_start)
word = word[:return_pos] + "    final pjBuilt = Container(\n" + word[return_pos + len("    return Container(\n"):]
if word.count(old) != 1:
    raise SystemExit(f'production build end anchor count={word.count(old)}')
word = word.replace(old, new, 1)

word_path.write_text(word)
print('WORD_DETAIL_FIRST_RENDER_BISECTION_APPLIED')
