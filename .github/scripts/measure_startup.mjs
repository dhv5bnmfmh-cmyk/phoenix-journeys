import { pathToFileURL } from 'node:url';
import fs from 'node:fs';

const puppeteerModule = await import(
  pathToFileURL(process.env.PUPPETEER_CORE_PATH).href,
);
const puppeteer = puppeteerModule.default ?? puppeteerModule;

const url = process.argv[2];
const output = process.argv[3];
const sourceSha = process.argv[4];
const browser = await puppeteer.launch({
  executablePath: process.env.CHROME_PATH,
  headless: true,
  args: ['--no-sandbox', '--disable-dev-shm-usage'],
});
const page = await browser.newPage();
const client = await page.createCDPSession();
await client.send('Network.enable');
await client.send('Network.setCacheDisabled', {cacheDisabled: false});

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
  await page.goto(url, {waitUntil: 'load', timeout: 60000});
  await page.waitForFunction(
    () => performance.getEntriesByName('phoenix-first-meaningful-screen').length > 0,
    {timeout: 60000},
  );
  const result = await page.evaluate(() => {
    const marks = Object.fromEntries(
      performance.getEntriesByType('mark').map((entry) => [entry.name, entry.startTime]),
    );
    const nav = performance.getEntriesByType('navigation')[0];
    const paints = Object.fromEntries(
      performance.getEntriesByType('paint').map((entry) => [entry.name, entry.startTime]),
    );
    const resources = performance.getEntriesByType('resource');
    const wanted = ['flutter_bootstrap.js', 'main.dart.js', 'canvaskit.js', 'canvaskit.wasm'];
    const startupResources = {};
    for (const wantedName of wanted) {
      const entry = resources.find((item) => item.name.includes(wantedName));
      if (entry) {
        startupResources[wantedName] = {
          durationMs: entry.duration,
          transferSize: entry.transferSize,
          encodedBodySize: entry.encodedBodySize,
        };
      }
    }
    const diff = (a, b) => marks[a] != null && marks[b] != null ? marks[b] - marks[a] : null;
    return {
      totalToMeaningfulMs: marks['phoenix-first-meaningful-screen'],
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
      firstContentfulPaintMs: paints['first-contentful-paint'] ?? null,
      domContentLoadedMs: nav?.domContentLoadedEventEnd ?? null,
      loadEventMs: nav?.loadEventEnd ?? null,
      responseEndMs: nav?.responseEnd ?? null,
      transferSize: nav?.transferSize ?? null,
      startupResources,
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
  'applyCommittedMs', 'restoreEligibilityMs', 'firstContentfulPaintMs', 'domContentLoadedMs',
  'loadEventMs', 'responseEndMs',
];
const stats = {};
const medians = {};
for (const [scenario, samples] of Object.entries(all)) {
  stats[scenario] = Object.fromEntries(
    fields.map((field) => [field, summary(samples.map((sample) => sample[field]))]),
  );
  medians[scenario] = Object.fromEntries(
    fields.map((field) => [field, stats[scenario][field].median]),
  );
}
fs.writeFileSync(
  output,
  JSON.stringify({sourceSha, sampleCount: 5, stats, medians, samples: all}, null, 2),
);
console.log(`SOURCE SHA = ${sourceSha}`);
console.log(JSON.stringify(stats, null, 2));
await browser.close();