import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium, webkit } = playwrightModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');

const eventTypes = ['pointerdown', 'pointerup', 'pointercancel', 'touchstart', 'touchend', 'touchcancel', 'click'];

async function installTrace(page) {
  await page.addInitScript((types) => {
    window.__phoenixInteractionTrace = [];
    const describe = (node) => ({
      tag: node?.tagName || node?.nodeName || null,
      id: node?.id || null,
      aria: node?.getAttribute?.('aria-label') || null,
    });
    const record = (scope, event) => window.__phoenixInteractionTrace.push({
      scope,
      type: event.type,
      target: describe(event.target),
      currentTarget: describe(event.currentTarget),
      pointerType: event.pointerType || null,
      isTrusted: event.isTrusted,
      time: performance.now(),
    });
    for (const type of types) {
      window.addEventListener(type, (event) => record('window', event), true);
      document.addEventListener(type, (event) => record('document', event), true);
    }
  }, eventTypes);
}

async function attachFlutterTrace(page) {
  await page.evaluate((types) => {
    const view = document.querySelector('flutter-view');
    if (!view || view.dataset.phoenixTraceAttached === '1') return;
    view.dataset.phoenixTraceAttached = '1';
    const describe = (node) => ({
      tag: node?.tagName || node?.nodeName || null,
      id: node?.id || null,
      aria: node?.getAttribute?.('aria-label') || null,
    });
    for (const type of types) {
      view.addEventListener(type, (event) => {
        window.__phoenixInteractionTrace.push({
          scope: 'flutter-view',
          type: event.type,
          target: describe(event.target),
          currentTarget: describe(event.currentTarget),
          pointerType: event.pointerType || null,
          isTrusted: event.isTrusted,
          time: performance.now(),
        });
      }, true);
    }
  }, eventTypes);
}

async function startupState(page) {
  return page.evaluate(() => {
    const cover = document.getElementById('phoenix-loading');
    const view = document.querySelector('flutter-view');
    const coverStyle = cover ? getComputedStyle(cover) : null;
    const viewStyle = view ? getComputedStyle(view) : null;
    return {
      marks: performance.getEntriesByType('mark').map((entry) => ({ name: entry.name, startTime: entry.startTime })),
      htmlInert: document.documentElement.hasAttribute('inert'),
      bodyInert: document.body.hasAttribute('inert'),
      bodyPointerEvents: getComputedStyle(document.body).pointerEvents,
      cover: cover ? {
        present: true,
        className: cover.className,
        inert: cover.hasAttribute('inert'),
        ariaHidden: cover.getAttribute('aria-hidden'),
        pointerEvents: coverStyle.pointerEvents,
        visibility: coverStyle.visibility,
        opacity: coverStyle.opacity,
      } : { present: false },
      flutterView: view ? {
        present: true,
        inert: view.hasAttribute('inert'),
        pointerEvents: viewStyle.pointerEvents,
        touchAction: viewStyle.touchAction,
      } : { present: false },
    };
  });
}

async function enableSemantics(page) {
  // Accessibility is enabled only to discover Flutter-owned rectangles and to
  // observe state changes. Actual audit taps bypass the semantics DOM host and
  // hit flutter-view through the browser's trusted touchscreen API.
  await page.evaluate(() => {
    const collect = (root) => {
      const elements = [...root.querySelectorAll('*')];
      for (const element of [...elements]) {
        if (element.shadowRoot) elements.push(...collect(element.shadowRoot));
      }
      return elements;
    };
    const placeholder = collect(document).find((element) =>
      element.tagName?.toLowerCase() === 'flt-semantics-placeholder' ||
      element.getAttribute?.('aria-label') === 'Enable accessibility'
    );
    placeholder?.click();
  });
  await page.waitForTimeout(500);
}

async function semanticSnapshot(page) {
  return page.evaluate(() => {
    const collect = (root) => {
      const elements = [...root.querySelectorAll('*')];
      for (const element of [...elements]) {
        if (element.shadowRoot) elements.push(...collect(element.shadowRoot));
      }
      return elements;
    };
    return collect(document).map((element) => {
      const tag = element.tagName?.toLowerCase() || '';
      if (!tag.includes('semantics') && !element.getAttribute?.('role')) return null;
      const rect = element.getBoundingClientRect?.();
      const aria = element.getAttribute?.('aria-label') || '';
      const text = (element.innerText || element.textContent || '').trim();
      const label = aria || text;
      if (!label || !rect || rect.width <= 0 || rect.height <= 0) return null;
      return {
        tag: element.tagName,
        role: element.getAttribute?.('role') || null,
        label,
        rect: { x: rect.x, y: rect.y, width: rect.width, height: rect.height },
      };
    }).filter(Boolean);
  });
}

async function boxFor(page, matcher, label) {
  const snapshot = await semanticSnapshot(page);
  const matches = snapshot.filter((entry) => matcher(entry.label));
  matches.sort((a, b) => (a.rect.width * a.rect.height) - (b.rect.width * b.rect.height));
  if (!matches.length) {
    console.log(`SEMANTIC SNAPSHOT BEFORE ${label}`);
    console.log(JSON.stringify(snapshot, null, 2));
    throw new Error(`${label}: semantic target not found`);
  }
  return matches[0];
}

async function semanticsHas(page, matcher) {
  return (await semanticSnapshot(page)).some((entry) => matcher(entry.label));
}

async function disableSemanticsHitTesting(page) {
  await page.evaluate(() => {
    const collect = (root) => {
      const elements = [...root.querySelectorAll('*')];
      for (const element of [...elements]) {
        if (element.shadowRoot) elements.push(...collect(element.shadowRoot));
      }
      return elements;
    };
    for (const element of collect(document)) {
      if (element.tagName?.toLowerCase() === 'flt-semantics-host') {
        element.style.setProperty('pointer-events', 'none', 'important');
      }
    }
  });
}

async function rawTouch(page, target, label) {
  await page.evaluate(() => { window.__phoenixInteractionTrace = []; });
  const x = target.rect.x + target.rect.width / 2;
  const y = target.rect.y + target.rect.height / 2;
  await page.touchscreen.tap(x, y);
  await page.waitForTimeout(350);
  const events = await page.evaluate(() => window.__phoenixInteractionTrace || []);
  console.log(`TOUCH TRACE ${label}`);
  console.log(JSON.stringify({ x, y, events }, null, 2));
  const trustedStart = events.some((entry) => entry.isTrusted && (entry.type === 'touchstart' || entry.type === 'pointerdown'));
  const flutterStart = events.some((entry) => entry.scope === 'flutter-view' && entry.isTrusted && (entry.type === 'touchstart' || entry.type === 'pointerdown'));
  if (!trustedStart) throw new Error(`${label}: DOM received no trusted touch/pointer start`);
  if (!flutterStart) throw new Error(`${label}: trusted touch did not reach flutter-view`);
}

async function waitSemantic(page, matcher, label, timeout = 8000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if (await semanticsHas(page, matcher)) return;
    await page.waitForTimeout(100);
  }
  console.log(`SEMANTIC SNAPSHOT AFTER FAILED ${label}`);
  console.log(JSON.stringify(await semanticSnapshot(page), null, 2));
  throw new Error(`${label}: trusted Flutter touch produced no observable UI state/route change`);
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
    await installTrace(page);

    const separator = url.includes('?') ? '&' : '?';
    const auditUrl = `${url}${separator}unlock=all&prototype=journeys&interaction_audit=1&v=${sourceSha}`;
    await page.goto(auditUrl, { waitUntil: 'load', timeout: 120000 });
    try {
      await page.waitForFunction(() => performance.getEntriesByName('phoenix-main-interactive').length > 0, null, { timeout: 120000 });
      await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 30000 });
    } catch (error) {
      console.log(`${browserName} STARTUP WAIT STATE`);
      console.log(JSON.stringify(await startupState(page), null, 2));
      throw error;
    }

    await attachFlutterTrace(page);
    await enableSemantics(page);
    console.log(`${browserName} DOM STATE`);
    console.log(JSON.stringify(await startupState(page), null, 2));
    console.log(`${browserName} SEMANTIC STATE`);
    console.log(JSON.stringify(await semanticSnapshot(page), null, 2));
    await disableSemanticsHitTesting(page);

    const passport = await boxFor(page, (value) => value === '护照' || /护照\s*$/.test(value), 'bottom-nav-passport');
    await rawTouch(page, passport, `${browserName}:bottom-nav-passport`);
    await waitSemantic(page, (value) => value.includes('探索护照') || value.includes('足迹'), `${browserName}:bottom-nav-passport`);
    console.log(`${browserName} BOTTOM NAVIGATION = PASS`);

    const explore = await boxFor(page, (value) => value === '探索' || /探索\s*$/.test(value), 'bottom-nav-explore');
    await rawTouch(page, explore, `${browserName}:bottom-nav-explore`);
    await waitSemantic(page, (value) => value.includes('Discovery · 今日发现'), `${browserName}:bottom-nav-explore`);

    const levelLabels = (await semanticSnapshot(page)).map((entry) => entry.label).filter((value) => value.includes('Phoenix 中文难度 '));
    const current = Number(levelLabels[0]?.match(/(\d+) 级/)?.[1]);
    if (!Number.isFinite(current)) throw new Error(`${browserName}: current level not observable`);
    const levelControl = current >= 10
      ? await boxFor(page, (value) => value.includes('降低当前难度'), 'level-minus')
      : await boxFor(page, (value) => value.includes('提高当前难度'), 'level-plus');
    await rawTouch(page, levelControl, `${browserName}:level-control`);
    const expected = current >= 10 ? current - 1 : current + 1;
    await waitSemantic(page, (value) => value.includes(`Phoenix 中文难度 ${expected} 级`), `${browserName}:level-control`);
    console.log(`${browserName} LV CONTROL = PASS`);

    const city = await boxFor(page, (value) => value.includes('选择城市'), 'city-selector');
    await rawTouch(page, city, `${browserName}:city-selector`);
    await waitSemantic(page, (value) => value.includes('选择城市与地点'), `${browserName}:city-selector`);
    console.log(`${browserName} CITY SELECTOR = PASS`);
    await page.keyboard.press('Escape');
    await page.waitForTimeout(350);

    const start = await boxFor(page, (value) => /(?:开始|继续|再次探索).+Journey/.test(value), 'start-journey');
    await rawTouch(page, start, `${browserName}:start-journey`);
    await waitSemantic(page, (value) => /^(Back|返回|后退)$/.test(value) || value.includes('返回'), `${browserName}:start-journey`);
    console.log(`${browserName} START JOURNEY = PASS`);

    const back = await boxFor(page, (value) => /^(Back|返回|后退)$/.test(value) || value.includes('返回'), 'journey-back');
    await rawTouch(page, back, `${browserName}:journey-back`);
    await waitSemantic(page, (value) => value.includes('选择城市'), `${browserName}:journey-back`);
    console.log(`${browserName} BACK = PASS`);

    const discovery = (await semanticSnapshot(page)).filter((entry) => entry.label.includes('Discovery · 今日发现'));
    const discoveryButton = discovery.find((entry) => entry.role === 'button');
    if (!discoveryButton) throw new Error(`${browserName}: Discovery card is static and has no callback`);
    await rawTouch(page, discoveryButton, `${browserName}:discovery`);
    console.log(`${browserName} DISCOVERY TOUCH = PASS`);

    if (pageErrors.length) throw new Error(`${browserName}: page errors: ${pageErrors.join('\n')}`);
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
