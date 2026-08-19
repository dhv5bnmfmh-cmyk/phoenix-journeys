import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium, webkit } = playwrightModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const normalize = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function semanticNode(page, label, { prefix = false, timeout = 15000 } = {}) {
  const wanted = normalize(label);
  const deadline = Date.now() + timeout;
  const nodes = page.locator('flt-semantics');
  while (Date.now() < deadline) {
    const index = await nodes.evaluateAll((elements, args) => {
      const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();
      const matches = (value) => args.prefix ? clean(value).startsWith(args.wanted) : clean(value) === args.wanted;
      const candidates = [];
      for (let i = 0; i < elements.length; i += 1) {
        const element = elements[i];
        const values = [
          element.getAttribute('aria-label'),
          element.getAttribute('aria-valuetext'),
          element.getAttribute('aria-description'),
          element.textContent,
        ];
        if (!values.some(matches)) continue;
        const rect = element.getBoundingClientRect();
        const style = getComputedStyle(element);
        const visible = rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden';
        candidates.push({ i, visible });
      }
      const visible = candidates.find((entry) => entry.visible);
      return visible?.i ?? candidates[0]?.i ?? -1;
    }, { wanted, prefix });
    if (index >= 0) return nodes.nth(index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${label}`);
}

async function semanticExists(page, label, options = {}) {
  try {
    await semanticNode(page, label, { ...options, timeout: options.timeout ?? 800 });
    return true;
  } catch (_) {
    return false;
  }
}

async function dumpSemantics(page, browserName) {
  const snapshot = await page.locator('flt-semantics').evaluateAll((elements) => elements.slice(0, 120).map((element) => ({
    ariaLabel: element.getAttribute('aria-label'),
    ariaValueText: element.getAttribute('aria-valuetext'),
    role: element.getAttribute('role'),
    text: String(element.textContent ?? '').replace(/\s+/g, ' ').trim(),
    rect: (() => {
      const rect = element.getBoundingClientRect();
      return [Math.round(rect.x), Math.round(rect.y), Math.round(rect.width), Math.round(rect.height)];
    })(),
  })));
  console.error(`${browserName} SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot)}`);
}

async function tapSemanticAction(page, label, logLabel, { prefix = false } = {}) {
  const action = await semanticNode(page, label, { prefix, timeout: 15000 });
  await action.waitFor({ state: 'visible', timeout: 15000 });
  const disabled = await action.getAttribute('aria-disabled');
  if (disabled === 'true' || !(await action.isEnabled())) throw new Error(`${logLabel}: action is disabled`);
  await action.tap({ timeout: 15000 });
  return action;
}

async function findJourneyAction(page) {
  for (const prefix of ['开始', '继续', '再次探索']) {
    try {
      return await semanticNode(page, prefix, { prefix: true, timeout: 1000 });
    } catch (_) {}
  }
  throw new Error('Home: no Start / Continue / Explore Again Journey action found');
}

async function findJourneyProgress(page, timeout = 20000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    for (let step = 1; step <= 6; step += 1) {
      try {
        const node = await semanticNode(page, `${step}/6`, { prefix: true, timeout: 250 });
        return { node, label: normalize(await node.getAttribute('aria-label') ?? await node.textContent()) };
      } catch (_) {}
    }
  }
  throw new Error('Journey: no semantic progress state (1/6..6/6) appeared');
}

async function enableFlutterSemantics(page, browserName) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 15000 });
  console.log(`${browserName} FLUTTER SEMANTICS = ENABLED`);
}

async function waitForHome(page, browserName) {
  await semanticNode(page, 'PHOENIX JOURNEYS', { timeout: 20000 });
  const journeyAction = await findJourneyAction(page);
  await journeyAction.waitFor({ state: 'visible', timeout: 20000 });
  console.log(`${browserName} HOME INTERACTIVE STATE = PRESENT`);
}

async function waitDetached(page, label, { prefix = false, timeout = 10000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if (!(await semanticExists(page, label, { prefix, timeout: 200 }))) return;
    await sleep(100);
  }
  throw new Error(`semantic state did not detach: ${label}`);
}

async function dismissBottomSheet(page, expectedLabel) {
  await page.touchscreen.tap(22, 58);
  await waitDetached(page, expectedLabel, { prefix: true, timeout: 10000 });
}

async function tapTabAndVerify(page, tabLabel, expectedPageLabel, browserName) {
  await tapSemanticAction(page, tabLabel, `${browserName}:${tabLabel}`, { prefix: true });
  await semanticNode(page, expectedPageLabel, { prefix: true, timeout: 15000 });
  console.log(`${browserName} TAB ${tabLabel} STATE CHANGE = PASS`);
}

async function exerciseLevelControl(page, browserName) {
  const level = await semanticNode(page, '查看 Lv.', { prefix: true, timeout: 15000 });
  const before = normalize(await level.getAttribute('aria-label') ?? await level.textContent());

  let control;
  let direction;
  try {
    control = await semanticNode(page, '提高当前难度', { prefix: true, timeout: 1000 });
    direction = 'PLUS';
  } catch (_) {
    control = await semanticNode(page, '降低当前难度', { prefix: true, timeout: 1000 });
    direction = 'MINUS';
  }
  const disabled = await control.getAttribute('aria-disabled');
  if (disabled === 'true' || !(await control.isEnabled())) throw new Error(`${browserName}: no enabled level control`);
  await control.tap();

  let after = before;
  for (let i = 0; i < 30 && after === before; i += 1) {
    await sleep(100);
    const current = await semanticNode(page, '查看 Lv.', { prefix: true, timeout: 1000 });
    after = normalize(await current.getAttribute('aria-label') ?? await current.textContent());
  }
  if (!before || !after || before === after) throw new Error(`${browserName}: level state did not change (${before} -> ${after})`);
  console.log(`${browserName} LV ${direction} = PASS (${before} -> ${after})`);
}

async function exerciseCitySelector(page, browserName) {
  await tapSemanticAction(page, '选择城市', `${browserName}:city-selector`, { prefix: true });
  await semanticNode(page, '选择城市与地点', { prefix: true, timeout: 15000 });
  console.log(`${browserName} CITY SELECTOR OPEN = PASS`);
  await dismissBottomSheet(page, '选择城市与地点');
  console.log(`${browserName} CITY SELECTOR CLOSE = PASS`);
}

async function openJourney(page, browserName, cycle) {
  const button = await findJourneyAction(page);
  const action = normalize(await button.getAttribute('aria-label') ?? await button.textContent());
  await button.tap({ timeout: 15000 });
  const progress = await findJourneyProgress(page, 20000);
  console.log(`${browserName} JOURNEY CYCLE ${cycle} OPEN = PASS (${action}; ${progress.label})`);
}

async function reachDiscovery(page, browserName) {
  await semanticNode(page, '1/6', { prefix: true, timeout: 15000 });
  await semanticNode(page, '故事', { prefix: true, timeout: 15000 });
  await tapSemanticAction(page, '继续', `${browserName}:story-next`, { prefix: true });
  await sleep(500);
  await semanticNode(page, '2/6', { prefix: true, timeout: 15000 });
  await semanticNode(page, '发现', { prefix: true, timeout: 15000 });
  console.log(`${browserName} JOURNEY DISCOVERY = PASS`);
}

async function returnHome(page, browserName, cycle) {
  const back = await semanticNode(page, '返回', { prefix: true, timeout: 15000 });
  await back.tap({ timeout: 15000 });
  await waitForHome(page, browserName);
  console.log(`${browserName} JOURNEY CYCLE ${cycle} RETURN HOME = PASS`);
}

async function verifyHomeInteractions(page, browserName, label) {
  await exerciseCitySelector(page, browserName);
  await exerciseLevelControl(page, browserName);
  await tapTabAndVerify(page, '护照', '旅行护照', browserName);
  await tapTabAndVerify(page, '跟读训练', '跟读训练', browserName);
  await tapTabAndVerify(page, '我的', '我的 Phoenix', browserName);
  await tapTabAndVerify(page, '探索', 'PHOENIX JOURNEYS', browserName);
  console.log(`${browserName} ${label} = PASS`);
}

async function runBrowser(browserType, browserName) {
  const browser = await browserType.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    isMobile: true,
    hasTouch: true,
    locale: 'zh-CN',
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  page.on('console', (message) => console.log(`[${browserName} console:${message.type()}] ${message.text()}`));
  page.on('pageerror', (error) => console.error(`${browserName} PAGE ERROR ${error.stack ?? error.message}`));

  let failed = false;
  try {
    await page.goto(url, { waitUntil: 'load', timeout: 60000 });
    await page.locator('flutter-view').first().waitFor({ state: 'attached', timeout: 60000 });
    await page.locator('#phoenix-loading').waitFor({ state: 'detached', timeout: 60000 });
    await enableFlutterSemantics(page, browserName);
    await waitForHome(page, browserName);
    console.log(`${browserName} HOME INITIAL INTERACTION = PASS`);
    await verifyHomeInteractions(page, browserName, 'HOME CONTROL COVERAGE');

    await openJourney(page, browserName, 1);
    await reachDiscovery(page, browserName);
    await returnHome(page, browserName, 1);
    await verifyHomeInteractions(page, browserName, 'POST-CYCLE-1 HOME RESPONSIVE');

    await openJourney(page, browserName, 2);
    await returnHome(page, browserName, 2);
    await verifyHomeInteractions(page, browserName, 'POST-CYCLE-2 HOME RESPONSIVE');

    console.log(`${browserName} REAL MOBILE FUNCTIONAL INTERACTION = PASS`);
  } catch (error) {
    failed = true;
    await dumpSemantics(page, browserName).catch(() => {});
    console.error(`${browserName} FUNCTIONAL AUDIT FAILURE`, error?.stack ?? error);
  } finally {
    await context.close();
    await browser.close();
  }
  return !failed;
}

const results = [];
for (const [browserType, browserName] of [[chromium, 'chromium'], [webkit, 'webkit']]) {
  results.push(await runBrowser(browserType, browserName));
}

console.log(`MOBILE INTERACTION SOURCE SHA = ${sourceSha}`);
if (!results.every(Boolean)) process.exit(1);
