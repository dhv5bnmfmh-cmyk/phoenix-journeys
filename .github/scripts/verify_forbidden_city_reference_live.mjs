import { pathToFileURL } from 'node:url';
import {
  attachDiagnostics,
  challengeToMemory,
  completeChallenge,
  discoveryToChallenge,
  memoryToCompletion,
  openForbiddenCity,
  prepareLevel,
  requireAnyMarker,
  requireMarkers,
  startup,
  storyToVocabulary,
  vocabularyToDiscovery,
} from './journey_e2e_core.mjs';
import { visibleText } from './flutter_semantics_live.mjs';

const { chromium } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_reference_live.mjs <preview-url> <sha>');

const levels = [1, 3, 5, 8, 10];
const storyMarkers = {
  1: ['沈砚', '阿宁', '午门'],
  3: ['沈砚', '阿宁', '判断'],
  5: ['沈砚', '阿宁', '证据'],
  8: ['沈砚', '阿宁', '路线'],
  10: ['沈砚', '阿宁', '行动后果'],
};

async function runLevel(browser, level) {
  const context = await browser.newContext({ viewport: { width: 1440, height: 1000 }, locale: 'zh-CN', reducedMotion: 'reduce' });
  const page = await context.newPage();
  const diagnostics = attachDiagnostics(page, `forbidden-city-lv${level}`);
  try {
    const separator = baseUrl.includes('?') ? '&' : '?';
    await startup(page, `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`, 'Forbidden City Reference');
    await openForbiddenCity(page, 'click');
    await prepareLevel(page, level, 'click');

    const story = await visibleText(page);
    requireMarkers(story, storyMarkers[level], `Forbidden City Lv${level} Story`);
    requireAnyMarker(story, ['中轴', '午门', '宫门', '院落'], `Forbidden City Lv${level} place causality`);
    diagnostics.assertNoBlockingError(`Lv${level} Story`);

    await storyToVocabulary(page, level, story, 'click');
    diagnostics.assertNoBlockingError(`Lv${level} Vocabulary`);

    const discovery = await vocabularyToDiscovery(page, level, 'click');
    requireAnyMarker(discovery, ['中轴', '宫门', '院落', '景运门', '乾清门', '外朝', '内廷', '建筑', '路线'], `Forbidden City Lv${level} Discovery`);
    diagnostics.assertNoBlockingError(`Lv${level} Discovery`);

    await discoveryToChallenge(page, level, 'click');
    await completeChallenge(page, level, 'click');
    diagnostics.assertNoBlockingError(`Lv${level} Challenge`);

    const memory = await challengeToMemory(page, level, 'click');
    requireAnyMarker(memory, ['两条都能走通的路线', '路线'], `Forbidden City Lv${level} Memory`);

    const completion = await memoryToCompletion(page, level, 'click');
    requireMarkers(completion, ['北京'], `Forbidden City Lv${level} Completion`);
    requireAnyMarker(completion, ['路线', '两条'], `Forbidden City Lv${level} Completion route closure`);
    diagnostics.assertNoBlockingError(`Lv${level} Completion`);
    diagnostics.assertNoBlockingRequests();
    console.log(`FORBIDDEN CITY REFERENCE Lv${level} SIX-STAGE = PASS`);
  } catch (error) {
    await diagnostics.dump(error?.stack || error?.message || String(error));
    throw error;
  } finally {
    await context.close();
  }
}

const browser = await chromium.launch({ headless: true });
try {
  for (const level of levels) await runLevel(browser, level);
  console.log(`FORBIDDEN CITY REFERENCE LIVE-ELEMENT E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')}`);
} finally {
  await browser.close();
}
