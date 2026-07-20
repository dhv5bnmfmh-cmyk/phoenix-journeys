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

test('Phoenix speed range is permanently limited to 0.5x through 1.5x', () => {
  assert.match(controller, /NarrationSpeedOption\(label: '0\.5×', rate: \.5\)/);
  assert.match(controller, /NarrationSpeedOption\(label: '1\.5×', rate: 1\.5\)/);
  assert.doesNotMatch(controller, /NarrationSpeedOption\(label: '1\.75×'/);
  assert.doesNotMatch(controller, /NarrationSpeedOption\(label: '2\.0×'/);
  assert.match(controller, /multiplier\.clamp\(0\.5, 1\.5\)/);
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
  assert.match(controller, /List<NarrationController>\.of\(_instances\)/);
  assert.match(controller, /controller\._applySharedSpeechRate\(option\.rate\)/);
  assert.match(controller, /resumeFromOffset\(resumeOffset\)/);
  assert.match(controller, /_instances\.remove\(this\)/);
});

test('permanent documents and pull requests enforce the same speed rule', () => {
  assert.match(processDoc, /0\.5×–1\.5×/);
  assert.match(processDoc, /速度数字下方必须固定显示“减速”和“加速”/);
  assert.match(processDoc, /所有现有与之后打开的朗读入口必须立刻同步/);
  assert.match(template, /0\.5×–1\.5×/);
  assert.match(template, /减速 \/ 加速/);
  assert.match(template, /全部朗读入口同步同一倍率/);
});
