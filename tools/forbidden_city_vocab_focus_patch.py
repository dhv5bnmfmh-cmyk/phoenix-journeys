from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNTIME = ROOT / 'app/lib/data/forbidden_city_journey_runtime.dart'
TEST = ROOT / 'app/test/forbidden_city_ten_level_content_contract_test.dart'
SELF = Path(__file__).resolve()

text = RUNTIME.read_text(encoding='utf-8')
old = '''List<WordEntry> forbiddenCityWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final maximum = <int>[5, 6, 7, 7, 8, 8, 8, 8, 8, 8][safeLevel - 1];
  return forbiddenCityWordRecords
      .where((record) => record.firstAppearsAt <= safeLevel && story.contains(record.entry.word))
      .take(maximum)
      .map((record) => _wordEntryForLevel(record, safeLevel))
      .toList(growable: false);
}
'''
new = '''List<WordEntry> forbiddenCityWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final maximum = <int>[5, 6, 7, 7, 8, 8, 8, 8, 8, 8][safeLevel - 1];
  final candidates = forbiddenCityWordRecords
      .where(
        (record) =>
            record.firstAppearsAt <= safeLevel &&
            story.contains(record.entry.word),
      )
      .toList(growable: false);
  if (candidates.length <= maximum) {
    return candidates
        .map((record) => _wordEntryForLevel(record, safeLevel))
        .toList(growable: false);
  }

  // Each level keeps newly introduced Story words, then rotates the remaining
  // same-level Story vocabulary. This makes Vocabulary a real Lv1-Lv10
  // progression instead of reusing one late-level word set.
  final introduced = candidates
      .where((record) => record.firstAppearsAt == safeLevel)
      .toList(growable: false);
  final prior = candidates
      .where((record) => record.firstAppearsAt != safeLevel)
      .toList(growable: false);
  final remainingSlots = (maximum - introduced.length).clamp(0, maximum);
  final offset = prior.isEmpty ? 0 : ((safeLevel - 1) * 2) % prior.length;
  final rotated = prior.isEmpty
      ? <ForbiddenCityWordRecord>[]
      : <ForbiddenCityWordRecord>[
          ...prior.skip(offset),
          ...prior.take(offset),
        ];
  final selected = <ForbiddenCityWordRecord>[
    ...introduced.take(maximum),
    ...rotated.take(remainingSlots),
  ];

  // Present words in Story order so the shared Phoenix vocabulary UI remains
  // natural and unchanged while the selected teaching focus differs by level.
  selected.sort(
    (a, b) => story.indexOf(a.entry.word).compareTo(story.indexOf(b.entry.word)),
  );
  return selected
      .map((record) => _wordEntryForLevel(record, safeLevel))
      .toList(growable: false);
}
'''
count = text.count(old)
if count != 1:
    raise SystemExit(f'vocabulary function: expected one match, got {count}')
RUNTIME.write_text(text.replace(old, new, 1), encoding='utf-8')

if TEST.exists():
    test = TEST.read_text(encoding='utf-8')
    old_sig = "      vocabulary.add(content.words.map((word) => word.word).join('|'));\n"
    new_sig = "      final vocabularyWords = content.words.map((word) => word.word).toList()..sort();\n      vocabulary.add(vocabularyWords.join('|'));\n"
    if test.count(old_sig) != 1:
        raise SystemExit('vocabulary test signature replacement not found exactly once')
    TEST.write_text(test.replace(old_sig, new_sig, 1), encoding='utf-8')

SELF.unlink()
print('FORBIDDEN CITY DISTINCT VOCABULARY FOCUS PATCH APPLIED')
