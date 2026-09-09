# AUTHORITATIVE STORY DEVELOPMENT CONTRACT

**Status:** AUTHORITATIVE ENTRY POINT  
**Purpose:** index and enforce the existing Phoenix Story standards; this file
does not create a new or parallel Story standard.

## Binding authority

Story work MUST load and obey all of the following existing authorities:

1. [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md)
2. [Story Depth + Historical Story Universe Appendix](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md)
3. [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md)
4. [Phoenix Six-Stage Journey Standard](PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md)
5. [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md)
6. [Phoenix Product Quality Standard](PHOENIX_PRODUCT_QUALITY_STANDARD.md)
7. [Phoenix Full Application Audit Standard](PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md)
8. [Phoenix Journey Content Quality Gate](journey-content-quality-gate.md)
9. [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md)
10. [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md)
11. [Fast Development Governance V2](FAST_DEVELOPMENT_GOVERNANCE_V2.md)

Where wording overlaps, the binding parent documents and the stricter
requirement control. Destination-specific, candidate, temporary, or historical
workflow text MUST NOT redefine or bypass these authorities.

## Golden product reference

The Founder-approved Golden implementation is the Forbidden City Story
`两条路，一张图` on Journey `beijing-forbidden-city`.

Every future Story inherits its navigation, level mechanism, six-stage page
sequence, Challenge architecture, audio and feedback lifecycles, progress,
resume, performance, and mobile behavior. A new Story supplies only its own
approved Story and Story-grounded learning data. It MUST NOT implement a
parallel engine, navigation route, lifecycle, fallback, or candidate workflow.

## Mandatory order

1. Load this authoritative entry point and every binding authority above.
2. Load the Golden Story implementation.
3. Complete the pre-development Story quality plan.
4. Complete the Lv1–Lv10 × all-stage content plan.
5. Pass preflight.
6. Implement the Story through the Golden engine.
7. Pass local rendered acceptance.
8. Pass Golden Story behavior comparison.
9. Pass targeted contracts.
10. Pass analyze.
11. Pass performance validation.
12. Produce an exact-head Founder Preview.
13. Receive Founder device acceptance for that exact head.
14. Pass Full Governance.
15. Release the same validated artifact.

No step may be skipped or reordered.

## Pre-development hard gate

Before Story product code is written, the existing design and acceptance
matrices MUST prove:

- `CONTRACT_LOADED = YES`
- `GOLDEN_STORY_LOADED = YES`
- `STORY_QUALITY_REQUIREMENTS = PASS`
- `LV1_LV10_CONTENT_PLAN = COMPLETE`
- `ALL_REQUIRED_STAGES = DEFINED`
- `MISSING_CELLS = 0`
- `SILENT_FALLBACK = 0`
- `KNOWLEDGE_SOURCES = DEFINED`

Missing content is a hard failure. Story A content, a previous level, a generic
fixture, a template question, or shared Story content MUST NOT be substituted.
Story quality and historical truth are reviewed before learning-stage
generation; learning exercises MUST NOT be used to reverse-assemble a Story.

## Preview and release hard gate

Founder Preview requires rendered Lv1–Lv10 evidence for Story, Vocabulary,
Discovery, Challenge, Memory, and Completion, plus Golden behavior comparison,
Story isolation, semantic anti-template, audio, feedback, progress, resume, and
performance evidence. Source-only checks are insufficient.

Founder device acceptance is exact-head and precedes Full Governance. Deploy,
Publish, and release workflows MUST invoke
`.github/scripts/enforce_authoritative_story_contract.sh` before building or
deploying. The static governance test rejects a workflow that can publish a
Story product without this entry point.

## Rejected implementation

`交接前的标记` and
`story.forbidden_city.modern_evidence_handoff.v1` are Founder-rejected and MUST
be absent from product source, runtime registries, fallbacks, fixtures,
generators, tests, Preview harnesses, and release paths.
