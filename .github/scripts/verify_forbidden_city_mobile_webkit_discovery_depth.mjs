import { pathToFileURL } from 'node:url';
import { assertNoJourneyLiveControls, journeySessionLevel, returnToExplore, setConfiguredLevel, tapSemanticChoice } from './journey_level_session_harness.mjs';

const { webkit } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_mobile_webkit_discovery_depth.mjs <url> <sha>');
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

async function semanticRecords(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.map((element, index) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    return {
      index,
      role: element.getAttribute('role'),
      label: element.getAttribute('aria-label') || '',
      value: element.getAttribute('aria-valuetext') || '',
      description: element.getAttribute('aria-description') || '',
      text: String(element.textContent || '').replace(/\s+/g, ' ').trim(),
      x: rect.x, y: rect.y, width: rect.width, height: rect.height,
      visible: rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden',
      disabled: element.getAttribute('aria-disabled') === 'true',
    };
  }));
}
const recText = (r) => clean([r.label, r.value, r.description, r.text].filter(Boolean).join(' '));

async function visibleText(page) {
  return (await semanticRecords(page)).filter((r) => r.visible).map(recText).join('\n');
}

async function waitText(page, needle, timeout = 30000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if ((await visibleText(page)).includes(needle)) return;
    await sleep(100);
  }
  throw new Error('Mobile WebKit semantic text not found: ' + needle);
}

async function tap(page, name) {
  const button = page.getByRole('button', { name, exact: true }).first();
  await button.waitFor({ state: 'visible', timeout: 20000 });
  await button.tap({ timeout: 15000 });
}

async function tapJourneyEntryForIdentity(page, identity) {
  const deadline = Date.now() + 20000;
  let lastSnapshot = '';
  while (Date.now() < deadline) {
    const rs = (await semanticRecords(page)).filter((r) => r.visible);
    lastSnapshot = rs.map(recText).join(' | ');
    if (lastSnapshot.includes('1/6') && lastSnapshot.includes(identity)) return;
    const identities = rs.filter((r) => recText(r).includes(identity));
    const actions = rs.filter((r) => r.role === 'button' && !r.disabled && /^(开始|继续|再次探索)/.test(recText(r)) && !recText(r).includes('朗读'));
    const pairs = [];
    for (const action of actions) {
      for (const marker of identities) {
        const distance = Math.hypot((marker.x + marker.width / 2) - (action.x + action.width / 2), (marker.y + marker.height / 2) - (action.y + action.height / 2));
        pairs.push({ action, distance });
      }
    }
    const target = pairs.sort((a, b) => a.distance - b.distance)[0]?.action;
    if (target) {
      try {
        const locator = page.locator('flt-semantics').nth(target.index);
        await locator.tap({ timeout: 2500 });
      } catch (_) {
        await sleep(100);
        continue;
      }
      const successDeadline = Date.now() + 3000;
      while (Date.now() < successDeadline) {
        const text = await visibleText(page);
        if (text.includes('1/6') && text.includes(identity)) return;
        await sleep(100);
      }
    }
    await sleep(100);
  }
  throw new Error(`identity-bound Journey entry failed for ${identity}; snapshot=${lastSnapshot.slice(0, 1200)}`);
}

async function openForbiddenCity(page) {
  await tap(page, '选择城市');
  await waitText(page, '选择城市与地点');
  await tapSemanticChoice(page, '北京', { expectedText: '北京的地点' });
  await waitText(page, '北京的地点');
  const startedAt = Date.now();
  await tapSemanticChoice(page, '紫禁城', { absentText: '北京的地点' });
  const postSelectionDeadline = Date.now() + 3000;
  while (Date.now() < postSelectionDeadline) {
    const text = await visibleText(page);
    if (text.includes('1/6') && text.includes('紫禁城')) return Date.now() - startedAt;
    if (text.includes('PHOENIX JOURNEYS')) break;
    await sleep(100);
  }
  await tapJourneyEntryForIdentity(page, '紫禁城');
  await waitText(page, '1/6');
  await waitText(page, '紫禁城');
  return Date.now() - startedAt;
}

async function advance(page, expectedStage) {
  const button = page.getByRole('button', { name: /^继续/ }).first();
  await button.waitFor({ state: 'visible', timeout: 20000 });
  await button.tap({ timeout: 15000 });
  if (expectedStage === 2) {
    await sleep(400);
    if (!(await visibleText(page)).includes('2/6')) await page.touchscreen.tap(22, 58);
  }
  await waitText(page, String(expectedStage) + '/6');
}

const browser = await webkit.launch({ headless: true });
const globalPageErrors = [];
const globalFailedRequests = [];
const entrySamples = [];
try {
  for (let level = 1; level <= 10; level += 1) {
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 3, isMobile: true, hasTouch: true, locale: 'zh-CN', reducedMotion: 'reduce' });
    const page = await context.newPage();
    page.on('pageerror', (error) => globalPageErrors.push(error?.message || String(error)));
    page.on('requestfailed', (request) => globalFailedRequests.push({ url: request.url(), errorText: request.failure()?.errorText ?? null }));
    if (level === 1) {
      await page.route(/assets\/images\/backgrounds\//, async (route) => {
        await sleep(3000);
        await route.continue();
      });
    }
    try {
      const separator = baseUrl.includes('?') ? '&' : '?';
      const testUrl = baseUrl + separator + 'unlock=all&prototype=journeys&v=' + sourceSha + '&level=' + level;
      await page.goto(testUrl, { waitUntil: 'load', timeout: 140000 });
      await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
      await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 45000 });
      await enableSemantics(page);
      await waitText(page, 'PHOENIX JOURNEYS');
      await setConfiguredLevel(page, level);
      await returnToExplore(page);
      const entryMs = await openForbiddenCity(page);
      entrySamples.push(entryMs);
      console.log('MOBILE WEBKIT STORY USABLE Lv' + level + ' = ' + entryMs + 'ms');
      if ((await journeySessionLevel(page)) !== level) throw new Error('Mobile WebKit Lv' + level + ' session snapshot mismatch');
      await assertNoJourneyLiveControls(page);
      await advance(page, 2);
      await advance(page, 3);
      if ((await journeySessionLevel(page)) !== level) throw new Error('Mobile WebKit Lv' + level + ' Discovery level drift');
      const expected = level <= 4 ? 2 : 3;
      await waitText(page, String(expected) + ' 段', 12000);
      console.log('MOBILE WEBKIT DISCOVERY DEPTH Lv' + level + ' = PASS | ENTRIES=' + expected);
    } finally {
      await context.close();
    }
  }
  if (globalPageErrors.length) throw new Error(`PAGE ERRORS: ${globalPageErrors.join(' | ')}`);
  if (globalFailedRequests.length) throw new Error(`FAILED REQUESTS: ${JSON.stringify(globalFailedRequests)}`);
  const coldMs = entrySamples[0];
  const warm = entrySamples.slice(1).sort((a, b) => a - b);
  const warmMedianMs = warm[Math.floor(warm.length / 2)];
  if (coldMs > 700) throw new Error(`Cold WebKit entry ${coldMs}ms exceeds 700ms`);
  if (warmMedianMs > 250) throw new Error(`Warm entry median ${warmMedianMs}ms exceeds 250ms`);
  console.log(`WEBKIT ENTRY COLD = ${coldMs}ms | WARM MEDIAN = ${warmMedianMs}ms`);
  console.log('PAGE ERRORS = []');
  console.log('FAILED REQUESTS = []');
  console.log('MOBILE WEBKIT BARE DISCOVERY DEPTH = PASS | SHA=' + sourceSha + ' | SESSION-LOCKED');
} finally {
  await browser.close();
}
