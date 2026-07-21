import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, writeFileSync } from 'node:fs';

const paths = {
  catalog: 'app/lib/data/daily_journey_catalog.dart',
  me: 'app/lib/screens/me_screen.dart',
  sheet: 'app/lib/widgets/word_detail_sheet.dart',
};

function replaceOnce(source, oldValue, newValue, label) {
  if (!source.includes(oldValue)) {
    if (source.includes(newValue)) return source;
    throw new Error(`Expected ${label} pattern was not found.`);
  }
  return source.replace(oldValue, newValue);
}

let catalog = readFileSync(paths.catalog, 'utf8');
catalog = replaceOnce(
  catalog,
  `  ...extendedJourneyExperiences,\n];\n\nDailyJourneyExperience requireDailyJourneyExperience(String id) {`,
  `  ...extendedJourneyExperiences,\n];\n\nfinal List<WordEntry> allDailyJourneyWords = List<WordEntry>.unmodifiable(\n  <String, WordEntry>{\n    for (final journey in dailyJourneyExperiences)\n      for (final entry in journey.words) entry.word: entry,\n  }.values,\n);\n\nDailyJourneyExperience requireDailyJourneyExperience(String id) {`,
  'shared vocabulary catalog',
);
writeFileSync(paths.catalog, catalog);

let me = readFileSync(paths.me, 'utf8');
me = replaceOnce(
  me,
  `import '../data/journey_data.dart';\n`,
  `import '../data/daily_journey_catalog.dart';\nimport '../data/journey_data.dart';\n`,
  'MeScreen catalog import',
);
me = replaceOnce(
  me,
  `    final savedEntries = words\n        .where((entry) => state.savedWords.contains(entry.word))\n        .toList(growable: false);`,
  `    final savedEntries = allDailyJourneyWords\n        .where((entry) => state.savedWords.contains(entry.word))\n        .toList(growable: false);`,
  'MeScreen saved entries',
);
writeFileSync(paths.me, me);

let sheet = readFileSync(paths.sheet, 'utf8');
sheet = replaceOnce(
  sheet,
  `                      label: Text(\n                        state.displayText(isSaved ? '已收藏' : '收藏生词'),\n                        style: const TextStyle(fontSize: 11),\n                      ),`,
  `                      label: FittedBox(\n                        fit: BoxFit.scaleDown,\n                        child: Text(\n                          state.displayText(isSaved ? '已收藏' : '收藏生词'),\n                          maxLines: 1,\n                          softWrap: false,\n                          style: const TextStyle(fontSize: 11),\n                        ),\n                      ),`,
  'single-line save vocabulary label',
);
writeFileSync(paths.sheet, sheet);

function exported(name, source) {
  const encoded = Buffer.from(source, 'utf8').toString('base64');
  console.log(`PHOENIX_EXPORT_${name}_BEGIN`);
  for (let offset = 0; offset < encoded.length; offset += 120) {
    console.log(encoded.slice(offset, offset + 120));
  }
  console.log(`PHOENIX_EXPORT_${name}_END`);
}

exported('CATALOG', catalog);
exported('ME_SCREEN', me);
exported('WORD_SHEET', sheet);

test('saved vocabulary repair includes all journey words', () => {
  assert.match(catalog, /allDailyJourneyWords/);
  assert.match(catalog, /for \(final journey in dailyJourneyExperiences\)/);
  assert.match(me, /final savedEntries = allDailyJourneyWords/);
  assert.doesNotMatch(me, /final savedEntries = words\n/);
});

test('save vocabulary label stays on one line', () => {
  assert.match(sheet, /fit: BoxFit\.scaleDown/);
  assert.match(sheet, /maxLines: 1/);
  assert.match(sheet, /softWrap: false/);
});
