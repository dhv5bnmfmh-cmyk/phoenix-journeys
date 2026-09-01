import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const catalog = fs.readFileSync(
  new URL('../app/lib/data/all_journey_language_level_catalog.dart', import.meta.url),
  'utf8',
);
const homeShell = fs.readFileSync(
  new URL('../app/lib/screens/home_shell.dart', import.meta.url),
  'utf8',
);
const meScreen = fs.readFileSync(
  new URL('../app/lib/screens/me_screen.dart', import.meta.url),
  'utf8',
);
const journeyScreen = fs.readFileSync(
  new URL('../app/lib/screens/journey_screen.dart', import.meta.url),
  'utf8',
);
const selector = fs.readFileSync(
  new URL('../app/lib/widgets/journey_level_selector_button.dart', import.meta.url),
  'utf8',
);
const narrationPlayer = fs.readFileSync(
  new URL('../app/lib/widgets/narration_player_card.dart', import.meta.url),
  'utf8',
);
const agent = fs.readFileSync(
  new URL('../app/lib/agents/phoenix_language_level_agent.dart', import.meta.url),
  'utf8',
);

test('adaptive journeys select aligned sentence packets instead of raw paragraph pairs', () => {
  assert.match(catalog, /_storySentencePackets/);
  assert.match(catalog, /_selectNarrativePackets/);
  assert.match(catalog, /_partitionPackets/);
  assert.match(catalog, /_alignedSentence/);
  assert.doesNotMatch(catalog, /_pairedStory/);
  assert.doesNotMatch(catalog, /_firstChineseSentence/);
});

test('every reading band keeps an approved one-or-two paragraph shape', () => {
  assert.match(catalog, /paragraphCount: plan\.paragraphCount/);
  assert.match(agent, /paragraphCount: 1/);
  assert.match(agent, /paragraphCount: 2/);
});

test('Home keeps four destinations and no floating level control', () => {
  assert.equal((homeShell.match(/NavigationRailDestination\(/g) ?? []).length, 4);
  assert.equal((homeShell.match(/_CompactNavItem\(/g) ?? []).length, 5);
  assert.doesNotMatch(homeShell, /SettingsScreen|settings_outlined|setTab\(4\)/);
  assert.doesNotMatch(homeShell, /JourneyLevelSelectorButton/);
  assert.doesNotMatch(homeShell, /Positioned\([\s\S]*top: 6,[\s\S]*right: 8/);
});

test('Me owns one ten-level control and explains next-entry application', () => {
  assert.equal((meScreen.match(/JourneyLevelSelectorButton\(/g) ?? []).length, 1);
  assert.match(meScreen, /me-learning-settings/);
  assert.match(meScreen, /settings-script-mode/);
  assert.match(meScreen, /settings-translation-language/);
  assert.doesNotMatch(meScreen, /_chooseLevel|HSK／TOCFL 能力设置/);
  assert.ok(selector.includes('global-journey-level-selector'));
  assert.ok(selector.includes('phoenix-level-minus'));
  assert.ok(selector.includes('phoenix-level-plus'));
  assert.ok(selector.includes("'Lv.$level'"));
  assert.ok(selector.includes('phoenix-level-guide'));
  assert.ok(selector.includes('新的等级将在下一次进入旅程时应用'));
  assert.doesNotMatch(selector, /HSK|TOCFL|考试等级/);
});

test('compact narration exposes paragraph percent and remaining text', () => {
  assert.ok(narrationPlayer.includes('compactNarrationProgressLabel'));
  assert.ok(narrationPlayer.includes('第 $item / $itemCount 段'));
  assert.ok(narrationPlayer.includes('剩余 $remaining 字'));
  assert.ok(narrationPlayer.includes('narration-compact-label'));
  assert.ok(narrationPlayer.includes('minHeight: 4'));
});

test('every journey step keeps one read-only session level in the app bar', () => {
  assert.match(journeyScreen, /journey-session-level-badge/);
  assert.match(journeyScreen, /Lv\.\$\{_sessionLanguageProfile\.phoenixLevel\}/);
  assert.doesNotMatch(journeyScreen, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.doesNotMatch(journeyScreen, /_phoenixLevelController\.addListener/);
  assert.doesNotMatch(journeyScreen, /_handlePhoenixLevelChanged/);
  assert.doesNotMatch(journeyScreen, /phoenix-level-minus|phoenix-level-plus/);
});

test('Phoenix exposes ten fused levels while retaining legacy calibration data', () => {
  assert.match(agent, /static const List<ChineseProficiencyProfile> phoenixProfiles/);
  assert.equal((agent.match(/phoenixLevel: /g) ?? []).length, 10);
  assert.match(agent, /phoenixLevelFromStorage/);
  assert.match(agent, /hskProfiles/);
  assert.match(agent, /tocflProfiles/);
});

test('the locked session level still binds all learning surfaces', () => {
  assert.match(journeyScreen, /_sessionLanguageProfile/);
  assert.match(journeyScreen, /setSpeechRate/);
  assert.match(journeyScreen, /final page = switch \(step\)/);
  assert.match(catalog, /wonderQuestion: _wonderQuestion/);
  assert.match(catalog, /expressQuestion: _expressQuestion/);
  assert.match(catalog, /selectVocabulary/);
});
