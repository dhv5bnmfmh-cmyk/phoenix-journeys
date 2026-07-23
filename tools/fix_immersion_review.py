from pathlib import Path

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text(encoding='utf-8')

old_word = """    );
    _immersion.reveal();
    if (!mounted || !shouldResume) return;

    // Wait until the sheet animation and iOS audio channel have fully closed.
"""
new_word = """    );
    if (!mounted) return;
    _immersion.reveal();
    if (!shouldResume) return;

    // Wait until the sheet animation and iOS audio channel have fully closed.
"""
if journey.count(old_word) != 1:
    raise SystemExit('word-detail mounted guard anchor mismatch')
journey = journey.replace(old_word, new_word, 1)

old_support = """  }) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ReadingSupportSheet(
              controller: _narration,
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
              onSpeakNative: () => _speakSupportText(
                nativeText,
                languageCode: _nativeSupportLanguageCode,
              ),
              onSpeakEnglish: () =>
                  _speakSupportText(english, languageCode: 'en-US'),
            ),
          ),
        );
      },
    );
  }
"""
new_support = """  }) async {
    if (!mounted) return;
    _immersion.setEnabled(false);
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (sheetContext) {
          final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _ReadingSupportSheet(
                controller: _narration,
                title: title,
                pinyin: pinyin,
                nativeLabel: nativeLabel,
                nativeText: nativeText,
                english: english,
                onSpeakNative: () => _speakSupportText(
                  nativeText,
                  languageCode: _nativeSupportLanguageCode,
                ),
                onSpeakEnglish: () =>
                    _speakSupportText(english, languageCode: 'en-US'),
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        _syncImmersion();
        _immersion.reveal();
      }
    }
  }
"""
if journey.count(old_support) != 1:
    raise SystemExit('reading-support immersion anchor mismatch')
journey = journey.replace(old_support, new_support, 1)
journey_path.write_text(journey, encoding='utf-8')

rule_path = Path('worker/journey_immersion_rule.test.mjs')
rule = rule_path.read_text(encoding='utf-8')
anchor = """  assert.match(journey, /轻触屏幕显示内容/);
});
"""
addition = """  assert.match(journey, /轻触屏幕显示内容/);
  assert.match(
    journey,
    /if \(!mounted\) return;\n    _immersion\.reveal\(\);\n    if \(!shouldResume\) return;/,
  );
});

test('modal reading support pauses and safely restores immersion', () => {
  assert.match(journey, /_immersion\.setEnabled\(false\);\n    try \{/);
  assert.match(
    journey,
    /finally \{\n      if \(mounted\) \{\n        _syncImmersion\(\);\n        _immersion\.reveal\(\);/,
  );
});
"""
if rule.count(anchor) != 1:
    raise SystemExit('immersion rule anchor mismatch')
rule = rule.replace(anchor, addition, 1)
rule_path.write_text(rule, encoding='utf-8')
