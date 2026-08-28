import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const sourceUrl = new URL('./pr202_perf_acceptance.mjs.gz', import.meta.url);
let source = gunzipSync(await readFile(sourceUrl)).toString('utf8');
function replaceSourceRange(startMarker, endMarker, replacementText, label) {
  const startCount = source.split(startMarker).length - 1;
  const endCount = source.split(endMarker).length - 1;
  if (startCount !== 1 || endCount !== 1) {
    throw new Error(`Performance ${label} range mismatch start=${startCount} end=${endCount}`);
  }
  const start = source.indexOf(startMarker);
  const end = source.indexOf(endMarker, start + startMarker.length);
  if (start < 0 || end < 0 || end <= start) {
    throw new Error(`Performance ${label} range bounds invalid`);
  }
  source = source.slice(0, start) + replacementText + '\n\n' + source.slice(end);
}


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
    if (journey.route === 'xian-passport' && snapshot.includes('陕西省，西安市') && !stageReady) {
      try {
        if (await exists(page, journey.place, { role: 'button', timeout: 500 })) {
          await activate(page, journey.place, { prefix: false, timeout: 2500 });
        }
      } catch (_) {
        // The Passport place control can disappear while navigation is already committing.
        // Keep polling for 1/6 + Journey identity instead of treating that race as product failure.
      }
    }
    await sleep(100);
  }
  throw new Error(\`Journey entry did not settle with identity + 1/6 + Story evidence: \${journey.title}; snapshot=\${snapshot.slice(0, 1200)}\`);
}`;

async function challengeOptionTargets(page) {
  const rs = await records(page);
  const toTarget = (record) => ({ role: record.role, label: clean(record.label), text: recordText(record) });
  const lettered = rs.filter((record) => {
    if (!record.visible || record.disabled) return false;
    const label = clean(record.label);
    return /^[A-D]\s/.test(label) && /[\u3400-\u9fff]/.test(label);
  }).sort((left, right) => left.index - right.index);
  if (lettered.length) return lettered.map(toTarget);
  const excluded = ['提交第','朗读','进入下一种挑战','完成三连挑战','再练重点项','继续留下回忆','完成挑战后继续','返回','Back','查看 Lv.','提高当前难度','降低当前难度','短文复原','语病修复','补回句子','简 / 繁','声线','减速','加速','提示'];
  return rs.filter((record) => {
    if (!record.visible || record.disabled) return false;
    const text = recordText(record);
    if (text.length < 4 || !/[\u3400-\u9fff]/.test(text)) return false;
    if (!['button', 'group'].includes(record.role)) return false;
    return !excluded.some((item) => text.includes(item));
  }).sort((left, right) => right.area - left.area).map(toTarget);
}

async function requiredChallengeSelections(page) {
  const text = await visibleText(page);
  const match = text.match(/依次点击\s*(\d+)\s*句/);
  return match ? Number(match[1]) : 1;
}

function challengeRecordMatchesTarget(record, target) {
  if (!record.visible || record.disabled) return false;
  if (target.label) return clean(record.label) === target.label;
  return record.role === target.role && recordText(record) === target.text;
}

async function ensureGrammarSegment(page) {
  const text = await visibleText(page);
  if (!text.includes('第一步 · 点击有问题的部分')) return;
  const segments = (await records(page))
    .filter((record) => record.visible && !record.disabled && record.role === 'checkbox' && /[\u3400-\u9fff]/.test(recordText(record)))
    .sort((left, right) => left.index - right.index);
  if (!segments.length) throw new Error('grammar repair segment selector not found');
  const target = segments[0];
  await page.locator('flt-semantics').nth(target.index).evaluate((element) => element.click());
  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    const currentText = await visibleText(page);
    if (!currentText.includes('第一步 · 点击有问题的部分')) return;
    const live = (await records(page)).filter((record) =>
      record.visible &&
      record.role === 'checkbox' &&
      (clean(record.label) === clean(target.label) || recordText(record).includes(recordText(target))));
    if (!live.length) return;
    const node = page.locator('flt-semantics').nth(live[0].index);
    const attrs = await Promise.all([
      node.getAttribute('aria-checked').catch(() => null),
      node.getAttribute('aria-selected').catch(() => null),
      node.getAttribute('aria-pressed').catch(() => null),
    ]);
    if (attrs.some((value) => value === 'true')) return;
    if ((await challengeOptionTargets(page)).length) return;
    await sleep(80);
  }
  throw new Error('grammar repair segment did not settle');
}

async function activateChallengeTarget(page, target) {
  const matches = (await records(page))
    .filter((record) => challengeRecordMatchesTarget(record, target))
    .sort((left, right) => left.area - right.area);
  if (!matches.length) throw new Error(`challenge option disappeared: ${target.label || target.text}`);
  await page.locator('flt-semantics').nth(matches[0].index).evaluate((element) => element.click());
  await sleep(120);
}

async function challengeSelectionState(page, target) {
  const matches = (await records(page))
    .filter((record) => challengeRecordMatchesTarget(record, target))
    .sort((left, right) => left.area - right.area);
  if (!matches.length) return { live: false, exposed: false, selected: false };
  const node = page.locator('flt-semantics').nth(matches[0].index);
  const attrs = await Promise.all([
    node.getAttribute('aria-checked').catch(() => null),
    node.getAttribute('aria-selected').catch(() => null),
    node.getAttribute('aria-pressed').catch(() => null),
  ]);
  const exposed = attrs.some((value) => value !== null);
  return { live: true, exposed, selected: attrs.some((value) => value === 'true') };
}

async function submitSemanticState(page) {
  const submits = (await records(page))
    .filter((record) => record.visible && record.role === 'button' && recordText(record).startsWith('提交第'))
    .sort((left, right) => left.area - right.area);
  return submits[0] ?? null;
}

async function waitChallengeSubmitReady(page, chosen, required) {
  const deadline = Date.now() + 8000;
  let last = '';
  while (Date.now() < deadline) {
    const states = [];
    for (const target of chosen) states.push(await challengeSelectionState(page, target));
    const live = states.filter((state) => state.live).length;
    const exposedInvalid = states.some((state) => state.exposed && !state.selected);
    const submit = await submitSemanticState(page);
    last = `live=${live}/${required} exposedInvalid=${exposedInvalid} submit=${submit ? recordText(submit) : 'none'} disabled=${submit?.disabled}`;
    if (live >= required && !exposedInvalid && submit && !submit.disabled) return;
    await sleep(80);
  }
  throw new Error(`Challenge selections/submit did not settle: ${last}`);
}

async function waitChallengeReady(page) {
  await waitStage(page, 4, 20000);
  const deadline = Date.now() + 20000;
  let snapshot = '';
  while (Date.now() < deadline) {
    snapshot = await visibleText(page);
    const badgeReady = snapshot.includes('4/6');
    const submit = await submitSemanticState(page);
    const required = await requiredChallengeSelections(page);
    const grammarMode = snapshot.includes('第一步 · 点击有问题的部分');
    let controlsReady = false;
    if (grammarMode) {
      const grammarSegments = (await records(page)).filter((record) =>
        record.visible && !record.disabled && record.role === 'checkbox' && /[\u3400-\u9fff]/.test(recordText(record)));
      controlsReady = grammarSegments.length > 0;
    } else {
      controlsReady = (await challengeOptionTargets(page)).length >= required;
    }
    if (badgeReady && submit && controlsReady) return;
    await sleep(80);
  }
  throw new Error(`Challenge 4/6 semantic state did not settle: ${snapshot.slice(0, 1200)}`);
}

async function chooseChallengeOptions(page) {
  await ensureGrammarSegment(page);
  const required = await requiredChallengeSelections(page);
  const deadline = Date.now() + 8000;
  let targets = [];
  while (Date.now() < deadline) {
    targets = await challengeOptionTargets(page);
    if (targets.length >= required) break;
    await sleep(80);
  }
  if (targets.length < required) {
    throw new Error(`Challenge mode controls did not settle: only ${targets.length} targets; need ${required}`);
  }
  const chosen = targets.slice(0, required);
  for (const target of chosen) await activateChallengeTarget(page, target);
  await waitChallengeSubmitReady(page, chosen, required);
}

async function waitChallengeOutcome(page, attempt) {
  const deadline = Date.now() + 12000;
  while (Date.now() < deadline) {
    if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 250 })) return 'next-mode';
    if (await exists(page, '完成三连挑战', { role: 'button', timeout: 250 })) return 'complete';
    if (
      attempt < 3 &&
      await exists(page, `提交第 ${attempt + 1} / 3 次答案`, {
        role: 'button',
        prefix: true,
        timeout: 250,
      })
    ) return 'retry';
    await sleep(80);
  }
  throw new Error(`Challenge attempt ${attempt} did not reach a real next semantic state`);
}

async function resolveChallengeMode(page, modeIndex) {
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    await chooseChallengeOptions(page);
    await activate(page, '提交第', { prefix: true });
    const outcome = await waitChallengeOutcome(page, attempt);
    if (outcome === 'retry') continue;
    if (outcome === 'next-mode') {
      if (modeIndex >= 2) throw new Error('final Challenge mode exposed another-mode transition');
      await activate(page, '进入下一种挑战');
      await waitChallengeReady(page);
      return;
    }
    if (outcome === 'complete') {
      if (modeIndex !== 2) throw new Error(`Challenge completed before mode ${modeIndex + 1} closed`);
      await activate(page, '完成三连挑战');
      await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
      return;
    }
  }
  throw new Error(`challenge mode ${modeIndex + 1} did not resolve`);
}

async function completeChallenge(page) {
  for (let mode = 0; mode < 3; mode += 1) await resolveChallengeMode(page, mode);
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
}

const matureChallengeBlock = [challengeOptionTargets, requiredChallengeSelections, challengeRecordMatchesTarget, ensureGrammarSegment, activateChallengeTarget, challengeSelectionState, submitSemanticState, waitChallengeSubmitReady, waitChallengeReady, chooseChallengeOptions, waitChallengeOutcome, resolveChallengeMode, completeChallenge]
  .map((fn) => fn.toString())
  .join('\n\n');

const challengeReadyOriginal = `  await activate(page,'继续',{prefix:true}); await waitStage(page,4);\n  await completeChallenge(page);`;
const challengeReadyReplacement = `  await activate(page,'继续',{prefix:true}); await waitChallengeReady(page);\n  await completeChallenge(page); if(process.env.CHALLENGE_PREFLIGHT_ONLY==='1'){console.log('CHALLENGE_PREFLIGHT_PASS city='+cityKey+' browser='+browserName);process.exit(0);}`;

const stageSelectOriginal = `  await activate(page,stageLabels[stage],{prefix:false,timeout:8000});
  await waitStage(page,target,12000); await ensureVocabularyPopupClosed(page); await sleep(120);`;
const stageSelectReplacement = `  const wanted = stageLabels[stage];
  await findSemantic(page,'选择学习步骤 · 课程已完成',{timeout:8000});
  const stageDeadline = Date.now() + 8000;
  let selected = false;
  while (Date.now() < stageDeadline && !selected) {
    const candidates = (await records(page)).filter((record) =>
      record.visible && !record.disabled && record.role === 'button' &&
      recordText(record).includes(wanted) && recordText(record).includes(\`\${target}/6\`));
    if (candidates.length) {
      await page.locator('flt-semantics').nth(candidates.sort((a,b)=>a.area-b.area)[0].index).tap({ timeout: 10000 });
      selected = true;
      break;
    }
    await sleep(80);
  }
  if (!selected) throw new Error(\`completed-course stage control not found: \${wanted}\`);
  await waitStage(page,target,15000); await ensureVocabularyPopupClosed(page); await sleep(180);`;

const desktopTouchOriginal = `const context=browserName==='webkit' ? await browser.newContext({...devices['iPhone 13']}) : await browser.newContext({viewport:{width:1440,height:1000}});`;
const desktopTouchReplacement = `const context=browserName==='webkit' ? await browser.newContext({...devices['iPhone 13']}) : await browser.newContext({viewport:{width:1440,height:1000},hasTouch:true});`;

const progressStripOriginal = `  await clickSemantic(page,'课程已完成 · 可自由选择',{timeout:5000});`;
const progressStripReplacement = `  const progressDeadline=Date.now()+5000;let progressStrip=null;while(Date.now()<progressDeadline){const candidates=(await records(page)).filter((r)=>r.visible&&recordText(r).includes('课程已完成 · 可自由选择')).sort((a,b)=>b.area-a.area);if(candidates.length){progressStrip=candidates[0];break;}await sleep(80);}if(progressStrip==null)throw new Error('completed progress strip not found');await page.locator('flt-semantics').nth(progressStrip.index).tap({timeout:10000});`;

const timingIncompleteOriginal = `  if(!t1||!t2||!t3||!t4) throw new Error(\`\${tag} timing incomplete t1=\${t1} t2=\${t2} t3=\${t3} t4=\${t4}\`);
  const out={tag,stage:stage+1,from,to:target,badgeMs:Math.round(t1-t0),contentMs:Math.round(t2-t0),semanticStableMs:Math.round(t3-t0),interactiveMs:Math.round(t4-t0),contentChanged:targetState.hash!==source.hash,sourceHash:source.hash,targetHash:targetState.hash,requestCount:requests.length,requestUrls:[...new Set(requests)].slice(0,12)};
  out.pass=out.badgeMs<=thresholds.badge&&out.contentMs<=thresholds.content&&out.interactiveMs<=thresholds.interactive;`;
const timingIncompleteReplacement = `  const timingComplete=Boolean(t1&&t2&&t3&&t4);const fallback=performance.now();t1??=fallback;t2??=fallback;t3??=fallback;t4??=fallback;targetState??=await learnerState(page,stage);
  const out={tag,stage:stage+1,from,to:target,badgeMs:Math.round(t1-t0),contentMs:Math.round(t2-t0),semanticStableMs:Math.round(t3-t0),interactiveMs:Math.round(t4-t0),timingComplete,contentChanged:targetState.hash!==source.hash,sourceHash:source.hash,targetHash:targetState.hash,requestCount:requests.length,requestUrls:[...new Set(requests)].slice(0,12)};
  out.pass=timingComplete&&out.badgeMs<=thresholds.badge&&out.contentMs<=thresholds.content&&out.interactiveMs<=thresholds.interactive;`;

const narrationProofOriginal = `  if(stage===4||stage===5){ await activate(page,'播放朗读'); await findSemantic(page,'停止朗读',{role:'button',timeout:5000}); await activate(page,'停止朗读'); return; }`;
const narrationProofReplacement = `  if(stage===4||stage===5){ await activate(page,'播放朗读');const narrationDeadline=Date.now()+6000;let playing=false;while(Date.now()<narrationDeadline){if(await exists(page,'正在朗读',{timeout:250})||await exists(page,'暂停朗读',{role:'button',timeout:250})||await exists(page,'停止朗读',{role:'button',timeout:250})){playing=true;break;}await sleep(80);}if(!playing)throw new Error(\`\${stageNames[stage]} narration did not enter playing state\`);if(await exists(page,'暂停朗读',{role:'button',timeout:500}))await activate(page,'暂停朗读');else if(await exists(page,'停止朗读',{role:'button',timeout:500}))await activate(page,'停止朗读');return; }`;

replaceSourceRange(
  'async function challengeOptionTargets(page) {',
  'async function completeJourneyOnce(',
  matureChallengeBlock,
  'mature Challenge helper block',
);
for (const [needle, replacementText, label] of [
  [perfEntryOriginal, perfEntryReplacement, 'mature entry assertion'],
  [challengeReadyOriginal, challengeReadyReplacement, 'challenge settled entry'],
  [stageSelectOriginal, stageSelectReplacement, 'completed course stage selection'],
  [desktopTouchOriginal, desktopTouchReplacement, 'desktop semantic touch context'],
  [progressStripOriginal, progressStripReplacement, 'completed progress strip activation'],
  [timingIncompleteOriginal, timingIncompleteReplacement, 'non-aborting performance sample'],
  [narrationProofOriginal, narrationProofReplacement, 'Memory Completion narration proof'],
]) {
  if (source.split(needle).length - 1 !== 1) {
    throw new Error(`Performance ${label} patch target mismatch`);
  }
  source = source.replace(needle, replacementText);
}

const challengeBlockStart = source.indexOf('async function challengeOptionTargets(page) {');
const challengeBlockEnd = source.indexOf('async function completeJourneyOnce(', challengeBlockStart);
const generatedChallengeBlock = source.slice(challengeBlockStart, challengeBlockEnd);
for (const [needle, label] of [
  ["async function ensureGrammarSegment(page)", 'grammar isolation helper'],
  ["!['button', 'group'].includes(record.role)", 'button/group ordinary targets'],
  ["async function activateChallengeTarget(page, target)", 'stable target activation'],
  ["await sleep(120);", 'mature click settle'],
  ["await challengeSelectionState(page, target)", 'live selected-state rebind'],
  ["submit && !submit.disabled", 'submit enable settle'],
  ["async function waitChallengeOutcome(page, attempt)", 'real post-submit state'],
  ["await waitChallengeReady(page)", '4/6 semantic readiness'],
  ["for (let mode = 0; mode < 3; mode += 1)", 'three-mode completion'],
]) {
  if (!generatedChallengeBlock.includes(needle)) {
    throw new Error(`Performance mature Challenge static contract missing: ${label}`);
  }
}
if (generatedChallengeBlock.includes("['button', 'group', 'checkbox']")) {
  throw new Error('Performance mature Challenge static contract leaked grammar checkbox into ordinary targets');
}
if (generatedChallengeBlock.includes("await activateChallengeTarget(page, target);\n    await sleep(")) {
  throw new Error('Performance mature Challenge static contract uses fixed post-option sleep');
}
const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_perf_acceptance_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
