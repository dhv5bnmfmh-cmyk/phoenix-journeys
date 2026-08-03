# Phoenix Full Application Audit Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Audit mode:** READ_ONLY unless a separate repair task is explicitly authorized  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

A Full Application Audit establishes one deduplicated product ledger across runtime identity, major pages, Journeys, Story and Discovery, learning stages, language, narration, mobile, accessibility, persistence, access, visuals, rights, privacy, and stable comparison.

Audit does not authorize repair. Every claim MUST identify Result, Evidence Level, exact scope, and evidence.

This standard is binding with [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), Journey System Standard, Product Quality Standard, UI and Visual Standard, and the audit matrix.

## 2. Baseline and read-only gate

Before audit:

- verify exact repository, branch, audited Commit, Stable PR, Stable Commit, and current main;
- verify `docs/PHOENIX_STABLE_BASELINE_STANDARD.md` remains the single normative baseline authority;
- freeze Remote Writes at `0` for read-only audit;
- inventory major surfaces, normal Journeys, special Journeys, vocabulary, visual mappings, and applicable providers;
- stop if main differs from the expected audited Commit.

## 3. Evidence rules

Allowed Results: `PASS`, `REQUIRES_REVISION`, `REGRESSION`, `BLOCKED`, `NOT_APPLICABLE`.

Allowed Evidence Levels: `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, `CONTRADICTORY`.

A static finding does not become PASS because the app opens. Desktop evidence does not create mobile PASS. File existence does not create visual PASS. Production identity cannot be assumed from a reachable hostname.

## 4. Required audit domains

The audit MUST independently cover:

- release identity;
- Startup, HomeShell, Explore, Picker, Passport, special Passport, Profile, Shadowing, all Journey stages, dialogs, and fallback states;
- normal and special Journey inventory;
- routing and invalid IDs;
- access and entitlement;
- Random / Daily behavior;
- persistence, migration, duplicate writes, and failure recovery;
- language and translations;
- narration and Shadowing;
- accessibility and mobile behavior;
- visual mapping and runtime visual quality;
- physical assets, rights, and provenance;
- privacy, external processors, Secret storage, logging, retention, and disclosure;
- stable comparison.

## 5. Narrative and Discovery audit

Each Journey MUST provide one Story Function Contract and one Discovery Function Contract. The audit MUST record them per Journey, not infer them from field presence.

For every Journey, audit:

- protagonist mode and independent identity;
- Relationship causality;
- Goal significance;
- Conflict connection to Goal;
- enacted Choice;
- Consequence causality;
- Emotional Arc;
- cultural anchor in action;
- narrative engine;
- opening pattern;
- progression structure;
- climax;
- changed ending state;
- Story / Discovery functional separation;
- memory anchor;
- special mechanism when applicable;
- Phoenix Lv.1 through Lv.10 narrative invariants.

The audit MUST maintain a library differentiation matrix covering title, opening, protagonist, role, Relationship, Goal, Conflict, Choice, Consequence, Emotional Arc, engine, climax, ending, daily-life setting, cultural anchor, perspective, interpersonal method, pace, theme, memory anchor, visual motif, and special mechanism.

Opening-pattern and ending-pattern review MUST identify repeated systems, not only exact repeated text.

Exact-text difference is insufficient for Story / Discovery separation. Functional duplication is blocking.

## 6. Automated and human results

The audit MUST separate:

```text
Automated Structural Result:
Automated Structural Evidence Level:
Implemented automated checks:
Human Literary Result:
Human Literary Evidence Level:
Human reviewer:
```

Automated scores cannot approve literary quality. `360 / 360 PASS`, `score 100`, `average 100`, and `all fields present` may be reported only for their implemented structural checks.

## 7. Journey-level and library-level evidence

Every Journey receives an independent record. Library-level findings MUST be deduplicated by root cause without losing affected Journey IDs.

Use [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md) for candidate repair evidence and [Phoenix Full Application Audit Matrix](templates/PHOENIX_FULL_APPLICATION_AUDIT_MATRIX.md) for audit coverage.

## 8. Runtime and device evidence

Runtime evidence MUST identify environment, release marker, candidate or audited Commit, route, device or viewport, orientation, text size, language, Journey ID, stage, state, expected result, actual result, Result, Evidence Level, and screenshot or reproducible record where available.

If a real phone, microphone, physical voice, production account, failure injection, or identity-tied runtime is unavailable, retain `BLOCKED` or `PARTIALLY_VERIFIED` and produce exact Founder verification steps.

## 9. Severity and findings

Issue Severity remains:

- `P0`: critical safety, security, legal, destructive-data, or release-isolation impact;
- `P1`: core product failure, broad access/routing/persistence failure, or library-wide material violation;
- `P2`: material quality, governance, content, visual, rights, or evidence gap;
- `P3`: localized minor defect.

Severity MUST follow impact, reach, recoverability, and stable-baseline effect. It MUST NOT be changed to manipulate totals.

One root cause MUST NOT be duplicated across pages. Existing findings are expanded when new evidence belongs to the same cause.

## 10. Required finding record

Every finding includes:

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

## 11. Audit completion

The final report MUST contain baseline identity, Remote Writes, coverage counts, domain decisions, deduplicated counts, blocked evidence, regressions, severity changes, new findings, full ledger, Founder decisions, repair dependencies, recommended repair waves, and read-only confirmation.

Decision values:

- `P0_REQUIRES_IMMEDIATE_ISOLATION`
- `BLOCKED_CRITICAL_COVERAGE`
- `FINAL_AUDIT_COMPLETE_WITH_BLOCKED_EVIDENCE`
- `FINAL_AUDIT_COMPLETE`

Audit completion does not mean product repair, release approval, literary approval, visual approval, rights approval, or Founder approval.
