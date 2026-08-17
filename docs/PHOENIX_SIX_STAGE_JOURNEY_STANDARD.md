# Phoenix Six-Stage Journey Standard

**System:** Phoenix Product Standard System v1.2
**Status:** BINDING  
**Effective scope:** all new Journeys, Story repairs, Journey flow changes, acceptance matrices, quality gates, previews, and release decisions; §3 Challenge Gold additionally governs every current Founder-approved Gold Journey, every remediated/modified Journey, and every future Gold promotion candidate
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Normative precedence

This document is the authoritative product-stage standard for Phoenix Journeys.

Where an older Phoenix document describes `Reflection` or `Writing` as required standalone Journey stages, this standard supersedes that stage requirement. Reflection and writing may remain as learning intents, prompt-design techniques, legacy persistence fields, or internal evidence categories, but they MUST NOT appear as additional user-visible Journey stages unless a later Founder-approved binding standard explicitly replaces this document.

All new work MUST obey:

> **NEW RESULT >= CURRENT STABLE BASELINE**

## 2. Canonical user-visible flow

Every normal and special Journey MUST use exactly these six committed stages:

| Step | Chinese label | Canonical ID | Required purpose |
|---:|---|---|---|
| 0 | 故事 | `story` | Deliver the Journey-specific narrative and language input. |
| 1 | 单词 | `vocabulary` | Teach selected vocabulary in Story or Discovery context. |
| 2 | 发现 | `discovery` | Add cultural, historical, spatial, social, ecological, technical, or literary understanding without retelling Story. |
| 3 | 挑战 | `challenge` | Validate understanding and application through all three required Challenge modes. |
| 4 | 回忆 | `memory` | Create a durable Journey-specific recall anchor. |
| 5 | 完成 | `completion` | Commit completion, progress, approved reward, Stamp when applicable, and next action. |

The committed top-level range remains `0–5`.

No Journey may add a seventh or eighth user-visible stage by splitting Reflection or Writing out of Challenge or Memory.

## 3. Required Challenge modes

Every Journey Challenge MUST contain all three modes:

1. `paragraphRebuild` — 段落重组
2. `grammarRepair` — 语法修复
3. `missingSentence` — 补全句子

Acceptance rules:

- all three modes are REQUIRED;
- all three must use Journey-specific Story or Discovery content;
- all three must provide valid answer logic and visible feedback;
- all three must be completed before Memory becomes available;
- mode order may be fixed by the product, but a Journey may not silently omit a mode;
- difficulty adaptation may change wording, number of items, distractors, grammar density, and support, but must preserve learning intent and answer validity;
- Reward quantity, wallet rules, and idempotency remain governed by the existing approved Reward system.

### 3.1 Phoenix Challenge Gold quality contract

Challenge is a **verification and reorganization layer**, not a warehouse for new teaching. Its canonical chain is:

> **TAUGHT CONTENT → CLEAR LEARNING INTENT → FAIR QUESTION → PLAUSIBLE DISTRACTORS → ONE DEFENSIBLE ANSWER → DIAGNOSABLE MISUNDERSTANDING → LEVEL-APPROPRIATE REASONING → STORY + LANGUAGE + CULTURE REINFORCEMENT**

Every active Challenge item MUST satisfy all of the following:

1. **TEACH BEFORE TEST.** Any historical fact, cultural concept, Story relationship/turn, or language structure necessary for the answer MUST already be taught in the current or an earlier level through active Story, Vocabulary, or Discovery. Synthesis and inference are allowed; untaught core knowledge is not.
2. **One primary learning intent.** Each item MUST have exactly one primary intent: `LANGUAGE`, `STORY`, `HISTORY`, `CULTURE`, or `CAUSAL_REASONING`. Secondary intents are allowed. The item MUST have a defensible learning reason to exist and MUST NOT be filler generated from a random sentence.
3. **Mode differentiation.** `paragraphRebuild` primarily tests structure, sequence, time, or causal order; it MUST NOT reduce to punctuation/length guessing or sentence memorization. `grammarRepair` primarily tests language structure; its defect MUST be genuine, explainable, level-appropriate, and unambiguous rather than a history-trivia trap. `missingSentence` primarily tests comprehension and inference across context; it MUST NOT reduce to keyword matching or verbatim recall alone. If all three modes effectively test memorization of the same source sentence, Challenge Gold fails.
4. **One defensible best answer.** The intended answer MUST be uniquely supportable from taught Journey context and level-appropriate Chinese. If two options remain reasonably defensible, rewrite the item; do not declare one correct by author intent. External knowledge, test-pattern guessing, tricks, and extreme-detail trivia are prohibited dependencies.
5. **Gold distractors.** A distractor MUST be plausible but wrong for a teachable reason. Preferred misconception classes include wrong sequence, reversed causality, relationship confusion, Goal/Consequence confusion, a taught true fact used in the wrong context, cultural misunderstanding, or a language-structure misconception. Absurd answers, random noun/city/person swaps, broken grammar unrelated to the learning intent, other-Journey material, inactive/legacy text, and cheap fabricated history are prohibited. Historical Truth applies to Challenge.
6. **Diagnosable misunderstanding.** Human audit MUST be able to state what misunderstanding each distractor represents. This is content-design evidence and does not require new feedback UI.
7. **Closed learning loop.** Story and Discovery provide experience and verified knowledge; Challenge asks the learner to reorganize, apply, compare, or infer from that taught material. Chinese learning remains active even when history or culture supplies the context.
8. **Provenance.** Every item MUST trace to active Story, active Discovery, active Vocabulary, or an explicit current language objective. Legacy seed text, old Story, another Journey, random cultural trivia, and inactive content are blocking defects.
9. **Fairness.** Phoenix Challenge may be challenging, but MUST NOT be tricky. The learner must be able to answer from the Journey already experienced plus the expected language ability for that level.
10. **Cognitive progression.** Subject to the canonical Three Gradients and Five Cognitive Bands, the default Challenge progression is: Lv1–2 recognition/basic comprehension; Lv3–4 sequence/simple causality; Lv5–6 relationship/choice/historical cause; Lv7–8 causal chain/implicit meaning; Lv9–10 integrated interpretation. Higher level means deeper reasoning, not merely longer questions, longer vocabulary, more options, or colder trivia.

For Story-sourced items, prefer people, relationship, Goal, Conflict, Choice, Cost, Consequence, Transformation, sequence, or subtext over isolated noun recall. For Discovery-sourced items, prefer understanding, sequence, causality, connection, change, and cultural meaning over year/number memorization unless the exact fact is an explicit level target.

### 3.2 Challenge Gold human gate

Machine checks are necessary but cannot approve fairness, naturalness, misconception quality, or learning value. Every Gold Journey MUST receive human Challenge review at **Lv1, Lv5, and Lv10**. Each review asks: what is the question testing; was it taught; is one answer best; are distractors plausible and diagnosable; is Chinese learning occurring; does Story/culture/history reinforcement fit the level; does the item feel repetitive or machine-filled?

The final human question is: **after completing the Challenge, is the learner clearer about at least one core Story, Chinese, cultural, historical, or causal learning target?** If the learner merely clicked the keyed answer without reinforced understanding, `CHALLENGE GOLD QUALITY = FAIL`.

### 3.3 Gold blocking gates

Before a Journey may enter or retain Gold Challenge status, every applicable canonical gate MUST be `PASS`:

- `CHALLENGE LEARNING INTENT`
- `TEACH BEFORE TEST`
- `MODE DIFFERENTIATION`
- `PARAGRAPH REBUILD QUALITY`
- `GRAMMAR REPAIR QUALITY`
- `MISSING SENTENCE QUALITY`
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

### 3.4 Existing Gold is not grandfathered

**EXISTING GOLD IS NOT GRANDFATHERED AGAINST NEW CANONICAL CHALLENGE QUALITY.** Founder approval, prior Gold status, merge history, or previously green tests do not prove compliance with a later Challenge Gold requirement.

When Challenge Gold governance is newly adopted or materially strengthened, Phoenix MUST audit the **current approved Gold registry from merged current `main` at audit start**. Do not use a remembered count, stale handoff, or historical registry snapshot. Every Gold Journey in that registry MUST be audited at **Lv1-Lv10 across all three active modes**: `paragraphRebuild`, `grammarRepair`, and `missingSentence`. Lv1, Lv5, and Lv10 additionally require the human gate in §3.2. No item may receive `PASS BY LEGACY APPROVAL`.

After the first merge that establishes a materially stronger Challenge Gold contract, the next content-development line MUST be an all-Gold Challenge audit and remediation before a new Journey Story enters development, unless the Founder explicitly changes priority. This convergence requirement does not authorize a parallel branch or PR and does not authorize unrelated product redesign.

### 3.5 All-Gold audit matrix and audit-first policy

The canonical **PHOENIX ALL-GOLD CHALLENGE MATRIX** records one row per `Journey × Level × Mode`. Each row MUST record at least: `JOURNEY ID`, `LEVEL`, `MODE`, `PRIMARY LEARNING INTENT`, optional `SECONDARY INTENT`, `ACTIVE SOURCE`, `SOURCE PROVENANCE`, `TAUGHT BEFORE TESTED`, `CORRECT ANSWER`, `WHY CORRECT`, `ALTERNATIVE ANSWER AMBIGUITY`, `DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION`, `HISTORICAL TRUTH`, `LANGUAGE VALUE`, `STORY / DISCOVERY CONNECTION`, `LEVEL APPROPRIATENESS`, `COGNITIVE BAND`, `LEGACY CONTAMINATION`, `CROSS-JOURNEY CONTAMINATION`, and `RESULT`. `RESULT` is only `PASS` or `REPAIR REQUIRED`.

Global convergence MUST use **AUDIT FIRST**. Do not mass-generate replacement questions before the defect inventory exists. Defects use these canonical audit codes: `TBT` teach-before-test violation; `AMB` ambiguous answer; `DST` weak distractor; `MODE` mode duplication; `PROV` provenance failure; `LEGACY` legacy contamination; `CROSS` cross-Journey contamination; `LEVEL` level mismatch; `PROG` weak cognitive progression; `HIST` historical-truth defect; `LANG` weak Chinese learning value; `LOOP` Story/Discovery closed-loop failure; `TEMPLATE` cross-Journey template repetition.

Repair the smallest real defect. Prefer Challenge content, mapping, distractors, and level binding. If required knowledge is genuinely absent and belongs in the learning package, prefer the minimum Discovery teaching repair or Vocabulary provenance repair. Founder-approved Story spine, Human Story, and Memory Moment remain locked by default; Story is the last teaching layer to reopen and requires a concrete independent reason.

### 3.6 Cross-Gold anti-template and content-shape protection

Challenge quality process is standardized; Challenge content shape is not. **STANDARDIZE THE QUALITY PROCESS. DO NOT STANDARDIZE THE CONTENT SHAPE.**

Cross-Gold human review MUST compare question logic, distractor logic, sentence skeleton, causal-question pattern, missing-sentence trick, paragraph-rebuild pattern, and grammar-error pattern. A remediation that copies one Challenge template and merely swaps city, person, building, artifact, or historical nouns is `TEMPLATE` and fails. Journey-specific Challenge must arise from that Journey's own Story, Discovery, language objective, historical mechanism, human relationship, and cultural identity.

Historical Journeys should, where truthful and level-appropriate, let learners enter history through human experience. Challenge must not collapse into a history quiz: across the Journey it must preserve meaningful balance among Chinese language, Story comprehension, history/culture, and causal reasoning.

### 3.7 Global cognitive and machine/human governance

Every Gold Journey MUST demonstrate real Lv1→Lv10 cognitive growth. The default direction is `Recognition → Sequence → Causality → Relationship → Interpretation → Integrated Understanding`, subject to the canonical Three Gradients, Five Cognitive Bands, and current level governance. Longer sentences, longer options, or colder facts do not establish progression.

Reasonable machine governance includes dynamic Gold-registry coverage, all-Gold Challenge coverage, mode coverage, runtime provenance, level mapping, teach-before-test, legacy and cross-Journey contamination, duplicate distractors, answer structural uniqueness, cognitive-band mapping, historical regression, and Challenge source mapping. Machine checks MUST NOT be described as proving fairness, naturalness, literary quality, or human-designed feel.

All-Gold convergence is complete only when every current Gold Journey is `CHALLENGE GOLD PASS`, every level and mode has been audited, Lv1/Lv5/Lv10 human review passes for every Journey, cross-Gold anti-template review passes, no legacy or cross-Journey contamination remains, full regression passes, and the exact-head Preview passes.

## 4. Story requirements

Every Story MUST provide VERIFIED evidence for:

- independent protagonist identity;
- causal Relationship;
- personal and specific Goal;
- Conflict connected to the Goal;
- enacted Choice;
- visible Consequence caused by the Choice;
- Emotional Arc;
- cultural anchor integrated into action, stakes, relationship, choice, or consequence;
- opening situation or disruption;
- causal progression;
- decisive climax;
- changed ending state;
- Journey-specific Memory Anchor;
- differentiation from the current Journey catalog.

Generic tourism narration, interchangeable city references, shared tourist enrichment, decorative culture, and philosophical-summary-only endings are blocking defects.

## 5. Story and Discovery separation

Story and Discovery MUST each provide a one-sentence Function Contract.

- Story owns protagonist, relationship, goal, conflict, choice, consequence, emotional movement, and ending change.
- Discovery owns verified knowledge that adds understanding without replaying Story events.
- Exact-text difference does not prove functional separation.
- Discovery must not use character names merely to disguise Story repetition.

## 6. Learning intents formerly represented by Reflection and Writing

Reflection and writing remain valid pedagogical intents, but are absorbed into the six-stage design:

- interpretation, emotional response, and short reasoning may appear inside Challenge feedback, Challenge prompts, or Memory;
- meaningful learner-authored output may appear inside an approved Challenge item or Memory response;
- these intents do not create standalone committed stages;
- legacy `wonderDraft`, `expressDraft`, Guide feedback, Writing feedback, composite-substage, or migration fields may remain for backward compatibility, but new Journey UI and progression must not depend on them;
- legacy fields must not reinterpret committed steps `3`, `4`, or `5`.

## 7. Lv.1–10 invariants

Across Phoenix Lv.1 through Lv.10, every effective output MUST preserve:

- protagonist;
- relationship;
- goal;
- conflict;
- key choice;
- caused consequence;
- event order;
- emotional arc;
- cultural anchor;
- ending state;
- Memory Anchor;
- applicable special mechanism.

Adaptation may change vocabulary, grammar, sentence length, paragraph density, support, and explanatory detail. It must not replace a named protagonist with a generic tourist, truncate causal events, or insert unrelated shared enrichment.

## 8. Multilingual requirements

Chinese, pinyin, Vietnamese, and English must align through shared semantic event identity where the Journey provides those variants.

Compression is allowed. Deleting or altering the Goal, Choice, Consequence, ending state, or Memory Anchor is prohibited.

## 9. New Journey lifecycle

A new Journey must pass these gates in order:

1. Proposal and catalog differentiation
2. Story / Discovery design and Function Contracts
3. Vocabulary → Challenge Design → Challenge Gold Audit → Memory → Completion → Reward and multilingual design
4. Visual concept and mobile crop review
5. Authorized implementation
6. Automated structural validation
7. Independent AI semantic audit
8. Stable-baseline comparison
9. Exact-Head isolated Preview
10. Founder mobile experience decision
11. Independent Ready authorization
12. Independent Merge authorization

No later gate may be inferred from an earlier PASS.

## 10. Automated quality gate

Automated checks MUST directly verify, where applicable:

- exact six-stage labels and `0–5` range;
- presence and canonical runtime mapping of all three Challenge modes;
- structurally testable Challenge provenance, duplicate distractors, level coverage, taught-before-tested prerequisites, and answer-key uniqueness;
- Story, Discovery, Vocabulary, Memory, and Completion records;
- Journey IDs, routes, languages, annotations, and asset mappings;
- Lv.1–10 structural invariants;
- no user-visible Reflection or Writing stage registration;
- no Journey-specific stage-label override that replaces Challenge or Memory;
- exact changed paths and exact candidate Commit.

Automated scores cannot approve literary quality, cultural quality, visual quality, or Founder experience.

## 11. Human and Founder gates

Independent AI semantic review MUST evaluate protagonist, Relationship, Goal, Conflict, Choice, Consequence, emotional movement, Story / Discovery separation, library differentiation, and Lv.1–10 identity.

Founder mobile approval is REQUIRED for:

- a new Journey;
- core Journey flow changes;
- visual changes;
- Challenge interaction changes;
- Memory interaction changes.

Every completed modification must provide an exact-Head experience link before Founder approval is requested.

## 12. Blocking conditions

A Journey is blocked when any of the following is true:

- user-visible flow is not exactly Story → Vocabulary → Discovery → Challenge → Memory → Completion;
- one of the three Challenge modes is absent;
- any required Challenge Gold gate in §3.3 fails;
- Reflection or Writing appears as a standalone user-visible stage;
- Story lacks any required causal element;
- Discovery duplicates Story;
- Vocabulary is absent from learner-visible context;
- Memory is generic or not Journey-specific;
- Lv.1–10 loses narrative identity;
- multilingual meaning drifts;
- automated evidence is used as literary approval;
- exact-Head Preview is missing;
- Founder mobile decision is missing when required;
- candidate is below the stable baseline.

## 13. Required acceptance record

Every new or materially repaired Journey must record:

```text
Journey ID:
Candidate Commit:
Stage 0 Story:
Stage 1 Vocabulary:
Stage 2 Discovery:
Stage 3 Challenge:
- paragraphRebuild:
- grammarRepair:
- missingSentence:
Stage 4 Memory:
Stage 5 Completion:
Top-level range 0–5:
Standalone Reflection present:
Standalone Writing present:
Story Function Contract:
Discovery Function Contract:
Narrative invariants:
Lv.1 Result:
Lv.2 Result:
Lv.3 Result:
Lv.4 Result:
Lv.5 Result:
Lv.6 Result:
Lv.7 Result:
Lv.8 Result:
Lv.9 Result:
Lv.10 Result:
Multilingual alignment:
Vocabulary in context:
Reward and persistence:
Stable baseline comparison:
Automated structural result:
Independent AI semantic result:
Preview URL:
Preview release SHA:
Founder mobile result:
Ready authorization:
Merge authorization:
Final decision:
```

## 14. Final rule

A Journey is not complete because files exist, CI is green, or an automated report says `100`.

A Journey is complete only when the exact six-stage product, all three Challenge modes, narrative quality, semantic alignment, runtime behavior, stable comparison, exact-Head Preview, and required Founder decision are all independently verified.

## Memory / Completion narration accessibility

**MEMORY AND COMPLETION MUST SUPPORT USER-INITIATED NARRATION.** This is a shared product requirement inside the existing Stage 5 Memory and Stage 6 Completion surfaces; it does not create an Audio stage or change the six-stage order.

Required behavior:
- a visible, quiet speaker control on Memory and Completion;
- user-initiated play and stop, with no forced autoplay;
- one active narration at a time and no overlapping speech;
- leave-page auto stop, including stage navigation, Journey exit, restart, and level change;
- narration of the current learner-facing content in natural reading order, excluding internal metadata, IDs, debug text, and developer terminology;
- narration must match the learner-facing script/locale currently displayed, including Simplified/Traditional mode;
- accessible play/stop semantics, keyboard/screen-reader reachability, and an adequate mobile touch target;
- graceful empty-content and unavailable-TTS behavior without a crash;
- implementation must reuse Phoenix's shared narration architecture and MUST NOT introduce forced autoplay or a parallel TTS system when the shared runtime can satisfy the requirement.
