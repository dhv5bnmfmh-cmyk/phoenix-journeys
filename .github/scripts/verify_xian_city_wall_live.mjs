import { pathToFileURL } from 'node:url';
import {
  attachDiagnostics,
  challengeToMemory,
  completeChallenge,
  discoveryToChallenge,
  memoryToCompletion,
  openXianViaPassport,
  prepareLevel,
  requireAnyMarker,
  requireMarkers,
  startup,
  storyToVocabulary,
  verifyReadingAnnotation,
  vocabularyToDiscovery,
  assertDiscoveryCorpus,
} from './journey_e2e_core.mjs';
import { visibleText } from './flutter_semantics_live.mjs';

const { chromium, webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_xian_city_wall_live.mjs <preview-url> <sha>');

const levels = [1, 3, 5, 8, 10];
const discovery = {
  1: { depth: 2, anchors: ['13.74', '永宁门'] },
  3: { depth: 2, anchors: ['12至14米', '永宁门'] },
  5: { depth: 3, anchors: ['护城河', '洪武', '12至14米'] },
  8: { depth: 3, anchors: ['监测', '1983', '公共活动'] },
  10: { depth: 3, anchors: ['历史城区', '1961', '预备名录', '监测'] },
};

async function runLevel(browser, browserName, contextOptions, mode, level) {
  const context = await browser.newContext(contextOptions);
  const page = await context.newPage();
  const diagnostics = attachDiagnostics(page, `xian-${browserName}-lv${level}`);
  try {
    const separator = baseUrl.includes('?') ? '&' : '?';
    await startup(page, `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`, `Xi'an ${browserName}`);
    await openXianViaPassport(page, mode);
    await prepareLevel(page, level, mode);

    const story = await visibleText(page);
    requireMarkers(story, ['周遥', '永宁门'], `Xi'an ${browserName} Lv${level} Story identity`);
    requireAnyMarker(story, ['搬家', '新家', '迁居'], `Xi'an ${browserName} Lv${level} Story goal`);
    requireAnyMarker(story, ['跑表', '计时', '没有按停', '不按停'], `Xi'an ${browserName} Lv${level} Story choice`);
    diagnostics.assertNoBlockingError(`Xi'an ${browserName} Lv${level} Story`);

    await verifyReadingAnnotation(page, level, mode, {
      pinyin: ['Zhōu', 'Yáo'],
      vietnamese: ['Chu Dao'],
      english: ['Zhou Yao'],
    });

    await storyToVocabulary(page, level, story, mode);
    diagnostics.assertNoBlockingError(`Xi'an ${browserName} Lv${level} Vocabulary`);

    const discoveryText = await vocabularyToDiscovery(page, level, mode);
    assertDiscoveryCorpus(discoveryText, { level, expectedDepth: discovery[level].depth, anchors: discovery[level].anchors });
    diagnostics.assertNoBlockingError(`Xi'an ${browserName} Lv${level} Discovery`);

    await discoveryToChallenge(page, level, mode);
    await completeChallenge(page, level, mode);
    diagnostics.assertNoBlockingError(`Xi'an ${browserName} Lv${level} Challenge`);

    const memory = await challengeToMemory(page, level, mode);
    requireAnyMarker(memory, ['永宁门后没有按停的跑表', '永宁门', '跑表'], `Xi'an ${browserName} Lv${level} Memory`);

    const completion = await memoryToCompletion(page, level, mode);
    requireMarkers(completion, ['西安'], `Xi'an ${browserName} Lv${level} Completion city`);
    requireAnyMarker(completion, ['回家', '长安续程牌', '续程跑者'], `Xi'an ${browserName} Lv${level} Completion closure`);
    diagnostics.assertNoBlockingError(`Xi'an ${browserName} Lv${level} Completion`);
    diagnostics.assertNoBlockingRequests();
    console.log(`XI'AN ${browserName} Lv${level} SIX-STAGE = PASS`);
  } catch (error) {
    await diagnostics.dump(error?.stack || error?.message || String(error));
    throw error;
  } finally {
    await context.close();
  }
}

const chromiumBrowser = await chromium.launch({ headless: true });
try {
  for (const level of levels) {
    await runLevel(
      chromiumBrowser,
      'CHROMIUM-DESKTOP',
      { viewport: { width: 1440, height: 1000 }, locale: 'zh-CN', reducedMotion: 'reduce' },
      'click',
      level,
    );
  }
} finally {
  await chromiumBrowser.close();
}

const webkitBrowser = await webkit.launch({ headless: true });
try {
  for (const level of levels) {
    await runLevel(
      webkitBrowser,
      'WEBKIT-MOBILE',
      { ...devices['iPhone 13'], locale: 'zh-CN', reducedMotion: 'reduce' },
      'tap',
      level,
    );
  }
} finally {
  await webkitBrowser.close();
}

console.log(`XI'AN CITY WALL EXACT-RELEASE E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')} | BROWSERS=Chromium,WebKit`);
