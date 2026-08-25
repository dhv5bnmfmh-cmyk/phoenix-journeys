import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_seek_action_safety.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'bound live semantic identity helper',
  `async function activateStableSemanticRecord(page, record, { expectedRole = null, allowedTexts = null, timeout = 10000 } = {}) {
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

async function dismissKnownTransientModal(page) {`,
  `async function readBoundSemanticHandle(handle) {
  return handle.evaluate((el) => ({
    connected: el.isConnected,
    role: el.getAttribute('role'),
    label: el.getAttribute('aria-label') || '',
    value: el.getAttribute('aria-valuetext') || '',
    description: el.getAttribute('aria-description') || '',
    text: String(el.textContent || '').replace(/\\s+/g, ' ').trim(),
    disabled: el.getAttribute('aria-disabled') === 'true',
  }));
}

function verifyBoundSemanticIdentity(live, { expectedRole = null, allowedTexts = null, expectedNeedle = null } = {}) {
  if (!live.connected) throw new Error('bound semantic element detached before activation');
  const liveText = semanticRecordText(live);
  if (expectedRole && live.role !== expectedRole) {
    throw new Error(\`semantic record role changed before activation: expected \${expectedRole}, got \${live.role}\`);
  }
  if (live.disabled) throw new Error('semantic record became disabled before activation');
  if (allowedTexts && !allowedTexts.includes(liveText)) {
    throw new Error(\`semantic record identity changed before activation: \${liveText}\`);
  }
  if (expectedNeedle && !liveText.includes(expectedNeedle)) {
    throw new Error(\`semantic record identity changed before activation: expected \${expectedNeedle}, got \${liveText}\`);
  }
  return liveText;
}

async function bindStableSemanticRecord(page, record, identity = {}) {
  const locator = page.locator('flt-semantics').nth(record.index);
  const handle = await locator.elementHandle();
  if (!handle) throw new Error('semantic record detached before live binding');
  const live = await readBoundSemanticHandle(handle);
  const liveText = verifyBoundSemanticIdentity(live, identity);
  return { handle, live, liveText };
}

async function activateStableSemanticRecord(page, record, { expectedRole = null, allowedTexts = null, expectedNeedle = null, timeout = 10000 } = {}) {
  const identity = { expectedRole, allowedTexts, expectedNeedle };
  const { handle } = await bindStableSemanticRecord(page, record, identity);
  verifyBoundSemanticIdentity(await readBoundSemanticHandle(handle), identity);

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
  'discovery-specific level guard',
  `async function assertTargetLevel(page, target, stage) {
  try {
    await waitStableLevel(page, target, { consecutive: 3, timeout: 3000 });
  } catch (error) {
    throw new Error(\`LEVEL DRIFT at \${stage}: expected Lv\${target}; \${error.message}\`);
  }
}

function runLevelSettleFixturePreflight() {`,
  `async function assertTargetLevel(page, target, stage) {
  try {
    await waitStableLevel(page, target, { consecutive: 3, timeout: 3000 });
  } catch (error) {
    throw new Error(\`LEVEL DRIFT at \${stage}: expected Lv\${target}; \${error.message}\`);
  }
}

async function assertDiscoveryTargetLevel(page, target, phase) {
  const actual = await currentLevel(page);
  if (actual !== target) {
    throw new Error(\`LEVEL DRIFT DURING DISCOVERY SEEK | expected Lv\${target} | actual Lv\${actual} | \${phase}\`);
  }
  await assertTargetLevel(page, target, \`Discovery traversal \${phase}\`);
}

function runLevelSettleFixturePreflight() {`
);

replaceOnce(
  'seek rail reorder and mid-stage level fixtures',
  `  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement');`,
  `  const seekSnapshot = [
    { index: 18, role: 'button', text: '朗读进度，可拖动跳转 42%', visible: true, disabled: false },
  ];
  const seekReordered = [
    { index: 18, role: 'button', text: '降低当前难度', visible: true, disabled: false },
    { index: 19, role: 'button', text: '朗读进度，可拖动跳转 42%', visible: true, disabled: false },
  ];
  const staleIndexTarget = seekReordered.find((record) => record.index === seekSnapshot[0].index);
  if (!staleIndexTarget || semanticRecordText(staleIndexTarget) !== '降低当前难度') {
    throw new Error('seek-rail reorder fixture did not prove stale-index decrement risk');
  }
  const identityTarget = seekReordered.find((record) => semanticRecordText(record).includes('朗读进度，可拖动跳转'));
  if (!identityTarget || identityTarget.index !== 19) {
    throw new Error('seek-rail reorder fixture did not preserve narration-rail identity');
  }

  function assertDiscoveryLevelSequence(sequence, target) {
    for (const actual of sequence) {
      if (actual !== target) {
        throw new Error(\`LEVEL DRIFT DURING DISCOVERY SEEK | expected Lv\${target} | actual Lv\${actual}\`);
      }
    }
  }
  assertDiscoveryLevelSequence([8, 8, 8], 8);
  let discoveryDriftRejected = false;
  try {
    assertDiscoveryLevelSequence([8, 7], 8);
  } catch (error) {
    discoveryDriftRejected = error.message.includes('LEVEL DRIFT DURING DISCOVERY SEEK') && error.message.includes('actual Lv7');
  }
  if (!discoveryDriftRejected) throw new Error('Lv8 -> Lv7 Discovery drift fixture did not fail immediately');

  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement | seek rail reorder cannot target difficulty decrement | Lv8 mid-stage drift rejected');`
);

replaceOnce(
  'bound narration seek geometry',
  `async function seekNarrationProgress(page, progress) {
  const rs = await records(page);
  const rail = rs.find((r) => r.visible && recText(r).includes('朗读进度，可拖动跳转'));
  if (!rail) throw new Error('Discovery narration seek rail not found');
  const locator = page.locator('flt-semantics').nth(rail.index);
  const box = await locator.boundingBox();
  if (!box || box.width <= 2 || box.height <= 2) throw new Error('Discovery narration seek rail has no actionable geometry');
  const x = box.x + Math.max(1, Math.min(box.width - 1, box.width * progress));
  const y = box.y + box.height / 2;
  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await page.mouse.click(x, y);
  } else if (mode === interactionModes.touch) {
    await page.touchscreen.tap(x, y);
  } else {
    throw new Error('browser interaction mode was not registered before narration seek');
  }
  await sleep(300);
}`,
  `async function seekNarrationProgress(page, progress) {
  const rs = await records(page);
  const rail = rs.find((r) => r.visible && !r.disabled && r.role === 'button' && recText(r).includes('朗读进度，可拖动跳转'));
  if (!rail) throw new Error('Discovery narration seek rail not found');

  const identity = { expectedRole: 'button', expectedNeedle: '朗读进度，可拖动跳转' };
  const { handle } = await bindStableSemanticRecord(page, rail, identity);
  const box = await handle.boundingBox();
  if (!box || box.width <= 2 || box.height <= 2) throw new Error('Discovery narration seek rail has no actionable geometry');
  const position = {
    x: Math.max(1, Math.min(box.width - 1, box.width * progress)),
    y: box.height / 2,
  };

  verifyBoundSemanticIdentity(await readBoundSemanticHandle(handle), identity);
  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await handle.click({ position, timeout: 10000, noWaitAfter: true });
  } else if (mode === interactionModes.touch) {
    await handle.tap({ position, timeout: 10000 });
  } else {
    throw new Error('browser interaction mode was not registered before narration seek');
  }
  await sleep(300);
}`
);

replaceOnce(
  'coarse discovery seek level guard',
  `    await seekNarrationProgress(page, progress);
    await waitStage(page, 3);
    const text = await visibleText(page);`,
  `    await seekNarrationProgress(page, progress);
    await waitStage(page, 3);
    await assertDiscoveryTargetLevel(page, level, \`seek \${Math.round(progress * 100)}%\`);
    const text = await visibleText(page);`
);

replaceOnce(
  'fine discovery seek level guard',
  `      await seekNarrationProgress(page, i / 100);
      await waitStage(page, 3);
      const text = await visibleText(page);`,
  `      await seekNarrationProgress(page, i / 100);
      await waitStage(page, 3);
      await assertDiscoveryTargetLevel(page, level, \`seek \${i}%\`);
      const text = await visibleText(page);`
);

replaceOnce(
  'final discovery seek level guard',
  `  await seekNarrationProgress(page, 0.999);
  const finishDeadline = Date.now() + 10000;`,
  `  await seekNarrationProgress(page, 0.999);
  await waitStage(page, 3);
  await assertDiscoveryTargetLevel(page, level, 'final seek 100%');
  const finishDeadline = Date.now() + 10000;`
);

replaceOnce(
  'discovery narration transition level guard',
  `  while (Date.now() < finishDeadline) {
    await waitStage(page, 3);
    finalText = await visibleText(page);`,
  `  while (Date.now() < finishDeadline) {
    await waitStage(page, 3);
    await assertTargetLevel(page, level, 'Discovery narration transition');
    finalText = await visibleText(page);`
);

replaceOnce(
  'grammar segment live binding',
  `  await activateSemantic(page, page.locator('flt-semantics').nth(segment.index));`,
  `  await activateStableSemanticRecord(page, segment, {
    expectedRole: 'checkbox',
    allowedTexts: [recText(segment)],
  });`
);

replaceOnce(
  'challenge option live binding',
  `    await activateSemantic(page, page.locator('flt-semantics').nth(hit.index));
    await sleep(120);`,
  `    await activateStableSemanticRecord(page, hit, {
      expectedRole: hit.role,
      allowedTexts: [recText(hit)],
    });
    await sleep(120);`
);

replaceOnce(
  'WebKit Lv8 Discovery preflight function',
  `async function runBrowserModePreflight(browserType, browserName) {`,
  `async function runWebKitLv8DiscoveryPreflight() {
  const browser = await playwright.webkit.launch({ headless: true });
  const context = await browser.newContext(contextOptions('webkit'));
  const page = await context.newPage();
  registerInteractionMode(page, interactionModeFor('webkit'));
  try {
    await loadExperience(page);
    await openShanghaiBund(page);
    await waitStage(page, 1);
    await setLevel(page, 8);
    await assertTargetLevel(page, 8, 'WebKit Lv8 Discovery preflight Story');
    const story = await visibleText(page);
    requireStory(story, 8);

    await activateButton(page, '继续', { prefix: true });
    await sleep(350);
    await dismissVocabularyDialogIfPresent(page);
    await waitStage(page, 2);
    await assertTargetLevel(page, 8, 'WebKit Lv8 Discovery preflight Vocabulary');

    await activateButton(page, '继续', { prefix: true });
    await waitStage(page, 3);
    await assertTargetLevel(page, 8, 'WebKit Lv8 Discovery preflight entry');
    const corpus = await collectDiscoveryStageSemantics(page, 8);
    await assertTargetLevel(page, 8, 'WebKit Lv8 Discovery preflight final');
    requireDiscoveryAnchors(corpus, 8);
    console.log('WEBKIT Lv8 DISCOVERY SEEK PREFLIGHT = PASS | TARGET LEVEL=Lv8 THROUGHOUT | ANCHORS=海运提单,1990');
  } catch (error) {
    const snapshot = await records(page).catch(() => []);
    console.error(\`WEBKIT Lv8 DISCOVERY PREFLIGHT SEMANTICS SNAPSHOT = \${JSON.stringify(snapshot.slice(0, 180))}\`);
    throw error;
  } finally {
    await context.close();
    await browser.close();
  }
}

async function runBrowserModePreflight(browserType, browserName) {`
);

replaceOnce(
  'WebKit Lv8 Discovery preflight matrix dispatch',
  `for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(\`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=\${sourceSha} | LEVELS=\${levels.join(',')} | BROWSERS=chromium,webkit\`);`,
  `if (process.argv.includes('--webkit-lv8-discovery-preflight')) {
  await runWebKitLv8DiscoveryPreflight();
  process.exit(0);
}

for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(\`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=\${sourceSha} | LEVELS=\${levels.join(',')} | BROWSERS=chromium,webkit\`);`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`SEEK ACTION SAFETY + MID-STAGE LEVEL GUARD PATCH = PASS | ${target}`);
