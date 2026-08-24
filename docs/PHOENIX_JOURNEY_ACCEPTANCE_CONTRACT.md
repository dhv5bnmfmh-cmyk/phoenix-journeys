# Phoenix Journey Acceptance Contract

**Status:** BINDING ENTRY CONTRACT  
**Purpose:** one acceptance entry point for every active Phoenix Journey. Specialist standards add detail only in their owned domain and may not weaken or contradict this contract.

## 0. Authority, quality priority, and duplication rule

Every task starts from the exact current remote `main` resolved at preflight. Historical PRs, old branches, stale previews, and old commits are evidence only unless the Founder explicitly authorizes otherwise.

Quality precedence is permanent:

> **CONTENT / LEVEL / CULTURAL / LANGUAGE / PRODUCT QUALITY > DEVELOPMENT SPEED**

Speed may remove duplicated work, duplicated documents, duplicated CI execution, stale diagnostics, and brittle harness behavior. Speed MUST NOT remove a quality gate, human semantic judgment, level review, factual verification, exact-head evidence, mobile evidence, or Founder decision that is applicable.

Canonical ownership:

- `PHOENIX_STABLE_BASELINE_STANDARD.md`: development source, protected baseline, regression floor.
- this contract: single Journey acceptance entry point.
- `PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md`: user-visible stages and Challenge governance.
- `PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md`: Story, Discovery, Lv1-Lv10 literary/semantic quality, anti-template, historical truth.
- `PHOENIX_JOURNEY_SYSTEM_STANDARD.md`: shared Journey product skeleton and data/runtime integrity.
- `PHOENIX_PRODUCT_QUALITY_STANDARD.md`: product-quality domains and evidence rules.
- `PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md`: exact completion evidence and merge readiness.
- `PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md`: lifecycle for a genuinely new Journey.
- `PHOENIX_UI_VISUAL_STANDARD.md`: visual and UI quality.

A new document MUST NOT restate an existing canonical rule merely to create another checklist. It must link to the owner. Historical checklists and roadmaps are non-authoritative when their requirements are already owned above.

## P1 Six-Stage

The only normal user-visible Journey flow is exactly:

`Story → Vocabulary → Discovery → Challenge → Memory → Completion`

Canonical committed stage IDs remain `0–5`. Reflection and Writing may exist as learning intents inside Challenge or Memory but are not standalone active stages unless a later Founder-approved binding standard explicitly replaces this contract.

## P2 Story Trace

Every active learning item must trace to the CURRENT level Story, CURRENT Discovery, or an explicit CURRENT-level language objective. Legacy Story text may not enter active runtime.

Vocabulary must use actual current-level Story/Discovery provenance. A cached sentence from another level is a blocking defect.

## P3 Lv1-Lv10 Adaptation

Every level must be independently reviewed. Lv1-Lv10 must increase cognitive and linguistic depth, not merely length, word count, option count, paragraph count, or sentence complexity.

Story must preserve its narrative invariants while changing language and reasoning depth appropriately. Vocabulary selection or teaching depth must progress. Discovery must provide level-appropriate verified knowledge. Challenge must progress from recognition/comprehension toward causal and integrated reasoning. Memory and Completion must remain aligned with the same level.

Exact text does not need to change merely for cosmetic difference. If the source meaning is genuinely unchanged, aligned support text may remain the same. Forced variation that reduces accuracy is prohibited.

## P4 Narrative Quality

Story must contain an identifiable protagonist, place-dependent Goal, causal Relationship, Conflict connected to Goal, enacted Choice, caused Consequence, emotional movement, cultural anchor in action, decisive movement/climax, and changed ending state.

Removing or replacing the named place must materially weaken the Story mechanism. Factual exposition, length, grammatical correctness, field completeness, or an automated score cannot by themselves produce literary `PASS`.

## P5 Discovery Grounding

Discovery extends a question raised by Story into independently verifiable real-world knowledge without retelling Story. Historical, cultural, architectural, scientific, geographic, or other factual claims require reliable provenance.

Discovery depth is governed by the active Journey contract. A resolver, cache, adaptive layer, or UI binding may not silently truncate canonical entries.

## P6 Challenge Cognition

Challenge uses all three canonical modes:

1. `paragraphRebuild`
2. `grammarRepair`
3. `missingSentence`

The modes must test distinct abilities, use taught active content, provide one defensible best answer, plausible and diagnosable distractors, level-appropriate reasoning, and CURRENT-level provenance. Mechanical corruption, trivia traps, legacy content, cross-Journey contamination, and three modes that test the same memorized sentence are blocking defects.

## P7 Memory Closure

Memory returns the learner to a Journey-specific character choice, consequence, relationship change, or durable meaning. It is not a generic quiz collection and may not reference deprecated Story semantics.

## P8 Completion Closure

Completion must close Story, learning, Memory, relationship/emotional movement, progress/reward, and the next action in language appropriate to the selected level.

## P9 ReadingAnnotation and Language Semantic Alignment

When explorer-readable text exists, ReadingAnnotation is required unless an evidence-backed applicability decision says otherwise.

For each CURRENT level and CURRENT paragraph:

`CURRENT source text → CURRENT Pinyin/pronunciation support → CURRENT Explorer Native Language → CURRENT English`

must remain aligned by paragraph identity and meaning. Pinyin must derive from the current Chinese source. Vietnamese/other native-language support and English must preserve current Story semantics rather than a generic summary. Non-monotonic level switching must not reuse the previous level's annotation cache.

Every formal language/support version must preserve the same Goal, Conflict, Choice, Consequence, character motivation, Challenge answer logic, Memory core, and grounded Discovery facts. Natural localization is preferred over literal translation, but semantic drift is blocking.

## P10 Location Binding

Every Journey must bind to a canonical geographic node and resolve through the location registry. Loose country/city/place strings are descriptive metadata only, not authoritative identity.

## P11 Runtime / UI / Data Evidence

Acceptance requires evidence across source data, active resolver/cache, runtime mapping, user-visible UI, routing, level selection, stage progression, completion, return/unlock, and persisted progress where applicable. JSON-only, source-only, or unit-test-only evidence is insufficient for user-visible acceptance.

No UI change is permitted when the authorized scope says UI is frozen. A test or harness must adapt to the approved product semantics, not force the product UI to adapt to a brittle test.

## P12 Gold Acceptance

Gold requires all applicable machine gates and human semantic gates to pass at the exact active revision. Prior Gold/Approved labels are not grandfathered against a later canonical requirement. Any blocker means Gold is denied until repaired and reverified.

Automated structural `PASS` and human literary/semantic `PASS` are separate results. Aggregate scores, field counts, `360/360`, or green CI cannot replace human review.

## P13 Founder Human Experience Gate

The final human experience review preserves the useful qualitative checks formerly scattered across older checklists. The Founder or designated human reviewer must judge, where applicable:

- the product purpose and next action are understandable quickly;
- Story feels like a lived Journey rather than textbook filler;
- selected level feels appropriate to the Explorer;
- unknown words and ReadingAnnotation support are reachable and useful;
- Discovery produces meaningful new understanding rather than repetition;
- Challenge reinforces something actually taught;
- feedback is clear, specific, and non-manipulative;
- Memory leaves a durable Journey-specific anchor;
- Completion feels closed and the next exploration is understandable;
- factual claims are source-grounded and applicable rights/provenance are valid.

These are human experience gates. They are not replaced by automated tests.

## P14 Exact-Head and Failure Classification

All final evidence is SHA-bound.

- `CURRENT HEAD` must be read before validation.
- CI, Preview, deployed release, browser E2E, mobile evidence, and Founder review must refer to the same exact candidate SHA.
- Any source commit invalidates older final proof for the new HEAD.
- Existing successful exact-head workflow runs must be reused; do not retrigger them merely to create a newer timestamp.

Before changing code after a failure, classify it from direct evidence as one of:

- `REAL PRODUCT FAILURE`
- `HARNESS / TEST FAILURE`
- `DEPLOY / INFRASTRUCTURE FAILURE`

Do not guess. Product files may be changed only when product evidence requires it. Harness failures are repaired in harness/test code only. A deploy propagation problem is not a Story or UI defect.

## P15 Browser Harness Engineering Contract

Real-browser validation must be robust enough that the test does not manufacture product defects.

- Prefer stable semantic role/name or explicit product state over coordinate taps.
- Do not reuse stale semantic-array indexes such as a snapshot followed later by `nth(index)` after Flutter semantics can reorder.
- Re-read semantics after every level or stage transition.
- Wait for a settled `(level, stage)` state before asserting content. Transitional simultaneous `2/6` and `3/6` nodes are not a stable state.
- Detect and diagnose unexpected dialogs before continuing.
- Prefer static checked-in scripts over dynamically generated JavaScript/RegExp/String.raw source rewriting.
- Run syntax/preflight checks before expensive browser execution.
- Mobile Founder-equivalent validation must use the real bare Experience URL when that is the user path.
- On failure capture current URL, level, stage, semantic/DOM state, console, page errors, failed requests, runtime/startup state, and screenshot where useful before deciding a fix.

## P16 Fast but Strict Journey Pipeline

The canonical fast path is:

1. **Preflight:** exact remote `main`, authorized Journey set, authorized paths, UI authorization, protected baseline manifest.
2. **Design before code:** lock Story invariants, level progression, Vocabulary provenance, Discovery facts/depth, Challenge intents/answers, Memory, Completion, Annotation/languages, sources and human quality result.
3. **Cheap deterministic checks first:** syntax, static/contract tests, source/provenance checks, level matrix, translation/annotation alignment, Journey-scope isolation.
4. **One candidate where practical:** fix known contract defects before pushing so harness typos do not create serial new HEADs.
5. **Exact-head CI + Preview:** allow independent required jobs to run concurrently; do not duplicate an already successful exact-head run.
6. **Release identity:** verify Health/Release and deployed SHA before browser assertions.
7. **Browser proof:** Desktop six-stage, ReadingAnnotation, representative/required levels, Mobile WebKit bare path, and Journey-specific depth/interaction contracts.
8. **Final drift check:** final PR HEAD == tested HEAD == deployed SHA.
9. **Founder experience:** explicit decision tied to the candidate.
10. **Merge only after explicit authorization.**

Fail fast, but never approve fast. When speed and quality conflict, quality wins.

## P17 Reference Journey Regression Contract

`PHOENIX_REFERENCE_LOCATION_001` / `beijing-forbidden-city` is the first Reference Journey and remains a regression sentinel for the complete chain:

`Story opens → Vocabulary grows from CURRENT Story → Discovery adds grounded knowledge → Challenge verifies understanding/reasoning/transfer → Memory leaves the core → Completion closes the Journey`.

Its approved reference behavior additionally includes:

- Lv1-Lv10 substantive level differentiation;
- canonical Discovery depth `2/2/2/2/3/3/3/3/3/3`;
- current-level Story Reading Annotation synchronization;
- Desktop Chromium representative levels Lv1/Lv3/Lv5/Lv8/Lv10 across all six stages;
- iPhone/WebKit bare-URL startup/entry and mobile Discovery-depth verification.

Shared Journey/runtime changes that can affect this chain must run the Reference Journey E2E gate.

## Final rule

A Journey is not accepted because code exists, CI is green, a Preview deploys, or a checklist is full. Acceptance requires the applicable canonical content, level, factual, language, product, exact-head, browser/mobile, and human gates to be `PASS` with adequate evidence. No efficiency change may weaken that rule.
