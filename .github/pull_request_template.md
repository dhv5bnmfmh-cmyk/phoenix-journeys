# Phoenix Pull Request Evidence

## 1. Pull Request identity

- Repository:
- Base branch:
- Base SHA:
- Head branch:
- Head SHA:
- Candidate Commit:
- Candidate Tree:
- Parent Commit:
- Stable PR: `#137`
- Stable Commit: `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`
- Change type:
- Owner:
- Reviewer:

## 2. Scope declaration

- [ ] The changed paths are listed exactly.
- [ ] No unrelated repair is included.
- [ ] Runtime behavior changes are declared.
- [ ] Story changes are declared.
- [ ] Discovery changes are declared.
- [ ] Journey data changes are declared.
- [ ] Image changes are declared.
- [ ] Audio changes are declared.
- [ ] Dependency changes are declared.
- [ ] Production workflow changes are declared.
- [ ] Rights and external-processing changes are declared.

```text
Authorized Paths:
Actual Changed Paths:
Unexpected Paths: NONE / DETAILS
Runtime Files Changed:
Story Files Changed:
Discovery Files Changed:
Journey Data Changed:
Image Files Changed:
Audio Files Changed:
Dependency Files Changed:
Production Workflow Files Changed:
```

## 3. Stable baseline declaration

- [ ] The branch was created from the latest approved stable `main`.
- [ ] `docs/PHOENIX_STABLE_BASELINE_STANDARD.md` was checked before implementation.
- [ ] The candidate satisfies `NEW RESULT >= CURRENT STABLE BASELINE`.
- [ ] PR `#138` through PR `#141` were not used as development baselines.
- [ ] A domain-by-domain `STABLE_BASELINE_COMPARISON` is attached when product behavior or content changes.

## 4. Functional verification

Record exact routes, states, inputs, outputs, expected results, actual results, Result, and Evidence Level.

- [ ] Startup loading and error recovery verified.
- [ ] Home, Explore, Picker, Passport, special Passport, Profile, and Journey routes verified where applicable.
- [ ] Invalid IDs and fallback states do not load unrelated content.
- [ ] Access and entitlement states verified where applicable.
- [ ] Progress, refresh, restart, completion, reward, unlock, and migration verified where applicable.
- [ ] Loading, Error, Empty, and Fallback are independently verified.

## 5. Mobile and accessibility verification

- [ ] Narrow phone portrait verified.
- [ ] Larger phone portrait verified.
- [ ] Landscape verified where supported.
- [ ] Keyboard visible and submission reachable.
- [ ] Safe Area top and bottom verified.
- [ ] Large system text and reflow verified.
- [ ] Scrolling and persistent controls verified.
- [ ] Back navigation and lifecycle return verified.
- [ ] Reduced motion verified where supported.
- [ ] Semantics, focus order, non-color feedback, and assistive input verified.

## 6. Narration and Shadowing verification

- [ ] 故事页朗读、暂停、继续、调速正常
- [ ] 声音、三角形、短文高亮同步
- [ ] Temporary vocabulary and Annotation playback returns to the original position.
- [ ] Route change, background, interruption, failed voice, silent device, and unavailable locale are recorded where applicable.
- [ ] Shadowing permission granted, denied, initialization failure, start, stop, recognition, interruption, and history are recorded where applicable.

## 7. Keyboard and learning-input verification

- [ ] 键盘稳定
- [ ] Keyboard does not cover Reflection, Writing, Memory, dialog, or submission controls.
- [ ] Focus is preserved or intentionally restored.
- [ ] Draft persistence and reopen behavior are verified.

## 8. Visual and rights verification

- [ ] Actual runtime pages were visually reviewed.
- [ ] Crop, focal point, text-safe region, source clarity, composition, small-screen behavior, and Journey identity were reviewed.
- [ ] File existence, dimensions, hashes, automated score, or rights metadata were not used as visual approval.
- [ ] Source, license or permission, modification rights, attribution, runtime path, and Founder approval state are recorded where applicable.
- [ ] Rights approval is separate from visual approval.

## 9. Narrative and Discovery Evidence

Required for every Story, Discovery, or Journey-content PR. Use `NOT_APPLICABLE` only with a documented reason and evidence.

```text
Affected Journey IDs:
Story Function:
Discovery Function:
Protagonist Mode: NORMAL_NAMED_OR_UNIQUELY_IDENTIFIABLE / SPECIAL_QUALIFIED_SECOND_PERSON / DETAILS
Protagonist Identity Evidence:
Relationship:
Relationship Causal Function:
Goal:
Why Goal Matters:
Conflict:
Conflict Connection to Goal:
Enacted Choice:
Choice Evidence:
Caused Consequence:
Consequence Causal Evidence:
Emotional Arc:
Cultural Anchor in Action:
Narrative Engine:
Opening Type:
Progression Structure:
Climax:
Ending State:
Memory Anchor:
Special Mechanism:
Catalog Comparison:
Closest Existing Journey IDs:
Level Invariants:
Automated Check Scope:
Checks Not Covered by Automation:
Automated Structural Result:
Automated Structural Evidence Level:
Human Literary Review:
Human Literary Result:
Human Literary Evidence Level:
Founder Preview Requirement: REQUIRED / NOT_REQUIRED
Founder Preview State: APPROVED / REJECTED / PENDING / NOT_APPLICABLE
```

Required declarations:

```text
Story / Discovery functional overlap: NONE / DETAILS
Narrative template reuse: NONE / DETAILS
Automated score used as literary approval: NO
Batch size: <count>
Pilot approval: APPROVED / REJECTED / PENDING / NOT_APPLICABLE
```

- [ ] Story and Discovery each have a one-sentence Function Contract.
- [ ] Generic second-person perspective alone is not used as protagonist identity.
- [ ] Relationship affects Goal, Conflict, Choice, Consequence, Emotional Arc, or Ending.
- [ ] Choice is enacted.
- [ ] Consequence is caused by the Choice.
- [ ] Cultural anchor affects action or stakes.
- [ ] Opening, climax, and ending are independently reviewed.
- [ ] Story / Discovery functional separation is reviewed beyond exact-text difference.
- [ ] Library-level differentiation matrix is attached.
- [ ] Phoenix Lv.1 through Lv.10 narrative invariants are reviewed.
- [ ] Automated scores are not used as literary approval.
- [ ] Pilot and batch gates are satisfied.

## 10. New Journey or repair-pilot gate

```text
Work Type: NONE / PROPOSAL / PILOT_N1 / PILOT_S1 / CONTROLLED_BATCH / NEW_JOURNEY
Journey Count:
Pilot Journey ID:
Prior Pilot Decision:
Prior Pilot Commit:
Founder Mobile Decision:
Next Phase Authorized: YES / NO
```

- [ ] No second pilot started before the first pilot decision.
- [ ] No batch rewrite started before pilot approval.
- [ ] No 27-normal-Journey or nine-special-Journey rewrite is included.
- [ ] A controlled batch contains two to three Journeys unless separately authorized.
- [ ] Every Journey has an independent acceptance record.

## 11. Automated validation

Do not mark queued or in-progress work as success.

```text
Worker Governance Tests:
Flutter Analyze:
Flutter Tests:
Web Release Build:
Cloudflare Worker Bundle Validation:
Cloudflare PR Preview:
Exact Changed-Path Verification:
Tests Deleted:
Tests Skipped:
```

- [ ] No `test.skip`.
- [ ] No `test.only`.
- [ ] No always-true assertion.
- [ ] Existing tests are preserved.
- [ ] Automated validation claims are limited to implemented checks.

## 12. Preview and release identity

- [ ] The PR Preview is isolated.
- [ ] The Preview uses the feature Head SHA, not the PR merge ref.
- [ ] The Preview health or release marker matches the candidate Head SHA.
- [ ] Preview verification completed before the link was published.
- [ ] A PR Preview hostname is not used as production evidence.
- [ ] Preview product behavior is compared with current main where the task is governance-only.

## 13. Privacy, Secrets, and external processing

- [ ] No Secret is committed.
- [ ] Worker Secrets remain server-side.
- [ ] External providers and submitted fields are declared.
- [ ] `store: false`, logging, retention, redaction, deletion, and processor evidence are recorded where applicable.
- [ ] Unpublished Phoenix content was not sent to an unapproved external service.

## 14. Regression decision

```text
Function:
Interaction:
Mobile:
Accessibility:
Performance:
Content:
Story / Discovery:
Languages:
Narration:
Shadowing:
Visual Mapping:
Visual Quality:
Rights:
Routing:
Persistence:
Access / Entitlement:
Privacy / Secrets:
Stable Comparison:
Regression Count:
Final Result:
```

Any `REGRESSION`, missing REQUIRED evidence, unresolved blocking code, or required Founder approval that is not `APPROVED` blocks Ready and merge.

## 15. Founder and merge gate

- [ ] Founder review is tied to the exact candidate Commit and Preview.
- [ ] Founder-required visual, interaction, Story, Discovery, mobile, or pilot review is `APPROVED`.
- [ ] The PR remains Draft until all required terminal checks and evidence gates pass.
- [ ] 用户已确认可以合并到 `main`

The last checkbox MUST NOT be checked by an agent without explicit user authorization. Ready and merge are separate explicit actions.
