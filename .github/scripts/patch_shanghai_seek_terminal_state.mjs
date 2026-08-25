import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_seek_terminal_state.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'seek terminal-state race guard',
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
}`,
  `async function narrationExplicitlyCompleted(page) {
  const text = await visibleText(page);
  return discoveryNarrationState(text).finished;
}

async function seekNarrationProgress(page, progress) {
  if (await narrationExplicitlyCompleted(page)) return false;

  const rs = await records(page);
  const rail = rs.find((r) => r.visible && !r.disabled && r.role === 'button' && recText(r).includes('朗读进度，可拖动跳转'));
  if (!rail) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw new Error('Discovery narration seek rail not found while narration is not complete');
  }

  const identity = { expectedRole: 'button', expectedNeedle: '朗读进度，可拖动跳转' };
  let bound;
  try {
    bound = await bindStableSemanticRecord(page, rail, identity);
  } catch (error) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw error;
  }
  const { handle } = bound;
  const box = await handle.boundingBox();
  if (!box || box.width <= 2 || box.height <= 2) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw new Error('Discovery narration seek rail has no actionable geometry while narration is not complete');
  }
  const position = {
    x: Math.max(1, Math.min(box.width - 1, box.width * progress)),
    y: box.height / 2,
  };

  try {
    verifyBoundSemanticIdentity(await readBoundSemanticHandle(handle), identity);
  } catch (error) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw error;
  }

  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await handle.click({ position, timeout: 10000, noWaitAfter: true });
  } else if (mode === interactionModes.touch) {
    await handle.tap({ position, timeout: 10000 });
  } else {
    throw new Error('browser interaction mode was not registered before narration seek');
  }
  await sleep(300);
  return true;
}`
);

replaceOnce(
  'already-completed Discovery entry',
  `  await waitStage(page, 3);
  const firstText = await visibleText(page);
  if (narrationUnavailable(firstText)) {`,
  `  await waitStage(page, 3);
  const firstText = await visibleText(page);
  const firstState = discoveryNarrationState(firstText);
  if (firstState.finished) {
    await assertTargetLevel(page, level, 'Discovery already-completed entry');
    requireDiscoveryAnchors(firstText, level);
    console.log(\`SHANGHAI BUND Lv\${level} DISCOVERY STAGE CORPUS = PASS | NARRATION=ALREADY-COMPLETED | FULL-TEXT SEMANTICS\`);
    return firstText;
  }
  if (narrationUnavailable(firstText)) {`
);

replaceOnce(
  'completed while discovering narration state',
  `    if (state.finished) {
      total = 1;
      break;
    }`,
  `    if (state.finished) {
      await assertTargetLevel(page, level, 'Discovery narration completed before seek');
      const corpus = discoveryStageCorpus(snapshots);
      requireDiscoveryAnchors(corpus, level);
      console.log(\`SHANGHAI BUND Lv\${level} DISCOVERY STAGE CORPUS = PASS | NARRATION=COMPLETED-BEFORE-SEEK | FULL-TEXT SEMANTICS\`);
      return corpus;
    }`
);

replaceOnce(
  'terminal fixture coverage',
  `  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement | seek rail reorder cannot target difficulty decrement | Lv8 mid-stage drift rejected');`,
  `  const terminalNarration = discoveryNarrationState('Discovery，Lv.8 · 分段短文 · 2 段 朗读完成 · 100%');
  if (!terminalNarration.finished) throw new Error('explicit 100% narration fixture was not recognized as terminal state');

  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement | seek rail reorder cannot target difficulty decrement | Lv8 mid-stage drift rejected | explicit 100% narration is terminal and does not require seek');`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`SEEK TERMINAL-STATE PATCH = PASS | ${target}`);
