import { pathToFileURL } from 'node:url';
import { assertNoJourneyLiveControls, journeySessionLevel, returnToExplore, setConfiguredLevel } from './journey_level_session_harness.mjs';

const { webkit } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_mobile_webkit_discovery_depth.mjs <url> <sha>');
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

async function visibleText(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.filter((element) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    return rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden';
  }).map((element) => [element.getAttribute('aria-label'), element.getAttribute('aria-valuetext'), element.textContent]
    .filter(Boolean).join(' ')).join('\n'));
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
  const button = page.getByRole('button', { name, exact: false }).first();
  await button.waitFor({ state: 'visible', timeout: 20000 });
  await button.tap({ timeout: 15000 });
}

async function openForbiddenCity(page) {
  await tap(page, '选择城市');
  await waitText(page, '选择城市与地点');
  await tap(page, '北京');
  await waitText(page, '北京的地点');
  await tap(page, '紫禁城');
  for (let guard = 0; guard < 100; guard += 1) {
    const text = await visibleText(page);
    if (text.includes('1/6')) return;
    for (const action of ['开始', '继续', '再次探索']) {
      const candidate = page.getByRole('button', { name: action, exact: false });
      if (await candidate.count()) {
        await candidate.first().tap();
        await sleep(300);
        break;
      }
    }
    await sleep(100);
  }
  throw new Error('Mobile WebKit Forbidden City Story did not open');
}

async function advance(page, expectedStage) {
  await tap(page, '继续');
  if (expectedStage === 2) {
    await sleep(400);
    if (!(await visibleText(page)).includes('2/6')) await page.touchscreen.tap(22, 58);
  }
  await waitText(page, String(expectedStage) + '/6');
}

const browser = await webkit.launch({ headless: true });
try {
  for (let level = 1; level <= 10; level += 1) {
    const context = await browser.newContext({
      viewport: { width: 390, height: 844 }, deviceScaleFactor: 3,
      isMobile: true, hasTouch: true, locale: 'zh-CN', reducedMotion: 'reduce',
    });
    const page = await context.newPage();
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
      await openForbiddenCity(page);
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
  console.log('MOBILE WEBKIT BARE DISCOVERY DEPTH = PASS | SHA=' + sourceSha + ' | SESSION-LOCKED');
} finally {
  await browser.close();
}
