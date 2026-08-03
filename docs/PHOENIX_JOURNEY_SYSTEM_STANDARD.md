# Phoenix Journey System Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the common product skeleton for all existing and future Phoenix Journeys while protecting narrative, cultural, emotional, literary, and visual independence.

Shared product structure MUST create consistency without turning Journeys into repeated story or visual templates.

## 2. Canonical requirement classes

All Phoenix Journey standards, matrices, and reviews MUST use only:

- `REQUIRED`: Every Journey MUST provide the element or an explicit validated equivalent.
- `CONDITIONALLY_REQUIRED`: The element MUST exist when its stated applicability condition is true.
- `OPTIONAL`: The element MAY be omitted without weakening required flow; omission MUST not create an incomplete stage.

Legacy terms, when encountered in historical records, map only as follows:

- `MANDATORY` = `REQUIRED`
- `CONDITIONAL` = `CONDITIONALLY_REQUIRED`

New rules, tables, and records MUST use the canonical terms. `NOT_APPLICABLE` requires a documented applicability reason and supporting evidence; it is not automatic `PASS`.

## 3. Canonical Journey identity

| Element | Requirement | Acceptance rule |
|---|---|---|
| Journey ID | REQUIRED | Unique, stable, correctly routed, and used consistently across data, progress, rewards, assets, and tests. |
| Journey Type | REQUIRED | Declares normal or special Journey and any approved subtype. |
| City / Realm Identity | REQUIRED | Establishes a non-interchangeable place, realm, or experiential identity. |
| Story ID | REQUIRED | Unique and linked to the correct Journey. |
| Cultural Anchor | REQUIRED | Specific, meaningful, integrated into action or learning, and not decorative trivia. |
| Protagonist | REQUIRED | Independent identity, agency, and relation to the Journey. |
| Relationship | REQUIRED | Defines the relationship identity, narrative function, and influence on the Journey. |
| Goal | REQUIRED | Defines the protagonist goal, why it matters, and how it relates to the conflict. |
| Conflict | REQUIRED | Real obstacle, tension, or dilemma that affects the goal. |
| Choice | REQUIRED | A meaningful decision or commitment, not a cosmetic branch. |
| Consequence | REQUIRED | A visible result caused by action or choice. |
| Emotional Arc | REQUIRED | Identifiable emotional movement from opening through consequence and ending. |

Relationship and Goal MUST be accepted as independent requirements with their own evidence paths, Result, and Evidence Level. They MUST NOT be inferred only from a general Story review.

## 4. Learning and narrative stages

| Stage or element | Requirement | Product purpose and applicability |
|---|---|---|
| Story | REQUIRED | Delivers the independent narrative, language input, context, conflict, choice, and consequence. |
| Vocabulary | REQUIRED | Teaches selected words in the Journey context with correct language support. |
| ReadingAnnotation | CONDITIONALLY_REQUIRED | Required when the Journey contains Story, Discovery, or other learning text intended for explorer reading. It aligns source text, pronunciation or annotation, translations, and segmentation. If no applicable reading text exists, use `NOT_APPLICABLE` with reason and evidence. |
| Discovery | REQUIRED | Explains culture, context, place, practice, or meaning without duplicating Story. |
| Challenge | REQUIRED | Tests understanding or application with valid feedback. |
| Reflection | REQUIRED | Connects the Journey to interpretation, feeling, or personal thought. |
| Writing | REQUIRED | Produces meaningful learner output aligned to level and Journey content. |
| Memory | REQUIRED | Creates a durable Journey-specific recall anchor. |
| Completion | REQUIRED | Confirms completion, progress, next action, and saved state. |
| Reward | REQUIRED | Provides the approved progression or recognition outcome. |
| Stamp | CONDITIONALLY_REQUIRED | Required when completion, reward, Passport, collection, or progress design includes a Stamp. If an explicit product decision excludes Stamp, use `NOT_APPLICABLE` with the design basis and evidence; do not use `OPTIONAL` to hide a missing Stamp. |
| Visual Stages | REQUIRED | Provides stage-appropriate visual direction and runtime mapping. |
| Narration | CONDITIONALLY_REQUIRED | Required wherever the product provides reading or audio playback. |
| Multilingual Content | REQUIRED | All supported language variants remain meaning-aligned and correctly routed. |
| Progression | REQUIRED | Defines order, unlock, completion, and repeat behavior. |
| Persistence | REQUIRED | Saves and restores the correct Journey and stage state. |
| Routing | REQUIRED | Uses exact route, Journey ID, stage ID, and parameters. |
| Loading | REQUIRED | Handles every asynchronous stage entry or operation. |
| Error | REQUIRED | Handles invalid, unavailable, permission, network, and service failures as applicable. |
| Fallback | REQUIRED | Provides safe degradation without wrong content or low-quality runtime substitution. |
| Accessibility | REQUIRED | Meets semantic, focus, text, contrast, motion, and input requirements. |
| Rights Evidence | CONDITIONALLY_REQUIRED | Required for protected, sourced, licensed, or permission-controlled material; it records approved provenance without replacing visual approval. |

## 5. Story requirements

Every Journey Story MUST:

- use an independent protagonist and relationship;
- establish a specific place or realm through lived detail;
- contain a concrete goal, conflict, meaningful choice, and consequence;
- develop an emotional arc;
- integrate the cultural anchor into the narrative rather than append it;
- support the intended language level and learning outcomes;
- avoid generic tourism narration, filler, and interchangeable city references;
- remain distinguishable from every other Journey in opening, structure, climax, and ending;
- maintain synchronized IDs, annotations, translations, learning items, and dependent stages.

## 6. Learning-stage integrity

Stages MAY reuse shared page components, navigation logic, and state handling. Each stage MUST retain a distinct function:

- Story is narrative input.
- Vocabulary is targeted lexical learning.
- Discovery is cultural or contextual understanding.
- Challenge is validated comprehension or application.
- Reflection is interpretation and emotional connection.
- Writing is learner production.
- Memory is durable recall design.
- Completion records outcome and next action.
- Reward and conditionally applicable Stamp represent approved progression.

Copying the same text across stages to satisfy field presence is prohibited.

## 7. Normal Journey rules

Normal Journeys MAY share:

- page skeleton;
- learning-stage order;
- navigation;
- narration controls;
- multilingual rules;
- progress and persistence;
- reward framework;
- loading, error, empty, and fallback components;
- acceptance and evidence methods.

Normal Journeys MUST independently define:

- protagonist;
- relationship;
- goal;
- conflict;
- choice;
- consequence;
- emotional arc;
- cultural anchor;
- city life or place-specific scene;
- narrative structure;
- visual composition and environment;
- memory anchor.

A city name, landmark, or recolor applied to the same narrative structure is not an independent Journey.

## 8. Special Journey rules

Special Journeys MAY share the same product and learning infrastructure as normal Journeys. They MUST preserve independent literary and visual identity.

Each special Journey MUST independently define:

- literary structure;
- protagonist and relationship;
- goal, conflict, choice, and consequence;
- emotional arc;
- imagery and visual composition;
- environment and color relationships;
- memory anchor;
- approved mysterious, symbolic, or extraordinary mechanism.

Special Journeys MUST NOT use one shared fantasy filter, identical reveal pattern, repeated magical device, or uniform visual composition.

## 9. Shared systems that MUST remain consistent

The following SHOULD be centralized or governed consistently where the existing architecture supports it:

- route naming and parameter validation;
- Journey access and entitlement policy;
- stage navigation and progress rules;
- narration state and interruption behavior;
- language and locale selection;
- persistence and migration;
- reward and stamp storage;
- loading, error, and fallback presentation;
- accessibility semantics;
- analytics and privacy boundaries;
- stable-baseline comparison method.

Consistency MUST NOT override Journey-specific content or visual identity.

## 10. Routing and data integrity

For every Journey, reviewers MUST verify:

- exact Journey ID;
- exact Story ID;
- exact route and route parameters;
- correct Journey type;
- correct page component;
- correct data record and language variant;
- correct asset path and visual stage;
- correct progress key and completion event;
- correct reward and conditionally applicable stamp mapping;
- no fallback to another Journey's content;
- no implementation inherited from closed PRs `#138`–`#141` as a baseline.

An incorrect route, ID, resource, reward, or progress mapping is at least `REQUIRES_REVISION`; loss or corruption of stable behavior is `REGRESSION`.

## 11. Multilingual alignment

All supported variants MUST align at the level of:

- story meaning and event order;
- protagonist, relationship, goal, conflict, choice, and consequence;
- vocabulary selection and explanation;
- annotations and segmentation;
- Discovery learning intent;
- Challenge answer validity;
- Reflection and Writing prompt intent;
- Memory and Completion meaning;
- accessibility labels and narration language.

A translation MAY be natural rather than literal, but it MUST NOT change the Journey's facts, choice, consequence, cultural meaning, or learning objective.

## 12. Narration and audio

Where narration exists, the Journey MUST verify:

- correct text, language, and stage;
- play, pause, resume, replay, stop, and interruption behavior;
- synchronization with visible progress or highlight where designed;
- no unintended overlap between stages or temporary playback;
- correct continuation after vocabulary or annotation playback;
- restored state after route change or app lifecycle events;
- safe error and fallback behavior.

## 13. Visual stages

Visual stages MUST support the Journey's narrative and learning progression. They MUST follow [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md), preserve PR `#137` as the minimum quality level, and remain independently recognizable.

Runtime mapping MUST be verified on the actual page. File existence, hash, dimensions, rights evidence, or data registration alone cannot produce visual `PASS`.

## 14. Progression, persistence, and reward

The Journey MUST define and verify:

- entry and eligibility;
- stage order and permitted return paths;
- partial progress save;
- resume location;
- completion criteria;
- replay behavior;
- reward issuance and idempotency;
- Stamp applicability decision and issuance when applicable;
- unlock effects;
- migration behavior when IDs or content versions change.

Cross-Journey progress contamination, duplicate rewards, missing completion, or incorrect entitlement is `REGRESSION` and may be P0 or P1.

## 15. Loading, error, empty, and fallback

Every Journey entry and stage MUST define applicable states. A failure MUST NOT silently load a different Journey, stale translation, unrelated image, or generic runtime placeholder. Recovery MUST preserve user progress and provide a reproducible next action.

## 16. Accessibility

Every Journey MUST support applicable:

- semantic page and stage headings;
- correct reading and focus order;
- meaningful control names and states;
- text scaling and reflow;
- non-color feedback;
- image alternatives;
- reduced motion;
- keyboard and assistive input;
- accessible narration and non-audio alternatives.

## 17. Rights and external disclosure

Rights evidence MUST be attached to applicable text, image, audio, and sourced cultural material. Evidence MUST identify source, permission or license, modification constraints, and approved use.

Rights approval does not establish content, cultural, audio, or visual quality. Unpublished Phoenix content MUST NOT be sent to external services without explicit approval.

## 18. Acceptance evidence

Journey acceptance MUST include applicable:

- proposal and design record;
- exact paths, IDs, routes, and candidate Commit;
- independent Relationship and Goal evidence;
- ReadingAnnotation applicability and evidence;
- Stamp applicability and evidence;
- stable and candidate page evidence;
- multilingual alignment evidence;
- narration and interaction evidence;
- progress and persistence evidence;
- asset mapping and mobile crop evidence;
- rights evidence;
- automated validation results;
- isolated Preview;
- `STABLE_BASELINE_COMPARISON`;
- Founder mobile approval for visual or core interaction changes.

Use [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md) for new Journeys.

## 19. Blocking rules

A Journey MUST NOT be marked Completed when:

- any `REQUIRED` element is missing;
- any applicable `CONDITIONALLY_REQUIRED` element is missing or lacks an evidence-backed `NOT_APPLICABLE` decision;
- a REQUIRED acceptance item is not `PASS` with `VERIFIED` evidence;
- content or visuals are interchangeable templates;
- route, ID, asset, language, progress, reward, or stamp mapping is unverified;
- the stable comparison is missing;
- any regression exists;
- Founder mobile approval is required but not `APPROVED`.

New Journey execution follows [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md).