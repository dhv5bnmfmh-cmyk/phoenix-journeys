import fs from 'node:fs';
import { pathToFileURL } from 'node:url';
import { returnToExplore, setConfiguredLevel } from './journey_level_session_harness.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const diagnosticSha = process.argv[3];
if (!baseUrl || !diagnosticSha) throw new Error('usage: probe <preview-url> <diagnostic-sha>');

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
  const started = Date.now();
  page.on('console', (message) => {
    const text = message.text();
    const match = text.match(/\b(PJ_[A-Z0-9_]+)\s+(\{.*\})$/);
    if (!match) return;
    let payload = {};
    try { payload = JSON.parse(match[2]); } catch {}
    const event = { marker: match[1], wallMs: Date.now() - started, payload };
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
    wait(marker, timeout = 70000) {
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

async function openFounderPath(page, session, { variant, noAutoOpen = false } = {}) {
  const params = new URLSearchParams({
    unlock: 'all',
    prototype: 'journeys',
    v: diagnosticSha,
    diagSession: session,
  });
  if (variant) params.set('pjWordVariant', variant);
  if (noAutoOpen) params.set('pjNoAutoOpen', '1');
  const navigation = await page.goto(`${baseUrl}/?${params.toString()}`,
    { waitUntil: 'domcontentloaded', timeout: 60000 });
  console.log(`NAVIGATION variant=${variant ?? 'none'} status=${navigation?.status()} url=${page.url()}`);
  const placeholder = page.locator('flt-semantics-placeholder').first();
  await placeholder.waitFor({ state: 'attached', timeout: 60000 });
  await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
  await setConfiguredLevel(page, 6);
  await returnToExplore(page);
  await tap(page, '护照', { prefix: true });
  await find(page, '探索护照');
  await tap(page, '中国', { exact: true });
  await find(page, '请从左侧选择省份');
  await tap(page, '北京市', { exact: true });
  await tap(page, '故宫博物院');
  await find(page, '选择 Story');
  await tap(page, '交接前的标记');
  await find(page, '1/5', { prefix: true });
  await find(page, '交接前的标记');

  const narration = (await records(page)).filter((record) => record.visible &&
    record.role === 'button' && record.text.includes('开始朗读') && !record.text.includes('继续'))
    .sort((a, b) => (a.width * a.height) - (b.width * b.height))[0];
  if (!narration) throw new Error('visible Story narration button not found');
  await page.touchscreen.tap(narration.x + narration.width * 0.535, narration.y + 22);
  await find(page, '正在朗读', { timeout: 10000 });
  const continueButton = await find(page, '继续', { role: 'button', prefix: true });
  const box = await continueButton.boundingBox();
  if (!box || box.width < 20 || box.height < 20) throw new Error('visible Continue unavailable');
  await continueButton.tap({ timeout: 10000 });
}

function first(events, marker) {
  return events.find((event) => event.marker === marker);
}

function delta(events, a, b) {
  const aa = first(events, a);
  const bb = first(events, b);
  return aa && bb ? bb.wallMs - aa.wallMs : null;
}

function summarize(label, events) {
  return {
    label,
    m4ToM5Ms: delta(events, 'PJ_VOCAB_FIRST_FRAME', 'PJ_VOCAB_STABLE'),
    routeReturnedToBuilderBeginMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_ROUTE_BUILDER_BEGIN'),
    builderDurationMs: delta(events, 'PJ_WORD_ROUTE_BUILDER_BEGIN', 'PJ_WORD_ROUTE_BUILDER_END'),
    routeReturnedToBuildBeginMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_DETAIL_BUILD_BEGIN'),
    buildDurationMs: delta(events, 'PJ_WORD_DETAIL_BUILD_BEGIN', 'PJ_WORD_DETAIL_BUILD_END'),
    routeReturnedToLayoutBeginMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_LAYOUT_BEGIN'),
    layoutDurationMs: delta(events, 'PJ_WORD_LAYOUT_BEGIN', 'PJ_WORD_LAYOUT_END'),
    routeReturnedToFirstPaintMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_FIRST_PAINT'),
    routeReturnedToPostFrameMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_POST_FRAME_CALLBACK_ENTERED'),
    routeReturnedToProdPostFrameMs: delta(events, 'PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 'PJ_WORD_PROD_POST_FRAME_ENTERED'),
    postFrameToSpeakMs: delta(events, 'PJ_WORD_POST_FRAME_CALLBACK_ENTERED', 'PJ_WORD_SPEAK_CALL_BEGIN'),
    prodPostFrameToSpeakMs: delta(events, 'PJ_WORD_PROD_POST_FRAME_ENTERED', 'PJ_WORD_SPEAK_CALL_BEGIN'),
    diagPostFrameToSpeakMs: delta(events, 'PJ_WORD_POST_FRAME_CALLBACK_ENTERED', 'PJ_WORD_DIAG_SPEAK_CALL_BEGIN'),
    prodExampleResolveMs: delta(events, 'PJ_WORD_EXAMPLE_RESOLVE_BEGIN', 'PJ_WORD_EXAMPLE_RESOLVE_END'),
    prodBuildCount: events.filter((event) => event.marker === 'PJ_WORD_PROD_BUILD_BEGIN').length,
    layoutCount: events.filter((event) => event.marker === 'PJ_WORD_LAYOUT_BEGIN').length,
  };
}

async function runAuto(browser, variant, { noAutoOpen = false } = {}) {
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`PAGE_ERROR variant=${variant} ${error.stack || error}`));
  const tracker = markerTracker(page, `AUTO_${variant.toUpperCase().replaceAll('-', '_')}`);
  const session = `word-bisect-${variant}-${Date.now()}`;
  await openFounderPath(page, session, { variant, noAutoOpen });
  await tracker.wait('PJ_VOCAB_FIRST_FRAME', 20000);
  if (noAutoOpen) {
    await tracker.wait('PJ_FIRST_WORD_AUTO_OPEN_SKIPPED', 10000);
    await tracker.wait('PJ_VOCAB_STABLE', 15000);
  } else {
    await tracker.wait('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 15000);
    await tracker.wait('PJ_WORD_POST_FRAME_CALLBACK_ENTERED', 70000);
    await tracker.wait('PJ_VOCAB_STABLE', 70000);
  }
  const result = summarize(`auto:${variant}${noAutoOpen ? ':no-auto-open' : ''}`, tracker.events);
  console.log(`BISECTION_RESULT ${JSON.stringify(result)}`);
  console.log(`BISECTION_TIMELINE variant=${variant} ${JSON.stringify(tracker.events)}`);
  await context.close();
  return result;
}

async function tapFirstWordAfterStable(page) {
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
  const variant = 'production';
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`MANUAL_PAGE_ERROR ${error.stack || error}`));
  const tracker = markerTracker(page, 'MANUAL_PRODUCTION');
  const session = `word-bisect-manual-${Date.now()}`;
  await openFounderPath(page, session, { variant, noAutoOpen: true });
  await tracker.wait('PJ_VOCAB_FIRST_FRAME', 20000);
  await tracker.wait('PJ_FIRST_WORD_AUTO_OPEN_SKIPPED', 10000);
  await tracker.wait('PJ_VOCAB_STABLE', 15000);

  // Heavy semantics lookup is deliberately done before the modal timing boundary.
  await tapFirstWordAfterStable(page);
  await tracker.wait('PJ_WORD_DETAIL_ROUTE_PUSH_RETURNED', 15000);
  await tracker.wait('PJ_WORD_POST_FRAME_CALLBACK_ENTERED', 70000);
  const result = summarize('manual:production', tracker.events);
  console.log(`BISECTION_RESULT ${JSON.stringify(result)}`);
  console.log(`BISECTION_TIMELINE manual ${JSON.stringify(tracker.events)}`);
  await context.close();
  return result;
}

const browser = await webkit.launch({ headless: true });
const results = [];

// Mandatory causal control: Vocabulary first frame with no automatic Word Detail open.
results.push(await runAuto(browser, 'production', { noAutoOpen: true }));

// Progressive first-render bisection. No screenshots or post-M4 DOM/semantics probes.
for (const variant of [
  'empty',
  'static',
  'layout',
  'reading',
  'fitted',
  'controls',
  'hook',
  'speech',
  'production',
  'production-no-outer-fitted',
]) {
  results.push(await runAuto(browser, variant));
}

// Manual-open comparison after Vocabulary is already stable.
results.push(await runManual(browser));

await browser.close();
fs.mkdirSync('test-results', { recursive: true });
fs.writeFileSync('test-results/word-detail-bisection.json', JSON.stringify(results, null, 2));
console.log(`BISECTION_MATRIX ${JSON.stringify(results)}`);
