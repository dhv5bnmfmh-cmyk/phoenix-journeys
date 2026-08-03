# Phoenix Full Application Audit Matrix

Use with [Phoenix Full Application Audit Standard](../PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md), [Phoenix Narrative and Discovery Standard](../PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), and [Phoenix Product Quality Standard](../PHOENIX_PRODUCT_QUALITY_STANDARD.md).

**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Audit identity

```text
Repository:
Audited Branch:
Audited Commit:
Audited Tree:
Expected Main:
Actual Main:
Stable PR: #137
Stable Commit: 5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977
Audit Mode: READ_ONLY
Remote Writes:
Auditor:
Audit Date:
```

## 2. Allowed values

- Result: `PASS` / `REQUIRES_REVISION` / `REGRESSION` / `BLOCKED` / `NOT_APPLICABLE`
- Evidence Level: `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`
- Issue Severity: `NONE` / `P0` / `P1` / `P2` / `P3`

Issue Severity rules are defined by Phoenix Full Application Audit Standard and MUST NOT be changed by this matrix.

## 3. Core coverage

| Audit ID | Area | Required scope | Exact evidence | Result | Evidence Level | Issue Severity | Finding ID | Owner | Required action |
|---|---|---|---|---|---|---|---|---|---|
| FA-001 | Baseline identity | Repository, branch, audited Commit, main, Stable PR, Stable Commit |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-002 | Runtime release identity | Reachability, release marker, deployed Commit, production hostname |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-003 | Major surfaces | Startup, HomeShell, Explore, Picker, Passport, special Passport, Profile, Shadowing, all Journey stages, dialogs, fallback |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-004 | Routing | Exact routes, IDs, invalid IDs, no wrong-content fallback |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-005 | Access / entitlement | Development, production, free, paid, locked, unlocked, direct, restored, stale, offline |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-006 | Random / Daily | Stable identifier, local date, timezone, morning/afternoon, refresh, restart |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-007 | Persistence | Active Journey, stage, drafts, narration, completion, reward, wallet, unlock, saved words, migration, failure recovery |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-008 | Language | Simplified, Traditional, English, Vietnamese, bilingual, fallback, accessibility labels |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-009 | Narration | Story and Discovery playback, speed, temporary audio, progress, interruption, failure, accessibility |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-010 | Shadowing | Permission, initialization, recording, recognition, route changes, history |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-011 | Mobile | Narrow phone, large phone, landscape, keyboard, large text, Safe Area, scrolling, reduced motion |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-012 | Accessibility | Semantics, focus, scaling, contrast, non-color feedback, assistive input |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-013 | Visual mapping | 36 Journeys, stage assets, badges, stamps, fallback identity |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-014 | Runtime visual quality | Crop, focal point, text-safe area, clarity, composition, placeholder, small-screen behavior |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-015 | Physical assets | Declarations, paths, existence, extension, bundle, mapping, orphan inventory |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-016 | Rights | Source, license, permission, modification, attribution, runtime path, approval |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-017 | Privacy / processors | OpenAI, Cloudflare, TTS, speech recognition, logs, retention, disclosure, account data, deletion |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-018 | Stable comparison | Domain-by-domain comparison and regressions |  | BLOCKED | UNVERIFIED | NONE |  |  |  |

## 4. Narrative and Discovery coverage

Complete one Journey-level row per Journey and one library-level record for the full catalog.

| Audit ID | Coverage row | Required evidence | Actual evidence | Result | Evidence Level | Issue Severity | Finding ID | Owner | Required action |
|---|---|---|---|---|---|---|---|---|---|
| FA-ND-001 | Story Function | One-sentence Function Contract and unique Story value per Journey |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-002 | Discovery Function | One-sentence Function Contract and unique Discovery value per Journey |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-003 | Story / Discovery Separation | Story-only and Discovery-only information, overlap, justification, functional review |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-004 | Narrative Engines | Declared engine, causal operation, catalog comparison, substitution test |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-005 | Opening Patterns | Opening type, active situation, repeated opening-system review |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-006 | Ending Patterns | Caused result, changed state, repeated ending-system review |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-007 | Protagonist Modes | Normal and special mode compliance; generic second person rejected |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-008 | Relationship Causality | Relationship affects Goal, Conflict, Choice, Consequence, Arc, or Ending |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-009 | Enacted Choice | Exact action or commitment, not internal thought alone |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-010 | Consequence Causality | Visible result caused by Choice |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-011 | Cultural Anchor in Action | Non-decorative anchor affecting action or stakes |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-012 | Catalog Differentiation | Complete library differentiation matrix and closest comparisons |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-013 | Level Invariants | Phoenix Lv.1 through Lv.10 preserve narrative invariants |  | BLOCKED | UNVERIFIED | NONE |  |  |  |
| FA-ND-014 | Automated Literary Approval Boundary | Separate automated structural and human literary results |  | BLOCKED | UNVERIFIED | NONE |  |  |  |

## 5. Journey-level narrative record

Duplicate this block for all 36 Journeys or the current verified catalog total.

```text
Journey ID:
Journey Type:
Story Function:
Discovery Function:
Protagonist Mode:
Protagonist Identity:
Relationship and causal function:
Goal:
Conflict:
Enacted Choice:
Caused Consequence:
Emotional Arc:
Cultural Anchor in Action:
Narrative Engine:
Opening Type:
Progression:
Climax:
Ending State:
Memory Anchor:
Special Mechanism:
Story-only Information:
Discovery-only Information:
Intentional Overlap:
Functional Duplication Detected: YES / NO
Closest Catalog Journeys:
Automated Structural Result:
Automated Structural Evidence Level:
Human Literary Result:
Human Literary Evidence Level:
Blocking Codes:
Finding ID:
```

## 6. Library differentiation matrix

| Journey ID | Title pattern | Opening pattern | Protagonist / role | Relationship | Goal / Conflict | Choice / Consequence | Emotional arc | Engine | Climax | Ending | Daily-life setting | Cultural anchor | Perspective | Interpersonal method | Pace | Theme | Memory anchor | Visual motif | Special mechanism | Result | Evidence Level |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | BLOCKED | UNVERIFIED |

## 7. Level-invariant audit

| Journey ID | Lv.1 | Lv.2 | Lv.3 | Lv.4 | Lv.5 | Lv.6 | Lv.7 | Lv.8 | Lv.9 | Lv.10 | Identity loss | Special mechanism flattened | Result | Evidence Level | Finding ID |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  | BLOCKED | UNVERIFIED |  |

Each level cell records whether protagonist, Relationship, Goal, Conflict, Choice, Consequence, event order, Emotional Arc, cultural anchor, ending state, memory anchor, and special mechanism are preserved.

## 8. Finding ledger

```text
Finding ID:
Related Findings:
Audit IDs:
Issue Severity:
Result:
Evidence Level:
Area:
Pages:
Paths:
Routes:
Journey IDs:
Stages:
Expected:
Actual:
Stable Baseline Evidence:
Candidate Evidence:
Runtime Evidence:
User Impact:
Reach:
Recoverability:
Required Action:
Owner:
Verification Needed:
Founder Approval Required:
Repair Dependencies:
Status:
```

## 9. Final coverage and decision

```text
Major Surfaces Audited:
Normal Journeys Audited:
Special Journeys Audited:
Story Function Contracts:
Discovery Function Contracts:
Story / Discovery Separation Records:
Narrative Engines Reviewed:
Opening Patterns Reviewed:
Ending Patterns Reviewed:
Catalog Differentiation Coverage:
Level-Invariant Coverage:
Automated Structural Coverage:
Human Literary Coverage:
P0:
P1:
P2:
P3:
Blocked Evidence Areas:
Regression Count:
Remote Writes:
Final Audit Decision:
```

A complete matrix may still conclude `FINAL_AUDIT_COMPLETE_WITH_BLOCKED_EVIDENCE`. Missing core inventory or an incomplete deduplicated ledger requires `BLOCKED_CRITICAL_COVERAGE`.
