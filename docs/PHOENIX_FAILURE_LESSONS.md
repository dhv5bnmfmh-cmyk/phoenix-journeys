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

## DIALOG ROOT != DIALOG IDENTITY ALREADY MOUNTED

**Failure:** run `32838502863`, job `97772693316`, again proved Chromium Lv1/Lv3/Lv5/Lv8/Lv10 all six-stage PASS and WebKit Lv1 PASS. At WebKit Lv3 the failure snapshot contained only a visible Flutter `label="Dialog"` root with empty text and no controls or identity markers; the harness immediately classified that empty shell as an unknown modal and stopped with `UNKNOWN MODAL != AUTO-DISMISS | Dialog`.  
**Classification:** `HARNESS / MODAL-IDENTITY MOUNT RACE FALSE NEGATIVE`  
**Root Cause:** Flutter can mount the Dialog semantic root before the Dialog's identifying text/content/control semantics. The harness correctly refused to auto-dismiss unknown dialogs, but incorrectly treated a not-yet-identifiable empty shell as already-classified unknown state.  
**Correct Fix:** distinguish only the structurally empty Dialog shell as `mounting-unidentified`, wait for semantic identity to settle, then classify. If it resolves to an explicit allowlisted modal, continue to its real allowed close control. If concrete unknown content appears, stop immediately. If the shell never gains identity, stop without dismissal.  
**Forbidden Fix:** do not classify every blank/partial dialog as known; do not auto-dismiss the empty shell; do not soften the unknown-dialog rule; do not change learner UI/content to alter Flutter semantics mount timing.  
**Cheap Preflight:** replay `empty Dialog shell -> known Vocabulary modal` and require wait then known; replay `empty Dialog shell -> concrete unknown modal` and require hard stop; a permanently unidentified shell must not produce an auto-dismiss target.  
**Rules:** `DIALOG ROOT != DIALOG IDENTITY ALREADY MOUNTED`; `UNIDENTIFIED SHELL => WAIT, NEVER DISMISS`; `CONCRETE UNKNOWN IDENTITY => STOP`

---

## SEMANTIC INDEX IS OBSERVATION METADATA, NOT ACTION IDENTITY

**Failure:** Shanghai browser validation exposed two forms of the same harness defect. Run `32839390229`, job `97775317225`, could retarget a modal action after Flutter semantics reordering. Later run `32840553304`, job `97778958323`, reached WebKit Lv8 Discovery while the harness still used `records() -> rail.index -> nth(index) -> boundingBox -> coordinate action`; the final semantics showed the run had drifted from expected Lv8 to actual Lv7. The observed effect was consistent with the stale numeric index resolving to the nearby `降低当前难度` control.  
**Classification:** `HARNESS / STALE-SEMANTIC-INDEX SEEK-GEOMETRY ACTIVATION FALSE NEGATIVE` plus `HARNESS / MID-STAGE LEVEL-GUARD COVERAGE GAP`  
**Root Cause:** a semantics snapshot array index was treated as persistent live action identity. Flutter/WebKit can reorder semantics nodes after observation and before click, tap, drag, seek, bounding-box lookup, or coordinate activation. The Discovery traversal also proved target level only at Stage entry, so an accidental Lv8 -> Lv7 change was not reported immediately.  
**Correct Fix:** use snapshot index only to locate the initial node; immediately bind the concrete live element, re-read its role/label/text/disabled state, prove the intended semantic identity, obtain geometry from that same bound element, recheck identity, then activate that same element. Apply the same rule to modal close, narration seek, grammar segment, and challenge options. Re-prove the target level after every UI-changing Discovery interaction and throughout the Stage.  
**Forbidden Fix:** do not modify the learner level, disable difficulty controls, remove level assertions, reset Lv8 after accidental drift, or alter Story/Discovery/narration/UI content to compensate for a harness action bug.  
**Cheap Preflight:** replay a semantics reorder where snapshot index 18 is the narration progress rail, then live index 18 becomes `降低当前难度` while the narration rail moves to 19. The old index-based algorithm must be demonstrated unsafe; the new bound-identity path must retain the narration rail or fail safely. Include Lv8 -> seek -> Lv8 -> seek -> Lv8 positive and Lv8 -> seek -> Lv7 immediate-negative fixtures, plus a static scan of active modal/seek/grammar/challenge action paths.  
**Rules:** `SEMANTIC INDEX IS OBSERVATION METADATA, NOT AN ACTION IDENTITY`; `RESOLVE -> BIND LIVE ELEMENT -> RECHECK IDENTITY -> GET GEOMETRY -> ACTIVATE`; `GEOMETRY MUST BELONG TO A BOUND, RECHECKED LIVE ELEMENT`; `LEVEL MUST REMAIN STABLE THROUGHOUT A STAGE, NOT ONLY AT STAGE ENTRY`

---

## EXPLICIT NARRATION COMPLETION IS A TERMINAL STATE, NOT A SEEK REQUIREMENT

**Failure:** run `32848200267`, job `97802720447`, kept the exact Shanghai Lv8 level stable and exposed the complete two-paragraph Discovery corpus with `海运提单`, `1990`, and explicit `朗读完成 · 100%`. The harness nevertheless attempted another narration seek and failed because the completed progress semantics had become a disabled/non-actionable terminal control with no usable seek geometry.  
**Classification:** `HARNESS / ALREADY-COMPLETED NARRATION SEEK FALSE NEGATIVE`  
**Root Cause:** the validator modeled narration as “seek until completion” but did not model “already completed” as a legitimate terminal state. A race between the last availability check and geometry acquisition could also make an otherwise valid seek rail become completed/non-actionable before activation.  
**Correct Fix:** when current Stage semantics explicitly report `朗读完成 · 100%`, keep the target-level guard, validate the complete Discovery corpus and anchors, and do not seek. If narration becomes explicitly complete while binding or obtaining geometry, re-read the Stage, confirm the same target level and explicit completion, then terminate traversal successfully.  
**Forbidden Fix:** do not weaken Discovery anchors, ignore level drift, fabricate seek geometry, re-enable a completed control, or change narration product behavior merely to keep the harness action path available.  
**Cheap Preflight:** an explicit `朗读完成 · 100%` fixture must be recognized as terminal and require no seek; non-complete missing/invalid geometry must still fail. The WebKit Lv8 real-browser preflight must preserve Lv8 and validate `海运提单` plus `1990` through final completion semantics.  
**Rules:** `EXPLICIT 100% COMPLETION => VALIDATE, DO NOT SEEK`; `TERMINAL STATE IS PART OF THE HARNESS CONTRACT`; `COMPLETION MAY REMOVE ACTION GEOMETRY WITHOUT PRODUCT FAILURE`

---

## FINAL TERMINAL CORPUS > INTERMEDIATE NARRATION ID COUNT

**Failure:** run `32848677242`, job `97804230512`, reached explicit WebKit Lv8 Discovery terminal completion. Runtime still showed exact `3/6 Discovery`, exact `Phoenix 中文难度 8 级`, `Discovery，Lv.8 · 分段短文 · 2 段`, `朗读完成 · 100%`, both visible paragraphs, and both required Lv8 anchors `海运提单` and `1990`. The harness nevertheless rejected the Stage with `Lv8 Discovery traversal saw 1/2 narration segments` because only one intermediate narration segment ID had been observed before terminal completion.  
**Classification:** `HARNESS / TERMINAL-COMPLETION SEGMENT-ACCOUNTING FALSE NEGATIVE`  
**Root Cause:** intermediate traversal bookkeeping was incorrectly treated as stronger evidence than the authoritative final Stage corpus.  
**Correct Fix:** when and only when exact Stage + exact Level + explicit 100% terminal completion + current Discovery level identity + full terminal corpus anchors all pass, with no unresolved modal, level drift, or fatal runtime semantics, accept the terminal corpus as authoritative. Preserve observed segment counts as diagnostic evidence; do not fabricate missing intermediate IDs.  
**Forbidden Fix:** do not fabricate observed segment IDs; do not remove non-terminal traversal checks; do not weaken Discovery anchors; do not modify learner content or narration behavior; do not accept `100%` if Stage or Level has drifted.  
**Cheap Preflight:** terminal `1/2` observed + complete Lv8 terminal corpus must PASS; terminal missing `1990` must FAIL; non-terminal `1/2` must FAIL; terminal wrong-level Lv7 with anchors must FAIL.  
**Rules:** `FINAL TERMINAL CORPUS > INTERMEDIATE NARRATION ID COUNT`; `SEGMENT ACCOUNTING SERVES CORPUS VALIDATION, NOT THE REVERSE`; `TERMINAL AUTHORITY REQUIRES EXACT STAGE + EXACT LEVEL + EXPLICIT COMPLETION + COMPLETE ANCHORS`

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