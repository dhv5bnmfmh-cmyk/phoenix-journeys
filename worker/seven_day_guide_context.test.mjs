import test from 'node:test';
import assert from 'node:assert/strict';

import {
  buildGuideMessages,
  getJourneyContext,
} from './agents/phoenix_guide_agent.mjs';

const expectedJourneys = [
  ['beijing-forbidden-city', '北京', '紫禁城'],
  ['shanghai-bund', '上海', '外滩'],
  ['xian-city-wall', '西安', '城墙'],
  ['hangzhou-west-lake', '杭州', '西湖'],
  ['chengdu-kuanzhai-alley', '成都', '宽窄巷子'],
  ['nanjing-qinhuai-river', '南京', '秦淮河'],
  ['guangzhou-chen-clan-academy', '广州', '陈家祠'],
];

test('PhoenixGuideAgent has a distinct grounded context for all seven journeys', () => {
  for (const [journeyId, city, place] of expectedJourneys) {
    const journey = getJourneyContext(journeyId);
    assert.equal(journey.city, city);
    assert.equal(journey.place, place);
    assert.ok(journey.context.length > 40);
    assert.ok(journey.reflection.includes('？'));
  }
});

test('guide messages use the selected journey rather than Beijing fallback', () => {
  for (const [journeyId, city, place] of expectedJourneys) {
    const messages = buildGuideMessages({
      text: '我最想观察建筑和城市生活的关系。',
      language: '越南语',
      journeyId,
    });
    const journeyMessage = messages[1].content;
    assert.match(journeyMessage, new RegExp(`city="${city}"`));
    assert.match(journeyMessage, new RegExp(`place="${place}"`));
  }
});

test('unknown journey ids use a neutral safety context', () => {
  const journey = getJourneyContext('future-city-placeholder');
  assert.equal(journey.city, '当前城市');
  assert.equal(journey.place, '今日目的地');
  assert.doesNotMatch(journey.context, /故宫|紫禁城|北京/);
});
