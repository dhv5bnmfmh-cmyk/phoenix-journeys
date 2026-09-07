from pathlib import Path

journey_path = Path('app/lib/screens/journey_screen.dart')
word_path = Path('app/lib/widgets/word_detail_sheet.dart')

journey = journey_path.read_text()
word = word_path.read_text()

# Journey milestone diagnostics. Query-gated controls only; default product behavior is unchanged.
old = "import 'dart:async';\n"
new = "import 'dart:async';\nimport 'dart:convert';\n"
if journey.count(old) != 1:
    raise SystemExit(f'journey import anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)

anchor = "@visibleForTesting\nint? stableNarrationRevealEnd({"
helper = """void _pjAccept(String marker, {String? reason}) {\n  if (Uri.base.queryParameters['pjFixedAccept'] != '1') return;\n  final payload = <String, Object?>{\n    'marker': marker,\n    if (reason != null) 'reason': reason,\n    'timestamp': DateTime.now().toUtc().toIso8601String(),\n  };\n  debugPrint('$marker ${jsonEncode(payload)}');\n}\n\n@visibleForTesting\nint? stableNarrationRevealEnd({"""
if journey.count(anchor) != 1:
    raise SystemExit(f'journey helper anchor count={journey.count(anchor)}')
journey = journey.replace(anchor, helper, 1)

old = """  Future<void> _goToStep(int targetStep) async {\n    final safeStep = targetStep.clamp(0, AppState.journeyLastStep);"""
new = """  Future<void> _goToStep(int targetStep) async {\n    final safeStep = targetStep.clamp(0, AppState.journeyLastStep);\n    if (step == 0 && safeStep == 1) {\n      _pjAccept('PJ_M2_PRE_GUARDS', reason: 'step=$step target=$safeStep');\n    }"""
if journey.count(old) != 1:
    raise SystemExit(f'goToStep anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)

old = """      setState(() {\n        _stageNarrationRequestedId = null;\n        step = safeStep;\n      });\n      WidgetsBinding.instance.addPostFrameCallback((_) {"""
new = """      setState(() {\n        _stageNarrationRequestedId = null;\n        step = safeStep;\n      });\n      _pjAccept('PJ_M3_STEP_COMMITTED', reason: 'step=$step');\n      WidgetsBinding.instance.addPostFrameCallback((_) {"""
if journey.count(old) != 1:
    raise SystemExit(f'step commit anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)

old = """    await showWordDetail(\n      context,\n      entry,"""
new = """    final detailFuture = showWordDetail(\n      context,\n      entry,"""
if journey.count(old) != 1:
    raise SystemExit(f'showWordDetail anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)
old = """      ),\n    );\n    if (!mounted || !shouldResume) return;"""
new = """      ),\n    );\n    _pjAccept('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', reason: 'word=${entry.word}');\n    await detailFuture;\n    if (!mounted || !shouldResume) return;"""
if journey.count(old) != 1:
    raise SystemExit(f'showWordDetail close anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)

old = """  Future<void> _enterVocabularyAtFirstWord() async {\n    await _goToStep(1);\n    if (!mounted || step != 1 || _levelContent.words.isEmpty) return;\n\n    await WidgetsBinding.instance.endOfFrame;\n    if (!mounted || step != 1) return;\n\n    await _openWord(_levelContent.words.first);\n  }"""
new = """  Future<void> _enterVocabularyAtFirstWord() async {\n    _pjAccept('PJ_M1_TAP_RECEIVED', reason: 'step=$step');\n    await _goToStep(1);\n    if (!mounted || step != 1 || _levelContent.words.isEmpty) return;\n\n    await WidgetsBinding.instance.endOfFrame;\n    if (!mounted || step != 1) return;\n    _pjAccept('PJ_M4_VOCAB_FIRST_FRAME', reason: 'step=$step');\n\n    if (Uri.base.queryParameters['pjNoAutoOpen'] == '1') {\n      _pjAccept('PJ_FIRST_WORD_AUTO_OPEN_SKIPPED');\n      return;\n    }\n    _pjAccept('PJ_FIRST_WORD_OPEN_BEGIN', reason: 'word=${_levelContent.words.first.word}');\n    await _openWord(_levelContent.words.first);\n    _pjAccept('PJ_FIRST_WORD_OPEN_END');\n  }"""
if journey.count(old) != 1:
    raise SystemExit(f'enter vocabulary anchor count={journey.count(old)}')
journey = journey.replace(old, new, 1)
journey_path.write_text(journey)

# Word Detail timing and lazy-fallback consumption diagnostics.
old = "import 'dart:async';\n"
new = "import 'dart:async';\nimport 'dart:convert';\n"
if word.count(old) != 1:
    raise SystemExit(f'word import anchor count={word.count(old)}')
word = word.replace(old, new, 1)
old = "import '../data/daily_journey_catalog.dart';\n"
new = "import '../data/daily_journey_catalog.dart';\nimport '../data/daily_journey_experience.dart';\n"
if word.count(old) != 1:
    raise SystemExit(f'word journey import anchor count={word.count(old)}')
word = word.replace(old, new, 1)

anchor = "const _wordSpeechFallbackTimeout = Duration(seconds: 4);\n\n"
helpers = r'''const _wordSpeechFallbackTimeout = Duration(seconds: 4);

void _pjWordAccept(String marker, {String? reason}) {
  if (Uri.base.queryParameters['pjFixedAccept'] != '1') return;
  final payload = <String, Object?>{
    'marker': marker,
    if (reason != null) 'reason': reason,
    'timestamp': DateTime.now().toUtc().toIso8601String(),
  };
  debugPrint('$marker ${jsonEncode(payload)}');
}

class _PjCountingJourneyIterable extends Iterable<DailyJourneyExperience> {
  _PjCountingJourneyIterable(this.source);
  final Iterable<DailyJourneyExperience> source;
  int invoked = 0;

  @override
  Iterator<DailyJourneyExperience> get iterator =>
      _PjCountingJourneyIterator(source.iterator, () => invoked += 1);
}

class _PjCountingJourneyIterator implements Iterator<DailyJourneyExperience> {
  _PjCountingJourneyIterator(this.inner, this.onAdvance);
  final Iterator<DailyJourneyExperience> inner;
  final void Function() onAdvance;

  @override
  DailyJourneyExperience get current => inner.current;

  @override
  bool moveNext() {
    final moved = inner.moveNext();
    if (moved) onAdvance();
    return moved;
  }
}

'''
if word.count(anchor) != 1:
    raise SystemExit(f'word helper anchor count={word.count(anchor)}')
word = word.replace(anchor, helpers, 1)

old = """    _index = widget.initialIndex;\n    _example = _resolveDownloadedExample(_entry);\n    WidgetsBinding.instance.addPostFrameCallback((_) {\n      if (mounted) unawaited(_speak());\n    });"""
new = """    _index = widget.initialIndex;\n    final coldWatch = Stopwatch()..start();\n    _pjWordAccept('PJ_WORD_EXAMPLE_COLD_BEGIN', reason: 'word=${_entry.word}');\n    _example = _resolveDownloadedExample(_entry);\n    coldWatch.stop();\n    _pjWordAccept(\n      'PJ_WORD_EXAMPLE_COLD_END',\n      reason: 'elapsedUs=${coldWatch.elapsedMicroseconds} content=${_example.chinese}',\n    );\n    final warmWatch = Stopwatch()..start();\n    final warmExample = _resolveDownloadedExample(_entry);\n    warmWatch.stop();\n    _pjWordAccept(\n      'PJ_WORD_EXAMPLE_WARM_END',\n      reason: 'elapsedUs=${warmWatch.elapsedMicroseconds} content=${warmExample.chinese}',\n    );\n    WidgetsBinding.instance.addPostFrameCallback((_) {\n      _pjWordAccept('PJ_WORD_DETAIL_FIRST_FRAME', reason: 'word=${_entry.word}');\n      _pjWordAccept('PJ_WORD_POST_FRAME_CALLBACK_ENTERED');\n      _pjWordAccept('PJ_M5_STABLE', reason: 'step=vocabulary');\n      if (mounted) unawaited(_speak());\n    });"""
if word.count(old) != 1:
    raise SystemExit(f'word init anchor count={word.count(old)}')
word = word.replace(old, new, 1)

old = """    final bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);\n    if (bundled != null) return bundled;\n\n    if (entry.examples.isNotEmpty) {"""
new = """    final bundledWatch = Stopwatch()..start();\n    final bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);\n    bundledWatch.stop();\n    _pjWordAccept(\n      'PJ_WORD_BUNDLED_LOOKUP',\n      reason: 'elapsedUs=${bundledWatch.elapsedMicroseconds} hit=${bundled != null}',\n    );\n    if (bundled != null) return bundled;\n\n    _pjWordAccept('PJ_WORD_ENTRY_EXAMPLES', reason: 'count=${entry.examples.length}');\n    if (entry.examples.isNotEmpty) {"""
if word.count(old) != 1:
    raise SystemExit(f'bundled anchor count={word.count(old)}')
word = word.replace(old, new, 1)

old = """    final contextData = findJourneyVocabularyContext(\n      activeJourney: state.activeJourney,\n      fallbackJourneys: dailyJourneyExperiences,\n      entry: entry,\n    );\n    if (contextData.chinese.isNotEmpty) {"""
new = """    final fallbackProbe = _PjCountingJourneyIterable(dailyJourneyExperiences);\n    final contextWatch = Stopwatch()..start();\n    _pjWordAccept('PJ_WORD_CONTEXT_LOOKUP_BEGIN', reason: 'active=${state.activeJourney.id}');\n    final contextData = findJourneyVocabularyContext(\n      activeJourney: state.activeJourney,\n      fallbackJourneys: fallbackProbe,\n      entry: entry,\n    );\n    contextWatch.stop();\n    _pjWordAccept(\n      'PJ_WORD_CONTEXT_LOOKUP_END',\n      reason: 'elapsedUs=${contextWatch.elapsedMicroseconds} lazyBuilders=${fallbackProbe.invoked} hit=${contextData.chinese.isNotEmpty}',\n    );\n    if (contextData.chinese.isNotEmpty) {"""
if word.count(old) != 1:
    raise SystemExit(f'context anchor count={word.count(old)}')
word = word.replace(old, new, 1)

word_path.write_text(word)
print('WORD_DETAIL_FIXED_ACCEPTANCE_INSTRUMENTED')
