import { pathToFileURL } from 'node:url';

const levels = [1, 3, 5, 8, 10];
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

const storyPlaceRoles = Object.freeze({
  west: ['外滩', '浦西', '西岸'],
  crossing: ['黄浦江', '金陵东路轮渡', '轮渡', '江对岸', '过江', '两岸'],
  east: ['浦东', '陆家嘴'],
});

function requireStory(text, level) {
  if (!text.includes('林岸')) throw new Error(`Lv${level} Story missing narrative identity 林岸`);
  if (!text.includes('提单')) throw new Error(`Lv${level} Story missing 提单 narrative object`);
  if (!text.includes('外滩')) throw new Error(`Lv${level} Story missing Bund identity 外滩`);

  for (const forbidden of ['沈砚', '阿宁', '许澄', '周岚']) {
    if (text.includes(forbidden)) throw new Error(`Lv${level} Story leaked another Journey: ${forbidden}`);
  }

  const missingRoles = Object.entries(storyPlaceRoles)
    .filter(([, markers]) => !markers.some((marker) => text.includes(marker)))
    .map(([role]) => role);
  if (missingRoles.length) {
    throw new Error(`Lv${level} Story missing Shanghai place-causality role(s): ${missingRoles.join(', ')}`);
  }
}

const discoveryAnchorGroups = {
  1: [['黄浦江', '西岸']],
  3: [['海运提单'], ['黄浦江', '西岸']],
  5: [['陆家嘴'], ['海运提单']],
  8: [['海运提单'], ['1990']],
  10: [['1843'], ['1990']],
};

function discoveryStageCorpus(segments) {
  if (!Array.isArray(segments) || !segments.length) {
    throw new Error('Discovery stage corpus requires at least one segment');
  }
  return segments.map(clean).filter(Boolean).join('\n');
}

function requireDiscoveryAnchors(text, level) {
  for (const group of discoveryAnchorGroups[level]) {
    const missing = group.filter((token) => !text.includes(token));
    if (missing.length) {
      throw new Error(`Lv${level} Discovery missing semantic anchor group ${group.join('+')}; missing ${missing.join('+')}`);
    }
  }
}

function narrationUnavailable(text) {
  return text.includes('朗读暂时不可用') || text.includes('当前设备暂时无法朗读');
}

function runStoryAnchorFixturePreflight() {
  const realLv5Semantics = [
    '上海 · 外滩 林岸二十四岁，成长在一个与上海港口贸易相连的家庭。桌上常有提单副本。',
    '第二天，他将到浦东陆家嘴上班。他把这份工作想成一次干净的切割：西岸属于船、海关和纸张，东岸属于数据、账户和新的金融基础设施。',
    '傍晚，他在外滩附近见母亲。她递给他一张外祖父留下的旧海运提单副本。林岸看着江对岸说：“过了江，我就算离开旧上海了。”',
    '两人沿滨水空间向南走到金陵东路轮渡站前。轮渡离开浦西，浦东天际线越来越近。就在两岸同时进入视野的几分钟里，他继续向陆家嘴走。',
  ].join(' ');
  requireStory(realLv5Semantics, 5);

  const negatives = [
    '林岸今天走进一座普通公园。',
    '林岸带着一张旧提单来到外滩旁的普通公园，然后原路回家。',
  ];
  for (const [index, sample] of negatives.entries()) {
    let rejected = false;
    try {
      requireStory(sample, 5);
    } catch (_) {
      rejected = true;
    }
    if (!rejected) throw new Error(`Story anchor negative fixture ${index + 1} unexpectedly passed`);
  }
  console.log('STORY ANCHOR FIXTURE PREFLIGHT = PASS | real Lv5 semantics accepted | non-Bund/non-crossing negatives rejected');
}

function runDiscoveryCorpusFixturePreflight() {
  const splitLv8 = discoveryStageCorpus([
    '第一段保留上海港口贸易脉络与海运提单。',
    '第二段说明现代陆家嘴金融城是在1990年浦东开发开放以后持续发展形成的。',
  ]);
  requireDiscoveryAnchors(splitLv8, 8);

  let rejected = false;
  try {
    requireDiscoveryAnchors(discoveryStageCorpus([
      '第一段保留上海港口贸易脉络与海运提单。',
      '第二段只谈现代城市变化，但没有目标年份。',
    ]), 8);
  } catch (_) {
    rejected = true;
  }
  if (!rejected) throw new Error('Discovery corpus negative fixture unexpectedly passed without 1990');

  requireDiscoveryAnchors(discoveryStageCorpus([
    '黄浦江西岸连接外滩历史空间。',
  ]), 1);

  const unavailableLv8 = [
    'Discovery，Lv.8 · 分段短文 · 2 段，朗读暂时不可用，进度 0%',
    '当前设备暂时无法朗读，请检查声音设置后重试。',
    '第一段保留海运提单。第二段说明1990年浦东开发开放以后陆家嘴持续发展。',
  ].join(' ');
  if (!narrationUnavailable(unavailableLv8)) throw new Error('Narration-unavailable fixture was not recognized');
  requireDiscoveryAnchors(unavailableLv8, 8);

  console.log('DISCOVERY CORPUS FIXTURE PREFLIGHT = PASS | split Lv8 anchors combine across segments | missing-1990 negative rejected | single-segment contract preserved | TTS-unavailable full-text fallback preserved');
}

if (process.argv.includes('--story-anchor-preflight')) {
  runStoryAnchorFixturePreflight();
  process.exit(0);
}

if (process.argv.includes('--discovery-corpus-preflight')) {
  runDiscoveryCorpusFixturePreflight();
  process.exit(0);
}

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_shanghai_bund_exact_preview.mjs <preview-url> <sha>');

const interactionModeByPage = new WeakMap();

const interactionModes = Object.freeze({
  desktop: 'desktop-click',
  touch: 'mobile-touch',
});

function registerInteractionMode(page, mode) {
  if (!Object.values(interactionModes).includes(mode)) {
    throw new Error(`unsupported browser interaction mode: ${mode}`);
  }
  interactionModeByPage.set(page, mode);
}

async function activateSemantic(page, locator, { timeout = 10000 } = {}) {
  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await locator.click({ timeout, noWaitAfter: true });
    return;
  }
  if (mode === interactionModes.touch) {
    await locator.tap({ timeout });
    return;
  }
  throw new Error('browser interaction mode was not registered before semantic activation');
}

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

async function activateButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(`button disabled: ${needle}`);
  await activateSemantic(page, node);
}

async function dismissVocabularyDialogIfPresent(page) {
  if (!(await exists(page, 'Dismiss', { role: 'button', timeout: 1200 }))) return false;
  await activateButton(page, 'Dismiss');
  await sleep(250);
  return true;
}

async function visibleText(page) {
  return (await records(page)).filter((r) => r.visible).map(recText).filter(Boolean).join('\n');
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((el) => el.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

function previewUrl() {
  const sep = baseUrl.includes('?') ? '&' : '?';
  return `${baseUrl}${sep}unlock=all&prototype=journeys&v=${sourceSha}`;
}

async function loadExperience(page) {
  const response = await page.goto(previewUrl(), { waitUntil: 'load', timeout: 140000 });
  if (!response?.ok()) throw new Error(`Preview HTTP load failed: ${response?.status()}`);
  await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
  await enableSemantics(page);
}

function contextOptions(browserName) {
  if (browserName === 'webkit') {
    return {
      viewport: { width: 390, height: 844 },
      deviceScaleFactor: 3,
      isMobile: true,
      hasTouch: true,
      locale: 'zh-CN',
      reducedMotion: 'reduce',
    };
  }
  return {
    viewport: { width: 1440, height: 1000 },
    locale: 'zh-CN',
    reducedMotion: 'reduce',
  };
}

function interactionModeFor(browserName) {
  return browserName === 'webkit' ? interactionModes.touch : interactionModes.desktop;
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
    await activateButton(page, level < target ? '提高当前难度' : '降低当前难度', { prefix: true });
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
  await activateButton(page, '选择城市', { prefix: true });
  await findSemantic(page, '选择城市与地点', { timeout: 15000 });
  await activateButton(page, '上海');
  await findSemantic(page, '上海的地点', { timeout: 15000 });
  await activateButton(page, '外滩');
  for (let i = 0; i < 100; i += 1) {
    if (await exists(page, '1/6', { prefix: true, timeout: 120 })) return;
    if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 120 })) break;
    await sleep(100);
  }
  if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 800 })) {
    for (const action of ['开始', '继续', '再次探索']) {
      if (await exists(page, action, { role: 'button', prefix: true, timeout: 600 })) {
        await activateButton(page, action, { prefix: true });
        await waitStage(page, 1);
        return;
      }
    }
  }
  throw new Error('Shanghai Bund did not open after destination selection');
}

function discoveryNarrationState(text) {
  const match = text.match(/第\s*(\d+)\s*\/\s*(\d+)\s*段/);
  return {
    current: match ? Number(match[1]) : null,
    total: match ? Number(match[2]) : null,
    finished: text.includes('朗读完成 · 100%'),
  };
}

async function seekNarrationProgress(page, progress) {
  const rs = await records(page);
  const rail = rs.find((r) => r.visible && recText(r).includes('朗读进度，可拖动跳转'));
  if (!rail) throw new Error('Discovery narration seek rail not found');
  const locator = page.locator('flt-semantics').nth(rail.index);
  const box = await locator.boundingBox();
  if (!box || box.width <= 2 || box.height <= 2) throw new Error('Discovery narration seek rail has no actionable geometry');
  const x = box.x + Math.max(1, Math.min(box.width - 1, box.width * progress));
  const y = box.y + box.height / 2;
  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await page.mouse.click(x, y);
  } else if (mode === interactionModes.touch) {
    await page.touchscreen.tap(x, y);
  } else {
    throw new Error('browser interaction mode was not registered before narration seek');
  }
  await sleep(300);
}

async function collectDiscoveryStageSemantics(page, level) {
  await waitStage(page, 3);
  const firstText = await visibleText(page);
  if (narrationUnavailable(firstText)) {
    requireDiscoveryAnchors(firstText, level);
    console.log(`SHANGHAI BUND Lv${level} DISCOVERY STAGE CORPUS = PASS | NARRATION=UNAVAILABLE | FULL-TEXT SEMANTICS`);
    return firstText;
  }

  const deadline = Date.now() + 25000;
  const snapshots = [firstText];
  const seenSegments = new Set();
  let total = null;

  while (Date.now() < deadline && total == null) {
    const text = await visibleText(page);
    snapshots.push(text);
    if (narrationUnavailable(text)) {
      requireDiscoveryAnchors(text, level);
      console.log(`SHANGHAI BUND Lv${level} DISCOVERY STAGE CORPUS = PASS | NARRATION=UNAVAILABLE | FULL-TEXT SEMANTICS`);
      return text;
    }
    const state = discoveryNarrationState(text);
    if (state.current != null && state.total != null) {
      seenSegments.add(state.current);
      total = state.total;
      break;
    }
    if (state.finished) {
      total = 1;
      break;
    }
    await sleep(150);
  }
  if (total == null) throw new Error(`Lv${level} Discovery narration segment state not found`);

  const coarse = [0.08, 0.18, 0.28, 0.38, 0.48, 0.58, 0.68, 0.78, 0.88, 0.95];
  for (const progress of coarse) {
    if (seenSegments.size >= total) break;
    await seekNarrationProgress(page, progress);
    await waitStage(page, 3);
    const text = await visibleText(page);
    snapshots.push(text);
    const state = discoveryNarrationState(text);
    if (state.current != null) seenSegments.add(state.current);
  }

  if (seenSegments.size < total && total > 1) {
    for (let i = 1; i < 99 && seenSegments.size < total; i += 2) {
      await seekNarrationProgress(page, i / 100);
      await waitStage(page, 3);
      const text = await visibleText(page);
      snapshots.push(text);
      const state = discoveryNarrationState(text);
      if (state.current != null) seenSegments.add(state.current);
    }
  }

  await seekNarrationProgress(page, 0.999);
  const finishDeadline = Date.now() + 10000;
  let finalText = '';
  while (Date.now() < finishDeadline) {
    await waitStage(page, 3);
    finalText = await visibleText(page);
    snapshots.push(finalText);
    const state = discoveryNarrationState(finalText);
    if (state.current != null) seenSegments.add(state.current);
    if (state.finished) break;
    if (narrationUnavailable(finalText)) {
      requireDiscoveryAnchors(finalText, level);
      console.log(`SHANGHAI BUND Lv${level} DISCOVERY STAGE CORPUS = PASS | NARRATION=UNAVAILABLE | FULL-TEXT SEMANTICS`);
      return finalText;
    }
    await sleep(150);
  }

  if (!finalText.includes('朗读完成 · 100%')) {
    throw new Error(`Lv${level} Discovery narration did not reach stable completed semantics`);
  }
  if (seenSegments.size < total) {
    throw new Error(`Lv${level} Discovery traversal saw ${seenSegments.size}/${total} narration segments`);
  }

  const corpus = discoveryStageCorpus([...snapshots, finalText]);
  requireDiscoveryAnchors(corpus, level);
  console.log(`SHANGHAI BUND Lv${level} DISCOVERY STAGE CORPUS = PASS | SEGMENTS=${total} | SEEN=${[...seenSegments].sort((a, b) => a - b).join(',')}`);
  return corpus;
}

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
  await activateSemantic(page, page.locator('flt-semantics').nth(segment.index));
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
    await activateSemantic(page, page.locator('flt-semantics').nth(hit.index));
    await sleep(120);
  }
}

async function completeChallenge(page) {
  for (let mode = 0; mode < 3; mode += 1) {
    let resolved = false;
    for (let attempt = 1; attempt <= 3; attempt += 1) {
      await chooseChallenge(page);
      await activateButton(page, '提交第', { prefix: true });
      await sleep(500);
      if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1000 })) {
        await activateButton(page, '进入下一种挑战');
        await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 12000 });
        resolved = true;
        break;
      }
      if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1000 })) {
        await activateButton(page, '完成三连挑战');
        await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
        return;
      }
      if (attempt < 3) await findSemantic(page, `提交第 ${attempt + 1} / 3 次答案`, { role: 'button', prefix: true, timeout: 5000 });
    }
    if (!resolved && mode < 2) throw new Error(`challenge mode ${mode + 1} did not resolve`);
  }
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
}

async function completeMemory(page) {
  if (await exists(page, '保存回忆并完成', { role: 'button', prefix: true, timeout: 1200 })) {
    await activateButton(page, '保存回忆并完成', { prefix: true });
    return;
  }
  await activateButton(page, '结束旅程', { prefix: true });
}

async function assertNoFatal(page, pageErrors, label) {
  const joined = `${await visibleText(page).catch(() => '')}\n${pageErrors.join('\n')}`;
  for (const fatal of ['Unhandled Exception', 'A RenderFlex overflowed', 'Bad state:']) {
    if (joined.includes(fatal)) throw new Error(`${label}: blocking runtime error: ${fatal}`);
  }
}

async function runBrowserModePreflight(browserType, browserName) {
  const browser = await browserType.launch({ headless: true });
  const context = await browser.newContext(contextOptions(browserName));
  const page = await context.newPage();
  registerInteractionMode(page, interactionModeFor(browserName));
  try {
    await loadExperience(page);
    await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
    const stableButton = await findSemantic(page, '选择城市', { role: 'button', prefix: true, timeout: 15000 });
    await activateSemantic(page, stableButton);
    await findSemantic(page, '选择城市与地点', { timeout: 15000 });
    await activateButton(page, '上海');
    await findSemantic(page, '上海的地点', { timeout: 15000 });
    await activateButton(page, '外滩');
    await waitStage(page, 1);
    if (browserName === 'webkit') {
      console.log('BROWSER MODE PREFLIGHT WEBKIT MOBILE = PASS | INTERACTION=tap | SHANGHAI SPA OPEN=PASS');
    } else {
      console.log('BROWSER MODE PREFLIGHT CHROMIUM DESKTOP = PASS | INTERACTION=click | SHANGHAI SPA OPEN=PASS');
    }
  } finally {
    await context.close();
    await browser.close();
  }
}

async function runLevel(browserType, browserName, level) {
  const browser = await browserType.launch({ headless: true });
  const context = await browser.newContext(contextOptions(browserName));
  const page = await context.newPage();
  registerInteractionMode(page, interactionModeFor(browserName));
  const errors = [];
  page.on('pageerror', (e) => errors.push(e?.stack || e?.message || String(e)));
  try {
    await loadExperience(page);
    await openShanghaiBund(page);
    await waitStage(page, 1);
    await setLevel(page, level);
    const story = await visibleText(page);
    requireStory(story, level);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Story`);

    await activateButton(page, '继续', { prefix: true });
    await sleep(350);
    await dismissVocabularyDialogIfPresent(page);
    await waitStage(page, 2);
    const vocabulary = await visibleText(page);
    if (!traceVocabulary(story, vocabulary).length) throw new Error(`Lv${level} Vocabulary has no visible Story trace`);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Vocabulary`);

    await activateButton(page, '继续', { prefix: true });
    await waitStage(page, 3);
    await collectDiscoveryStageSemantics(page, level);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Discovery`);

    await activateButton(page, '继续', { prefix: true });
    await waitStage(page, 4);
    await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 15000 });
    await completeChallenge(page);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Challenge`);

    await activateButton(page, '继续留下回忆', { prefix: true });
    await waitStage(page, 5);
    const memory = await visibleText(page);
    if (!memory.includes('林岸') && !memory.includes('旧提单')) throw new Error(`Lv${level} Memory missing Shanghai closure`);
    await assertNoFatal(page, errors, `${browserName} Lv${level} Memory`);

    await completeMemory(page);
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

await runBrowserModePreflight(playwright.chromium, 'chromium');
await runBrowserModePreflight(playwright.webkit, 'webkit');
console.log('BROWSER MODE PREFLIGHT = PASS | desktop-click + mobile-touch | Shanghai SPA open');

for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')} | BROWSERS=chromium,webkit`);
