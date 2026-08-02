# Phoenix New Journey Creation Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the only permitted lifecycle for creating a new Phoenix Journey. It prevents batch expansion before product, story, learning, visual, technical, and mobile quality are proven.

The first new-Journey cycle permits exactly **one Journey pilot**. No second Journey may enter implementation before the first pilot receives controlled approval.

## 2. Global gates

Every phase MUST record:

- input;
- required deliverables;
- validation evidence;
- blocking conditions;
- responsible owner;
- completion state.

Canonical completion states are `PASS`, `REQUIRES_REVISION`, `REGRESSION`, `BLOCKED`, and `NOT_APPLICABLE`. Canonical evidence levels are `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, and `CONTRADICTORY`.

A phase may advance only when every Mandatory item is `PASS` with `VERIFIED` evidence and no regression exists.

## 3. Phase A: Journey Proposal

### Input

- current approved stable baseline;
- product and learning goals;
- proposed Journey type, city or realm, audience, and language level;
- known rights and cultural constraints.

### Required deliverables

- unique Journey ID and proposed Story ID;
- Journey type;
- city or realm identity;
- learner value and product value;
- cultural anchor;
- protagonist, relationship, goal, conflict, choice, consequence, and emotional arc summary;
- explanation of how the proposal differs from every existing Journey;
- proposed learning stages and reward outcome;
- initial rights and external-disclosure plan;
- authorized scope and responsible owners.

### Validation evidence

- comparison against existing Journey catalog;
- duplicate-pattern review;
- route and ID collision review;
- cultural research source record;
- proposal decision record.

### Blocking conditions

- interchangeable city or realm;
- repeated protagonist, conflict, choice, consequence, or structure;
- no meaningful learning value;
- no credible cultural anchor;
- unresolved rights or disclosure risk;
- second pilot proposed before the first is approved.

### Responsible owner

Product owner with Story/Learning and Quality review.

### Completion state

`PASS` only after proposal uniqueness and scope are VERIFIED.

## 4. Phase B: Story and Learning Design

### Input

- approved Phase A proposal;
- Journey System Standard;
- target language level and supported languages.

### Required deliverables

- complete independent story design;
- protagonist, relationship, goal, conflict, choice, consequence, and emotional arc;
- cultural anchor integrated into action;
- Story, Vocabulary, ReadingAnnotation, Discovery, Challenge, Reflection, Writing, Memory, Completion, Reward, and Stamp design as applicable;
- multilingual alignment plan;
- narration plan;
- progression and persistence rules;
- content rights and source record;
- acceptance criteria for every stage.

### Validation evidence

- story structure review;
- learning-purpose review;
- cultural authenticity review;
- cross-language meaning matrix;
- duplication review against existing Journeys;
- required/optional element checklist.

### Blocking conditions

- generic tourism text;
- copied or lightly recolored narrative template;
- missing choice or consequence;
- stage text duplicated only to fill fields;
- unsupported cultural claims;
- multilingual meaning drift;
- rights or attribution unresolved.

### Responsible owner

Story/Learning owner with cultural, language, and Quality review.

### Completion state

`PASS` only when the complete design is VERIFIED and no implementation begins early.

## 5. Phase C: Visual Concept Pilot

### Input

- approved Story and Learning Design;
- PR `#137` visual baseline;
- UI and Visual Standard;
- approved rights plan.

### Required deliverables

The visual pilot is limited to:

- one Journey;
- one to three sample images;
- one isolated Preview.

It MUST also provide:

- visual concept statement;
- independent composition, environment, focal point, color relationships, lighting, material, weather, and cultural details;
- target mobile crop and readable text region;
- stage-to-image intent;
- source, rights, and modification evidence;
- explicit statement that unapproved pilot assets are excluded from release runtime.

### Validation evidence

- stable/candidate visual comparison;
- target-phone screenshots;
- crop and focal-point review;
- visual differentiation review;
- Rights, Technical, Visual Quality, and Stable Comparison gate evidence;
- Founder mobile decision.

### Blocking conditions

- low-detail programmatic principal visual;
- flat background;
- recolored or repeated composition;
- source-only approval without product review;
- more than three sample images;
- batch generation or runtime integration before approval;
- Founder decision missing, pending, or rejected.

### Responsible owner

Visual owner with Product, Rights, Quality, and Founder review.

### Completion state

`PASS` only after Founder mobile approval of the concept. Rejection returns the work to revision; it does not authorize a new batch.

## 6. Phase D: Implementation

### Input

- approved proposal, Story/Learning design, and visual concept;
- exact authorized paths and implementation scope;
- latest approved stable `main`.

### Required deliverables

- correct Journey ID, Story ID, route, components, data, assets, languages, narration, progression, persistence, reward, stamp, loading, error, fallback, and accessibility implementation;
- changed-path inventory;
- implementation notes linking every change to an approved requirement;
- no unrelated changes;
- no use of closed PRs `#138`–`#141` as a baseline.

### Validation evidence

- exact diff, Commit, Tree, paths, and mappings;
- route and ID evidence;
- runtime page evidence;
- content and asset mapping evidence;
- progress and persistence evidence;
- scope review.

### Blocking conditions

- unauthorized path;
- wrong route, ID, component, content, language, asset, reward, or persistence mapping;
- runtime placeholder;
- unrelated refactor;
- closed-PR implementation inherited without independent stable-baseline proof;
- batch implementation of additional Journeys.

### Responsible owner

Implementation owner with Product and Quality review.

### Completion state

Implementation complete means ready for validation, not product Completed.

## 7. Phase E: Automated Validation

### Input

- candidate Commit from Phase D;
- exact required validation commands and CI workflows.

### Required deliverables

- analysis, tests, build, link, route/data, asset, security, or other scope-required results;
- exact command, environment, Commit, output, and terminal status;
- CI run and job identifiers where available.

### Validation evidence

- reproducible command output;
- CI terminal conclusions;
- failed-test and retry history;
- confirmation that validation did not modify unauthorized files.

### Blocking conditions

- required validation not run;
- non-terminal CI;
- failure or cancellation;
- stale result from another Commit;
- summary without output or run ID;
- local tests claimed despite no local environment.

### Responsible owner

Implementation owner with Quality verification.

### Completion state

When no local environment exists, local status MUST be `NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT`. Automated validation success does not replace Preview or Founder approval.

## 8. Phase F: Stable Baseline Comparison

### Input

- validated candidate Commit;
- current approved stable PR and Commit;
- equivalent stable and candidate routes and states.

### Required deliverables

- complete `STABLE_BASELINE_COMPARISON` from [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md);
- comparison of function, pages, routes, assets, visuals, interaction, mobile, performance, content, audio, accessibility, rights, and unexpected loss;
- exact evidence for all affected surfaces.

### Validation evidence

- reproducible stable and candidate paths;
- screenshots, recordings, measurements, logs, and runtime observations as applicable;
- scope and changed-path verification.

### Blocking conditions

- missing report;
- non-equivalent comparison conditions;
- `UNVERIFIED` or `CONTRADICTORY` material claim;
- any `REGRESSION`;
- accidental loss of stable feature or resource.

### Responsible owner

Quality owner with implementation support.

### Completion state

Missing report: `INCOMPLETE_STABLE_BASELINE_COMPARISON_MISSING`. Any regression: `REGRESSION_BLOCKS_READY_AND_MERGE`.

## 9. Phase G: Founder Mobile Preview

### Input

- Phase F candidate with no known regression;
- isolated reproducible Preview tied to exact candidate Commit;
- target mobile test path.

### Required deliverables

- Preview link and route instructions;
- affected Journey and stage list;
- stable/candidate comparison summary;
- known limitations;
- explicit Founder decision.

### Validation evidence

- Founder approval record tied to candidate Commit or reproducible Preview;
- mobile screenshots or recording where retained;
- issue list for any rejection.

### Blocking conditions

- Preview unavailable or not tied to candidate;
- mobile flow incomplete;
- approval assumed from silence;
- decision `PENDING` or `REJECTED`;
- candidate changed after approval without reapproval.

### Responsible owner

Founder decision, coordinated by Product/Quality.

### Completion state

`PASS` only with explicit `APPROVED` decision.

## 10. Phase H: Approval and Controlled Release

### Input

- all Phases A–G passed;
- exact approved candidate Commit;
- release and rollback plan.

### Required deliverables

- completed New Journey Acceptance Matrix;
- final changed-path and evidence inventory;
- release scope limited to the approved pilot;
- rollback trigger and restoration procedure;
- post-release verification plan;
- Founder approval to release or merge.

### Validation evidence

- all Mandatory acceptance items `PASS` with `VERIFIED` evidence;
- PR remains within scope;
- CI terminal success where required;
- exact approval record;
- post-release comparison evidence when released.

### Blocking conditions

- any missing Mandatory item;
- candidate differs from approved Commit;
- additional Journey or unapproved batch included;
- regression, blocked evidence, or unauthorized path;
- missing rollback plan.

### Responsible owner

Product owner, Quality owner, and Founder.

### Completion state

Only this phase may authorize the pilot Journey as Completed and eligible for controlled release.

## 11. Single-pilot enforcement

Until the first new Journey completes Phase H:

- no second new Journey may enter Phase D Implementation;
- no batch visual generation may enter runtime;
- no shared template may be inferred from one unapproved design;
- reusable infrastructure changes must be separately scoped and compared against the stable baseline;
- research proposals may be recorded, but they MUST remain outside implementation.

## 12. Acceptance matrix

Every phase MUST update [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md). Any missing Mandatory item blocks Completed, Ready, merge, expansion, and the next phase.

## 13. Final rule

A new Journey is not complete when its files, content, images, tests, or Preview merely exist. It is complete only after all phases pass, the stable baseline is preserved or exceeded, and Founder mobile approval authorizes controlled release.