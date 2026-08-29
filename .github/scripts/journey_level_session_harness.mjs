const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function semanticRecords(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.map((element, index) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    return {
      index,
      role: element.getAttribute('role') || '',
      text: [
        element.getAttribute('aria-label'),
        element.getAttribute('aria-valuetext'),
        element.getAttribute('aria-description'),
        element.textContent,
      ].filter(Boolean).join(' ').replace(/\s+/g, ' ').trim(),
      disabled: element.getAttribute('aria-disabled') === 'true',
      visible: rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden',
      area: rect.width * rect.height,
    };
  }));
}

async function findNode(page, needle, { role = null, prefix = false, timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const matches = (await semanticRecords(page)).filter((record) => {
      if (!record.visible || (role && record.role !== role)) return false;
      return prefix ? record.text.startsWith(needle) : record.text.includes(needle);
    }).sort((a, b) => a.area - b.area);
    if (matches.length) return page.locator('flt-semantics').nth(matches[0].index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function tapButton(page, needle, { prefix = false } = {}) {
  const node = await findNode(page, needle, { role: 'button', prefix });
  const deadline = Date.now() + 15000;
  while ((await node.getAttribute('aria-disabled')) === 'true') {
    if (Date.now() >= deadline) throw new Error(`button remained disabled: ${needle}`);
    await sleep(100);
  }
  const hasTouch = await page.evaluate(() => navigator.maxTouchPoints > 0);
  if (hasTouch) {
    await node.tap({ timeout: 15000 });
  } else {
    await node.click({ timeout: 15000 });
  }
}

export async function configuredLevel(page) {
  for (const record of await semanticRecords(page)) {
    if (!record.visible) continue;
    const match = record.text.match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  throw new Error('configured Phoenix level not found in Me learning settings');
}

export async function journeySessionLevel(page) {
  for (const record of await semanticRecords(page)) {
    if (!record.visible) continue;
    const match = record.text.match(/当前旅程 Phoenix 中文等级\s*(\d+)/);
    if (match) return Number(match[1]);
  }
  throw new Error('read-only Journey session level not found');
}

export async function openMeSettings(page) {
  await tapButton(page, '我的', { prefix: true });
  await findNode(page, '学习设置');
  await findNode(page, 'Phoenix 中文等级');
  await findNode(page, '中文字体');
  await findNode(page, '翻译语言');
}

export async function setConfiguredLevel(page, target) {
  await openMeSettings(page);
  for (let guard = 0; guard < 12; guard += 1) {
    const before = await configuredLevel(page);
    if (before === target) return;
    await tapButton(page, before < target ? '提高当前难度' : '降低当前难度', { prefix: true });
    const deadline = Date.now() + 6000;
    while (Date.now() < deadline) {
      const after = await configuredLevel(page).catch(() => before);
      if (after !== before) break;
      await sleep(100);
    }
  }
  throw new Error(`failed to configure Lv${target} in Me; current Lv${await configuredLevel(page)}`);
}

export async function returnToExplore(page) {
  await tapButton(page, '探索', { prefix: true });
  await findNode(page, 'PHOENIX JOURNEYS');
}

export async function assertNoJourneyLiveControls(page) {
  const text = (await semanticRecords(page)).filter((record) => record.visible).map((record) => clean(record.text)).join('\n');
  if (text.includes('提高当前难度') || text.includes('降低当前难度')) {
    throw new Error('Journey unexpectedly exposes live Phoenix level controls');
  }
}
