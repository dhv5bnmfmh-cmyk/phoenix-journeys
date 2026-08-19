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
    const describe = (node) => {
      if (!node) return null;
      return {
        tag: node.tagName || node.nodeName || null,
        id: node.id || null,
        aria: node.getAttribute?.('aria-label') || null,
      };
    };
    const record = (scope, event) => {
      window.__phoenixInteractionTrace.push({
        scope,
        type: event.type,
        target: describe(event.target),
        currentTarget: describe(event.currentTarget),
        pointerType: event.pointerType || null,
        isTrusted: event.isTrusted,
        time: performance.now(),
      });
    };
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
      readyState: document.readyState,
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
  await page.evaluate(() => {
    const walk = (root) => {
      const elements = [...root.querySelectorAll('*')];
      for (const element of elements) {
        if (element.shadowRoot) elements.push(...walk(element.shadowRoot));
      }
      return elements;
    };
    const all = walk(document);
    const placeholder = all.find((element) =>
      element.tagName?.toLowerCase() === 'flt-semantics-placeholder' ||
      element.getAttribute?.('aria-label') === 'Enable accessibility'
    );
    placeholder?.click();
  });
  await page.waitForFunction(() => {
    const collect = (root) => {
      const elements = [...root.querySelectorAll('*')];
      for (const element of [...elements]) {
        if (element.shadowRoot) elements.push(...collect(element.shadowRoot));
      }
      return elements;
    };
    return collect(document).some((element) => element.getAttribute?.('aria-label'));
  }, null, { timeout: 15000 });
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
    return collect(document)
      .map((element) => {
        const rect = element.getBoundingClientRect?.();
        const label = element.getAttribute?.('aria-label') || '';
        if (!label || !rect || rect.width <= 0 || rect.height <= 0) return null;
        return {
          tag: element.tagName,
          role: element.getAttribute?.('role') || null,
          label,
          selected: element.getAttribute?.('aria-selected'),
          checked: element.getAttribute?.('aria-checked'),
          pressed: element.getAttribute?.('aria-pressed'),
          rect: { x: rect.x, y: rect.y, width: rect.width, height: rect.height },
        };
      })
      .filter(Boolean);
  });
}

async function boxFor(page, matcher) {
  const snapshot = await semanticSnapshot(page);
  const matches = snapshot.filter((entry) => matcher(entry.label));
  matches.sort((a, b) => (a.rect.width * a.rect.height) - (b.rect.width * b.rect.height));
  if (!matches.length) {
    console.log('SEMANTIC LABELS', JSON.stringify(snapshot.map((entry) => entry.label), null, 2));
    throw new Error('semantic target not found');
  }
  return matches[0];
}

async function semanticsHas(page, matcher) {
  const snapshot = await semanticSnapshot(page);
  return snapshot.some((entry) => matcher(entry.label));
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

async function resetTrace(page) {
  await page.evaluate(() => { window.__phoenixInteractionTrace = []; });
}

async function trace(page) {
  return page.evaluate(() => window.__phoenixInteractionTrace || []);
}

async function rawTouch(page, target, label) {
  await resetTrace(page);
  const x = target.rect.x + target.rect.width / 2;
  const y = target.rect.y + target.rect.height / 2;
  await page.touchscreen.tap(x, y);
  await page.waitForTimeout(350);
  const events = await trace(page);
  console.log(`TOUCH TRACE ${label}`);
  console.log(JSON.stringify({ x, y, events }, null, 2));
  const trustedTouch = events.some((entry) => entry.isTrusted && (entry.type === 'touchstart' || entry.type === 'pointerdown'));
  if (!trustedTouch) throw new Error(`${label}: browser emitted no trusted touch/pointer start`);
  return events;
}

async function waitSemantic(page, matcher, timeout = 5000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if (await semanticsHas(page, matcher)) return;
    await page.waitForTimeout(100);
  }
  throw new Error('expected semantic state change did not occur');
}

async function runBrowser(browserType, browserName) {
  const browser = await browserType.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 3,
    isMobile: true,
    hasTouch: true,
    locale: 'zh-CN',
  });
  const page = await context.newPage();
  const pageErrors = [];
  page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
  page.on('console', (message) => console.log(`[${browserName} console:${message.type()}] ${message.text()}`));
  await installTrace(page);

  const separator = url.includes('?') ? '&' : '?';
  const auditUrl = `${url}${separator}unlock=all&prototype=journeys&interaction_audit=1&v=${sourceSha}`;
  await page.goto(auditUrl, { waitUntil: 'load', timeout: 90000 });
  try {
    await page.waitForFunction(
      () => performance.getEntriesByName('phoenix-main-interactive').length > 0,
      null,
      { timeout: 90000 },
    );
    await page.waitForFunction(
      () => document.getElementById('phoenix-loading') == null,
      null,
      { timeout: 30000 },
    );
  } catch (error) {
    console.log(`${browserName} STARTUP WAIT STATE`);
    console.log(JSON.stringify(await startupState(page), null, 2));
    throw error;
  }

  await attachFlutterTrace(page);
  await enableSemantics(page);
  await disableSemanticsHitTesting(page);

  const domState = await startupState(page);
  console.log(`${browserName} DOM STATE`);
  console.log(JSON.stringify(domState, null, 2));

  const passport = await boxFor(page, (label) => label === '护照');
  await rawTouch(page, passport, `${browserName}:bottom-nav-passport`);
  await waitSemantic(page, (label) => label.includes('探索护照'));
  console.log(`${browserName} BOTTOM NAVIGATION = PASS`);

  const explore = await boxFor(page, (label) => label === '探索');
  await rawTouch(page, explore, `${browserName}:bottom-nav-explore`);
  await waitSemantic(page, (label) => label.includes('Discovery · 今日发现'));

  const beforeLevels = (await semanticSnapshot(page)).map((entry) => entry.label).filter((label) => label.startsWith('Phoenix 中文难度 '));
  const beforeLevel = beforeLevels[0];
  const current = Number(beforeLevel?.match(/(\d+) 级/)?.[1]);
  const levelControl = current >= 10
    ? await boxFor(page, (label) => label.includes('降低当前难度'))
    : await boxFor(page, (label) => label.includes('提高当前难度'));
  await rawTouch(page, levelControl, `${browserName}:level-control`);
  const expected = current >= 10 ? current - 1 : current + 1;
  await waitSemantic(page, (label) => label.includes(`Phoenix 中文难度 ${expected} 级`));
  console.log(`${browserName} LV CONTROL = PASS`);

  const city = await boxFor(page, (label) => label.includes('选择城市'));
  await rawTouch(page, city, `${browserName}:city-selector`);
  await waitSemantic(page, (label) => label.includes('选择城市与地点'));
  console.log(`${browserName} CITY SELECTOR = PASS`);
  await page.keyboard.press('Escape');
  await page.waitForTimeout(350);

  const start = await boxFor(page, (label) => /(?:开始|继续|再次探索).+Journey/.test(label));
  await rawTouch(page, start, `${browserName}:start-journey`);
  await waitSemantic(page, (label) => /^(Back|返回|后退)$/.test(label) || label.includes('返回'));
  console.log(`${browserName} START JOURNEY = PASS`);

  const back = await boxFor(page, (label) => /^(Back|返回|后退)$/.test(label) || label.includes('返回'));
  await rawTouch(page, back, `${browserName}:journey-back`);
  await waitSemantic(page, (label) => label.includes('选择城市'));
  console.log(`${browserName} BACK = PASS`);

  const discoveryLabels = (await semanticSnapshot(page)).filter((entry) => entry.label.includes('Discovery · 今日发现'));
  const discoveryButton = discoveryLabels.find((entry) => entry.role === 'button');
  if (!discoveryButton) {
    console.log(`${browserName} DISCOVERY = FAIL_STATIC_NO_CALLBACK`);
    throw new Error(`${browserName}: Discovery card has no functional button/callback`);
  }

  await rawTouch(page, discoveryButton, `${browserName}:discovery`);
  console.log(`${browserName} DISCOVERY = TOUCH_DISPATCHED`);

  if (pageErrors.length) throw new Error(`${browserName}: page errors: ${pageErrors.join('\n')}`);
  console.log(`${browserName} REAL MOBILE FUNCTIONAL INTERACTION AUDIT = PASS`);
  await browser.close();
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
