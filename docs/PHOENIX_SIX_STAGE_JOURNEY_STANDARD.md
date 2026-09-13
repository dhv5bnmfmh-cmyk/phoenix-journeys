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
| 3 | 挑战 | `challenge` | Validate understanding and application through the authoritative 2×6 Challenge architecture. |
| 4 | 回忆 | `memory` | Create a durable Journey-specific recall anchor. |
| 5 | 完成 | `completion` | Commit completion, progress, approved reward, Stamp when applicable, and next action. |

The committed top-level range remains `0–5`.

No Journey may add a seventh or eighth user-visible stage by splitting Reflection or Writing out of Challenge or Memory.

## 3. Challenge stage binding

The one complete and current Challenge definition is [AUTHORITATIVE STORY DEVELOPMENT CONTRACT — Active Challenge contract: 2 × 6](AUTHORITATIVE_STORY_DEVELOPMENT_CONTRACT.md#active-challenge-contract-2--6). This Six-Stage Standard owns only the stage boundary: Challenge remains stage `3`, every Lv1–Lv10 run completes exactly 12 questions before Memory, and Reward quantity, wallet rules, and idempotency remain governed by the approved Reward system.

Acceptance, authoring, family semantics, quality gates, progression, anti-template rules, human review, and all-Gold convergence MUST use that single authoritative definition. This document MUST NOT duplicate or redefine it.

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
- presence and canonical runtime mapping of all six Challenge families and 2×6 counts;
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
- one of the six Challenge families or any required authored question is absent;
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
- Semantic Sentence Rebuild (2):
- Grammar Repair (2):
- Context Completion (2):
- Story Evidence / Understanding (2):
- Knowledge / Spatial Reasoning (2):
- Scenario / Route Decision (2):
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

A Journey is complete only when the exact six-stage product, the complete 2×6 Challenge architecture, narrative quality, semantic alignment, runtime behavior, stable comparison, exact-Head Preview, and required Founder decision are all independently verified.

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
