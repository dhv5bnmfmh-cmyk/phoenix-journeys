import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium, webkit } = playwrightModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) {
  throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const attrEscape = (value) => value.replaceAll('\\', '\\\\').replaceAll('"', '\\"');

function semanticLabel(page, label, { role = null, prefix = false } = {}) {
  const op = prefix ? '^=' : '=';
  const roleSelector = role ? `[role="${attrEscape(role)}"]` : '';
  return page.locator(
    `flt-semantics${roleSelector}[aria-label${op}"${attrEscape(label)}"]`,
  ).first();
}

async function waitSemantic(page, label, options = {}) {
  const node = semanticLabel(page, label, options);
  await node.waitFor({ state: 'attached', timeout: options.timeout ?? 15000 });
  return node;
}

async function tapSemanticAction(page, label, logLabel, { prefix = false } = {}) {
  const action = semanticLabel(page, label, { prefix });
  await action.waitFor({ state: 'visible', timeout: 15000 });
  const disabled = await action.getAttribute('aria-disabled');
  if (disabled === 'true' || !(await action.isEnabled())) {
    throw new Error(`${logLabel}: action is disabled`);
  }
  await action.tap({ timeout: 15000 });
  return action;
}

async function findJourneyAction(page) {
  const prefixes = ['开始', '继续', '再次探索'];
  for (const prefix of prefixes) {
    const candidate = semanticLabel(page, prefix, { prefix: true });
    if (await candidate.count()) return candidate;
  }
  throw new Error('Home: no Start / Continue / Explore Again Journey action found');
}

async function findJourneyProgress(page, timeout = 20000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    for (let step = 1; step <= 6; step += 1) {
      const candidate = semanticLabel(page, `${step}/6`, { prefix: true });
      if (await candidate.count()) {
        await candidate.waitFor({ state: 'attached', timeout: 2000 });
        return { node: candidate, label: await candidate.getAttribute('aria-label') };
      }
    }
    await sleep(100);
  }
  throw new Error('Journey: no semantic progress state (1/6..6/6) appeared');
}

async function enableFlutterSemantics(page, browserName) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) {
    await placeholder.evaluate((element) => element.click());
  }
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 15000 });
  console.log(`${browserName} FLUTTER SEMANTICS = ENABLED`);
}

async function waitForHome(page, browserName) {
  await waitSemantic(page, '探索', { prefix: true, timeout: 20000 });
  const journeyAction = await findJourneyAction(page);
  await journeyAction.waitFor({ state: 'visible', timeout: 20000 });
  console.log(`${browserName} HOME INTERACTIVE STATE = PRESENT`);
}

async function dismissBottomSheet(page, expectedLabel) {
  await page.touchscreen.tap(22, 58);
  await semanticLabel(page, expectedLabel, { prefix: true }).waitFor({ state: 'detached', timeout: 10000 });
}

async function tapTabAndVerify(page, tabLabel, expectedPageLabel, browserName) {
  await tapSemanticAction(page, tabLabel, `${browserName}:${tabLabel}`, { prefix: true });
  await waitSemantic(page, expectedPageLabel, { prefix: true, timeout: 15000 });
  console.log(`${browserName} TAB ${tabLabel} STATE CHANGE = PASS`);
}

async function exerciseLevelControl(page, browserName) {
  const level = page.locator('flt-semantics[aria-label^="Phoenix 中文难度 "]').first();
  await level.waitFor({ state: 'attached', timeout: 15000 });
  const before = await level.getAttribute('aria-label');

  let control = semanticLabel(page, '提高当前难度', { prefix: true });
  let direction = 'PLUS';
  if (!(await control.count()) || !(await control.isEnabled())) {
    control = semanticLabel(page, '降低当前难度', { prefix: true });
    direction = 'MINUS';
  }
  await control.waitFor({ state: 'visible', timeout: 15000 });
  const disabled = await control.getAttribute('aria-disabled');
  if (disabled === 'true' || !(await control.isEnabled())) {
    throw new Error(`${browserName}: no enabled level control`);
  }
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
  await tapSemanticAction(page, '选择城市', `${browserName}:city-selector`, { prefix: true });
  await waitSemantic(page, '选择城市与地点', { prefix: true });
  console.log(`${browserName} CITY SELECTOR OPEN = PASS`);
  await dismissBottomSheet(page, '选择城市与地点');
  console.log(`${browserName} CITY SELECTOR CLOSE = PASS`);
}

async function openJourney(page, browserName, cycle) {
  const button = await findJourneyAction(page);
  await button.waitFor({ state: 'visible', timeout: 15000 });
  const action = await button.getAttribute('aria-label');
  const beforeUrl = page.url();
  await button.tap();
  const progress = await findJourneyProgress(page, 20000);
  if (page.url() === beforeUrl && !(await progress.node.count())) {
    throw new Error(`${browserName}: Journey cycle ${cycle} did not change route/state`);
  }
  console.log(`${browserName} JOURNEY CYCLE ${cycle} OPEN = PASS (${action}; ${progress.label})`);
}

async function reachDiscovery(page, browserName) {
  await waitSemantic(page, '1/6', { prefix: true });
  await waitSemantic(page, '故事', { prefix: true });
  await tapSemanticAction(page, '继续', `${browserName}:story-next`, { prefix: true });
  await sleep(500);
  await page.touchscreen.tap(22, 58);
  await waitSemantic(page, '2/6', { prefix: true, timeout: 15000 });
  await waitSemantic(page, '单词', { prefix: true, timeout: 15000 });
  await tapSemanticAction(page, '继续', `${browserName}:words-next`, { prefix: true });
  await waitSemantic(page, '3/6', { prefix: true, timeout: 15000 });
  await waitSemantic(page, '发现', { prefix: true, timeout: 15000 });
  console.log(`${browserName} DISCOVERY STATE TRANSITION = PASS`);
}

async function exitJourneyToHome(page, browserName, cycle) {
  const beforeUrl = page.url();
  await page.touchscreen.tap(28, 26);
  await waitForHome(page, browserName);
  const journeyAction = await findJourneyAction(page);
  if (!(await journeyAction.count())) {
    throw new Error(`${browserName}: Journey cycle ${cycle} return did not restore Home action`);
  }
  console.log(`${browserName} JOURNEY CYCLE ${cycle} RETURN = PASS (${beforeUrl} -> ${page.url()})`);
}

async function exercisePostReturnHome(page, browserName, cycle) {
  await tapTabAndVerify(page, '护照', '探索护照', browserName);
  await tapTabAndVerify(page, '探索', '欢迎回来，Explorer', browserName);
  await waitForHome(page, browserName);
  console.log(`${browserName} POST-CYCLE-${cycle} HOME INTERACTION = PASS`);
}

async function exerciseAllTabs(page, browserName) {
  await tapTabAndVerify(page, '护照', '探索护照', browserName);
  await tapTabAndVerify(page, '跟读训练', '听一句 · 跟一句 · 逐字对照 · 薄弱句复练', browserName);
  await tapTabAndVerify(page, '我的', 'HSK／TOCFL 能力设置', browserName);
  await tapTabAndVerify(page, '探索', '欢迎回来，Explorer', browserName);
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
