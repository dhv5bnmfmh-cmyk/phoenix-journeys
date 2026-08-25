import { pathToFileURL } from 'node:url';

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_shanghai_bund_exact_preview.mjs <preview-url> <sha>');

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
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(`button disabled: ${needle}`);
  await node.tap({ timeout: 10000 });
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
  for (const r of await records(page)) {
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
    for (let i = 0; i < 50; i += 1) {
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

async function openShanghaiBund(page) {
  if (await exists(page, '上海 · 外滩', { timeout: 600 })) {
    await waitStage(page, 1);
    return;
  }
  await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
  await tapButton(page, '选择城市', { prefix: true });
  await findSemantic(page, '选择城市与地点', { timeout: 15000 });
  await tapButton(page, '上海');
  await findSemantic(page, '上海的地点', { timeout: 15000 });
  await tapButton(page, '外滩');
  for (let i = 0; i < 100; i += 1) {
    if (await exists(page, '1/6', { prefix: true, timeout: 120 })) return;
    if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 120 })) break;
    await sleep(100);
  }
  if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 800 })) {
    for (const action of ['开始', '继续', '再次探索']) {
      if (await exists(page, action, { role: 'button', prefix: true, timeout: 600 })) {
        await tapButton(page, action, { prefix: true });
        await waitStage(page, 1);
        return;
      }
    }
  }
  throw new Error('Shanghai Bund did not open after destination selection');
}

function requireStory(text, level) {
  for (const marker of ['林岸', '提单', '黄浦江', '外滩', '陆家嘴']) {
    if (!text.includes(marker)) throw new Error(`Lv${level} Story missing ${marker}`);
  }
  for (const forbidden of ['沈砚', '阿宁', '许澄', '周岚']) {
    if (text.includes(forbidden)) throw new Error(`Lv${level} Story leaked another Journey: ${forbidden}`);
  }
}

const discoveryAnchors = {
  1: ['黄浦江西岸'],
  3: ['海运提单', '黄浦江西岸'],
  5: ['陆家嘴', '海运提单'],
  8: ['海运提单', '1990'],
  10: ['1843', '1990'],
};

function traceVocabulary(story, vocabulary) {
  const ignore = new Set(['故事', '单词', '发现', '挑战', '继续', '返回', '朗读', '查看', '中文难度', '重点词汇']);
  const words = [...new Set(vocabulary.match(/[\u3400-\u9fff]{2,6}/g) ?? [])];
  return words.filter((w) => !ignore.has(w) && story.includes(w));
}

async function challengeTargets(page) {
  const rs = await records(page);
  const lettered = rs.filter((r) => r.visible && !r.disabled && /^[A-D]\s/.test(clean(r.label)) && /[\u3400-\u9fff]/.test(clean(r.label)));
  if (lettered.length) return lettered.map((r) => ({ label: clean(r.label), role: r.role, text: recText(r) }));
  const excluded = ['提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项', '继续留下回忆', '完成挑战后继续', '返回', '查看 Lv.', '提高当前难度', '降低当前难度', '短文复原', '语病修复', '补回句子', '简 / 繁', '声线', '减速', '加速', '提示'];
  return rs.filter((r) => {
    const text = recText(r);
    return r.visible && !r.disabled && ['button', 'group'].includes(r.role) && text.length >= 4 && /[\u3400-\u9fff]/.test(text) && !excluded.some((x) => text.includes(x));
  }).sort((a, b) => b.area - a.area).map((r) => ({ label: clean(r.label), role: r.role, text: recText(r) }));
}

async function ensureGrammarSegment(page) {
  if (!(await visibleText(page)).includes('第一步 · 点击有问题的部分')) return;
  const rs = await records(page);
  const segment = rs.find((r) => r.visible && !r.disabled && r.role === 'checkbox' && /[\u3400-\u9fff]/.test(recText(r)));
  if (!segment) throw new Error('grammar repair segment selector not found');
  await page.locator('flt-semantics').nth(segment.index).tap({ timeout: 10000 });
}

async function chooseChallenge(page) {
  await ensureGrammarSegment(page);
  const text = await visibleText(page);
  const match = text.match(/依次点击\s*(\d+)\s*句/);
  const count = match ? Number(match[1]) : 1;
  const targets = await challengeTargets(page);
  if (targets.length < count) throw new Error(`only ${targets.length} challenge options found; need ${count}`);
  for (const target of targets.slice(0, count)) {
    const rs = await records(page);
    const hit = rs.find((r) => r.visible && !r.disabled && ((target.label && clean(r.label) === target.label) || (r.role === target.role && recText(r) === target.text)));
    if (!hit) throw new Error('challenge target disappeared');
    await page.locator('flt-semantics').nth(hit.index).tap({ timeout: 10000 });
    await sleep(120);
  }
}

async function completeChallenge(page) {
  for (let mode = 0; mode < 3; mode += 1) {
    let resolved = false;
    for (let attempt = 1; attempt <= 3; attempt += 1) {
      await chooseChallenge(page);
      await tapButton(page, '提交第', { prefix: true });
      await sleep(500);
      if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1000 })) {
        await tapButton(page, '进入下一种挑战');
        await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 12000 });
        resolved = true;
        break;
      }
      if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1000 })) {
        await tapButton(page, '完成三连挑战');
        await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
        return;
      }
      if (attempt < 3) await findSemantic(page, `提交第 ${attempt + 1} / 3 次答案`, { role: 'button', prefix: true, timeout: 5000 });
    }
    if (!resolved && mode < 2) throw new Error(`challenge mode ${mode + 1} did not resolve`);
  }
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
}

async function assertNoFatal(page, pageErrors, label) {
  const joined = `${await visibleText(page).catch(() => '')}\n${pageErrors.join('\n')}`;
  for (const fatal of ['Unhandled Exception', 'A RenderFlex overflowed', 'Bad state:']) {
    if (joined.includes(fatal)) throw new Error(`${label}: blocking runtime error: ${fatal}`);
  }
}

async function runLevel(browserType, browserName, level) {
  const browser = await browserType.launch({ headless: true });
  const mobile = browserName === 'webkit';
  const context = await browser.newContext(mobile ? {
    viewport: { width: 390, height: 844 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true, locale: 'zh-CN', reducedMotion: 'reduce',
  } : {
    viewport: { width: 1440, height: 1000 }, locale: 'zh-CN', reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  const errors = [];
  page.on('pageerror', (e) => errors.push(e?.stack || e?.message || String(e)));
  try {
    const sep = baseUrl.includes('?') ? '&' : '?';
    const url = `${baseUrl}${sep}unlock=all&prototype=journeys&v=${sourceSha}`;
    const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
    if (!response?.ok()) throw new Error(`Preview HTTP load failed: ${response?.status()}`);
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
    await enableSemantics(page);
    await openShanghaiBund(page);
    await waitStage(page, 1);
    await setLevel(page, level);
    const story = await visibleText(page);
    requireStory(story, level);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Story`);

    await tapButton(page, '继续', { prefix: true });
    await waitStage(page, 2);
    const vocabulary = await visibleText(page);
    if (!traceVocabulary(story, vocabulary).length) throw new Error(`Lv${level} Vocabulary has no visible Story trace`);

    await tapButton(page, '继续', { prefix: true });
    await waitStage(page, 3);
    const discovery = await visibleText(page);
    for (const anchor of discoveryAnchors[level]) if (!discovery.includes(anchor)) throw new Error(`Lv${level} Discovery missing ${anchor}`);

    await tapButton(page, '继续', { prefix: true });
    await waitStage(page, 4);
    await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 15000 });
    await completeChallenge(page);

    await tapButton(page, '继续留下回忆', { prefix: true });
    await waitStage(page, 5);
    const memory = await visibleText(page);
    if (!memory.includes('林岸') && !memory.includes('旧提单')) throw new Error(`Lv${level} Memory missing Shanghai closure`);

    await tapButton(page, '结束旅程', { prefix: true });
    await waitStage(page, 6);
    await findSemantic(page, '已点亮', { timeout: 15000 });
    const completion = await visibleText(page);
    if (!completion.includes('上海')) throw new Error(`Lv${level} Completion city binding missing`);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Completion`);
    console.log(`SHANGHAI BUND ${browserName.toUpperCase()} Lv${level} SIX-STAGE = PASS`);
  } catch (error) {
    const snapshot = await records(page).catch(() => []);
    console.error(`${browserName} Lv${level} SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot.slice(0, 160))}`);
    throw error;
  } finally {
    await context.close();
    await browser.close();
  }
}

for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')} | BROWSERS=chromium,webkit`);
