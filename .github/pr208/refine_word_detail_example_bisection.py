from pathlib import Path

path = Path('app/lib/widgets/word_detail_sheet.dart')
text = path.read_text()

old = """      final production = pjVariant == 'production' ||\n          pjVariant == 'production-no-outer-fitted';"""
new = """      final production = pjVariant.startsWith('production');"""
if text.count(old) != 1:
    raise SystemExit(f'production selector count={text.count(old)}')
text = text.replace(old, new, 1)

# Make production markers carry the actual diagnostic production variant.
old = "const pjVariant = 'production';"
count = text.count(old)
if count < 2:
    raise SystemExit(f'production marker anchor count={count}')
text = text.replace(
    old,
    "final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';",
)

old = """    _index = widget.initialIndex;\n    final exampleWatch = Stopwatch()..start();\n    _pjWordDiag('PJ_WORD_EXAMPLE_RESOLVE_BEGIN', variant: pjVariant);\n    _example = _resolveDownloadedExample(_entry);\n    exampleWatch.stop();"""
new = """    _index = widget.initialIndex;\n    final exampleWatch = Stopwatch()..start();\n    _pjWordDiag('PJ_WORD_EXAMPLE_RESOLVE_BEGIN', variant: pjVariant);\n    if (pjVariant == 'production-bypass-example') {\n      final entry = _entry;\n      _example = PhoenixVocabularyExample(\n        chinese: '4{entry.word}是本次旅程中的重点词。',\n        pinyin: entry.pinyin,\n        native: entry.nativeDefinition(context.read<AppState>().translationLanguage),\n        english: entry.englishDefinition,\n        usageNote: 'PJ diagnostic bypass',\n        isOfflineFallback: true,\n      );\n      _pjWordDiag('PJ_WORD_EXAMPLE_BYPASSED', variant: pjVariant);\n    } else {\n      _example = _resolveDownloadedExample(_entry);\n    }\n    exampleWatch.stop();""".replace('\u00024', '$')
if text.count(old) != 1:
    raise SystemExit(f'init example anchor count={text.count(old)}')
text = text.replace(old, new, 1)

old = """  PhoenixVocabularyExample _resolveDownloadedExample(WordEntry entry) {\n    final state = context.read<AppState>();\n    final bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);\n    if (bundled != null) return bundled;\n\n    if (entry.examples.isNotEmpty) {"""
new = """  PhoenixVocabularyExample _resolveDownloadedExample(WordEntry entry) {\n    final state = context.read<AppState>();\n    final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';\n    PhoenixVocabularyExample? bundled;\n    if (pjVariant != 'production-bypass-bundled') {\n      final bundledWatch = Stopwatch()..start();\n      _pjWordDiag('PJ_WORD_BUNDLED_LOOKUP_BEGIN', variant: pjVariant);\n      bundled = PhoenixVocabularyService.bundledExampleForWord(entry.word);\n      bundledWatch.stop();\n      _pjWordDiag(\n        'PJ_WORD_BUNDLED_LOOKUP_END',\n        variant: pjVariant,\n        reason: 'hit=4{bundled != null} elapsedUs=4{bundledWatch.elapsedMicroseconds}',\n      );\n    } else {\n      _pjWordDiag('PJ_WORD_BUNDLED_LOOKUP_BYPASSED', variant: pjVariant);\n    }\n    if (bundled != null) return bundled;\n\n    _pjWordDiag(\n      'PJ_WORD_ENTRY_EXAMPLES_CHECK',\n      variant: pjVariant,\n      reason: 'count=4{entry.examples.length}',\n    );\n    if (entry.examples.isNotEmpty) {""".replace('\u00024', '$')
if text.count(old) != 1:
    raise SystemExit(f'resolve start anchor count={text.count(old)}')
text = text.replace(old, new, 1)

old = """    final contextData = _findVocabularyContext(state, entry);\n    if (contextData.chinese.isNotEmpty) {"""
new = """    if (pjVariant == 'production-bypass-context') {\n      _pjWordDiag('PJ_WORD_CONTEXT_LOOKUP_BYPASSED', variant: pjVariant);\n      return PhoenixVocabularyExample(\n        chinese: '4{entry.word}是本次旅程中的重点词。4{entry.simpleChinese}',\n        pinyin: entry.pinyin,\n        native: entry.nativeDefinition(state.translationLanguage),\n        english: '4{entry.word}: 4{entry.englishDefinition}',\n        usageNote: 'PJ diagnostic context bypass',\n        isOfflineFallback: true,\n      );\n    }\n\n    final contextWatch = Stopwatch()..start();\n    _pjWordDiag('PJ_WORD_CONTEXT_LOOKUP_BEGIN', variant: pjVariant);\n    final contextData = _findVocabularyContext(state, entry);\n    contextWatch.stop();\n    _pjWordDiag(\n      'PJ_WORD_CONTEXT_LOOKUP_END',\n      variant: pjVariant,\n      reason: 'hit=4{contextData.chinese.isNotEmpty} elapsedUs=4{contextWatch.elapsedMicroseconds}',\n    );\n    if (contextData.chinese.isNotEmpty) {""".replace('\u00024', '$')
if text.count(old) != 1:
    raise SystemExit(f'context anchor count={text.count(old)}')
text = text.replace(old, new, 1)

old = """_VocabularyContext _findVocabularyContext(AppState state, WordEntry entry) {\n  final journeys = [\n    state.activeJourney,\n    ...dailyJourneyExperiences.where(\n      (journey) => journey.id != state.activeJourney.id,\n    ),\n  ];\n\n  for (final journey in journeys) {"""
new = """_VocabularyContext _findVocabularyContext(AppState state, WordEntry entry) {\n  final pjVariant = Uri.base.queryParameters['pjWordVariant'] ?? 'production';\n  final journeys = <DailyJourneyExperience>[state.activeJourney];\n  if (pjVariant == 'production-active-only') {\n    _pjWordDiag(\n      'PJ_WORD_ALL_JOURNEYS_BYPASSED',\n      variant: pjVariant,\n      reason: 'active=4{state.activeJourney.id}',\n    );\n  } else {\n    final catalogWatch = Stopwatch()..start();\n    _pjWordDiag(\n      'PJ_WORD_ALL_JOURNEYS_MATERIALIZE_BEGIN',\n      variant: pjVariant,\n      reason: 'length=4{dailyJourneyExperiences.length}',\n    );\n    for (var index = 0; index < dailyJourneyExperiences.length; index += 1) {\n      final itemWatch = Stopwatch()..start();\n      final journey = dailyJourneyExperiences[index];\n      itemWatch.stop();\n      if (itemWatch.elapsedMilliseconds >= 20) {\n        _pjWordDiag(\n          'PJ_WORD_JOURNEY_MATERIALIZE_SLOW',\n          variant: pjVariant,\n          reason: 'index=4index id=4{journey.id} elapsedUs=4{itemWatch.elapsedMicroseconds}',\n        );\n      }\n      if (journey.id != state.activeJourney.id) journeys.add(journey);\n    }\n    catalogWatch.stop();\n    _pjWordDiag(\n      'PJ_WORD_ALL_JOURNEYS_MATERIALIZE_END',\n      variant: pjVariant,\n      reason: 'count=4{journeys.length} elapsedUs=4{catalogWatch.elapsedMicroseconds}',\n    );\n  }\n\n  for (final journey in journeys) {""".replace('\u00024', '$')
if text.count(old) != 1:
    raise SystemExit(f'find context anchor count={text.count(old)}')
text = text.replace(old, new, 1)

path.write_text(text)
print('WORD_DETAIL_EXAMPLE_BISECTION_REFINED')
