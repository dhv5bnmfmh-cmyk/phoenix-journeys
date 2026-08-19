import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { chromium, webkit } = playwrightModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');

const domEventTypes = [
  'pointerdown',
  'pointerup',
  'pointercancel',
  'touchstart',
  'touchend',
  'touchcancel',
  'click',
];

async function installAuditBridge(page) {
  await page.addInitScript((types) => {
    window.__phoenixDomTrace = [];
    window.__phoenixAuditEvents = [];
    window.__phoenixAuditRects = {};

    const describe = (node) => ({
      tag: node?.tagName || node?.nodeName || null,
      id: node?.id || null,
      aria: node?.getAttribute?.('aria-label') || null,
    });
    const recordDom = (scope, event) => window.__phoenixDomTrace.push({
      scope,
      type: event.type,
      target: describe(event.target),
      currentTarget: describe(event.currentTarget),
      pointerType: event.pointerType || null,
      isTrusted: event.isTrusted,
      time: performance.now(),
    });

    for (const type of types) {
      window.addEventListener(type, (event) => recordDom('window', event), true);
      document.addEventListener(type, (event) => recordDom('document', event), true);
    }

    window.addEventListener('phoenix-interaction-audit', (event) => {
      let payload;
      try {
        payload = typeof event.detail === 'string' ? JSON.parse(event.detail) : event.detail;
      } catch (_) {
        payload = { type: 'invalid-audit-payload', raw: String(event.detail) };
      }
      if (!payload || typeof payload !== 'object') return;
      const entry = { ...payload, time: performance.now() };
      window.__phoenixAuditEvents.push(entry);
      if (payload.type === 'target-rect' && payload.id) {
        window.__phoenixAuditRects[payload.id] = {
          x: Number(payload.x),
          y: Number(payload.y),
          width: Number(payload.width),
          height: Number(payload.height),
        };
      }
    });
  }, domEventTypes);
}

async function attachFlutterDomTrace(page) {
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
        window.__phoenixDomTrace.push({
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
  }, domEventTypes);
}

async function startupState(page) {
  return page.evaluate(() => {
    const cover = document.getElementById('phoenix-loading');
    const view = document.querySelector('flutter-view');
    const coverStyle = cover ? getComputedStyle(cover) : null;
    const viewStyle = view ? getComputedStyle(view) : null;
    return {
      marks: performance.getEntriesByType('mark').map((entry) => ({
        name: entry.name,
        startTime: entry.startTime,
      })),
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

async function waitForRect(page, id, timeout = 15000) {
  await page.waitForFunction(
    (targetId) => {
      const rect = window.__phoenixAuditRects?.[targetId];
      return rect && rect.width > 0 && rect.height > 0;
    },
    id,
    { timeout },
  );
  return page.evaluate((targetId) => window.__phoenixAuditRects[targetId], id);
}

async function auditLength(page) {
  return page.evaluate(() => window.__phoenixAuditEvents?.length || 0);
}

async function waitForAuditEvent(page, startIndex, predicateSource, label, timeout = 10000) {
  const handle = await page.waitForFunction(
    ({ startIndex, predicateSource }) => {
      const predicate = new Function('entry', `return (${predicateSource})(entry);`);
      const events = (window.__phoenixAuditEvents || []).slice(startIndex);
      return events.find((entry) => predicate(entry)) || false;
    },
    { startIndex, predicateSource },
    { timeout },
  );
  const event = await handle.jsonValue();
  console.log(`${label} OBSERVED`);
  console.log(JSON.stringify(event, null, 2));
  return event;
}

async function rawTouch(page, rect, label) {
  await page.evaluate(() => { window.__phoenixDomTrace = []; });
  const startIndex = await auditLength(page);
  const x = rect.x + rect.width / 2;
  const y = rect.y + rect.height / 2;
  await page.touchscreen.tap(x, y);
  await page.waitForTimeout(350);

  const domEvents = await page.evaluate(() => window.__phoenixDomTrace || []);
  const auditEvents = await page.evaluate(
    (index) => (window.__phoenixAuditEvents || []).slice(index),
    startIndex,
  );
  console.log(`TOUCH TRACE ${label}`);
  console.log(JSON.stringify({ x, y, domEvents, auditEvents }, null, 2));

  const trustedDomStart = domEvents.some((entry) =>
    entry.isTrusted && (entry.type === 'touchstart' || entry.type === 'pointerdown'));
  const trustedDomEnd = domEvents.some((entry) =>
    entry.isTrusted && (entry.type === 'touchend' || entry.type === 'pointerup'));
  const trustedFlutterViewStart = domEvents.some((entry) =>
    entry.scope === 'flutter-view' &&
    entry.isTrusted &&
    (entry.type === 'touchstart' || entry.type === 'pointerdown'));
  const trustedFlutterViewEnd = domEvents.some((entry) =>
    entry.scope === 'flutter-view' &&
    entry.isTrusted &&
    (entry.type === 'touchend' || entry.type === 'pointerup'));

  console.log(`ACTION = ${label}`);
  console.log(`DOM pointer/touch start = ${trustedDomStart ? 'YES' : 'NO'}`);
  console.log(`DOM pointer/touch end = ${trustedDomEnd ? 'YES' : 'NO'}`);
  console.log(`flutter-view start = ${trustedFlutterViewStart ? 'YES' : 'NO'}`);
  console.log(`flutter-view end = ${trustedFlutterViewEnd ? 'YES' : 'NO'}`);

  if (!trustedDomStart || !trustedDomEnd) {
    throw new Error(`${label}: incomplete trusted DOM touch sequence`);
  }
  if (!trustedFlutterViewStart || !trustedFlutterViewEnd) {
    throw new Error(`${label}: trusted touch sequence did not reach flutter-view`);
  }
  return startIndex;
}

async function dismissModalByTouch(page, browserName) {
  const startIndex = await rawTouch(
    page,
    { x: 0, y: 60, width: 40, height: 40 },
    `${browserName}:modal-dismiss`,
  );
  await waitForAuditEvent(
    page,
    startIndex,
    `(entry) => entry.type === 'route-pop'`,
    `${browserName}:modal-dismiss-route`,
  );
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
    await installAuditBridge(page);

    const separator = url.includes('?') ? '&' : '?';
    const auditUrl = `${url}${separator}unlock=all&prototype=journeys&interaction_audit=1&v=${sourceSha}`;
    await page.goto(auditUrl, { waitUntil: 'load', timeout: 140000 });
    try {
      await page.waitForFunction(
        () => performance.getEntriesByName('phoenix-main-interactive').length > 0,
        null,
        { timeout: 140000 },
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

    await attachFlutterDomTrace(page);
    console.log(`${browserName} POST-STARTUP DOM STATE`);
    console.log(JSON.stringify(await startupState(page), null, 2));

    const passport = await waitForRect(page, 'bottom-nav-passport');
    let actionStart = await rawTouch(page, passport, `${browserName}:bottom-nav-passport`);
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'home-tab-state' && entry.selectedTab === 1`,
      `${browserName}:bottom-nav-passport-state`,
    );
    console.log(`${browserName} BOTTOM NAVIGATION PASSPORT = PASS`);

    const explore = await waitForRect(page, 'bottom-nav-explore');
    actionStart = await rawTouch(page, explore, `${browserName}:bottom-nav-explore`);
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'home-tab-state' && entry.selectedTab === 0`,
      `${browserName}:bottom-nav-explore-state`,
    );
    console.log(`${browserName} BOTTOM NAVIGATION = PASS`);

    let levelRect = await waitForRect(page, 'level-plus');
    actionStart = await rawTouch(page, levelRect, `${browserName}:level-plus`);
    try {
      await waitForAuditEvent(
        page,
        actionStart,
        `(entry) => entry.type === 'level-state'`,
        `${browserName}:level-state`,
        4000,
      );
    } catch (_) {
      levelRect = await waitForRect(page, 'level-minus');
      actionStart = await rawTouch(page, levelRect, `${browserName}:level-minus`);
      await waitForAuditEvent(
        page,
        actionStart,
        `(entry) => entry.type === 'level-state'`,
        `${browserName}:level-state-fallback`,
      );
    }
    console.log(`${browserName} LV CONTROL = PASS`);

    const city = await waitForRect(page, 'city-selector');
    actionStart = await rawTouch(page, city, `${browserName}:city-selector`);
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'route-push'`,
      `${browserName}:city-selector-route`,
    );
    console.log(`${browserName} CITY SELECTOR = PASS`);
    await dismissModalByTouch(page, browserName);

    const startJourney = await waitForRect(page, 'start-journey');
    actionStart = await rawTouch(page, startJourney, `${browserName}:start-journey`);
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'route-push'`,
      `${browserName}:start-journey-route`,
    );
    console.log(`${browserName} START JOURNEY = PASS`);

    actionStart = await rawTouch(
      page,
      { x: 0, y: 0, width: 56, height: 52 },
      `${browserName}:journey-back`,
    );
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'route-pop'`,
      `${browserName}:journey-back-route`,
    );
    console.log(`${browserName} BACK = PASS`);

    const discovery = await waitForRect(page, 'discovery');
    actionStart = await rawTouch(page, discovery, `${browserName}:discovery`);
    await waitForAuditEvent(
      page,
      actionStart,
      `(entry) => entry.type === 'route-push'`,
      `${browserName}:discovery-route`,
    );
    console.log(`${browserName} DISCOVERY = PASS`);

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
