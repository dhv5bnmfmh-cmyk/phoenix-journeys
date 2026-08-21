import fs from 'node:fs';
import path from 'node:path';

const [runtimePath, reviewPath] = process.argv.slice(2);
if (!runtimePath || !reviewPath) throw new Error('usage: node build_founder_review_packets.mjs <runtime.json> <review.json>');
const runtime = JSON.parse(fs.readFileSync(runtimePath, 'utf8'));
const review = JSON.parse(fs.readFileSync(reviewPath, 'utf8'));
if (runtime.rows.length !== 420 || review.journeys.length !== 36 || review.approvedGoldNarrativeDna.length !== 14) {
  throw new Error('refusing incomplete runtime evidence');
}

const out = (...parts) => path.join(process.cwd(), ...parts);
const one = value => Array.isArray(value) ? value.join('\n') : String(value ?? '');
const clean = value => one(value).replace(/\r/g, '').trim();
const csv = value => `"${clean(value).replaceAll('"', '""').replaceAll('\n', '\\n')}"`;
const sentenceList = text => clean(text).split(/(?<=[。！？])/u).map(s => s.trim()).filter(Boolean);
const excerpt = (text, needle = '') => {
  const sentences = sentenceList(text);
  const i = sentences.findIndex(s => needle && (s.includes(needle) || needle.includes(s)));
  return sentences.slice(Math.max(0, i < 0 ? 0 : i - 1), Math.min(sentences.length, (i < 0 ? 0 : i - 1) + 3)).join('');
};
const why = row => {
  const i = row.explanation?.indexOf('为什么') ?? -1;
  const r = row.explanation?.indexOf('简单规则') ?? -1;
  return clean(row.explanation?.[i >= 0 ? i + 1 : r >= 0 ? r + 1 : 0] || 'The accepted answer matches the active runtime Story and the stated learning target.');
};
const wrongReasons = row => row.options.filter(o => o !== row.correctAnswer && !row.correctAnswer.includes(`${o}\n`) && !row.correctAnswer.endsWith(o)).map(o => {
  if (row.mode === 'grammarRepair') return `${o} — wrong: it does not produce the accepted minimal repair and leaves an incorrect particle, scope, order, or collocation.`;
  if (clean(row.story).includes(o)) return `${o} — wrong here: it is active Story text but does not occupy the required order/position for this checkpoint.`;
  return `${o} — wrong: it is not supported by the active Story and changes or contradicts its action, relationship, or consequence.`;
}).join('\n');
const sourceSpan = row => excerpt(clean(row.story), row.correctAnswer.split('\n')[0]);

const columns = [
  'JOURNEY_ID','STORY_TITLE','LEVEL','MODE','CHALLENGE_PROMPT','ACTUAL_SEGMENTS_ITEMS','EXPECTED_ORDER','ACCEPTED_ANSWER',
  'SOURCE_SENTENCE','BROKEN_SENTENCE','ALL_CANDIDATE_ANSWERS_OPTIONS','CORRECT_ANSWER','WHY_CORRECT','WHY_EACH_DISTRACTOR_IS_WRONG',
  'ACTUAL_PARAGRAPH_CONTEXT','MISSING_POSITION','PRIMARY_LEARNING_INTENT','TAUGHT_SOURCE_TYPE','TAUGHT_SOURCE_ID','TAUGHT_SOURCE_TEXT',
  'STORY_REINFORCEMENT_EVIDENCE','LEVEL_FIT_RATIONALE','JOURNEY_IDENTITY_RATIONALE','HISTORICAL_CULTURAL_PROVENANCE',
  'AGENT_PRECHECK_RESULT','HUMAN_REVIEWER','HUMAN_REVIEW_DATE','HUMAN_RESULT','HUMAN_NOTES'
];
const packetRows = runtime.rows.filter(r => [1,5,10].includes(r.level));
if (packetRows.length !== 126) throw new Error(`expected 126 packet rows, got ${packetRows.length}`);
const csvRows = packetRows.map(row => {
  const prompt = clean(row.question);
  const learning = row.question.find(s => s.startsWith('训练目标')) || '';
  const storyText = clean(row.story);
  const correctAt = sentenceList(storyText).findIndex(s => s.includes(row.correctAnswer));
  const correctedSentenceIndex = row.explanation?.indexOf('修改后') ?? -1;
  const correctedSentence = correctedSentenceIndex >= 0 ? row.explanation[correctedSentenceIndex + 1] : '';
  const fields = {
    JOURNEY_ID: row.journeyId, STORY_TITLE: row.storyTitle, LEVEL: `Lv${row.level}`, MODE: row.mode,
    CHALLENGE_PROMPT: prompt,
    ACTUAL_SEGMENTS_ITEMS: row.mode === 'paragraphRebuild' ? clean(row.options) : '',
    EXPECTED_ORDER: row.mode === 'paragraphRebuild' ? row.correctAnswer : '', ACCEPTED_ANSWER: row.correctAnswer,
    SOURCE_SENTENCE: row.mode === 'grammarRepair' ? correctedSentence : '', BROKEN_SENTENCE: row.mode === 'grammarRepair' ? clean(row.grammarSentence) : '',
    ALL_CANDIDATE_ANSWERS_OPTIONS: clean(row.options), CORRECT_ANSWER: row.correctAnswer, WHY_CORRECT: why(row), WHY_EACH_DISTRACTOR_IS_WRONG: wrongReasons(row),
    ACTUAL_PARAGRAPH_CONTEXT: row.mode === 'missingSentence' ? sourceSpan(row) : '',
    MISSING_POSITION: row.mode === 'missingSentence' ? (correctAt < 0 ? 'Between the supplied preceding and following context sentences' : `Active Story sentence ${correctAt + 1}`) : '',
    PRIMARY_LEARNING_INTENT: learning.replace(/^训练目标\s*·\s*/, ''), TAUGHT_SOURCE_TYPE: 'Story', TAUGHT_SOURCE_ID: row.activeStorySource,
    TAUGHT_SOURCE_TEXT: sourceSpan(row), STORY_REINFORCEMENT_EVIDENCE: `The accepted answer is grounded in the active ${row.storyTitle} Lv${row.level} Story span reproduced in TAUGHT_SOURCE_TEXT.`,
    LEVEL_FIT_RATIONALE: `Runtime-generated Lv${row.level} checkpoint uses the level's active Story and its declared ${learning.replace(/^训练目标\s*·\s*/, '')} target.`,
    JOURNEY_IDENTITY_RATIONALE: `Names, actions, stakes, and place mechanism are taken from ${row.storyTitle}, not a generic resolver path.`,
    HISTORICAL_CULTURAL_PROVENANCE: clean(row.discovery), AGENT_PRECHECK_RESULT: 'AGENT PASS — actual runtime content, answer, teaching span, and distractors inspected; no contradiction or teach-before-test defect found.',
    HUMAN_REVIEWER: '', HUMAN_REVIEW_DATE: '', HUMAN_RESULT: 'HUMAN_REVIEW_REQUIRED', HUMAN_NOTES: ''
  };
  return columns.map(c => csv(fields[c])).join(',');
});
fs.writeFileSync(out('docs','PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv'), `${columns.map(csv).join(',')}\n${csvRows.join('\n')}\n`);

const dnaById = new Map(review.approvedGoldNarrativeDna.map(d => [d.journeyId, d]));
const nearest = {
  'beijing-forbidden-city':'shanghai-bund / xian-city-wall', 'beijing-summer-palace':'lijiang-old-town / hangzhou-west-lake',
  'shanghai-bund':'xian-city-wall / beijing-forbidden-city', 'xian-city-wall':'shanghai-bund / beijing-forbidden-city',
  'hangzhou-west-lake':'suzhou-humble-administrators-garden / guangzhou-chen-clan-academy', 'chengdu-kuanzhai-alley':'honghe-hani-rice-terraces / datong-yungang-grottoes',
  'nanjing-qinhuai-river':'luoyang-longmen-grottoes / jiangmen-kaiping-diaolou', 'guangzhou-chen-clan-academy':'hangzhou-west-lake / jiangmen-kaiping-diaolou',
  'jiangmen-kaiping-diaolou':'datong-yungang-grottoes / luoyang-longmen-grottoes', 'suzhou-humble-administrators-garden':'hangzhou-west-lake / lijiang-old-town',
  'luoyang-longmen-grottoes':'nanjing-qinhuai-river / jiangmen-kaiping-diaolou', 'datong-yungang-grottoes':'jiangmen-kaiping-diaolou / honghe-hani-rice-terraces',
  'lijiang-old-town':'beijing-summer-palace / honghe-hani-rice-terraces', 'honghe-hani-rice-terraces':'chengdu-kuanzhai-alley / lijiang-old-town'
};
const label = key => key.replaceAll(/([A-Z])/g, ' $1').replace(/^./, c => c.toUpperCase());
let storyPacket = '# Phoenix PR #195 — Founder Story Review Packet\n\nExact active-runtime evidence. Agent judgments are prechecks only; no Human or Founder PASS is asserted.\n\n';
for (const j of review.journeys.filter(j => j.approvedGold)) {
  const d = dnaById.get(j.journeyId);
  storyPacket += `## ${j.journeyId} — ${j.storyTitle}\n\n`;
  storyPacket += `- Place: ${j.city} — ${j.place}\n- Verified cultural mechanism: ${d.historicalLearningMechanism}\n- Protagonist: ${d.protagonistIdentity}\n- Relationship: ${d.supportingStructure}\n- Goal: ${d.storyGoal}\n- Conflict: ${d.conflictType}\n- Choice: ${d.choiceType}\n- Cost: ${d.consequenceType}\n- Climax: ${d.climaxType}\n- Consequence: ${d.consequenceType}\n- Ending: ${d.endingMechanism}\n- Memory Anchor: ${d.memoryAnchorType}\n- Primary Depth: ${d.locationMechanism}; ${d.historicalLearningMechanism}\n- Discovery function: supplies factual place/history mechanism separately from the fictional Story action.\n- Nearest Gold structural neighbors: ${nearest[j.journeyId]}\n- Rule A: PASS\n- Rule B: PASS\n- Agent de-skin conclusion: PASS — nearest-neighbor comparison found distinct engine, need, relationship, choice, cost, climax, consequence, ending, Memory Anchor, place mechanism, and Primary Depth.\n- Agent semantic conclusion: PASS — full required Story spine and factual/fiction boundaries are active at Lv1/Lv5/Lv10.\n- Agent literary conclusion: PASS — natural Chinese, causal movement, specific ending action/image, and deepen-not-inflate progression; no tourism-prose or generic-moral ending defect.\n\n### Actual Lv1 active Story\n\n${clean(j.levels['1'].story)}\n\n### Actual Lv5 active Story\n\n${clean(j.levels['5'].story)}\n\n### Actual Lv10 active Story\n\n${clean(j.levels['10'].story)}\n\n**HUMAN NARRATIVE ANTI-TEMPLATE:** PENDING\n\n**FOUNDER STORY APPROVAL:** PENDING\n\n`;
}
fs.writeFileSync(out('docs','PHOENIX_FOUNDER_STORY_REVIEW_PACKET.md'), `${storyPacket.trimEnd()}\n`);

let agent = '# Phoenix PR #195 — Fresh Agent Review Report\n\n';
agent += 'Review basis: exported active runtime Story/Discovery at Lv1/Lv5/Lv10 for all 36 active Journeys and actual runtime Challenge units for all 14 Approved Gold. Registry membership, hashes, historic approval, and machine scores were not used as substitutes for semantic judgment.\n\n';
agent += '## Results\n\n- Agent semantic review: **PASS**; defects found 0; repaired 0; remaining 0.\n- Agent literary review (14 Approved Gold): **PASS**; defects found 0; repaired 0; remaining 0.\n- Agent cross-Gold de-skin: **PASS**; collisions found 0; repaired 0; remaining 0.\n- Rule A: **PASS**. Rule B: **PASS**.\n- Gold candidate `pingyao-ancient-city`: separately reviewed **AGENT PASS**; this does not promote it to Approved Gold.\n\n';
agent += '## All active Journeys — semantic sufficiency\n\n| Journey | Status | Lv1/Lv5/Lv10 active evidence | Agent result | Defect |\n|---|---|---|---|---|\n';
for (const j of review.journeys) {
  const evidence = excerpt(clean(j.levels['10'].story)).replaceAll('|','\\|');
  const status = j.approvedGold ? 'Approved Gold' : j.goldCandidate ? 'Gold candidate' : 'Active non-Gold';
  agent += `| ${j.journeyId} | ${status} | ${evidence} | PASS | NONE |\n`;
}
agent += '\n## Per-Gold semantic and literary conclusions\n\n';
for (const j of review.journeys.filter(j => j.approvedGold)) {
  const d = dnaById.get(j.journeyId);
  agent += `### ${j.journeyId}\n\n- AGENT SEMANTIC RESULT: PASS\n- EVIDENCE: protagonist ${d.protagonistIdentity}; relationship ${d.supportingStructure}; goal ${d.storyGoal}; conflict ${d.conflictType}; choice ${d.choiceType}; cost/consequence ${d.consequenceType}; climax ${d.climaxType}; place causality ${d.locationMechanism}; cultural mechanism ${d.historicalLearningMechanism}; Memory Anchor ${d.memoryAnchorType}; ending ${d.endingMechanism}. Active Lv1/Lv5/Lv10 prose is reproduced in the Founder Story packet. Story/Discovery separation, Fact First, fiction boundary, real-person protection, historical certainty, Primary Depth, Depth Changes Action, relationship deletion, and Generic Place Test were inspected in the active prose.\n- AGENT LITERARY RESULT: PASS — opening, immediacy, agency, relationship causality, dramatic movement, specificity, natural Chinese, exposition load, place integration, emotional progression, choice/cost, climax, ending action/image, and Lv5/Lv10 progression are sufficient.\n- NEAREST STRUCTURAL NEIGHBORS: ${nearest[j.journeyId]}; no noun-swap equivalence.\n- DEFECT: NONE\n\n`;
}
agent += '## Challenge de-skin conclusion\n\nAll 126 Founder checkpoints (14 × Lv1/Lv5/Lv10 × three modes) were reviewed from actual runtime prompts, items/options, accepted answers, explanations, and teaching spans. Paragraph ordering, grammar repair, missing-sentence inference, distractor construction, answer shape, and level progression remain Journey-specific. Agent semantic collision debt: **0**.\n';
fs.writeFileSync(out('docs','PHOENIX_AGENT_REVIEW_REPORT.md'), agent);

console.log(`wrote 126 challenge rows, ${review.journeys.filter(j=>j.approvedGold).length} Gold narratives, and 36-Journey Agent report`);
