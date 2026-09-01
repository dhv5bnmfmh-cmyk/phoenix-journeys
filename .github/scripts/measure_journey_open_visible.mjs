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

async function waitHome() {
  const deadline = Date.now() + 30000;
  while (Date.now() < deadline) {
    const rs = (await records()).filter((r) => r.visible);
    const home = rs.some((r) => recText(r).includes('PHOENIX JOURNEYS'));
    const action = rs.some((r) => r.role === 'button' && !r.disabled && /^(开始|继续|再次探索)/.test(recText(r)) && !recText(r).includes('朗读'));
    if (home && action) return;
    await sleep(100);
  }
  throw new Error('learner-visible Home did not become interactive');
}

async function journeyAction() {
  const rs = (await records()).filter((r) => r.visible);
  const actions = rs.filter((r) => r.role === 'button' && !r.disabled && /^(开始|继续|再次探索)/.test(recText(r)) && !recText(r).includes('朗读'));
  if (!actions.length) throw new Error('no learner Journey entry action');
  const identities = rs.filter((r) => r.role !== 'button' && ['紫禁城','外滩','城墙','西湖','颐和园'].some((name) => recText(r).includes(name)));
  const pairs = [];
  for (const action of actions) {
    for (const identity of identities) {
      const distance = Math.hypot((identity.x + identity.width / 2) - (action.x + action.width / 2), (identity.y + identity.height / 2) - (action.y + action.height / 2));
      pairs.push({ action, identity, distance });
    }
  }
  const chosen = pairs.sort((a, b) => a.distance - b.distance)[0] ?? { action: actions[0], identity: null };
  const identityText = chosen.identity ? recText(chosen.identity) : '';
  const identityToken = ['紫禁城','外滩','城墙','西湖','颐和园'].find((name) => identityText.includes(name)) ?? null;
  return { actionIndex: chosen.action.index, identityToken, identityText };
}

async function clickIndex(index) {
  await page.evaluate((target) => {
    const node = [...document.querySelectorAll('flt-semantics')][target];
    if (!node) throw new Error('Journey action detached before click');
    node.click();
  }, index);
}

async function waitStoryUsable(identityToken) {
  const deadline = Date.now() + 10000;
  while (Date.now() < deadline) {
    const rs = (await records()).filter((r) => r.visible);
    const texts = rs.map(recText);
    const progress = texts.some((text) => text.startsWith('1/6') || text.includes(' 1/6'));
    const identity = identityToken ? texts.some((text) => text.includes(identityToken)) : texts.some((text) => text.includes('故事'));
    const interaction = rs.some((r) => r.role === 'button' && !r.disabled && ['继续','开始朗读','朗读'].some((needle) => recText(r).includes(needle)));
    if (progress && identity && interaction) return;
    await sleep(50);
  }
  throw new Error(`Journey Story never became learner-usable for ${identityToken ?? 'current Journey'}`);
}

async function backHome() {
  await page.evaluate(() => history.back());
  await waitHome();
  await enableSemantics();
}

const samples = [];
try {
  await page.goto(url, { waitUntil: 'load', timeout: 120000 });
  await page.waitForFunction(() => document.querySelector('flutter-view') != null, { timeout: 120000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, { timeout: 45000 });
  await enableSemantics();
  await waitHome();
  for (let i = 0; i < 5; i += 1) {
    const target = await journeyAction();
    const startedAt = Date.now();
    await clickIndex(target.actionIndex);
    await waitStoryUsable(target.identityToken);
    const elapsedMs = Date.now() - startedAt;
    samples.push({ elapsedMs, identityToken: target.identityToken, identityText: target.identityText });
    console.log(`LEARNER-VISIBLE JOURNEY OPEN SAMPLE ${i + 1} = ${elapsedMs}ms`);
    if (i < 4) await backHome();
  }
} finally {
  await browser.close();
}
const values = samples.map((s) => s.elapsedMs).sort((a, b) => a - b);
const medianMs = values[Math.floor(values.length / 2)];
const result = { sourceSha, metric: 'Home usable -> click Journey identity-bound entry -> Story 1/6 + identity + interaction target', samples, medianMs, pageErrors, failedRequests };
fs.writeFileSync(output, JSON.stringify(result, null, 2));
console.log(`LEARNER-VISIBLE JOURNEY OPEN MEDIAN = ${medianMs}ms`);
if (pageErrors.length) throw new Error(`page errors: ${pageErrors.join(' | ')}`);
if (failedRequests.length) throw new Error(`failed requests: ${JSON.stringify(failedRequests)}`);
