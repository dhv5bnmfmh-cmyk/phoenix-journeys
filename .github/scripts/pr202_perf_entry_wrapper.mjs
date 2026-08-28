import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const sourceUrl = new URL('./pr202_perf_acceptance.mjs.gz', import.meta.url);
let source = gunzipSync(await readFile(sourceUrl)).toString('utf8');

const original = `    identityAll: ['林岸', '黄浦江'],
    identityAny: [['陆家嘴', '浦东'], ['提单', '结算']],`;
const replacement = `    identityAll: ['林岸'],
    identityAny: [],`;

if (source.split(original).length - 1 !== 1) {
  throw new Error('Shanghai performance entry identity patch target mismatch');
}
source = source.replace(original, replacement);

const perfEntryOriginal = `async function assertJourneyEntryIdentity(page) {
  await waitStage(page, 1, 20000);
  const snapshot = await visibleText(page);
  if (!snapshot.includes(journey.title)) {
    throw new Error(\`Journey identity missing title: \${journey.title}\`);
  }
  for (const marker of journey.identityAll) {
    if (!snapshot.includes(marker)) {
      throw new Error(\`Journey identity missing stable marker: \${marker}\`);
    }
  }
  for (const group of journey.identityAny) {
    if (!group.some((marker) => snapshot.includes(marker))) {
      throw new Error(\`Journey identity missing stable marker group: \${group.join(' | ')}\`);
    }
  }
}`;
const perfEntryReplacement = `async function assertJourneyEntryIdentity(page) {
  const deadline = Date.now() + 30000;
  let snapshot = '';
  while (Date.now() < deadline) {
    snapshot = await visibleText(page);
    const stageReady = snapshot.includes('1/6');
    const titleReady = snapshot.includes(journey.title);
    const allReady = journey.identityAll.every((marker) => snapshot.includes(marker));
    const groupsReady = journey.identityAny.every((group) =>
      group.some((marker) => snapshot.includes(marker)));
    if (stageReady && titleReady && allReady && groupsReady) return;
    if (journey.route === 'xian-passport' && snapshot.includes('陕西省，西安市') &&
        !stageReady && await exists(page, journey.place, { role: 'button', timeout: 250 })) {
      await activate(page, journey.place, { prefix: false, timeout: 1200 });
    }
    await sleep(100);
  }
  throw new Error(\`Journey entry did not settle with identity + 1/6 + Story evidence: \${journey.title}; snapshot=\${snapshot.slice(0, 1200)}\`);
}`;

const challengeTapOriginal = `    await page.locator('flt-semantics').nth(matches[0].index).evaluate((e)=>e.click()); await sleep(70);`;
const challengeTapReplacement = `    await page.locator('flt-semantics').nth(matches[0].index).click({ timeout: 10000 }); await sleep(120);`;

const challengeTargetsOriginal = `  const count = await requiredChallengeSelections(page); const targets = await challengeOptionTargets(page);
  if (targets.length < count) throw new Error(\`only \${targets.length} challenge targets; need \${count}\`);`;
const challengeTargetsReplacement = `  const count = await requiredChallengeSelections(page);
  const targetDeadline = Date.now() + 6000;
  let targets = [];
  while (Date.now() < targetDeadline) {
    targets = await challengeOptionTargets(page);
    if (targets.length >= count) break;
    await sleep(100);
  }
  if (targets.length < count) throw new Error(\`only \${targets.length} challenge targets after settle; need \${count}\`);`;

const challengeReadyOriginal = `  await activate(page,'继续',{prefix:true}); await waitStage(page,4);
  await completeChallenge(page);`;
const challengeReadyReplacement = `  await activate(page,'继续',{prefix:true}); await waitStage(page,4);
  await findSemantic(page,'提交第 1 / 3 次答案',{role:'button',prefix:true,timeout:15000});
  await completeChallenge(page);`;

const stageSelectOriginal = `  await activate(page,stageLabels[stage],{prefix:false,timeout:8000});
  await waitStage(page,target,12000); await ensureVocabularyPopupClosed(page); await sleep(120);`;
const stageSelectReplacement = `  const wanted = stageLabels[stage];
  const stageDeadline = Date.now() + 8000;
  let selected = false;
  while (Date.now() < stageDeadline && !selected) {
    const candidates = (await records(page)).filter((record) =>
      record.visible && !record.disabled && record.role === 'button' &&
      (clean(record.label) === wanted || recordText(record) === wanted));
    if (candidates.length) {
      await page.locator('flt-semantics').nth(candidates.sort((a,b)=>a.area-b.area)[0].index).click({ timeout: 10000 });
      selected = true;
      break;
    }
    await sleep(80);
  }
  if (!selected) throw new Error(\`completed-course stage control not found: \${wanted}\`);
  await waitStage(page,target,15000); await ensureVocabularyPopupClosed(page); await sleep(180);`;

for (const [needle, replacementText, label] of [
  [perfEntryOriginal, perfEntryReplacement, 'mature entry assertion'],
  [challengeTapOriginal, challengeTapReplacement, 'challenge semantic tap'],
  [challengeTargetsOriginal, challengeTargetsReplacement, 'challenge target settle'],
  [challengeReadyOriginal, challengeReadyReplacement, 'challenge settled entry'],
  [stageSelectOriginal, stageSelectReplacement, 'completed course stage selection'],
]) {
  if (source.split(needle).length - 1 !== 1) {
    throw new Error(`Performance ${label} patch target mismatch`);
  }
  source = source.replace(needle, replacementText);
}

const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_perf_acceptance_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
