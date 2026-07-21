import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const meScreen = readFileSync('app/lib/screens/me_screen.dart', 'utf8');
const wordSheet = readFileSync(
  'app/lib/widgets/word_detail_sheet.dart',
  'utf8',
);

test('My Vocabulary uses the shared seven-city vocabulary catalog', () => {
  assert.match(catalog, /allDailyJourneyWords/);
  assert.match(catalog, /for \(final journey in dailyJourneyExperiences\)/);
  assert.match(meScreen, /final savedEntries = allDailyJourneyWords/);
  assert.doesNotMatch(meScreen, /final savedEntries = words\n/);
});

test('the save-vocabulary label is permanently constrained to one line', () => {
  assert.match(
    wordSheet,
    /state\.displayText\(isSaved \? '已收藏' : '收藏单词'\)/,
  );
  assert.match(wordSheet, /maxLines: 1/);
  assert.match(wordSheet, /softWrap: false/);
  assert.match(wordSheet, /fit: BoxFit\.scaleDown/);
});
