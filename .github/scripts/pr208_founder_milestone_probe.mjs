import { pathToFileURL } from 'node:url';
import {
  returnToExplore,
  setConfiguredLevel,
} from './journey_level_session_harness.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const diagnosticSha = process.argv[3];
if (!baseUrl || !diagnosticSha) throw new Error('usage: probe <preview-url> <diagnostic-sha>');

const session = `webkit-lv6-${Date.now()}`;
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

async function visibleText(page) {
  return (await records(page)).filter((record) => record.visible).map((record) => record.text).join('\n');
}

const browser = await webkit.launch({ headless: true });
const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
await context.addInitScript(() => {
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

const page = await context.newPage();
page.on('console', (message) => {
  console.log(`BROWSER_CONSOLE_${message.type()} ${message.text()}`);
});
page.on('pageerror', (error) => console.log(`BROWSER_PAGE_ERROR ${error.stack || error}`));
page.on('requestfailed', (request) => console.log(`BROWSER_REQUEST_FAILED ${request.url()} ${request.failure()?.errorText}`));
const navigation = await page.goto(`${baseUrl}/?unlock=all&prototype=journeys&v=${diagnosticSha}&diagSession=${session}`,
  { waitUntil: 'domcontentloaded', timeout: 60000 });
console.log(`NAVIGATION status=${navigation?.status()} url=${page.url()} title=${await page.title()}`);
const placeholder = page.locator('flt-semantics-placeholder').first();
await placeholder.waitFor({ state: 'attached', timeout: 60000 }).catch(async (error) => {
  console.log(`STARTUP_DOM ${clean(await page.locator('body').innerText().catch(() => ''))}`);
  console.log(`STARTUP_HTML ${(await page.content()).slice(0, 4000)}`);
  await page.screenshot({ path: 'test-results/pr208-diagnostic-startup-failure.png', fullPage: false });
  throw error;
});
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
console.log(`NARRATION_RECT ${JSON.stringify(narration)}`);
await page.screenshot({ path: 'test-results/pr208-before-narration.png', fullPage: false });
// Flutter WebKit merges the enabled media control with a disabled seek rail in one
// semantics container. Tap the visible 32px media control's actual screen point.
await page.touchscreen.tap(narration.x + narration.width - 124, narration.y + 19);
await find(page, '正在朗读', { timeout: 10000 });

const continueButton = await find(page, '继续', { role: 'button', prefix: true });
const box = await continueButton.boundingBox();
if (!box || box.width < 20 || box.height < 20) throw new Error('M0 visible Continue hit target unavailable');
await continueButton.tap({ timeout: 10000 });
await sleep(3500);

const traceResponse = await page.request.get(`${baseUrl}/api/diagnostic?session=${session}`);
if (!traceResponse.ok()) throw new Error(`diagnostic trace GET ${traceResponse.status()}`);
const trace = await traceResponse.json();
console.log(`PJ_TRACE ${JSON.stringify(trace)}`);
const markers = trace.events.map((event) => event.marker);
for (const required of ['PJ_CONTINUE_HIT_TARGET_READY', 'PJ_CONTINUE_TAP_RECEIVED']) {
  if (!markers.includes(required)) throw new Error(`${required} missing`);
}
const text = await visibleText(page);
console.log(`VISIBLE_AFTER_ONE_TAP ${clean(text).slice(0, 2000)}`);
console.log(`MILESTONE_STOP=${markers.includes('PJ_VOCAB_STABLE') ? 'M5' :
  markers.includes('PJ_VOCAB_FIRST_FRAME') ? 'M4' :
  markers.includes('PJ_STEP_1_COMMITTED') ? 'M3' :
  markers.includes('PJ_CONTINUE_PRE_GUARDS_COMPLETE') ? 'M2' : 'M1'}`);

await page.screenshot({ path: 'test-results/pr208-diagnostic-after-one-tap.png', fullPage: false });
await browser.close();
