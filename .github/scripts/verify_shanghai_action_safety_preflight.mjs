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
  `bindStableSemanticRecord(page, rail`,
  `expectedNeedle: '朗读进度，可拖动跳转'`,
  `handle.boundingBox()`,
  `readBoundSemanticHandle(handle)`,
  `handle.click({ position`,
  `handle.tap({ position`,
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

const discovery = functionBody('collectDiscoveryStageSemantics');
requireContains('collectDiscoveryStageSemantics', discovery, [
  `assertDiscoveryTargetLevel(page, level`,
  `assertTargetLevel(page, level, 'Discovery narration transition')`,
]);

console.log('SHANGHAI ACTION SAFETY STATIC PREFLIGHT = PASS | semantic index is observation metadata only | seek/modal/grammar/challenge bind + recheck live identity | Discovery seek level guarded');
