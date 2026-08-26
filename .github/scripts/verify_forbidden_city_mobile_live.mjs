import { pathToFileURL } from 'node:url';
import {
  attachDiagnostics,
  openForbiddenCity,
  prepareLevel,
  startup,
  storyToVocabulary,
  vocabularyToDiscovery,
} from './journey_e2e_core.mjs';
import { assertTargetLevel, setLevel, visibleText, waitStableStage } from './flutter_semantics_live.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_mobile_live.mjs <preview-url> <sha>');

const browser = await webkit.launch({ headless: true });
const context = await browser.newContext({ ...devices['iPhone 13'], locale: 'zh-CN', reducedMotion: 'reduce' });
const page = await context.newPage();
const diagnostics = attachDiagnostics(page, 'forbidden-city-mobile-webkit');
try {
  const separator = baseUrl.includes('?') ? '&' : '?';
  await startup(page, `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`, 'Forbidden City WebKit');
  await openForbiddenCity(page, 'tap');
  await prepareLevel(page, 1, 'tap');
  const story = await visibleText(page);
  await storyToVocabulary(page, 1, story, 'tap');
  await vocabularyToDiscovery(page, 1, 'tap');

  for (let level = 1; level <= 10; level += 1) {
    await setLevel(page, level, { mode: 'tap' });
    await waitStableStage(page, 3, level, { mode: 'tap' });
    await assertTargetLevel(page, level, `Forbidden City WebKit Lv${level} Discovery`);
    const text = await visibleText(page);
    const expected = level <= 4 ? 2 : 3;
    if (!text.includes(`${expected} 段`)) {
      throw new Error(`Forbidden City WebKit Lv${level} Discovery missing canonical ${expected}-segment depth`);
    }
    diagnostics.assertNoBlockingError(`Forbidden City WebKit Lv${level}`);
    console.log(`FORBIDDEN CITY MOBILE WEBKIT DISCOVERY Lv${level} = PASS | DEPTH=${expected}`);
  }
  diagnostics.assertNoBlockingRequests();
  console.log(`FORBIDDEN CITY MOBILE WEBKIT LIVE-ELEMENT = PASS | SHA=${sourceSha}`);
} catch (error) {
  await diagnostics.dump(error?.stack || error?.message || String(error));
  throw error;
} finally {
  await context.close();
  await browser.close();
}
