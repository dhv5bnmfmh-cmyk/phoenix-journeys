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

test('PR118 exposes the rotating three-attempt challenge pool', async () => {
  const [journey, challenge] = await Promise.all([
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/widgets/journey_challenge_panel.dart'),
  ]);

  assert.match(journey, /JourneyChallengePanel/);
  assert.match(challenge, /JourneyChallengeType\.paragraphRebuild/);
  assert.match(challenge, /JourneyChallengeType\.grammarRepair/);
  assert.match(challenge, /JourneyChallengeType\.missingSentence/);
  assert.match(challenge, /attempts >= 3/);
  assert.match(challenge, /1 => '金币'/);
  assert.match(challenge, /2 => '银币'/);
  assert.match(challenge, /_ => '铜币'/);
  assert.match(challenge, /: '碎银'/);
  assert.match(challenge, /病句类型/);
  assert.match(challenge, /错误位置/);
  assert.match(challenge, /为什么错误/);
  assert.match(challenge, /修改原则/);
  assert.match(challenge, /记忆方法/);
});

test('PR118 persists wallet rewards and permanently unlocks 万象奇旅', async () => {
  const [state, passport, special, home] = await Promise.all([
    read('app/lib/state/app_state.dart'),
    read('app/lib/screens/city_passport_screen.dart'),
    read('app/lib/widgets/special_journey_passport.dart'),
    read('app/lib/screens/explore_screen.dart'),
  ]);

  assert.match(state, /awardChallengeRewardOnce/);
  assert.match(state, /challenge\.awardedIds/);
  assert.match(state, /unlockSpecialJourney/);
  assert.match(state, /specialJourney\.unlockedIds/);
  assert.match(passport, /SpecialJourneyPassport/);
  assert.match(special, /passport-special-journeys/);
  assert.match(special, /万象奇旅 · 特别旅程/);
  assert.match(special, /确认扣币/);
  assert.match(special, /永久收藏/);
  assert.match(home, /home-coin-wallet-hint/);
});
