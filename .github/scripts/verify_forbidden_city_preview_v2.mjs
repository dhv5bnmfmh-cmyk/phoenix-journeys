import { pathToFileURL } from 'node:url';

const { chromium } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_preview_v2.mjs <preview-url> <sha>');

const levels = [1, 3, 5, 8, 10];
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((els) => els.map((el, index) => {
    const r = el.getBoundingClientRect();
    const s = getComputedStyle(el);
    return {
      index,
      role: el.getAttribute('role'),
      label: el.getAttribute('aria-label') || '',
      value: el.getAttribute('aria-valuetext') || '',
      description: el.getAttribute('aria-description') || '',
      text: String(el.textContent || '').replace(/\s+/g, ' ').trim(),
      disabled: el.getAttribute('aria-disabled') === 'true',
      visible: r.width > 0 && r.height > 0 && s.display !== 'none' && s.visibility !== 'hidden',
      area: r.width * r.height,
    };
  }));
}

const recText = (r) => clean([r.label, r.value, r.description, r.text].filter(Boolean).join(' '));

async function findSemantic(page, needle, { role = null, prefix = false, timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  const wanted = clean(needle);
  while (Date.now() < deadline) {
    const rs = await records(page);
    const matches = rs.filter((r) => {
      if (!r.visible || (role && r.role !== role)) return false;
      const text = recText(r);
      return prefix ? text.startsWith(wanted) : text.includes(wanted);
    }).sort((a, b) => {
      if (a.role === 'button' && b.role !== 'button') return -1;
      if (b.role === 'button' && a.role !== 'button') return 1;
      return a.area - b.area;
    });
    if (matches.length) return page.locator('flt-semantics').nth(matches[0].index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function exists(page, needle, options = {}) {
  try {
    await findSemantic(page, needle, { ...options, timeout: options.timeout ?? 500 });
    return true;
  } catch (_) {
    return false;
  }
}

async function tapButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if ((await node.getAttribute('aria-disabled')) === 'true') throw new Error(`button disabled: ${needle}`);
  await node.tap({ timeout });
}

async function visibleText(page) {
  return (await records(page)).filter((r) => r.visible).map(recText).filter(Boolean).join('\n');
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((el) => el.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

async function currentLevel(page) {
  const rs = await records(page);
  for (const r of rs) {
    if (!r.visible) continue;
    const m = recText(r).match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (m) return Number(m[1]);
  }
  throw new Error('Phoenix level selector not found');
}

async function setLevel(page, target) {
  let level = await currentLevel(page);
  for (let guard = 0; level !== target && guard < 12; guard += 1) {
    const before = level;
    await tapButton(page, level < target ? '提高当前难度' : '降低当前难度', { prefix: true });
    for (let i = 0; i < 40; i += 1) {
      await sleep(100);
      level = await currentLevel(page);
      if (level !== before) break;
    }
    if (level === before) throw new Error(`level selector did not move from ${before}`);
  }
  if (level !== target) throw new Error(`failed to select Lv${target}; current Lv${level}`);
}

async function waitStage(page, n) {
  await findSemantic(page, `${n}/6`, { prefix: true, timeout: 20000 });
}

async function openForbiddenCity(page) {
  if (await exists(page, '北京 · 紫禁城', { timeout: 600 })) {
    if (!(await exists(page, '1/6', { prefix: true, timeout: 600 }))) {
      throw new Error('Forbidden City title is visible without Story stage');
    }
    return;
  }

  await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
  await tapButton(page, '选择城市', { prefix: true });
  await findSemantic(page, '选择城市与地点', { timeout: 15000 });
  await tapButton(page, '北京');
  await findSemantic(page, '北京的地点', { timeout: 15000 });
  await tapButton(page, '紫禁城');

  for (let i = 0; i < 100; i += 1) {
    if (await exists(page, '1/6', { prefix: true, timeout: 120 })) return;
    if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 120 })) break;
    await sleep(100);
  }

  if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 1000 })) {
    for (const action of ['开始', '继续', '再次探索']) {
      if (await exists(page, action, { role: 'button', prefix: true, timeout: 700 })) {
        await tapButton(page, action, { prefix: true });
        await waitStage(page, 1);
        return;
      }
    }
  }
  throw new Error('Forbidden City did not open after destination selection');
}

function requireStoryIdentity(text, level) {
  for (const marker of ['沈砚', '阿宁']) {
    if (!text.includes(marker)) throw new Error(`Lv${level} Story missing ${marker}`);
  }
  if (!text.includes('中轴') && !text.includes('午门')) throw new Error(`Lv${level} Story missing Forbidden City spatial mechanism`);
  if (!text.includes('路线') && !text.includes('两条线')) throw new Error(`Lv${level} Story missing route mechanism`);
  if (level >= 3 && !text.includes('判断')) throw new Error(`Lv${level} Story missing 判断`);
  if (level >= 5 && !text.includes('证据')) throw new Error(`Lv${level} Story missing 证据`);
}

function traceVocabulary(story, vocabulary) {
  const ignore = new Set(['故事', '单词', '发现', '挑战', '继续', '返回', '朗读', '查看', '中文难度', '重点词汇']);
  const words = [...new Set(vocabulary.match(/[\u3400-\u9fff]{2,6}/g) ?? [])];
  return words.filter((w) => !ignore.has(w) && story.includes(w));
}

async function nextToVocabulary(page, level, storyText) {
  await tapButton(page, '继续', { prefix: true });
  await sleep(400);
  if (!(await exists(page, '2/6', { prefix: true, timeout: 700 }))) {
    await page.touchscreen.tap(22, 58);
  }
  await waitStage(page, 2);
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Vocabulary level drift`);
  const text = await visibleText(page);
  const traced = traceVocabulary(storyText, text);
  if (!traced.length) throw new Error(`Lv${level} Vocabulary has no visible same-level Story trace`);
}

async function nextToDiscovery(page, level) {
  await tapButton(page, '继续', { prefix: true });
  await waitStage(page, 3);
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Discovery level drift`);
  const text = await visibleText(page);
  if (!['中轴', '宫门', '院落', '景运门', '乾清门', '外朝', '内廷'].some((w) => text.includes(w))) {
    throw new Error(`Lv${level} Discovery missing Forbidden City spatial content`);
  }
}

async function nextToChallenge(page, level) {
  await tapButton(page, '继续', { prefix: true });
  await waitStage(page, 4);
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Challenge level drift`);
  await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 15000 });
}

async function challengeOptionIndices(page) {
  const rs = await records(page);
  const lettered = rs.filter((r) => {
    if (!r.visible || r.disabled) return false;
    const label = clean(r.label);
    return /^[A-D]\s/.test(label) && /[\u3400-\u9fff]/.test(label);
  }).sort((a, b) => a.index - b.index);
  if (lettered.length) return lettered.map((r) => r.index);

  const excluded = [
    '提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项', '继续留下回忆',
    '完成挑战后继续', '返回', 'Back', '查看 Lv.', '提高当前难度', '降低当前难度',
    '短文复原', '语病修复', '补回句子', '简 / 繁', '声线', '减速', '加速', '提示',
  ];
  return rs.filter((r) => {
    if (!r.visible || r.disabled) return false;
    const text = recText(r);
    if (text.length < 4 || !/[\u3400-\u9fff]/.test(text)) return false;
    if (!['button', 'group'].includes(r.role)) return false;
    return !excluded.some((x) => text.includes(x));
  }).sort((a, b) => b.area - a.area).map((r) => r.index);
}

async function requiredChallengeSelections(page) {
  const text = await visibleText(page);
  const match = text.match(/依次点击\s*(\d+)\s*句/);
  if (match) return Number(match[1]);
  return 1;
}

async function ensureGrammarSegment(page) {
  const text = await visibleText(page);
  if (!text.includes('第一步 · 点击有问题的部分')) return;
  const rs = await records(page);
  const segments = rs.filter((r) =>
    r.visible && !r.disabled && r.role === 'checkbox' && /[\u3400-\u9fff]/.test(recText(r))
  ).sort((a, b) => a.index - b.index);
  if (!segments.length) throw new Error('grammar repair segment selector not found');
  await page.locator('flt-semantics').nth(segments[0].index).tap({ timeout: 10000 });
  await sleep(120);
}

async function chooseOptions(page) {
  await ensureGrammarSegment(page);
  const count = await requiredChallengeSelections(page);
  const indices = await challengeOptionIndices(page);
  if (indices.length < count) throw new Error(`only ${indices.length} challenge options found; need ${count}`);
  for (const index of indices.slice(0, count)) {
    const node = page.locator('flt-semantics').nth(index);
    await node.tap({ timeout: 10000 });
    await sleep(120);
  }
}

async function waitForNextChallenge(page) {
  await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 12000 });
}

async function resolveChallengeMode(page, modeIndex) {
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    await chooseOptions(page);
    await tapButton(page, '提交第', { prefix: true });
    await sleep(500);

    if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1200 })) {
      await tapButton(page, '进入下一种挑战');
      await waitForNextChallenge(page);
      return;
    }
    if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1200 })) {
      await tapButton(page, '完成三连挑战');
      await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
      return;
    }

    if (attempt < 3) {
      await findSemantic(page, `提交第 ${attempt + 1} / 3 次答案`, { role: 'button', prefix: true, timeout: 5000 });
    }
  }
  throw new Error(`challenge mode ${modeIndex + 1} did not resolve`);
}

async function completeChallenge(page, level) {
  for (let mode = 0; mode < 3; mode += 1) await resolveChallengeMode(page, mode);
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Challenge completion level drift`);
}

async function nextToMemory(page, level) {
  await tapButton(page, '继续留下回忆', { prefix: true });
  await waitStage(page, 5);
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Memory level drift`);
  const text = await visibleText(page);
  if (!text.includes('两条都能走通的路线')) throw new Error(`Lv${level} Memory anchor missing`);
}

async function nextToCompletion(page, level) {
  await tapButton(page, '结束旅程', { prefix: true });
  await waitStage(page, 6);
  await findSemantic(page, '已点亮', { timeout: 15000 });
  if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Completion level drift`);
  const text = await visibleText(page);
  if (!text.includes('北京')) throw new Error(`Lv${level} Completion city binding missing`);
  if (!text.includes('路线') && !text.includes('两条')) throw new Error(`Lv${level} Completion route closure missing`);
}

async function assertNoBlockingError(page, pageErrors, label) {
  const text = await visibleText(page).catch(() => '');
  const joined = `${text}\n${pageErrors.join('\n')}`;
  for (const fatal of [
    'Bad state: Forbidden City Challenge requires an exact locked Lv1-Lv10 Story binding.',
    'Unhandled Exception',
    'A RenderFlex overflowed',
  ]) {
    if (joined.includes(fatal)) throw new Error(`${label}: blocking runtime error: ${fatal}`);
  }
}

async function runLevel(browser, level) {
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
  page.on('pageerror', (e) => pageErrors.push(e?.stack || e?.message || String(e)));

  try {
    const sep = baseUrl.includes('?') ? '&' : '?';
    const url = `${baseUrl}${sep}unlock=all&prototype=journeys&v=${sourceSha}`;
    const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
    if (!response?.ok()) throw new Error(`Preview HTTP load failed: ${response?.status()}`);
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
    await enableSemantics(page);

    await openForbiddenCity(page);
    await waitStage(page, 1);
    await setLevel(page, level);
    const story = await visibleText(page);
    requireStoryIdentity(story, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Story`);
    console.log(`Lv${level} STORY = PASS`);

    await nextToVocabulary(page, level, story);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Vocabulary`);
    console.log(`Lv${level} VOCABULARY = PASS`);

    await nextToDiscovery(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Discovery`);
    console.log(`Lv${level} DISCOVERY = PASS`);

    await nextToChallenge(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Challenge`);
    await completeChallenge(page, level);
    console.log(`Lv${level} CHALLENGE = PASS`);

    await nextToMemory(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Memory`);
    console.log(`Lv${level} MEMORY = PASS | 两条都能走通的路线`);

    await nextToCompletion(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Completion`);
    console.log(`Lv${level} COMPLETION = PASS`);
    console.log(`Lv${level} ACTUAL PREVIEW SIX-STAGE = PASS`);
  } catch (error) {
    const snapshot = await records(page).catch(() => []);
    console.error(`Lv${level} SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot.slice(0, 180))}`);
    throw error;
  } finally {
    await context.close();
  }
}

const browser = await chromium.launch({ headless: true });
try {
  for (const level of levels) await runLevel(browser, level);
  console.log(`FORBIDDEN CITY ACTUAL PREVIEW E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')}`);
} finally {
  await browser.close();
}
