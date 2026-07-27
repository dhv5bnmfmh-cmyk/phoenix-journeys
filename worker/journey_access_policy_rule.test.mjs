import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const policy = readFileSync(
  'app/lib/services/journey_access_policy.dart',
  'utf8',
);
const workflow = readFileSync('docs/development-workflow.md', 'utf8');
const prTemplate = readFileSync('.github/pull_request_template.md', 'utf8');

test('development and paid explorers keep all journeys open', () => {
  assert.match(policy, /developmentExperience/);
  assert.match(policy, /productionPaidExplorer/);
  assert.match(policy, /allJourneyIds\.toSet\(\)/);
  assert.match(workflow, /开发分支、PR 独立体验版和内部验收环境必须开放全部已发布旅程/);
  assert.match(workflow, /付费探索者可以打开全部已发布旅程/);
});

test('free explorers receive stable random morning and afternoon journeys', () => {
  assert.match(policy, /JourneyReleaseSlot \{ morning, afternoon \}/);
  assert.match(policy, /explorerSeed\|\$dateKey\|morning/);
  assert.match(policy, /explorerSeed\|\$dateKey\|afternoon/);
  assert.match(policy, /if \(afternoonIndex == morningIndex\)/);
  assert.match(workflow, /早上释放一段，下午再释放一段/);
  assert.match(workflow, /刷新、重启或重新登录不得重新抽取/);
  assert.match(workflow, /同一天早上与下午的旅程不得重复/);
});

test('journey access remains configurable and centralized', () => {
  assert.match(workflow, /统一经过 `JourneyAccessPolicy` 判断/);
  assert.match(workflow, /具体早上和下午的钟点、价格、试用期、重复回避周期与促销方案必须保留为可配置商业策略/);
  assert.match(prTemplate, /免费、付费与随机旅程权限统一经过 `JourneyAccessPolicy`/);
  assert.match(prTemplate, /开发分支与 PR 体验版保持全部旅程开放/);
});
