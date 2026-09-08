import fs from 'node:fs';

const [inputPath, jsonPath, mdPath] = process.argv.slice(2);
if (!inputPath || !jsonPath || !mdPath) {
  throw new Error('usage: node pr208_level_stage_audit_analyze.mjs <raw.json> <audit.json> <audit.md>');
}

const raw = JSON.parse(fs.readFileSync(inputPath, 'utf8'));
const rows = raw.rows;

const punctuation = /[\s\p{P}\p{S}]/gu;
const uiNoise = /^(Story|Vocabulary|Discovery|Challenge|回忆 · 完成|上一步|继续|完成挑战后继续|继续留下回忆|保存回忆并完成|结束旅程|简 \/ 繁|繁 \/ 简|Lv\.\d+)$/;
const cityLeak = /(杭州|西湖|上海|苏州|西安|丽江|颐和园|大理|成都)/;
const knowledgeSignal = /(北京|紫禁城|故宫|故宫博物院|午门|乾清门|景运门|中轴|宫门|宫城|外朝|内廷|院落|路线|沈砚|阿宁|林乔|许澄|核对|交接|记录)/;

function normalizeText(value) {
  return String(value ?? '')
    .replace(/Lv\.?\s*\d+/gi, 'Lv')
    .replace(/挑战\s*\d+\/12/g, '挑战')
    .replace(/\d+\/4/g, 'x/4')
    .replace(punctuation, '')
    .toLowerCase();
}

function fnv(value) {
  let hash = 0x811c9dc5;
  for (const ch of value) {
    hash ^= ch.codePointAt(0);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash.toString(16).padStart(8, '0');
}

function pedagogicalPayload(row) {
  const actual = row.actual;
  switch (row.stage) {
    case 'Story':
      return actual.renderedParagraphs;
    case 'Vocabulary':
      return actual.items.map((item) => ({
        word: item.word,
        pinyin: item.pinyin,
        simpleChinese: item.simpleChinese,
        englishDefinition: item.englishDefinition,
        firstOccurrence: item.firstOccurrence,
        examples: item.examples.map((x) => x.chinese),
      }));
    case 'Discovery':
      return actual.renderedDiscoveries;
    case 'Challenge':
      return actual.questions.map((q) => ({
        mode: q.mode,
        sourceSentence: q.sourceSentence,
        prompt: q.prompt,
        answer: q.answer,
        options: [...q.options].sort(),
        tiles: [...q.characterTiles].sort(),
        errorSegments: q.errorSegments,
        grammarFamily: q.grammarFamily,
        completionSegments: q.completionSegments,
        blanks: q.completionBlanks.map((b) => ({
          answer: b.answer,
          options: [...b.options].sort(),
          answerType: b.answerType,
          semanticSlotType: b.semanticSlotType,
        })),
      }));
    case 'Memory':
    case 'Completion':
      return actual.renderedPageTexts
        .filter((x) => !uiNoise.test(String(x).trim()))
        .map((x) => String(x).replace(/Lv\.?\s*\d+/gi, 'Lv'));
    default:
      return actual;
  }
}

function semanticIdentity(row) {
  const normalized = JSON.stringify(pedagogicalPayload(row), (_key, value) =>
    typeof value === 'string' ? normalizeText(value) : value,
  );
  return fnv(normalized);
}

function allStrings(value, out = []) {
  if (typeof value === 'string') out.push(value);
  else if (Array.isArray(value)) value.forEach((x) => allStrings(x, out));
  else if (value && typeof value === 'object') Object.values(value).forEach((x) => allStrings(x, out));
  return out;
}

function hanCount(value) {
  return [...String(value)].filter((ch) => /[\u3400-\u9fff]/u.test(ch)).length;
}

function maxStreak(values) {
  let best = 0;
  let current = 0;
  let previous = null;
  for (const value of values) {
    if (value === previous) current += 1;
    else current = 1;
    previous = value;
    best = Math.max(best, current);
  }
  return best;
}

function recommendation(stage, rule) {
  if (stage === 'Vocabulary') return 'Wire Story-specific, level-aware vocabulary selection without touching pronunciation overrides or the lazy Word Detail performance path.';
  if (stage === 'Discovery') return 'Author/wire level-specific Forbidden City discovery knowledge for this Story while preserving authoritative source labels.';
  if (stage === 'Challenge') return 'Complete the shared Challenge generator for both Story IDs and all Lv1–Lv10 contracts; preserve HskStoryChallenge feedback UI.';
  if (stage === 'Story') return 'Preserve Founder-reviewed prose unless the primary level binding is missing; prefer exercise-level scaling for the protected Second Story.';
  if (stage === 'Memory' || stage === 'Completion') return 'Bind the existing level-aware Story-specific memory/completion runtime instead of UI-only level labels.';
  return `Minimal fix for ${rule}`;
}

const byKey = new Map();
for (const row of rows) {
  row.semanticIdentity = semanticIdentity(row);
  row.status = 'PASS';
  row.issueClassification = [];
  row.issues = [];
  row.duplicateWithLevel = [];
  row.recommendedMinimalFix = '';
  byKey.set(`${row.storyId}|${row.level}|${row.stage}`, row);
}

const failures = [];
function fail(row, classification, rule, evidence, severity = 'FAIL') {
  row.status = 'FAIL';
  if (!row.issueClassification.includes(classification)) row.issueClassification.push(classification);
  row.issues.push({ rule, evidence, severity });
  if (!row.recommendedMinimalFix) row.recommendedMinimalFix = recommendation(row.stage, rule);
  failures.push({
    story: row.story,
    storyId: row.storyId,
    level: row.level,
    stage: row.stage,
    classification,
    rule,
    evidence,
    recommendedMinimalFix: row.recommendedMinimalFix,
  });
}

// Cross-level semantic diff and duplication classification.
const adjacentDiffs = [];
for (const story of raw.stories) {
  for (const stage of ['Story', 'Vocabulary', 'Discovery', 'Challenge', 'Memory', 'Completion']) {
    for (let level = 1; level < 10; level += 1) {
      const a = byKey.get(`${story.id}|${level}|${stage}`);
      const b = byKey.get(`${story.id}|${level + 1}|${stage}`);
      const same = a.semanticIdentity === b.semanticIdentity;
      let classification = same ? 'TRIVIAL_OR_IDENTICAL' : 'LEVEL-SPECIFIC AND CORRECTLY DIFFERENT';
      if (stage === 'Story' && story.id === 'story.forbidden_city.modern_evidence_handoff.v1' && same) {
        classification = 'INTENTIONALLY SAME';
      }
      adjacentDiffs.push({ story: story.title, stage, fromLevel: level, toLevel: level + 1, same, classification });
      if (same) {
        a.duplicateWithLevel.push(level + 1);
        b.duplicateWithLevel.push(level);
        if (stage === 'Story' && story.id === 'story.forbidden_city.modern_evidence_handoff.v1') {
          continue;
        }
        if (stage === 'Vocabulary' || stage === 'Discovery' || stage === 'Challenge') {
          fail(
            b,
            'REAL PRODUCT INCOMPLETENESS',
            'cross-level semantic duplication',
            `Lv${level} and Lv${level + 1} are pedagogically identical after normalizing IDs, punctuation and option order.`,
          );
        } else if (stage === 'Story' && story.id === 'story.forbidden_city.two_routes_one_map.v1') {
          fail(b, 'RUNTIME WIRING FAILURE', 'primary Story level binding', `Primary Story Lv${level} and Lv${level + 1} render identically.`);
        } else if (stage === 'Memory' || stage === 'Completion') {
          fail(b, 'CONTENT STANDARD FAILURE', 'level-aware reflection/completion', `Only UI-level differences or no meaningful content difference found between Lv${level} and Lv${level + 1}.`);
        }
      }
    }
  }
}

// Row-level content and isolation checks.
for (const row of rows) {
  const strings = allStrings(row.actual);
  const joined = strings.join('\n');
  if (cityLeak.test(joined)) {
    fail(row, 'CONTENT STANDARD FAILURE', 'knowledge source scope', `Unrelated city/place content detected: ${joined.match(cityLeak)?.[0]}`);
  }
  if (row.storyId === 'story.forbidden_city.two_routes_one_map.v1' && /(林乔|许澄|交接前的标记)/.test(joined)) {
    fail(row, 'RUNTIME WIRING FAILURE', 'Story A/B isolation', 'Second Story identity/content leaked into Story A runtime output.');
  }
  if (row.storyId === 'story.forbidden_city.modern_evidence_handoff.v1' && /(沈砚|阿宁|两条路，一张图)/.test(joined)) {
    fail(row, 'RUNTIME WIRING FAILURE', 'Story A/B isolation', 'Primary Story identity/content leaked into Story B runtime output.');
  }

  if (row.stage === 'Vocabulary') {
    const items = row.actual.items;
    if (!items.length) fail(row, 'REAL PRODUCT INCOMPLETENESS', 'Vocabulary non-empty', 'No rendered vocabulary items.');
    for (const item of items) {
      if (!item.firstOccurrence) {
        fail(row, 'CONTENT STANDARD FAILURE', 'Vocabulary Story relevance / first occurrence', `${item.word} has no first occurrence in the rendered Story paragraphs.`);
      }
      if (!item.pinyin || !item.simpleChinese || !item.englishDefinition) {
        fail(row, 'CONTENT STANDARD FAILURE', 'Word Detail completeness', `${item.word} is missing pinyin or definition fields used by Word Detail.`);
      }
    }
  }

  if (row.stage === 'Discovery') {
    const items = row.actual.renderedDiscoveries;
    if (!items.length) fail(row, 'REAL PRODUCT INCOMPLETENESS', 'Discovery non-empty', 'No rendered Discovery content.');
    if (!items.every((item) => knowledgeSignal.test(item))) {
      fail(row, 'CONTENT STANDARD FAILURE', 'Discovery Beijing / Forbidden City knowledge', 'At least one rendered Discovery paragraph lacks a current Story / Forbidden City knowledge signal.');
    }
  }

  if (row.stage === 'Challenge') {
    const actual = row.actual;
    const questions = actual.questions;
    if (actual.questionCount !== 12) {
      fail(row, 'GENERATOR FAILURE', 'Challenge question count', `Expected 12 rendered questions, got ${actual.questionCount}.`);
    }
    const modeCounts = Object.fromEntries(['sentenceRebuild', 'grammarRepair', 'storyCompletion'].map((mode) => [mode, questions.filter((q) => q.mode === mode).length]));
    for (const [mode, count] of Object.entries(modeCounts)) {
      if (count !== 4) fail(row, 'GENERATOR FAILURE', 'Challenge mode distribution', `${mode} expected 4, got ${count}.`);
    }

    const grammarFamilies = new Set();
    const answerPositions = [];
    const rebuildAnswers = [];
    for (const q of questions) {
      const qText = [q.prompt, q.sourceSentence, q.answer, q.narrationText].join(' ');
      if (!knowledgeSignal.test(qText)) {
        fail(row, 'CONTENT STANDARD FAILURE', 'Challenge knowledge relevance', `${q.id} lacks a Beijing / Forbidden City or current Story knowledge signal.`);
      }
      if (q.options.length === 4) {
        const matches = q.options.filter((x) => normalizeText(x) === normalizeText(q.answer));
        if (matches.length !== 1 || q.directCorrectIndex < 0) {
          fail(row, 'GENERATOR FAILURE', 'unique direct correct option', `${q.id} has ${matches.length} normalized correct options.`);
        } else {
          answerPositions.push(q.directCorrectIndex);
        }
        const normalized = q.options.map(normalizeText);
        if (new Set(normalized).size !== normalized.length) {
          fail(row, 'GENERATOR FAILURE', 'duplicate distractors', `${q.id} contains duplicate/equivalent rendered options.`);
        }
      }

      if (q.mode === 'sentenceRebuild') {
        rebuildAnswers.push(normalizeText(q.answer));
        const chars = hanCount(q.answer);
        if (chars > 10) {
          fail(row, 'CONTENT STANDARD FAILURE', 'Sentence Rebuild <=10 Chinese characters', `${q.id} renders ${chars} Han characters: ${q.answer}`);
        }
        if (!knowledgeSignal.test(q.answer)) {
          fail(row, 'CONTENT STANDARD FAILURE', 'Sentence Rebuild meaningful knowledge', `${q.id} answer is not clearly grounded in Beijing / Forbidden City knowledge: ${q.answer}`);
        }
        const joinedTiles = q.characterTiles.map(normalizeText).sort().join('|');
        if (!joinedTiles) fail(row, 'GENERATOR FAILURE', 'Sentence Rebuild blocks', `${q.id} has no rendered rebuild blocks.`);
      }

      if (q.mode === 'grammarRepair') {
        if (q.grammarFamily) grammarFamilies.add(normalizeText(q.grammarFamily));
        if (!/[。！？!?]$/u.test(q.prompt.trim()) || hanCount(q.prompt) < 8) {
          fail(row, 'CONTENT STANDARD FAILURE', 'Grammar complete incorrect sentence', `${q.id} does not render a complete substantial incorrect sentence: ${q.prompt}`);
        }
        if (!q.grammarWhyWrong || !q.grammarRevisionRule) {
          fail(row, 'CONTENT STANDARD FAILURE', 'Grammar explanation / correction rule', `${q.id} is missing why-wrong or revision-rule feedback.`);
        }
      }

      if (q.mode === 'storyCompletion') {
        if (q.completionBlanks.length !== row.level) {
          fail(row, 'GENERATOR FAILURE', 'Completion LvN blank count', `${q.id} Lv${row.level} expected ${row.level} blanks, got ${q.completionBlanks.length}.`);
        }
        for (const [blankIndex, blank] of q.completionBlanks.entries()) {
          const matches = blank.options.filter((x) => normalizeText(x) === normalizeText(blank.answer));
          if (matches.length !== 1 || blank.correctIndex < 0) {
            fail(row, 'GENERATOR FAILURE', 'Completion unique correct answer', `${q.id} blank ${blankIndex + 1} has ${matches.length} normalized correct options.`);
          } else {
            answerPositions.push(blank.correctIndex);
          }
          const normalized = blank.options.map(normalizeText);
          if (new Set(normalized).size !== normalized.length) {
            fail(row, 'GENERATOR FAILURE', 'Completion distractor uniqueness', `${q.id} blank ${blankIndex + 1} has duplicate/equivalent options.`);
          }
        }
      }

      const feedback = (q.renderedFeedback ?? []).join(' ');
      if (!feedback.includes('回答错误') || !feedback.includes('正确答案')) {
        fail(row, 'CONTENT STANDARD FAILURE', 'Challenge inline wrong/correct feedback', `${q.id} did not render both explicit wrong feedback and inline correct answer.`);
      }
      const feedbackColor = String(q.feedbackColor ?? '').toLowerCase();
      const correctColor = String(q.correctAnswerColor ?? '').toLowerCase();
      if (!feedbackColor.includes('ffff5252')) {
        fail(row, 'CONTENT STANDARD FAILURE', 'WRONG red feedback', `${q.id} wrong feedback color is ${q.feedbackColor}.`);
      }
      if (!correctColor.includes('ff69f0ae')) {
        fail(row, 'CONTENT STANDARD FAILURE', 'CORRECT green answer feedback', `${q.id} correct answer color is ${q.correctAnswerColor}.`);
      }
    }

    if (grammarFamilies.size !== 4) {
      fail(row, 'CONTENT STANDARD FAILURE', 'Grammar four distinct categories', `Lv${row.level} renders ${grammarFamilies.size} distinct grammar families across four Grammar questions.`);
    }
    if (!actual.feedbackAudioCallbackBound || actual.ttsSpeakCallsDuringChallenge <= 0) {
      fail(row, 'RUNTIME WIRING FAILURE', 'Challenge correct/wrong audio feedback', `Audio callback bound=${actual.feedbackAudioCallbackBound}, TTS speak calls=${actual.ttsSpeakCallsDuringChallenge}.`);
    }
    if (answerPositions.some((x) => x < 0 || x > 3)) {
      fail(row, 'GENERATOR FAILURE', 'MCQ final rendered positions', `Invalid correct positions: ${answerPositions.join(',')}`);
    } else if (answerPositions.length) {
      const streak = maxStreak(answerPositions);
      const counts = [0, 0, 0, 0];
      answerPositions.forEach((x) => counts[x] += 1);
      if (streak > 2) {
        fail(row, 'CONTENT STANDARD FAILURE', 'MCQ correct-option streak <=2', `Final rendered correct-position streak is ${streak}: ${answerPositions.join(',')}`);
      }
      if (Math.max(...counts) - Math.min(...counts) > 1) {
        fail(row, 'CONTENT STANDARD FAILURE', 'MCQ A/B/C/D balance', `Final rendered position counts are ${counts.join('/')}.`);
      }
    }

    row.challengeMetrics = {
      modeCounts,
      grammarFamilies: [...grammarFamilies],
      finalAnswerPositions: answerPositions,
      maxCorrectPositionStreak: maxStreak(answerPositions),
      rebuildAnswers,
    };
  }
}

// Mode-specific anti-template across adjacent levels, stricter than whole-stage hashes.
for (const story of raw.stories) {
  for (let level = 1; level < 10; level += 1) {
    const a = byKey.get(`${story.id}|${level}|Challenge`);
    const b = byKey.get(`${story.id}|${level + 1}|Challenge`);
    for (const mode of ['sentenceRebuild', 'grammarRepair', 'storyCompletion']) {
      const pa = a.actual.questions.filter((q) => q.mode === mode).map((q) => normalizeText([q.prompt, q.answer, q.sourceSentence].join('|'))).sort();
      const pb = b.actual.questions.filter((q) => q.mode === mode).map((q) => normalizeText([q.prompt, q.answer, q.sourceSentence].join('|'))).sort();
      if (JSON.stringify(pa) === JSON.stringify(pb)) {
        fail(
          b,
          'REAL PRODUCT INCOMPLETENESS',
          `Semantic Anti-Template ${mode}`,
          `${mode} pedagogical content is semantically identical between Lv${level} and Lv${level + 1}.`,
        );
      }
    }
  }
}

// Final cell status and explicit audit answers.
const failedLevels = [...new Set(failures.map((x) => x.level))].sort((a, b) => a - b);
const failedStages = [...new Set(failures.map((x) => x.stage))].sort();
const duplicatedStages = [...new Set(failures.filter((x) => x.rule.includes('duplication') || x.rule.includes('Anti-Template')).map((x) => x.stage))].sort();
const challengeFailures = failures.filter((x) => x.stage === 'Challenge');
const completionFailures = failures.filter((x) => x.rule.includes('Completion'));
const grammarFailures = failures.filter((x) => x.rule.includes('Grammar'));
const rebuildFailures = failures.filter((x) => x.rule.includes('Sentence Rebuild'));
const mcqFailures = failures.filter((x) => x.rule.includes('MCQ'));
const knowledgeFailures = failures.filter((x) => x.rule.includes('knowledge') || x.rule.includes('Knowledge') || x.rule.includes('source scope'));

const primaryStoryRows = rows.filter((r) => r.storyId === 'story.forbidden_city.two_routes_one_map.v1' && r.stage === 'Story');
const secondStoryRows = rows.filter((r) => r.storyId === 'story.forbidden_city.modern_evidence_handoff.v1' && r.stage === 'Story');
const primaryStoryDistinct = new Set(primaryStoryRows.map((r) => r.semanticIdentity)).size;
const secondStoryDistinct = new Set(secondStoryRows.map((r) => r.semanticIdentity)).size;

const auditSummary = {
  '1_are_all_lv1_lv10_implemented': failures.length ? 'PARTIAL' : 'YES',
  '2_incomplete_levels': failedLevels,
  '3_incomplete_stages': failedStages,
  '4_incorrect_identical_content_stages': duplicatedStages,
  '5_story_expected_to_change_by_level': {
    primaryStory: `YES: ${primaryStoryDistinct}/10 distinct rendered semantic identities`,
    secondStory: `NO narrative rewrite required by current Founder protection: ${secondStoryDistinct}/10 distinct narrative identities; progression should live in exercises.`,
  },
  '6_vocabulary_level_specific': failures.some((x) => x.stage === 'Vocabulary' && x.rule.includes('duplication')) ? 'NO / INCOMPLETE' : 'YES',
  '7_discovery_level_specific': failures.some((x) => x.stage === 'Discovery' && x.rule.includes('duplication')) ? 'NO / INCOMPLETE' : 'YES',
  '8_challenge_compliant': challengeFailures.length ? 'NO' : 'YES',
  '9_challenge_contract_failures': [...new Set(challengeFailures.map((x) => x.rule))].sort(),
  '10_completion_blank_counts_correct': completionFailures.some((x) => x.rule === 'Completion LvN blank count') ? 'NO' : 'YES',
  '11_grammar_four_categories_present': grammarFailures.some((x) => x.rule === 'Grammar four distinct categories') ? 'NO' : 'YES',
  '12_sentence_rebuild_le_10_and_meaningful': rebuildFailures.length ? 'NO' : 'YES',
  '13_mcq_positions_deterministic_balanced': mcqFailures.length ? 'NO / BALANCE CONTRACT FAILURE' : 'PASS IN CAPTURED FINAL RENDERED ORDER',
  '14_all_questions_beijing_forbidden_city_knowledge': knowledgeFailures.length ? 'NO / SOME FAIL' : 'YES',
  totalCells: rows.length,
  failedCells: rows.filter((r) => r.status === 'FAIL').length,
  failureCount: failures.length,
};

const output = {
  ...raw,
  auditSummary,
  adjacentDiffs,
  failures,
  rows,
};
fs.writeFileSync(jsonPath, JSON.stringify(output, null, 2));

const lines = [];
lines.push('# Phoenix Journeys PR #208 — Full Lv1–Lv10 × Learning-Stage Runtime Audit');
lines.push('');
lines.push(`Exact product SHA: \`${raw.candidate_sha}\``);
lines.push('');
lines.push('## Actual runtime topology');
lines.push('');
lines.push('| Step | Runtime page | Actual renderer |');
lines.push('|---:|---|---|');
for (const item of raw.runtimeTopology) lines.push(`| ${item.stepIndex} | ${item.runtimePage} | ${item.widget} |`);
lines.push('');
lines.push('## Required audit answers');
lines.push('');
for (const [key, value] of Object.entries(auditSummary)) {
  lines.push(`- **${key}**: ${typeof value === 'string' ? value : JSON.stringify(value)}`);
}
lines.push('');
lines.push('## Failures');
lines.push('');
if (!failures.length) {
  lines.push('No failures.');
} else {
  lines.push('| Story | Lv | Stage | Classification | Rule | Evidence |');
  lines.push('|---|---:|---|---|---|---|');
  for (const f of failures) {
    const evidence = String(f.evidence).replaceAll('|', '\\|').replaceAll('\n', ' ').slice(0, 420);
    lines.push(`| ${f.story} | ${f.level} | ${f.stage} | ${f.classification} | ${f.rule} | ${evidence} |`);
  }
}
lines.push('');
lines.push('## Level × stage matrix');
lines.push('');
lines.push('| Story | Lv | Story | Vocabulary | Discovery | Challenge | Memory | Completion |');
lines.push('|---|---:|---|---|---|---|---|---|');
for (const story of raw.stories) {
  for (let level = 1; level <= 10; level += 1) {
    const status = (stage) => byKey.get(`${story.id}|${level}|${stage}`).status;
    lines.push(`| ${story.title} | ${level} | ${status('Story')} | ${status('Vocabulary')} | ${status('Discovery')} | ${status('Challenge')} | ${status('Memory')} | ${status('Completion')} |`);
  }
}
lines.push('');
lines.push('## Adjacent-level semantic diff');
lines.push('');
lines.push('| Story | Stage | Pair | Classification |');
lines.push('|---|---|---|---|');
for (const item of adjacentDiffs) {
  lines.push(`| ${item.story} | ${item.stage} | Lv${item.fromLevel}→Lv${item.toLevel} | ${item.classification} |`);
}
lines.push('');
lines.push('## Cell details');
lines.push('');
for (const row of rows) {
  lines.push(`### ${row.story} · Lv${row.level} · ${row.stage} — ${row.status}`);
  lines.push('');
  lines.push(`- semantic identity: \`${row.semanticIdentity}\``);
  lines.push(`- controller/source: ${row.controllerSource}`);
  lines.push(`- generator: ${row.contentGenerator}`);
  lines.push(`- expected: ${row.expectedContract}`);
  if (row.duplicateWithLevel.length) lines.push(`- duplicate with levels: ${[...new Set(row.duplicateWithLevel)].sort((a,b)=>a-b).join(', ')}`);
  if (row.issues.length) {
    for (const issue of row.issues) lines.push(`- ${issue.rule}: ${issue.evidence}`);
  }
  const preview = allStrings(pedagogicalPayload(row)).join(' | ').replaceAll('\n', ' ').slice(0, 900);
  lines.push(`- actual preview: ${preview}`);
  lines.push('');
}
fs.writeFileSync(mdPath, lines.join('\n'));

console.log(JSON.stringify(auditSummary, null, 2));
