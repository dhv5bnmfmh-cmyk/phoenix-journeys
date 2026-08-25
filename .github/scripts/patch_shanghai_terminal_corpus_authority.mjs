import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_terminal_corpus_authority.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'terminal Discovery authority helper insertion',
  `async function collectDiscoveryStageSemantics(page, level) {`,
  `function terminalDiscoveryAuthorityFixture({ expectedLevel, actualLevel, stageLabel, completed, terminalText }) {
  if (!/^3\\/6(?:\\s|$)/.test(stageLabel) || actualLevel !== expectedLevel || !completed) return false;
  if (!terminalText.includes('朗读完成 · 100%')) return false;
  if (!terminalText.includes(\`Discovery，Lv.\${expectedLevel}\`)) return false;
  try {
    requireDiscoveryAnchors(terminalText, expectedLevel);
  } catch (_) {
    return false;
  }
  return true;
}

function terminalDiscoveryStageRecord(recordsSnapshot) {
  return recordsSnapshot.find((record) =>
    record.visible &&
    record.role === 'progressbar' &&
    /^3\\/6(?:\\s|$)/.test(recText(record).trim())
  ) || null;
}

async function isAuthoritativeTerminalDiscoveryCorpus(page, level, snapshots, finalText) {
  await waitStage(page, 3);
  await assertTargetLevel(page, level, 'Discovery terminal corpus authority');

  // Stage identity is structural and locale-independent: the exact third-stage
  // progressbar is 3/6 even when its surface label is localized (for example 发现).
  const terminalRecords = await records(page);
  const terminalStage = terminalDiscoveryStageRecord(terminalRecords);
  if (!terminalStage) {
    throw new Error(\`Lv\${level} terminal Discovery corpus lost structural Stage 3/6 progressbar identity\`);
  }
  const terminalSemantics = terminalRecords.map((record) => recText(record)).join('\\n');
  const terminalEvidence = \`\${finalText}\\n\${terminalSemantics}\`;

  if (!terminalEvidence.includes(\`Phoenix 中文难度 \${level} 级\`)) {
    throw new Error(\`LEVEL DRIFT DURING DISCOVERY TERMINAL AUTHORITY | expected Lv\${level} | terminal selector identity missing\`);
  }
  if (!terminalEvidence.includes(\`Discovery，Lv.\${level}\`)) {
    throw new Error(\`Lv\${level} terminal Discovery corpus does not declare the expected Discovery level\`);
  }

  const state = discoveryNarrationState(terminalEvidence);
  if (!state.finished || !terminalEvidence.includes('朗读完成 · 100%')) {
    return { authoritative: false, reason: 'not-explicit-terminal' };
  }

  const modal = classifyTransientModalRecords(terminalRecords);
  if (modal.kind !== 'none') {
    throw new Error(\`Lv\${level} terminal Discovery corpus has unresolved modal state: \${modal.kind}\`);
  }

  for (const fatal of ['Unhandled Exception', 'A RenderFlex overflowed', 'Bad state:']) {
    if (terminalEvidence.includes(fatal)) {
      throw new Error(\`Lv\${level} terminal Discovery corpus contains fatal runtime semantics: \${fatal}\`);
    }
  }

  // Required content anchors must be present in the current terminal runtime
  // semantic evidence, not borrowed from a stale earlier level or Stage.
  requireDiscoveryAnchors(terminalEvidence, level);
  const corpus = discoveryStageCorpus([...snapshots, finalText, terminalSemantics]);
  requireDiscoveryAnchors(corpus, level);
  return { authoritative: true, corpus };
}

async function collectDiscoveryStageSemantics(page, level) {`
);

replaceOnce(
  'terminal Discovery incomplete-segment accounting',
  `  if (!finalText.includes('朗读完成 · 100%')) {
    throw new Error(\`Lv\${level} Discovery narration did not reach stable completed semantics\`);
  }
  if (seenSegments.size < total) {
    throw new Error(\`Lv\${level} Discovery traversal saw \${seenSegments.size}/\${total} narration segments\`);
  }

  const corpus = discoveryStageCorpus([...snapshots, finalText]);
  requireDiscoveryAnchors(corpus, level);
  console.log(\`SHANGHAI BUND Lv\${level} DISCOVERY STAGE CORPUS = PASS | SEGMENTS=\${total} | SEEN=\${[...seenSegments].sort((a, b) => a - b).join(',')}\`);`,
  `  if (!finalText.includes('朗读完成 · 100%')) {
    throw new Error(\`Lv\${level} Discovery narration did not reach stable completed semantics\`);
  }

  if (seenSegments.size < total) {
    const terminal = await isAuthoritativeTerminalDiscoveryCorpus(page, level, snapshots, finalText);
    if (!terminal.authoritative) {
      throw new Error(\`Lv\${level} Discovery traversal saw \${seenSegments.size}/\${total} narration segments without authoritative terminal corpus\`);
    }
    console.log(
      \`SHANGHAI BUND Lv\${level} DISCOVERY STAGE CORPUS = PASS | SEGMENT_IDS_OBSERVED=\${seenSegments.size}/\${total} | TERMINAL_CORPUS=AUTHORITATIVE | ANCHORS=PASS | LEVEL=Lv\${level} | STAGE=3/6 | NARRATION=100%\`
    );
    return terminal.corpus;
  }

  const corpus = discoveryStageCorpus([...snapshots, finalText]);
  requireDiscoveryAnchors(corpus, level);
  console.log(\`SHANGHAI BUND Lv\${level} DISCOVERY STAGE CORPUS = PASS | SEGMENTS=\${total} | SEEN=\${[...seenSegments].sort((a, b) => a - b).join(',')}\`);`
);

replaceOnce(
  'terminal Discovery authority fixtures',
  `  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement | seek rail reorder cannot target difficulty decrement | Lv8 mid-stage drift rejected | explicit 100% narration is terminal and does not require seek');`,
  `  const terminalPositive = terminalDiscoveryAuthorityFixture({
    expectedLevel: 8,
    actualLevel: 8,
    stageLabel: '3/6\\n发现\\n下一步 挑战 50',
    completed: true,
    terminalText: 'Phoenix 中文难度 8 级 Discovery，Lv.8 · 分段短文 · 2 段 朗读完成 · 100% 海运提单 1990',
  });
  if (!terminalPositive) throw new Error('localized Stage 3/6 terminal authoritative positive fixture rejected complete Lv8 corpus');

  const terminalWrongStage = terminalDiscoveryAuthorityFixture({
    expectedLevel: 8,
    actualLevel: 8,
    stageLabel: '2/6\\n词汇\\n下一步 发现 33',
    completed: true,
    terminalText: 'Phoenix 中文难度 8 级 Discovery，Lv.8 · 分段短文 · 2 段 朗读完成 · 100% 海运提单 1990',
  });
  if (terminalWrongStage) throw new Error('wrong-stage 2/6 fixture unexpectedly gained terminal Discovery authority');

  const terminalMissingAnchor = terminalDiscoveryAuthorityFixture({
    expectedLevel: 8,
    actualLevel: 8,
    stageLabel: '3/6\\n发现',
    completed: true,
    terminalText: 'Phoenix 中文难度 8 级 Discovery，Lv.8 · 分段短文 · 2 段 朗读完成 · 100% 海运提单',
  });
  if (terminalMissingAnchor) throw new Error('terminal missing-anchor negative fixture unexpectedly passed without 1990');

  const nonTerminalIncomplete = terminalDiscoveryAuthorityFixture({
    expectedLevel: 8,
    actualLevel: 8,
    stageLabel: '3/6\\n发现',
    completed: false,
    terminalText: 'Phoenix 中文难度 8 级 Discovery，Lv.8 · 分段短文 · 2 段 海运提单 1990',
  });
  if (nonTerminalIncomplete) throw new Error('non-terminal incomplete traversal fixture unexpectedly gained terminal authority');

  const terminalWrongLevel = terminalDiscoveryAuthorityFixture({
    expectedLevel: 8,
    actualLevel: 7,
    stageLabel: '3/6\\n发现',
    completed: true,
    terminalText: 'Phoenix 中文难度 7 级 Discovery，Lv.7 · 分段短文 · 2 段 朗读完成 · 100% 海运提单 1990',
  });
  if (terminalWrongLevel) throw new Error('terminal level-drift negative fixture unexpectedly passed');

  console.log('LEVEL + STABLE ACTIVATION FIXTURE PREFLIGHT = PASS | localized 3/6 发现 structural Stage PASS | wrong 2/6 Stage FAIL | transient level rejected | stable target required | semantic index reorder demonstrates fixed-handle requirement | seek rail reorder cannot target difficulty decrement | Lv8 mid-stage drift rejected | terminal 1/2 + complete corpus PASS | terminal missing anchor FAIL | non-terminal 1/2 FAIL | terminal wrong level FAIL');`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`TERMINAL DISCOVERY CORPUS AUTHORITY PATCH = PASS | ${target}`);
