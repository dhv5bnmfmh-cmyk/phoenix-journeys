# Phoenix New Journey Creation Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING PHASE GATE  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

This standard is binding together with [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md), Phoenix Product Quality Standard, Phoenix UI and Visual Standard, and the acceptance matrix.

All work MUST obey `NEW RESULT >= CURRENT STABLE BASELINE`.

## 1. Purpose

This standard controls creation of exactly one new Journey at a time. It prevents premature implementation, copied Story structures, unverified cultural claims, batch image production, runtime placeholders, and expansion before Founder approval.

It also governs an existing-Story repair pilot when the same phase evidence is required by Phoenix Narrative and Discovery Standard.

## 2. Permanent limits

- One authorized task MUST NOT implement more than one Journey unless a later controlled batch is explicitly approved.
- No new Journey begins before existing pilot quality is proven and the roadmap authorizes expansion.
- No batch Story rewrite occurs before pilot approval.
- A proposal, design, or concept does not authorize implementation.
- Every phase keeps an independent acceptance record.
- `PASS` requires `VERIFIED` evidence.
- `NOT_APPLICABLE` requires reason and evidence.
- Automated validation success does not establish literary `PASS`.
- Founder approval MUST be tied to the exact candidate Commit and Preview.

## 3. Phase A: Proposal

### Allowed work

Research, internal source review, proposal drafting, catalog comparison, and feasibility analysis. No product, Story data, Discovery data, visual asset, route, or runtime implementation.

### Required evidence

- Journey ID and Story ID proposal;
- Journey Type and publication state;
- city, place, or realm identity;
- approved internal source evidence;
- cultural anchor and substitution test;
- protagonist mode;
- Relationship;
- Goal;
- Conflict;
- key Choice;
- caused Consequence;
- Emotional Arc;
- primary narrative engine;
- Story Function;
- Discovery Function;
- opening type;
- climax type;
- ending type and changed ending state;
- memory anchor;
- catalog differentiation matrix;
- closest existing Journeys and risks;
- Phoenix Lv.1 through Lv.10 invariant plan;
- visual direction without batch generation;
- product and technical feasibility;
- rights and disclosure plan;
- owner, reviewer, Result, and Evidence Level.

### Blocking conditions

Any applicable blocking code from Phoenix Narrative and Discovery Standard blocks Phase A. In particular:

- `PROTAGONIST_IDENTITY_MISSING`
- `RELATIONSHIP_NOT_CAUSAL`
- `GOAL_NOT_PERSONAL_OR_SPECIFIC`
- `CONFLICT_NOT_CONNECTED_TO_GOAL`
- `CHOICE_NOT_ENACTED`
- `CONSEQUENCE_NOT_CAUSED`
- `EMOTIONAL_ARC_UNVERIFIED`
- `CULTURAL_ANCHOR_DECORATIVE`
- `STORY_IS_PRIMARY_EXPOSITION`
- `STORY_DISCOVERY_FUNCTION_OVERLAP`
- `NARRATIVE_ENGINE_DUPLICATION`
- `LIBRARY_DIFFERENTIATION_UNVERIFIED`
- `LEVEL_ADAPTATION_IDENTITY_LOSS`
- `SPECIAL_MECHANISM_FLATTENED`
- `BATCH_EXPANSION_BEFORE_PILOT_APPROVAL`

### Exit gate

Founder approves the proposal direction only. Phase B is not automatically approved.

## 4. Phase B: Story and learning design

### Allowed work

Design records and reviewable content specifications. No runtime implementation or asset batch.

### Required evidence

- complete [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md);
- Story Function Contract;
- Discovery Function Contract;
- Function Contracts for Challenge, Reflection, Writing, Memory, and Completion;
- complete protagonist identity evidence;
- causal Relationship evidence;
- Goal significance;
- Conflict connected to Goal;
- enacted Choice evidence;
- Consequence caused-by-choice evidence;
- Emotional Arc opening, turning point, and ending;
- cultural anchor effect on action;
- narrative-engine independence;
- opening independence;
- causal progression;
- climax and changed ending state;
- Story / Discovery functional separation evidence;
- catalog-level similarity and differentiation review;
- Phoenix Lv.1 through Lv.10 invariant matrix;
- ReadingAnnotation plan;
- translation and segmentation plan;
- vocabulary selection and provenance;
- Challenge answer validity;
- Reflection and Writing purpose;
- Memory anchor;
- Completion outcome;
- narration plan;
- automated-score limitation acknowledgment;
- human literary-review owner.

### Required declaration

```text
Automated checks planned:
Checks not covered by automation:
Automated score used as literary approval: NO
Human literary review required: YES
```

### Blocking conditions

All blocking codes in Phoenix Narrative and Discovery Standard apply. `OPENING_TEMPLATE_REUSE`, `ENDING_TEMPLATE_REUSE`, `STORY_DISCOVERY_FUNCTION_OVERLAP`, and `AUTOMATED_SCORE_NOT_LITERARY_APPROVAL` are explicit Phase B blockers.

### Exit gate

All required design rows are `PASS / VERIFIED`; Founder approves the exact Story and Discovery design before visual concept or implementation.

## 5. Phase C: Visual concept

### Allowed work

One Journey only, with one to three representative concept assets or existing approved internal references. No full batch, no replacement of product visuals, and no production mapping.

### Required evidence

- visual motif linked to Story action and memory anchor;
- stage intent;
- crop, focal point, text-safe area, small-screen, Safe Area, and reduced-motion plan;
- catalog visual-differentiation comparison;
- source, license, permission, modification, and attribution evidence;
- technical mapping plan;
- isolated Preview plan;
- Founder mobile review requirement.

### Exit gate

Founder approves the visual direction. Approval is not approval for batch generation.

## 6. Phase D: Implementation

### Preconditions

Phases A, B, and C are approved. The branch starts from the latest approved stable `main`, as recorded by `docs/PHOENIX_STABLE_BASELINE_STANDARD.md`.

### Required implementation scope

- exact Journey and Story IDs;
- exact route and parameters;
- Story and Discovery records;
- Reflection, Writing, Memory, Challenge, Completion, Reward, and conditionally applicable Stamp;
- Lv.1 through Lv.10 content preserving narrative invariants;
- ReadingAnnotations and translations;
- vocabulary and reviewed examples;
- narration and locale behavior;
- progress, persistence, access, and migration;
- Loading, Error, Empty, and Fallback states;
- accessibility;
- approved visual mapping;
- rights records;
- Journey-level acceptance evidence.

No unrelated repair or second Journey may be bundled.

## 7. Phase E: Automated validation

Required checks include, as applicable:

- Worker governance tests;
- Flutter Analyze;
- Flutter Tests;
- Web release build;
- Cloudflare Worker bundle validation;
- IDs, routes, records, annotations, translations, vocabulary, Challenge, level, progress, persistence, access, assets, and rights-record integrity;
- exact changed-path verification;
- no skipped or deleted stable tests.

Automated validation success does not establish literary `PASS`.

Automated validation MAY establish only the checks it implements. `360 / 360 PASS`, `score 100`, `average 100`, or `all fields present` MUST NOT be promoted into Story Quality approval.

## 8. Phase F: Stable comparison and isolated Preview

Required:

- candidate Commit, Tree, and parent;
- exact changed paths;
- isolated PR Preview tied to candidate Head SHA;
- `STABLE_BASELINE_COMPARISON` against PR `#137` and the current approved stable `main`;
- separate content, interaction, mobile, visual, audio, accessibility, persistence, access, rights, and performance Results and Evidence Levels;
- no regression;
- no PR Preview used as production evidence;
- no unsupported visual or literary approval.

## 9. Phase G: Founder mobile review

Founder mobile review MUST cover:

- Story identity;
- Discovery distinction;
- protagonist mode and Relationship visibility;
- Goal, Conflict, enacted Choice, and caused Consequence;
- emotional continuity;
- opening, climax, and ending independence;
- cultural anchor in action;
- level adaptation;
- Journey memorability;
- language, narration, mobile layout, keyboard, Safe Area, persistence, and completion where applicable.

Founder decision values:

- `APPROVED`
- `REJECTED`
- `PENDING`

Only `APPROVED` tied to the exact candidate authorizes the next phase. A later material content or visual change requires reapproval.

## 10. Pilot and batch gate

Existing-library narrative repair MUST follow:

1. Pilot N1, one normal Journey, recommended `beijing-summer-palace`;
2. Founder mobile decision on Pilot N1;
3. Pilot S1, one special Journey, recommended `tide-letter`;
4. Founder mobile decision on Pilot S1;
5. controlled repair batches of two to three Journeys;
6. library differentiation rerun after every batch.

Before Pilot N1 approval:

- no second pilot;
- no batch rewrite;
- no 27-normal-Journey rewrite;
- no nine-special-Journey rewrite;
- no template inferred from the pilot.

A rejected pilot returns to revision. It does not authorize replacing the pilot or mass production.

## 11. Acceptance matrix

Use [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md). NJ-001 through NJ-052 are cumulative. Existing rows MUST NOT be replaced by aggregate evidence.

Every row records exact evidence, Result, Evidence Level, Issue / Required Action, Owner, and Founder Approval state where applicable.

## 12. Prohibited shortcuts

The following are blocking:

- generic tourism narration as Story;
- factual accuracy used as narrative approval;
- exact-text difference used as functional separation;
- generic second-person perspective used as protagonist identity;
- mentioned person used as causal Relationship;
- internal thought used as enacted Choice without action or commitment;
- philosophical ending used as caused Consequence;
- one unsupported similarity score used as catalog approval;
- aggregate score used as literary approval;
- batch rewrite before pilot approval;
- Story / Discovery functional duplication;
- shared Story template;
- city or realm substitution inside the same causal structure;
- special mechanism flattened by generic adaptation;
- runtime placeholder or wrong-Journey fallback;
- production use before rights and Founder gates.

## 13. Completion and expansion

A Journey is Completed only when every applicable acceptance row is `PASS / VERIFIED`, all blocking codes are closed, stable comparison passes, technical checks are terminal-success, and required Founder approval is `APPROVED`.

A completed pilot does not automatically authorize a second Journey or batch. Expansion requires explicit scope and follows the two-to-three-Journey default batch limit.

This governance document does not authorize a new Journey, Summer Palace pilot, Tide Letter pilot, content repair, Ready state, or merge.
