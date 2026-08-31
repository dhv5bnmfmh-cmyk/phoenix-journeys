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
      inViewport: r.right > 0 && r.bottom > 0 && r.left < window.innerWidth && r.top < window.innerHeight,
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

async function semanticActionDiagnostics(page, needle) {
  const snapshot = await records(page);
  const visible = snapshot.filter((r) => r.visible);
  const wanted = clean(needle);
  const matching = snapshot.filter((r) => recText(r).includes(wanted));
  const buttons = snapshot.filter((r) => r.role === 'button');
  const viewport = await page.evaluate(() => ({
    width: window.innerWidth,
    height: window.innerHeight,
    scrollX: window.scrollX,
    scrollY: window.scrollY,
    documentScrollHeight: document.documentElement.scrollHeight,
  }));
  const text = visible.map(recText).join(' | ');
  const stage = text.match(/(?:^|\s)([1-6])\/6(?:\s|$)/)?.[1] ?? 'UNKNOWN';
  let sessionLevel = 'UNKNOWN';
  try { sessionLevel = `Lv${await journeySessionLevel(page)}`; } catch (_) {}
  return { needle, stage, sessionLevel, viewport, matching, buttons, visibleSemanticSnapshot: visible };
}

async function tapButton(page, needle, { prefix = false, timeout = 15000, maxScrollSteps = 8 } = {}) {
  const wanted = clean(needle);
  const deadline = Date.now() + timeout;
  let scrollSteps = 0;
  let lastError = null;

  while (Date.now() < deadline) {
    const rs = await records(page);
    const matches = rs.filter((r) => {
      if (!r.visible || r.role !== 'button') return false;
      const text = recText(r);
      return prefix ? text.startsWith(wanted) : text.includes(wanted);
    }).sort((a, b) => {
      if (a.disabled !== b.disabled) return a.disabled ? 1 : -1;
      if (a.inViewport !== b.inViewport) return a.inViewport ? -1 : 1;
      return a.area - b.area;
    });

    const target = matches[0];
    if (target) {
      if (target.disabled) {
        await sleep(120);
        continue;
      }

      const node = page.locator('flt-semantics').nth(target.index);
      try {
        await node.scrollIntoViewIfNeeded({ timeout: Math.min(1800, Math.max(250, deadline - Date.now())) });
      } catch (error) {
        lastError = error;
      }

      const refreshed = (await records(page)).filter((r) => {
        if (!r.visible || r.role !== 'button') return false;
        const text = recText(r);
        return prefix ? text.startsWith(wanted) : text.includes(wanted);
      }).sort((a, b) => {
        if (a.disabled !== b.disabled) return a.disabled ? 1 : -1;
        if (a.inViewport !== b.inViewport) return a.inViewport ? -1 : 1;
        return a.area - b.area;
      })[0];

      if (refreshed && !refreshed.disabled && refreshed.inViewport) {
        try {
          await page.locator('flt-semantics').nth(refreshed.index).tap({
            timeout: Math.min(3000, Math.max(250, deadline - Date.now())),
          });
          return;
        } catch (error) {
          lastError = error;
        }
      }

      if (scrollSteps < maxScrollSteps) {
        const viewport = page.viewportSize() ?? { width: 390, height: 844 };
        const direction = (refreshed ?? target).y < 0 ? -1 : 1;
        await page.mouse.move(viewport.width / 2, viewport.height / 2);
        await page.mouse.wheel(0, direction * Math.max(240, Math.round(viewport.height * 0.65)));
        scrollSteps += 1;
        await sleep(180);
        continue;
      }
    } else if (scrollSteps < maxScrollSteps) {
      const viewport = page.viewportSize() ?? { width: 390, height: 844 };
      await page.mouse.move(viewport.width / 2, viewport.height / 2);
      await page.mouse.wheel(0, Math.max(240, Math.round(viewport.height * 0.65)));
      scrollSteps += 1;
      await sleep(180);
      continue;
    }

    await sleep(120);
  }

  console.error(`SEMANTIC ACTION DIAGNOSTICS = ${JSON.stringify(await semanticActionDiagnostics(page, needle))}`);
  throw lastError ?? new Error(`button not tappable: ${needle}`);
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
  const seen = new Set();
  const submitEnabled = async () => (await records(page)).some((r) => r.visible && r.role === 'button' && !r.disabled && recText(r).startsWith('提交第'));
  for (let guard = 0; guard < 16; guard += 1) {
    if (await submitEnabled()) return;

    const text = await visibleText(page);
    let targets;
    if (text.includes('第一步 · 点击有问题的部分')) {
      targets = (await records(page)).filter((r) => r.visible && !r.disabled && r.role === 'checkbox' && /[\u3400-\u9fff]/.test(recText(r)));
    } else {
      targets = await challengeTargets(page);
    }
    const target = targets.find((r) => {
      const signature = `${r.role}|${recText(r)}|${Math.round(r.x)}|${Math.round(r.y)}`;
      if (seen.has(signature)) return false;
      seen.add(signature);
      return true;
    });
    if (!target) break;
    await page.locator('flt-semantics').nth(target.index).tap({ timeout: 10000 });
    await sleep(180);
  }

  // Flutter can omit ChoiceChip/InkWell answer text from the mobile semantics
  // tree after FittedBox scaling. Sweep the answer column at its safe center;
  // speaker controls remain on the right and navigation stays outside this band.
  for (let y = 230; y <= 750; y += 20) {
    await page.touchscreen.tap(195, y);
    await sleep(100);
    if (await submitEnabled()) return;
  }
  throw new Error(`challenge submit did not become enabled; snapshot=${(await visibleText(page)).slice(0, 1200)}`);
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

async function narrationControls(page) {
  const labels = ['开始朗读', '暂停朗读', '重新播放'];
  return (await records(page)).filter((r) => r.visible && r.role === 'button' && labels.some((label) => recText(r).startsWith(label))).map((r) => ({
    ...r,
    // Flutter merges the always-enabled main control with the adjacent disabled
    // replay button before the first playback, so the combined semantics node
    // can inherit aria-disabled even though its main InkWell is actionable.
    mergedMainControl: ['开始朗读', '暂停朗读'].some((label) => r.label.startsWith(label)) && r.text.includes('重新播放'),
  }));
}

async function narrationDiagnostics(page, { browserName, city }) {
  const snapshot = (await records(page)).filter((r) => r.visible);
  const text = snapshot.map(recText).join(' | ');
  const stage = text.match(/(?:^|\s)([1-6])\/6(?:\s|$)/)?.[1] ?? 'UNKNOWN';
  let level = 'UNKNOWN';
  try { level = `Lv${await journeySessionLevel(page)}`; } catch (_) {}
  return {
    browser: browserName,
    city,
    journeyStage: stage,
    sessionLevel: level,
    narrationSemanticSnapshot: snapshot,
  };
}

async function tapNarrationControl(page, control) {
  if (control.mergedMainControl && control.disabled) {
    const replay = (await records(page)).find((r) => r.visible && r.role === 'button' && recText(r).startsWith('重新播放'));
    if (!replay) throw new Error('merged narration main control has no replay geometry anchor');
    await page.touchscreen.tap(replay.x - 18, replay.y + replay.height / 2);
    return;
  }
  await page.locator('flt-semantics').nth(control.index).tap({ timeout: 2500 });
}

async function captureNarrationRate(page, expected, label, metadata) {
  await page.evaluate(() => { window.__phoenixSpeechRates = []; });
  try {
    const deadline = Date.now() + 30000;
    let triggered = false;
    while (Date.now() < deadline && !triggered) {
      const controls = await narrationControls(page);
      const actionable = controls.filter((r) => !r.disabled || r.mergedMainControl);
      const start = actionable.find((r) => recText(r).startsWith('开始朗读'));
      const replay = actionable.find((r) => recText(r).startsWith('重新播放'));
      const pause = actionable.find((r) => recText(r).startsWith('暂停朗读'));
      try {
        if (start || replay) {
          await tapNarrationControl(page, start ?? replay);
          triggered = true;
        } else if (pause) {
          await tapNarrationControl(page, pause);
          while (Date.now() < deadline) {
            const next = (await narrationControls(page)).filter((r) => !r.disabled || r.mergedMainControl);
            if (next.some((r) => ['开始朗读', '重新播放'].some((label) => recText(r).startsWith(label)))) break;
            await sleep(100);
          }
        } else {
          await sleep(100);
        }
      } catch (_) {
        await sleep(100);
      }
    }
    if (!triggered) throw new Error(`${label}: no actionable narration control within 30s`);
    await page.waitForFunction(
      () => Array.isArray(window.__phoenixSpeechRates) && window.__phoenixSpeechRates.length > 0,
      null,
      { timeout: Math.max(1, deadline - Date.now()) },
    );
    const rate = await page.evaluate(() => window.__phoenixSpeechRates.at(-1));
    if (Math.abs(rate - expected) > 0.03) throw new Error(`${label}: narration rate ${rate}, expected ${expected}`);
    console.log(`${label} NARRATION RATE = ${rate}`);
  } catch (error) {
    console.error(`NARRATION DIAGNOSTICS = ${JSON.stringify(await narrationDiagnostics(page, metadata))}`);
    throw error;
  } finally {
    if (await exists(page, '暂停朗读', { role: 'button', prefix: true, timeout: 500 })) {
      await tapButton(page, '暂停朗读', { prefix: true, timeout: 10000 });
    }
  }
}

async function sixStages(page, spec, level, browserName) {
  await assertLevel(page, level, `${browserName} ${spec.city} Story`);
  if (level === 5) await captureNarrationRate(page, .92, `${browserName} ${spec.city} Lv5`, { browserName, city: spec.city });
  if (level === 7) await captureNarrationRate(page, .98, `${browserName} ${spec.city} Lv7`, { browserName, city: spec.city });
  await nextSimple(page, 2); await assertLevel(page, level, `${browserName} ${spec.city} Vocabulary`);
  await nextSimple(page, 3); await assertLevel(page, level, `${browserName} ${spec.city} Discovery`);
  await nextSimple(page, 4); await assertLevel(page, level, `${browserName} ${spec.city} Challenge`);
  await completeChallenge(page);
  await tapButton(page, '继续留下回忆', { prefix: true });
  await waitStage(page, 5); await assertLevel(page, level, `${browserName} ${spec.city} Memory`);
  await tapButton(page, '结束旅程', { prefix: true, timeout: 20000, maxScrollSteps: 10 });
  await waitStage(page, 6);
  await findSemantic(page, spec.identity, { timeout: 12000 });
  await assertLevel(page, level, `${browserName} ${spec.city} Completion`);
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
    await captureNarrationRate(page, .98, `${browserName} ${spec.city} Lv7 next-entry`, { browserName, city: spec.city });

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
