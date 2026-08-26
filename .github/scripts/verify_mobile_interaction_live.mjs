import { pathToFileURL } from 'node:url';
import {
  attachDiagnostics,
  startup,
  waitForVisible,
} from './journey_e2e_core.mjs';
import {
  activateSemantic,
  currentLevel,
  currentStage,
  setLevel,
  sleep,
  visibleText,
} from './flutter_semantics_live.mjs';

const { chromium, webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) throw new Error('usage: verify_mobile_interaction_live.mjs <url> <source-sha>');

async function runBrowser(browserType, browserName) {
  const browser = await browserType.launch({ headless: true });
  const context = await browser.newContext({ ...devices['iPhone 13'], locale: 'zh-CN', reducedMotion: 'reduce' });
  const page = await context.newPage();
  const diagnostics = attachDiagnostics(page, `generic-mobile-${browserName}`);
  try {
    const separator = baseUrl.includes('?') ? '&' : '?';
    await startup(page, `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`, `${browserName} mobile audit`);
    await waitForVisible(page, 'PHOENIX JOURNEYS');

    await activateSemantic(page, { role: 'button', exact: '护照' }, { mode: 'tap' });
    await waitForVisible(page, '探索护照');
    await activateSemantic(page, { role: 'button', exact: '中国' }, { mode: 'tap' });
    await waitForVisible(page, '请从左侧选择省份');
    await activateSemantic(page, { role: 'button', includes: '浙江省' }, { mode: 'tap' });
    await waitForVisible(page, '请从左侧选择城市');
    await activateSemantic(page, { role: 'button', includes: '杭州' }, { mode: 'tap' });
    await waitForVisible(page, '浙江省，杭州市');
    await activateSemantic(page, { role: 'button', prefix: '返回上一级' }, { mode: 'tap' });
    await waitForVisible(page, '请从左侧选择城市');
    console.log(`${browserName} GENERIC PASSPORT INTERACTION = PASS`);

    await activateSemantic(page, { role: 'button', prefix: '我的' }, { mode: 'tap' });
    await waitForVisible(page, 'HSK／TOCFL 能力设置');
    await activateSemantic(page, { role: 'button', prefix: '跟读训练' }, { mode: 'tap' });
    await waitForVisible(page, '跟读训练');
    await activateSemantic(page, { role: 'button', prefix: '探索' }, { mode: 'tap' });
    await waitForVisible(page, 'PHOENIX JOURNEYS');
    console.log(`${browserName} GENERIC TAB INTERACTION = PASS`);

    const before = await currentLevel(page);
    const target = before < 10 ? before + 1 : before - 1;
    await setLevel(page, target, { mode: 'tap' });
    if ((await currentLevel(page)) !== target) throw new Error(`${browserName} level control did not settle`);
    console.log(`${browserName} GENERIC LEVEL CONTROL = PASS | Lv${before}->Lv${target}`);

    await activateSemantic(page, { role: 'button', prefix: '选择城市' }, { mode: 'tap' });
    await waitForVisible(page, '选择城市与地点');
    await activateSemantic(page, { role: 'button', exact: 'Dismiss' }, { mode: 'tap' });
    const deadline = Date.now() + 5000;
    while (Date.now() <= deadline && (await visibleText(page)).includes('选择城市与地点')) await sleep(100);
    if ((await visibleText(page)).includes('选择城市与地点')) throw new Error(`${browserName} city selector did not close`);
    console.log(`${browserName} GENERIC CITY SELECTOR = PASS`);

    for (const action of ['开始', '继续', '再次探索']) {
      try {
        await activateSemantic(page, { role: 'button', prefix: action }, { mode: 'tap', timeout: 1200, retries: 1 });
        break;
      } catch (_) {}
    }
    const stage = await currentStage(page);
    if (stage < 1 || stage > 6) throw new Error(`${browserName} Journey stage invalid: ${stage}`);
    diagnostics.assertNoBlockingError(`${browserName} Journey open`);
    diagnostics.assertNoBlockingRequests();
    console.log(`${browserName} GENERIC DAILY JOURNEY OPEN = PASS | STAGE=${stage}/6`);
    console.log(`${browserName} MOBILE INTERACTION LIVE-ELEMENT AUDIT = PASS | SHA=${sourceSha}`);
  } catch (error) {
    await diagnostics.dump(error?.stack || error?.message || String(error));
    throw error;
  } finally {
    await context.close();
    await browser.close();
  }
}

await runBrowser(chromium, 'CHROMIUM');
await runBrowser(webkit, 'WEBKIT');
console.log(`MOBILE INTERACTION AUDIT = PASS | SHA=${sourceSha}`);
