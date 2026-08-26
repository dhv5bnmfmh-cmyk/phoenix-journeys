export const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
export const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

export function recordText(record) {
  return clean([record?.label, record?.value, record?.description, record?.text].filter(Boolean).join(' '));
}

export function semanticMatches(record, spec = {}) {
  if (!record || (spec.visible !== false && !record.visible)) return false;
  if (spec.role && record.role !== spec.role) return false;
  if (spec.enabled === true && record.disabled) return false;
  if (spec.enabled === false && !record.disabled) return false;
  const text = recordText(record);
  if (spec.exact != null && text !== clean(spec.exact)) return false;
  if (spec.prefix != null && !text.startsWith(clean(spec.prefix))) return false;
  if (spec.includes != null && !text.includes(clean(spec.includes))) return false;
  if (spec.pattern && !spec.pattern.test(text)) return false;
  return true;
}

export async function recordForHandle(handle) {
  try {
    return await handle.evaluate((element) => {
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
        area: rect.width * rect.height,
      };
    });
  } catch (_) {
    return null;
  }
}

export async function records(page) {
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
        area: rect.width * rect.height,
      };
    }),
  );
}

export async function visibleText(page) {
  return (await records(page)).filter((record) => record.visible).map(recordText).filter(Boolean).join('\n');
}

export async function bindLiveSemantic(page, spec, { timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  let lastObserved = [];
  while (Date.now() <= deadline) {
    const handles = await page.locator('flt-semantics').elementHandles();
    const candidates = [];
    for (const handle of handles) {
      const record = await recordForHandle(handle);
      if (record && semanticMatches(record, spec)) candidates.push({ handle, record });
    }
    candidates.sort((left, right) => {
      if (left.record.role === 'button' && right.record.role !== 'button') return -1;
      if (right.record.role === 'button' && left.record.role !== 'button') return 1;
      return left.record.area - right.record.area;
    });
    lastObserved = candidates.map(({ record }) => recordText(record));
    for (const candidate of candidates) {
      const fresh = await recordForHandle(candidate.handle);
      if (fresh && semanticMatches(fresh, spec)) return { handle: candidate.handle, record: fresh };
    }
    await sleep(100);
  }
  throw new Error(`live semantic not found: ${JSON.stringify(spec)} observed=${JSON.stringify(lastObserved.slice(0, 8))}`);
}

export async function activateSemantic(page, spec, { mode = 'click', timeout = 15000, retries = 3 } = {}) {
  let lastError = null;
  for (let attempt = 1; attempt <= retries; attempt += 1) {
    try {
      const bound = await bindLiveSemantic(page, { ...spec, enabled: true }, { timeout });
      const before = await recordForHandle(bound.handle);
      if (!before || !semanticMatches(before, { ...spec, enabled: true })) {
        throw new Error('live semantic identity changed before activation');
      }
      if (mode === 'tap') await bound.handle.tap({ timeout: Math.min(timeout, 5000) });
      else await bound.handle.click({ timeout: Math.min(timeout, 5000) });
      return before;
    } catch (error) {
      lastError = error;
      if (attempt < retries) await sleep(120);
    }
  }
  throw lastError ?? new Error(`semantic activation failed: ${JSON.stringify(spec)}`);
}

export function stageFromRecords(items) {
  const stages = [];
  for (const record of items || []) {
    if (!record.visible) continue;
    const match = recordText(record).match(/^([1-6])\/6(?:\s|$)/);
    if (match) stages.push(Number(match[1]));
  }
  return stages.length ? Math.max(...stages) : null;
}

export function levelFromRecords(items) {
  for (const record of items || []) {
    if (!record.visible) continue;
    const match = recordText(record).match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  return null;
}

export function classifyDialogState(items) {
  const visible = (items || []).filter((record) => record.visible);
  const hasDialogRoot = visible.some((record) => record.role === 'dialog' || clean(record.label) === 'Dialog');
  if (!hasDialogRoot) return { state: 'NONE', kind: null };
  const corpus = visible.map(recordText).filter(Boolean).join('\n');
  const concrete = corpus.replace(/\bDialog\b/g, '').trim();
  if (!concrete) return { state: 'MOUNTING_UNIDENTIFIED', kind: null };
  if (corpus.includes('中文朗读声线')) return { state: 'KNOWN', kind: 'voice-selector' };
  if (corpus.includes('收藏单词') && corpus.includes('上一个单词') && corpus.includes('下一个单词')) {
    return { state: 'KNOWN', kind: 'vocabulary-word-detail' };
  }
  return { state: 'UNKNOWN', kind: null, corpus };
}

export async function settleKnownModal(page, { mode = 'click', timeout = 5000 } = {}) {
  const deadline = Date.now() + timeout;
  while (Date.now() <= deadline) {
    const snapshot = await records(page);
    const dialog = classifyDialogState(snapshot);
    if (dialog.state === 'NONE') return false;
    if (dialog.state === 'MOUNTING_UNIDENTIFIED') {
      await sleep(100);
      continue;
    }
    if (dialog.state === 'UNKNOWN') {
      throw new Error(`UNKNOWN MODAL != AUTO-DISMISS | ${clean(dialog.corpus).slice(0, 500)}`);
    }
    try {
      await activateSemantic(page, { role: 'button', exact: 'Dismiss' }, { mode, timeout: 1000, retries: 1 });
    } catch (_) {
      await sleep(100);
      continue;
    }
    const vanishDeadline = Date.now() + 3000;
    while (Date.now() <= vanishDeadline) {
      if (classifyDialogState(await records(page)).state === 'NONE') return true;
      await sleep(100);
    }
    throw new Error(`known modal ${dialog.kind} did not disappear after allowed close control`);
  }
  throw new Error('dialog identity/close-control did not settle within bounded wait');
}

export async function currentLevel(page) {
  const level = levelFromRecords(await records(page));
  if (level == null) throw new Error('Phoenix level selector not found');
  return level;
}

export async function currentStage(page) {
  const stage = stageFromRecords(await records(page));
  if (stage == null) throw new Error('Journey stage not found');
  return stage;
}

export async function assertTargetLevel(page, target, label) {
  const actual = await currentLevel(page);
  if (actual !== target) throw new Error(`LEVEL DRIFT | ${label} | expected Lv${target} actual Lv${actual}`);
  return actual;
}

export async function waitStableStage(page, stage, targetLevel, { timeout = 20000, mode = 'click' } = {}) {
  const deadline = Date.now() + timeout;
  let stable = 0;
  while (Date.now() <= deadline) {
    await settleKnownModal(page, { mode, timeout: 1200 }).catch((error) => {
      if (String(error?.message || error).includes('UNKNOWN MODAL')) throw error;
    });
    const snapshot = await records(page);
    const actualStage = stageFromRecords(snapshot);
    const actualLevel = levelFromRecords(snapshot);
    if (actualLevel != null && actualLevel !== targetLevel) {
      throw new Error(`LEVEL DRIFT | stage ${stage}/6 | expected Lv${targetLevel} actual Lv${actualLevel}`);
    }
    if (actualStage === stage && actualLevel === targetLevel) {
      stable += 1;
      if (stable >= 3) return snapshot;
    } else {
      stable = 0;
    }
    await sleep(100);
  }
  throw new Error(`stable stage not reached: ${stage}/6 Lv${targetLevel}`);
}

export async function setLevel(page, target, { mode = 'click' } = {}) {
  for (let guard = 0; guard < 16; guard += 1) {
    await settleKnownModal(page, { mode, timeout: 1200 });
    const before = await currentLevel(page);
    if (before === target) return;
    const direction = before < target ? '提高当前难度' : '降低当前难度';
    await activateSemantic(page, { role: 'button', prefix: direction }, { mode });
    const deadline = Date.now() + 6000;
    while (Date.now() <= deadline) {
      const now = await currentLevel(page).catch(() => before);
      if (now === target) return;
      if (now !== before) break;
      await sleep(100);
    }
  }
  throw new Error(`failed to select Lv${target}; current Lv${await currentLevel(page)}`);
}

export function terminalNarrationState(items) {
  const corpus = (items || []).filter((record) => record.visible).map(recordText).join('\n');
  return /朗读完成\s*[·・]?\s*100%/.test(corpus);
}

export function shouldAcceptTerminalCorpus({ stage, level, targetLevel, completed100, anchorsComplete, unresolvedModal, drift }) {
  return stage === 3 && level === targetLevel && completed100 === true && anchorsComplete === true && !unresolvedModal && !drift;
}

export function discoveryDepthFromText(text) {
  const match = clean(text).match(/Discovery[^\n]*?(\d+)\s*段|分段短文\s*[·・]?\s*(\d+)\s*段|共\s*(\d+)\s*段/);
  const value = match ? Number(match[1] || match[2] || match[3]) : null;
  return Number.isInteger(value) ? value : null;
}
