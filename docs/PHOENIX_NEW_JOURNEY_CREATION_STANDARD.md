# Phoenix New Journey Creation Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the only permitted lifecycle for creating a new Phoenix Journey. It prevents batch expansion before product, story, learning, visual, technical, and mobile quality are proven.

The first new-Journey cycle permits exactly **one Journey pilot**. No second Journey may enter implementation before the first pilot receives controlled approval.

For all new or replaced Journey backgrounds, [PHOENIX AI BACKGROUND PRODUCTION STANDARD](PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md) is binding and MUST be read before background production begins.

## 2. Global gates and requirement classes

Every phase MUST record:

- input;
- required deliverables;
- validation evidence;
- blocking conditions;
- responsible owner;
- completion state.

Canonical requirement classes are:

- `REQUIRED`
- `CONDITIONALLY_REQUIRED`
- `OPTIONAL`

Legacy terms map only as follows when reading historical records: `MANDATORY` = `REQUIRED`; `CONDITIONAL` = `CONDITIONALLY_REQUIRED`. New records and tables MUST use the canonical terms.

Canonical completion states are `PASS`, `REQUIRES_REVISION`, `REGRESSION`, `BLOCKED`, and `NOT_APPLICABLE`. Canonical evidence levels are `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, and `CONTRADICTORY`.

A phase may advance only when every `REQUIRED` item and every applicable `CONDITIONALLY_REQUIRED` item is `PASS` with `VERIFIED` evidence and no regression exists. `NOT_APPLICABLE` requires a reason and evidence.

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
- repeated protagonist, relationship, goal, conflict, choice, consequence, or structure;
- no meaningful learning value;
- no credible cultural anchor;
- unresolved rights or disclosure risk;
- second pilot proposed before the first is approved.

### Responsible owner

Product owner with Story/Learning and Quality review.

### Completion state

`PASS` only after proposal uniqueness and scope are `VERIFIED`.

## 4. Phase B: Story and Learning Design

### Input

- approved Phase A proposal;
- Journey System Standard;
- target language level and supported languages.

### Requirement classification

Phase B MUST classify its design elements as follows:

- Protagonist: `REQUIRED`
- Relationship: `REQUIRED`
- Goal: `REQUIRED`
- Conflict: `REQUIRED`
- Choice: `REQUIRED`
- Consequence: `REQUIRED`
- Emotional Arc: `REQUIRED`
- Story: `REQUIRED`
- Vocabulary: `REQUIRED`
- ReadingAnnotation: `CONDITIONALLY_REQUIRED` when Story, Discovery, or other explorer-readable learning text exists
- Discovery: `REQUIRED`
- Challenge: `REQUIRED`
- Reflection: `REQUIRED`
- Writing: `REQUIRED`
- Memory: `REQUIRED`
- Completion: `REQUIRED`
- Reward: `REQUIRED`
- Stamp: `CONDITIONALLY_REQUIRED` when completion, reward, Passport, collection, or progress design includes a Stamp
- Other product-approved fields: `OPTIONAL` only when omission does not weaken the required flow

ReadingAnnotation may be `NOT_APPLICABLE` only when no applicable explorer-readable text exists, with reason and evidence. Stamp may be `NOT_APPLICABLE` only when an explicit product design decision excludes it, with design basis and evidence. Neither may be left blank or hidden as `OPTIONAL`.

### Required deliverables

- complete independent story design;
- independent protagonist;
- Relationship identity, narrative function, and evidence path;
- protagonist Goal, why it matters, relationship to the Conflict, and evidence path;
- conflict, choice, consequence, and emotional arc;
- cultural anchor integrated into action;
- Story, Vocabulary, Discovery, Challenge, Reflection, Writing, Memory, Completion, and Reward designs;
- ReadingAnnotation applicability decision and design;
- Stamp applicability decision and design;
- multilingual alignment plan;
- narration plan;
- progression and persistence rules;
- content rights and source record;
- acceptance criteria for every applicable stage.

### Validation evidence

- story structure review;
- learning-purpose review;
- cultural authenticity review;
- Relationship and Goal evidence review;
- ReadingAnnotation applicability review;
- Stamp applicability review;
- cross-language meaning matrix;
- duplication review against existing Journeys;
- canonical requirement-class checklist.

### Blocking conditions

- generic tourism text;
- copied or lightly recolored narrative template;
- missing Relationship, Goal, Choice, or Consequence;
- applicable ReadingAnnotation omitted or unverified;
- applicable Stamp omitted or unverified;
- `NOT_APPLICABLE` used without reason and evidence;
- stage text duplicated only to fill fields;
- unsupported cultural claims;
- multilingual meaning drift;
- rights or attribution unresolved.

### Responsible owner

Story/Learning owner with cultural, language, and Quality review.

### Completion state

`PASS` only when the complete design is `VERIFIED` and no implementation begins early.

## 5. Phase C: Visual Concept Pilot

### Input

- approved Story and Learning Design at Story Gold quality;
- PR `#137` visual baseline;
- UI and Visual Standard;
- [PHOENIX AI BACKGROUND PRODUCTION STANDARD](PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md);
- approved rights and IP safety plan.

### Binding background-production sequence

For Journey backgrounds, Phase C and the subsequent visual production path MUST execute in this order:

> **Story Gold**  
> → **Visual DNA**  
> → **Cross-Journey Differentiation**  
> → **Shot Plan**  
> → **1–3 Pilot**  
> → **Rights / IP QA**  
> → **Historical / Cultural QA**  
> → **Mobile QA**  
> → **Founder Review where required**  
> → **Full Production Library**  
> → **Runtime Integration**

A new Journey MUST NOT skip directly from Story Gold to 10-image generation. The 10-image minimum, where required by runtime policy, applies only after Pilot approval.

### Required deliverables

The visual pilot is limited to:

- one Journey;
- one to three sample images;
- one isolated Preview.

Before any image generation it MUST provide the pre-generation record required by the AI Background Production Standard, including:

- Journey Visual DNA;
- cross-Journey visual-difference review;
- Shot Plan;
- Pilot image request count of 1–3;
- IP safety plan;
- historical and cultural verification plan;
- mobile crop plan;
- UI readable-region plan;
- runtime performance plan.

The Pilot MUST also provide:

- visual concept statement;
- independent composition, environment, focal point, color relationships, lighting, material, weather, and cultural details;
- target mobile crop and readable text region;
- stage-to-image intent;
- AI Original status and audit provenance;
- Rights Gate and IP Similarity Review evidence;
- explicit statement that unapproved Pilot assets are excluded from release runtime.

### Validation evidence

- stable/candidate visual comparison;
- target-phone screenshots;
- crop and focal-point review;
- Visual DNA and Shot Plan review;
- visual differentiation and Anti-Template review;
- Visual, Historical, Cultural, Architecture, Geography, IP/Rights, IP Similarity, Mobile Crop, UI Readability, Anti-Template, and performance-feasibility evidence;
- Founder mobile decision where required.

### Blocking conditions

- missing Visual DNA;
- missing Cross-Journey Differentiation review;
- missing Shot Plan;
- missing IP safety or verification plan;
- low-detail programmatic principal visual;
- flat background;
- recolored or repeated composition;
- source-only approval without product review;
- more than three Pilot images before Pilot approval;
- generation of the full production library before Pilot approval;
- runtime integration before Rights Gate `PASS`;
- IP Similarity Review not `PASS`;
- mobile crop or UI readable region unverified;
- Founder decision missing, pending, or rejected where Founder review is required.

### Responsible owner

Visual owner with Product, Rights, Quality, Cultural/Historical, and Founder review where required.

### Completion state

`PASS` only after every applicable Pilot gate passes and required Founder mobile approval is explicit. Rejection returns the work to revision; it does not authorize a new batch.

## 6. Phase D: Implementation

### Input

- approved proposal, Story/Learning design, and visual concept;
- exact authorized paths and implementation scope;
- latest approved stable `main`.

### Required deliverables

- correct Journey ID, Story ID, route, components, data, assets, languages, narration, progression, persistence, reward, conditionally applicable Stamp, loading, error, fallback, and accessibility implementation;
- changed-path inventory;
- implementation notes linking every change to an approved requirement;
- no unrelated changes;
- no use of closed PRs `#138`–`#141` as a baseline.

For background assets, runtime integration is permitted only after the approved Pilot has authorized full production, the final library satisfies applicable minimum-count/runtime metadata rules, Rights Gate is `PASS`, IP Similarity Review is `PASS`, mobile and visual QA are `PASS`, provenance/versioning are complete, and Founder approval is `APPROVED` where required.

### Validation evidence

- exact diff, Commit, Tree, paths, and mappings;
- route and ID evidence;
- runtime page evidence;
- content and asset mapping evidence;
- progress and persistence evidence;
- scope review.

### Blocking conditions

- unauthorized path;
- wrong route, ID, component, content, language, asset, reward, Stamp, or persistence mapping;
- runtime placeholder;
- unrelated refactor;
- closed-PR implementation inherited without independent stable-baseline proof;
- batch implementation of additional Journeys;
- background runtime integration without all binding background-production gates.

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

When no local environment exists, local status MUST be `NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT`. Automated validation success does not replace Preview, Rights/IP review, human visual judgment, or Founder approval where required.

## 8. Phase F: Stable Baseline Comparison

### Input

- validated candidate Commit;
- current approved stable PR and Commit;
- equivalent stable and candidate routes and states.

### Required deliverables

- complete `STABLE_BASELINE_COMPARISON` from [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md);
- comparison of function, pages, routes, Journey IDs, assets, visuals, interaction, mobile, performance, content, audio, accessibility, persistence, access/entitlement, rights, and unexpected loss;
- exact evidence for all affected surfaces.

### Validation evidence

- reproducible stable and candidate paths;
- screenshots, recordings, measurements, logs, and runtime observations as applicable;
- scope and changed-path verification.

### Blocking conditions

- missing report;
- missing required field or evidence level;
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

- all `REQUIRED` and applicable `CONDITIONALLY_REQUIRED` acceptance items `PASS` with `VERIFIED` evidence;
- every `NOT_APPLICABLE` item has a reason and evidence;
- PR remains within scope;
- CI terminal success where required;
- exact approval record;
- post-release comparison evidence when released.

### Blocking conditions

- any missing `REQUIRED` item;
- any missing applicable `CONDITIONALLY_REQUIRED` item;
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

Every phase MUST update [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md). Any missing `REQUIRED` item or applicable `CONDITIONALLY_REQUIRED` item blocks Completed, Ready, merge, expansion, and the next phase.

For Journey backgrounds, every background-production row in the Acceptance Matrix is binding. `PASS` may not be inferred from image count, dimensions, `complianceScore`, `varietyScore`, AI-generated metadata, or file presence alone.

## 13. Final rule

A new Journey is not complete when its files, content, images, tests, or Preview merely exist. It is complete only after all phases pass, the stable baseline is preserved or exceeded, and Founder mobile approval authorizes controlled release.

## 14. Binding Narrative and Discovery extension

This standard is binding together with [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md).

### Phase A additional REQUIRED deliverables

- narrative engine;
- Story Function;
- Discovery Function;
- opening type;
- climax type;
- ending type and changed state;
- catalog differentiation matrix;
- Phoenix Lv.1 through Lv.10 level-invariant plan.

### Phase B additional REQUIRED evidence

- complete Story / Discovery Design Matrix;
- causal Relationship evidence;
- enacted Choice evidence;
- Consequence caused-by-choice evidence;
- Story / Discovery functional separation evidence;
- opening independence and ending independence;
- catalog-level similarity and differentiation review;
- automated-score limitation acknowledgment;
- separate automated structural Result and human literary Result.

All applicable blocking codes from Phoenix Narrative and Discovery Standard apply, including `PROTAGONIST_IDENTITY_MISSING`, `RELATIONSHIP_NOT_CAUSAL`, `CHOICE_NOT_ENACTED`, `CONSEQUENCE_NOT_CAUSED`, `STORY_DISCOVERY_FUNCTION_OVERLAP`, `OPENING_TEMPLATE_REUSE`, `ENDING_TEMPLATE_REUSE`, `NARRATIVE_ENGINE_DUPLICATION`, `LIBRARY_DIFFERENTIATION_UNVERIFIED`, `LEVEL_ADAPTATION_IDENTITY_LOSS`, `SPECIAL_MECHANISM_FLATTENED`, `AUTOMATED_SCORE_NOT_LITERARY_APPROVAL`, and `BATCH_EXPANSION_BEFORE_PILOT_APPROVAL`.

Phase E rule:

> Automated validation success does not establish literary `PASS`.

Phase G Founder mobile review MUST include Story identity, Discovery distinction, emotional continuity, level adaptation, and Journey memorability.

Existing-library repair follows Pilot N1 (`beijing-summer-palace`), Founder decision, Pilot S1 (`tide-letter`), Founder decision, then controlled batches of two to three Journeys. There is no batch rewrite, no 27-Journey rewrite, no nine-special-Journey rewrite, and no Story / Discovery functional duplication before pilot approval. A rejected pilot returns to revision and does not authorize another pilot or mass production.

## 15. Binding AI background production extension

The [PHOENIX AI BACKGROUND PRODUCTION STANDARD](PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md) is the canonical background-production standard for new and replacement Journey backgrounds.

Its Visual DNA, Cross-Journey Differentiation, Shot Plan, 1–3 Pilot, AI Original, Rights Gate, IP Similarity Review, provenance, cultural/historical accuracy, mobile crop, UI readable region, anti-template, performance, versioning, rollback, and runtime-integration rules are `REQUIRED` wherever Journey backgrounds are in scope.

Canonical Journey content remains read-only during visual production. Story, Words, Discovery, Challenge, Memory, and Complete MUST NOT be rewritten to make background production easier.

No Agent or implementation may create a Journey-specific exception, hard-code `PASS`, skip rights review, skip required Founder review, skip Pilot gating, lower the stable visual baseline, alter canonical Story, or remove tests merely to obtain background acceptance. Any exception must be explicit, documented, scoped, and Founder-approved where applicable.
