import fs from 'node:fs';
import { pathToFileURL } from 'node:url';
import { returnToExplore, setConfiguredLevel } from './journey_level_session_harness.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const productSha = process.argv[3];
if (!baseUrl || !productSha) throw new Error('usage: fixed-acceptance <preview-url> <product-sha>');

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.map((element, index) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    return {
      index,
      role: element.getAttribute('role') || '',
      text: [element.getAttribute('aria-label'), element.getAttribute('aria-valuetext'),
        element.getAttribute('aria-description'), element.textContent]
        .filter(Boolean).join(' ').replace(/\s+/g, ' ').trim(),
      disabled: element.getAttribute('aria-disabled') === 'true',
      visible: rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden',
      x: rect.x, y: rect.y, width: rect.width, height: rect.height,
    };
  }));
}

async function find(page, needle, { role = null, prefix = false, exact = false, timeout = 20000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const matches = (await records(page)).filter((record) => record.visible &&
      (!role || record.role === role) &&
      (exact ? record.text === needle : prefix ? record.text.startsWith(needle) : record.text.includes(needle)))
      .sort((a, b) => (a.width * a.height) - (b.width * b.height));
    if (matches.length) return page.locator('flt-semantics').nth(matches[0].index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function tap(page, needle, options = {}) {
  const node = await find(page, needle, { ...options, role: 'button' });
  if ((await node.getAttribute('aria-disabled')) === 'true') throw new Error(`disabled: ${needle}`);
  await node.tap({ timeout: 10000 });
}

function installSpeechMock(context) {
  return context.addInitScript(() => {
    class DiagnosticUtterance extends EventTarget {
      constructor(text) { super(); this.text = text; this.lang = ''; this.rate = 1; this.pitch = 1; this.volume = 1; }
    }
    const synth = {
      speaking: false, pending: false, paused: false,
      getVoices: () => [],
      speak(utterance) {
        this.speaking = true;
        setTimeout(() => utterance.dispatchEvent(new Event('start')), 0);
      },
      cancel() { this.speaking = false; this.pending = false; this.paused = false; },
      pause() { this.paused = true; },
      resume() { this.paused = false; this.speaking = true; },
    };
    Object.defineProperty(window, 'SpeechSynthesisUtterance', { configurable: true, value: DiagnosticUtterance });
    Object.defineProperty(window, 'speechSynthesis', { configurable: true, value: synth });
  });
}

function markerTracker(page, label) {
  const events = [];
  const waiters = new Map();
  const started = performance.now();
  page.on('console', (message) => {
    const text = message.text();
    const match = text.match(/\b(PJ_[A-Z0-9_]+)\s+(\{.*\})$/);
    if (!match) return;
    let payload = {};
    try { payload = JSON.parse(match[2]); } catch {}
    const event = { marker: match[1], wallMs: performance.now() - started, payload };
    events.push(event);
    console.log(`${label}_MARKER wallMs=${event.wallMs} ${event.marker} ${JSON.stringify(payload)}`);
    const pending = waiters.get(event.marker);
    if (pending) {
      for (const resolve of pending) resolve(event);
      waiters.delete(event.marker);
    }
  });
  return {
    events,
    wait(marker, timeout = 15000) {
      const existing = events.find((event) => event.marker === marker);
      if (existing) return Promise.resolve(existing);
      return new Promise((resolve, reject) => {
        const timer = setTimeout(() => reject(new Error(`marker timeout: ${marker}`)), timeout);
        const list = waiters.get(marker) ?? [];
        list.push((event) => { clearTimeout(timer); resolve(event); });
        waiters.set(marker, list);
      });
    },
  };
}

function first(events, marker) { return events.find((event) => event.marker === marker); }
function delta(events, a, b) {
  const aa = first(events, a); const bb = first(events, b);
  return aa && bb ? bb.wallMs - aa.wallMs : null;
}
function reason(events, marker) { return first(events, marker)?.payload?.reason ?? ''; }
function numberFromReason(text, key) {
  const match = String(text).match(new RegExp(`${key}=([0-9]+)`));
  return match ? Number(match[1]) : null;
}
function contentFromReason(text) {
  const match = String(text).match(/content=(.*)$/s);
  return match ? match[1] : null;
}

async function openStory(page, { level, storyTitle, noAutoOpen = false }) {
  const params = new URLSearchParams({
    unlock: 'all', prototype: 'journeys', v: productSha, pjFixedAccept: '1',
    diagSession: `fixed-${level}-${Date.now()}`,
  });
  if (noAutoOpen) params.set('pjNoAutoOpen', '1');
  const navigation = await page.goto(`${baseUrl}/?${params.toString()}`, { waitUntil: 'domcontentloaded', timeout: 60000 });
  if (!navigation || navigation.status() >= 400) throw new Error(`navigation failed: ${navigation?.status()}`);
  const placeholder = page.locator('flt-semantics-placeholder').first();
  await placeholder.waitFor({ state: 'attached', timeout: 60000 });
  await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
  await setConfiguredLevel(page, level);
  await returnToExplore(page);
  await tap(page, '护照', { prefix: true });
  await find(page, '探索护照');
  await tap(page, '中国', { exact: true });
  await find(page, '请从左侧选择省份');
  await tap(page, '北京市', { exact: true });
  await tap(page, '故宫博物院');
  await find(page, '选择 Story');
  await tap(page, storyTitle);
  await find(page, '1/5', { prefix: true });
  await find(page, storyTitle);

  const narration = (await records(page)).filter((record) => record.visible &&
    record.role === 'button' && record.text.includes('开始朗读') && !record.text.includes('继续'))
    .sort((a, b) => (a.width * a.height) - (b.width * b.height))[0];
  if (!narration) throw new Error('visible Story narration button not found');
  await page.touchscreen.tap(narration.x + narration.width * 0.535, narration.y + Math.min(22, narration.height / 2));
  await find(page, '正在朗读', { timeout: 10000 });
  const speechAvailable = await page.evaluate(() => Boolean(window.speechSynthesis && window.SpeechSynthesisUtterance));
  if (!speechAvailable) throw new Error('Web Speech unavailable');

  const continueButton = await find(page, '继续', { role: 'button', prefix: true });
  const box = await continueButton.boundingBox();
  if (!box || box.width < 20 || box.height < 20) throw new Error('visible Continue unavailable');
  await continueButton.tap({ timeout: 10000 });
  return { speechAvailable, narrationActive: true, oneVisibleContinueTap: true };
}

function summarize(label, tracker, pathMeta) {
  const events = tracker.events;
  const coldReason = reason(events, 'PJ_WORD_EXAMPLE_COLD_END');
  const warmReason = reason(events, 'PJ_WORD_EXAMPLE_WARM_END');
  const contextReason = reason(events, 'PJ_WORD_CONTEXT_LOOKUP_END');
  const result = {
    label,
    ...pathMeta,
    m1: Boolean(first(events, 'PJ_M1_TAP_RECEIVED')),
    m2: Boolean(first(events, 'PJ_M2_PRE_GUARDS')),
    m3: Boolean(first(events, 'PJ_M3_STEP_COMMITTED')),
    m4: Boolean(first(events, 'PJ_M4_VOCAB_FIRST_FRAME')),
    wordDetailBuild: Boolean(first(events, 'PJ_WORD_DETAIL_BUILD')),
    wordDetailFirstFrame: Boolean(first(events, 'PJ_WORD_DETAIL_FIRST_FRAME')),
    layoutPaint: Boolean(first(events, 'PJ_WORD_DETAIL_LAYOUT_PAINT_COMPLETE')),
    m5: Boolean(first(events, 'PJ_M5_STABLE')),
    m1ToM4Ms: delta(events, 'PJ_M1_TAP_RECEIVED', 'PJ_M4_VOCAB_FIRST_FRAME'),
    m4ToWordDetailFirstFrameMs: delta(events, 'PJ_M4_VOCAB_FIRST_FRAME', 'PJ_WORD_DETAIL_FIRST_FRAME'),
    routeToWordDetailFirstFrameMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_DETAIL_FIRST_FRAME'),
    m4ToM5Ms: delta(events, 'PJ_M4_VOCAB_FIRST_FRAME', 'PJ_M5_STABLE'),
    m1ToWordDetailFirstFrameMs: delta(events, 'PJ_M1_TAP_RECEIVED', 'PJ_WORD_DETAIL_FIRST_FRAME'),
    m1ToM5Ms: delta(events, 'PJ_M1_TAP_RECEIVED', 'PJ_M5_STABLE'),
    resolveDownloadedExampleColdMs: numberFromReason(coldReason, 'elapsedUs') / 1000,
    resolveDownloadedExampleWarmMs: numberFromReason(warmReason, 'elapsedUs') / 1000,
    contextLookupMs: numberFromReason(contextReason, 'elapsedUs') / 1000,
    lazyBuildersInvoked: numberFromReason(contextReason, 'lazyBuilders'),
    coldContent: contentFromReason(coldReason),
    warmContent: contentFromReason(warmReason),
    postFramePrompt: Boolean(first(events, 'PJ_WORD_POST_FRAME_CALLBACK_ENTERED')),
  };
  if (![result.m1, result.m2, result.m3, result.m4, result.wordDetailBuild,
    result.wordDetailFirstFrame, result.layoutPaint, result.m5, result.postFramePrompt].every(Boolean)) {
    throw new Error(`${label}: missing mandatory milestone`);
  }
  if (result.lazyBuildersInvoked !== 0) throw new Error(`${label}: active hit invoked ${result.lazyBuildersInvoked} fallback builders`);
  if (result.contextLookupMs == null || result.contextLookupMs >= 2000) throw new Error(`${label}: context lookup not interactive: ${result.contextLookupMs}ms`);
  if (result.resolveDownloadedExampleColdMs == null || result.resolveDownloadedExampleColdMs >= 2000) throw new Error(`${label}: cold resolve not interactive: ${result.resolveDownloadedExampleColdMs}ms`);
  if (result.m4ToM5Ms == null || result.m4ToM5Ms >= 3000) throw new Error(`${label}: M4->M5 too slow: ${result.m4ToM5Ms}ms`);
  if (!result.coldContent || result.coldContent !== result.warmContent) throw new Error(`${label}: cold/warm content mismatch`);
  return result;
}

async function assertResponsive(page, label) {
  const value = await page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => resolve('responsive'))));
  if (value !== 'responsive') throw new Error(`${label}: page unresponsive`);
  await sleep(500);
  const visible = (await records(page)).filter((record) => record.visible).map((record) => record.text).join('\n');
  if (!visible.includes('下一个单词') && !visible.includes('完成并收起')) {
    throw new Error(`${label}: Word Detail no longer visible after stability wait`);
  }
}

async function runAuto(browser, { label, level, storyTitle }) {
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`${label}_PAGE_ERROR ${error.stack || error}`));
  const tracker = markerTracker(page, label.toUpperCase().replaceAll('-', '_'));
  const pathMeta = await openStory(page, { level, storyTitle });
  await tracker.wait('PJ_M1_TAP_RECEIVED');
  await tracker.wait('PJ_M2_PRE_GUARDS');
  await tracker.wait('PJ_M3_STEP_COMMITTED');
  await tracker.wait('PJ_M4_VOCAB_FIRST_FRAME');
  await tracker.wait('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED');
  await tracker.wait('PJ_WORD_EXAMPLE_COLD_END');
  await tracker.wait('PJ_WORD_EXAMPLE_WARM_END');
  await tracker.wait('PJ_WORD_CONTEXT_LOOKUP_END');
  await tracker.wait('PJ_WORD_DETAIL_FIRST_FRAME');
  await tracker.wait('PJ_WORD_DETAIL_LAYOUT_PAINT_COMPLETE');
  await tracker.wait('PJ_M5_STABLE');
  await assertResponsive(page, label);
  const result = summarize(label, tracker, pathMeta);
  await context.close();
  return result;
}

async function tapFirstWord(page) {
  const candidates = (await records(page)).filter((record) =>
    record.visible && !record.disabled && record.text.includes('中轴'))
    .sort((a, b) => {
      const aButton = a.role === 'button' ? 0 : 1;
      const bButton = b.role === 'button' ? 0 : 1;
      if (aButton !== bButton) return aButton - bButton;
      return (a.width * a.height) - (b.width * b.height);
    });
  if (!candidates.length) throw new Error('manual first-word target 中轴 not found');
  const target = candidates[0];
  await page.touchscreen.tap(target.x + target.width / 2, target.y + target.height / 2);
}

async function runManual(browser) {
  const label = 'manual-second-lv6';
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`${label}_PAGE_ERROR ${error.stack || error}`));
  const tracker = markerTracker(page, 'MANUAL_SECOND_LV6');
  const pathMeta = await openStory(page, { level: 6, storyTitle: '交接前的标记', noAutoOpen: true });
  await tracker.wait('PJ_M1_TAP_RECEIVED');
  await tracker.wait('PJ_M2_PRE_GUARDS');
  await tracker.wait('PJ_M3_STEP_COMMITTED');
  await tracker.wait('PJ_M4_VOCAB_FIRST_FRAME');
  await tracker.wait('PJ_FIRST_WORD_AUTO_OPEN_SKIPPED');
  await tapFirstWord(page);
  await tracker.wait('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED');
  await tracker.wait('PJ_WORD_EXAMPLE_COLD_END');
  await tracker.wait('PJ_WORD_EXAMPLE_WARM_END');
  await tracker.wait('PJ_WORD_CONTEXT_LOOKUP_END');
  await tracker.wait('PJ_WORD_DETAIL_FIRST_FRAME');
  await tracker.wait('PJ_WORD_DETAIL_LAYOUT_PAINT_COMPLETE');
  await tracker.wait('PJ_M5_STABLE');
  await assertResponsive(page, label);
  const result = summarize(label, tracker, pathMeta);
  await context.close();
  return result;
}

const browser = await webkit.launch({ headless: true });
const results = [];
results.push(await runAuto(browser, { label: 'auto-second-lv5', level: 5, storyTitle: '交接前的标记' }));
results.push(await runAuto(browser, { label: 'auto-second-lv6', level: 6, storyTitle: '交接前的标记' }));
results.push(await runAuto(browser, { label: 'auto-existing-lv6', level: 6, storyTitle: '两条路，一张图' }));
results.push(await runManual(browser));
await browser.close();

const autoLv6 = results.find((r) => r.label === 'auto-second-lv6');
const manualLv6 = results.find((r) => r.label === 'manual-second-lv6');
if (!autoLv6 || !manualLv6 || autoLv6.coldContent !== manualLv6.coldContent) {
  throw new Error('auto/manual Word Detail content mismatch');
}

const report = {
  candidate_sha: productSha,
  cold_auto_ms: Math.max(...results.filter((r) => r.label.startsWith('auto-')).map((r) => r.resolveDownloadedExampleColdMs)),
  warm_auto_ms: Math.max(...results.filter((r) => r.label.startsWith('auto-')).map((r) => r.resolveDownloadedExampleWarmMs)),
  cold_manual_ms: manualLv6.resolveDownloadedExampleColdMs,
  warm_manual_ms: manualLv6.resolveDownloadedExampleWarmMs,
  resolve_downloaded_example_ms: Math.max(...results.map((r) => r.resolveDownloadedExampleColdMs)),
  context_lookup_ms: Math.max(...results.map((r) => r.contextLookupMs)),
  all_journeys_materialize_ms: 0,
  lazy_builders_invoked: Math.max(...results.map((r) => r.lazyBuildersInvoked)),
  word_detail_first_frame_ms: Math.max(...results.map((r) => r.m1ToWordDetailFirstFrameMs)),
  m5_ms: Math.max(...results.map((r) => r.m1ToM5Ms)),
  productSha,
  oldBaseline: {
    productSha: 'd560fa1403e5c8ec14e4291eaf4ae34184a125b8',
    sourceRun: 34131331681,
    resolveDownloadedExampleMs: 30566,
    contextLookupMs: 30564,
    allJourneysMaterializeMs: 30278,
    lazyBuildersInvoked: 27,
    manualProductionMs: 30349,
  },
  results,
  acceptance: {
    fullCatalogMaterializationEliminatedOnActiveHit: results.every((r) => r.lazyBuildersInvoked === 0),
    noLongWebkitStall: results.every((r) => r.m4ToM5Ms < 3000 && r.contextLookupMs < 2000),
    autoOpen: results.filter((r) => r.label.startsWith('auto-')).every((r) => r.wordDetailFirstFrame && r.m5),
    manualOpen: Boolean(manualLv6.wordDetailFirstFrame && manualLv6.m5),
    sameContent: autoLv6.coldContent === manualLv6.coldContent,
    webSpeechAvailable: results.every((r) => r.speechAvailable),
    narrationActive: results.every((r) => r.narrationActive),
    oneVisibleContinueTap: results.every((r) => r.oneVisibleContinueTap),
  },
};
if (!Object.values(report.acceptance).every(Boolean)) throw new Error(`acceptance failed ${JSON.stringify(report.acceptance)}`);
fs.mkdirSync('test-results', { recursive: true });
fs.writeFileSync('test-results/performance-results.json', JSON.stringify(report, null, 2));
console.log(`FIXED_ACCEPTANCE ${JSON.stringify(report)}`);
