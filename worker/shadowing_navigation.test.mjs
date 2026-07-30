import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const homeShell = readFileSync(
  new URL('../app/lib/screens/home_shell.dart', import.meta.url),
  'utf8',
);
const explore = readFileSync(
  new URL('../app/lib/screens/explore_screen.dart', import.meta.url),
  'utf8',
);
const training = readFileSync(
  new URL('../app/lib/screens/shadowing_training_screen.dart', import.meta.url),
  'utf8',
);

test('shadowing is a fixed navigation tab immediately after passport', () => {
  const passport = homeShell.indexOf("label: state.displayText('护照')");
  const shadowing = homeShell.indexOf("label: state.displayText('跟读训练')");
  const profile = homeShell.indexOf("label: state.displayText('我的')");

  assert.ok(passport >= 0);
  assert.ok(shadowing > passport);
  assert.ok(profile > shadowing);
  assert.match(homeShell, /ShadowingTrainingScreen\(embedded: true\)/);
});

test('explore page no longer carries an inline shadowing shortcut', () => {
  assert.doesNotMatch(explore, /home-shadowing-training-entry/);
  assert.doesNotMatch(explore, /_ShadowingHomeEntry/);
});

test('shadowing offers slow, clear, and natural demonstration speeds', () => {
  assert.match(training, /shadowing-speed-control/);
  assert.match(training, /\('慢速', \.7\)/);
  assert.match(training, /\('清晰', \.9\)/);
  assert.match(training, /\('原速', 1\.0\)/);
  assert.match(training, /_narration\.setSpeechRate\(rate\)/);
});

test('shadowing completion routes low-scoring sentences into focused review', () => {
  assert.match(training, /_weakSentenceIndexes/);
  assert.match(training, /shadowing-review-weak-sentences/);
  assert.match(training, /重练 \$\{weakSentences\.length\} 个薄弱句/);
  assert.match(training, /薄弱句复练 \$\{_reviewPosition \+ 1\}/);
  assert.match(training, /更新后的本篇平均分/);
});

test('shadowing uses Phoenix visual surfaces and updates immediately with level changes', () => {
  assert.match(training, /PhoenixLevelController\.instance\.addListener\(_handleLevelChange\)/);
  assert.match(training, /PhoenixLevelController\.instance\.removeListener\(_handleLevelChange\)/);
  assert.match(training, /shadowing-premium-hero/);
  assert.match(training, /shadowing-level-passages-\$level/);
  assert.match(training, /_ShadowingBackground/);
  assert.match(training, /phoenix-shadowing-original-background/);
});

test('shadowing uses original Phoenix training art and layered action buttons', () => {
  assert.match(training, /phoenixShadowingTrainingBackgroundBytes/);
  assert.match(training, /phoenix-shadowing-original-background/);
  assert.match(training, /_shadowingListenButtonStyle/);
  assert.match(training, /开始跟读 · 让声音带你前进/);
  assert.match(training, /BoxShadow\(\s*color:\s*Color\(0x4D7A201B\)/s);
});

test('shadowing keeps compact translucent panels so original art remains visible', () => {
  assert.match(training, /Color\(0x00FFF5DE\)/);
  assert.match(training, /Colors\.white\.withValues\(alpha: \.18\)/);
  assert.match(training, /Colors\.white\.withValues\(alpha: \.30\)/);
  assert.doesNotMatch(training, /for \(final session in history\.recentSessions\.take\(3\)\)/);
});

test('shadowing exposes three diagnostic metrics and focused retry controls', () => {
  assert.match(training, /shadowing-diagnostic-metrics/);
  assert.match(training, /shadowing-metric-accuracy/);
  assert.match(training, /shadowing-metric-completeness/);
  assert.match(training, /shadowing-metric-fluency/);
  assert.match(training, /shadowing-issue-counts/);
  assert.match(training, /shadowing-retry-weakness/);
  assert.match(training, /针对\$\{score!\.weakestMetric\}再练一次/);
});
