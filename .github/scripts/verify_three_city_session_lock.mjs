import { pathToFileURL } from 'node:url';
import { assertNoJourneyLiveControls, journeySessionLevel, returnToExplore, setConfiguredLevel, tapSemanticChoice } from './journey_level_session_harness.mjs';

const { chromium, webkit } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_three_city_session_lock.mjs <preview-url> <sha>');

const cities = [
  { city: '北京', place: '紫禁城', identity: '紫禁城' },
  { city: '上海', place: '外滩', identity: '外滩' },
  { city: '西安', place: '城墙', identity: '城墙' },
];
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
      x: r.x, y: r.y, width: r.width, height: r.height, area: r.width * r.height,
    };
  }));
}
const recText = (r) => clean([r.label, r.value, r.description, r.text].filter(Boolean).join(' '));

async function findSemantic(page, needle, { role = null, prefix = false, timeout = 15000 } = {}) {
  const wanted = clean(needle);
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const rs = await records(page);
    const matches = rs.filter((r) => {
      if (!r.visible || (role && r.role !== role)) return false;
      const text = recText(r);
      return prefix ? text.startsWith(wanted) : text.includes(wanted);
    }).sort((a, b) => a.area - b.area);
    if (matches.length) return page.locator('flt-semantics').nth(matches[0].index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function exists(page, needle, options = {}) {
  try { await findSemantic(page, needle, { ...options, timeout: options.timeout ?? 500 }); return true; } catch (_) { return false; }
}

async function tapButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    try {
      const node = await findSemantic(page, needle, { role: 'button', prefix, timeout: 1200 });
      if ((await node.getAttribute('aria-disabled')) === 'true') throw new Error(`button disabled: ${needle}`);
      await node.tap({ timeout: 2500 });
      return;
    } catch (error) {
      if (String(error).includes('button disabled')) throw error;
      await sleep(100);
    }
  }
  throw new Error(`button not tappable: ${needle}`);
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((el) => el.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

async function visibleText(page) {
  return (await records(page)).filter((r) => r.visible).map(recText).join('\n');
}

async function waitStage(page, stage) {
  await findSemantic(page, `${stage}/6`, { prefix: true, timeout: 20000 });
}

async function tapJourneyEntryForIdentity(page, identity) {
  const deadline = Date.now() + 20000;
  while (Date.now() < deadline) {
    const rs = (await records(page)).filter((r) => r.visible);
    const text = rs.map(recText).join(' | ');
    if (text.includes('1/6') && text.includes(identity)) return;
    const markers = rs.filter((r) => recText(r).includes(identity));
    const actions = rs.filter((r) => r.role === 'button' && !r.disabled && /^(开始|继续|再次探索)/.test(recText(r)) && !recText(r).includes('朗读'));
    const pairs = [];
    for (const action of actions) for (const marker of markers) {
      const distance = Math.hypot((marker.x + marker.width / 2) - (action.x + action.width / 2), (marker.y + marker.height / 2) - (action.y + action.height / 2));
      pairs.push({ action, distance });
    }
    const target = pairs.sort((a, b) => a.distance - b.distance)[0]?.action;
    if (target) {
      try { await page.locator('flt-semantics').nth(target.index).tap({ timeout: 2500 }); } catch (_) { await sleep(100); continue; }
      const success = Date.now() + 3000;
      while (Date.now() < success) {
        const now = await visibleText(page);
        if (now.includes('1/6') && now.includes(identity)) return;
        await sleep(100);
      }
    }
    await sleep(100);
  }
  throw new Error(`identity-bound Journey entry failed: ${identity}`);
}

async function selectAndOpen(page, spec) {
  await tapButton(page, '选择城市', { prefix: true });
  await findSemantic(page, '选择城市与地点', { timeout: 15000 });
  await tapSemanticChoice(page, spec.city, { expectedText: `${spec.city}的地点` });
  await findSemantic(page, `${spec.city}的地点`, { timeout: 15000 });
  await tapSemanticChoice(page, spec.place, { absentText: `${spec.city}的地点` });
  const short = Date.now() + 2500;
  while (Date.now() < short) {
    const text = await visibleText(page);
    if (text.includes('1/6') && text.includes(spec.identity)) return;
    if (text.includes('PHOENIX JOURNEYS')) break;
    await sleep(100);
  }
  await tapJourneyEntryForIdentity(page, spec.identity);
  await waitStage(page, 1);
  await findSemantic(page, spec.identity, { timeout: 15000 });
}

async function assertLevel(page, level, label) {
  const actual = await journeySessionLevel(page);
  if (actual !== level) throw new Error(`${label}: expected Lv${level}, got Lv${actual}`);
  await assertNoJourneyLiveControls(page);
}

async function nextSimple(page, targetStage) {
  await tapButton(page, '继续', { prefix: true });
  if (targetStage === 2) {
    await sleep(400);
    if (!(await exists(page, '2/6', { prefix: true, timeout: 600 }))) await page.touchscreen.tap(22, 58);
  }
  await waitStage(page, targetStage);
}

async function challengeTargets(page) {
  const rs = await records(page);
  const lettered = rs.filter((r) => r.visible && !r.disabled && /^[A-D]\s/.test(clean(r.label)) && /[\u3400-\u9fff]/.test(r.label));
  if (lettered.length) return lettered;
  const excluded = ['提交第','朗读','进入下一种挑战','完成三连挑战','继续留下回忆','返回','Back','短文复原','语病修复','补回句子','提示'];
  return rs.filter((r) => r.visible && !r.disabled && ['button','group','checkbox'].includes(r.role) && /[\u3400-\u9fff]/.test(recText(r)) && !excluded.some((x) => recText(r).includes(x))).sort((a,b) => b.area - a.area);
}

async function chooseChallenge(page) {
  const text = await visibleText(page);
  if (text.includes('第一步 · 点击有问题的部分')) {
    const segments = (await records(page)).filter((r) => r.visible && !r.disabled && r.role === 'checkbox' && /[\u3400-\u9fff]/.test(recText(r)));
    if (segments.length) await page.locator('flt-semantics').nth(segments[0].index).tap();
  }
  const required = Number(text.match(/依次点击\s*(\d+)\s*句/)?.[1] ?? 1);
  const targets = await challengeTargets(page);
  if (targets.length < required) throw new Error(`challenge choices insufficient: ${targets.length}/${required}`);
  for (const target of targets.slice(0, required)) {
    await page.locator('flt-semantics').nth(target.index).tap({ timeout: 10000 });
    await sleep(120);
  }
}

async function resolveChallengeMode(page) {
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    await chooseChallenge(page);
    await tapButton(page, '提交第', { prefix: true });
    await sleep(500);
    if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1000 })) {
      await tapButton(page, '进入下一种挑战');
      await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 12000 });
      return 'next';
    }
    if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1000 })) {
      await tapButton(page, '完成三连挑战');
      await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
      return 'done';
    }
  }
  throw new Error('challenge mode did not resolve');
}

async function completeChallenge(page) {
  for (let mode = 0; mode < 3; mode += 1) {
    const result = await resolveChallengeMode(page);
    if (result === 'done') return;
  }
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
}

async function captureNarrationRate(page, expected, label) {
  await page.evaluate(() => { window.__phoenixSpeechRates = []; });
  await tapButton(page, '开始朗读', { prefix: true, timeout: 12000 });
  try {
    await page.waitForFunction(() => Array.isArray(window.__phoenixSpeechRates) && window.__phoenixSpeechRates.length > 0, null, { timeout: 6000 });
    const rate = await page.evaluate(() => window.__phoenixSpeechRates.at(-1));
    if (Math.abs(rate - expected) > 0.03) throw new Error(`${label}: narration rate ${rate}, expected ${expected}`);
    console.log(`${label} NARRATION RATE = ${rate}`);
  } finally {
    if (await exists(page, '停止朗读', { role: 'button', prefix: true, timeout: 500 })) await tapButton(page, '停止朗读', { prefix: true });
  }
}

async function sixStages(page, spec, level, browserName) {
  await assertLevel(page, level, `${browserName} ${spec.city} Story`);
  if (level === 5) await captureNarrationRate(page, .92, `${browserName} ${spec.city} Lv5`);
  if (level === 7) await captureNarrationRate(page, .98, `${browserName} ${spec.city} Lv7`);
  await nextSimple(page, 2); await assertLevel(page, level, `${browserName} ${spec.city} Vocabulary`);
  await nextSimple(page, 3); await assertLevel(page, level, `${browserName} ${spec.city} Discovery`);
  await nextSimple(page, 4); await assertLevel(page, level, `${browserName} ${spec.city} Challenge`);
  await completeChallenge(page);
  await tapButton(page, '继续留下回忆', { prefix: true });
  await waitStage(page, 5); await assertLevel(page, level, `${browserName} ${spec.city} Memory`);
  await tapButton(page, '结束旅程', { prefix: true });
  await waitStage(page, 6); await assertLevel(page, level, `${browserName} ${spec.city} Completion`);
}

async function exitJourney(page) {
  await page.touchscreen.tap(28, 26);
  await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 20000 });
}

async function runCity(browserType, browserName, spec) {
  const browser = await browserType.launch({ headless: true });
  try {
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true, locale: 'zh-CN', reducedMotion: 'reduce' });
    await context.addInitScript(() => {
      window.__phoenixSpeechRates = [];
      const proto = window.SpeechSynthesis?.prototype;
      if (proto && !proto.__phoenixWrappedSpeak) {
        const original = proto.speak;
        proto.speak = function(utterance) {
          window.__phoenixSpeechRates.push(Number(utterance?.rate ?? 1));
          try { return original.call(this, utterance); } catch (_) { return undefined; }
        };
        Object.defineProperty(proto, '__phoenixWrappedSpeak', { value: true });
      }
    });
    const page = await context.newPage();
    const pageErrors = [];
    const failedRequests = [];
    page.on('pageerror', (error) => pageErrors.push(error?.message || String(error)));
    page.on('requestfailed', (request) => failedRequests.push({ url: request.url(), errorText: request.failure()?.errorText ?? null }));
    const separator = baseUrl.includes('?') ? '&' : '?';
    const testUrl = `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`;
    await page.goto(testUrl, { waitUntil: 'load', timeout: 140000 });
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 45000 });
    await enableSemantics(page);
    await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });

    await setConfiguredLevel(page, 5);
    await returnToExplore(page);
    await selectAndOpen(page, spec);
    await sixStages(page, spec, 5, browserName);
    await exitJourney(page);

    await setConfiguredLevel(page, 7);
    await returnToExplore(page);
    await selectAndOpen(page, spec);
    await assertLevel(page, 7, `${browserName} ${spec.city} next-entry`);
    await captureNarrationRate(page, .98, `${browserName} ${spec.city} Lv7 next-entry`);

    if (pageErrors.length) throw new Error(`${browserName} ${spec.city} PAGE ERRORS: ${pageErrors.join(' | ')}`);
    if (failedRequests.length) throw new Error(`${browserName} ${spec.city} FAILED REQUESTS: ${JSON.stringify(failedRequests)}`);
    console.log(`${browserName} ${spec.city} SESSION LOCK = PASS`);
    console.log(`${browserName} ${spec.city} PAGE ERRORS = []`);
    console.log(`${browserName} ${spec.city} FAILED REQUESTS = []`);
    await context.close();
  } finally {
    await browser.close();
  }
}

for (const [browserType, browserName] of [[chromium, 'Chromium'], [webkit, 'WebKit']]) {
  for (const spec of cities) await runCity(browserType, browserName, spec);
}
console.log(`THREE-CITY SESSION LOCK = PASS | SHA=${sourceSha}`);
console.log('NARRATION SESSION LEVEL = PASS');
console.log('PAGE ERRORS = []');
console.log('FAILED REQUESTS = []');
