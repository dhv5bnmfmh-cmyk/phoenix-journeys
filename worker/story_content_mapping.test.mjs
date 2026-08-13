import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const challengeSource = readFileSync(
  new URL('../app/lib/widgets/journey_challenge_panel.dart', import.meta.url),
  'utf8',
);

test('Suzhou, Guangzhou, and Hangzhou grammar mappings use current Journey content', () => {
  const required = [
    'suzhou-humble-administrators-garden',
    '长廊转弯、曲桥和池水',
    '共同兴建与陈氏书院匾额',
    '断桥残雪、湿石阶和预约卡',
  ];
  for (const value of required) assert.match(challengeSource, new RegExp(value));

  const activeMappings = challengeSource.slice(
    challengeSource.indexOf("'hangzhou-west-lake' => ("),
    challengeSource.indexOf("'literary-roaming' => ("),
  );
  for (const stale of ['屋脊陶塑和木石雕刻', '苏堤、桥与远山', '通过参观这里']) {
    assert.doesNotMatch(activeMappings, new RegExp(stale));
  }
});

test('three corrected Journeys use current Story facts in missing-sentence options', () => {
  for (const anchor of [
    '方毓把预约卡收回包里',
    '周绍庭答对全部景名',
    '陈秀仪把镜头转向刘嘉禾',
    '刘嘉禾戴上红围巾',
    '程朗第一次消失后',
    '陈玉兰说完“下一处等我”',
  ]) {
    assert.match(challengeSource, new RegExp(anchor));
  }
  for (const stale of [
    '苏堤和白堤远离湖面',
    '屋脊装饰全部来自现代印刷',
  ]) {
    assert.doesNotMatch(challengeSource, new RegExp(stale));
  }
});
