# Phoenix Development Completion Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the evidence required before any Phoenix development task may be marked Completed, moved to Ready, merged, expanded, or used to start a later stage.

Completion is a product decision, not a synonym for “code written,” “files created,” “CI started,” or “Preview deployed.”

## 2. Mandatory completion conditions

A task may be Completed only when all applicable conditions are `PASS` with `VERIFIED` evidence:

- repository, branch, candidate Commit, and Tree are identified;
- parent and baseline are correct;
- authorized scope and changed paths are exact;
- no unauthorized or unrelated change exists;
- required technical validation reached a successful terminal state;
- the candidate is reproducible in the required environment;
- the complete `STABLE_BASELINE_COMPARISON` is submitted;
- no regression exists;
- required Founder mobile approval is `APPROVED`;
- PR state and merge decision satisfy the task authorization.

## 3. Mandatory STABLE_BASELINE_COMPARISON

Every development task MUST include the following exact report structure:

```text
STABLE_BASELINE_COMPARISON

Stable PR:
Stable Commit:
Candidate Commit:
Changed Scope:
Changed Paths:
Compared Pages:
Compared Journeys:
Compared Features:
Compared Assets:
Visual Result:
Functional Result:
Interaction Result:
Mobile Result:
Performance Result:
Content Result:
Audio Result:
Accessibility Result:
Rights Result:
Unexpected Regression:
Founder Preview Required:
Founder Preview Link:
Founder Preview Result:
Final Comparison Decision:
```

Each result field MUST use `PASS`, `REQUIRES_REVISION`, `REGRESSION`, `BLOCKED`, or `NOT_APPLICABLE`. Every material claim MUST also identify an evidence level: `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, or `CONTRADICTORY`.

## 4. Comparison method

The comparison MUST use equivalent conditions wherever applicable:

- same device class and viewport;
- same route and entry path;
- same Journey and stage;
- same language;
- same account, free/paid, locked/unlocked, and progress state;
- same interaction sequence;
- equivalent network and cache conditions;
- exact stable and candidate identities.

Any non-equivalent condition MUST be disclosed. A conclusion that depends on unmatched conditions cannot be `VERIFIED`.

## 5. Required implementation proof

The developer or executing Agent MUST prove:

- the correct page component was used;
- the correct route and route parameters were used;
- the correct Journey ID and Story ID were used;
- the correct data, language, and stage records were used;
- the correct asset paths were used;
- stable resources were not accidentally deleted, renamed, retired, or rerouted;
- closed PRs `#138`–`#141` were not used as the development baseline;
- no unauthorized file was changed;
- no task-unrelated change was included;
- loading, error, empty, and fallback paths remain correct;
- persistence, reward, entitlement, and accessibility behavior remain correct where affected.

Assertions without exact paths, SHA, diff, runtime evidence, or reproducible output are `UNVERIFIED`.

## 6. Evidence package

The completion package MUST include applicable:

- repository and PR identity;
- starting and final branch Head;
- candidate Commit and Tree;
- parent Commit verification;
- complete changed-path list;
- exact diff or file evidence;
- command, environment, and output for local validation;
- CI run IDs, job IDs, and terminal conclusions;
- reproducible Preview link and route instructions;
- stable and candidate screenshots or recordings;
- mobile viewport and device information;
- performance measurement method;
- content and multilingual review evidence;
- narration/audio evidence;
- accessibility evidence;
- rights and source evidence;
- Founder approval record;
- final comparison decision.

When no local execution environment exists, local checks MUST be reported as:

`NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT`

They MUST NOT be reported as `PASS`.

## 7. Changed-scope verification

The final report MUST distinguish:

- files added;
- files modified;
- files deleted;
- runtime files changed;
- image files changed;
- Story or Journey data changed;
- audio files changed;
- dependencies changed;
- workflows changed;
- configuration changed;
- unexpected paths.

The changed-path inventory MUST be compared with the authorized scope. One unexpected path is sufficient to block completion until reviewed.

## 8. Technical validation

Required validation depends on scope. The report MUST state the actual status of every required check:

- `NOT_TRIGGERED`;
- `QUEUED`;
- `IN_PROGRESS`;
- `SUCCESS`;
- `FAILURE`;
- `CANCELLED`;
- `NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT`.

A queued or in-progress check is not terminal success. A check from another Commit is not candidate evidence. A retry MUST preserve the history of the original failure.

## 9. Preview and mobile validation

A Preview deployment proves only that a Preview was deployed. It does not prove correct routes, visuals, interactions, content, audio, performance, or mobile quality.

The report MUST identify:

- exact candidate Commit;
- Preview URL;
- route and state instructions;
- tested pages and Journeys;
- device or viewport;
- result and evidence level;
- known limitations.

Founder mobile approval is mandatory for visual changes, image changes, layout hierarchy changes, navigation changes affecting core flow, and core interaction changes.

## 10. Rights and visual separation

Rights evidence MUST be verified separately from technical and visual acceptance.

A visual asset requires all applicable gates:

1. Rights Gate;
2. Technical Gate;
3. Visual Quality Gate;
4. Stable Baseline Comparison Gate;
5. Founder Mobile Preview Approval Gate.

No file hash, source record, dimensions, compliance field, or automated score may replace actual visual and mobile evidence.

## 11. Missing report status

When the `STABLE_BASELINE_COMPARISON` is absent or materially incomplete, the only allowed completion status is:

`INCOMPLETE_STABLE_BASELINE_COMPARISON_MISSING`

The task MUST NOT be marked Completed, moved to Ready, merged, expanded, or used to start the next stage.

## 12. Regression status

When any applicable category is below the current stable baseline, the mandatory status is:

`REGRESSION_BLOCKS_READY_AND_MERGE`

The response MUST identify:

- affected route, page, Journey, feature, asset, or state;
- stable evidence;
- candidate evidence;
- impact and severity;
- required restoration or repair;
- verification needed after repair.

## 13. Completion blockers

Completion is blocked when any of the following is true:

- wrong repository, branch, parent, base, or candidate identity;
- candidate started from an unapproved baseline;
- closed PR used as baseline;
- unauthorized or unrelated path changed;
- required validation is absent, non-terminal, failed, or stale;
- Preview is unavailable or not tied to candidate;
- required mobile evidence is absent;
- Founder approval is pending, absent, rejected, or tied to another Commit;
- an applicable result is `REQUIRES_REVISION`, `REGRESSION`, or `BLOCKED`;
- material evidence is `PARTIALLY_VERIFIED`, `UNVERIFIED`, or `CONTRADICTORY`;
- stable feature, route, content, resource, or user data is lost;
- rights approval is used as a substitute for product quality.

## 14. Final decision rules

### `PASS`

May be used only when all Mandatory conditions are satisfied with VERIFIED evidence and no blocker exists.

### `REQUIRES_REVISION`

Use when the candidate needs improvement or missing non-regression work before completion.

### `REGRESSION`

Use whenever the candidate is below the stable baseline in any applicable category.

### `BLOCKED`

Use when evidence, environment, dependency, permission, Preview, or approval prevents a valid decision.

### `NOT_APPLICABLE`

Use only with an explicit reason tied to scope.

## 15. Ready and merge authorization

A completion report does not itself authorize Ready or merge. The task and PR MUST also have explicit authorization for those transitions.

When a task says to keep a PR Draft, not merge, or wait for Founder review, the completion report MUST preserve that state even after all documentation or implementation work is finished.

## 16. Relationship to other standards

Completion MUST also comply with:

- [Phoenix Stable Baseline Standard](PHOENIX_STABLE_BASELINE_STANDARD.md)
- [Phoenix Product Quality Standard](PHOENIX_PRODUCT_QUALITY_STANDARD.md)
- [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md)
- [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md)
- [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md)
- [Phoenix Full Application Audit Standard](PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md)

## 17. Permanent enforcement

No developer, reviewer, Agent, script, CI result, or PR checkbox may redefine “Completed” more weakly than this standard.