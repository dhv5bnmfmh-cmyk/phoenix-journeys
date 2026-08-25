import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: verify_shanghai_action_safety_preflight.mjs <patched-verify-script>');

const source = fs.readFileSync(target, 'utf8');

function functionBody(name) {
  const start = source.indexOf(`async function ${name}(`);
  if (start < 0) throw new Error(`action-safety preflight: function not found: ${name}`);
  const nextAsync = source.indexOf('\nasync function ', start + 1);
  const nextFunction = source.indexOf('\nfunction ', start + 1);
  const candidates = [nextAsync, nextFunction].filter((index) => index > start);
  const end = candidates.length ? Math.min(...candidates) : source.length;
  return source.slice(start, end);
}

function requireContains(label, body, tokens) {
  for (const token of tokens) {
    if (!body.includes(token)) throw new Error(`${label}: required safety token missing: ${token}`);
  }
}

function forbidContains(label, body, tokens) {
  for (const token of tokens) {
    if (body.includes(token)) throw new Error(`${label}: forbidden stale-index action token found: ${token}`);
  }
}

const seek = functionBody('seekNarrationProgress');
forbidContains('seekNarrationProgress', seek, [
  `.nth(rail.index)`,
  `page.mouse.click(`,
  `page.touchscreen.tap(`,
]);
requireContains('seekNarrationProgress', seek, [
  `narrationExplicitlyCompleted(page)`,
  `const maxRemountAttempts = 5`,
  `for (let attempt = 1; attempt <= maxRemountAttempts; attempt += 1)`,
  `const rs = await records(page)`,
  `bindStableSemanticRecord(page, rail`,
  `expectedNeedle: '朗读进度，可拖动跳转'`,
  `handle.boundingBox()`,
  `readBoundSemanticHandle(handle)`,
  `isSemanticRemountRace(error)`,
  `handle.click({ position`,
  `handle.tap({ position`,
]);
const recordsPos = seek.indexOf(`const rs = await records(page)`);
const loopPos = seek.indexOf(`for (let attempt = 1; attempt <= maxRemountAttempts; attempt += 1)`);
const bindPosInSeek = seek.indexOf(`bindStableSemanticRecord(page, rail`);
if (!(loopPos >= 0 && recordsPos > loopPos && bindPosInSeek > recordsPos)) {
  throw new Error('seekNarrationProgress: every remount attempt must start with a fresh semantic snapshot before live binding');
}
if (!source.includes(`function isSemanticRemountRace(error)`)) {
  throw new Error('semantic-remount classifier missing');
}

const terminal = functionBody('narrationExplicitlyCompleted');
requireContains('narrationExplicitlyCompleted', terminal, [
  `visibleText(page)`,
  `discoveryNarrationState(text).finished`,
]);

const modal = functionBody('dismissKnownTransientModal');
forbidContains('dismissKnownTransientModal', modal, [`.nth(closeRecord.index)`]);
requireContains('dismissKnownTransientModal', modal, [`activateStableSemanticRecord(page, closeRecord`]);

const grammar = functionBody('ensureGrammarSegment');
forbidContains('ensureGrammarSegment', grammar, [`.nth(segment.index)`]);
requireContains('ensureGrammarSegment', grammar, [`activateStableSemanticRecord(page, segment`]);

const challenge = functionBody('chooseChallenge');
forbidContains('chooseChallenge', challenge, [`.nth(hit.index)`]);
requireContains('chooseChallenge', challenge, [`activateStableSemanticRecord(page, hit`]);

const binder = functionBody('bindStableSemanticRecord');
requireContains('bindStableSemanticRecord', binder, [
  `.nth(record.index)`,
  `.elementHandle()`,
  `readBoundSemanticHandle(handle)`,
  `verifyBoundSemanticIdentity(live, identity)`,
]);
const nthPos = binder.indexOf(`.nth(record.index)`);
const bindPos = binder.indexOf(`.elementHandle()`);
const recheckPos = binder.indexOf(`verifyBoundSemanticIdentity(live, identity)`);
if (!(nthPos >= 0 && bindPos > nthPos && recheckPos > bindPos)) {
  throw new Error('bindStableSemanticRecord: observation index must be followed by live binding then identity recheck');
}

for (const forbidden of [
  `page.locator('flt-semantics').nth(rail.index)`,
  `page.locator('flt-semantics').nth(segment.index)`,
  `page.locator('flt-semantics').nth(hit.index)`,
  `page.locator('flt-semantics').nth(closeRecord.index)`,
]) {
  if (source.includes(forbidden)) throw new Error(`active Shanghai action path still contains stale snapshot-index activation: ${forbidden}`);
}

const terminalAuthority = functionBody('isAuthoritativeTerminalDiscoveryCorpus');
requireContains('isAuthoritativeTerminalDiscoveryCorpus', terminalAuthority, [
  `waitStage(page, 3)`,
  `assertTargetLevel(page, level, 'Discovery terminal corpus authority')`,
  `const terminalRecords = await records(page)`,
  `terminalRecords.map((record) => recText(record)).join('\\n')`,
  `const terminalEvidence =`,
  `terminalEvidence.includes('3/6 Discovery')`,
  `terminalEvidence.includes(\`Phoenix 中文难度 \${level} 级\`)`,
  `terminalEvidence.includes(\`Discovery，Lv.\${level}\`)`,
  `discoveryNarrationState(terminalEvidence)`,
  `terminalEvidence.includes('朗读完成 · 100%')`,
  `classifyTransientModalRecords(terminalRecords)`,
  `requireDiscoveryAnchors(terminalEvidence, level)`,
]);
forbidContains('isAuthoritativeTerminalDiscoveryCorpus', terminalAuthority, [
  `finalText.includes('3/6 Discovery')`,
  `classifyTransientModalRecords(await records(page))`,
]);

const discovery = functionBody('collectDiscoveryStageSemantics');
requireContains('collectDiscoveryStageSemantics', discovery, [
  `firstState.finished`,
  `NARRATION=ALREADY-COMPLETED`,
  `assertDiscoveryTargetLevel(page, level`,
  `assertTargetLevel(page, level, 'Discovery narration transition')`,
  `seenSegments.size < total`,
  `isAuthoritativeTerminalDiscoveryCorpus(page, level, snapshots, finalText)`,
  `SEGMENT_IDS_OBSERVED=`,
  `TERMINAL_CORPUS=AUTHORITATIVE`,
]);

console.log('SHANGHAI ACTION SAFETY STATIC PREFLIGHT = PASS | semantic index is observation metadata only | detached seek handles use finite fresh snapshot + live rebind | no stale index/handle reuse | seek/modal/grammar/challenge bind + recheck live identity | Discovery seek level guarded | terminal Stage/Level/completion identity comes from fresh semantic labels + text | terminal authority requires exact stage + exact level + explicit completion + complete terminal anchors | segment accounting remains strict off-terminal');
