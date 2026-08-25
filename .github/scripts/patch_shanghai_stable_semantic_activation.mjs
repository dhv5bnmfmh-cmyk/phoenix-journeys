import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_stable_semantic_activation.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'stable semantic record activation helper',
  `async function activateButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(\`button disabled: \${needle}\`);
  await activateSemantic(page, node);
}

async function dismissKnownTransientModal(page) {`,
  `async function activateButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(\`button disabled: \${needle}\`);
  await activateSemantic(page, node);
}

async function activateStableSemanticRecord(page, record, { expectedRole = null, allowedTexts = null, timeout = 10000 } = {}) {
  const locator = page.locator('flt-semantics').nth(record.index);
  const handle = await locator.elementHandle();
  if (!handle) throw new Error('semantic record detached before stable activation');

  const live = await handle.evaluate((el) => ({
    role: el.getAttribute('role'),
    label: el.getAttribute('aria-label') || '',
    value: el.getAttribute('aria-valuetext') || '',
    description: el.getAttribute('aria-description') || '',
    text: String(el.textContent || '').replace(/\\s+/g, ' ').trim(),
    disabled: el.getAttribute('aria-disabled') === 'true',
  }));
  const liveText = semanticRecordText(live);
  if (expectedRole && live.role !== expectedRole) {
    throw new Error(\`semantic record role changed before activation: expected \${expectedRole}, got \${live.role}\`);
  }
  if (live.disabled) throw new Error('semantic record became disabled before activation');
  if (allowedTexts && !allowedTexts.includes(liveText)) {
    throw new Error(\`semantic record identity changed before activation: \${liveText}\`);
  }

  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await handle.click({ timeout, noWaitAfter: true });
    return;
  }
  if (mode === interactionModes.touch) {
    await handle.tap({ timeout });
    return;
  }
  throw new Error('browser interaction mode was not registered before stable semantic activation');
}

async function dismissKnownTransientModal(page) {`
);

replaceOnce(
  'modal close fixed-handle activation',
  `  console.log(\`KNOWN TRANSIENT MODAL CLOSE READY = \${expectedId} | ACTION=\${semanticRecordText(closeRecord)}\`);
  await activateSemantic(page, page.locator('flt-semantics').nth(closeRecord.index));`,
  `  console.log(\`KNOWN TRANSIENT MODAL CLOSE READY = \${expectedId} | ACTION=\${semanticRecordText(closeRecord)}\`);
  await activateStableSemanticRecord(page, closeRecord, {
    expectedRole: 'button',
    allowedTexts: initial.definition.closeLabels,
  });`
);

replaceOnce(
  'level stable postcondition helpers',
  `async function setLevel(page, target) {
  let level = await currentLevel(page);
  for (let guard = 0; level !== target && guard < 12; guard += 1) {
    const before = level;
    await activateButton(page, level < target ? '提高当前难度' : '降低当前难度', { prefix: true });
    for (let i = 0; i < 50; i += 1) {
      await sleep(100);
      level = await currentLevel(page);
      if (level !== before) break;
    }
    if (level === before) throw new Error(\`level selector did not move from \${before}\`);
  }
  if (level !== target) throw new Error(\`failed to select Lv\${target}; current Lv\${level}\`);
}

async function waitStage(page, n) {`,
  `async function waitStableLevel(page, target, { consecutive = 5, timeout = 8000 } = {}) {
  const deadline = Date.now() + timeout;
  let streak = 0;
  let last = null;
  while (Date.now() < deadline) {
    last = await currentLevel(page);
    if (last === target) {
      streak += 1;
      if (streak >= consecutive) return;
    } else {
      streak = 0;
    }
    await sleep(100);
  }
  throw new Error(\`LEVEL DRIFT / UNSETTLED: expected Lv\${target}; current Lv\${last}; stable reads \${streak}/\${consecutive}\`);
}

async function setLevel(page, target) {
  let level = await currentLevel(page);
  for (let guard = 0; level !== target && guard < 12; guard += 1) {
    const before = level;
    await activateButton(page, level < target ? '提高当前难度' : '降低当前难度', { prefix: true });
    for (let i = 0; i < 50; i += 1) {
      await sleep(100);
      level = await currentLevel(page);
      if (level !== before) break;
    }
    if (level === before) throw new Error(\`level selector did not move from \${before}\`);
  }
  if (level !== target) throw new Error(\`failed to select Lv\${target}; current Lv\${level}\`);
  await waitStableLevel(page, target);
}

async function assertTargetLevel(page, target, stage) {
  try {
    await waitStableLevel(page, target, { consecutive: 3, timeout: 3000 });
  } catch (error) {
    throw new Error(\`LEVEL DRIFT at \${stage}: expected Lv\${target}; \${error.message}\`);
  }
}

function runLevelSettleFixturePreflight() {
  function settled(sequence, target, consecutive) {
    let streak = 0;
    for (const value of sequence) {
      streak = value === target ? streak + 1 : 0;
      if (streak >= consecutive) return true;
    }
    return false;
  }
  if (!settled([2, 3, 3, 3, 3, 3], 3, 5)) throw new Error('stable target-level fixture did not settle');
  if (settled([2, 3, 3, 2, 3, 3], 3, 3)) throw new Error('transient target-level fixture incorrectly settled');
  if (settled([3, 3, 2], 3, 3)) throw new Error('level-drift fixture incorrectly passed');

  const original = [
    { index: 0, role: 'button', text: 'Dismiss', visible: true, disabled: false },
    { index: 1, role: 'button', text: '降低当前难度', visible: true, disabled: false },
  ];
  const reordered = [
    { index: 0, role: null, text: 'new semantics node', visible: true, disabled: false },
    { index: 1, role: 'button', text: 'Dismiss', visible: true, disabled: false },
    { index: 2, role: 'button', text: '降低当前难度', visible: true, disabled: false },
  ];
  if (semanticRecordText(original[0]) !== 'Dismiss' || semanticRecordText(reordered[1]) !== 'Dismiss') {
    throw new Error('semantic-index reorder fixture malformed');
  }
  if (semanticRecordText(reordered[0]) === semanticRecordText(original[0])) {
    throw new Error('semantic-index reorder fixture did not demonstrate stale-index risk');
  }
  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement');
}

async function waitStage(page, n) {`
);

replaceOnce(
  'level fixture cli',
  `if (process.argv.includes('--transient-modal-preflight')) {
  runTransientModalFixturePreflight();
  process.exit(0);
}

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);`,
  `if (process.argv.includes('--transient-modal-preflight')) {
  runTransientModalFixturePreflight();
  process.exit(0);
}

if (process.argv.includes('--level-settle-preflight')) {
  runLevelSettleFixturePreflight();
  process.exit(0);
}

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);`
);

replaceOnce(
  'runLevel stage-bound level postconditions',
  `    await waitStage(page, 1);
    await setLevel(page, level);
    const story = await visibleText(page);`,
  `    await waitStage(page, 1);
    await setLevel(page, level);
    await assertTargetLevel(page, level, 'Story');
    const story = await visibleText(page);`
);

replaceOnce(
  'vocabulary level postcondition',
  `    await waitStage(page, 2);
    const vocabulary = await visibleText(page);`,
  `    await waitStage(page, 2);
    await assertTargetLevel(page, level, 'Vocabulary');
    const vocabulary = await visibleText(page);`
);

replaceOnce(
  'discovery level postcondition',
  `    await waitStage(page, 3);
    await collectDiscoveryStageSemantics(page, level);`,
  `    await waitStage(page, 3);
    await assertTargetLevel(page, level, 'Discovery');
    await collectDiscoveryStageSemantics(page, level);`
);

replaceOnce(
  'challenge level postcondition',
  `    await waitStage(page, 4);
    await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 15000 });`,
  `    await waitStage(page, 4);
    await assertTargetLevel(page, level, 'Challenge');
    await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 15000 });`
);

replaceOnce(
  'memory level postcondition',
  `    await waitStage(page, 5);
    const memory = await visibleText(page);`,
  `    await waitStage(page, 5);
    await assertTargetLevel(page, level, 'Memory');
    const memory = await visibleText(page);`
);

replaceOnce(
  'completion level postcondition',
  `    await waitStage(page, 6);
    await findSemantic(page, '已点亮', { timeout: 15000 });`,
  `    await waitStage(page, 6);
    await assertTargetLevel(page, level, 'Completion');
    await findSemantic(page, '已点亮', { timeout: 15000 });`
);

replaceOnce(
  'browser-mode WebKit Lv3 settle preflight',
  `    await activateButton(page, '外滩');
    await waitStage(page, 1);
    if (browserName === 'webkit') {`,
  `    await activateButton(page, '外滩');
    await waitStage(page, 1);
    if (browserName === 'webkit') {
      await setLevel(page, 3);
      await assertTargetLevel(page, 3, 'WebKit browser-mode preflight');
      console.log('BROWSER MODE PREFLIGHT WEBKIT LEVEL SETTLE = PASS | TARGET=Lv3');`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`STABLE SEMANTIC ACTIVATION + LEVEL GUARD PATCH = PASS | ${target}`);
