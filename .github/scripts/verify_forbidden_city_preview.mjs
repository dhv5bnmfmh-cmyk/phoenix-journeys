import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium } = playwrightModule;

const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) {
  throw new Error('usage: verify_forbidden_city_preview.mjs <preview-url> <source-sha>');
}

const targetLevels = [1, 3, 5, 8, 10];
const levelStoryMarkers = new Map([
  [1, ['十七岁的营造学徒沈砚', '阿宁', '午门', '乾清门']],
  [3, ['沈砚', '阿宁', '判断', '乾清门']],
  [5, ['沈砚', '阿宁', '证据', '景运门']],
  [8, ['沈砚', '阿宁', '视角', '路线']],
  [10, ['沈砚', '阿宁', '共同空间骨架', '成立条件']],
]);
const levelDiscoveryMarkers = new Map([
  [1, ['午门', '中轴', '乾清门']],
  [3, ['宫门', '院落']],
  [5, ['景运门', '东']],
  [8, ['视角', '事实']],
  [10, ['建筑', '任务']],
]);

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const normalize = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function semanticRecords(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.map((element, index) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    const visible = rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden';
    return {
      index,
      role: element.getAttribute('role'),
      label: element.getAttribute('aria-label') || '',
      value: element.getAttribute('aria-valuetext') || '',
      description: element.getAttribute('aria-description') || '',
      text: String(element.textContent || '').replace(/\s+/g, ' ').trim(),
      disabled: element.getAttribute('aria-disabled') === 'true',
      visible,
      rect: [rect.x, rect.y, rect.width, rect.height],
    };
  }));
}

function recordText(record) {
  return normalize([record.label, record.value, record.description, record.text].filter(Boolean).join(' '));
}

async function semanticNode(page, matcher, {
  timeout = 15000,
  role = null,
  mode = 'contains',
  visible = true,
} = {}) {
  const wanted = normalize(matcher);
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const records = await semanticRecords(page);
    const candidates = records.filter((record) => {
      if (visible && !record.visible) return false;
      if (role && record.role !== role) return false;
      const text = recordText(record);
      if (mode === 'equals') return text === wanted;
      if (mode === 'prefix') return text.startsWith(wanted);
      return text.includes(wanted);
    });
    const candidate = candidates[0];
    if (candidate) return page.locator('flt-semantics').nth(candidate.index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${matcher}`);
}

async function semanticExists(page, matcher, options = {}) {
  try {
    await semanticNode(page, matcher, { ...options, timeout: options.timeout ?? 500 });
    return true;
  } catch (_) {
    return false;
  }
}

async function tapSemantic(page, matcher, {
  role = null,
  mode = 'contains',
  timeout = 15000,
} = {}) {
  const node = await semanticNode(page, matcher, { role, mode, timeout });
  const disabled = await node.getAttribute('aria-disabled');
  if (disabled === 'true') throw new Error(`semantic action disabled: ${matcher}`);
  await node.tap({ timeout });
  return node;
}

async function enableFlutterSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 20000 });
}

async function visibleSemanticText(page) {
  const records = await semanticRecords(page);
  return records.filter((record) => record.visible).map(recordText).filter(Boolean).join('\n');
}

async function assertNoRuntimeError(page, pageErrors, label) {
  const bodyText = await page.locator('body').innerText().catch(() => '');
  const semantics = await visibleSemanticText(page).catch(() => '');
  const combined = `${bodyText}\n${semantics}`;
  const forbidden = [
    'Bad state: Forbidden City Challenge requires an exact locked Lv1-Lv10 Story binding.',
    'A RenderFlex overflowed',
    'Unhandled Exception',
  ];
  for (const message of forbidden) {
    if (combined.includes(message)) throw new Error(`${label}: runtime failure visible: ${message}`);
  }
  if (pageErrors.length > 0) {
    throw new Error(`${label}: pageerror: ${pageErrors.join(' | ')}`);
  }
}

async function waitForHome(page) {
  await semanticNode(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
  for (const prefix of ['开始', '继续', '再次探索']) {
    if (await semanticExists(page, prefix, { mode: 'prefix', timeout: 1200 })) return;
  }
  throw new Error('Home journey action not available');
}

async function selectForbiddenCity(page) {
  await tapSemantic(page, '选择城市', { mode: 'prefix' });
  await semanticNode(page, '选择城市与地点', { timeout: 15000 });
  await tapSemantic(page, '北京', { timeout: 15000 });
  await semanticNode(page, '北京的地点', { timeout: 15000 });
  await tapSemantic(page, '紫禁城', { timeout: 15000 });
  await waitForHome(page);
  await semanticNode(page, '紫禁城', { timeout: 15000 });
}

async function currentLevel(page) {
  const records = await semanticRecords(page);
  for (const record of records) {
    if (!record.visible) continue;
    const match = recordText(record).match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  throw new Error('Phoenix level semantics not found');
}

async function setLevel(page, target) {
  let current = await currentLevel(page);
  let guard = 0;
  while (current !== target && guard++ < 12) {
    await tapSemantic(page, current < target ? '提高当前难度' : '降低当前难度', { mode: 'prefix', timeout: 10000 });
    const previous = current;
    for (let i = 0; i < 30; i += 1) {
      await sleep(100);
      current = await currentLevel(page);
      if (current !== previous) break;
    }
    if (current === previous) throw new Error(`level did not change from ${previous}`);
  }
  if (current !== target) throw new Error(`failed to set Phoenix level ${target}; current=${current}`);
  console.log(`Lv${target} LEVEL SELECTOR = PASS`);
}

async function openJourney(page) {
  for (const prefix of ['开始', '继续', '再次探索']) {
    if (await semanticExists(page, prefix, { mode: 'prefix', timeout: 1000 })) {
      await tapSemantic(page, prefix, { mode: 'prefix' });
      await semanticNode(page, '1/6', { mode: 'prefix', timeout: 25000 });
      return;
    }
  }
  throw new Error('no journey open action');
}

async function assertLevel(page, target, stage) {
  const level = await currentLevel(page);
  if (level !== target) throw new Error(`Lv${target} ${stage}: level drifted to ${level}`);
}

function assertContainsAll(text, markers, label) {
  for (const marker of markers) {
    if (!text.includes(marker)) throw new Error(`${label}: missing marker ${marker}`);
  }
}

function vocabularyTrace(storyText, vocabText) {
  const ignored = new Set([
    '故事', '单词', '发现', '挑战', '旅程回忆', '北京已点亮', '继续', '返回', '朗读',
    '重点词汇', '中文难度', '查看', '提高当前难度', '降低当前难度', 'PHOENIX', 'JOURNEYS',
  ]);
  const tokens = new Set(vocabText.match(/[\u3400-\u9fff]{2,8}/g) ?? []);
  return [...tokens].filter((token) => !ignored.has(token) && storyText.includes(token));
}

async function goToVocabulary(page, level, storyText) {
  await tapSemantic(page, '继续', { mode: 'prefix' });
  await sleep(500);
  if (!(await semanticExists(page, '2/6', { mode: 'prefix', timeout: 500 }))) {
    await page.touchscreen.tap(22, 58);
  }
  await semanticNode(page, '2/6', { mode: 'prefix', timeout: 15000 });
  await assertLevel(page, level, 'Vocabulary');
  const vocabText = await visibleSemanticText(page);
  const traced = vocabularyTrace(storyText, vocabText);
  if (traced.length === 0) throw new Error(`Lv${level} Vocabulary: no visible word traces to same-level Story`);
  console.log(`Lv${level} VOCABULARY = PASS | story trace: ${traced.slice(0, 4).join(', ')}`);
}

async function goToDiscovery(page, level) {
  await tapSemantic(page, '继续', { mode: 'prefix' });
  await semanticNode(page, '3/6', { mode: 'prefix', timeout: 15000 });
  await assertLevel(page, level, 'Discovery');
  const text = await visibleSemanticText(page);
  assertContainsAll(text, levelDiscoveryMarkers.get(level), `Lv${level} Discovery`);
  console.log(`Lv${level} DISCOVERY = PASS`);
}

async function goToChallenge(page, level) {
  await tapSemantic(page, '继续', { mode: 'prefix' });
  await semanticNode(page, '4/6', { mode: 'prefix', timeout: 15000 });
  await assertLevel(page, level, 'Challenge');
  await semanticNode(page, '提交第 1 / 3 次答案', { mode: 'prefix', timeout: 15000 });
  console.log(`Lv${level} CHALLENGE RENDER = PASS`);
}

const challengeControlFragments = [
  '提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项', '继续留下回忆',
  '完成挑战后继续', '返回', '查看 Lv.', '提高当前难度', '降低当前难度',
  '段落重组', '语法修复', '补回句子',
];

async function visibleChallengeOptionNodes(page) {
  const records = await semanticRecords(page);
  const candidates = records.filter((record) => {
    if (!record.visible || record.role !== 'button' || record.disabled) return false;
    const text = recordText(record);
    if (!text || text.length < 8) return false;
    if (challengeControlFragments.some((fragment) => text.includes(fragment))) return false;
    return /[\u3400-\u9fff]/.test(text);
  });
  candidates.sort((a, b) => recordText(b).length - recordText(a).length);
  return candidates.map((record) => page.locator('flt-semantics').nth(record.index));
}

async function submitAvailable(page) {
  const records = await semanticRecords(page);
  return records.some((record) => record.visible && record.role === 'button' && !record.disabled && recordText(record).startsWith('提交第'));
}

async function selectChallengeAnswer(page, modeIndex) {
  const needed = modeIndex === 0 ? 4 : 1;
  const nodes = await visibleChallengeOptionNodes(page);
  if (nodes.length < needed) {
    throw new Error(`challenge mode ${modeIndex + 1}: only ${nodes.length} candidate options found`);
  }
  let taps = 0;
  for (const node of nodes) {
    if (taps >= needed) break;
    await node.tap({ timeout: 10000 });
    taps += 1;
  }
  if (!(await submitAvailable(page))) {
    throw new Error(`challenge mode ${modeIndex + 1}: submit stayed disabled after ${taps} option taps`);
  }
}

async function solveChallengeMode(page, modeIndex) {
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    await selectChallengeAnswer(page, modeIndex);
    await tapSemantic(page, '提交第', { mode: 'prefix', timeout: 10000 });
    await sleep(350);
    if (await semanticExists(page, '进入下一种挑战', { timeout: 500 })) {
      await tapSemantic(page, '进入下一种挑战', { timeout: 10000 });
      return;
    }
    if (await semanticExists(page, '完成三连挑战', { timeout: 500 })) {
      await tapSemantic(page, '完成三连挑战', { timeout: 10000 });
      return;
    }
  }
  throw new Error(`challenge mode ${modeIndex + 1}: did not resolve after three submissions`);
}

async function completeChallenge(page, level) {
  for (let modeIndex = 0; modeIndex < 3; modeIndex += 1) {
    await solveChallengeMode(page, modeIndex);
    await sleep(250);
  }
  await semanticNode(page, '继续留下回忆', { mode: 'prefix', timeout: 15000 });
  console.log(`Lv${level} CHALLENGE COMPLETE = PASS`);
}

async function goToMemory(page, level) {
  await tapSemantic(page, '继续留下回忆', { mode: 'prefix' });
  await semanticNode(page, '5/6', { mode: 'prefix', timeout: 15000 });
  await assertLevel(page, level, 'Memory');
  const text = await visibleSemanticText(page);
  if (!text.includes('两条都能走通的路线')) {
    throw new Error(`Lv${level} Memory: canonical anchor missing`);
  }
  console.log(`Lv${level} MEMORY = PASS | 两条都能走通的路线`);
}

async function goToCompletion(page, level) {
  await tapSemantic(page, '结束旅程', { mode: 'prefix' });
  await semanticNode(page, '6/6', { mode: 'prefix', timeout: 15000 });
  await semanticNode(page, '北京已点亮', { timeout: 15000 });
  await assertLevel(page, level, 'Completion');
  const text = await visibleSemanticText(page);
  if (!text.includes('路线') && !text.includes('两条')) {
    throw new Error(`Lv${level} Completion: Forbidden City route closure missing`);
  }
  console.log(`Lv${level} COMPLETION = PASS`);
}

async function exerciseLevel(browser, level) {
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 3,
    isMobile: true,
    hasTouch: true,
    locale: 'zh-CN',
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  const pageErrors = [];
  page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
  page.on('console', (message) => {
    const text = message.text();
    if (message.type() === 'error' && text.includes('Bad state: Forbidden City Challenge')) {
      pageErrors.push(text);
    }
  });

  try {
    const separator = baseUrl.includes('?') ? '&' : '?';
    const url = `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`;
    const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
    if (!response || !response.ok()) throw new Error(`Lv${level}: preview HTTP load failed (${response?.status()})`);
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
    await enableFlutterSemantics(page);
    await waitForHome(page);
    await selectForbiddenCity(page);
    await setLevel(page, level);
    await openJourney(page);
    await assertLevel(page, level, 'Story');

    const storyText = await visibleSemanticText(page);
    assertContainsAll(storyText, levelStoryMarkers.get(level), `Lv${level} Story`);
    console.log(`Lv${level} STORY = PASS`);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Story`);

    await goToVocabulary(page, level, storyText);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Vocabulary`);

    await goToDiscovery(page, level);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Discovery`);

    await goToChallenge(page, level);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Challenge`);
    await completeChallenge(page, level);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Challenge completion`);

    await goToMemory(page, level);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Memory`);

    await goToCompletion(page, level);
    await assertNoRuntimeError(page, pageErrors, `Lv${level} Completion`);

    console.log(`Lv${level} ACTUAL PREVIEW SIX-STAGE = PASS`);
  } catch (error) {
    const snapshot = await semanticRecords(page).catch(() => []);
    console.error(`Lv${level} SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot.slice(0, 160))}`);
    throw error;
  } finally {
    await context.close();
  }
}

const browser = await chromium.launch({ headless: true });
try {
  for (const level of targetLevels) {
    await exerciseLevel(browser, level);
  }
  console.log(`FORBIDDEN CITY ACTUAL PREVIEW E2E = PASS | SHA=${sourceSha} | LEVELS=${targetLevels.join(',')}`);
} finally {
  await browser.close();
}
