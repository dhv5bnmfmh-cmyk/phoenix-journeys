import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium, webkit } = playwrightModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) {
  throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function enableFlutterSemantics(page, browserName) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) {
    await placeholder.evaluate((element) => element.click());
  }
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 15000 });
  console.log(`${browserName} FLUTTER SEMANTICS = ENABLED`);
}

async function waitForHome(page, browserName) {
  await page.getByRole('button', { name: '探索', exact: true }).first().waitFor({ state: 'visible', timeout: 20000 });
  await page.getByRole('button', { name: '选择城市', exact: true }).first().waitFor({ state: 'visible', timeout: 20000 });
  await page.getByRole('button', { name: /^(开始|继续|再次探索).+/ }).first().waitFor({ state: 'visible', timeout: 20000 });
  console.log(`${browserName} HOME INTERACTIVE STATE = PRESENT`);
}

async function tapButton(page, name, label) {
  const button = page.getByRole('button', { name, exact: typeof name === 'string' }).first();
  await button.waitFor({ state: 'visible', timeout: 15000 });
  if (!(await button.isEnabled())) throw new Error(`${label}: button is disabled`);
  await button.tap({ timeout: 15000 });
  return button;
}

async function waitExactText(page, text, timeout = 15000) {
  await page.getByText(text, { exact: true }).first().waitFor({ state: 'visible', timeout });
}

async function dismissBottomSheet(page, expectedText) {
  await page.touchscreen.tap(22, 58);
  await page.getByText(expectedText, { exact: true }).first().waitFor({ state: 'hidden', timeout: 10000 });
}

async function assertSelectedTab(page, label, browserName) {
  const nav = page.getByRole('button', { name: label, exact: true }).first();
  await nav.waitFor({ state: 'visible', timeout: 10000 });
  await nav.tap();
  await sleep(300);
  const selected = await nav.getAttribute('aria-selected');
  const checked = await nav.getAttribute('aria-checked');
  if (selected !== 'true' && checked !== 'true') {
    throw new Error(`${browserName}:${label}: tab did not expose selected state after tap`);
  }
  console.log(`${browserName} TAB ${label} = PASS`);
}

async function exerciseLevelControl(page, browserName) {
  const level = page.locator('flt-semantics[aria-label^="Phoenix 中文难度 "]').first();
  await level.waitFor({ state: 'attached', timeout: 15000 });
  const before = await level.getAttribute('aria-label');
  let control = page.getByRole('button', { name: '提高当前难度', exact: true }).first();
  let direction = 'PLUS';
  if (!(await control.isEnabled())) {
    control = page.getByRole('button', { name: '降低当前难度', exact: true }).first();
    direction = 'MINUS';
  }
  if (!(await control.isEnabled())) throw new Error(`${browserName}: no enabled level control`);
  await control.tap();
  let after = before;
  for (let i = 0; i < 30 && after === before; i += 1) {
    await sleep(100);
    after = await level.getAttribute('aria-label');
  }
  if (!before || !after || before === after) {
    throw new Error(`${browserName}: level state did not change (${before} -> ${after})`);
  }
  console.log(`${browserName} LV ${direction} = PASS (${before} -> ${after})`);
}

async function exerciseCitySelector(page, browserName) {
  await tapButton(page, '选择城市', `${browserName}:city-selector`);
  await waitExactText(page, '选择城市与地点');
  console.log(`${browserName} CITY SELECTOR OPEN = PASS`);
  await dismissBottomSheet(page, '选择城市与地点');
  console.log(`${browserName} CITY SELECTOR CLOSE = PASS`);
}

async function openJourney(page, browserName, cycle) {
  const button = page.getByRole('button', { name: /^(开始|继续|再次探索).+/ }).first();
  await button.waitFor({ state: 'visible', timeout: 15000 });
  const action = await button.getAttribute('aria-label');
  await button.tap();
  await page.getByText(/^[1-6]\/6$/).first().waitFor({ state: 'visible', timeout: 20000 });
  console.log(`${browserName} JOURNEY CYCLE ${cycle} OPEN = PASS (${action})`);
}

async function reachDiscovery(page, browserName) {
  await waitExactText(page, '1/6');
  await waitExactText(page, '故事');
  await tapButton(page, '继续', `${browserName}:story-next`);
  await sleep(500);
  await page.touchscreen.tap(22, 58);
  await waitExactText(page, '2/6', 15000);
  await waitExactText(page, '单词', 15000);
  await tapButton(page, '继续', `${browserName}:words-next`);
  await waitExactText(page, '3/6', 15000);
  await waitExactText(page, '发现', 15000);
  console.log(`${browserName} DISCOVERY STATE TRANSITION = PASS`);
}

async function exitJourneyToHome(page, browserName, cycle) {
  await page.touchscreen.tap(28, 26);
  await waitForHome(page, browserName);
  console.log(`${browserName} JOURNEY CYCLE ${cycle} RETURN = PASS`);
}

async function exercisePostReturnHome(page, browserName, cycle) {
  await assertSelectedTab(page, '护照', browserName);
  await waitExactText(page, '探索护照');
  await assertSelectedTab(page, '探索', browserName);
  await waitForHome(page, browserName);
  console.log(`${browserName} POST-CYCLE-${cycle} HOME INTERACTION = PASS`);
}

async function exerciseAllTabs(page, browserName) {
  await assertSelectedTab(page, '护照', browserName);
  await waitExactText(page, '探索护照');
  await assertSelectedTab(page, '跟读训练', browserName);
  await assertSelectedTab(page, '我的', browserName);
  await assertSelectedTab(page, '探索', browserName);
  await waitForHome(page, browserName);
  console.log(`${browserName} BOTTOM NAVIGATION ALL TABS = PASS`);
}

async function runBrowser(browserType, browserName) {
  const browser = await browserType.launch({ headless: true });
  try {
    const context = await browser.newContext({
      viewport: { width: 390, height: 844 },
      deviceScaleFactor: 3,
      isMobile: true,
      hasTouch: true,
      locale: 'zh-CN',
      reducedMotion: 'reduce',
    });
    const page = await context.newPage();
    const pageErrors = [];
    page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
    page.on('console', (message) => console.log(`[${browserName} console:${message.type()}] ${message.text()}`));

    const separator = url.includes('?') ? '&' : '?';
    const candidateUrl = `${url}${separator}unlock=all&prototype=journeys&v=${sourceSha}`;
    await page.goto(candidateUrl, { waitUntil: 'load', timeout: 140000 });
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
    await enableFlutterSemantics(page, browserName);
    await waitForHome(page, browserName);
    console.log(`${browserName} HOME INITIAL INTERACTION = PASS`);

    await exerciseCitySelector(page, browserName);
    await exerciseLevelControl(page, browserName);

    await openJourney(page, browserName, 1);
    await reachDiscovery(page, browserName);
    await exitJourneyToHome(page, browserName, 1);
    await exercisePostReturnHome(page, browserName, 1);

    await openJourney(page, browserName, 2);
    await exitJourneyToHome(page, browserName, 2);
    await exercisePostReturnHome(page, browserName, 2);

    await exerciseCitySelector(page, browserName);
    await exerciseLevelControl(page, browserName);
    await exerciseAllTabs(page, browserName);

    if (pageErrors.length) {
      throw new Error(`${browserName}: page errors: ${pageErrors.join('\n')}`);
    }
    console.log(`${browserName} REAL MOBILE FUNCTIONAL INTERACTION AUDIT = PASS`);
  } finally {
    await browser.close();
  }
}

let failed = false;
for (const [name, type] of [['chromium', chromium], ['webkit', webkit]]) {
  try {
    await runBrowser(type, name);
  } catch (error) {
    failed = true;
    console.error(`${name} FUNCTIONAL AUDIT FAILURE`, error?.stack || error);
  }
}

console.log(`MOBILE INTERACTION SOURCE SHA = ${sourceSha}`);
if (failed) process.exit(1);
