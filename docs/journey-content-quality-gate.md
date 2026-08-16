# Phoenix Journey Content Quality Agent

`PhoenixJourneyContentQualityAgent` is a deterministic **automated content-contract gate**. It is not the release authority for literary quality, human Story differentiation, Founder approval, or Gold promotion.

The binding Story-quality authority remains the combination of:

- `docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md`;
- `docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md` where applicable;
- `docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md` and the current acceptance matrices;
- `ai/AI_BEHAVIOR.md`;
- the canonical semantic fingerprint registry for Rule A / Rule B;
- explicit Founder approval where required.

## Automated decisions

The deterministic agent may return:

- `approved`: automated content-contract checks pass; the content is **eligible to enter human/Founder review**;
- `needsRevision`: one or more automated improvement findings remain;
- `blocked`: one or more automated blocking findings remain.

`approved`, `isPublishable`, and `canPublish` are legacy/runtime names whose scope is strictly the automated content gate. They MUST NOT be read or reported as `STORY QUALITY PASS`, `NARRATIVE QUALITY PASS`, `GOLD READY`, or Founder approval.

## Separate authority states

Every Story-quality report must keep these states distinct:

```text
MACHINE_CONTENT_GATE: PASS / FAIL
MACHINE_SEMANTIC_GATE: PASS / FAIL
AGENT_SEMANTIC_SUFFICIENCY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
AGENT_LITERARY_REVIEW: PASS / REQUIRES_REVISION / BLOCKED / PENDING
HUMAN_NARRATIVE_ANTI_TEMPLATE: PASS / REQUIRES_REVISION / BLOCKED / PENDING
PREVIOUS_VERSION_UI_FUNCTION_PARITY: PASS / FAIL / PENDING
FOUNDER_STORY_APPROVAL: APPROVED / REJECTED / PENDING
OVERALL_STORY_QUALITY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
AUTOMATED_SCORE_USED_AS_LITERARY_APPROVAL: NO
```

Rule A = 0 and Rule B = 0 establish only the machine semantic-collision result. They do not establish human-reader differentiation.

## What the deterministic agent reviews

The agent runs across the configured Phoenix Journey catalog and language levels. Depending on current implementation it may review:

- approved character ranges and paragraph shape;
- required structural fields and content presence;
- opening/closing contract signals implemented by code;
- pinyin, Vietnamese, and English alignment checks implemented by code;
- Discovery novelty/depth checks implemented by code;
- vocabulary validity and duplication;
- separation between comprehension and expression prompts;
- special-Journey genre signals;
- exact duplication and other deterministic content rules.

The report must state the exact implemented scope rather than imply natural-language understanding that the code does not possess.

## What the deterministic agent cannot prove

Automated green status cannot prove:

- that a protagonist feels alive;
- that a Goal matters for a human reason;
- that a Relationship is emotionally or causally meaningful;
- that a Choice carries a real cost;
- that a climax is more than a revised method succeeding;
- that Chinese prose feels natural rather than engineered;
- that exposition is artistically restrained;
- that a Story contains a memorable human moment;
- that Story Shape is genuinely different to a reader;
- that a de-skinned Story spine does not collide with an approved Gold Story;
- that Lv5 works as literature;
- that Lv10 deepens rather than inflates;
- that removing the final explanation improves the ending;
- that Founder approved the exact candidate.

## Expansion Gate

When a new Journey proposal is in scope, the Quality Gate enforces the Expansion Gate minimal checks (machine or human where applicable):

- ONE PLACE != ONE STORY — multiple independent Journeys per Place are permitted but require Same-Place Differentiation proof.
- SAME-PLACE STORY DIFFERENTIATION — human same-place comparison of opening, protagonist, relationship, Goal, Conflict, Choice, Cost, Climax, Consequence, Memory Moment, Story Shape, and cultural mechanism.
- TRUTH MODE — candidate must declare Truth Mode and provide evidence classification (VERIFIED HISTORY / VERIFIED CULTURAL FACT / CONTEMPORARY FICTION / FICTIONAL CHARACTER IN VERIFIED HISTORICAL SETTING / FOLKLORE / LITERARY TRADITION).
- INCREMENTAL VALUE — candidate must demonstrate Incremental Cultural Value and Incremental Human Value.
- COVERAGE DOES NOT OVERRIDE GOLD — coverage goals or story-count targets must not reduce or bypass Gold acceptance requirements.

Those are Agent/human/Founder review responsibilities defined by the canonical Story standards and design matrix.

## Human literary and anti-template handoff

After the automated content gate and machine semantic gate pass, the Story must still complete the human gates in `PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md`, including:

- protagonist humanity;
- relationship deletion test;
- human stakes;
- Cost of Choice Review;
- climax-quality review;
- behavioral transformation;
- Story Memory Moment;
- Story Shape;
- de-skinned Story Spine against every current Founder-approved Gold Story;
- nearest Story collision;
- Chinese narrative quality;
- exposition / AI case-study tone risk;
- Lv1 Human Story Proof;
- Lv5 primary literary review;
- Lv10 deepen-not-inflate review;
- LAST_EXPLANATION_REMOVAL_TEST.

A human Story collision blocks Gold readiness even when deterministic semantic collision arithmetic is green.

## Mandatory Story development closed loop

Every AI Story development or remediation cycle MUST follow this loop on the **current exact candidate head**:

> **MODIFY OR CREATE STORY → CHANGE / COMPLIANCE PROOF → PREVIOUS-VERSION UI + FUNCTION PARITY → MACHINE CONTRACT CHECK → MACHINE SEMANTIC CHECK → AGENT LITERARY REVIEW → HUMAN DE-SKINNED CATALOG COMPARISON → RUNTIME STORY PARITY → EXACT-HEAD PREVIEW → FOUNDER REVIEW → APPROVE OR REVISE**

The loop has two different entry proofs:

1. **Existing Story modification / remediation — ACTIVE STORY CHANGE PROOF**
   - compare the pre-change Story with the current runtime-active Story;
   - verify the intended protagonist, relationship, Story Shape, decisive action, Memory Moment, and ending actually changed where the remediation requires them to change;
   - verify rejected names, plot references, artifacts, and Story skeletons are absent from every active runtime route, including adaptive language-level rendering;
   - old Story material may remain only as explicitly non-runtime historical evidence when useful for audit.

2. **New Story development — NEW STORY COMPLIANCE PROOF**
   - verify the candidate against all binding Narrative, New Journey, acceptance, Story Truth, place-causality, Lv1/Lv5/Lv10, Chinese narrative quality, and human Story requirements before Preview;
   - no new Story may reach Preview merely because fields are complete or CI is green.

## Previous-version UI + Function Parity Gate

For every Story-only modification or new Story implementation, the Agent MUST record the exact pre-change baseline SHA and prove that Phoenix remains the same product outside the explicitly authorized Story/content delta.

Before editing, the Agent MUST establish a **changed-file and changed-field allowlist**. For a Story-only task, production changes are restricted to the target Story and the minimum Story-grounded bindings required because the Story itself changed. UI, navigation, Passport, Map, backgrounds, rewards, coins, challenge architecture, progress, location hierarchy, shared runtime architecture, unrelated catalogs, unrelated Journeys, and other product behavior are outside the allowlist unless the Founder explicitly authorizes them.

Before any Preview is generated, the Agent MUST compare the candidate against the recorded baseline and set:

`PREVIOUS_VERSION_UI_FUNCTION_PARITY = PASS / FAIL`

A PASS requires all of the following:

- the changed-file diff contains no unauthorized product or UI files;
- the changed-field diff contains no unauthorized product configuration changes;
- layout, navigation, screen order, controls, product modes, rewards/coins, Passport, Map, progress, challenge behavior, completion behavior, and unrelated runtime behavior remain unchanged from the baseline;
- Journey ID, GeoNode, route/catalog membership, and unrelated Journey records remain unchanged unless the Story task explicitly requires a documented content-binding correction;
- all non-target Journeys retain their previous behavior and data;
- the target Journey continues through the pre-existing product architecture unless the Founder explicitly authorizes an architecture change;
- the only Founder-visible differences are the authorized Story/content changes and their minimum necessary Story-grounded text bindings;
- available regression, widget, golden, route, runtime, and catalog tests remain green; absence of a particular automated UI test does not waive the diff and behavior comparison requirement.

Any unauthorized visible or behavioral delta is a **SCOPE VIOLATION** and forces:

`PREVIOUS_VERSION_UI_FUNCTION_PARITY = FAIL`

When this happens, the candidate MUST NOT be patched forward by preserving the unauthorized redesign. The Agent MUST discard or revert the violating product changes, restore the previous Phoenix product behavior, return to the clean baseline, re-apply only the authorized Story delta, and restart the complete closed loop on a new exact head.

A correct Story is never permission to redesign Phoenix. Passing Story tests is never permission to alter unrelated software behavior. No AI agent may infer product-change authorization from failing tests, implementation convenience, refactoring preference, or a desire to make the Story easier to wire.

For **both** modified and new Stories, the Agent MUST then:

- run Rule A / Rule B against the complete current approved-Gold semantic catalog;
- compare `DE-SKINNED STORY SPINE`, `STORY SHAPE`, protagonist/life-stage pattern, relationship geometry, opening pattern, climax pattern, ending pattern, Story Memory Moment, and emotional texture against **every** current Founder-approved Gold Story;
- record `AGENT_LITERARY_REVIEW` separately from machine results;
- fail the cycle if the Story is materially the same template with only city, profession, names, culture nouns, props, or wording changed;
- prove **RUNTIME STORY PARITY** through the same resolver/rendering path used by the product for Founder-visible Lv1/Lv5/Lv10. A release SHA health check, successful deploy, catalog-unit test, or source-file assertion alone is insufficient if the rendered Story can still come from an old/generic path;
- generate and hand off an exact-head Preview only after all pre-Preview Story gates pass.

`RUNTIME STORY PARITY` MUST verify at minimum:

- Founder-visible Lv1, Lv5, and Lv10 resolve from the intended active Story package;
- expected current protagonist / relationship / decisive Story markers are present;
- rejected prior-Story markers and generic fallback Story text are absent;
- the Preview release SHA equals the reviewed candidate SHA.

Founder review closes the loop:

- before Founder decision: `FOUNDER_STORY_APPROVAL = PENDING`;
- if Founder rejects, requests changes, or reports runtime/content mismatch: the previous Preview/review result is invalidated, Story work returns to `MODIFY OR CREATE STORY`, and **the entire gate sequence must rerun on a new exact head**;
- if Founder approves the Story but has not explicitly authorized merge: keep the PR open and unmerged;
- Merge is permitted only after the explicit instruction `FOUNDER APPROVED FOR MERGE` and only for the exact candidate that completed the loop.

No AI agent may skip directly from code change or green CI to Founder handoff. No prior Preview, prior machine score, prior literary review, prior parity result, or prior Founder review may be reused after a Story-affecting change without rerunning the applicable gates.

## Visible PR report

`app/tool/generate_journey_quality_report.dart` must expose the automated gate separately from pending human/Founder states. A clean automated report should use language equivalent to:

`AUTOMATED CONTENT GATE: PASS — ELIGIBLE FOR HUMAN REVIEW`

It must not say that machine green alone authorizes release or Gold Story acceptance.

## CI enforcement

CI may enforce deterministic contract failures and may verify that required human-review records/states exist. CI must not hard-code literary approval or claim that string presence, scores, test counts, or enum arithmetic independently prove literary quality.

A valid build may be machine-green while `OVERALL_STORY_QUALITY = PENDING` because human literary review or Founder review is still pending. That is a truthful state, not a CI failure by itself unless the current workflow phase explicitly requires those approvals.
A deterministic PASS remains only a machine gate. For Story/Culture/Level work, the release record MUST additionally preserve: Cultural Fact Action evidence, human Place Causality, Cultural Knowledge Residue, Story/Discovery bridge, Discovery depth, three gradients, five cognitive bands, adjacent semantic deltas, backward completeness, Lv10 mastery, exact four-language alignment, vocabulary provenance, and learner-visible QA-language sweep.

Founder authority is exact-head and SHA-bound. `PR HEAD = Founder-reviewed Candidate = Preview release`. A later source commit invalidates the prior approval even when every automated check stays green.

## Single-track development gate

Phoenix uses `PHOENIX SINGLE-TRACK DEVELOPMENT`: permanent branch `main`; maximum active development branches = 1; maximum active development PRs = 1; maximum active development lines = 1. Before any repository write, verify `STARTING_MAIN_SHA`, `ACTIVE_DEVELOPMENT_BRANCH`, `ACTIVE_DEVELOPMENT_PR`, and `REMOTE_ACTIVE_DEVELOPMENT_LINE_COUNT`. More than one line is `MULTIPLE ACTIVE DEVELOPMENT LINES — BLOCKED`.

New work must fetch current remote main and branch from that exact SHA. `RELATED HISTORY != CURRENT SOURCE OF TRUTH`. Journey work is one Journey, one PR, one branch, and one line; unrelated product, standards, UI, or remediation work may not run beside it without explicit Founder scope.

The gate includes `NO SILENT PRODUCT REPLACEMENT`: `ABSENCE OF AUTHORIZATION = PRESERVE CURRENT MAIN`. Record a `PROTECTED BASELINE MANIFEST` before writing and prove `AUTHORIZED DELTA + PROTECTED BASELINE PARITY` at closeout.

`FILE EXISTS != ACTIVE PRODUCT`. Current judgments must establish active runtime identity from `ACTIVE RUNTIME`, `ACTIVE RESOLVER`, `ACTIVE BINDING`, and `CURRENT MAIN` before using content as defect evidence. Legacy constants and inactive packages cannot define current product behavior. Founder approval remains SHA-bound.

## Challenge Gold gate

Challenge quality is governed in detail by [Phoenix Six-Stage Journey Standard §3](PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes). This gate only records its acceptance boundary to avoid a parallel standard.

A Gold candidate MUST demonstrate: clear primary learning intent; teach-before-test; differentiated `paragraphRebuild` / `grammarRepair` / `missingSentence`; one defensible best answer; plausible and diagnosable distractors; active-content provenance; level-appropriate cognitive progression; Story/Discovery closed loop; Historical Truth; and human Lv1/Lv5/Lv10 Challenge review. Any required failure blocks the quality gate even when mode-presence tests and aggregate scores are green.
