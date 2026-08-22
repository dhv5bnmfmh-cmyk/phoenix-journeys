import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('PR118 keeps language level in settings and does not autoplay restored discovery', async () => {
  const [journey, settings] = await Promise.all([
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/screens/me_screen.dart'),
  ]);

  assert.doesNotMatch(journey, /_showDifficultyWelcome/);
  assert.doesNotMatch(journey, /_scheduleDiscoveryAutoStart/);
  assert.match(settings, /settings-language-level/);
  assert.match(settings, /HSK／TOCFL 能力设置/);
});

test('PR118 always presents three sequential four-choice challenge modes', async () => {
  const [journey, challenge] = await Promise.all([
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/widgets/journey_challenge_panel_legacy.dart'),
  ]);

  assert.match(journey, /onAllCompleted/);
  assert.match(challenge, /fixedJourneyChallengeTypes/);
  assert.match(challenge, /JourneyChallengeType\.paragraphRebuild/);
  assert.match(challenge, /JourneyChallengeType\.grammarRepair/);
  assert.match(challenge, /JourneyChallengeType\.missingSentence/);
  assert.match(challenge, /journeyChallengeOptionCount = 4/);
  assert.match(challenge, /options\.length == journeyChallengeOptionCount/);
  assert.match(challenge, /challenge-question-card/);
  assert.match(challenge, /challenge-hint-card/);
  assert.match(challenge, /challenge-answer-area/);
  assert.doesNotMatch(challenge, /challengeTypeForSeed/);
  assert.match(challenge, /attempts >= 3/);
  assert.match(challenge, /1 => '金币'/);
  assert.match(challenge, /2 => '银币'/);
  assert.match(challenge, /_ => '铜币'/);
  assert.match(challenge, /: '碎银'/);
  assert.match(challenge, /病句类型/);
  assert.match(challenge, /为什么错误/);
  for (const errorType of [
    '成分残缺：主语缺失',
    '前后主语与句式不平行',
    '成分赘余：关联词堆叠并导致主语缺失',
  ]) {
    assert.match(challenge, new RegExp(errorType));
  }
  assert.match(challenge, /_adaptiveGrammarForJourney/);
  assert.match(challenge, /return journeySpec/);
  assert.doesNotMatch(challenge, /replayVariant/);
});

test('PR118 registers full cinematic special journeys in the stable flow', async () => {
  const [catalog, location, background, passport, state, home] = await Promise.all([
    read('app/lib/data/special_journey_catalog.dart'),
    read('app/lib/services/journey_location_binding.dart'),
    read('app/lib/widgets/special_realm_background.dart'),
    read('app/lib/widgets/special_journey_passport.dart'),
    read('app/lib/state/app_state.dart'),
    read('app/lib/screens/explore_screen.dart'),
  ]);

  for (const id of [
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    assert.match(catalog, new RegExp(id));
    assert.match(background, new RegExp(id));
    assert.match(passport, new RegExp(id));
  }
  assert.match(catalog, /庄周梦蝶/);
  assert.match(catalog, /月宫遗简/);
  assert.match(catalog, /无影客栈/);
  assert.match(catalog, /逆流河灯/);
  assert.match(location, /allJourneyExperiences/);
  assert.match(passport, /JourneyScreen\(journeyId: journeyId\)/);
  assert.doesNotMatch(passport, /完整章节正在编写中/);
  assert.match(state, /unlockSpecialJourney/);
  assert.match(state, /specialJourney\.unlockedIds/);
  assert.match(home, /home-coin-wallet-hint/);
  assert.match(background, /JourneyBackgroundPage/);
  assert.match(background, /_paintChapterLight/);
});
