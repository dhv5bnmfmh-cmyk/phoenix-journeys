# Phoenix Journey Acceptance Contract

**Status:** BINDING ENTRY CONTRACT  
**Purpose:** one acceptance entry point for every active Journey. Specialist Phoenix standards remain applicable where they add detail, but they may not contradict this contract.

## P1 Six-Stage

The only normal user-visible Journey flow is exactly:

`Story → Vocabulary → Discovery → Challenge → Memory → Completion`

Canonical committed stage IDs remain `0–5`. Reflection and Writing may be learning intents inside the six stages, but are not standalone active stages.

Any older rule, including an `S11 visible-stage count` rule, is **superseded** wherever it conflicts with this Six-Stage contract or `PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md`.

## P2 Story Trace

Every active learning item must trace to the current Story, current Discovery, or an explicit current-level language objective. Legacy Story text may not enter active runtime.

## P3 Level Adaptation

Lv1–Lv10 must increase cognitive and linguistic depth, not merely length, word count, option count, or sentence complexity.

## P4 Narrative Quality

Story must contain character, place-dependent goal, conflict, enacted choice, caused consequence, relationship movement, and changed ending state. Removing the named place must materially weaken the story mechanism.

## P5 Discovery Grounding

Discovery extends a question raised by Story into verifiable real-world knowledge. Historical, cultural, architectural, scientific, or other factual claims require reliable provenance. Editorial fact/fiction notices belong in Sources/About, not Discovery slots.

## P6 Challenge Cognition

Challenge must test distinct abilities rather than repeat one synthesis sentence in three UI forms. The three active renderer modes must have differentiated cognitive purposes, fair answer logic, teach-before-test provenance, and diagnosable distractors. Mechanical string corruption is prohibited Gold content.

## P7 Memory Closure

Memory returns the learner to a Journey-specific character choice and durable meaning. It is not a generic quiz collection and may not reference deprecated Story semantics.

## P8 Completion Closure

Completion must close Story, learning, Memory, relationship change, emotional movement, reward/progress, and the next unlocked state in language appropriate to the selected level.

## P9 Language Semantic Alignment

Every formal language/support version must preserve the same Goal, Conflict, Choice, Consequence, character motivation, Challenge answer logic, Memory core, and grounded Discovery facts. Natural localization is preferred over literal translation, but semantic drift is blocking.

## P10 Location Binding

Every Journey must bind to a canonical geographic node and resolve through the location registry. Loose country/city/place strings are descriptive metadata only, not authoritative identity.

## P11 Runtime / UI / Data Evidence

Acceptance requires evidence across source data, runtime mapping, user-visible UI, routing, level selection, stage progression, completion, return, unlock, and persisted progress. JSON-only or unit-test-only evidence is insufficient.

## P12 Gold Acceptance

Gold requires all applicable machine gates and human semantic gates to pass at the exact active revision. Prior Gold/Approved labels are not grandfathered. Any blocker means Gold is denied.

## Standard relationship

- `PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md`: binding specialist detail for stage and Challenge governance.
- Historical checklists and acceptance matrices: **reference-only when duplicated by P1–P12**; retain only independent specialist value.
- A duplicate MUST never create a parallel or contradictory acceptance requirement.

## Reference implementation

`PHOENIX_REFERENCE_LOCATION_001` / `beijing-forbidden-city` is the first Reference Journey expected to demonstrate the complete chain:

`Story opens → Vocabulary grows from Story → Discovery connects Story to the real place → Challenge verifies understanding/reasoning/transfer → Memory leaves the core → Completion closes the journey.`
