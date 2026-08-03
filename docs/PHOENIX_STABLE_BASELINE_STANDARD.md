# Phoenix Stable Baseline Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the only approved Phoenix product baseline and the rules for comparing, approving, updating, and restoring that baseline. It applies to every developer, reviewer, Codex task, automation, pull request, Preview, and release decision.

The binding rule is:

> **NEW RESULT >= CURRENT STABLE BASELINE**

A candidate is not complete merely because files exist, tests pass, a Preview deploys, or rights records are present. The candidate must preserve or improve the verified stable product experience.

## 2. Current binding baseline

The current and only approved stable product baseline is:

- Stable PR: `#137`
- Stable `main` Commit: `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`
- Stable branch: `main`

PR `#132` is a historical merged version and is not the current development baseline. Closed PRs `#138`, `#139`, `#140`, and `#141` are historical and problem evidence only. They MUST NOT be used as a development baseline, inherited implementation source, visual reference, or merge target.

The stable baseline does not automatically move to the newest PR, newest Commit, newest Preview, newest successful CI run, or newest merged documentation. A candidate becomes the new stable baseline only after all update conditions in Section 4 are satisfied.

### 2.1 Authority and precedence

This file, `docs/PHOENIX_STABLE_BASELINE_STANDARD.md`, is the single normative authority for Phoenix stable-baseline identity.

- Other governance documents MAY reference the current Stable PR and Stable Commit, but MUST NOT independently define a different current baseline.
- When any document conflicts with this standard, this standard controls the baseline decision and the conflicting document MUST be corrected in the same revision.
- A conflict MUST NOT be silently ignored.
- Permanent product-rule references MUST NOT be deleted merely to hide a baseline conflict; the valid permanent rules must be preserved while the obsolete baseline identity is corrected.
- After any approved stable-baseline update, every governance document containing a hard-coded Stable PR or Stable Commit MUST be updated in the same controlled change.
- Every future development task MUST begin from the latest approved stable `main` identified by this standard.

## 3. Baseline scope

Comparison against the stable baseline MUST cover every applicable category:

- functional completeness;
- page completeness and correct integration;
- routes and navigation;
- assets and resource paths;
- visual quality;
- interaction quality;
- mobile experience and safe areas;
- page stability;
- performance;
- loading, error, empty, and fallback states;
- content quality;
- multilingual consistency;
- narration and audio;
- progress and persistence;
- accessibility;
- access and entitlement;
- privacy, secrets, and external disclosure;
- rights and provenance evidence;
- unexpected feature or resource loss.

Any applicable category below the stable baseline is `REGRESSION`.

## 4. Stable baseline update conditions

The stable baseline MAY be updated only when all of the following are VERIFIED:

1. The candidate started from the latest approved stable `main`.
2. The authorized task scope and changed paths are exact and complete.
3. Required automated validation reached a terminal successful state.
4. The mandatory `STABLE_BASELINE_COMPARISON` is complete.
5. No category is `REGRESSION`, `BLOCKED`, `UNVERIFIED`, or `CONTRADICTORY`.
6. Relevant pages and flows are reproducible in an isolated Preview.
7. Visual or core interaction changes received explicit Founder mobile Preview approval.
8. Rights and provenance gates passed without reducing product quality.
9. The PR explicitly states that it is proposed as the next stable baseline.
10. The Founder explicitly approves the candidate and its exact Commit.
11. The approved PR is merged into `main`.
12. The resulting `main` Commit is recorded as the new stable Commit.
13. Every governance document with a hard-coded baseline identity is synchronized to the new approved identity.

Until all conditions are satisfied, the binding baseline remains PR `#137` and Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`.

## 5. PR #137 minimum product and visual standard

PR `#137` is the minimum acceptable product experience, not an optional reference.

A candidate MUST preserve or exceed:

- stable page access and navigation;
- complete Journey and learning flows;
- correct resource routing;
- high-resolution scene imagery;
- clear foreground, midground, and background depth;
- lighting, weather, material, atmosphere, and spatial detail;
- independent city and Journey identity;
- correct mobile crop, focal point, and readable text area;
- stable narration, interaction, progress, access, and fallback behavior;
- the verified visual completion of Home, Explore, Passport, Profile, Shadowing, normal Journeys, and special Journeys.

Production visuals MUST NOT be replaced by low-detail programmatic SVG/WebP, flat backgrounds, recolored templates, repeated compositions, placeholders, or images with lower detail density than the stable baseline.

Rights completeness does not equal visual approval. Rights, technical validity, visual quality, stable comparison, and Founder approval are separate mandatory gates.

See [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md) and [Phoenix Product Quality Standard](PHOENIX_PRODUCT_QUALITY_STANDARD.md).

## 6. Mandatory stable baseline comparison

Every completed development task MUST submit the report defined by [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md).

The comparison MUST use equivalent conditions wherever applicable:

- same device class and viewport;
- same page or route;
- same Journey and content state;
- same user entitlement and unlock state;
- same interaction path;
- equivalent network and loading conditions;
- stable and candidate evidence that another reviewer can reproduce.

Missing report status:

`INCOMPLETE_STABLE_BASELINE_COMPARISON_MISSING`

Any verified downgrade status:

`REGRESSION_BLOCKS_READY_AND_MERGE`

Automated tests do not replace Preview evidence or human mobile evaluation.

## 7. Regression blocking rule

When any regression is found:

- the task MUST NOT be marked Completed;
- the PR MUST remain Draft or be returned to Draft;
- the PR MUST NOT be merged;
- the batch MUST NOT expand;
- the next phase MUST NOT start;
- the regression MUST be repaired, or the candidate MUST be restored to the stable behavior;
- the comparison MUST be repeated after repair.

No numeric score, checkbox count, file hash, compliance field, or aggregate percentage may override a verified regression.

## 8. Founder mobile approval

Founder mobile Preview approval is mandatory for:

- visual changes;
- image replacement or rerouting;
- layout hierarchy changes;
- core interaction changes;
- navigation changes that affect user flow;
- batch visual expansion;
- any change whose quality cannot be established through repository evidence alone.

Approval MUST identify the candidate Commit or reproducible Preview. `PENDING`, absent, informal, or unrelated approval blocks Ready and merge.

## 9. Small-batch pilot rule

High-risk visual or Journey work MUST begin with a controlled pilot:

- one Journey or one page;
- one to three sample images for a visual concept;
- one isolated Preview;
- one stable baseline comparison;
- Founder mobile approval before expansion.

A completed batch of unapproved work does not create permission to keep or expand it.

New Journey creation follows [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md). The first cycle permits only one new Journey pilot.

## 10. Rollback and restoration

When a candidate causes regression, incorrect routing, missing stable assets, failed fallback, or rejected visual direction, the safe default is restoration to the current stable behavior.

Rollback MUST:

1. identify the exact stable Commit and affected paths;
2. preserve unrelated approved work;
3. remove only the unauthorized or regressive candidate changes;
4. verify routes, assets, pages, and persistence after restoration;
5. repeat the stable baseline comparison;
6. retain evidence of the incident and corrective action.

A rollback MUST NOT use a closed PR as the restoration source unless the exact content is independently proven to be identical to the approved stable baseline.

## 11. Evidence and decision language

Product results use only:

- `PASS`
- `REQUIRES_REVISION`
- `REGRESSION`
- `BLOCKED`
- `NOT_APPLICABLE`

Evidence levels use only:

- `VERIFIED`
- `PARTIALLY_VERIFIED`
- `UNVERIFIED`
- `CONTRADICTORY`

A result may be `PASS` only when its required evidence is `VERIFIED`. `NOT_APPLICABLE` requires a scoped applicability reason and evidence; it is not automatic `PASS`. Evidence gaps MUST remain visible and MUST NOT be converted into assumed success.

## 12. Enforcement

All Phoenix PRs MUST use `.github/pull_request_template.md` and comply with the related standards:

- [Phoenix Product Quality Standard](PHOENIX_PRODUCT_QUALITY_STANDARD.md)
- [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md)
- [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md)
- [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md)
- [Phoenix Full Application Audit Standard](PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md)
- [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md)
- [Phoenix Quality Unification Roadmap](PHOENIX_QUALITY_UNIFICATION_ROADMAP.md)
- [Phoenix Journeys Development Workflow](development-workflow.md) for permanent narration, vocabulary, access, AI, privacy, Secret, and user-experience rules.

No task, Agent, reviewer, automation, or conflicting governance document may weaken this standard through a narrower local instruction.