# AUTHORITATIVE STORY DEVELOPMENT CONTRACT

**Status:** AUTHORITATIVE ENTRY POINT  
**Purpose:** index and enforce the existing Phoenix Story standards. This file
is the single active Story development entry point and MUST NOT be forked into
Story Standard V2/V3, Challenge V2, candidate rules, or temporary parallel
contracts.

## Binding authority

Story work MUST load and obey all of the following existing authorities:

1. [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md)
2. [Story Depth + Historical Story Universe Appendix](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md)
3. [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md)
4. [Phoenix Six-Stage Journey Standard](PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md)
5. [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md)
6. [Phoenix Product Quality Standard](PHOENIX_PRODUCT_QUALITY_STANDARD.md)
7. [Phoenix Full Application Audit Standard](PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md)
8. [Phoenix Journey Content Quality Gate](journey-content-quality-gate.md)
9. [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md)
10. [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md)
11. [Fast Development Governance V2](FAST_DEVELOPMENT_GOVERNANCE_V2.md)

Where wording overlaps, this authoritative entry point and its binding parent
documents are one contract surface. Destination-specific, candidate,
temporary, historical, or Story-specific workflow text MUST NOT redefine or
bypass them. Active Challenge architecture count MUST remain exactly one.

## Golden product reference

The Founder-approved Golden implementation is the Forbidden City Story
`两条路，一张图` on Journey `beijing-forbidden-city`.

Every future Story inherits its navigation, level mechanism, six-stage page
sequence, Challenge architecture, Challenge shell, audio and feedback
lifecycles, progress, resume, performance, and mobile behavior. A new Story
supplies only its own approved Story and Story-grounded learning data. It MUST
NOT implement a parallel engine, navigation route, lifecycle, fallback,
Challenge shell, candidate workflow, or alternate Preview path.

## Active Challenge contract: 2 × 6

Every Story Level from Lv1 through Lv10 MUST contain exactly **12 Challenge
questions** authored as six capability families, exactly two questions per
family:

1. **Semantic Sentence Rebuild / 语义块复原** × 2
2. **Grammar Repair / 语病修复** × 2
3. **Context Completion / 情境补全** × 2
4. **Story Evidence / Story Understanding / 故事证据与理解** × 2
5. **Beijing / Forbidden City Knowledge & Spatial Reasoning / 北京·紫禁城知识与空间推理** × 2
6. **Scenario / Route Decision / 情境与路线决策** × 2

The previous 4 Sentence Rebuild + 4 Grammar Repair + 4 Story Completion rule is
retired. Git history is the historical record; it MUST NOT remain active in a
second standard or alternate gate.

### Challenge product goal

Challenge combines Story + Chinese + Beijing / Forbidden City + Knowledge +
Reasoning + Decision. Difficulty MUST feel like stronger understanding, not
smaller fragments, more arbitrary blanks, or more repeated templates.

### Mandatory authoring record

Before implementation, every `Story × Level × Question` MUST record:

- question family;
- learning objective;
- knowledge target;
- language target;
- reasoning target;
- question structure;
- correct answer;
- why the answer is correct;
- distractor rationale;
- difficulty;
- Story evidence and/or trusted knowledge source;
- template signature;
- semantic signature.

A count of 12 questions is not authoring evidence.

### Semantic Sentence Rebuild

Rebuild uses natural semantic units, not character atomization. Protected
lexical units and proper nouns such as `紫禁城`, `午门`, `乾清门`, `中轴`,
`秩序`, `路径`, and other meaningful words MUST remain coherent.

Progression:

- Lv1–2: about three clear semantic units and direct relations;
- Lv3–4: more relational structure;
- Lv5–6: temporal, spatial, causal, or compound relations;
- Lv7–8: contrast, conditions, and multi-relation ordering;
- Lv9–10: integrated syntax, knowledge, and plausible ordering.

High level MUST NOT mean single-character splitting or meaningless fragments.
The historical `<=10 Han characters` constraint is retired because it conflicts
with semantic-learning quality. The replacement invariant is: natural complete
Chinese sentence + unique reconstruction + meaningful semantic chunks +
protected lexical coherence + mobile-readable interaction.

### Grammar Repair

Every level has two Grammar questions with different language targets. Across
Lv1–Lv10 they MUST exercise the existing Founder-approved grammar-family
architecture with increasing complexity.

Step 1 asks `哪里错？`. Every selectable segment MUST be a meaningful
grammatical segment. Standalone punctuation (`。 ， ！ ？ ： ；`), empty strings,
broken words, partial lexical fragments, and meaningless character fragments
are hard failures.

Step 2 asks `怎么改？`. All four candidates MUST be complete natural Chinese
sentences. Wrong candidates may be grammatically or logically wrong, but MUST
remain linguistically plausible. Fragment garbage such as `写。`, `写在。`, or
`内廷往。` is prohibited.

After a wrong answer the product MUST expose the user choice, actual error
location, why it is wrong, revision rule, correct modification, and complete
correct sentence. Correct is GREEN; wrong is RED.

### Context Completion

Every level has two context-dependent questions. Completion MUST require Story
context, event sequence, cause, location, character decision, or knowledge
context. The fully restored text MUST be natural, grammatical, meaningful,
Story-valid, and Forbidden-City-valid. Distractors MUST be grammatical-slot
compatible and plausible.

Difficulty is not defined by blank count alone:

- Lv1–2: direct context;
- Lv3–4: sentence relation;
- Lv5–6: cause, sequence, or spatial relation;
- Lv7–8: multi-clue or multi-sentence context;
- Lv9–10: inference and integrated context.

Any historical `Lv1=1 blank … Lv10=10 blanks` rule is retired where it harms
context quality. A level MAY use more than one meaningful blank only when that
improves the learning objective rather than mechanically inflating difficulty.

### Story Evidence / Understanding

Every level has two questions whose answers are supported by the current Story.
Generic common-knowledge MCQ, name recall, and Story-unrelated filler are
prohibited. Progression moves from fact/event recall through evidence selection,
cause, intent, inference, and multi-clue reasoning. The rendered acceptance
artifact MUST record the supporting Story evidence.

### Beijing / Forbidden City Knowledge & Spatial Reasoning

Every level has two questions grounded in existing trusted Journey knowledge
sources. Allowed targets include authentic Beijing / Forbidden City gates,
courtyards, central axis, Outer/Inner Court, spatial relations, architectural
connections, routes, functions, and supported historical/architectural facts.
Knowledge MUST NOT be invented for a question.

Progression moves from direct fact/location to relationship, function/spatial
reasoning, multiple clues, and integrated knowledge reasoning. Ten levels MUST
NOT be a repeated `XX门在哪里？` template with noun substitution.

### Scenario / Route Decision

Every level has two text or structured-MCQ decisions using route choice, field
judgment, information conflict, insufficient evidence, location judgment, or a
travel/work scenario. Answers MUST depend on language comprehension plus Story
context plus trusted place knowledge plus reasoning. Pure common-sense answers
are insufficient.

Reuse the approved Challenge shell. A complex map editor or unrelated UI system
MUST NOT be introduced merely to satisfy this family.

### Whole-Challenge level progression

- Lv1–2: recognition, recall, direct understanding;
- Lv3–4: relationships and simple context;
- Lv5–6: cause, spatial reasoning, language structure;
- Lv7–8: inference and multiple clues;
- Lv9–10: integration, decision, and reasoning.

Adjacent Levels MUST NOT differ only by noun swap, building swap, option order,
punctuation, IDs, or single-slot substitution.

### Global Semantic Anti-Template rule

The existing Semantic Anti-Template gate remains the single active gate and is
extended to Challenge. It MUST inspect the final authored/rendered matrix for:

- exact duplicate;
- normalized duplicate;
- same prompt skeleton;
- slot-swapped duplicate;
- same answer logic;
- same distractor structure;
- adjacent-level copy;
- single-fact repetition.

Classifications are `INTENTIONALLY RELATED`, `MEANINGFULLY DIFFERENT`,
`TRIVIAL VARIATION`, `TEMPLATE DUPLICATE`, and `INVALID`.

Founder Preview is blocked unless:

- `TEMPLATE DUPLICATE = 0`;
- `TRIVIAL VARIATION = 0`;
- `INVALID = 0`.

UI shell reuse is allowed. Question-content template cloning is not.

### Phoenix Challenge Gold quality contract

Challenge is a **verification and reorganization layer**, not a warehouse for new teaching. Its canonical chain is:

> **TAUGHT CONTENT → CLEAR LEARNING INTENT → FAIR QUESTION → PLAUSIBLE DISTRACTORS → ONE DEFENSIBLE ANSWER → DIAGNOSABLE MISUNDERSTANDING → LEVEL-APPROPRIATE REASONING → STORY + LANGUAGE + CULTURE REINFORCEMENT**

Every active Challenge item MUST satisfy all of the following:

1. **TEACH BEFORE TEST.** Any historical fact, cultural concept, Story relationship/turn, or language structure necessary for the answer MUST already be taught in the current or an earlier level through active Story, Vocabulary, or Discovery. Synthesis and inference are allowed; untaught core knowledge is not.
2. **One primary learning intent.** Each item MUST have exactly one primary intent: `LANGUAGE`, `STORY`, `HISTORY`, `CULTURE`, or `CAUSAL_REASONING`. Secondary intents are allowed. The item MUST have a defensible learning reason to exist and MUST NOT be filler generated from a random sentence.
3. **Family differentiation.** Semantic Rebuild tests natural semantic-unit ordering; Grammar Repair tests a genuine, explainable language defect; Context Completion tests contextual inference; Story Evidence tests support from the current Story; Knowledge / Spatial Reasoning tests taught, sourced place knowledge; Scenario / Route Decision integrates Story, place knowledge, language, and reasoning. If families collapse into recall of the same source sentence or a noun-swapped shell, Challenge Gold fails.
4. **One defensible best answer.** The intended answer MUST be uniquely supportable from taught Journey context and level-appropriate Chinese. If two options remain reasonably defensible, rewrite the item; do not declare one correct by author intent. External knowledge, test-pattern guessing, tricks, and extreme-detail trivia are prohibited dependencies.
5. **Gold distractors.** A distractor MUST be plausible but wrong for a teachable reason. Preferred misconception classes include wrong sequence, reversed causality, relationship confusion, Goal/Consequence confusion, a taught true fact used in the wrong context, cultural misunderstanding, or a language-structure misconception. Absurd answers, random noun/city/person swaps, broken grammar unrelated to the learning intent, other-Journey material, inactive/legacy text, and cheap fabricated history are prohibited. Historical Truth applies to Challenge.
6. **Diagnosable misunderstanding.** Human audit MUST be able to state what misunderstanding each distractor represents. This is content-design evidence and does not require new feedback UI.
7. **Closed learning loop.** Story and Discovery provide experience and verified knowledge; Challenge asks the learner to reorganize, apply, compare, or infer from that taught material. Chinese learning remains active even when history or culture supplies the context.
8. **Provenance.** Every item MUST trace to active Story, active Discovery, active Vocabulary, or an explicit current language objective. Legacy seed text, old Story, another Journey, random cultural trivia, and inactive content are blocking defects.
9. **Fairness.** Phoenix Challenge may be challenging, but MUST NOT be tricky. The learner must be able to answer from the Journey already experienced plus the expected language ability for that level.
10. **Cognitive progression.** Subject to the canonical Three Gradients and Five Cognitive Bands, the default Challenge progression is: Lv1–2 recognition/basic comprehension; Lv3–4 sequence/simple causality; Lv5–6 relationship/choice/historical cause; Lv7–8 causal chain/implicit meaning; Lv9–10 integrated interpretation. Higher level means deeper reasoning, not merely longer questions, longer vocabulary, more options, or colder trivia.

For Story-sourced items, prefer people, relationship, Goal, Conflict, Choice, Cost, Consequence, Transformation, sequence, or subtext over isolated noun recall. For Discovery-sourced items, prefer understanding, sequence, causality, connection, change, and cultural meaning over year/number memorization unless the exact fact is an explicit level target.

### Challenge Gold human gate

Machine checks are necessary but cannot approve fairness, naturalness, misconception quality, or learning value. Every Gold Journey MUST receive human Challenge review at **Lv1, Lv5, and Lv10**. Each review asks: what is the question testing; was it taught; is one answer best; are distractors plausible and diagnosable; is Chinese learning occurring; does Story/culture/history reinforcement fit the level; does the item feel repetitive or machine-filled?

The final human question is: **after completing the Challenge, is the learner clearer about at least one core Story, Chinese, cultural, historical, or causal learning target?** If the learner merely clicked the keyed answer without reinforced understanding, `CHALLENGE GOLD QUALITY = FAIL`.

### Gold blocking gates

Before a Journey may enter or retain Gold Challenge status, every applicable canonical gate MUST be `PASS`:

- `CHALLENGE LEARNING INTENT`
- `TEACH BEFORE TEST`
- `MODE DIFFERENTIATION`
- `SEMANTIC REBUILD QUALITY`
- `GRAMMAR REPAIR QUALITY`
- `CONTEXT COMPLETION QUALITY`
- `STORY EVIDENCE QUALITY`
- `KNOWLEDGE / SPATIAL REASONING QUALITY`
- `SCENARIO / ROUTE DECISION QUALITY`
- `ONE DEFENSIBLE ANSWER`
- `PLAUSIBLE DISTRACTORS`
- `DIAGNOSABLE MISUNDERSTANDING`
- `HISTORICAL TRUTH IN CHALLENGE`
- `ACTIVE CONTENT PROVENANCE`
- `NO LEGACY CONTAMINATION`
- `NO CROSS-JOURNEY CONTAMINATION`
- `LEVEL-APPROPRIATE REASONING`
- `COGNITIVE PROGRESSION`
- `STORY / DISCOVERY CLOSED LOOP`
- `LANGUAGE LEARNING VALUE`
- `LV1 HUMAN CHALLENGE REVIEW`
- `LV5 HUMAN CHALLENGE REVIEW`
- `LV10 HUMAN CHALLENGE REVIEW`

`DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION LOGIC`, `CHALLENGE PROVENANCE`, `LEVEL PROGRESSION`, `HISTORICAL TRUTH`, and `HUMAN CHALLENGE REVIEW` remain valid compatibility labels for evidence already recorded under the gates above; they do not define parallel standards. **Any required gate failure means `GOLD CHALLENGE = FAIL`.** A machine PASS cannot substitute for a human gate.

### Existing Gold is not grandfathered

**EXISTING GOLD IS NOT GRANDFATHERED AGAINST NEW CANONICAL CHALLENGE QUALITY.** Founder approval, prior Gold status, merge history, or previously green tests do not prove compliance with a later Challenge Gold requirement.

When Challenge Gold governance is newly adopted or materially strengthened, Phoenix MUST audit the **current approved Gold registry from merged current `main` at audit start**. Do not use a remembered count, stale handoff, or historical registry snapshot. Every Gold Journey in that registry MUST be audited at **Lv1-Lv10 across all six active families**, with exactly two authored questions per family. Lv1, Lv5, and Lv10 additionally require the human gate in §3.2. No item may receive `PASS BY LEGACY APPROVAL`.

After the first merge that establishes a materially stronger Challenge Gold contract, the next content-development line MUST be an all-Gold Challenge audit and remediation before a new Journey Story enters development, unless the Founder explicitly changes priority. This convergence requirement does not authorize a parallel branch or PR and does not authorize unrelated product redesign.

### All-Gold audit matrix and audit-first policy

The canonical **PHOENIX ALL-GOLD CHALLENGE MATRIX** records one row per `Journey × Level × Question`. Each row MUST record at least: `JOURNEY ID`, `LEVEL`, `QUESTION`, `FAMILY`, `PRIMARY LEARNING INTENT`, optional `SECONDARY INTENT`, `ACTIVE SOURCE`, `SOURCE PROVENANCE`, `TAUGHT BEFORE TESTED`, `CORRECT ANSWER`, `WHY CORRECT`, `ALTERNATIVE ANSWER AMBIGUITY`, `DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION`, `HISTORICAL TRUTH`, `LANGUAGE VALUE`, `STORY / DISCOVERY CONNECTION`, `LEVEL APPROPRIATENESS`, `COGNITIVE BAND`, `LEGACY CONTAMINATION`, `CROSS-JOURNEY CONTAMINATION`, and `RESULT`. `RESULT` is only `PASS` or `REPAIR REQUIRED`.

Global convergence MUST use **AUDIT FIRST**. Do not mass-generate replacement questions before the defect inventory exists. Defects use these canonical audit codes: `TBT` teach-before-test violation; `AMB` ambiguous answer; `DST` weak distractor; `MODE` mode duplication; `PROV` provenance failure; `LEGACY` legacy contamination; `CROSS` cross-Journey contamination; `LEVEL` level mismatch; `PROG` weak cognitive progression; `HIST` historical-truth defect; `LANG` weak Chinese learning value; `LOOP` Story/Discovery closed-loop failure; `TEMPLATE` cross-Journey template repetition.

Repair the smallest real defect. Prefer Challenge content, mapping, distractors, and level binding. If required knowledge is genuinely absent and belongs in the learning package, prefer the minimum Discovery teaching repair or Vocabulary provenance repair. Founder-approved Story spine, Human Story, and Memory Moment remain locked by default; Story is the last teaching layer to reopen and requires a concrete independent reason.

### Cross-Gold anti-template and content-shape protection

Challenge quality process is standardized; Challenge content shape is not. **STANDARDIZE THE QUALITY PROCESS. DO NOT STANDARDIZE THE CONTENT SHAPE.**

Cross-Gold human review MUST compare question logic, distractor logic, sentence skeleton, Context Completion logic, Semantic Rebuild pattern, grammar-error pattern, Story-evidence logic, spatial reasoning, and scenario decisions. A remediation that copies one Challenge template and merely swaps city, person, building, artifact, or historical nouns is `TEMPLATE` and fails. Journey-specific Challenge must arise from that Journey's own Story, Discovery, language objective, historical mechanism, human relationship, and cultural identity.

Historical Journeys should, where truthful and level-appropriate, let learners enter history through human experience. Challenge must not collapse into a history quiz: across the Journey it must preserve meaningful balance among Chinese language, Story comprehension, history/culture, and causal reasoning.

### Global cognitive and machine/human governance

Every Gold Journey MUST demonstrate real Lv1→Lv10 cognitive growth. The default direction is `Recognition → Sequence → Causality → Relationship → Interpretation → Integrated Understanding`, subject to the canonical Three Gradients, Five Cognitive Bands, and current level governance. Longer sentences, longer options, or colder facts do not establish progression.

Reasonable machine governance includes dynamic Gold-registry coverage, all-Gold Challenge coverage, family coverage, runtime provenance, level mapping, teach-before-test, legacy and cross-Journey contamination, duplicate distractors, answer structural uniqueness, cognitive-band mapping, historical regression, and Challenge source mapping. Machine checks MUST NOT be described as proving fairness, naturalness, literary quality, or human-designed feel.

All-Gold convergence is complete only when every current Gold Journey is `CHALLENGE GOLD PASS`, every level and family has been audited, Lv1/Lv5/Lv10 human review passes for every Journey, cross-Gold anti-template review passes, no legacy or cross-Journey contamination remains, full regression passes, and the exact-head Preview passes.


### Challenge UI and audio lifecycle

The Challenge shell is shared across all six families.

Before final question submission, the bottom action row is:

`上一步 | 提交`

The dead page-level `完成挑战后继续` CTA is prohibited. Grammar Step 1 MUST NOT
introduce a separate primary `确认位置` row; the shared bottom-right `提交`
action advances the two-step Grammar interaction. After final submission,
feedback remains visible and the primary action becomes `下一题`; only after the
last question is resolved may Challenge complete and move to the next stage.

Feedback audio is distinct from question/narration audio:

- PRE-SUBMIT: feedback speaker absent;
- POST-SUBMIT: approved feedback/audio behavior available;
- NEXT QUESTION: feedback/audio state reset;
- previous-question state MUST NOT leak forward.

The existing narration/audio engine remains authoritative. No Challenge-specific
parallel audio engine is permitted.

## Mandatory order

The product lifecycle is one pipeline:

1. AUTHORITATIVE PREFLIGHT
2. IMPLEMENT
3. LOCAL / RENDERED ACCEPTANCE
4. FOUNDER PREVIEW GATE
5. FOUNDER DEVICE ACCEPTANCE
6. FULL RELEASE GOVERNANCE

No alternate Preview, Story-specific one-pass workflow, manual deploy bypass,
or temporary Challenge workflow may replace this order.

## Layer 1 — Authoring / Preflight

Before Story or Challenge product code is written, the existing design and
acceptance matrices MUST prove:

- `CONTRACT_LOADED = YES`
- `GOLDEN_STORY_LOADED = YES`
- `STORY_QUALITY_REQUIREMENTS = PASS`
- `LV1_LV10_CONTENT_PLAN = COMPLETE`
- `ALL_REQUIRED_STAGES = DEFINED`
- `CHALLENGE_2X6_PLAN = COMPLETE`
- `CHALLENGE_QUESTION_RECORDS = 120` for the Golden Lv1–Lv10 reference
- `MISSING_CELLS = 0`
- `SILENT_FALLBACK = 0`
- `KNOWLEDGE_SOURCES = DEFINED`
- `TEMPLATE_DUPLICATE = 0`
- `TRIVIAL_VARIATION = 0`
- `INVALID_QUESTION = 0`

Missing content is a hard failure. Another Story, a previous level, generic
fixture, generated filler, template question, or shared Story content MUST NOT
be substituted. Story quality and historical truth are reviewed before
learning-stage generation; exercises MUST NOT reverse-assemble the Story.

## Layer 2 — Founder Preview Gate

Before Founder receives a Preview, the exact candidate MUST pass:

1. actual rendered Lv1–Lv10 acceptance;
2. all 120 Golden Challenge questions rendered and recorded;
3. `challenge-rendered-matrix.json`;
4. `challenge-semantic-uniqueness-report.json`;
5. Semantic Anti-Template (`TEMPLATE DUPLICATE=0`, `TRIVIAL VARIATION=0`, `INVALID=0`);
6. targeted product contracts;
7. `flutter analyze`;
8. performance regression;
9. basic mobile WebKit smoke, sampling at least Lv1/Lv3/Lv5/Lv7/Lv10 and all six Challenge families;
10. BUILD ARTIFACT A ONCE;
11. validate Artifact A;
12. deploy the SAME Artifact A;
13. strict exact health equality;
14. deployed mobile WebKit smoke.

The rendered matrix records at minimum: level, question index, family, prompt,
body, final options, correct answer, reasoning, knowledge source, Story source,
difficulty, template signature, semantic signature, feedback, pre-submit audio
state, post-submit audio state, and PASS/FAIL.

When Layer 2 passes, Founder Preview is returned immediately. Full Governance
MUST NOT delay first device acceptance.

## Layer 3 — Full Release Governance

Only after Founder Preview / device acceptance does the same exact product SHA
enter one Full Governance path covering Full Flutter, Quality, release/build
integrity, same-artifact truth, exact health, deployed smoke, and Publish.
Preview artifacts MAY be safely reused only when the existing release contract
can prove artifact identity. Otherwise a fresh exact-SHA release build is
allowed, but the release must still obey BUILD → VALIDATE SAME ARTIFACT → DEPLOY
SAME ARTIFACT.

## No silent fallback

Required Story / Level / Challenge / Vocabulary / Discovery content missing at
runtime is a hard failure. The product MUST NOT silently load another Story,
base/default Level, generic Challenge, shared content fixture, or previous-level
content. `BYPASS PATH = NONE` is permanent.

## Validation consolidation

Story/Challenge validation is intentionally limited to the three layers above.
Story-specific, candidate-only, duplicate semantic audits, duplicate Challenge
audits, duplicate Preview checks, and obsolete one-pass workflows MUST be
removed when the authoritative suite covers the same requirement at the same
evidence level. Independent coverage MUST be preserved.

Deploy, Publish, and release workflows MUST invoke
`.github/scripts/enforce_authoritative_story_contract.sh` before building or
deploying. The static governance test rejects a workflow that can publish Story
product without this entry point.

## Rejected implementation

`交接前的标记` and
`story.forbidden_city.modern_evidence_handoff.v1` are Founder-rejected and MUST
remain absent from product source, runtime registries, fallbacks, fixtures,
generators, tests, Preview harnesses, and release paths.
