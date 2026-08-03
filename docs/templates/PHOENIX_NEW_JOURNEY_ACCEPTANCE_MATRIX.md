# Phoenix New Journey Acceptance Matrix

Use with [Phoenix New Journey Creation Standard](../PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md), [Phoenix Journey System Standard](../PHOENIX_JOURNEY_SYSTEM_STANDARD.md), and [Phoenix Narrative and Discovery Standard](../PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md).

**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## Journey identity

```text
Repository:
Candidate Branch:
Candidate Commit:
Candidate Tree:
Parent Commit:
Journey ID:
Story ID:
Journey Type:
City / Realm:
Current Phase:
Preview Link:
Owner:
Reviewer:
```

## Allowed values

- Requirement: `REQUIRED` / `CONDITIONALLY_REQUIRED` / `OPTIONAL`
- Result: `PASS` / `REQUIRES_REVISION` / `REGRESSION` / `BLOCKED` / `NOT_APPLICABLE`
- Evidence Level: `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`
- Founder Approval: `APPROVED` / `REJECTED` / `PENDING` / `NOT_REQUIRED`

Legacy records map `MANDATORY` to `REQUIRED` and `CONDITIONAL` to `CONDITIONALLY_REQUIRED`. New records MUST use the canonical terms above.

Every `REQUIRED` item and every applicable `CONDITIONALLY_REQUIRED` item MUST be `PASS` with `VERIFIED` evidence before Completed. `NOT_APPLICABLE` requires an applicability reason and evidence. Any regression blocks Ready, merge, expansion, and the next phase.

## Acceptance table

| ID | Acceptance item | Requirement | Expected evidence | Actual evidence | Result | Evidence Level | Issue / Required action | Owner | Founder Approval |
|---|---|---|---|---|---|---|---|---|---|
| NJ-001 | Proposal uniqueness | REQUIRED | Existing-catalog comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-002 | Story uniqueness | REQUIRED | Independent opening, structure, climax, consequence, ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-003 | Cultural authenticity | REQUIRED | Reviewed cultural anchor and sources |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-004 | Protagonist independence | REQUIRED | Independent protagonist with agency and evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-005 | Relationship | REQUIRED | Relationship identity, narrative function, influence on the Journey, and exact evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-006 | Goal | REQUIRED | Protagonist goal, why it matters, relationship to the conflict, and exact evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-007 | Conflict | REQUIRED | Concrete obstacle or dilemma connected to the goal |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-008 | Choice | REQUIRED | Meaningful decision |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-009 | Consequence | REQUIRED | Result caused by action or choice |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-010 | Emotional arc | REQUIRED | Emotional movement from opening to ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-011 | Learning value | REQUIRED | Defined outcomes served by each stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-012 | Vocabulary | REQUIRED | Contextual words and language support |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-013 | ReadingAnnotation | CONDITIONALLY_REQUIRED | When Story, Discovery, or other explorer-readable text exists: text, pronunciation, segmentation, and translation alignment. Otherwise: `NOT_APPLICABLE` reason and evidence that no applicable reading text exists. |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-014 | Discovery | REQUIRED | Cultural/context learning distinct from Story |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-015 | Challenge | REQUIRED | Valid task, answer, and feedback |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-016 | Reflection | REQUIRED | Interpretation or emotional prompt |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-017 | Writing | REQUIRED | Meaningful learner production |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-018 | Memory | REQUIRED | Journey-specific recall anchor |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-019 | Completion | REQUIRED | Completion, save, next action, replay |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-020 | Reward | REQUIRED | Correct reward, unlock, and persistence |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-021 | Stamp | CONDITIONALLY_REQUIRED | Required when completion, reward, Passport, collection, or progress design includes Stamp. Otherwise: explicit product design basis, evidence, and `NOT_APPLICABLE`. |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-022 | Multilingual alignment | REQUIRED | Meaning and learning intent aligned in all supported languages |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-023 | Narration | CONDITIONALLY_REQUIRED | Correct language, controls, sync, interruption, fallback when narration exists; otherwise evidence-backed `NOT_APPLICABLE` |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-024 | Visual concept | REQUIRED | Concept tied to story and PR #137 minimum quality |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-025 | Visual differentiation | REQUIRED | Independent composition, environment, lighting, cultural detail |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-026 | Mobile crop | REQUIRED | Target-phone focal point, readable region, safe area |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-027 | Visual pilot limit | REQUIRED | One Journey, one to three samples, one isolated Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-028 | Routing | REQUIRED | Exact route, component, Journey ID, Story ID, stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-029 | Persistence | REQUIRED | Progress, resume, completion, reward, migration |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-030 | Loading | REQUIRED | Correct asynchronous loading states |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-031 | Error | REQUIRED | Safe error, preserved state, recovery |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-032 | Fallback | REQUIRED | No wrong Journey, language, image, entitlement, or runtime placeholder |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-033 | Accessibility | REQUIRED | Semantics, focus, scaling, contrast, reduced motion, touch targets |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-034 | Performance | REQUIRED | Reproducible no-regression comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-035 | Rights | CONDITIONALLY_REQUIRED | Approved source, license, permission, or creation evidence for protected or sourced material; otherwise reasoned `NOT_APPLICABLE` |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-036 | Stable comparison | REQUIRED | Complete `STABLE_BASELINE_COMPARISON`, including Tree, Parent, Routes, Journey IDs, Persistence, Access/Entitlement, and Evidence Levels |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-037 | Founder mobile approval | REQUIRED | Explicit approval tied to candidate Commit or Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-038 | Single-pilot rule | REQUIRED | No second Journey entered implementation |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-039 | Story Function Contract | REQUIRED | One-sentence Story Function, unique learner value, inputs, outputs, exact evidence, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-040 | Discovery Function Contract | REQUIRED | One-sentence Discovery Function, unique learner value, inputs, outputs, exact evidence, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-041 | Story / Discovery Functional Separation | REQUIRED | Story-only and Discovery-only information, intentional overlap, justification, human functional review, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-042 | Narrative Engine Independence | REQUIRED | Declared engine, closest catalog engines, causal operation, substitution test, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-043 | Opening Independence | REQUIRED | Opening type, exact opening evidence, catalog opening-pattern comparison, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-044 | Relationship Causality | REQUIRED | Relationship parties, opening state, causal function, affected Goal/Conflict/Choice/Consequence/Arc/Ending, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-045 | Enacted Choice | REQUIRED | Exact action or commitment evidence, affected state, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-046 | Caused Consequence | REQUIRED | Exact causal link from Choice to visible Consequence, reach, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-047 | Climax and Changed Ending State | REQUIRED | Decisive moment, before/after state, non-summary ending evidence, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-048 | Cultural Anchor in Action | REQUIRED | Approved source, action/stakes effect, non-interchangeability test, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-049 | Catalog-Level Differentiation Matrix | REQUIRED | Complete current-catalog comparison across all required literary dimensions, risks, decisions, evidence, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-050 | Level-Adaptation Narrative Invariants | REQUIRED | Phoenix Lv.1 through Lv.10 matrix preserving identity, causality, event order, cultural anchor, ending, memory anchor, and special mechanism |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-051 | Automated Literary Approval Limitation | REQUIRED | Exact automated-check scope, excluded literary judgments, separate human review, declaration `Automated score used as literary approval: NO` |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-052 | Repair / Creation Pilot Batch Gate | REQUIRED | Work type, batch size, prior pilot Commit and Founder decision, next-phase authorization, Result, and Evidence Level |  | BLOCKED | UNVERIFIED |  |  | PENDING |

## Conditional applicability record

Every `CONDITIONALLY_REQUIRED` item MUST include:

```text
Acceptance Item:
Applicability Condition:
Condition Met: YES / NO
Applicability Evidence:
Result:
Evidence Level:
Reason when NOT_APPLICABLE:
```

A blank conditional decision is `BLOCKED`.

## Phase decision record

| Phase | Inputs | Required deliverables | Evidence | Blockers | Owner | Result | Evidence Level | Next phase authorized |
|---|---|---|---|---|---|---|---|---|
| A: Journey Proposal |  | Narrative engine, Story Function, Discovery Function, opening, climax, ending, catalog matrix, level-invariant plan |  |  |  | BLOCKED | UNVERIFIED | NO |
| B: Story and Learning Design |  | Complete Story / Discovery Design Matrix, causal Relationship, enacted Choice, caused Consequence, functional separation, library review |  |  |  | BLOCKED | UNVERIFIED | NO |
| C: Visual Concept Pilot |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| D: Implementation |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| E: Automated Validation |  | Structural validation with literary-approval boundary |  |  |  | BLOCKED | UNVERIFIED | NO |
| F: Stable Baseline Comparison |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| G: Founder Mobile Preview |  | Story identity, Discovery distinction, emotional continuity, level adaptation, memorability |  |  |  | BLOCKED | UNVERIFIED | NO |
| H: Approval and Controlled Release |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |

## Final decision

```text
Required Items Total:
Required PASS + VERIFIED:
Required Missing or Failed:
Conditionally Required Items Total:
Conditionally Required PASS + VERIFIED:
Conditionally Required NOT_APPLICABLE with Reason + Evidence:
Conditionally Required Missing or Failed:
Regression Items:
Blocked Items:
Blocking Codes:
Automated Structural Result:
Human Literary Result:
Founder Mobile Approval:
Second Journey Implementation Detected: YES / NO
Batch Size:
Stable Baseline Comparison Decision:
Final Journey Decision:
Controlled Release Authorized: YES / NO
```

Any missing `REQUIRED` item or applicable `CONDITIONALLY_REQUIRED` item blocks Completed. A high aggregate score cannot replace any row.
