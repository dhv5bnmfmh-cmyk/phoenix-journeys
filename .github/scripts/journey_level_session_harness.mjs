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
      x: rect.x,
      y: rect.y,
      width: rect.width,
      height: rect.height,
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
  const deadline = Date.now() + 15000;
  const hasTouch = await page.evaluate(() => navigator.maxTouchPoints > 0);
  let lastError = null;
  while (Date.now() < deadline) {
    const remaining = Math.max(250, deadline - Date.now());
    try {
      const node = await findNode(page, needle, {
        role: 'button',
        prefix,
        timeout: Math.min(1200, remaining),
      });
      if ((await node.getAttribute('aria-disabled')) === 'true') {
        await sleep(100);
        continue;
      }
      if (hasTouch) {
        await node.tap({ timeout: Math.min(2500, remaining) });
      } else {
        await node.click({ timeout: Math.min(2500, remaining) });
      }
      return;
    } catch (error) {
      lastError = error;
      await sleep(100);
    }
  }
  throw lastError ?? new Error(`button not tappable: ${needle}`);
}


export async function tapSemanticChoice(
  page,
  needle,
  { expectedText = null, absentText = null, timeout = 20000 } = {},
) {
  const wanted = clean(needle);
  const deadline = Date.now() + timeout;
  const hasTouch = await page.evaluate(() => navigator.maxTouchPoints > 0);
  let lastSnapshot = '';
  while (Date.now() < deadline) {
    const visible = (await semanticRecords(page)).filter(
      (record) => record.visible && !record.disabled,
    );
    lastSnapshot = visible.map((record) => clean(record.text)).join(' | ');
    const candidates = visible
      .filter((record) => clean(record.text).includes(wanted))
      .sort((a, b) => {
        const aRole = a.role === 'button' ? 0 : 1;
        const bRole = b.role === 'button' ? 0 : 1;
        if (aRole !== bRole) return aRole - bRole;
        const aExact = clean(a.text) === wanted ? 0 : 1;
        const bExact = clean(b.text) === wanted ? 0 : 1;
        if (aExact !== bExact) return aExact - bExact;
        return a.area - b.area;
      });
    const target = candidates[0];
    if (target) {
      const x = target.x + target.width / 2;
      const y = target.y + target.height / 2;
      try {
        if (hasTouch) {
          await page.touchscreen.tap(x, y);
        } else {
          await page.mouse.click(x, y);
        }
      } catch (_) {
        await sleep(100);
        continue;
      }
      const settleDeadline = Date.now() + 1800;
      while (Date.now() < settleDeadline) {
        const text = (await semanticRecords(page))
          .filter((record) => record.visible)
          .map((record) => clean(record.text))
          .join('\n');
        const expectedOk = expectedText == null || text.includes(expectedText);
        const absentOk = absentText == null || !text.includes(absentText);
        if (expectedOk && absentOk) return;
        await sleep(100);
      }
    }
    await sleep(100);
  }
  throw new Error(
    `semantic choice not actionable: ${needle}; snapshot=${lastSnapshot.slice(0, 1200)}`,
  );
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

export async function saveMemoryAndWaitCommitted(
  page,
  { expectedValues = [], timeout = 15000 } = {},
) {
  const keyHint = 'journeyMemory.entries.v1';
  const before = await page.evaluate((hint) => {
    const candidates = [];
    for (let i = 0; i < localStorage.length; i += 1) {
      const key = localStorage.key(i);
      if (key && key.includes(hint)) candidates.push([key, localStorage.getItem(key)]);
    }
    candidates.sort((a, b) => a[0].localeCompare(b[0]));
    const [key, value] = candidates[0] ?? [null, null];
    return { key, value };
  }, keyHint);

  await page.evaluate(() => {
    delete window.__phoenixMemoryCommitWitness;
  });
  await tapButton(page, '保存修改', { prefix: true });

  await page.waitForFunction(
    ({ keyHint: hint, beforeValue, expectedValues: expected }) => {
      const candidates = [];
      for (let i = 0; i < localStorage.length; i += 1) {
        const key = localStorage.key(i);
        if (key && key.includes(hint)) candidates.push([key, localStorage.getItem(key)]);
      }
      candidates.sort((a, b) => a[0].localeCompare(b[0]));
      const [key, value] = candidates[0] ?? [null, null];
      if (value == null || value === beforeValue) return false;

      let decoded = value;
      for (let i = 0; i < 4 && typeof decoded === 'string'; i += 1) {
        try {
          const parsed = JSON.parse(decoded);
          if (parsed === decoded) break;
          decoded = parsed;
        } catch (_) {
          break;
        }
      }
      const text = typeof decoded === 'string' ? decoded : JSON.stringify(decoded);
      if (!expected.every((marker) => text.includes(marker))) return false;

      const previous = window.__phoenixMemoryCommitWitness;
      if (previous?.key === key && previous.value === value) {
        previous.stableReads += 1;
      } else {
        window.__phoenixMemoryCommitWitness = { key, value, stableReads: 1 };
      }
      return window.__phoenixMemoryCommitWitness.stableReads >= 2;
    },
    { keyHint, beforeValue: before.value, expectedValues },
    { polling: 'raf', timeout },
  );
}

