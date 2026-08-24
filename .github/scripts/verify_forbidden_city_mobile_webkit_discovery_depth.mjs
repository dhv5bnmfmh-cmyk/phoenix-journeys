import { readFile, writeFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';
import path from 'node:path';

const sourceUrl = new URL('./verify_forbidden_city_mobile_webkit.mjs', import.meta.url);
const source = await readFile(sourceUrl, 'utf8');

const functionMarker = 'async function verifyFounderEquivalentBareExperience(browser) {';
const helpers = String.raw`async function visibleText(page) {
  return (await records(page))
    .filter((record) => record.visible)
    .map(recordText)
    .filter(Boolean)
    .join('\n');
}

async function currentLevel(page) {
  const rs = await records(page);
  for (const record of rs) {
    if (!record.visible) continue;
    const match = recordText(record).match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  throw new Error('Mobile WebKit Phoenix level selector not found');
}

async function pressSemanticButton(page, needle, { prefix = true, timeout = 20000 } = {}) {
  const deadline = Date.now() + timeout;
  const wanted = clean(needle);
  while (Date.now() < deadline) {
    const matches = (await records(page))
      .filter((record) => {
        if (!record.visible || record.disabled || record.role !== 'button') return false;
        const text = recordText(record);
        return prefix ? text.startsWith(wanted) : text.includes(wanted);
      })
      .sort((left, right) => left.area - right.area);
    if (matches.length) {
      const node = page.locator('flt-semantics').nth(matches[0].index);
      await node.focus();
      await node.press('Enter');
      return;
    }
    await sleep(100);
  }
  throw new Error('Mobile WebKit semantic button not found: ' + needle);
}

async function setLevel(page, target) {
  for (let guard = 0; guard < 12; guard += 1) {
    const level = await currentLevel(page);
    if (level === target) return;

    const direction = level < target ? '提高当前难度' : '降低当前难度';
    const rs = await records(page);
    const matches = rs
      .filter((record) =>
        record.visible &&
        record.role === 'button' &&
        recordText(record).startsWith(direction)
      )
      .sort((left, right) => left.area - right.area);
    if (!matches.length) {
      throw new Error('Mobile WebKit level selector button missing: ' + direction);
    }

    const button = matches[0];
    if (button.disabled) {
      for (let i = 0; i < 20; i += 1) {
        await sleep(100);
        const settled = await currentLevel(page);
        if (settled === target) return;
        if (settled !== level) break;
      }
      const settled = await currentLevel(page);
      if (settled === target) return;
      if (settled !== level) continue;
      throw new Error(
        'Mobile WebKit level selector disabled before target: current Lv' +
          settled +
          ', target Lv' +
          target +
          ', button ' +
          direction,
      );
    }

    const before = level;
    const node = page.locator('flt-semantics').nth(button.index);
    await node.focus();
    await node.press('Enter');

    let moved = false;
    for (let i = 0; i < 40; i += 1) {
      await sleep(100);
      const settled = await currentLevel(page);
      if (settled === target) return;
      if (settled !== before) {
        moved = true;
        break;
      }
    }
    if (!moved) {
      throw new Error('Mobile WebKit level selector did not move from ' + before);
    }
  }

  const finalLevel = await currentLevel(page);
  if (finalLevel === target) return;
  throw new Error(
    'Mobile WebKit failed to select Lv' + target + '; current Lv' + finalLevel,
  );
}

async function waitStage(page, stage) {
  await findSemantic(page, String(stage) + '/6', {
    prefix: true,
    timeout: 30000,
  });
}

async function waitDiscoveryDepth(page, level, expected) {
  const deadline = Date.now() + 12000;
  const countNeedle = String(expected) + ' 段';
  while (Date.now() < deadline) {
    const text = await visibleText(page);
    if (
      text.includes('3/6') &&
      text.includes(countNeedle) &&
      (await currentLevel(page)) === level
    ) {
      return;
    }
    await sleep(120);
  }
  throw new Error(
    'Mobile WebKit Lv' +
      level +
      ' Discovery did not expose canonical ' +
      expected +
      '-entry rendered depth',
  );
}

async function verifyBareDiscoveryDepth(page, diagnostics) {
  await setLevel(page, 1);
  await pressSemanticButton(page, '继续');
  await waitStage(page, 2);
  diagnostics.assertNoBlockingRuntimeError();
  await pressSemanticButton(page, '继续');
  await waitStage(page, 3);
  diagnostics.assertNoBlockingRuntimeError();

  for (let level = 1; level <= 10; level += 1) {
    await setLevel(page, level);
    const expected = level <= 4 ? 2 : 3;
    await waitDiscoveryDepth(page, level, expected);
    diagnostics.assertNoBlockingRuntimeError();
    console.log(
      'MOBILE WEBKIT DISCOVERY DEPTH Lv' +
        level +
        ' = PASS | ENTRIES=' +
        expected,
    );
  }

  console.log(
    'MOBILE WEBKIT BARE DISCOVERY DEPTH = PASS | DEPTH=2/2/2/2/3/3/3/3/3/3',
  );
}

`;

if (!source.includes(functionMarker)) {
  throw new Error('Mobile WebKit Discovery wrapper function marker did not match');
}

let patched = source.replace(functionMarker, helpers + functionMarker);

const entryMarker = `    await findSemantic(page, '北京 · 紫禁城', { timeout: 30000 });
    await findSemantic(page, '1/6', { prefix: true, timeout: 30000 });
    diagnostics.assertNoBlockingRuntimeError();`;
const entryReplacement = `    await findSemantic(page, '北京 · 紫禁城', { timeout: 30000 });
    await findSemantic(page, '1/6', { prefix: true, timeout: 30000 });
    diagnostics.assertNoBlockingRuntimeError();
    await verifyBareDiscoveryDepth(page, diagnostics);`;

if (!patched.includes(entryMarker)) {
  throw new Error('Mobile WebKit Discovery wrapper entry marker did not match');
}
patched = patched.replace(entryMarker, entryReplacement);

const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `verify_forbidden_city_mobile_webkit_discovery_depth_${process.pid}.mjs`,
);
await writeFile(tempPath, patched, 'utf8');
await import(pathToFileURL(tempPath).href);
