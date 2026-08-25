# Phoenix Failure Lessons

Canonical governance record for recurring Phoenix development and validation failures. This file is governance only. A red validation gate is not learner-product evidence until the failing boundary proves a learner-facing defect on the exact formal candidate.

## Core rules

1. **CLASSIFY BEFORE FIXING.** Separate PRODUCT, HARNESS, PATCH-MECHANISM, ENVIRONMENT, and EVIDENCE failures before touching learner code.
2. **FORMAL PRODUCT HEAD STAYS IMMUTABLE DURING HARNESS REPAIR.** Validation adapts to the real product contract, never the reverse.
3. **CHEAP BEFORE EXPENSIVE.** Syntax, fixture, identity, scope, and semantic preflights run before browser installation or expensive suites.
4. **EXACT HEAD OR NO RELEASE CLAIM.** Preview, CI, browser evidence, and Founder handoff must resolve to the exact formal SHA.
5. **REUSE UNINVALIDATED EVIDENCE WHILE PRODUCT SHA IS FROZEN.** Harness/docs changes do not invalidate already-green product gates unless they directly invalidate that evidence.

---

## PATCH-MECHANISM FAILURE

**Failure:** Shanghai run `32814724621`, job `97700622623`, failed at `Capture helper generator outside repository tree`; product checkout, Flutter setup, targeted tests, Analyze, and full tests never started.  
**Classification:** `HARNESS / PATCH-MECHANISM FAILURE`  
**Root Cause:** helper capture/replay failed before learner-product execution.  
**Correct Fix:** repair only helper/workflow mechanics; require exact patch-target counts; syntax-check before dependencies.  
**Forbidden Fix:** never modify Story/UI/content to compensate for helper delivery failure.  
**Cheap Preflight:** capture/replay -> exact target count -> smallest unique target -> helper-only patch -> syntax check -> stop before expensive work.  
**Rule:** `PATCH DELIVERY FAILURE != PRODUCT FAILURE`

---

## BROWSER INTERACTION CAPABILITY: CLICK VS TAP

**Failure:** one touch interaction path was used for desktop Chromium and touch WebKit.  
**Classification:** `HARNESS / BROWSER-INTERACTION FAILURE`  
**Root Cause:** browser capability and interaction mode were conflated.  
**Correct Fix:** explicit desktop-click and mobile-touch semantic activation modes.  
**Forbidden Fix:** do not fake touch on desktop or alter learner UI.  
**Cheap Preflight:** prove one real semantic activation and expected state transition in every browser mode.  
**Rule:** `INTERACTION MODE IS PART OF THE HARNESS CONTRACT`

---

## SEMANTIC STATE > IMPLICIT NAVIGATION WAIT

**Failure:** Chromium reached Shanghai `1/6 Story`, while Playwright kept waiting for irrelevant traditional navigation.  
**Classification:** `HARNESS / SPA-ACTIVATION WAIT FALSE NEGATIVE`  
**Root Cause:** Flutter SPA semantic transition was coupled to browser navigation lifecycle.  
**Correct Fix:** trigger the real interaction, then wait for explicit application semantics.  
**Forbidden Fix:** do not modify routing/UI to manufacture navigation.  
**Cheap Preflight:** open Journey via real UI and require first stable six-stage semantic state.  
**Rule:** `SEMANTIC STATE > IMPLICIT NAVIGATION WAIT`

---

## INVARIANT MEANING != INVARIANT WORDING

**Failure:** adaptive Shanghai Story validation required identical surface literals across levels even when the same Bund spatial/narrative invariant was correctly preserved.  
**Classification:** `HARNESS / SEMANTIC-ANCHOR FALSE NEGATIVE`  
**Root Cause:** level-invariant meaning was encoded as level-invariant wording.  
**Correct Fix:** validate narrative identity and semantic role groups such as `west-bank Bund -> river crossing -> east-bank Lujiazui`.  
**Forbidden Fix:** do not inject literals into correct prose just for the validator.  
**Cheap Preflight:** representative real semantics plus a negative fixture missing the Journey-specific engine.  
**Rule:** `INVARIANT MEANING != INVARIANT WORDING`

---

## STAGE CORPUS != CURRENTLY MOUNTED SEGMENT

**Failure:** WebKit Lv8 showed Discovery item `1 / 2` with `海运提单`; `1990` existed later in the same Stage, but the harness asserted whole-stage anchors against only the current segment.  
**Classification:** `HARNESS / SEGMENTED-DISCOVERY VISIBILITY FALSE NEGATIVE`  
**Root Cause:** mounted/revealed semantics were treated as the complete Stage corpus.  
**Correct Fix:** stay in real `3/6 Discovery`, collect stable semantics across all runtime segments, assert anchors on the combined corpus, then transition to Challenge.  
**Forbidden Fix:** do not delete/move `1990`, flatten Discovery, or change UI/content.  
**Cheap Preflight:** positive split-segment fixture, missing-later-anchor negative, single-segment fixture.  
**Rules:** `STAGE CORPUS != CURRENTLY MOUNTED SEGMENT`; `VALIDATE ALL SEGMENTS BEFORE STAGE-LEVEL ASSERTIONS`

---

## CONTENT VALIDATION != TTS AVAILABILITY

**Failure:** complete Discovery text was visible while TTS was unavailable; harness incorrectly required active narration state.  
**Classification:** `HARNESS / NARRATION-AVAILABILITY COUPLING FALSE NEGATIVE`  
**Root Cause:** optional narration became prerequisite for content correctness.  
**Correct Fix:** traverse narration when available; otherwise validate fully revealed Stage semantics directly, with the same anchors.  
**Forbidden Fix:** do not weaken anchors or change narration UI/audio configuration.  
**Cheap Preflight:** TTS-unavailable full-text fixture must pass without narration indices.  
**Rule:** `CONTENT VALIDATION != TTS AVAILABILITY`

---

## MODAL OVERLAY != STAGE LOSS

**Failure:** run `32833535493`, job `97757291939`, WebKit Lv3 exposed legitimate `中文朗读声线` Dialog while Stage semantics were temporarily hidden; harness reported missing `3/6`.  
**Classification:** `HARNESS / TRANSIENT-MODAL-OVERLAY FALSE NEGATIVE`  
**Root Cause:** temporary modal overlay was interpreted as loss of underlying Journey state.  
**Correct Fix:** recognize only explicit known transient dialogs, use real allowed close controls, wait for disappearance, re-read semantics, keep the original Stage assertion.  
**Forbidden Fix:** no Stage weakening, no global arbitrary-dialog dismissal, no learner/narration UI change.  
**Cheap Preflight:** known voice modal closes and Stage resumes; unknown modal remains non-dismissible.  
**Rules:** `MODAL OVERLAY != STAGE LOSS`; `DISMISS KNOWN TRANSIENT STATE, THEN RE-READ SEMANTICS`; `UNKNOWN MODAL != AUTO-DISMISS`

---

## DIALOG IDENTITY IS SEMANTIC, NOT ONE DOM ROLE SHAPE

**Failure:** run `32837154670`, job `97768541821`, Chromium Lv1 Vocabulary word-detail modal was legitimate but Flutter exposed `role=null, label="Dialog"`; strict classifier only recognized `role="Dialog"`, then falsely failed `2/6`.  
**Classification:** `HARNESS / KNOWN-TRANSIENT-MODAL SEMANTIC-SHAPE FALSE NEGATIVE`  
**Root Cause:** one DOM representation was treated as the full Flutter Dialog identity, and the known Vocabulary modal was omitted from allowlist.  
**Correct Fix:** normalize observed Flutter Dialog shapes (`role="Dialog"` or exact `label="Dialog"`) and keep explicit marker-based allowlists for voice selector and Vocabulary detail.  
**Forbidden Fix:** do not restore `if Dismiss exists -> close it`; do not treat every Dialog as safe.  
**Cheap Preflight:** real `role=null, label="Dialog"` fixtures for both known modal types plus unknown Dialog negative.  
**Rules:** `DIALOG IDENTITY IS SEMANTIC, NOT A SINGLE DOM ROLE SHAPE`; `KNOWN TRANSIENT ALLOWLIST MUST BE EXPLICIT`; `UNKNOWN MODAL != AUTO-DISMISS`

---

## KNOWN MODAL IDENTITY != CLOSE CONTROL ALREADY MOUNTED

**Failure:** run `32837676187`, job `97770152331`, Chromium Lv1/Lv3/Lv5/Lv8/Lv10 all passed. On WebKit Lv1 the Vocabulary Dialog identity was correctly recognized, but the harness immediately reported `Known transient modal vocabulary-word-detail has no allowed close control`. A fresh semantics snapshot at the failure boundary already contained the legitimate `role=button, text=Dismiss`, proving a short semantic mount race between Dialog-root exposure and close-control exposure.  
**Classification:** `HARNESS / MODAL CLOSE-CONTROL MOUNT RACE FALSE NEGATIVE`  
**Root Cause:** the harness assumed known Dialog identity and its allowed close control must enter the Flutter semantics tree in the same snapshot.  
**Correct Fix:** after recognizing a known modal, keep the identity locked and poll only for that modal's explicitly allowed close control. Model `known-waiting-close -> known-ready`; close through the real control only after it is mounted; then wait for Dialog disappearance and re-read Stage semantics. If the Dialog becomes unknown or changes identity, stop.  
**Forbidden Fix:** do not broaden close matching, click arbitrary `Dismiss`, remove Stage assertions, or modify product/UI to make semantics mount atomically.  
**Cheap Preflight:** two-snapshot fixture where a known Dialog root appears first without a close button and the next snapshot adds its allowed `Dismiss`; require waiting then ready. Unknown Dialog or identity change must still reject.  
**Rules:** `KNOWN MODAL IDENTITY != CLOSE CONTROL ALREADY MOUNTED`; `WAIT FOR ALLOWED CONTROL, NOT AN ARBITRARY DELAY`; `UNKNOWN OR CHANGED MODAL IDENTITY => STOP`

---

## CURRENT LEVEL LEAKAGE

**Failure pattern:** stale/hidden/non-active level content can accidentally satisfy or fail adaptive assertions.  
**Classification:** `HARNESS / CURRENT-LEVEL LEAKAGE`  
**Root Cause:** broader DOM/runtime corpus was treated as active Phoenix level.  
**Correct Fix:** prove exact level first, then bind Story/Vocabulary/Discovery/Challenge/Memory/Completion assertions to current-level visible state.  
**Forbidden Fix:** do not accept anchors from another level or remove level-specific requirements.  
**Cheap Preflight:** required anchor present only in non-active fixture must be rejected.  
**Rule:** `CURRENT LEVEL IS THE ASSERTION BOUNDARY`

---

## ARBITRARY 5000MS PERFORMANCE GATE

**Failure pattern:** a fixed `5000 ms` wall-clock threshold was treated as universal quality without an owned performance contract.  
**Classification:** `HARNESS / ARBITRARY PERFORMANCE THRESHOLD`  
**Root Cause:** magic timeout substituted for performance specification.  
**Correct Fix:** define user-relevant measurement, boundaries, warm/cold conditions, source threshold, and tolerance; separate correctness timeout from performance assertion.  
**Forbidden Fix:** no learner simplification, silent threshold inflation, or runner latency reclassified as product regression.  
**Cheap Preflight:** reject performance gates lacking named operation, boundaries, threshold source, and tolerance.  
**Rule:** `TIMEOUT != PERFORMANCE SPEC`

---

## EXACT-HEAD IDENTITY AND RERUN COST

**Failure pattern:** moving branches, merge refs, stale previews, or habitually re-running unrelated successful gates make evidence ambiguous and expensive.  
**Classification:** `EVIDENCE / EXACT-HEAD DRIFT` or `HARNESS / RERUN-COST WASTE`  
**Root Cause:** formal product identity, preview identity, validation harness identity, and evidence-reuse policy were conflated.  
**Correct Fix:** pin formal SHA, verify preview release SHA, record harness SHA independently, run cheap gates first, reuse green evidence while formal SHA is frozen and not invalidated, then perform final HEAD drift immediately before Founder handoff.  
**Forbidden Fix:** do not claim merge-ref/moving-branch evidence or rerun every expensive gate after harness/docs-only changes.  
**Cheap Preflight:** print formal SHA, preview release SHA, harness SHA, changed-file scope, and reusable-green gate list.  
**Rules:** `EXACT HEAD OR NO RELEASE CLAIM`; `FROZEN PRODUCT SHA => REUSE UNINVALIDATED EVIDENCE`

---

## Failure handling template

Every new lesson records concrete Failure, Classification, Root Cause, Correct Fix, Forbidden Fix, Cheap Preflight, and one reusable Long-term Rule.

## Founder handoff rule

Machine validation may prove exact-head identity, scope, contracts, browser execution, and regression safety. It does not replace Founder experience review. A candidate is ready for Founder review only after all required exact-head gates are green and final HEAD drift is clean. Merge or approval remains a separate explicit Founder action.
