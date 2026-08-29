import { pathToFileURL } from 'node:url';
import {
  assertNoJourneyLiveControls,
  journeySessionLevel,
  returnToExplore,
  setConfiguredLevel,
} from './journey_level_session_harness.mjs';

const { chromium } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) {
  throw new Error(
    'usage: verify_forbidden_city_story_reading_support.mjs <preview-url> <sha>',
  );
}

const levels = [1, 3, 5, 8, 10];
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

const expected = {
  1: {
    story: ['十七岁', '午门', '乾清门', '送到东边'],
    pinyin: ['shí qī suì', 'wǔ mén'],
    vietnamese: ['17 tuổi', 'mục tiêu'],
    english: ['Seventeen-year-old', 'goal'],
  },
  3: {
    story: ['宫门和院落', '东侧空间', '汇合'],
    pinyin: ['yuàn luò', 'huì hé'],
    vietnamese: ['hội tụ', 'đáp án duy nhất'],
    english: ['converges', 'only answer'],
  },
  5: {
    story: ['空间关系', '粗线', '判断'],
    pinyin: ['pàn duàn', 'kōng jiān'],
    vietnamese: ['đường đậm', 'phán đoán'],
    english: ['thick line', 'judgment'],
  },
  8: {
    story: ['任务效率', '三个问题', '空间证据'],
    pinyin: ['zhèng jù', 'rèn wù'],
    vietnamese: ['hiệu quả nhiệm vụ', 'ba câu hỏi'],
    english: ['task efficiency', 'three questions'],
  },
  10: {
    story: ['默认答案', '权衡', '行动后果'],
    pinyin: ['quán héng', 'hòu guǒ'],
    vietnamese: ['cân nhắc', 'hệ quả hành động'],
    english: ['weigh', 'action consequences'],
  },
};

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((elements) =>
    elements.map((element) => {
      const rect = element.getBoundingClientRect();
      const style = getComputedStyle(element);
      return {
        role: element.getAttribute('role') || '',
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

async function visibleText(page) {
  return (await records(page))
    .filter((record) => record.visible)
    .map(recordText)
    .filter(Boolean)
    .join('\n');
}

async function enableSemantics(page) {
  const deadline = Date.now() + 60000;
  while (Date.now() < deadline) {
    const placeholder = page.locator('flt-semantics-placeholder').first();
    if (await placeholder.count()) {
      await placeholder.evaluate((element) => element.click());
    }
    if (await page.locator('flt-semantics').count()) return;
    await sleep(100);
  }
  throw new Error('Flutter semantics did not become available after startup readiness');
}

async function requireStartup(page) {
  const response = await page.goto(baseUrl, {
    waitUntil: 'load',
    timeout: 140000,
  });
  if (!response?.ok()) {
    throw new Error(`Story Reading Support HTTP load failed: ${response?.status()}`);
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
  await enableSemantics(page);
}

async function waitForText(page, needle, timeout = 20000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if ((await visibleText(page)).includes(needle)) return;
    await sleep(100);
  }
  throw new Error(`semantic text not found: ${needle}`);
}

async function semanticButton(page, name, { exact = true, timeout = 20000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const locator = page.getByRole('button', { name, exact });
    const count = await locator.count();
    if (count === 1) {
      const disabled = await locator.getAttribute('aria-disabled').catch(() => null);
      if (disabled === 'true') throw new Error(`button disabled: ${name}`);
      return locator;
    }
    if (count > 1) {
      throw new Error(`semantic button ambiguous: ${name} count=${count}`);
    }
    await sleep(100);
  }
  throw new Error(`semantic button not found: ${name}`);
}

async function activateButton(page, name, options = {}) {
  const button = await semanticButton(page, name, options);
  await button.evaluate((element) => element.click());
}

async function currentSessionLevel(page) {
  return journeySessionLevel(page);
}

async function openForbiddenCity(page) {
  if ((await visibleText(page)).includes('北京 · 紫禁城')) {
    await waitForText(page, '1/6');
    return;
  }
  await waitForText(page, 'PHOENIX JOURNEYS', 30000);
  await activateButton(page, '选择城市', { exact: false });
  await waitForText(page, '选择城市与地点');
  await activateButton(page, '北京', { exact: false });
  await waitForText(page, '北京的地点');
  await activateButton(page, '紫禁城', { exact: false });

  const deadline = Date.now() + 30000;
  while (Date.now() < deadline) {
    const text = await visibleText(page);
    if (text.includes('北京 · 紫禁城') && text.includes('1/6')) return;
    if (text.includes('PHOENIX JOURNEYS')) {
      for (const action of ['开始', '继续', '再次探索']) {
        const locator = page.getByRole('button', { name: action, exact: false });
        if ((await locator.count()) === 1) {
          await locator.evaluate((element) => element.click());
          break;
        }
      }
    }
    await sleep(100);
  }
  throw new Error('Forbidden City Story did not open');
}

function requireMarkers(text, markers, label) {
  for (const marker of markers) {
    if (!text.includes(marker)) {
      throw new Error(`${label} missing marker: ${marker}`);
    }
  }
}

function includesStoryMarkerAcrossInlineSemantics(text, marker) {
  if (text.includes(marker)) return true;
  const characters = [...marker];
  if (!characters.length) return true;
  const maxTotalSpan = Math.max(80, Math.min(240, characters.length * 60));
  let start = text.indexOf(characters[0]);
  while (start !== -1) {
    let cursor = start;
    let matched = true;
    for (let index = 1; index < characters.length; index += 1) {
      const next = text.indexOf(characters[index], cursor + 1);
      if (next === -1 || next - start > maxTotalSpan) {
        matched = false;
        break;
      }
      cursor = next;
    }
    if (matched) return true;
    start = text.indexOf(characters[0], start + 1);
  }
  return false;
}

function requireStoryMarkers(text, markers, label) {
  for (const marker of markers) {
    if (!includesStoryMarkerAcrossInlineSemantics(text, marker)) {
      throw new Error(`${label} missing semantic marker: ${marker}`);
    }
  }
}

async function openFirstStoryAnnotation(page) {
  const notes = page.getByRole('button', { name: '注', exact: true });
  const count = await notes.count();
  if (count < 1) throw new Error('Story Reading Support 注 button not found');
  await notes.first().evaluate((element) => element.click());
  await waitForText(page, '故事第 1 段');
  await waitForText(page, '拼音');
  await waitForText(page, '探索者母语 · 越南语');
  await waitForText(page, 'English');
}

async function closeReadingSupport(page) {
  await page.keyboard.press('Escape');
  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    if (!(await visibleText(page)).includes('故事第 1 段')) return;
    await sleep(100);
  }
  throw new Error('Story Reading Support popup did not close');
}

const pageErrors = [];
const failedRequests = [];
const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({
  viewport: { width: 1280, height: 900 },
});
const page = await context.newPage();
page.on('pageerror', (error) => pageErrors.push(String(error?.message || error)));
page.on('requestfailed', (request) => {
  const failure = request.failure();
  failedRequests.push(`${request.url()} :: ${failure?.errorText || 'request failed'}`);
});

try {
  for (const level of levels) {
    await requireStartup(page);
    await setConfiguredLevel(page, level);
    await returnToExplore(page);
    await openForbiddenCity(page);
    await waitForText(page, '1/6');
    if ((await currentSessionLevel(page)) !== level) {
      throw new Error(`Lv${level} Story level drift before Reading Support`);
    }
    await assertNoJourneyLiveControls(page);

    const storyText = await visibleText(page);
    requireStoryMarkers(storyText, expected[level].story, `Lv${level} CURRENT Story`);

    await openFirstStoryAnnotation(page);
    const supportText = await visibleText(page);
    requireMarkers(supportText, expected[level].pinyin, `Lv${level} Pinyin`);
    requireMarkers(
      supportText,
      expected[level].vietnamese,
      `Lv${level} Vietnamese`,
    );
    requireMarkers(supportText, expected[level].english, `Lv${level} English`);

    if (pageErrors.length) {
      throw new Error(`Lv${level} page errors: ${pageErrors.join(' || ')}`);
    }
    console.log(
      `STORY READING ANNOTATION Lv${level} = PASS | CURRENT STORY + PINYIN + VI + EN`,
    );
    await closeReadingSupport(page);
  }

  const blockingRequests = failedRequests.filter(
    (entry) => !entry.includes('favicon') && !entry.includes('analytics'),
  );
  if (blockingRequests.length) {
    throw new Error(`blocking failed requests: ${blockingRequests.join(' || ')}`);
  }

  console.log(
    `FORBIDDEN CITY STORY READING ANNOTATION E2E = PASS | SHA=${sourceSha} | LEVELS=1,3,5,8,10`,
  );
  console.log(`STORY READING ANNOTATION BARE EXPERIENCE URL = ${baseUrl}`);
} catch (error) {
  console.error('FORBIDDEN CITY STORY READING ANNOTATION E2E = FAIL');
  console.error(`CURRENT URL = ${page.url()}`);
  console.error(`CURRENT LEVEL = ${await currentSessionLevel(page).catch(() => 'unknown')}`);
  console.error(`SEMANTICS = ${(await visibleText(page).catch(() => '')).slice(0, 12000)}`);
  console.error(`PAGE ERRORS = ${JSON.stringify(pageErrors)}`);
  console.error(`FAILED REQUESTS = ${JSON.stringify(failedRequests)}`);
  throw error;
} finally {
  await context.close();
  await browser.close();
}
