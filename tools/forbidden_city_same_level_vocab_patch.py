from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNTIME = ROOT / 'app/lib/data/forbidden_city_journey_runtime.dart'
TEST = ROOT / 'app/test/forbidden_city_ten_level_content_contract_test.dart'
WORKFLOW = ROOT / '.github/workflows/forbidden-city-content-only-finalize.yml'
SELF = Path(__file__).resolve()

text = RUNTIME.read_text(encoding='utf-8')

old_decl = 'const forbiddenCityWordRecords = <ForbiddenCityWordRecord>[\n'
if text.count(old_decl) != 1:
    raise SystemExit('word record declaration match failed')
text = text.replace(
    old_decl,
    'const _forbiddenCityWordRecordDefinitions = <ForbiddenCityWordRecord>[\n',
    1,
)

needle = '''WordEntry _wordEntryForLevel(ForbiddenCityWordRecord record, int level) {
  final base = record.entry;
'''
replacement = r'''int _earliestStoryLevel(String word) {
  for (var index = 0; index < forbiddenCityLockedStories.length; index += 1) {
    if (forbiddenCityLockedStories[index].contains(word)) return index + 1;
  }
  throw StateError('Forbidden City vocabulary is orphaned from Story: $word');
}

String _storySource(String word, String story, {required String context}) {
  for (final segment in story.split(RegExp(r'[。！？!?；;\n]'))) {
    final source = segment.trim();
    if (source.contains(word)) return source;
  }
  throw StateError(
    'Forbidden City vocabulary has no $context Story source: $word',
  );
}

String _earliestStorySource(String word) {
  final level = _earliestStoryLevel(word);
  return _storySource(
    word,
    forbiddenCityLockedStories[level - 1],
    context: 'earliest-level',
  );
}

String _sameLevelStorySource(String word, int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return _storySource(
    word,
    forbiddenCityLockedStories[safeLevel - 1],
    context: 'Lv$safeLevel',
  );
}

/// First-appearance provenance is derived from the locked ten Story levels.
/// Teaching examples are derived again from the currently selected Story, so
/// Vocabulary can never show a sentence copied from a different level.
final List<ForbiddenCityWordRecord> forbiddenCityWordRecords =
    List<ForbiddenCityWordRecord>.unmodifiable([
      for (final record in _forbiddenCityWordRecordDefinitions)
        ForbiddenCityWordRecord(
          entry: record.entry,
          usageNote: record.usageNote,
          storySource: _earliestStorySource(record.entry.word),
          firstAppearsAt: _earliestStoryLevel(record.entry.word),
          contrastNote: record.contrastNote,
          narrativeNote: record.narrativeNote,
        ),
    ]);

WordEntry _wordEntryForLevel(ForbiddenCityWordRecord record, int level) {
  final base = record.entry;
  final sameLevelStorySource = _sameLevelStorySource(base.word, level);
'''
if text.count(needle) != 1:
    raise SystemExit('word entry function match failed')
text = text.replace(needle, replacement, 1)

text = text.replace(
    "      chinese: 'Story 原句：${record.storySource}',\n"
    "      pinyin: _pinyin(record.storySource),\n"
    "      vietnamese: 'Câu gốc trong Story: ${record.storySource}',\n"
    "      english: 'Story source: ${record.storySource}',\n",
    "      chinese: 'Story 原句：$sameLevelStorySource',\n"
    "      pinyin: _pinyin(sameLevelStorySource),\n"
    "      vietnamese: 'Câu gốc trong Story: $sameLevelStorySource',\n"
    "      english: 'Story source: $sameLevelStorySource',\n",
    1,
)

RUNTIME.write_text(text, encoding='utf-8')

test = TEST.read_text(encoding='utf-8')
old_loop = '''      for (final word in content.words) {
        expect(
          joinedStory.contains(word.word),
          isTrue,
          reason:
              'Lv$level Vocabulary must trace to same-level Story: ${word.word}',
        );
      }
'''
new_loop = '''      for (final word in content.words) {
        expect(
          joinedStory.contains(word.word),
          isTrue,
          reason:
              'Lv$level Vocabulary must trace to same-level Story: ${word.word}',
        );
        final source = word.studyExamples.first.chinese.replaceFirst(
          'Story 原句：',
          '',
        );
        expect(
          source.contains(word.word) && joinedStory.contains(source),
          isTrue,
          reason:
              'Lv$level teaching source must be an exact same-level Story sentence: ${word.word}',
        );
      }
'''
if test.count(old_loop) != 1:
    raise SystemExit('test vocabulary loop match failed')
test = test.replace(old_loop, new_loop, 1)

insert_before = "  test(\n    'Forbidden City keeps the locked Phoenix story mechanism at all levels',\n"
extra = '''  test('Forbidden City vocabulary provenance is derived from Story', () {
    expect(validateForbiddenCityWordTrace(), isEmpty);
    expect(
      forbiddenCityWordRecords
          .firstWhere((record) => record.entry.word == '判断')
          .firstAppearsAt,
      3,
    );
    expect(
      forbiddenCityWordRecords
          .firstWhere((record) => record.entry.word == '证据')
          .firstAppearsAt,
      5,
    );
  });

'''
if test.count(insert_before) != 1:
    raise SystemExit('test insertion anchor failed')
test = test.replace(insert_before, extra + insert_before, 1)
TEST.write_text(test, encoding='utf-8')

if WORKFLOW.exists():
    WORKFLOW.unlink()
SELF.unlink()
print('FORBIDDEN CITY SAME-LEVEL VOCABULARY PROVENANCE PATCH APPLIED')
