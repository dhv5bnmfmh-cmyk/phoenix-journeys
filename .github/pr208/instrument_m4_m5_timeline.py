from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
s = path.read_text()

replacements = []

old = """      await _persistProgress(overrideStep: safeStep);\n      return;\n    }\n    if (safeStep == 2 && safeStep != step) {"""
new = """      _pjDiagnostic('PJ_PROGRESS_PERSIST_BEGIN');\n      final pjPersistWatch = Stopwatch()..start();\n      await _persistProgress(overrideStep: safeStep);\n      pjPersistWatch.stop();\n      _pjDiagnostic(\n        'PJ_PROGRESS_PERSIST_END',\n        reason: 'elapsedMs=${pjPersistWatch.elapsedMilliseconds}',\n      );\n      return;\n    }\n    if (safeStep == 2 && safeStep != step) {"""
replacements.append((old, new, 'Story-to-Vocabulary persistence timing'))

old = """  Future<void> _openWord(WordEntry entry) async {\n    final shouldResume = _narration.status == NarrationStatus.playing;"""
new = """  Future<void> _openWord(WordEntry entry) async {\n    _pjDiagnostic('PJ_WORD_OPEN_ENTER', reason: 'word=${entry.word}');\n    final shouldResume = _narration.status == NarrationStatus.playing;"""
replacements.append((old, new, 'word open entry'))

old = """    final initialIndex = _levelContent.words.indexWhere(\n      (item) => item.word == entry.word,\n    );\n    await showWordDetail(\n      context,\n      entry,\n      narrationController: _narration,\n      entries: _levelContent.words,\n      initialIndex: initialIndex < 0 ? 0 : initialIndex,\n      onSpeak: () => _narration.speakWord(\n        _appState.displayText(entry.word),\n        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n      ),\n      onSpeakEntry: (currentEntry) => _narration.speakWord(\n        _appState.displayText(currentEntry.word),\n        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n      ),\n    );\n    if (!mounted || !shouldResume) return;"""
new = """    final initialIndex = _levelContent.words.indexWhere(\n      (item) => item.word == entry.word,\n    );\n\n    _pjDiagnostic('PJ_WORD_DETAIL_ROUTE_PUSH_BEGIN');\n    final wordDetailFuture = showWordDetail(\n      context,\n      entry,\n      narrationController: _narration,\n      entries: _levelContent.words,\n      initialIndex: initialIndex < 0 ? 0 : initialIndex,\n      onSpeak: () {\n        _pjDiagnostic(\n          'PJ_WORD_SPEAK_CALL_BEGIN',\n          reason: 'source=initial word=${entry.word}',\n        );\n        final speech = _narration.speakWord(\n          _appState.displayText(entry.word),\n          languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n        );\n        _pjDiagnostic(\n          'PJ_WORD_SPEAK_FUTURE_RETURNED',\n          reason: 'source=initial',\n        );\n        return speech.then((success) {\n          _pjDiagnostic(\n            'PJ_WORD_SPEAK_COMPLETE',\n            reason: 'source=initial success=$success',\n          );\n          return success;\n        });\n      },\n      onSpeakEntry: (currentEntry) {\n        _pjDiagnostic(\n          'PJ_WORD_SPEAK_CALL_BEGIN',\n          reason: 'source=entry word=${currentEntry.word}',\n        );\n        final speech = _narration.speakWord(\n          _appState.displayText(currentEntry.word),\n          languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n        );\n        _pjDiagnostic(\n          'PJ_WORD_SPEAK_FUTURE_RETURNED',\n          reason: 'source=entry',\n        );\n        return speech.then((success) {\n          _pjDiagnostic(\n            'PJ_WORD_SPEAK_COMPLETE',\n            reason: 'source=entry success=$success',\n          );\n          return success;\n        });\n      },\n    );\n    _pjDiagnostic('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED');\n    await wordDetailFuture;\n    _pjDiagnostic('PJ_WORD_DETAIL_CLOSED');\n    if (!mounted || !shouldResume) return;"""
replacements.append((old, new, 'word detail and speech timing'))

old = """    try {\n      await _goToStep(1);\n    } catch (error, stackTrace) {"""
new = """    try {\n      await _goToStep(1);\n      _pjDiagnostic('PJ_ENTER_VOCAB_AFTER_GO');\n    } catch (error, stackTrace) {"""
replacements.append((old, new, 'after go-to-step timing'))

old = """    await WidgetsBinding.instance.endOfFrame;\n    if (!mounted) {"""
new = """    _pjDiagnostic('PJ_FIRST_WORD_END_OF_FRAME_BEGIN');\n    await WidgetsBinding.instance.endOfFrame;\n    _pjDiagnostic('PJ_FIRST_WORD_END_OF_FRAME_END');\n    if (!mounted) {"""
replacements.append((old, new, 'end-of-frame timing'))

old = """    await _openWord(_levelContent.words.first);\n  }"""
new = """    _pjDiagnostic('PJ_FIRST_WORD_OPEN_BEGIN');\n    await _openWord(_levelContent.words.first);\n    _pjDiagnostic('PJ_FIRST_WORD_OPEN_END');\n  }"""
replacements.append((old, new, 'first-word lifecycle timing'))

old = """      if (_pjVocabularyStableScheduled) return;\n      _pjVocabularyStableScheduled = true;\n      Timer(const Duration(seconds: 2), () {\n        if (!mounted) {"""
new = """      if (_pjVocabularyStableScheduled) return;\n      _pjVocabularyStableScheduled = true;\n      _pjDiagnostic('PJ_VOCAB_STABLE_TIMER_SCHEDULED');\n      Timer(const Duration(seconds: 2), () {\n        _pjDiagnostic('PJ_VOCAB_STABLE_TIMER_FIRED');\n        if (!mounted) {"""
replacements.append((old, new, 'M5 timer timing'))

for old, new, label in replacements:
    count = s.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one anchor, found {count}')
    s = s.replace(old, new, 1)

path.write_text(s)
print('M4_M5_DIAGNOSTIC_INSTRUMENTATION_APPLIED')
