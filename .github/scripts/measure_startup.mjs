import { pathToFileURL } from 'node:url';
import path from 'node:path';
import fs from 'node:fs';

const puppeteerModule = await import(
  pathToFileURL(process.env.PUPPETEER_CORE_PATH).href,
);
const puppeteer = puppeteerModule.default ?? puppeteerModule;

const url = process.argv[2];
const output = process.argv[3];
const sourceSha = process.argv[4];
const benchmarkIdentity = path.basename(output).replace(/-timings\.json$/, '');
const servedRoot = path.resolve(process.cwd(), 'build/web');
const servedMainJsPath = path.join(servedRoot, 'main.dart.js');
const servedMainJs = fs.existsSync(servedMainJsPath)
  ? fs.readFileSync(servedMainJsPath, 'utf8')
  : '';
const servedArtifactState = {
  benchmarkIdentity,
  sourceSha,
  cwd: process.cwd(),
  servedRoot,
  servedMainJsPath,
  servedMainJsExists: fs.existsSync(servedMainJsPath),
  servedMainJsBytes: servedMainJs ? Buffer.byteLength(servedMainJs) : null,
  servedJsContainsPhoenixPerf: servedMainJs.includes('__phoenix_perf'),
  servedJsContainsAppFirstMeaningful: servedMainJs.includes('app.firstMeaningful'),
  servedJsContainsFirstMeaningfulPerformanceMark: servedMainJs.includes('phoenix-first-meaningful-screen'),
};
console.log('STARTUP BENCHMARK SERVED ARTIFACT DIAGNOSTICS');
console.log(JSON.stringify(servedArtifactState, null, 2));

const browser = await puppeteer.launch({
  executablePath: process.env.CHROME_PATH,
  headless: true,
  args: ['--no-sandbox', '--disable-dev-shm-usage'],
});
const page = await browser.newPage();
const client = await page.createCDPSession();
await client.send('Network.enable');
await client.send('Network.setCacheDisabled', {cacheDisabled: false});

const browserConsole = [];
const pageErrors = [];
const failedRequests = [];
const httpErrors = [];

page.on('console', (message) => {
  const entry = {
    type: message.type(),
    text: message.text(),
    location: message.location(),
  };
  browserConsole.push(entry);
  console.log(`[browser console:${entry.type}] ${entry.text}`);
});
page.on('pageerror', (error) => {
  const entry = {
    name: error?.name ?? 'Error',
    message: error?.message ?? String(error),
    stack: error?.stack ?? null,
  };
  pageErrors.push(entry);
  console.error('[browser pageerror]', entry.stack ?? entry.message);
});
page.on('requestfailed', (request) => {
  const entry = {
    url: request.url(),
    method: request.method(),
    resourceType: request.resourceType(),
    errorText: request.failure()?.errorText ?? null,
  };
  failedRequests.push(entry);
  console.error('[browser requestfailed]', JSON.stringify(entry));
});
page.on('response', (response) => {
  if (response.status() < 400) return;
  const request = response.request();
  const entry = {
    url: response.url(),
    status: response.status(),
    statusText: response.statusText(),
    method: request.method(),
    resourceType: request.resourceType(),
  };
  httpErrors.push(entry);
  console.error('[browser http-error]', JSON.stringify(entry));
});

async function runtimeDiagnosticState(sampleLabel, phase) {
  let runtime = null;
  try {
    runtime = await page.evaluate(() => {
      const controller = navigator.serviceWorker?.controller ?? null;
      const marks = performance.getEntriesByType('mark').map((entry) => ({
        name: entry.name,
        startTime: entry.startTime,
        duration: entry.duration,
      }));
      let phoenixPerf = null;
      try {
        phoenixPerf = window.__phoenix_perf ?? null;
      } catch (error) {
        phoenixPerf = {diagnosticReadError: String(error)};
      }
      return {
        finalBrowserUrl: window.location.href,
        documentReadyState: document.readyState,
        phoenixPerf,
        appFirstMeaningfulGlobal:
          window.__phoenix_perf?.['app.firstMeaningful'] ?? null,
        firstMeaningfulPerformanceMark:
          performance.getEntriesByName('phoenix-first-meaningful-screen').map((entry) => ({
            name: entry.name,
            startTime: entry.startTime,
            duration: entry.duration,
          })),
        marks,
        serviceWorker: {
          supported: 'serviceWorker' in navigator,
          controller: controller
            ? {
                scriptURL: controller.scriptURL,
                state: controller.state,
              }
            : null,
        },
      };
    });
  } catch (error) {
    runtime = {
      diagnosticEvaluationError: error?.stack ?? error?.message ?? String(error),
      finalBrowserUrl: page.url(),
    };
  }
  return {
    benchmarkIdentity,
    sourceSha,
    sampleLabel,
    phase,
    requestedUrl: url,
    finalBrowserUrl: page.url(),
    servedArtifact: servedArtifactState,
    runtime,
    browserConsole,
    browserConsoleErrors: browserConsole.filter((entry) => entry.type === 'error'),
    pageErrors,
    failedRequests,
    httpErrors,
  };
}

async function dumpRuntimeDiagnostics(sampleLabel, phase) {
  const state = await runtimeDiagnosticState(sampleLabel, phase);
  console.error(`STARTUP BENCHMARK RUNTIME DIAGNOSTICS [${sampleLabel}] [${phase}]`);
  console.error(JSON.stringify(state, null, 2));
}

async function waitForFunctionWithDiagnostics(sampleLabel, phase, predicate) {
  try {
    await page.waitForFunction(predicate, {timeout: 60000});
  } catch (error) {
    await dumpRuntimeDiagnostics(sampleLabel, phase);
    throw error;
  }
}

await page.evaluateOnNewDocument(() => {
  const mark = (name) => {
    try {
      if (!performance.getEntriesByName(name).length) performance.mark(name);
    } catch (_) {}
  };
  const originalConsoleInfo = console.info.bind(console);
  console.info = (...args) => {
    const message = String(args[0] ?? '');
    const match = message.match(/^PHOENIX BRANDING DEADLINE = ([0-9.]+)ms$/);
    if (match && !performance.getEntriesByName('benchmark-branding-deadline').length) {
      performance.mark('benchmark-branding-deadline', {
        startTime: Number(match[1]),
      });
    }
    originalConsoleInfo(...args);
  };
  let coverSeen = false;
  let travelerBound = false;
  const inspect = () => {
    const cover = document.getElementById('phoenix-loading');
    if (cover && !coverSeen) {
      coverSeen = true;
      mark('benchmark-cover-created');
    }
    const traveler = cover?.querySelector('.phoenix-time-traveler');
    if (traveler && !travelerBound) {
      travelerBound = true;
      traveler.addEventListener('animationstart', (event) => {
        if (event.animationName === 'phoenix-time-flight-v2') mark('benchmark-flight-start');
      }, {passive: true});
      traveler.addEventListener('animationend', (event) => {
        if (event.animationName === 'phoenix-time-flight-v2') mark('benchmark-flight-end');
      }, {passive: true});
    }
    if (cover?.classList.contains('phoenix-loading--hidden')) {
      mark('benchmark-cover-fade-start');
    }
    if (coverSeen && !cover) mark('benchmark-cover-removed');
  };
  const observer = new MutationObserver(inspect);
  document.addEventListener('DOMContentLoaded', () => {
    observer.observe(document.documentElement, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['class'],
    });
    inspect();
  }, {once: true});
});

async function clearHttpAndWorkerCache() {
  await client.send('Network.clearBrowserCache');
  await client.send('Storage.clearDataForOrigin', {
    origin: new URL(url).origin,
    storageTypes: 'cache_storage,service_workers',
  });
}

async function clearLocalState() {
  await client.send('Storage.clearDataForOrigin', {
    origin: new URL(url).origin,
    storageTypes: 'local_storage,indexeddb',
  });
}

async function sample(label, {cold, freshState}) {
  if (cold) await clearHttpAndWorkerCache();
  if (freshState) await clearLocalState();
  try {
    await page.goto(url, {waitUntil: 'load', timeout: 60000});
  } catch (error) {
    await dumpRuntimeDiagnostics(label, 'navigation');
    throw error;
  }
  console.log(`STARTUP SAMPLE [${label}] REQUESTED URL = ${url}`);
  console.log(`STARTUP SAMPLE [${label}] FINAL URL = ${page.url()}`);
  await waitForFunctionWithDiagnostics(
    label,
    'phoenix-first-meaningful-screen',
    () => performance.getEntriesByName('phoenix-first-meaningful-screen').length > 0,
  );
  await waitForFunctionWithDiagnostics(
    label,
    'benchmark-cover-fade-start',
    () => performance.getEntriesByName('benchmark-cover-fade-start').length > 0,
  );
  await waitForFunctionWithDiagnostics(
    label,
    'benchmark-cover-removed',
    () => performance.getEntriesByName('benchmark-cover-removed').length > 0,
  );

  await page.evaluate(() => {
    window.dispatchEvent(new Event('phoenix-benchmark-open-current-journey'));
  });
  await waitForFunctionWithDiagnostics(
    label,
    'phoenix-journey-story-usable',
    () => performance.getEntriesByName('phoenix-journey-story-usable').length > 0,
  );

  const result = await page.evaluate(() => {
    const marks = Object.fromEntries(
      performance.getEntriesByType('mark').map((entry) => [entry.name, entry.startTime]),
    );
    const nav = performance.getEntriesByType('navigation')[0];
    const paints = Object.fromEntries(
      performance.getEntriesByType('paint').map((entry) => [entry.name, entry.startTime]),
    );
    const diff = (a, b) => marks[a] != null && marks[b] != null ? marks[b] - marks[a] : null;
    const coverCreated = marks['benchmark-cover-created'] ?? 0;
    const coverFadeStart = marks['benchmark-cover-fade-start'];
    const coverRemoved = marks['benchmark-cover-removed'];
    const brandingDeadline = marks['benchmark-branding-deadline'] ?? coverCreated + 6800;
    const flightStart = marks['benchmark-flight-start'];
    const flightEnd = marks['benchmark-flight-end'];
    const appReady = marks['phoenix-first-meaningful-screen'];
    return {
      totalToMeaningfulMs: appReady,
      mainEntryToMeaningfulMs: diff('phoenix-main-entry', 'phoenix-first-meaningful-screen'),
      preRunAppMs: diff('phoenix-main-entry', 'phoenix-runapp-start'),
      languageInitMs: diff('phoenix-language-init-start', 'phoenix-language-init-end'),
      firstFrameMs: diff('phoenix-runapp-start', 'phoenix-first-frame'),
      runAppToStateLoadMs: diff('phoenix-runapp-start', 'phoenix-state-load-start'),
      appStateDailyJourneyInitMs: diff('phoenix-appstate-daily-journey-start', 'phoenix-appstate-daily-journey-end'),
      dailyCatalogFirstTouchMs: diff('phoenix-daily-catalog-first-touch-start', 'phoenix-daily-catalog-length-ready'),
      dailyCatalogIndexLookupMs: diff('phoenix-daily-catalog-index-start', 'phoenix-daily-catalog-index-ready'),
      appStateRestoreMs: diff('phoenix-state-load-start', 'phoenix-state-ready'),
      sharedPreferencesMs: diff('phoenix-preferences-start', 'phoenix-preferences-ready'),
      criticalReadMs: diff('phoenix-critical-read-start', 'phoenix-critical-read-end'),
      legacyPathMs: diff('phoenix-legacy-path-start', 'phoenix-legacy-path-end'),
      legacyBuildMs: diff('phoenix-legacy-build-start', 'phoenix-legacy-build-end'),
      legacyValidateMs: diff('phoenix-legacy-validate-start', 'phoenix-legacy-validate-end'),
      commitInitialMs: diff('phoenix-commit-initial-start', 'phoenix-commit-initial-end'),
      snapshotDecodeValidateMs: diff('phoenix-snapshot-decode-validate-start', 'phoenix-snapshot-decode-validate-end'),
      locationBindingsMs: diff('phoenix-location-bindings-start', 'phoenix-location-bindings-end'),
      applyCommittedMs: diff('phoenix-apply-committed-start', 'phoenix-apply-committed-end'),
      restoreEligibilityMs: diff('phoenix-restore-eligibility-start', 'phoenix-restore-eligibility-end'),
      coverVisibleMs: coverRemoved != null ? coverRemoved - coverCreated : null,
      coverFadeStartMs: coverFadeStart != null ? coverFadeStart - coverCreated : null,
      coverRemovalAfterFadeStartMs: coverFadeStart != null && coverRemoved != null ? coverRemoved - coverFadeStart : null,
      brandingDeadlineToFadeStartMs: coverFadeStart != null ? Math.max(0, coverFadeStart - brandingDeadline) : null,
      homeReadyBeforeBrandingDeadlineMs: appReady != null ? brandingDeadline - appReady : null,
      phoenixFlightMs: flightStart != null && flightEnd != null ? flightEnd - flightStart : null,
      postFlightCoverStallMs: flightEnd != null && coverRemoved != null ? Math.max(0, coverRemoved - flightEnd) : null,
      appReadyBeforeFlightEndMs: appReady != null && flightEnd != null ? flightEnd - appReady : null,
      intentionalMinimumWaitMs: diff('phoenix-minimum-duration-wait-start', 'phoenix-minimum-duration-wait-end'),
      runtimeWaitAfterFlightMs: flightEnd != null && appReady != null ? Math.max(0, appReady - flightEnd) : null,
      journeyOpenContentReadyMs: diff('phoenix-journey-open-start', 'phoenix-journey-content-ready'),
      journeyOpenStoryUsableMs: diff('phoenix-journey-open-start', 'phoenix-journey-story-usable'),
      firstContentfulPaintMs: paints['first-contentful-paint'] ?? null,
      domContentLoadedMs: nav?.domContentLoadedEventEnd ?? null,
      loadEventMs: nav?.loadEventEnd ?? null,
      responseEndMs: nav?.responseEnd ?? null,
      marks,
    };
  });
  return {label, ...result};
}

async function runScenario(label, options, count = 5) {
  const samples = [];
  for (let i = 0; i < count; i += 1) samples.push(await sample(label, options));
  return samples;
}

await clearHttpAndWorkerCache();
await clearLocalState();
await sample('prewarm', {cold: false, freshState: true});
const all = {
  cold_new: await runScenario('cold_new', {cold: true, freshState: true}),
  warm_new: await runScenario('warm_new', {cold: false, freshState: true}),
};
all.cold_existing = await runScenario('cold_existing', {cold: true, freshState: false});
all.warm_existing = await runScenario('warm_existing', {cold: false, freshState: false});

function summary(values) {
  const clean = values.filter((value) => Number.isFinite(value)).sort((a, b) => a - b);
  if (!clean.length) return {min: null, median: null, max: null};
  const mid = Math.floor(clean.length / 2);
  const median = clean.length % 2 ? clean[mid] : (clean[mid - 1] + clean[mid]) / 2;
  return {min: clean[0], median, max: clean[clean.length - 1]};
}

const fields = [
  'totalToMeaningfulMs', 'mainEntryToMeaningfulMs', 'preRunAppMs', 'languageInitMs',
  'firstFrameMs', 'runAppToStateLoadMs', 'appStateDailyJourneyInitMs',
  'dailyCatalogFirstTouchMs', 'dailyCatalogIndexLookupMs', 'appStateRestoreMs',
  'sharedPreferencesMs', 'criticalReadMs', 'legacyPathMs', 'legacyBuildMs',
  'legacyValidateMs', 'commitInitialMs', 'snapshotDecodeValidateMs', 'locationBindingsMs',
  'applyCommittedMs', 'restoreEligibilityMs', 'coverVisibleMs', 'phoenixFlightMs',
  'coverFadeStartMs', 'coverRemovalAfterFadeStartMs', 'brandingDeadlineToFadeStartMs',
  'homeReadyBeforeBrandingDeadlineMs',
  'postFlightCoverStallMs', 'appReadyBeforeFlightEndMs', 'intentionalMinimumWaitMs',
  'runtimeWaitAfterFlightMs', 'journeyOpenContentReadyMs', 'journeyOpenStoryUsableMs',
  'firstContentfulPaintMs', 'domContentLoadedMs', 'loadEventMs', 'responseEndMs',
];
const stats = {};
const medians = {};
for (const [scenario, samples] of Object.entries(all)) {
  stats[scenario] = Object.fromEntries(fields.map((field) => [field, summary(samples.map((sample) => sample[field]))]));
  medians[scenario] = Object.fromEntries(fields.map((field) => [field, stats[scenario][field].median]));
}
fs.writeFileSync(output, JSON.stringify({sourceSha, sampleCount: 5, stats, medians, samples: all}, null, 2));
console.log(`SOURCE SHA = ${sourceSha}`);
console.log(JSON.stringify(stats, null, 2));
await browser.close();
