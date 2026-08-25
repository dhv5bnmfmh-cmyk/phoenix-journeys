# Phoenix Failure Lessons

Canonical governance record for recurring Phoenix development and validation failures. This file is governance only. A red validation gate is not learner-product evidence until the failing boundary proves a learner-facing defect on the exact formal candidate.

## Core rules

1. **CLASSIFY BEFORE FIXING.** Separate PRODUCT, HARNESS, PATCH-MECHANISM, ENVIRONMENT, and EVIDENCE failures before touching learner code.
2. **FORMAL PRODUCT HEAD STAYS IMMUTABLE DURING HARNESS REPAIR.** Validation infrastructure adapts to the real product contract, never the reverse.
3. **CHEAP BEFORE EXPENSIVE.** Syntax, fixture, identity, scope, and semantic preflights run before browser installation, full suites, preview deploys, or duplicate cross-Journey gates.
4. **EXACT HEAD OR NO RELEASE CLAIM.** Preview, CI, browser evidence, and Founder handoff must resolve to the exact formal SHA.
5. **REUSE UNINVALIDATED EVIDENCE WHILE PRODUCT SHA IS FROZEN.** Harness/docs changes do not automatically invalidate already-green product CI, Preview, Mobile, or unrelated reference-Journey evidence.

---

## PATCH-MECHANISM FAILURE

**Failure**  
Shanghai run `32814724621`, job `97700622623`, failed at `Capture helper generator outside repository tree`. Product checkout, Flutter setup, dependencies, targeted tests, Analyze, and full Flutter tests never started.

**Classification**  
`HARNESS / PATCH-MECHANISM FAILURE`

**Root Cause**  
The helper capture/replay mechanism was invalid before learner-product execution.

**Correct Fix**  
Repair only helper transport/patch/workflow mechanics. Require every patch target count to be exactly one, capture helpers outside destructive checkout scope when needed, and run syntax checks before expensive dependencies.

**Forbidden Fix**  
Do not modify Story, Vocabulary, Discovery, Challenge, Memory, Completion, ReadingAnnotation, UI, or navigation to compensate for helper delivery failure.

**Cheap Preflight**  
Capture/replay helper -> exact patch-target count -> smallest unique target -> helper-only patch -> `node --check` / `python -m py_compile` as appropriate -> stop before Flutter/browser work on failure.

**Long-term rule**  
`PATCH DELIVERY FAILURE != PRODUCT FAILURE`

---

## BROWSER INTERACTION CAPABILITY: CLICK VS TAP

**Failure**  
A universal `tap()` path was used for desktop Chromium and touch WebKit.

**Classification**  
`HARNESS / BROWSER-INTERACTION FAILURE`

**Root Cause**  
Browser capability and interaction mode were conflated.

**Correct Fix**  
Use one semantic activation abstraction with explicit desktop-click and mobile-touch modes.

**Forbidden Fix**  
Do not fake touch capability on desktop or alter learner UI to make the harness pass.

**Cheap Preflight**  
Before multi-level E2E, prove one real semantic activation and expected state transition in each browser mode.

**Long-term rule**  
`INTERACTION MODE IS PART OF THE HARNESS CONTRACT`

---

## SEMANTIC STATE > IMPLICIT NAVIGATION WAIT

**Failure**  
Desktop Chromium reached the correct Shanghai `1/6 Story` SPA state, while Playwright continued waiting for an irrelevant browser navigation lifecycle and timed out.

**Classification**  
`HARNESS / SPA-ACTIVATION WAIT FALSE NEGATIVE`

**Root Cause**  
A Flutter SPA semantic transition was coupled to traditional navigation waiting.

**Correct Fix**  
Trigger the real interaction, then wait for explicit application semantics.

**Forbidden Fix**  
Do not modify routing/UI to manufacture a browser navigation event.

**Cheap Preflight**  
Open the target Journey through the real UI and require its first stable six-stage semantic state.

**Long-term rule**  
`SEMANTIC STATE > IMPLICIT NAVIGATION WAIT`

---

## INVARIANT MEANING != INVARIANT WORDING

**Failure**  
A Shanghai Story validator required one identical place literal at every adaptive level even when the correct Bund spatial engine was preserved through level-appropriate wording.

**Classification**  
`HARNESS / SEMANTIC-ANCHOR FALSE NEGATIVE`

**Root Cause**  
Level-invariant meaning was encoded as level-invariant surface wording.

**Correct Fix**  
Validate narrative identity, hard Journey identity, and semantic role groups. For Shanghai, preserve `west-bank Bund -> river crossing -> east-bank Lujiazui` without forcing identical prose.

**Forbidden Fix**  
Do not inject literals into correct learner prose merely to satisfy a brittle assertion.

**Cheap Preflight**  
Replay representative real semantics and a negative fixture that keeps the protagonist but removes the Journey-specific spatial engine.

**Long-term rule**  
`INVARIANT MEANING != INVARIANT WORDING`

---

## STAGE CORPUS != CURRENTLY MOUNTED SEGMENT

**Failure**  
WebKit Lv8 Discovery showed narration item `1 / 2` containing `海运提单`; `1990` existed later in the same formal Discovery Stage corpus. The harness validated only the currently revealed segment and falsely failed the Stage-level anchor.

**Classification**  
`HARNESS / SEGMENTED-DISCOVERY VISIBILITY FALSE NEGATIVE`

**Root Cause**  
Currently mounted/revealed semantics were treated as the entire Stage corpus.

**Correct Fix**  
Stay in real `3/6 Discovery`, follow the runtime's actual narration/item progression, collect all stable segment semantics, validate anchors over the combined Stage corpus, then transition to Challenge.

**Forbidden Fix**  
Do not remove `1990`, move it to segment 1, flatten Discovery, or change Journey content/UI for harness visibility.

**Cheap Preflight**  
Positive split-segment fixture with required anchors in different segments; missing-later-anchor negative; single-segment fixture.

**Long-term rules**  
`STAGE CORPUS != CURRENTLY MOUNTED SEGMENT`  
`VALIDATE ALL SEGMENTS BEFORE STAGE-LEVEL ASSERTIONS`

---

## CONTENT VALIDATION != TTS AVAILABILITY

**Failure**  
A browser exposed complete learner Discovery text while TTS reported `朗读暂时不可用`; the harness incorrectly required an active narration item before accepting the corpus.

**Classification**  
`HARNESS / NARRATION-AVAILABILITY COUPLING FALSE NEGATIVE`

**Root Cause**  
Optional narration availability became a prerequisite for content correctness.

**Correct Fix**  
When narration is available, traverse its segmented progression. When unavailable, validate the already fully revealed Stage semantics directly. Keep identical content anchors in both paths.

**Forbidden Fix**  
Do not weaken content anchors or alter narration UI/audio configuration merely to make a content validator run.

**Cheap Preflight**  
A TTS-unavailable full-text fixture carrying the same Stage anchors must pass without narration indices.

**Long-term rule**  
`CONTENT VALIDATION != TTS AVAILABILITY`

---

## MODAL OVERLAY != STAGE LOSS

**Failure**  
Shanghai run `32833535493`, job `97757291939`, reached WebKit Lv3 after Chromium Lv1/Lv3/Lv5/Lv8/Lv10 and WebKit Lv1 passed. A legitimate `中文朗读声线` Dialog temporarily replaced mounted Journey semantics and the harness reported `semantic state not found: 3/6`.

**Classification**  
`HARNESS / TRANSIENT-MODAL-OVERLAY FALSE NEGATIVE`

**Root Cause**  
Temporary modal-overlay state was interpreted as loss of the underlying Journey Stage.

**Correct Fix**  
Recognize only explicitly known transient runtime dialogs, log identity, close through a real semantic `关闭` / `Dismiss` control, wait for the Dialog to disappear, then re-read semantics and enforce the original Stage assertion unchanged.

**Forbidden Fix**  
Do not remove Stage assertions, globally dismiss arbitrary dialogs, or change learner/narration UI to prevent a legitimate modal.

**Cheap Preflight**  
Known voice modal -> recognized -> real close target -> Stage semantics re-read. Unknown modal -> must remain non-dismissible and fail classification.

**Long-term rules**  
`MODAL OVERLAY != STAGE LOSS`  
`DISMISS KNOWN TRANSIENT STATE, THEN RE-READ SEMANTICS`  
`UNKNOWN MODAL != AUTO-DISMISS`

---

## DIALOG IDENTITY IS SEMANTIC, NOT ONE DOM ROLE SHAPE

**Failure**  
Shanghai run `32837154670`, job `97768541821`, passed all pure fixtures, exact-preview identity, and Chromium/WebKit interaction + Shanghai SPA preflight. During Chromium Lv1, the normal Vocabulary word-detail modal for `外滩` appeared after Story. Its snapshot included `已下载例句`, reviewed Story example, Pinyin/Vietnamese/English support, `收藏单词`, `上一个单词`, `下一个单词`, and a real `Dismiss` button. Flutter exposed the modal record as `role=null, label="Dialog"`, while the strict harness recognized only `role="Dialog"`; it therefore reported `semantic state not found: 2/6`.

**Classification**  
`HARNESS / KNOWN-TRANSIENT-MODAL SEMANTIC-SHAPE FALSE NEGATIVE`

**Root Cause**  
The harness encoded one DOM representation of Dialog identity instead of Flutter semantics, and its explicit transient allowlist omitted the historically expected Vocabulary word-detail modal.

**Correct Fix**  
Normalize Dialog identity across the observed Flutter semantic shapes (`role="Dialog"` or exact semantic `label="Dialog"`). Keep an explicit allowlist for known transient identities such as `中文朗读声线` and Vocabulary word detail. Match each by specific content markers, close only through its allowed real control, then re-read and prove the unchanged Stage postcondition.

**Forbidden Fix**  
Do not restore a global `if Dismiss exists -> close it` rule. Do not treat every `label="Dialog"` as safe. Do not close unknown dialogs. Do not change Vocabulary, Story, UI, or Stage behavior.

**Cheap Preflight**  
Replay real Flutter-shaped fixtures with `role=null, label="Dialog"` for both known voice-selection and Vocabulary-detail states; require both to resolve an allowlisted close control. Replay an unknown `role=null, label="Dialog"` fixture and require rejection.

**Long-term rules**  
`DIALOG IDENTITY IS SEMANTIC, NOT A SINGLE DOM ROLE SHAPE`  
`KNOWN TRANSIENT ALLOWLIST MUST BE EXPLICIT`  
`UNKNOWN MODAL != AUTO-DISMISS`

---

## CURRENT LEVEL LEAKAGE

**Failure pattern**  
Adaptive validation can accidentally read stale, hidden, cached, or non-active level material and satisfy/fail assertions using the wrong level.

**Classification**  
`HARNESS / CURRENT-LEVEL LEAKAGE`

**Root Cause**  
The broader DOM/semantic/runtime corpus was treated as equivalent to the active Phoenix level.

**Correct Fix**  
Prove exact active level first, then bind Story, Vocabulary, Discovery, Challenge, Memory, and Completion assertions to learner-visible current-level state.

**Forbidden Fix**  
Do not remove level-specific requirements or accept anchors merely because they exist in another level's corpus.

**Cheap Preflight**  
Place a required anchor only in a non-active-level fixture and require the active-level validator to reject it.

**Long-term rule**  
`CURRENT LEVEL IS THE ASSERTION BOUNDARY`

---

## ARBITRARY 5000MS PERFORMANCE GATE

**Failure pattern**  
A fixed `5000 ms` wall-clock threshold was treated as universal product quality despite runner variance, cold starts, network latency, or lack of an owned performance contract.

**Classification**  
`HARNESS / ARBITRARY PERFORMANCE THRESHOLD`

**Root Cause**  
A magic timeout was substituted for a defined performance specification.

**Correct Fix**  
Measure the user-relevant operation, define boundaries and warm/cold conditions, and source the threshold from an owned SLA or stable baseline with documented tolerance. Keep correctness timeouts separate from performance assertions.

**Forbidden Fix**  
Do not simplify learner content to satisfy a magic number, silently raise the number until green, or interpret infrastructure latency as product regression without evidence.

**Cheap Preflight**  
Require named operation, measurement boundaries, warm/cold mode, threshold source, and tolerance before enabling a performance gate.

**Long-term rule**  
`TIMEOUT != PERFORMANCE SPEC`

---

## EXACT-HEAD IDENTITY AND RERUN COST

**Failure pattern**  
Evidence becomes ambiguous and CI cost balloons when validation targets a merge ref, stale preview, moving branch, or re-runs unrelated successful gates after harness-only changes.

**Classification**  
`EVIDENCE / EXACT-HEAD DRIFT` or `HARNESS / RERUN-COST WASTE`

**Root Cause**  
Formal candidate identity, preview identity, validation-harness identity, and evidence-reuse policy were not separated.

**Correct Fix**  
Pin the formal SHA; verify preview release SHA; record validation harness SHA independently; run cheap gates first; reuse already-green product CI/Preview/Mobile/reference evidence while formal SHA is unchanged and the changed harness did not invalidate that evidence; run a final HEAD-drift check immediately before Founder handoff.

**Forbidden Fix**  
Do not claim moving-branch/merge-ref evidence as exact-head proof, and do not habitually rerun every expensive gate after docs/harness-only changes.

**Cheap Preflight**  
Print and compare formal product SHA, preview release SHA, validation harness SHA, changed-file scope, and reusable-green gate list before expensive work.

**Long-term rules**  
`EXACT HEAD OR NO RELEASE CLAIM`  
`FROZEN PRODUCT SHA => REUSE UNINVALIDATED EVIDENCE`

---

## Failure handling template

Every new lesson records:
- **Failure**: concrete observed behavior and exact failing boundary.
- **Classification**: PRODUCT / HARNESS / PATCH-MECHANISM / ENVIRONMENT / EVIDENCE.
- **Root Cause**: why it happened without retrofitting product blame.
- **Correct Fix**: smallest layer that owns the defect.
- **Forbidden Fix**: shortcuts that corrupt learner quality or evidence.
- **Cheap Preflight**: low-cost regression before expensive gates.
- **Long-term rule**: reusable invariant.

## Founder handoff rule

Machine validation can prove exact-head identity, scope, contracts, browser execution, and regression safety. It does not replace Founder experience review. A candidate is only ready for Founder review after all required exact-head gates are green and final HEAD drift is clean. Merge or approval remains a separate explicit Founder action.
