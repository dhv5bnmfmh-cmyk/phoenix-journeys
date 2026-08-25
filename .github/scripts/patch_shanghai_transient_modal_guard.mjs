import fs from 'node:fs';

const target = process.argv[2];
if (!target) {
  throw new Error('usage: patch_shanghai_transient_modal_guard.mjs <verify-script>');
}

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) {
    throw new Error(`${label}: expected exactly one patch target`);
  }
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'transient modal classifier insertion',
  `function narrationUnavailable(text) {
  return text.includes('朗读暂时不可用') || text.includes('当前设备暂时无法朗读');
}

function runStoryAnchorFixturePreflight() {`,
  `function narrationUnavailable(text) {
  return text.includes('朗读暂时不可用') || text.includes('当前设备暂时无法朗读');
}

const knownTransientModalDefinitions = Object.freeze([
  Object.freeze({
    id: 'chinese-voice-selector',
    title: '中文朗读声线',
    markers: Object.freeze(['中文朗读声线', '当前浏览器没有提供可选择的中文声线']),
    closeLabels: Object.freeze(['关闭', 'Dismiss']),
  }),
]);

function semanticRecordText(record) {
  return clean([record?.label, record?.value, record?.description, record?.text].filter(Boolean).join(' '));
}

function classifyTransientModalRecords(recordsToClassify) {
  const dialogs = recordsToClassify.filter((record) => record.visible !== false && record.role === 'Dialog');
  if (!dialogs.length) return { kind: 'none' };

  const classified = dialogs.map((dialog) => {
    const text = semanticRecordText(dialog);
    const definition = knownTransientModalDefinitions.find((candidate) =>
      candidate.markers.every((marker) => text.includes(marker))
    );
    return { dialog, text, definition };
  });

  const unknown = classified.filter((entry) => !entry.definition);
  if (unknown.length) {
    return {
      kind: 'unknown',
      dialogs: unknown.map((entry) => entry.text),
    };
  }

  const ids = new Set(classified.map((entry) => entry.definition.id));
  if (ids.size !== 1) {
    return {
      kind: 'unknown',
      dialogs: classified.map((entry) => entry.text),
    };
  }

  return {
    kind: 'known',
    definition: classified[0].definition,
    dialogText: classified[0].text,
  };
}

function knownTransientModalCloseRecord(recordsToClassify, classification) {
  if (classification.kind !== 'known') return null;
  for (const label of classification.definition.closeLabels) {
    const exact = recordsToClassify.find((record) =>
      record.visible !== false &&
      !record.disabled &&
      record.role === 'button' &&
      semanticRecordText(record) === label
    );
    if (exact) return exact;
  }
  return null;
}

function runTransientModalFixturePreflight() {
  const knownModal = [
    {
      index: 0,
      role: 'Dialog',
      text: 'Dismiss 中文朗读声线 关闭 简体普通话 台湾国语 当前浏览器没有提供可选择的中文声线。 Phoenix 仍会自动使用最佳可用声线。',
      visible: true,
      disabled: false,
    },
    { index: 1, role: 'button', text: '关闭', visible: true, disabled: false },
    { index: 2, role: 'button', text: 'Dismiss', visible: true, disabled: false },
  ];
  const known = classifyTransientModalRecords(knownModal);
  if (known.kind !== 'known' || known.definition.id !== 'chinese-voice-selector') {
    throw new Error('Known voice modal fixture was not recognized');
  }
  const closeRecord = knownTransientModalCloseRecord(knownModal, known);
  if (!closeRecord || !['关闭', 'Dismiss'].includes(semanticRecordText(closeRecord))) {
    throw new Error('Known voice modal fixture did not resolve a real close control');
  }

  const postDismissStage = [
    { index: 0, role: null, text: '3/6 Discovery', visible: true, disabled: false },
  ];
  if (classifyTransientModalRecords(postDismissStage).kind !== 'none') {
    throw new Error('Post-dismiss fixture unexpectedly retained a modal');
  }
  if (!postDismissStage.some((record) => semanticRecordText(record).includes('3/6'))) {
    throw new Error('Post-dismiss fixture did not continue the original Stage assertion');
  }

  const unknownModal = [
    { index: 0, role: 'Dialog', text: '未知系统确认 对学习记录执行不可逆操作', visible: true, disabled: false },
    { index: 1, role: 'button', text: '关闭', visible: true, disabled: false },
  ];
  const unknown = classifyTransientModalRecords(unknownModal);
  if (unknown.kind !== 'unknown') {
    throw new Error('Unknown dialog fixture was not rejected');
  }
  if (knownTransientModalCloseRecord(unknownModal, unknown) !== null) {
    throw new Error('Unknown dialog fixture unexpectedly produced an auto-dismiss target');
  }

  console.log('TRANSIENT MODAL FIXTURE PREFLIGHT = PASS | known voice modal recognized -> real close control -> Stage semantics re-read | unknown Dialog rejected');
}

function runStoryAnchorFixturePreflight() {`
);

replaceOnce(
  'transient modal fixture CLI insertion',
  `if (process.argv.includes('--discovery-corpus-preflight')) {
  runDiscoveryCorpusFixturePreflight();
  process.exit(0);
}

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);`,
  `if (process.argv.includes('--discovery-corpus-preflight')) {
  runDiscoveryCorpusFixturePreflight();
  process.exit(0);
}

if (process.argv.includes('--transient-modal-preflight')) {
  runTransientModalFixturePreflight();
  process.exit(0);
}

const playwright = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);`
);

replaceOnce(
  'runtime transient modal guard insertion',
  `async function activateButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(\`button disabled: \${needle}\`);
  await activateSemantic(page, node);
}

async function dismissVocabularyDialogIfPresent(page) {
  if (!(await exists(page, 'Dismiss', { role: 'button', timeout: 1200 }))) return false;
  await activateButton(page, 'Dismiss');
  await sleep(250);
  return true;
}`,
  `async function activateButton(page, needle, { prefix = false, timeout = 15000 } = {}) {
  const node = await findSemantic(page, needle, { role: 'button', prefix, timeout });
  if (await node.getAttribute('aria-disabled') === 'true') throw new Error(\`button disabled: \${needle}\`);
  await activateSemantic(page, node);
}

async function dismissKnownTransientModal(page) {
  const currentRecords = await records(page);
  const classification = classifyTransientModalRecords(currentRecords);
  if (classification.kind === 'none') return false;
  if (classification.kind === 'unknown') {
    throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${classification.dialogs.join(' || ')}\`);
  }

  const closeRecord = knownTransientModalCloseRecord(currentRecords, classification);
  if (!closeRecord) {
    throw new Error(\`Known transient modal \${classification.definition.id} has no allowed close control\`);
  }

  console.log(
    \`KNOWN TRANSIENT MODAL = \${classification.definition.id} | TITLE=\${classification.definition.title} | ACTION=\${semanticRecordText(closeRecord)}\`
  );
  await activateSemantic(page, page.locator('flt-semantics').nth(closeRecord.index));

  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    await sleep(100);
    const after = classifyTransientModalRecords(await records(page));
    if (after.kind === 'none') {
      console.log(\`KNOWN TRANSIENT MODAL DISMISSED = \${classification.definition.id} | RE-READ SEMANTICS\`);
      return true;
    }
    if (after.kind === 'unknown') {
      throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${after.dialogs.join(' || ')}\`);
    }
  }
  throw new Error(\`Known transient modal did not dismiss: \${classification.definition.id}\`);
}

async function dismissVocabularyDialogIfPresent(page) {
  const classification = classifyTransientModalRecords(await records(page));
  if (classification.kind === 'none') return false;
  return dismissKnownTransientModal(page);
}`
);

replaceOnce(
  'Stage wait transient modal recovery',
  `async function waitStage(page, n) {
  await findSemantic(page, \`\${n}/6\`, { prefix: true, timeout: 20000 });
}`,
  `async function waitStage(page, n) {
  const needle = \`\${n}/6\`;
  const deadline = Date.now() + 20000;
  while (Date.now() < deadline) {
    try {
      await findSemantic(page, needle, { prefix: true, timeout: 600 });
      return;
    } catch (_) {
      // A legitimate transient modal can temporarily replace mounted Stage semantics.
    }
    if (await dismissKnownTransientModal(page)) continue;
    await sleep(100);
  }
  throw new Error(\`semantic state not found: \${needle}\`);
}`
);

replaceOnce(
  'separate browser-mode preflight from full matrix',
  `await runBrowserModePreflight(playwright.chromium, 'chromium');
await runBrowserModePreflight(playwright.webkit, 'webkit');
console.log('BROWSER MODE PREFLIGHT = PASS | desktop-click + mobile-touch | Shanghai SPA open');

for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(\`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=\${sourceSha} | LEVELS=\${levels.join(',')} | BROWSERS=chromium,webkit\`);`,
  `if (process.argv.includes('--browser-mode-preflight')) {
  await runBrowserModePreflight(playwright.chromium, 'chromium');
  await runBrowserModePreflight(playwright.webkit, 'webkit');
  console.log('BROWSER MODE PREFLIGHT = PASS | desktop-click + mobile-touch | Shanghai SPA open');
  process.exit(0);
}

for (const [browserName, browserType] of [['chromium', playwright.chromium], ['webkit', playwright.webkit]]) {
  for (const level of levels) await runLevel(browserType, browserName, level);
}
console.log(\`SHANGHAI BUND EXACT PREVIEW E2E = PASS | SHA=\${sourceSha} | LEVELS=\${levels.join(',')} | BROWSERS=chromium,webkit\`);`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`TRANSIENT MODAL HARNESS PATCH = PASS | ${target}`);
