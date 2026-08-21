import { readFileSync, writeFileSync } from 'node:fs';

const baseline = process.argv[2];
if (!baseline) {
  throw new Error('usage: node generate_global_compliance_evidence.mjs <baseline-sha>');
}

const esc = value => `"${String(value).replaceAll('"', '""').replaceAll(/\s+/g, ' ').trim()}"`;
const docId = path => path.replace(/^docs\//, '').replace(/\.md$/, '');

function parseCsv(text) {
  const rows = [];
  let row = [];
  let cell = '';
  let quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    if (quoted) {
      if (char === '"' && text[index + 1] === '"') {
        cell += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        cell += char;
      }
      continue;
    }
    if (char === '"') {
      quoted = true;
    } else if (char === ',') {
      row.push(cell);
      cell = '';
    } else if (char === '\n') {
      row.push(cell.replace(/\r$/, ''));
      rows.push(row);
      row = [];
      cell = '';
    } else {
      cell += char;
    }
  }
  if (cell.length || row.length) {
    row.push(cell);
    rows.push(row);
  }
  return rows.filter(candidate => candidate.some(value => value.trim().length > 0));
}

function recordsFromCsv(text) {
  const rows = parseCsv(text);
  if (rows.length === 0) return [];
  const headers = rows[0];
  return rows.slice(1).map(row => Object.fromEntries(headers.map((header, index) => [header, row[index] ?? ''])));
}

const currentInventory = recordsFromCsv(readFileSync('docs/PHOENIX_CURRENT_STANDARD_INVENTORY.csv', 'utf8'));
const standards = currentInventory
    .filter(row => row.STATUS === 'CURRENT_EFFECTIVE')
    .map(row => row.FILE)
    .filter(Boolean);
if (standards.length === 0) {
  throw new Error('No CURRENT_EFFECTIVE standard documents discovered from PHOENIX_CURRENT_STANDARD_INVENTORY.csv');
}
if (new Set(standards).size !== standards.length) {
  throw new Error('Duplicate CURRENT_EFFECTIVE standard document in authority inventory');
}

const normativeSections = /(?:requirement|rule|standard|acceptance|blocking|blocker|gate|checklist|lifecycle|workflow|process|criteria|criterion|definition of done|quality|level|stage|must|shall|prohibit|constraint|policy|principle|completion|verification)/i;
const explicitNormative = /(?:\bMUST\b|\bMUST NOT\b|\bREQUIRED\b|\bCONDITIONALLY_REQUIRED\b|\bSHALL\b|\bSHALL NOT\b|\bCANNOT\b|\bDO NOT\b|\bNO\b|\bONLY\b|\bEVERY\b|\bEACH\b|\bBEFORE\b|\bAFTER\b|\bREPLACE\b|\bKEEP\b|\bAPPLY\b|\bSTOP\b|\bDISABLE\b|\bBLOCKING\b|\bBLOCKER\b|\bACCEPTANCE\b|\bPASS\b|\bFAIL\b|\bPROHIBITED\b|\bREJECTED\b|必须|不得|禁止|需要|仅|每个|每一|之前|之后|阻塞|验收|通过|失败)/i;
const imperative = /^(?:use|verify|require|ensure|preserve|prove|keep|include|exclude|compare|check|record|audit|test|review|prevent|return|resolve|remove|derive|establish|complete|match|maintain|enforce|validate|reject|block|stop|disable|replace|apply|read|run|create|update|do not|never|always|must|should|不得|必须|禁止|保持|确认|验证|检查|记录|审计|测试|拒绝|阻止|停止|替换|应用|保留|完成)\b/i;
const tableSeparator = /^\|?\s*:?-{3,}:?\s*(?:\|\s*:?-{3,}:?\s*)+\|?$/;
const genericTableHeader = /^(?:item|field|category|dimension|stage|level|rule|requirement|status|check|criterion|criteria|scope|area|项目|字段|类别|阶段|等级|规则|要求|状态|检查|标准)(?:\s*\|)/i;

function cleanMarkdown(value) {
  return value
      .replace(/^[-*+]\s+/, '')
      .replace(/^\d+[.)]\s+/, '')
      .replace(/^[-*+]\s*\[[ xX]\]\s*/, '')
      .replace(/^>\s*/, '')
      .replaceAll('`', '')
      .replace(/\s+/g, ' ')
      .trim();
}

function isCandidateNormative(line, section, kind) {
  const cleaned = cleanMarkdown(line);
  if (cleaned.length < 3) return false;
  if (explicitNormative.test(cleaned)) return true;
  if (kind === 'checkbox') return true;
  if (normativeSections.test(section) && (kind === 'list' || kind === 'table')) return true;
  if (normativeSections.test(section) && imperative.test(cleaned)) return true;
  if (kind === 'list' && imperative.test(cleaned)) return true;
  return false;
}

function extractRequirements(file) {
  const lines = readFileSync(file, 'utf8').split(/\r?\n/);
  const extracted = [];
  let section = 'Document scope';
  let inFence = false;
  let serial = 0;

  for (const raw of lines) {
    const trimmed = raw.trim();
    if (/^```/.test(trimmed)) {
      inFence = !inFence;
      continue;
    }
    if (inFence || !trimmed) continue;

    const heading = trimmed.match(/^#{1,6}\s+(.+)/);
    if (heading) {
      section = cleanMarkdown(heading[1]);
      continue;
    }
    if (/^<!--/.test(trimmed) || /^---+$/.test(trimmed)) continue;

    const isTable = trimmed.startsWith('|') && trimmed.includes('|', 1);
    const isCheckbox = /^[-*+]\s*\[[ xX]\]\s+/.test(trimmed);
    const isList = isCheckbox || /^[-*+]\s+/.test(trimmed) || /^\d+[.)]\s+/.test(trimmed);
    const kind = isCheckbox ? 'checkbox' : isTable ? 'table' : isList ? 'list' : 'paragraph';
    let candidate = trimmed;

    if (isTable) {
      if (tableSeparator.test(trimmed)) continue;
      const cells = trimmed
          .replace(/^\|/, '')
          .replace(/\|$/, '')
          .split('|')
          .map(cleanMarkdown)
          .filter(Boolean);
      if (cells.length === 0) continue;
      candidate = cells.join(' | ');
      if (genericTableHeader.test(candidate) && !explicitNormative.test(candidate)) continue;
    }

    if (!isCandidateNormative(candidate, section, kind)) continue;
    const text = cleanMarkdown(candidate);
    if (!text || extracted.some(item => item.section === section && item.text === text)) continue;
    serial += 1;
    extracted.push({
      file,
      section,
      requirementId: `${docId(file)}-${String(serial).padStart(3, '0')}`,
      text,
      sourceKind: kind,
    });
  }
  return extracted;
}

const requirements = standards.flatMap(extractRequirements);
const requirementsByFile = new Map(standards.map(file => [file, requirements.filter(item => item.file === file)]));
const unextractedDocs = standards.filter(file => (requirementsByFile.get(file) ?? []).length === 0);
if (unextractedDocs.length > 0) {
  throw new Error(`CURRENT_EFFECTIVE documents with zero structurally extracted rules: ${unextractedDocs.join(', ')}`);
}

const runtimeInventory = recordsFromCsv(readFileSync('docs/PHOENIX_CURRENT_ACTIVE_JOURNEY_INVENTORY.csv', 'utf8'));
if (runtimeInventory.length === 0) {
  throw new Error('Current active runtime Journey inventory is empty');
}
const allJourneys = runtimeInventory.map(row => row.JOURNEY_ID).filter(Boolean);
if (new Set(allJourneys).size !== allJourneys.length) {
  throw new Error('Duplicate Journey identity in current active runtime inventory');
}
const journeyById = new Map(runtimeInventory.map(row => [row.JOURNEY_ID, row]));

const contractRules = [
  {
    id: 'HUMAN_OR_FOUNDER_GATE',
    pattern: /human|founder|manual review|literary judgment|narrative judgment|visual approval|story approval/i,
    source: 'docs/PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv + Founder review packets',
    kind: 'HUMAN_GATE',
  },
  {
    id: 'CHALLENGE_RUNTIME_CONTRACT',
    pattern: /challenge|paragraphrebuild|grammarrepair|missingsentence|distractor|teach before test/i,
    source: 'app/test/adaptive_challenge_pedagogy_test.dart + app/test/all_gold_challenge_runtime_snapshot_test.dart + app/test/all_gold_challenge_phase2_contract_test.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'SPECIAL_MECHANISM_CONTRACT',
    pattern: /special journey|special mechanism|genre|literary mechanism/i,
    source: 'app/test/special_journey_adaptive_coverage_test.dart + app/test/special_journey_phoenix_level_test.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'VOCABULARY_LEVEL_PROVENANCE_CONTRACT',
    pattern: /hsk|tocfl|vocab|known.word|language level|level calibration|difficulty|word coverage/i,
    source: 'app/test/vocabulary_level_provenance_test.dart + app/test/all_journey_adaptive_levels_test.dart + app/lib/data/phoenix_level_calibration_matrix.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'STORY_NARRATIVE_CONTRACT',
    pattern: /story|narrative|protagonist|relationship|conflict|choice|consequence|climax|ending|memory anchor|anti.template|literary/i,
    source: 'app/test/adaptive_story_quality_test.dart + app/test/journey_semantic_anti_template_gate_test.dart + app/test/journey_story_truth_place_gate_test.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'DISCOVERY_CLOSED_LOOP_CONTRACT',
    pattern: /discovery|cultural mechanism|historical|history|truth|provenance/i,
    source: 'app/test/adaptive_story_quality_test.dart + app/test/fiction_historical_truth_governance_test.dart + app/test/journey_story_truth_place_gate_test.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'MEMORY_COMPLETION_CONTRACT',
    pattern: /memory|completion|reward|stamp|progress/i,
    source: 'app/test/journey_memory_completion_narration_contract_test.dart',
    kind: 'MACHINE',
  },
  {
    id: 'MULTILINGUAL_SEMANTIC_CONTRACT',
    pattern: /pinyin|vietnamese|english|translation|multilingual|language support/i,
    source: 'app/test/all_journey_adaptive_levels_test.dart + app/test/journey_memory_completion_narration_contract_test.dart',
    kind: 'MACHINE_AND_AGENT',
  },
  {
    id: 'NARRATION_AUDIO_CONTRACT',
    pattern: /narration|audio|voice|speech|tts/i,
    source: 'app/test/journey_memory_completion_narration_contract_test.dart + app/test/natural_narration_agent_test.dart + app/test/narration_voice_picker_test.dart',
    kind: 'MACHINE',
  },
  {
    id: 'PERFORMANCE_LAZY_RUNTIME_CONTRACT',
    pattern: /performance|startup|lazy|materializ|first frame|latency|freeze/i,
    source: 'app/test/journey_runtime_performance_gate_test.dart + Startup Performance Audit workflow',
    kind: 'MACHINE',
  },
  {
    id: 'LOCATION_PASSPORT_CONTRACT',
    pattern: /location|passport|continent|country|province|city|geo|map/i,
    source: 'app/test/journey_routing_active_identity_test.dart + Mobile Interaction Audit workflow',
    kind: 'MACHINE',
  },
  {
    id: 'MOBILE_ACCESSIBILITY_INTERACTION_CONTRACT',
    pattern: /mobile|interaction|accessib|safe area|tap target|contrast|one.screen|navigation/i,
    source: 'Mobile Interaction Audit workflow + Flutter CI interaction/accessibility contracts',
    kind: 'MACHINE',
  },
  {
    id: 'ASSET_VISUAL_RIGHTS_CONTRACT',
    pattern: /asset|background|visual|image|rights|license|copyright/i,
    source: 'worker/remaining_journey_dynamic_backgrounds.test.mjs + docs/PHOENIX_VISUAL_RIGHTS_REVIEW_PACKET.md',
    kind: 'MACHINE_AND_HUMAN_WHERE_REQUIRED',
  },
  {
    id: 'DEVELOPMENT_GOVERNANCE_CONTRACT',
    pattern: /branch|pull request|\bpr\b|merge|commit|workflow|baseline|release|deploy|health|sha/i,
    source: 'Exact-head GitHub branch/PR/workflow/release identity evidence',
    kind: 'MACHINE',
  },
];

function contractFor(requirement) {
  const searchable = `${requirement.file} ${requirement.section} ${requirement.text}`;
  const matched = contractRules.find(rule => rule.pattern.test(searchable));
  if (matched) return matched;
  return {
    id: 'REQUIREMENT_SPECIFIC_AGENT_REVIEW',
    source: `docs/PHOENIX_DEEP_AUDIT_REPORT.md#${requirement.requirementId}`,
    kind: 'AGENT',
  };
}

const mappings = requirements.map(requirement => ({ requirement, contract: contractFor(requirement) }));
const unmappedRequirements = mappings.filter(item => !item.contract?.id || !item.contract?.source);
if (unmappedRequirements.length > 0) {
  throw new Error(`UNMAPPED_REQUIREMENTS=${unmappedRequirements.length}`);
}

const standardRows = [[
  'FILE','VERSION','STATUS','EFFECTIVE_SCOPE','REQUIREMENT_COUNT','REQUIREMENT_IDS',
  'HUMAN_GATES','FOUNDER_GATES','MACHINE_GATES','SUPERSEDES','SUPERSEDED_BY','PRECEDENCE',
]];
for (const file of standards) {
  const rows = requirementsByFile.get(file) ?? [];
  standardRows.push([
    file,
    `authority@${baseline}`,
    'CURRENT_EFFECTIVE',
    'Phoenix product/Journey clauses as written',
    rows.length,
    rows.map(row => row.requirementId).join('|'),
    'Explicit Human clauses stay Human',
    'Explicit Founder clauses stay Founder',
    'Requirement-specific runtime/test/action/Agent contract mapping',
    '',
    file.endsWith('PHOENIX_JOURNEY_SYSTEM_STANDARD.md')
      ? 'PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md for visible-stage wording'
      : '',
    'Newer explicit supersession > specific canonical standard > stable baseline > product principles',
  ]);
}
writeFileSync(
  'docs/PHOENIX_CURRENT_STANDARD_INVENTORY.csv',
  standardRows.map(row => row.map(esc).join(',')).join('\n') + '\n',
);

const requirementRows = [[
  'STANDARD','SECTION','REQUIREMENT_ID','SOURCE_KIND','REQUIREMENT','CONTRACT_ID',
  'CONTRACT_KIND','CONTRACT_SOURCE','MAPPING_RESULT','SEMANTIC_PASS',
]];
for (const { requirement, contract } of mappings) {
  requirementRows.push([
    requirement.file,
    requirement.section,
    requirement.requirementId,
    requirement.sourceKind,
    requirement.text,
    contract.id,
    contract.kind,
    contract.source,
    'MAPPED',
    'NOT_ASSERTED_BY_GENERATOR',
  ]);
}
writeFileSync(
  'docs/PHOENIX_CURRENT_EFFECTIVE_REQUIREMENTS.csv',
  requirementRows.map(row => row.map(esc).join(',')).join('\n') + '\n',
);

const matrixRows = [[
  'JOURNEY','JOURNEY_TYPE','GOLD_STATUS','STANDARD','SECTION','REQUIREMENT_ID','REQUIREMENT',
  'APPLICABILITY','CONTRACT_ID','CONTRACT_SOURCE','EVIDENCE_LEVEL','RESULT','DEFECT_CODE',
  'REPAIR_REQUIRED','REPAIR_SHA',
]];
for (const journey of allJourneys) {
  const runtime = journeyById.get(journey) ?? {};
  for (const { requirement, contract } of mappings) {
    const humanGate = contract.kind === 'HUMAN_GATE';
    matrixRows.push([
      journey,
      runtime.JOURNEY_TYPE ?? 'UNKNOWN',
      runtime.GOLD_STATUS ?? 'UNKNOWN',
      requirement.file,
      requirement.section,
      requirement.requirementId,
      requirement.text,
      'APPLICABLE — active runtime Journey unless the requirement-specific audit records N/A with evidence',
      contract.id,
      contract.source,
      humanGate ? 'HUMAN_REQUIRED' : 'MAPPED_REQUIREMENT_SPECIFIC',
      humanGate ? 'HUMAN_GATE' : 'PENDING_REQUIREMENT_SPECIFIC_VERIFICATION',
      '',
      humanGate ? 'NO_MACHINE_REPAIR' : 'VERIFY_OR_REPAIR',
      '',
    ]);
  }
}
writeFileSync(
  'docs/PHOENIX_GLOBAL_REQUIREMENT_JOURNEY_MATRIX.csv',
  matrixRows.map(row => row.map(esc).join(',')).join('\n') + '\n',
);

const humanPacket = readFileSync('docs/PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv', 'utf8');
for (const requiredField of ['CHALLENGE_PROMPT','TAUGHT_SOURCE_TEXT','WHY_EACH_DISTRACTOR_IS_WRONG','HUMAN_RESULT']) {
  if (!humanPacket.startsWith('"JOURNEY_ID"') || !humanPacket.includes(`"${requiredField}"`)) {
    throw new Error(`content-rich Human packet is missing ${requiredField}`);
  }
}
if ((humanPacket.match(/"HUMAN_REVIEW_REQUIRED"/g) || []).length !== 126) {
  throw new Error('content-rich Human packet must contain exactly 126 review checkpoints');
}

const humanRequirementCount = mappings.filter(item => item.contract.kind === 'HUMAN_GATE').length;
const objectiveRequirementCount = requirements.length - humanRequirementCount;
const specialCount = runtimeInventory.filter(row => row.JOURNEY_TYPE === 'SPECIAL').length;
const normalCount = runtimeInventory.filter(row => row.JOURNEY_TYPE === 'NORMAL').length;
const goldCount = runtimeInventory.filter(row => row.GOLD_STATUS === 'APPROVED_GOLD').length;
const candidateCount = runtimeInventory.filter(row => row.GOLD_STATUS === 'GOLD_CANDIDATE').length;

const report = `# Phoenix global current-standard compliance\n\n` +
`Audit authority SHA: \`${baseline}\`\n\n` +
`## Standard extraction authority\n\n` +
`- Current effective standard documents: **${standards.length}**\n` +
`- Total current-effective requirements: **${requirements.length}**\n` +
`- Current-effective documents with unextracted rules: **${unextractedDocs.length}**\n` +
`- Unmapped requirements: **${unmappedRequirements.length}**\n` +
`- Objectively/Agent verifiable requirements: **${objectiveRequirementCount}**\n` +
`- Legitimate Human/Founder requirements: **${humanRequirementCount}**\n\n` +
`Extraction is structural: tables, checkboxes, lists, imperatives, acceptance/blocking language, lifecycle/level/stage sections, and explicit normative verbs are considered. It is not a MUST-only regex.\n\n` +
`## Runtime scope consumed by this generator\n\n` +
`- Active Journeys: **${allJourneys.length}** (${normalCount} normal + ${specialCount} special)\n` +
`- Current Approved Gold: **${goldCount}**\n` +
`- Gold candidates: **${candidateCount}**\n` +
`- Requirement × Journey rows: **${requirements.length * allJourneys.length}**\n\n` +
`The active Journey inventory is consumed from the runtime-generated durable inventory. This generator does not hardcode or rewrite Journey identity counts.\n\n` +
`## Verification semantics\n\n` +
`This generator never converts a keyword match or the existence of a related CI suite into semantic PASS. It maps every extracted clause to a requirement-specific machine, Agent, Human, or Founder evidence contract. Semantic PASS is established only by the deep runtime audit and exact-head qualification that execute those contracts.\n\n` +
`OBJECTIVE CURRENT-STANDARD COMPLIANCE: **NOT ESTABLISHED BY GENERATOR**\n\n` +
`UNEXTRACTED: **${unextractedDocs.length}**\n\n` +
`UNMAPPED: **${unmappedRequirements.length}**\n\n` +
`## Durable evidence\n\n` +
`- \`PHOENIX_CURRENT_STANDARD_INVENTORY.csv\` — current authority with exact per-document requirement counts and IDs.\n` +
`- \`PHOENIX_CURRENT_EFFECTIVE_REQUIREMENTS.csv\` — one row per structurally extracted current-effective requirement and its requirement-specific verification contract.\n` +
`- \`PHOENIX_GLOBAL_REQUIREMENT_JOURNEY_MATRIX.csv\` — active Journey × requirement applicability and verification contract matrix; no generator-created semantic PASS.\n` +
`- \`PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv\` — reusable 14-Gold Lv1/Lv5/Lv10 Human Challenge checkpoints; Human results remain unasserted until a Human records them.\n`;
writeFileSync('docs/PHOENIX_GLOBAL_CURRENT_STANDARD_COMPLIANCE.md', report);

console.log(JSON.stringify({
  currentEffectiveDocuments: standards.length,
  totalCurrentEffectiveRequirements: requirements.length,
  currentEffectiveDocsWithUnextractedRules: unextractedDocs.length,
  unmappedRequirements: unmappedRequirements.length,
  objectiveRequirementCount,
  humanRequirementCount,
  activeJourneys: allJourneys.length,
  normalJourneys: normalCount,
  specialJourneys: specialCount,
  approvedGold: goldCount,
  goldCandidates: candidateCount,
  requirementJourneyRows: requirements.length * allJourneys.length,
  semanticPassesAssertedByGenerator: 0,
}, null, 2));
