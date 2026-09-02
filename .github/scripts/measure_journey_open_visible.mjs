import { pathToFileURL } from 'node:url';
import fs from 'node:fs';

const puppeteerModule = await import(pathToFileURL(process.env.PUPPETEER_CORE_PATH).href);
const puppeteer = puppeteerModule.default ?? puppeteerModule;
const url = process.argv[2];
const output = process.argv[3];
const sourceSha = process.argv[4];
if (!url || !output || !sourceSha) throw new Error('usage: measure_journey_open_visible.mjs <url> <output-json> <source-sha>');

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();
const browser = await puppeteer.launch({ executablePath: process.env.CHROME_PATH, headless: true, args: ['--no-sandbox', '--disable-dev-shm-usage'] });
const page = await browser.newPage();
const pageErrors = [];
const failedRequests = [];
page.on('pageerror', (error) => pageErrors.push(error?.message ?? String(error)));
page.on('requestfailed', (request) => failedRequests.push({ url: request.url(), errorText: request.failure()?.errorText ?? null }));

async function enableSemantics() {
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  await page.waitForFunction(() => document.querySelectorAll('flt-semantics').length > 0, { timeout: 30000 });
}

async function records() {
  return page.evaluate(() => [...document.querySelectorAll('flt-semantics')].map((el, index) => {
    const r = el.getBoundingClientRect();
    const s = getComputedStyle(el);
    return {
      index,
      role: el.getAttribute('role'),
      label: el.getAttribute('aria-label') || '',
      value: el.getAttribute('aria-valuetext') || '',
      description: el.getAttribute('aria-description') || '',
      text: String(el.textContent || '').replace(/\s+/g, ' ').trim(),
      x: r.x, y: r.y, width: r.width, height: r.height,
      visible: r.width > 0 && r.height > 0 && s.display !== 'none' && s.visibility !== 'hidden',
      disabled: el.getAttribute('aria-disabled') === 'true',
    };
  }));
}
const recText = (r) => clean([r.label, r.value, r.description, r.text].filter(Boolean).join(' '));

function parseJourneyAction(text) {
  const normalized = clean(text);
  if (!normalized || normalized.includes('朗读')) return null;
  const match = normalized.match(/^(开始|继续|再次探索)\s*(.+?)\s*Journey(?:\s|$)/i);
  if (!match) return null;
  const identityKey = clean(match[2]);
  if (!identityKey) return null;
  return { identityKey, actionText: normalized };
}

function journeyActions(rs) {
  return rs
    .filter((r) => r.visible && r.role === 'button' && !r.disabled)
    .map((action) => {
      const parsed = parseJourneyAction(recText(action));
      return parsed ? { action, ...parsed } : null;
    })
    .filter(Boolean)
    .sort((a, b) => a.action.y - b.action.y || a.action.x - b.action.x || a.action.index - b.action.index);
}

function compactSnapshot(rs) {
  return rs.filter((r) => r.visible).map((r) => ({
    index: r.index,
    role: r.role,
    text: recText(r),
    disabled: r.disabled,
    x: Math.round(r.x),
    y: Math.round(r.y),
    width: Math.round(r.width),
    height: Math.round(r.height),
  }));
}

function resolveJourneyAction(rs, targetIdentityKey = null) {
  const actions = journeyActions(rs);
  if (targetIdentityKey == null) return actions[0] ?? null;
  return actions.find((candidate) => candidate.identityKey === targetIdentityKey) ?? null;
}

async function failWithSemantics(message, rs = null) {
  const snapshot = compactSnapshot(rs ?? await records());
  console.error(`SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot)}`);
  throw new Error(message);
}

async function waitHome(targetIdentityKey = null) {
  const deadline = Date.now() + 30000;
  let stableMatches = 0;
  let lastTarget = null;
  while (Date.now() < deadline) {
    const rs = await records();
    const visible = rs.filter((r) => r.visible);
    const texts = visible.map(recText);
    const home = texts.some((text) => text.includes('PHOENIX JOURNEYS'));
    const storyProgress = texts.some((text) => text.startsWith('1/6') || text.includes(' 1/6'));
    const target = resolveJourneyAction(rs, targetIdentityKey);
    if (home && !storyProgress && target?.identityKey) {
      stableMatches += 1;
      lastTarget = target;
      if (stableMatches >= 2) return lastTarget;
    } else {
      stableMatches = 0;
      lastTarget = null;
    }
    await sleep(100);
  }
  await failWithSemantics(
    `HARNESS IDENTITY RESOLUTION FAILURE: Home did not expose ${targetIdentityKey ?? 'a non-empty identity-bound Journey action'}`,
  );
}

async function journeyAction(targetIdentityKey = null) {
  const rs = await records();
  const target = resolveJourneyAction(rs, targetIdentityKey);
  if (!target?.identityKey) {
    await failWithSemantics(
      `HARNESS IDENTITY RESOLUTION FAILURE: no Journey action for ${targetIdentityKey ?? 'first sample'}`,
      rs,
    );
  }
  return target;
}

async function clickIndex(index) {
  await page.evaluate((target) => {
    const node = [...document.querySelectorAll('flt-semantics')][target];
    if (!node) throw new Error('Journey action detached before click');
    node.click();
  }, index);
}

async function waitStoryUsable() {
  const deadline = Date.now() + 10000;
  while (Date.now() < deadline) {
    const rs = (await records()).filter((r) => r.visible);
    const texts = rs.map(recText);
    const progress = texts.some((text) => text.startsWith('1/6') || text.includes(' 1/6'));
    const chineseStoryContent = texts.some(
      (text) => (text.match(/[\u3400-\u9fff]/g) ?? []).length >= 12,
    );
    const interaction = rs.some(
      (r) => r.role === 'button' && !r.disabled
        && ['继续', '开始朗读', '朗读'].some((needle) => recText(r).includes(needle)),
    );
    const staleHomeJourneyEntry = journeyActions(rs).length > 0;
    if (progress && chineseStoryContent && interaction && !staleHomeJourneyEntry) return;
    await sleep(50);
  }
  await failWithSemantics('Journey Story never became learner-usable after locked Journey action click');
}

async function backHome(targetIdentityKey) {
  await page.evaluate(() => history.back());
  await sleep(50);
  await enableSemantics();
  await waitHome(targetIdentityKey);
}

const samples = [];
let identityKey = null;
try {
  await page.goto(url, { waitUntil: 'load', timeout: 120000 });
  await page.waitForFunction(() => document.querySelector('flutter-view') != null, { timeout: 120000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, { timeout: 45000 });
  await enableSemantics();
  await waitHome();

  for (let i = 0; i < 5; i += 1) {
    const target = await journeyAction(identityKey);
    if (i === 0) {
      if (!target.identityKey) {
        await failWithSemantics('HARNESS IDENTITY RESOLUTION FAILURE: first Journey sample produced an empty identity key');
      }
      identityKey = target.identityKey;
      console.log(`LOCKED JOURNEY IDENTITY = ${identityKey}`);
    } else if (target.identityKey !== identityKey) {
      await failWithSemantics(
        `HARNESS IDENTITY RESOLUTION FAILURE: Journey identity drifted from ${identityKey} to ${target.identityKey ?? 'null'} on sample ${i + 1}`,
      );
    }

    const startedAt = Date.now();
    await clickIndex(target.action.index);
    await waitStoryUsable();
    const elapsedMs = Date.now() - startedAt;
    samples.push({ elapsedMs, identityKey: target.identityKey, actionText: target.actionText });
    console.log(`LEARNER-VISIBLE JOURNEY OPEN SAMPLE ${i + 1} = ${elapsedMs}ms | IDENTITY=${target.identityKey}`);

    if (i < 4) await backHome(identityKey);
  }

  if (samples.length !== 5) {
    throw new Error(`Journey benchmark requires 5/5 valid samples, got ${samples.length}/5`);
  }
  if (!identityKey || samples.some((sample) => sample.identityKey !== identityKey)) {
    throw new Error('HARNESS IDENTITY RESOLUTION FAILURE: samples are not bound to one non-empty Journey identity');
  }
} finally {
  await browser.close();
}

const values = samples.map((s) => s.elapsedMs).sort((a, b) => a - b);
const medianMs = values[Math.floor(values.length / 2)];
const result = {
  sourceSha,
  metric: 'Home usable -> click SAME parsed Journey entry -> learner-usable Story 1/6 + Chinese content + interaction target',
  identityKey,
  validSamples: samples.length,
  samples,
  medianMs,
  pageErrors,
  failedRequests,
};
fs.writeFileSync(output, JSON.stringify(result, null, 2));
console.log(`LEARNER-VISIBLE JOURNEY OPEN MEDIAN = ${medianMs}ms | VALID=${samples.length}/5 | IDENTITY=${identityKey}`);
if (pageErrors.length) throw new Error(`page errors: ${pageErrors.join(' | ')}`);
if (failedRequests.length) throw new Error(`failed requests: ${JSON.stringify(failedRequests)}`);
