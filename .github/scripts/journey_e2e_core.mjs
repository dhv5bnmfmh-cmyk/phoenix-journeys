import {
  activateSemantic,
  assertTargetLevel,
  clean,
  currentLevel,
  currentStage,
  recordText,
  records,
  setLevel,
  sleep,
  visibleText,
  waitStableStage,
} from './flutter_semantics_live.mjs';

export async function enableSemantics(page) {
  const deadline = Date.now() + 60000;
  while (Date.now() <= deadline) {
    const placeholder = page.locator('flt-semantics-placeholder').first();
    if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
    if (await page.locator('flt-semantics').count()) return;
    await sleep(100);
  }
  throw new Error('Flutter semantics did not become available');
}

export async function startup(page, url, label) {
  const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
  if (!response?.ok()) throw new Error(`${label} HTTP load failed: ${response?.status()}`);
  await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 45000 });
  await enableSemantics(page);
}

export function attachDiagnostics(page, label) {
  const pageErrors = [];
  const failedRequests = [];
  const consoleMessages = [];
  page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
  page.on('requestfailed', (request) => {
    failedRequests.push(`${request.method()} ${request.url()} :: ${request.failure()?.errorText || 'failed'}`);
  });
  page.on('console', (message) => consoleMessages.push(`${message.type()}: ${message.text()}`));
  return {
    assertNoBlockingError(context) {
      if (pageErrors.length) throw new Error(`${context}: page error: ${pageErrors.join(' | ')}`);
      const blocking = consoleMessages.find((entry) => /Uncaught|Unhandled|TypeError|ReferenceError|failed to start/i.test(entry));
      if (blocking) throw new Error(`${context}: blocking console: ${blocking}`);
    },
    async dump(reason) {
      console.error(`E2E DIAGNOSTICS [${label}] ${reason}`);
      console.error(`URL=${page.url()}`);
      console.error(`LEVEL=${await currentLevel(page).catch(() => 'unknown')}`);
      console.error(`STAGE=${await currentStage(page).catch(() => 'unknown')}`);
      console.error(`SEMANTICS=${(await visibleText(page).catch(() => '')).slice(0, 18000)}`);
      console.error(`PAGE_ERRORS=${JSON.stringify(pageErrors)}`);
      console.error(`FAILED_REQUESTS=${JSON.stringify(failedRequests)}`);
    },
    assertNoBlockingRequests() {
      const blocking = failedRequests.filter((entry) => !/favicon|analytics/i.test(entry));
      if (blocking.length) throw new Error(`blocking failed requests: ${blocking.join(' | ')}`);
    },
  };
}

export async function openForbiddenCity(page, mode) {
  await activateSemantic(page, { role: 'button', prefix: '选择城市' }, { mode });
  await waitForVisible(page, '选择城市与地点');
  await activateSemantic(page, { role: 'button', includes: '北京' }, { mode });
  await waitForVisible(page, '北京的地点');
  await activateSemantic(page, { role: 'button', includes: '紫禁城' }, { mode });
  await waitForStageOne(page, mode);
}

export async function openXianViaPassport(page, mode) {
  await activateSemantic(page, { role: 'button', exact: '护照' }, { mode });
  await waitForVisible(page, '探索护照');
  await activateSemantic(page, { role: 'button', exact: '中国' }, { mode });
  await waitForVisible(page, '请从左侧选择省份');
  await activateSemantic(page, { role: 'button', includes: '陕西省' }, { mode });
  await waitForVisible(page, '请从左侧选择城市');
  await activateSemantic(page, { role: 'button', includes: '西安' }, { mode });
  await waitForVisible(page, '陕西省，西安市');
  await activateSemantic(page, { role: 'button', includes: '西安城墙' }, { mode });
  await waitForStageOne(page, mode);
}

async function waitForStageOne(page, mode) {
  const deadline = Date.now() + 30000;
  while (Date.now() <= deadline) {
    if (await currentStage(page).catch(() => null) === 1) return;
    const home = await visibleText(page).catch(() => '');
    for (const action of ['开始', '继续', '再次探索']) {
      if (home.includes(action)) {
        try {
          await activateSemantic(page, { role: 'button', prefix: action }, { mode, timeout: 800, retries: 1 });
        } catch (_) {}
        break;
      }
    }
    await sleep(100);
  }
  throw new Error('Journey did not open at Story stage');
}

export async function waitForVisible(page, needle, timeout = 20000) {
  const deadline = Date.now() + timeout;
  while (Date.now() <= deadline) {
    if ((await visibleText(page)).includes(needle)) return;
    await sleep(100);
  }
  throw new Error(`semantic text not found: ${needle}`);
}

export function requireMarkers(text, markers, label) {
  for (const marker of markers) {
    if (!text.includes(marker)) throw new Error(`${label} missing marker: ${marker}`);
  }
}

export function requireAnyMarker(text, markers, label) {
  if (!markers.some((marker) => text.includes(marker))) {
    throw new Error(`${label} missing all allowed markers: ${markers.join(' | ')}`);
  }
}

export async function verifyReadingAnnotation(page, targetLevel, mode, expected = {}) {
  await assertTargetLevel(page, targetLevel, `Lv${targetLevel} before ReadingAnnotation`);
  await activateSemantic(page, { role: 'button', exact: '注' }, { mode });
  await waitForVisible(page, '故事第 1 段');
  const support = await visibleText(page);
  requireMarkers(support, ['拼音', '探索者母语 · 越南语', 'English'], `Lv${targetLevel} ReadingAnnotation structure`);
  if (expected.pinyin) requireAnyMarker(support, expected.pinyin, `Lv${targetLevel} Pinyin identity`);
  if (expected.vietnamese) requireAnyMarker(support, expected.vietnamese, `Lv${targetLevel} Vietnamese identity`);
  if (expected.english) requireAnyMarker(support, expected.english, `Lv${targetLevel} English identity`);

  try {
    await activateSemantic(page, { role: 'button', exact: 'Dismiss' }, { mode, timeout: 2000, retries: 2 });
  } catch (_) {
    await page.keyboard.press('Escape');
  }
  const deadline = Date.now() + 5000;
  while (Date.now() <= deadline) {
    if (!(await visibleText(page)).includes('故事第 1 段')) break;
    await sleep(100);
  }
  await waitStableStage(page, 1, targetLevel, { mode });
}

function traceVocabulary(story, vocabulary) {
  const ignore = new Set(['故事', '单词', '发现', '挑战', '继续', '返回', '朗读', '查看', '中文难度', '重点词汇']);
  const words = [...new Set(vocabulary.match(/[\u3400-\u9fff]{2,8}/g) ?? [])];
  return words.filter((word) => !ignore.has(word) && story.includes(word));
}

export async function storyToVocabulary(page, level, story, mode) {
  await activateSemantic(page, { role: 'button', prefix: '继续' }, { mode });
  await waitStableStage(page, 2, level, { mode });
  const text = await visibleText(page);
  const traced = traceVocabulary(story, text);
  if (!traced.length) throw new Error(`Lv${level} Vocabulary has no visible current-level Story trace`);
  return text;
}

export async function vocabularyToDiscovery(page, level, mode) {
  await activateSemantic(page, { role: 'button', prefix: '继续' }, { mode });
  await waitStableStage(page, 3, level, { mode });
  return visibleText(page);
}

export function assertDiscoveryCorpus(text, { level, expectedDepth, anchors }) {
  const countNeedle = `${expectedDepth} 段`;
  if (!text.includes(countNeedle)) {
    throw new Error(`Lv${level} Discovery missing rendered canonical depth ${expectedDepth}`);
  }
  requireMarkers(text, anchors, `Lv${level} Discovery whole-stage corpus`);
}

export async function discoveryToChallenge(page, level, mode) {
  await assertTargetLevel(page, level, `Lv${level} Discovery before transition`);
  await activateSemantic(page, { role: 'button', prefix: '继续' }, { mode });
  await waitStableStage(page, 4, level, { mode });
  await waitForVisible(page, '提交第 1 / 3 次答案');
}

function targetIdentity(record) {
  const label = clean(record.label);
  return label ? { role: record.role, exact: label } : { role: record.role, exact: recordText(record) };
}

async function ensureGrammarSegment(page, mode, level) {
  const text = await visibleText(page);
  if (!text.includes('第一步 · 点击有问题的部分')) return;
  const candidates = (await records(page)).filter(
    (record) => record.visible && !record.disabled && record.role === 'checkbox' && /[\u3400-\u9fff]/.test(recordText(record)),
  );
  if (!candidates.length) throw new Error('grammar repair segment selector not found');
  await activateSemantic(page, targetIdentity(candidates[0]), { mode });
  await assertTargetLevel(page, level, `Lv${level} grammar segment action`);
}

async function requiredChallengeSelections(page) {
  const text = await visibleText(page);
  const match = text.match(/依次点击\s*(\d+)\s*句/);
  return match ? Number(match[1]) : 1;
}

async function challengeTargets(page) {
  const items = await records(page);
  const lettered = items.filter((record) => {
    if (!record.visible || record.disabled) return false;
    return /^[A-D]\s/.test(clean(record.label)) && /[\u3400-\u9fff]/.test(clean(record.label));
  });
  if (lettered.length) return lettered;
  const excluded = [
    '提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项', '继续留下回忆',
    '完成挑战后继续', '返回', 'Back', '查看 Lv.', '提高当前难度', '降低当前难度',
    '短文复原', '语病修复', '补回句子', '简 / 繁', '声线', '减速', '加速', '提示',
  ];
  return items.filter((record) => {
    if (!record.visible || record.disabled || !['button', 'group', 'checkbox'].includes(record.role)) return false;
    const text = recordText(record);
    return text.length >= 4 && /[\u3400-\u9fff]/.test(text) && !excluded.some((entry) => text.includes(entry));
  }).sort((left, right) => right.area - left.area);
}

async function chooseChallengeOptions(page, level, mode) {
  await ensureGrammarSegment(page, mode, level);
  const count = await requiredChallengeSelections(page);
  const targets = await challengeTargets(page);
  if (targets.length < count) throw new Error(`only ${targets.length} challenge options found; need ${count}`);
  for (const record of targets.slice(0, count)) {
    await activateSemantic(page, targetIdentity(record), { mode });
    await assertTargetLevel(page, level, `Lv${level} challenge option`);
  }
}

export async function completeChallenge(page, level, mode) {
  for (let challengeMode = 0; challengeMode < 3; challengeMode += 1) {
    let resolved = false;
    for (let attempt = 1; attempt <= 3; attempt += 1) {
      await chooseChallengeOptions(page, level, mode);
      await activateSemantic(page, { role: 'button', prefix: '提交第' }, { mode });
      await assertTargetLevel(page, level, `Lv${level} challenge submit`);
      await sleep(350);
      const text = await visibleText(page);
      if (text.includes('进入下一种挑战')) {
        await activateSemantic(page, { role: 'button', exact: '进入下一种挑战' }, { mode });
        await assertTargetLevel(page, level, `Lv${level} next challenge mode`);
        await waitForVisible(page, '提交第 1 / 3 次答案');
        resolved = true;
        break;
      }
      if (text.includes('完成三连挑战')) {
        await activateSemantic(page, { role: 'button', exact: '完成三连挑战' }, { mode });
        await assertTargetLevel(page, level, `Lv${level} challenge completion`);
        await waitForVisible(page, '继续留下回忆');
        resolved = true;
        break;
      }
      if (attempt < 3) await waitForVisible(page, `提交第 ${attempt + 1} / 3 次答案`);
    }
    if (!resolved) throw new Error(`Lv${level} challenge mode ${challengeMode + 1} did not resolve`);
    if ((await visibleText(page)).includes('继续留下回忆')) break;
  }
  await waitForVisible(page, '继续留下回忆');
}

export async function challengeToMemory(page, level, mode) {
  await activateSemantic(page, { role: 'button', prefix: '继续留下回忆' }, { mode });
  await waitStableStage(page, 5, level, { mode });
  return visibleText(page);
}

export async function memoryToCompletion(page, level, mode) {
  await activateSemantic(page, { role: 'button', prefix: '结束旅程' }, { mode });
  await waitStableStage(page, 6, level, { mode });
  await waitForVisible(page, '已点亮');
  return visibleText(page);
}

export async function prepareLevel(page, level, mode) {
  await waitStableStage(page, 1, await currentLevel(page), { mode });
  await setLevel(page, level, { mode });
  await waitStableStage(page, 1, level, { mode });
}
