import { pathToFileURL } from 'node:url';

const puppeteerModule = await import(
  pathToFileURL(process.env.PUPPETEER_CORE_PATH).href,
);
const puppeteer = puppeteerModule.default ?? puppeteerModule;

const url = process.argv[2];
const sourceSha = process.argv[3];
if (!url || !sourceSha) {
  throw new Error('usage: verify_mobile_interaction.mjs <url> <source-sha>');
}

const browser = await puppeteer.launch({
  executablePath: process.env.CHROME_PATH,
  headless: true,
  args: ['--no-sandbox', '--disable-dev-shm-usage'],
});

const page = await browser.newPage();
await page.setViewport({
  width: 390,
  height: 844,
  deviceScaleFactor: 3,
  isMobile: true,
  hasTouch: true,
});

const consoleErrors = [];
const pageErrors = [];
page.on('console', (message) => {
  const line = `[browser console:${message.type()}] ${message.text()}`;
  console.log(line);
  if (message.type() === 'error') consoleErrors.push(line);
});
page.on('pageerror', (error) => {
  const line = error?.stack ?? error?.message ?? String(error);
  pageErrors.push(line);
  console.error('[browser pageerror]', line);
});

await page.goto(url, {waitUntil: 'load', timeout: 60000});
await page.waitForFunction(
  () => performance.getEntriesByName('phoenix-main-interactive').length > 0,
  {timeout: 60000},
);

const handoff = await page.evaluate(() => {
  const width = window.innerWidth;
  const height = window.innerHeight;
  const cover = document.getElementById('phoenix-loading');
  const points = [
    {name: 'level-selector', x: width * .86, y: 26},
    {name: 'city-selection', x: width * .78, y: height * .57},
    {name: 'start-journey', x: width * .50, y: height * .69},
    {name: 'discovery', x: width * .50, y: height * .78},
    {name: 'bottom-navigation', x: width * .18, y: Math.max(1, height - 26)},
  ];
  const describe = (element) => element == null ? null : {
    tag: element.tagName,
    id: element.id || null,
    className: typeof element.className === 'string' ? element.className : null,
  };
  const hits = points.map((point) => {
    const target = document.elementFromPoint(point.x, point.y);
    return {
      ...point,
      target: describe(target),
      capturedByCover: Boolean(
        cover && target && (target === cover || cover.contains(target)),
      ),
    };
  });
  const style = cover ? getComputedStyle(cover) : null;
  const rect = cover?.getBoundingClientRect() ?? null;
  const marks = performance.getEntriesByType('mark').map((entry) => entry.name);
  return {
    sourceSha: window.location.search,
    viewport: {width, height, devicePixelRatio: window.devicePixelRatio},
    cover: cover ? {
      present: true,
      className: cover.className,
      pointerEvents: style.pointerEvents,
      zIndex: style.zIndex,
      opacity: style.opacity,
      visibility: style.visibility,
      display: style.display,
      inert: cover.hasAttribute('inert'),
      ariaHidden: cover.getAttribute('aria-hidden'),
      rect: rect ? {
        x: rect.x,
        y: rect.y,
        width: rect.width,
        height: rect.height,
      } : null,
    } : {present: false},
    hits,
    marks,
  };
});

console.log('MOBILE INTERACTION HANDOFF');
console.log(JSON.stringify(handoff, null, 2));

const captures = handoff.hits.filter((entry) => entry.capturedByCover);
if (captures.length > 0) {
  throw new Error(`startup cover captured mobile hit testing: ${JSON.stringify(captures)}`);
}
if (handoff.cover.present) {
  if (handoff.cover.pointerEvents !== 'none') {
    throw new Error(`cover pointer-events must be none, got ${handoff.cover.pointerEvents}`);
  }
  if (!handoff.cover.inert) {
    throw new Error('cover must be inert as soon as Home interaction is released');
  }
  if (handoff.cover.ariaHidden !== 'true') {
    throw new Error(`cover aria-hidden must be true, got ${handoff.cover.ariaHidden}`);
  }
}
if (!handoff.marks.includes('phoenix-cover-input-released')) {
  throw new Error('missing phoenix-cover-input-released mark');
}
if (
  !handoff.marks.includes('phoenix-cover-hit-test-safe') &&
  !handoff.marks.includes('phoenix-cover-hit-test-fallback-removed')
) {
  throw new Error('startup cover hit-test verification never completed');
}

await page.waitForFunction(
  () => document.getElementById('phoenix-loading') == null,
  {timeout: 5000},
);

const afterRemoval = await page.evaluate(() => ({
  coverPresent: document.getElementById('phoenix-loading') != null,
  marks: performance.getEntriesByType('mark').map((entry) => entry.name),
}));
console.log('MOBILE INTERACTION AFTER COVER REMOVAL');
console.log(JSON.stringify(afterRemoval, null, 2));

if (afterRemoval.coverPresent) {
  throw new Error('startup cover remained mounted after fade completion');
}
if (!afterRemoval.marks.includes('phoenix-cover-removed')) {
  throw new Error('missing phoenix-cover-removed mark');
}
if (pageErrors.length > 0) {
  throw new Error(`page errors during mobile interaction audit: ${pageErrors.join('\n')}`);
}
if (consoleErrors.length > 0) {
  throw new Error(`console errors during mobile interaction audit: ${consoleErrors.join('\n')}`);
}

console.log(`MOBILE INTERACTION SOURCE SHA = ${sourceSha}`);
console.log('MOBILE INTERACTION REGRESSION = PASS');
await browser.close();
