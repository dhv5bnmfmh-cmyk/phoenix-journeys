# Phoenix Failure Lessons

Canonical governance record for recurring Phoenix development and validation failures.

This document records failure mechanisms, the correct class of fix, forbidden shortcuts, and cheap preflights that should run before expensive CI, browser, preview, or Founder-review gates. It is governance only. A validation failure is not product evidence unless the failing gate demonstrates an actual learner-facing defect on the exact formal product candidate.

## Core principles

1. **CLASSIFY BEFORE FIXING.** Separate PRODUCT, HARNESS, PATCH-MECHANISM, ENVIRONMENT, and EVIDENCE failures before touching learner code.
2. **FORMAL PRODUCT HEAD IS IMMUTABLE DURING HARNESS REPAIR.** Validation infrastructure must adapt to the real product contract; learner content must not be rewritten merely to satisfy a brittle validator.
3. **CHEAP BEFORE EXPENSIVE.** Syntax, fixture, identity, scope, and semantic-contract preflights run before browser installation, full suites, preview deploys, or duplicated cross-Journey gates.
4. **EXACT HEAD BEFORE CLAIMS.** Every release, preview, browser result, and Founder handoff must be traceable to the exact candidate SHA being reviewed.
5. **REUSE VALID EVIDENCE WHILE THE FORMAL SHA IS FROZEN.** Harness-only changes do not invalidate already-green product CI, Preview, Mobile, or unrelated reference-Journey evidence.

---

## PATCH-MECHANISM FAILURE

**Failure**

A validation workflow failed while capturing or transporting the helper generator before any product validation ran. Shanghai example: run `32814724621`, job `97700622623`, failed at `Capture helper generator outside repository tree`; subsequent checkout, Flutter setup, dependencies, diff validation, targeted tests, Analyze, and full Flutter tests never started.

**Classification**

`HARNESS / PATCH-MECHANISM FAILURE`

**Root Cause**

The mechanism used to preserve or reapply the validation helper across checkout boundaries was invalid. The failure occurred before learner-product execution and therefore was not product evidence.

**Correct Fix**

Repair only helper capture/replay/workflow mechanics. Keep the formal product candidate unchanged and rerun from the earliest invalidated validation boundary.

**Forbidden Fix**

Do not modify Story, Vocabulary, Discovery, Challenge, Memory, Completion, ReadingAnnotation, UI, or navigation to compensate for a helper transport failure.

**Cheap Preflight**

Before dependencies or expensive tests, verify that the helper artifact exists outside destructive checkout scope, is readable/executable, and can survive the exact reset/checkout sequence used by the workflow.

**Long-term rule**

`PATCH DELIVERY FAILURE != PRODUCT FAILURE`

---

## BROWSER INTERACTION CAPABILITY: CLICK VS TAP

**Failure**

A universal touch interaction was used for both desktop Chromium and mobile WebKit.

**Classification**

`HARNESS / BROWSER-INTERACTION FAILURE`

**Root Cause**

Browser capability and device interaction mode were conflated.

**Correct Fix**

Use one semantic activation abstraction with explicit desktop-click and mobile-touch modes. Validate each mode independently before multi-level E2E.

**Forbidden Fix**

Do not enable fake touch capability on desktop merely to make `tap()` succeed. Do not alter learner UI to accommodate the harness.

**Cheap Preflight**

In every browser mode, activate one stable semantic control and prove the expected application state transition.

**Long-term rule**

`INTERACTION MODE IS PART OF THE HARNESS CONTRACT`

---

## SEMANTIC STATE > IMPLICIT NAVIGATION WAIT

**Failure**

Desktop Chromium successfully activated Shanghai · Bund and reached the `1/6 Story` application state, but Playwright continued waiting for an implicit browser navigation lifecycle and timed out.

**Classification**

`HARNESS / SPA-ACTIVATION WAIT FALSE NEGATIVE`

**Root Cause**

A Flutter SPA semantic transition was incorrectly coupled to a traditional page-navigation waiter.

**Correct Fix**

Let the interaction trigger the action, then wait explicitly for the expected app semantic state. For desktop semantic clicks, do not let an irrelevant navigation waiter override an already-proven SPA state transition.

**Forbidden Fix**

Do not change learner routing, destination behavior, or UI to manufacture a browser navigation event.

**Cheap Preflight**

Open the target Journey through the real UI and require the first stable stage semantic state before expensive coverage begins.

**Long-term rule**

`SEMANTIC STATE > IMPLICIT NAVIGATION WAIT`

---

## INVARIANT MEANING != INVARIANT WORDING

**Failure**

The Shanghai Story harness required one exact place literal, `黄浦江`, at every adaptive level. A correct Lv5 Story expressed the stronger spatial engine through `外滩 / 浦西 + 金陵东路轮渡 / 过江 / 两岸 + 浦东 / 陆家嘴` but failed the literal assertion.

**Classification**

`HARNESS / SEMANTIC-ANCHOR FALSE NEGATIVE`

**Root Cause**

A level-invariant meaning was represented as level-invariant surface wording.

**Correct Fix**

Validate narrative identity, hard Journey identity, and semantic role groups. For Shanghai · Bund, preserve the Story engine `west-bank Bund -> river crossing -> east-bank Lujiazui` while allowing level-appropriate wording.

**Forbidden Fix**

Do not inject a missing literal into otherwise-correct learner prose just to satisfy the validator. Do not weaken place causality into a generic-place check.

**Cheap Preflight**

Replay representative real semantics snapshots against the validator and include a negative fixture that keeps the protagonist but removes the Journey-specific spatial engine.

**Long-term rule**

`INVARIANT MEANING != INVARIANT WORDING`

---

## STAGE CORPUS != CURRENTLY MOUNTED SEGMENT

**Failure**

The harness validated only currently revealed Discovery semantics while requiring anchors that belong to the full segmented Discovery Stage. In Shanghai WebKit Lv8, narration item `1 / 2` exposed `海运提单`; `1990` existed later in the same formal Discovery corpus but was not yet present in the visible semantics snapshot.

**Classification**

`HARNESS / SEGMENTED-DISCOVERY VISIBILITY FALSE NEGATIVE`

**Root Cause**

Narration-gated viewport semantics were treated as the entire Stage corpus.

**Correct Fix**

Stay in the real `3/6 Discovery` Stage, follow the runtime's actual narration/item progression, collect stable semantics across all segments, validate Stage-level anchors against the combined corpus, and only then transition to Challenge.

**Forbidden Fix**

Do not delete the later-segment anchor. Do not move it into segment 1. Do not flatten Discovery. Do not change Journey UI/content for harness visibility.

**Cheap Preflight**

Use a positive multi-segment fixture with required anchors split across segments, a negative fixture missing the later anchor, and a single-segment fixture proving the abstraction still handles simple stages.

**Long-term rules**

`STAGE CORPUS != CURRENTLY MOUNTED SEGMENT`

`VALIDATE ALL SEGMENTS BEFORE STAGE-LEVEL ASSERTIONS`

---

## CONTENT VALIDATION != TTS AVAILABILITY

**Failure**

A browser exposed the complete learner Discovery text while browser TTS reported `朗读暂时不可用`, but the harness required an active narration item index before accepting the Stage corpus.

**Classification**

`HARNESS / NARRATION-AVAILABILITY COUPLING FALSE NEGATIVE`

**Root Cause**

Optional runtime narration availability was incorrectly made a prerequisite for content correctness. Phoenix intentionally reveals full text when the narration session is inactive or unavailable.

**Correct Fix**

When narration is available, traverse and collect its segmented semantic progression. When narration is unavailable, validate the already fully revealed Stage semantics directly. The content anchor contract is identical in both paths.

**Forbidden Fix**

Do not weaken Discovery anchors because TTS is unavailable. Do not modify learner content, narration UI, or browser audio configuration merely to make a content validator execute.

**Cheap Preflight**

Include a TTS-unavailable full-text fixture with the same required Stage anchors and require it to pass without narration indices.

**Long-term rule**

`CONTENT VALIDATION != TTS AVAILABILITY`

---

## CURRENT LEVEL LEAKAGE

**Failure pattern**

Adaptive Journey validation can accidentally read stale, hidden, cached, or non-active level material and either satisfy an assertion with the wrong level or report contamination that is not learner-visible at the current level.

**Classification**

`HARNESS / CURRENT-LEVEL LEAKAGE`

**Root Cause**

The validator treated the broader DOM/semantic/runtime corpus as equivalent to the active Phoenix level.

**Correct Fix**

Prove the exact active Phoenix level first, then bind Story, Vocabulary, Discovery, Challenge, Memory, and Completion assertions to the learner-visible active-level state. Level progression assertions compare intentional semantic deltas, not leftovers from another level.

**Forbidden Fix**

Do not remove level-specific quality requirements because stale content was observed. Do not rewrite learner content to hide material that is not active. Do not accept an anchor merely because it exists somewhere in another level's corpus.

**Cheap Preflight**

Use fixtures with a required anchor present only in a non-active level and require the active-level validator to reject it. Also assert that current level identity is stable before stage-specific checks run.

**Long-term rule**

`CURRENT LEVEL IS THE ASSERTION BOUNDARY`

---

## ARBITRARY 5000MS PERFORMANCE GATE

**Failure pattern**

A fixed `5000 ms` threshold was treated as a universal product-quality boundary even when runner variance, cold-start cost, browser installation, network/preview latency, or the measured user interaction being tested did not justify that number.

**Classification**

`HARNESS / ARBITRARY PERFORMANCE THRESHOLD`

**Root Cause**

A magic wall-clock cutoff was substituted for an explicit performance contract.

**Correct Fix**

Measure the user-relevant operation, define the threshold from an owned performance/SLA contract or a stable baseline with documented tolerance, and separate correctness timeouts from performance assertions. Record cold/warm conditions when they matter.

**Forbidden Fix**

Do not speed up or simplify learner content solely to satisfy an unexplained magic timeout. Do not silently raise the number until green. Do not interpret infrastructure latency as learner-runtime regression without evidence.

**Cheap Preflight**

Validate the performance-gate configuration itself: named operation, measurement boundaries, warm/cold mode, threshold source, and tolerance. Reject bare magic-number gates with no contract owner.

**Long-term rule**

`TIMEOUT != PERFORMANCE SPEC`

---

## EXACT-HEAD IDENTITY AND RERUN COST

**Failure pattern**

Expensive gates are wasted or evidence becomes ambiguous when a workflow validates a merge ref, stale preview, moving branch, or re-runs unrelated successful gates after a validation-only change.

**Classification**

`EVIDENCE / EXACT-HEAD DRIFT` or `HARNESS / RERUN-COST WASTE`

**Root Cause**

Candidate identity, preview identity, validation-harness identity, and evidence reuse policy were not separated explicitly.

**Correct Fix**

- Pin the formal product to one exact candidate SHA.
- Verify preview health/release SHA equals the formal candidate before browser E2E.
- Pin or record the validation harness HEAD independently.
- Run cheap syntax/fixture checks before browser installation or full suites.
- When the formal product SHA is unchanged, reuse successful product CI, Preview, Mobile, and unrelated reference-Journey evidence unless the changed validation mechanism actually invalidates that evidence.
- Perform a final HEAD-drift check immediately before Founder handoff.

**Forbidden Fix**

Do not claim a moving branch or merge ref as exact-head evidence. Do not rerun every expensive gate after a docs/harness-only change by habit. Do not reuse evidence if the formal product SHA changed or if the changed harness directly invalidates that evidence.

**Cheap Preflight**

Before expensive work, print and compare: formal product SHA, expected preview release SHA, validation harness SHA, changed-file scope, and the list of previously-green gates eligible for reuse.

**Long-term rules**

`EXACT HEAD OR NO RELEASE CLAIM`

`FROZEN PRODUCT SHA => REUSE UNINVALIDATED EVIDENCE`

---

## Failure handling template

Every new Phoenix failure lesson should record:

- **Failure**: the concrete observed behavior and exact failing boundary.
- **Classification**: PRODUCT / HARNESS / PATCH-MECHANISM / ENVIRONMENT / EVIDENCE.
- **Root Cause**: why the failure happened, without retrofitting product blame.
- **Correct Fix**: the smallest layer that owns the defect.
- **Forbidden Fix**: shortcuts that would corrupt learner quality or evidence.
- **Cheap Preflight**: a low-cost regression that catches recurrence before expensive gates.
- **Long-term rule**: one reusable invariant.

## Founder handoff rule

Machine validation may prove exact-head identity, scope, contracts, browser execution, and regression safety. It does not replace Founder experience review. A candidate is only ready for Founder review after all required exact-head gates are green and final HEAD drift is clean; merge or approval remains a separate explicit Founder action.
