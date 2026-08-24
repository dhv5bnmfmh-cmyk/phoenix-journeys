import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');
const processDoc = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');
const controller = read('app/lib/services/narration_controller.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const player = read('app/lib/widgets/narration_player_card.dart');

const permanentRule = '永久朗读开发准则';

test('Phoenix permanently documents the native-speed narration contract', () => {
  assert.match(processDoc, new RegExp(permanentRule));
  assert.match(processDoc, /默认倍率固定为 `1\.0×`/);
  assert.match(processDoc, /用户可调范围固定为 `0\.5×–1\.5×`/);
  assert.match(processDoc, /简体中文使用 `zh-CN`/);
  assert.match(processDoc, /繁体中文使用 `zh-TW`/);
  assert.match(processDoc, /英文使用 `en-US`/);
  assert.match(processDoc, /越南语使用 `vi-VN`/);
  assert.match(processDoc, /所有朗读必须共用 `NarrationController`/);
  assert.match(processDoc, /声音、进度条、百分比、当前段落和字符三角形必须同步/);
  assert.match(processDoc, /临时朗读结束后.*从该位置自动继续/);
});

test('pull requests delegate specialist narration rules to canonical governance', () => {
  assert.match(template, /Single entry contract: `docs\/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT\.md`/);
  assert.match(template, /Do not copy old checklists into this PR/);
  assert.match(template, /Desktop required levels\/stages/);
  assert.match(template, /pageErrors \/ failedRequests blocking defects/);
});

test('runtime keeps native speed, locale and one synchronized controller', () => {
  assert.match(controller, /static const double nativeDefaultRate = 1\.0/);
  assert.match(controller, /NarrationSpeedOption\(label: '0\.5×', rate: \.5\)/);
  assert.match(controller, /NarrationSpeedOption\(label: '1\.5×', rate: 1\.5\)/);
  assert.doesNotMatch(controller, /1\.75×|2\.0×/);
  assert.match(controller, /Future<bool> speakTemporaryText/);
  assert.match(controller, /resumeFromOffset\(resumeOffset\)/);
  assert.match(journey, /languageCode: _appState\.isTraditional \? 'zh-TW' : 'zh-CN'/);
  assert.match(journey, /'en-US'/);
  assert.match(journey, /'vi-VN'/);
  assert.match(player, /The controller is the single source of truth/);
});
