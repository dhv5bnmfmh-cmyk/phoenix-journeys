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

async function semanticButton(
  page,
  needle,
  { prefix = true, timeout = 20000 } = {},
) {
  const deadline = Date.now() + timeout;
  const wanted = clean(needle);

  while (Date.now() < deadline) {
    const locator = page.getByRole('button', {
      name: wanted,
      exact: !prefix,
    });
    const count = await locator.count();
    if (count === 1) {
      const disabled = await locator.getAttribute('aria-disabled').catch(() => null);
      if (disabled === 'true') {
        throw new Error('Mobile WebKit semantic button disabled: ' + needle);
      }
      return locator;
    }
    if (count > 1) {
      const labels = await locator.evaluateAll((elements) =>
        elements.map((element) =>
          [
            element.getAttribute('aria-label') || '',
            element.getAttribute('aria-valuetext') || '',
            element.getAttribute('aria-description') || '',
            String(element.textContent || '').replace(/\s+/g, ' ').trim(),
          ]
            .filter(Boolean)
            .join(' '),
        ),
      );
      throw new Error(
        'Mobile WebKit semantic button ambiguous: ' +
          needle +
          ' :: ' +
          labels.join(' || '),
      );
    }
    await sleep(100);
  }
  throw new Error('Mobile WebKit semantic button not found: ' + needle);
}

async function wordDetailDialogOpen(page) {
  const text = await visibleText(page);
  if (
    !text.includes('收藏单词') ||
    !text.includes('上一个单词') ||
    !text.includes('下一个单词')
  ) {
    return false;
  }
  return (await page.getByRole('button', { name: 'Dismiss', exact: true }).count()) === 1;
}

async function closeHarnessWordDetailDialog(page) {
  if (!(await wordDetailDialogOpen(page))) return false;
  const dismiss = await semanticButton(page, 'Dismiss', {
    prefix: false,
    timeout: 3000,
  });
  await dismiss.focus();
  const focused = await dismiss.evaluate(
    (element) => document.activeElement === element,
  );
  if (!focused) {
    throw new Error('Mobile WebKit could not focus Word Detail dismiss control');
  }
  await page.keyboard.press('Enter');

  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    if (!(await wordDetailDialogOpen(page))) {
      console.log('MOBILE WEBKIT HARNESS RECOVERED WORD DETAIL DIALOG');
      return true;
    }
    await sleep(100);
  }
  throw new Error('Mobile WebKit harness could not dismiss Word Detail dialog');
}

async function activateSemanticButton(
  page,
  needle,
  { prefix = true, timeout = 20000 } = {},
) {
  await closeHarnessWordDetailDialog(page);
  const button = await semanticButton(page, needle, { prefix, timeout });
  await button.focus();
  const focused = await button.evaluate(
    (element) => document.activeElement === element,
  );
  if (!focused) {
    throw new Error('Mobile WebKit semantic focus failed: ' + needle);
  }
  await page.keyboard.press('Enter');
}

async function stageVisible(page, stage) {
  const wanted = String(stage) + '/6';
  return (await records(page)).some(
    (record) => record.visible && recordText(record).startsWith(wanted),
  );
}

async function waitStage(page, stage, timeout = 30000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    if (await stageVisible(page, stage)) return;
    await sleep(100);
  }
  throw new Error('semantic state not found: ' + stage + '/6');
}

async function advanceStage(page, fromStage, toStage, diagnostics) {
  await waitStage(page, fromStage);
  for (let attempt = 1; attempt <= 4; attempt += 1) {
    await closeHarnessWordDetailDialog(page);
    await activateSemanticButton(page, '继续');

    const deadline = Date.now() + 7000;
    while (Date.now() < deadline) {
      if (await stageVisible(page, toStage)) {
        diagnostics.assertNoBlockingRuntimeError();
        return;
      }
      if (await wordDetailDialogOpen(page)) {
        await closeHarnessWordDetailDialog(page);
        break;
      }
      await sleep(100);
    }

    diagnostics.assertNoBlockingRuntimeError();
    if (await stageVisible(page, toStage)) return;
    console.log(
      'MOBILE WEBKIT HARNESS RETRY STAGE ' +
        fromStage +
        '→' +
        toStage +
        ' ATTEMPT=' +
        attempt,
    );
  }
  throw new Error(
    'Mobile WebKit failed semantic stage transition ' +
      fromStage +
      '/6→' +
      toStage +
      '/6',
  );
}

async function setLevel(page, target) {
  for (let guard = 0; guard < 16; guard += 1) {
    await closeHarnessWordDetailDialog(page);
    const level = await currentLevel(page);
    if (level === target) return;

    const direction = level < target ? '提高当前难度' : '降低当前难度';
    const before = level;
    await activateSemanticButton(page, direction);

    let moved = false;
    const deadline = Date.now() + 5000;
    while (Date.now() < deadline) {
      if (await wordDetailDialogOpen(page)) {
        await closeHarnessWordDetailDialog(page);
        break;
      }
      const settled = await currentLevel(page).catch(() => before);
      if (settled === target) return;
      if (settled !== before) {
        moved = true;
        break;
      }
      await sleep(100);
    }
    if (!moved) {
      continue;
    }
  }

  const finalLevel = await currentLevel(page);
  if (finalLevel === target) return;
  throw new Error(
    'Mobile WebKit failed to select Lv' + target + '; current Lv' + finalLevel,
  );
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
  await advanceStage(page, 1, 2, diagnostics);
  await advanceStage(page, 2, 3, diagnostics);

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
