# Phoenix New Journey Acceptance Matrix

Use with [Phoenix New Journey Creation Standard](../PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md) and [Phoenix Journey System Standard](../PHOENIX_JOURNEY_SYSTEM_STANDARD.md).

**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## Journey identity

```text
Repository:
Candidate Branch:
Candidate Commit:
Candidate Tree:
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

- Requirement: `MANDATORY` / `CONDITIONAL` / `OPTIONAL`
- Result: `PASS` / `REQUIRES_REVISION` / `REGRESSION` / `BLOCKED` / `NOT_APPLICABLE`
- Evidence Level: `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`
- Founder Approval: `APPROVED` / `REJECTED` / `PENDING` / `NOT_REQUIRED`

Every `MANDATORY` item MUST be `PASS` with `VERIFIED` evidence before Completed. Any regression blocks Ready, merge, expansion, and the next phase.

## Acceptance table

| ID | Acceptance item | Requirement | Expected evidence | Actual evidence | Result | Evidence Level | Issue / Required action | Owner | Founder Approval |
|---|---|---|---|---|---|---|---|---|---|
| NJ-001 | Proposal uniqueness | MANDATORY | Existing-catalog comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-002 | Story uniqueness | MANDATORY | Independent opening, structure, climax, consequence, ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-003 | Cultural authenticity | MANDATORY | Reviewed cultural anchor and sources |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-004 | Protagonist independence | MANDATORY | Independent protagonist with agency |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-005 | Conflict | MANDATORY | Concrete obstacle or dilemma |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-006 | Choice | MANDATORY | Meaningful decision |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-007 | Consequence | MANDATORY | Result caused by action or choice |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-008 | Emotional arc | MANDATORY | Emotional movement from opening to ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-009 | Learning value | MANDATORY | Defined outcomes served by each stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-010 | Vocabulary | MANDATORY | Contextual words and language support |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-011 | Annotation | MANDATORY | Text, pronunciation, segmentation, translation alignment |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-012 | Discovery | MANDATORY | Cultural/context learning distinct from Story |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-013 | Challenge | MANDATORY | Valid task, answer, and feedback |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-014 | Reflection | MANDATORY | Interpretation or emotional prompt |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-015 | Writing | MANDATORY | Meaningful learner production |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-016 | Memory | MANDATORY | Journey-specific recall anchor |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-017 | Completion | MANDATORY | Completion, save, next action, replay |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-018 | Reward | MANDATORY | Correct reward, unlock, and persistence |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-019 | Multilingual alignment | MANDATORY | Meaning and learning intent aligned in all supported languages |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-020 | Narration | CONDITIONAL | Correct language, controls, sync, interruption, fallback |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-021 | Visual concept | MANDATORY | Concept tied to story and PR #137 minimum quality |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-022 | Visual differentiation | MANDATORY | Independent composition, environment, lighting, cultural detail |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-023 | Mobile crop | MANDATORY | Target-phone focal point, readable region, safe area |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-024 | Visual pilot limit | MANDATORY | One Journey, one to three samples, one isolated Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-025 | Routing | MANDATORY | Exact route, component, Journey ID, Story ID, stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-026 | Persistence | MANDATORY | Progress, resume, completion, reward, migration |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-027 | Loading | MANDATORY | Correct asynchronous loading states |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-028 | Error | MANDATORY | Safe error, preserved state, recovery |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-029 | Fallback | MANDATORY | No wrong Journey, language, image, entitlement, or runtime placeholder |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-030 | Accessibility | MANDATORY | Semantics, focus, scaling, contrast, reduced motion, touch targets |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-031 | Performance | MANDATORY | Reproducible no-regression comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-032 | Rights | MANDATORY | Approved source, license, permission, or creation evidence |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-033 | Stable comparison | MANDATORY | Complete STABLE_BASELINE_COMPARISON |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-034 | Founder mobile approval | MANDATORY | Explicit approval tied to candidate Commit or Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-035 | Single-pilot rule | MANDATORY | No second Journey entered implementation |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |

## Phase decision record

| Phase | Inputs | Required deliverables | Evidence | Blockers | Owner | Result | Evidence Level | Next phase authorized |
|---|---|---|---|---|---|---|---|---|
| A: Journey Proposal |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| B: Story and Learning Design |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| C: Visual Concept Pilot |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| D: Implementation |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| E: Automated Validation |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| F: Stable Baseline Comparison |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| G: Founder Mobile Preview |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| H: Approval and Controlled Release |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |

## Final decision

```text
Mandatory Items Total:
Mandatory PASS + VERIFIED:
Mandatory Missing or Failed:
Regression Items:
Blocked Items:
Founder Mobile Approval:
Second Journey Implementation Detected: YES / NO
Stable Baseline Comparison Decision:
Final Journey Decision:
Controlled Release Authorized: YES / NO
```

Any missing Mandatory item blocks Completed.