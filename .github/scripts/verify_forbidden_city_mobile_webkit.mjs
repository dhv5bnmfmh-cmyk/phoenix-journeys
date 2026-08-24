import { pathToFileURL } from 'node:url';

const { webkit, devices } = await import(
  pathToFileURL(process.env.PLAYWRIGHT_PATH).href
);

const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) {
  throw new Error(
    'usage: verify_forbidden_city_mobile_webkit.mjs <preview-url> <sha>',
  );
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

function attachDiagnostics(page, label) {
  const consoleMessages = [];
  const pageErrors = [];
  const failedRequests = [];

  page.on('console', (message) => {
    consoleMessages.push(`${message.type()}: ${message.text()}`);
  });
  page.on('pageerror', (error) => {
    pageErrors.push(error?.stack || error?.message || String(error));
  });
  page.on('requestfailed', (request) => {
    failedRequests.push(
      `${request.method()} ${request.url()} :: ${request.failure()?.errorText || 'failed'}`,
    );
  });

  return {
    async dump(reason) {
      let runtime = null;
      let semantics = [];
      try {
        runtime = await page.evaluate(() => ({
          url: location.href,
          readyState: document.readyState,
          loadingSeen: Boolean(window.__phoenixLoadingSeen),
          loadingPresent: Boolean(document.getElementById('phoenix-loading')),
          loadingText:
            document.getElementById('phoenix-loading-text')?.textContent || null,
          flutterViewPresent: Boolean(document.querySelector('flutter-view')),
          startupEvents: window.__phoenixStartupEvents || [],
          userAgent: navigator.userAgent,
          serviceWorkerControlled: Boolean(navigator.serviceWorker?.controller),
        }));
        semantics = await page.locator('flt-semantics').evaluateAll((elements) =>
          elements.slice(0, 250).map((element) => ({
            role: element.getAttribute('role'),
            label: element.getAttribute('aria-label') || '',
            value: element.getAttribute('aria-valuetext') || '',
            description: element.getAttribute('aria-description') || '',
            text: String(element.textContent || '').replace(/\s+/g, ' ').trim(),
          })),
        );
      } catch (error) {
        runtime = { diagnosticError: String(error) };
      }

      console.error(`MOBILE WEBKIT DIAGNOSTICS [${label}] ${reason}`);
      console.error(
        JSON.stringify(
          {
            runtime,
            semantics,
            pageErrors,
            failedRequests,
            consoleMessages,
          },
          null,
          2,
        ),
      );
      try {
        await page.screenshot({
          path: `test-results/mobile-webkit-${label}-failure.png`,
          fullPage: true,
        });
      } catch (_) {
        // The textual runtime evidence above remains authoritative.
      }
    },
    assertNoBlockingRuntimeError() {
      if (pageErrors.length) {
        throw new Error(
          `Mobile WebKit page error: ${pageErrors.join(' | ')}`,
        );
      }
      const blocking = consoleMessages.find((message) =>
        /Phoenix Journeys failed to start|Uncaught|Unhandled|TypeError|ReferenceError/i.test(
          message,
        ),
      );
      if (blocking) {
        throw new Error(`Mobile WebKit blocking console error: ${blocking}`);
      }
    },
  };
}

async function installStartupProbe(page) {
  await page.addInitScript(() => {
    window.__phoenixStartupEvents = [];
    window.__phoenixLoadingSeen = false;

    const markLoading = () => {
      if (document.getElementById('phoenix-loading')) {
        window.__phoenixLoadingSeen = true;
      }
    };

    window.addEventListener('phoenix-startup-settled', (event) => {
      window.__phoenixStartupEvents.push({
        detail: event?.detail ?? null,
        at: performance.now(),
      });
    });

    document.addEventListener('readystatechange', markLoading);
    document.addEventListener('DOMContentLoaded', markLoading);
    new MutationObserver(markLoading).observe(document, {
      childList: true,
      subtree: true,
    });
    markLoading();
  });
}

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((elements) =>
    elements.map((element, index) => {
      const rect = element.getBoundingClientRect();
      const style = getComputedStyle(element);
      return {
        index,
        role: element.getAttribute('role'),
        label: element.getAttribute('aria-label') || '',
        value: element.getAttribute('aria-valuetext') || '',
        description: element.getAttribute('aria-description') || '',
        text: String(element.textContent || '').replace(/\s+/g, ' ').trim(),
        disabled: element.getAttribute('aria-disabled') === 'true',
        visible:
          rect.width > 0 &&
          rect.height > 0 &&
          style.display !== 'none' &&
          style.visibility !== 'hidden',
        area: rect.width * rect.height,
      };
    }),
  );
}

const recordText = (record) =>
  clean(
    [record.label, record.value, record.description, record.text]
      .filter(Boolean)
      .join(' '),
  );

async function findSemantic(
  page,
  needle,
  { role = null, prefix = false, timeout = 20000 } = {},
) {
  const deadline = Date.now() + timeout;
  const wanted = clean(needle);
  while (Date.now() < deadline) {
    const matches = (await records(page))
      .filter((record) => {
        if (!record.visible || (role && record.role !== role)) return false;
        const text = recordText(record);
        return prefix ? text.startsWith(wanted) : text.includes(wanted);
      })
      .sort((left, right) => {
        if (left.role === 'button' && right.role !== 'button') return -1;
        if (right.role === 'button' && left.role !== 'button') return 1;
        return left.area - right.area;
      });
    if (matches.length) {
      return page.locator('flt-semantics').nth(matches[0].index);
    }
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function exists(page, needle, options = {}) {
  try {
    await findSemantic(page, needle, {
      ...options,
      timeout: options.timeout ?? 700,
    });
    return true;
  } catch (_) {
    return false;
  }
}

async function tapButton(
  page,
  needle,
  { prefix = false, timeout = 20000 } = {},
) {
  const deadline = Date.now() + timeout;
  let lastError = null;
  while (Date.now() < deadline) {
    const remaining = Math.max(250, deadline - Date.now());
    try {
      const node = await findSemantic(page, needle, {
        role: 'button',
        prefix,
        timeout: Math.min(1800, remaining),
      });
      const disabled = await node.getAttribute('aria-disabled', {
        timeout: Math.min(900, remaining),
      });
      if (disabled === 'true') {
        throw new Error(`button disabled: ${needle}`);
      }
      await node.tap({ timeout: Math.min(2500, remaining) });
      return;
    } catch (error) {
      if (String(error?.message || error).includes(`button disabled: ${needle}`)) {
        throw error;
      }
      if (
        !(await exists(page, needle, {
          role: 'button',
          prefix,
          timeout: 250,
        }))
      ) {
        return;
      }
      lastError = error;
      await sleep(100);
    }
  }
  throw lastError ?? new Error(`button not tappable: ${needle}`);
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) {
    await placeholder.evaluate((element) => element.click());
  }
  await page
    .locator('flt-semantics')
    .first()
    .waitFor({ state: 'attached', timeout: 30000 });
}

async function requireStartup(page, url, label) {
  const response = await page.goto(url, {
    waitUntil: 'load',
    timeout: 140000,
  });
  if (!response?.ok()) {
    throw new Error(`Mobile WebKit HTTP load failed: ${response?.status()}`);
  }
  await page.waitForFunction(
    () => document.querySelector('flutter-view') != null,
    null,
    { timeout: 140000 },
  );
  await page.waitForFunction(
    () => document.getElementById('phoenix-loading') == null,
    null,
    { timeout: 45000 },
  );
  const startup = await page.evaluate(() => ({
    loadingSeen: Boolean(window.__phoenixLoadingSeen),
    events: window.__phoenixStartupEvents || [],
  }));
  if (!startup.loadingSeen) {
    throw new Error(`${label}: Phoenix launch cover was never observed`);
  }
  if (!startup.events.some((event) => event.detail === 'ready')) {
    throw new Error(
      `${label}: phoenix-startup-settled ready event was not observed`,
    );
  }
  await enableSemantics(page);
  await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
}

async function verifyFounderEquivalentBareExperience(browser) {
  const context = await browser.newContext({
    ...devices['iPhone 13'],
    locale: 'zh-CN',
  });
  const page = await context.newPage();
  const diagnostics = attachDiagnostics(page, 'bare-founder-experience');
  await installStartupProbe(page);
  try {
    await requireStartup(page, baseUrl, 'bare preview startup');
    diagnostics.assertNoBlockingRuntimeError();
    console.log(
      `MOBILE WEBKIT BARE STARTUP = PASS | DEVICE=iPhone 13 | SHA=${sourceSha}`,
    );

    await tapButton(page, '选择城市', { prefix: true });
    await findSemantic(page, '选择城市与地点', { timeout: 20000 });
    await tapButton(page, '北京');
    await findSemantic(page, '北京的地点', { timeout: 20000 });
    await tapButton(page, '紫禁城');

    await findSemantic(page, '北京 · 紫禁城', { timeout: 30000 });
    await findSemantic(page, '1/6', { prefix: true, timeout: 30000 });
    diagnostics.assertNoBlockingRuntimeError();
    console.log(
      `MOBILE WEBKIT BARE FORBIDDEN CITY ENTRY = PASS | DEVICE=iPhone 13 | SHA=${sourceSha}`,
    );
    console.log(`MOBILE WEBKIT BARE EXPERIENCE URL = ${baseUrl}`);
  } catch (error) {
    await diagnostics.dump(error?.stack || error?.message || String(error));
    throw error;
  } finally {
    await context.close();
  }
}

const browser = await webkit.launch({ headless: true });
try {
  await verifyFounderEquivalentBareExperience(browser);
  console.log(
    `FORBIDDEN CITY MOBILE WEBKIT E2E = PASS | SHA=${sourceSha}`,
  );
} finally {
  await browser.close();
}
