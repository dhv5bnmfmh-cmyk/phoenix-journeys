import { pathToFileURL } from 'node:url';

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
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) {
    await placeholder.evaluate((element) => element.click());
  }
  await page
    .locator('flt-semantics')
    .first()
    .waitFor({ state: 'attached', timeout: 30000 });
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

async function currentLevel(page) {
  for (const record of await records(page)) {
    if (!record.visible) continue;
    const match = recordText(record).match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  throw new Error('Phoenix level selector not found');
}

async function setLevel(page, target) {
  for (let guard = 0; guard < 16; guard += 1) {
    const level = await currentLevel(page);
    if (level === target) return;
    const direction = level < target ? '提高当前难度' : '降低当前难度';
    await activateButton(page, direction, { exact: false });
    const deadline = Date.now() + 6000;
    while (Date.now() < deadline) {
      const settled = await currentLevel(page).catch(() => level);
      if (settled === target) return;
      if (settled !== level) break;
      await sleep(100);
    }
  }
  throw new Error(
    `failed to select Lv${target}; current Lv${await currentLevel(page)}`,
  );
}

async function openForbiddenCity(page) {
  if ((await visibleText(page)).includes('北京 · 紫禁城')) {
    await waitForText(page, '1/6');
    return;
  }
  await waitForText(page, 'PHOENIX JOURNEYS', 30000);
  await activateButton(page, '选择城市', { exact: false });
  await waitForText(page, '选择城市与地点');
  await activateButton(page, '北京');
  await waitForText(page, '北京的地点');
  await activateButton(page, '紫禁城');

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
  await page.goto(baseUrl, { waitUntil: 'domcontentloaded', timeout: 30000 });
  await enableSemantics(page);
  await openForbiddenCity(page);

  for (const level of levels) {
    await setLevel(page, level);
    await waitForText(page, '1/6');
    if ((await currentLevel(page)) !== level) {
      throw new Error(`Lv${level} Story level drift before Reading Support`);
    }

    const storyText = await visibleText(page);
    requireMarkers(storyText, expected[level].story, `Lv${level} CURRENT Story`);

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
  console.error(`CURRENT LEVEL = ${await currentLevel(page).catch(() => 'unknown')}`);
  console.error(`SEMANTICS = ${(await visibleText(page).catch(() => '')).slice(0, 12000)}`);
  console.error(`PAGE ERRORS = ${JSON.stringify(pageErrors)}`);
  console.error(`FAILED REQUESTS = ${JSON.stringify(failedRequests)}`);
  throw error;
} finally {
  await context.close();
  await browser.close();
}
