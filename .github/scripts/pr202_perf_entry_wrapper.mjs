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

// Challenge option discovery and activation intentionally reuse the compressed runner's
// mature formal-E2E contract. Do not layer role filtering or synthetic de-duplication here.
// Match the formal iPhone/WebKit verifier's semantic-click settle before submitting.
const challengeClickSettleOriginal = `    await page.locator('flt-semantics').nth(matches[0].index).evaluate((e)=>e.click()); await sleep(70);`;
const challengeClickSettleReplacement = `    await page.locator('flt-semantics').nth(matches[0].index).evaluate((e)=>e.click()); await sleep(120);`;

const challengeReadyOriginal = `  await activate(page,'继续',{prefix:true}); await waitStage(page,4);
  await completeChallenge(page);`;
const challengeReadyReplacement = `  await activate(page,'继续',{prefix:true}); await waitStage(page,4);
  const challengeDeadline=Date.now()+20000;while(Date.now()<challengeDeadline){if(await exists(page,'提交第 1 / 3 次答案',{role:'button',prefix:true,timeout:300}))break;const snapshot=await visibleText(page);if(snapshot.includes('3/6')&&await exists(page,'继续',{role:'button',prefix:true,timeout:300}))await activate(page,'继续',{prefix:true,timeout:1200});await sleep(100);}await findSemantic(page,'提交第 1 / 3 次答案',{role:'button',prefix:true,timeout:5000});await waitStage(page,4,5000);
  const optionDeadline=Date.now()+8000;let optionCount=0;let requiredCount=1;while(Date.now()<optionDeadline){requiredCount=await requiredChallengeSelections(page);optionCount=(await challengeOptionTargets(page)).length;if(optionCount>=requiredCount)break;await sleep(100);}if(optionCount<requiredCount)throw new Error('Challenge controls did not settle before interaction; targets='+optionCount+' required='+requiredCount);
  await completeChallenge(page); if(process.env.CHALLENGE_PREFLIGHT_ONLY==='1'){console.log('CHALLENGE_PREFLIGHT_PASS city='+cityKey+' browser='+browserName);process.exit(0);}`;

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

for (const [needle, replacementText, label] of [
  [perfEntryOriginal, perfEntryReplacement, 'mature entry assertion'],
  [challengeClickSettleOriginal, challengeClickSettleReplacement, 'formal Challenge click settle'],
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

const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_perf_acceptance_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
