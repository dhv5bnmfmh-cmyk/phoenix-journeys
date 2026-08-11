# Phoenix Human Narrative Quality Acceptance Extension

**Status:** BINDING acceptance extension under `docs/PHOENIX_HUMAN_NARRATIVE_QUALITY_GATE.md`.

This extension is REQUIRED for every new Journey Story, Founder-authorized Story remediation, and Gold candidate. It supplements, and does not replace, `PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md`.

A candidate cannot be Completed, Gold-ready, or Founder-ready while any applicable REQUIRED row below is `BLOCKED`, `REQUIRES_REVISION`, `PENDING`, `UNVERIFIED`, or `PARTIALLY_VERIFIED`.

## Candidate

```text
Repository:
PR:
Branch:
Candidate SHA:
Journey ID:
Story title:
Reviewer:
Review date:
Current approved Gold count:
```

## Allowed values

- Result: `PASS` / `REQUIRES_REVISION` / `BLOCKED` / `PENDING`
- Evidence Level: `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`
- Founder Approval: `APPROVED` / `REJECTED` / `PENDING` / `NOT_REQUIRED`

## Blocking acceptance rows

| ID | Acceptance item | Requirement | Required evidence | Result | Evidence Level | Founder Approval |
|---|---|---|---|---|---|---|
| HNQ-001 | Authority-state separation | REQUIRED | Machine content, machine semantic, Agent semantic sufficiency, Agent literary, human anti-template, Founder, and overall Story Quality recorded separately | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-002 | Automated literary approval prohibition | REQUIRED | `AUTOMATED_SCORE_USED_AS_LITERARY_APPROVAL: NO`; machine PASS grants only eligibility for human review | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-003 | Architecture alternatives | REQUIRED | At least three structurally distinct pre-lock architectures and selection/rejection rationale | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-004 | De-skinned causal spine | REQUIRED | Surface identity removed; opening → desire → stakes → relationship pressure → conflict → failure → choice → cost → climax → consequence → transformation → ending recorded | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-005 | All-Gold human pairwise comparison | REQUIRED | De-skinned candidate compared with every current Founder-approved Gold Story | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-006 | Nearest-Gold reader distinction | REQUIRED | Event-level explanation of why an ordinary reader would not confuse candidate and nearest Gold without taxonomy terminology | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-007 | Human stakes | REQUIRED | Personal stakes beyond generic task completion; exact Story evidence and review | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-008 | Relationship pressure | REQUIRED | Relationship causally affects Goal, Conflict, Choice, Consequence, emotional movement, or Ending where relationship is applicable | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-009 | Choice and cost | REQUIRED | Competing value/need, meaningful cost/risk/commitment, non-automatic choice, exact Story evidence | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-010 | Climax quality | REQUIRED | Climax resolves/exposes central pressure and does not merely prove a revised method works | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-011 | Behavioral transformation | REQUIRED | Changed behavior/relationship/responsibility/decision demonstrated in Story action | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-012 | Memory-anchor independence | REQUIRED | Durable anchor is Story-native and not interchangeable with another approved Journey or default Phoenix object pattern | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-013 | Place-irreplaceability | REQUIRED | Generic substitution plus at least three materially different approved-Gold location probes; causal spine materially depends on verified place property | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-014 | Taxonomy-laundering prohibition | REQUIRED | Human difference remains defensible without engine enum / Narrative DNA labels; new taxonomy, if any, follows Story causality | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-015 | Lv1/Lv5/Lv10 literary coherence | REQUIRED | Same locked causal Story; Lv1 complete spine, Lv5 natural complete narrative, Lv10 deepens without becoming exposition | BLOCKED | UNVERIFIED | NOT_REQUIRED |
| HNQ-016 | Exact-head Founder handoff | REQUIRED | New candidate SHA, exact-head Preview parity, Lv1/Lv5/Lv10 review evidence, explicit Founder state | BLOCKED | UNVERIFIED | PENDING |

## Mandatory blocking outcomes

Use the exact applicable outcome when a row fails:

- `HUMAN NARRATIVE TEMPLATE REUSE — NOT GOLD READY`
- `HUMAN LITERARY REVIEW MISSING — STORY QUALITY PENDING`
- `READER-PERCEIVED NARRATIVE DUPLICATION — REQUIRES REVISION`
- `STORY QUALITY STATUS CONFLATION — BLOCKED`
- `NARRATIVE MECHANISM TAXONOMY LAUNDERING — BLOCKED`
- `HUMAN STAKES INSUFFICIENT — REQUIRES REVISION`
- `CHOICE / COST INSUFFICIENT — REQUIRES REVISION`
- `CLIMAX ONLY PROVES METHOD — REQUIRES REVISION`
- `MEMORY ANCHOR INTERCHANGEABLE — REQUIRES REVISION`
- `GENERIC-PLACE STORY — NOT GOLD READY`

## Final authority state

Before Founder review the strongest permitted truthful state is:

```text
MACHINE_CONTENT_GATE: PASS
MACHINE_SEMANTIC_GATE: PASS
AGENT_SEMANTIC_SUFFICIENCY: PASS
AGENT_LITERARY_REVIEW: PASS
HUMAN_NARRATIVE_ANTI_TEMPLATE: PASS
FOUNDER_STORY_APPROVAL: PENDING
OVERALL_STORY_QUALITY: PENDING FOUNDER APPROVAL
```

No automated score, CI result, semantic collision arithmetic, or report count may change `FOUNDER_STORY_APPROVAL`.
