import { pathToFileURL } from 'node:url';
import { returnToExplore, setConfiguredLevel } from './journey_level_session_harness.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const diagnosticSha = process.argv[3];
if (!baseUrl || !diagnosticSha) throw new Error('usage: probe <preview-url> <diagnostic-sha>');

const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();
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
    console.log(`${label}_CONSOLE t=${Date.now() - started}ms ${message.type()} ${text}`);
    const match = text.match(/\b(PJ_[A-Z0-9_]+)\s+(\{.*\})$/);
    if (!match) return;
    let payload = null;
    try { payload = JSON.parse(match[2]); } catch { payload = {}; }
    const event = { marker: match[1], wallMs: Date.now() - started, payload };
    events.push(event);
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
        const list = waiters.get(marker) ?? [];
        list.push(resolve);
        waiters.set(marker, list);
        const timer = setTimeout(() => {
          const current = waiters.get(marker) ?? [];
          waiters.set(marker, current.filter((item) => item !== resolve));
          reject(new Error(`marker timeout: ${marker}`));
        }, timeout);
        const wrapped = (event) => { clearTimeout(timer); resolve(event); };
        list[list.length - 1] = wrapped;
      });
    },
  };
}

async function openFounderPath(page, session) {
  const navigation = await page.goto(`${baseUrl}/?unlock=all&prototype=journeys&v=${diagnosticSha}&diagSession=${session}`,
    { waitUntil: 'domcontentloaded', timeout: 60000 });
  console.log(`NAVIGATION status=${navigation?.status()} url=${page.url()}`);
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

async function lightweightSurface(page) {
  const started = Date.now();
  const state = await page.evaluate(() => {
    const labels = [...document.querySelectorAll('flt-semantics[aria-label]')]
      .map((element) => element.getAttribute('aria-label') || '');
    return {
      vocabulary: labels.some((value) => value.includes('单词')),
      story: labels.some((value) => value.includes('故事')),
      dialog: Boolean(document.querySelector('flt-semantics[role="dialog"]')),
      semanticsCount: document.querySelectorAll('flt-semantics').length,
    };
  });
  return { ...state, durationMs: Date.now() - started };
}

const browser = await webkit.launch({ headless: true });

// Scenario A: no post-M4 page operations until M5. This isolates product/runtime timing.
{
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`CONTROL_PAGE_ERROR ${error.stack || error}`));
  const tracker = markerTracker(page, 'CONTROL');
  const session = `m4m5-control-${Date.now()}`;
  const m5Promise = tracker.wait('PJ_VOCAB_STABLE', 70000);
  await openFounderPath(page, session);
  const m4 = await tracker.wait('PJ_VOCAB_FIRST_FRAME', 15000);
  const timerScheduled = await tracker.wait('PJ_VOCAB_STABLE_TIMER_SCHEDULED', 5000);
  console.log(`CONTROL_M4 wallMs=${m4.wallMs} timerScheduledWallMs=${timerScheduled.wallMs}`);
  const m5 = await m5Promise;
  console.log(`CONTROL_M4_TO_M5_MS=${m5.wallMs - m4.wallMs}`);
  const relevant = tracker.events.filter((event) => event.marker.startsWith('PJ_'));
  console.log(`CONTROL_TIMELINE ${JSON.stringify(relevant)}`);
  const surface = await lightweightSurface(page);
  console.log(`CONTROL_SURFACE_AT_M5 ${JSON.stringify(surface)}`);
  await page.screenshot({ path: 'test-results/m4m5-control-at-m5.png', fullPage: false });
  await context.close();
}

// Scenario B: capture what a user would see after M4 without an all-semantics layout scan.
{
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await installSpeechMock(context);
  const page = await context.newPage();
  page.on('pageerror', (error) => console.log(`VISIBLE_PAGE_ERROR ${error.stack || error}`));
  const tracker = markerTracker(page, 'VISIBLE');
  const session = `m4m5-visible-${Date.now()}`;
  await openFounderPath(page, session);
  const m4 = await tracker.wait('PJ_VOCAB_FIRST_FRAME', 15000);
  const captureStart = Date.now();
  for (const target of [100, 500, 1000, 2000, 5000]) {
    const remaining = target - (Date.now() - captureStart);
    if (remaining > 0) await sleep(remaining);
    const requestedAt = Date.now() - captureStart;
    const shotStart = Date.now();
    await page.screenshot({ path: `test-results/m4-plus-${target}ms.png`, fullPage: false });
    const shotEnd = Date.now();
    const surface = await lightweightSurface(page);
    console.log(`VISIBLE_CAPTURE target=${target} requestedAt=${requestedAt} screenshotMs=${shotEnd - shotStart} completedAt=${Date.now() - captureStart} surface=${JSON.stringify(surface)}`);
  }
  const m5 = tracker.events.find((event) => event.marker === 'PJ_VOCAB_STABLE');
  console.log(`VISIBLE_M4_TO_M5_MS=${m5 ? m5.wallMs - m4.wallMs : 'NOT_YET'}`);
  console.log(`VISIBLE_TIMELINE ${JSON.stringify(tracker.events.filter((event) => event.marker.startsWith('PJ_')))}`);
  await context.close();
}

await browser.close();
