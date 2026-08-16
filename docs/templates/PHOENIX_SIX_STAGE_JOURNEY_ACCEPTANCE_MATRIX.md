# Phoenix Six-Stage Journey Acceptance Matrix

**Binding standard:** `docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md`  
**Use for:** every new Journey, every material Story or Journey-flow repair, and every current Gold Journey when Challenge Gold re-audit is required.

## Identity

| Field | Required value / evidence | Result | Evidence Level |
|---|---|---|---|
| Journey ID | Unique stable ID |  |  |
| Story ID | Correctly linked Story ID |  |  |
| Journey type | Normal or Special |  |  |
| Candidate Commit | Exact SHA |  |  |
| Candidate Tree | Exact Tree SHA |  |  |
| Stable baseline | Current approved stable identity |  |  |

## Canonical stages

| Step | Stage | Acceptance requirement | Result | Evidence Level |
|---:|---|---|---|---|
| 0 | Story / 故事 | Independent causal narrative |  |  |
| 1 | Vocabulary / 单词 | Selected terms appear in Story or Discovery |  |  |
| 2 | Discovery / 发现 | Adds verified understanding without retelling Story |  |  |
| 3 | Challenge / 挑战 | All three required modes complete before Memory |  |  |
| 4 | Memory / 回忆 | Journey-specific durable recall anchor |  |  |
| 5 | Completion / 完成 | Completion, progress, reward and next action |  |  |

Top-level committed range: `0–5`

Standalone Reflection present: `NO`  
Standalone Writing present: `NO`

## Required Challenge modes

| Mode | Chinese label | Journey-specific content | Answer validity | Feedback | Result |
|---|---|---|---|---|---|
| `paragraphRebuild` | 段落重组 |  |  |  |  |
| `grammarRepair` | 语法修复 |  |  |  |  |
| `missingSentence` | 补全句子 |  |  |  |  |

## Story evidence

| Requirement | Exact evidence | Result | Evidence Level |
|---|---|---|---|
| Protagonist |  |  |  |
| Relationship |  |  |  |
| Goal |  |  |  |
| Conflict connected to Goal |  |  |  |
| Enacted Choice |  |  |  |
| Caused Consequence |  |  |  |
| Emotional Arc |  |  |  |
| Cultural Anchor in action |  |  |  |
| Opening situation |  |  |  |
| Causal progression |  |  |  |
| Climax |  |  |  |
| Changed ending state |  |  |  |
| Memory Anchor |  |  |  |
| Catalog differentiation |  |  |  |

## Function separation

Story Function Contract:

Discovery Function Contract:

Information unique to Story:

Information unique to Discovery:

Intentional overlap and reason:

Functional Separation Result:

## Lv.1–10 invariant matrix

| Level | Protagonist | Relationship | Goal | Conflict | Choice | Consequence | Event order | Ending | Memory Anchor | Result |
|---:|---|---|---|---|---|---|---|---|---|---|
| 1 |  |  |  |  |  |  |  |  |  |  |
| 2 |  |  |  |  |  |  |  |  |  |  |
| 3 |  |  |  |  |  |  |  |  |  |  |
| 4 |  |  |  |  |  |  |  |  |  |  |
| 5 |  |  |  |  |  |  |  |  |  |  |
| 6 |  |  |  |  |  |  |  |  |  |  |
| 7 |  |  |  |  |  |  |  |  |  |  |
| 8 |  |  |  |  |  |  |  |  |  |  |
| 9 |  |  |  |  |  |  |  |  |  |  |
| 10 |  |  |  |  |  |  |  |  |  |  |

## Multilingual alignment

| Event / function | Chinese | Pinyin | Vietnamese | English | Result |
|---|---|---|---|---|---|
| Protagonist |  |  |  |  |  |
| Relationship |  |  |  |  |  |
| Goal |  |  |  |  |  |
| Conflict |  |  |  |  |  |
| Choice |  |  |  |  |  |
| Consequence |  |  |  |  |  |
| Ending |  |  |  |  |  |
| Memory Anchor |  |  |  |  |  |

## Story × Culture × Level content semantics

The six stages remain unchanged. These rows validate content inside existing stages and MUST NOT create standalone Reflection or Writing stages.

| Gate | Required evidence | Result |
|---|---|---|
| Cultural Fact Action Test | Fact/source/Story location/action/pressure/non-exposition/removal effect |  |
| Place Causality | Key Choice materially breaks under generic-place substitution |  |
| Cultural Knowledge Residue | Natural Story-only place/culture understanding by level band |  |
| Story / Discovery Bridge | Story encounter precedes Discovery explanation; no plot retelling |  |
| Discovery depth | `2/2/2/2/3/3/3/3/3/3`, independent sourced aligned units |  |
| Three gradients | Language + Story understanding + cultural understanding |  |
| Five cognitive bands | Event / Place / Relationship×Place / Mechanism / Judgment |  |
| Adjacent semantic delta | New causal/relational/cultural meaning at every Lv2–Lv10 |  |
| Backward completeness | Every level independently contains full Story spine |  |
| Lv10 mastery | Unique action/judgment/capstone beyond Lv9 |  |
| Vocabulary provenance | Current Story + all current active Discovery units |  |
| Learner-visible QA ban | Exact visible-copy sweep |  |

## Runtime and evidence gates

| Gate | Required evidence | Result |
|---|---|---|
| Route and IDs | Exact runtime path and IDs |  |
| Progress and persistence | Restart, resume, repeated action |  |
| Reward idempotency | Failure, retry and reopen |  |
| Vocabulary in context | Story / Discovery source evidence |  |
| Accessibility | Semantics, focus, scaling, reduced motion |  |
| Mobile visual quality | Target iPhone screenshots |  |
| Automated tests | Exact commands, run IDs, terminal results |  |
| AI semantic audit | Separate from automated score |  |
| Stable comparison | `NEW RESULT >= CURRENT STABLE BASELINE` |  |
| Exact-Head Preview | URL and release SHA |  |
| Founder mobile decision | PASS / REQUIRES_REVISION / BLOCKED |  |
| Ready authorization | Independent exact-Head record |  |
| Merge authorization | Independent exact-Head record |  |

## Final decision

Only one:

- `READY_FOR_FOUNDER_EXPERIENCE`
- `REQUIRES_REVISION`
- `SCOPE_EXPANSION_REQUIRED`
- `READY_FOR_MERGE_AUTHORIZATION`
- `MERGED`

## Stage 3 Challenge Gold evidence

Stage 3 remains the existing `challenge` stage and MUST NOT introduce a new user-visible stage or mode. In addition to confirming all three runtime modes, attach the Challenge Gold gate results from [Phoenix Six-Stage Journey Standard §3](../PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes), including Lv1/Lv5/Lv10 human review.

### Stage 3 all-Gold convergence evidence

For current-Gold Challenge re-audit, record the dynamic merged-main Gold registry identity, complete Lv1-Lv10 × three-mode coverage, all canonical §3 blocking gates, the all-Gold matrix result, defect codes and repairs, Lv1/Lv5/Lv10 human review, and cross-Gold anti-template result. Previous Gold approval is not acceptance evidence for a newly introduced Challenge gate.
