# Phoenix Quality Unification Roadmap

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING SEQUENCE  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This roadmap defines the only approved order for auditing, repairing, unifying, improving, and expanding Phoenix. A later stage MUST NOT begin before the previous stage has the required evidence and approval.

No stage may be marked Completed without VERIFIED evidence.

## 2. Permanent rules

Every stage MUST:

- start from the latest approved stable `main`;
- obey `NEW RESULT >= CURRENT STABLE BASELINE`;
- preserve PR `#137` as the minimum product and visual quality until a later stable baseline is explicitly approved;
- use canonical product results and evidence levels;
- identify exact scope, paths, Commit, and owner;
- submit a stable-baseline comparison after development;
- stop on any regression;
- keep closed PRs `#138`–`#141` as historical evidence only;
- require Founder mobile approval for visual or core interaction changes.

## 3. Stage 1: Standards completed and approved

### Scope

Complete the Phoenix Product Standard System v1.0 and Founder review.

### Required outputs

- Stable Baseline Standard;
- Product Quality Standard;
- UI and Visual Standard;
- Journey System Standard;
- New Journey Creation Standard;
- Full Application Audit Standard;
- Development Completion Standard;
- this roadmap;
- Full Application Audit Matrix;
- New Journey Acceptance Matrix;
- enforced PR template.

### Completion evidence

- all documents exist and are readable;
- links and terminology are consistent;
- PR contains documentation-only authorized paths;
- PR remains Draft until Founder review;
- no runtime, image, Story, audio, dependency, or workflow change;
- Founder explicitly approves the standard PR;
- approved standard PR is merged into `main` before Stage 2.

### Blockers

Missing document, conflicting rule, unauthorized path, unverified content, PR not approved, or standards not merged.

## 4. Stage 2: Full application read-only audit

### Scope

Execute [Phoenix Full Application Audit Standard](PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md) across the complete application.

### Required outputs

- route, page, Journey, stage, asset, audio, language, entitlement, state, mobile, persistence, privacy, and stable-comparison coverage;
- completed audit matrix;
- evidence limitations;
- no product modifications.

### Completion evidence

- audit scope and inventories are complete;
- every item is recorded with result, severity, and evidence level;
- no fix or new Journey was performed during the audit.

### Blockers

Incomplete inventory, hidden gaps, modified product files, or unsupported assumptions.

## 5. Stage 3: P0/P1/P2/P3 ledger

### Scope

Normalize and deduplicate Stage 2 findings into one auditable issue ledger.

### Required outputs

- unique Audit/Issue ID;
- severity, impact, route, path, Journey, evidence, stable comparison, owner, required action, and verification method;
- dependencies and repair order;
- explicit P0/P1 release blockers.

### Completion evidence

- every audit finding maps to a ledger entry or documented duplicate;
- severity follows the Full Application Audit Standard;
- contradictory evidence is resolved or remains visibly blocked.

### Blockers

Unmapped finding, severity without evidence, or issue hidden by aggregate scoring.

## 6. Stage 4: Repair P0 and P1

### Scope

Repair only authorized P0 and P1 issues in controlled, small tasks.

### Required outputs

- one scoped repair task at a time or an explicitly approved dependent set;
- exact changed paths;
- technical validation;
- Preview when user-visible;
- mandatory stable-baseline comparison;
- Founder approval when required.

### Completion evidence

- each P0/P1 is closed with VERIFIED repair evidence;
- no new P0/P1 or regression introduced;
- stable product behavior is preserved or improved.

### Blockers

Outstanding P0/P1, regression, missing comparison, or unauthorized bundled improvement.

## 7. Stage 5: Unify UI, Loading, Error, Empty, and Accessibility

### Scope

Unify shared product behavior without flattening Journey identity.

### Required outputs

- shared component and state inventory;
- page hierarchy, spacing, typography, safe-area, small-screen, motion, and accessibility alignment;
- consistent Loading, Error, Empty, and Fallback behavior;
- migration plan for each affected page;
- small-batch implementation and Preview evidence.

### Completion evidence

- affected pages meet [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md);
- PR `#137` visual and interaction quality is preserved or exceeded;
- Founder mobile approval covers visual/core interaction changes.

### Blockers

Template-driven visual flattening, broad unapproved rewrite, mobile regression, or incomplete state coverage.

## 8. Stage 6: Unify normal Journey product skeleton

### Scope

Align normal Journeys to [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md).

### Required outputs

- shared stage, navigation, narration, multilingual, progress, reward, loading, error, fallback, and acceptance structure;
- preserved independent protagonist, relationship, goal, conflict, choice, consequence, emotional arc, cultural anchor, city-life scene, visual composition, and memory anchor;
- Journey-by-Journey acceptance evidence.

### Completion evidence

- common product skeleton is consistent;
- no normal Journey is reduced to a copied story or visual template;
- stable comparison passes for each changed Journey.

### Blockers

Interchangeable content, repeated visuals, broken IDs/routes, incomplete language alignment, or regression.

## 9. Stage 7: Unify special Journey product skeleton while preserving literary independence

### Scope

Align special Journeys to shared product infrastructure without imposing one fantasy or literary template.

### Required outputs

- consistent page, stage, narration, progress, state, and accessibility systems;
- independent literary structure, protagonist, conflict, choice, consequence, emotional arc, mysterious mechanism, imagery, environment, and memory anchor;
- Journey-by-Journey comparison and Founder visual approval where changed.

### Completion evidence

- product behavior is consistent;
- literary and visual identity remains independently recognizable;
- no shared fantasy filter or repeated reveal mechanism dominates the catalog.

### Blockers

Loss of literary independence, uniform visual mechanism, or stable-baseline downgrade.

## 10. Stage 8: Raise overall quality above PR #137

### Scope

Address approved P2/P3 issues and measurable product improvements after shared systems and Journey structures are stable.

### Required outputs

- prioritized quality plan tied to audit evidence;
- small, verifiable improvement tasks;
- before/after product evidence;
- performance, content, audio, accessibility, visual, and mobile improvements as applicable;
- updated stable comparison for every task.

### Completion evidence

- no unresolved P0/P1;
- targeted P2/P3 improvements are VERIFIED;
- overall result is demonstrably above, not merely different from, PR `#137`;
- Founder approves material visual or experience elevation.

### Blockers

Unmeasured redesign, regression hidden by new features, or aggregate score without direct evidence.

## 11. Stage 9: Develop one new Journey pilot

### Scope

Create exactly one new Journey under [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md).

### Required outputs

- Phases A–F completed;
- completed acceptance matrix to the current phase;
- visual concept limited to one Journey, one to three sample images, and one isolated Preview;
- no second Journey implementation.

### Completion evidence

- proposal, Story/Learning design, visual concept, implementation, automated validation, and stable comparison pass;
- no runtime placeholder or unauthorized batch work.

### Blockers

Second Journey implementation, batch visual expansion, missing phase evidence, or regression.

## 12. Stage 10: Founder mobile approval

### Scope

Founder reviews the single pilot on a real mobile Preview.

### Required outputs

- exact candidate Commit and Preview;
- complete route and stage instructions;
- stable/candidate comparison;
- explicit APPROVED or REJECTED decision;
- issue list and revision path if rejected.

### Completion evidence

Founder approval is tied to the exact candidate. Any later material candidate change requires reapproval.

### Blockers

Pending, inferred, stale, or rejected approval.

## 13. Stage 11: Controlled expansion of more Journeys

### Scope

Expand only after the first pilot completes controlled approval.

### Required outputs

- Founder-approved expansion scope and batch size;
- retained single-Journey acceptance per Journey;
- shared-system reuse without story or visual templating;
- independent Preview and stable comparison for each approved batch;
- rollback plan.

### Completion evidence

- each Journey independently passes Mandatory acceptance items;
- batch quality remains at or above the approved pilot and stable baseline;
- no unreviewed scaling.

### Blockers

Pilot not approved, reduced quality at scale, template duplication, missing Founder approval, or any regression.

## 14. Stage status record

Every stage record MUST include:

```text
Stage:
Status:
Starting Stable PR:
Starting Stable Commit:
Authorized Scope:
Required Outputs:
Evidence:
Open Blockers:
Founder Approval Required:
Founder Approval Result:
Completion Decision:
Next Stage Authorized: YES / NO
```

`Next Stage Authorized` MUST be `NO` unless the current stage has all required VERIFIED evidence and explicit approval.

## 15. Enforcement

Skipping a stage, starting product repair during the read-only audit, beginning a new Journey before quality unification, or expanding before Founder approval is a process violation and results in `BLOCKED`.

## 16. Binding narrative-repair sequence before broad expansion

[Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) adds the following binding order before broad content expansion:

1. Finish routing, access, and critical-persistence P1 repairs.
2. Merge Narrative and Discovery Standard after Founder review.
3. Founder confirms the content model.
4. Complete one normal Story pilot, recommended `beijing-summer-palace`.
5. Obtain Founder mobile approval for that exact normal pilot Commit and Preview.
6. Complete one special Story pilot, recommended `tide-letter`.
7. Obtain Founder mobile approval for that exact special pilot Commit and Preview.
8. Expand only in controlled batches of two to three Journeys.
9. Re-run library differentiation after every batch.
10. No new Journey expansion until existing pilot quality is proven.

The roadmap explicitly prohibits:

- rewriting 27 normal Journeys in one task;
- rewriting nine special Journeys in one task;
- using one shared Story template;
- approving a batch only through aggregate score;
- starting a second pilot before the first is decided;
- batch Story rewrite before pilot approval;
- inferring a reusable template from the first pilot draft;
- using `360 / 360 PASS`, `score 100`, `average 100`, or `all fields present` as literary approval.

A rejected pilot returns to revision. It does not authorize a replacement pilot, a second pilot, or mass production. Every approved batch retains independent Journey acceptance records and is blocked if quality falls below the approved pilot or stable baseline.
