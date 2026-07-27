import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');
const controller = read('app/lib/services/narration_controller.dart');
const speedControl = read('app/lib/widgets/narration_speed_stepper.dart');
const player = read('app/lib/widgets/narration_player_card.dart');
const wordSheet = read('app/lib/widgets/word_detail_sheet.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const processDoc = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');

test('Phoenix speed range uses exact 0.1 steps from 0.5x through 1.5x', () => {
  const labels = [
    '0.5×', '0.6×', '0.7×', '0.8×', '0.9×', '1.0×',
    '1.1×', '1.2×', '1.3×', '1.4×', '1.5×',
  ];
  assert.match(controller, /static const double speechRateStep = 0\.1/);
  for (const label of labels) {
    assert.ok(controller.includes(`label: '${label}'`));
  }
  assert.doesNotMatch(controller, /0\.75×|1\.25×|1\.75×|2\.0×/);
  assert.match(controller, /multiplier\.clamp\(0\.5, 1\.5\)/);
  assert.match(controller, /speedOptions\[index - 1\]\.rate/);
  assert.match(controller, /speedOptions\[index \+ 1\]\.rate/);
});

test('the current speed has slow-down and speed-up choices directly underneath', () => {
  assert.match(speedControl, /ValueKey\('narration-current-speed'\)/);
  assert.match(speedControl, /label: '减速'/);
  assert.match(speedControl, /label: '加速'/);
  assert.match(speedControl, /ValueKey\('narration-slow-down'\)/);
  assert.match(speedControl, /ValueKey\('narration-speed-up'\)/);
  assert.doesNotMatch(player, /PopupMenuButton<double>/);
  assert.doesNotMatch(wordSheet, /PopupMenuButton<double>/);
  assert.doesNotMatch(journey, /key: const ValueKey\('support-speed-control'\)[\s\S]{0,220}PopupMenuButton/);
});

test('changing speed synchronizes every narration controller and future controller', () => {
  assert.match(controller, /static double _sharedSpeechRate = nativeDefaultRate/);
  assert.match(controller, /static final Set<NarrationController> _instances/);
  assert.match(controller, /_speechRate = _sharedSpeechRate/);
  assert.match(controller, /_instances\.add\(this\)/);
  assert.match(controller, /Future<void> decreaseSpeechRate\(\)/);
  assert.match(controller, /Future<void> increaseSpeechRate\(\)/);
  assert.match(controller, /List<NarrationController>\.of\(_instances\)/);
  assert.match(controller, /controller\._applySharedSpeechRate\(option\.rate\)/);
  assert.match(controller, /final wasPlaying =/);
  assert.match(controller, /resumeFromOffset\(resumeOffset\)/);
  assert.match(controller, /_instances\.remove\(this\)/);
});

test('permanent documents and pull requests enforce the same speed rule', () => {
  assert.match(processDoc, /0\.5×–1\.5×/);
  assert.match(processDoc, /固定只变化 `0\.1×`/);
  assert.match(processDoc, /所有现有与之后打开的朗读入口必须立刻同步/);
  assert.match(template, /每次固定变化 `0\.1×`/);
  assert.match(template, /全部朗读入口同步同一倍率/);
});
