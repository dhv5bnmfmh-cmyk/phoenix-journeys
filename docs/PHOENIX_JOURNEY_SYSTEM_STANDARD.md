# Phoenix Journey System Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose and binding relationship

This standard defines the common product skeleton for all existing and future Phoenix Journeys. [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) is binding and defines content differentiation, causal quality, Story / Discovery separation, narrative-engine independence, level invariants, and repair-batch gates.

The Journey System Standard defines the common skeleton. The Narrative and Discovery Standard defines the independent narrative, cultural, emotional, and literary result inside that skeleton.

Shared structure MUST create consistency without turning Journeys into repeated Story, Discovery, or visual templates. All work MUST obey `NEW RESULT >= CURRENT STABLE BASELINE`.

## 2. Canonical requirement classes

Use only:

- `REQUIRED`: every Journey MUST provide the element or a validated equivalent;
- `CONDITIONALLY_REQUIRED`: the element MUST exist when its applicability condition is true;
- `OPTIONAL`: omission does not weaken a required flow.

Historical `MANDATORY` maps to `REQUIRED`; historical `CONDITIONAL` maps to `CONDITIONALLY_REQUIRED`. `NOT_APPLICABLE` requires a documented decision, reason, and evidence. It is not automatic `PASS`.

## 3. Canonical Journey identity

The following are REQUIRED unless explicitly marked otherwise:

- unique and stable Journey ID;
- Journey Type: normal or special;
- non-interchangeable city, place, realm, or experiential identity;
- unique Story ID;
- approved cultural anchor;
- Protagonist;
- Relationship;
- Goal;
- Conflict connected to Goal;
- enacted Choice;
- caused Consequence;
- Emotional Arc;
- narrative engine;
- opening type;
- climax;
- changed ending state;
- Journey-specific memory anchor.

Relationship and Goal are independent requirements with their own evidence, Result, and Evidence Level.

Generic second-person perspective alone does not satisfy protagonist identity.

Normal Journey and special Journey protagonist modes MUST follow Phoenix Narrative and Discovery Standard.

## 4. Canonical stages and Function Contracts

| Stage or element | Requirement | Product purpose |
|---|---|---|
| Story | REQUIRED | Independent narrative input with causal movement. |
| Vocabulary | REQUIRED | Journey-context lexical learning. |
| ReadingAnnotation | CONDITIONALLY_REQUIRED | Pronunciation, translation, and segmentation for explorer-facing reading text. |
| Discovery | REQUIRED | Verified cultural or contextual understanding without retelling Story. |
| Challenge | REQUIRED | Validated understanding or application. |
| Reflection | REQUIRED | Explorer interpretation or emotional response. |
| Writing | REQUIRED | Meaningful learner production. |
| Memory | REQUIRED | Durable Journey-specific recall. |
| Completion | REQUIRED | Outcome, progress, saved state, and next action. |
| Reward | REQUIRED | Approved progression or recognition. |
| Stamp | CONDITIONALLY_REQUIRED | Required when Passport, collection, reward, or completion design includes it. |
| Visual Stages | REQUIRED | Stage-appropriate visual direction and runtime mapping. |
| Narration | CONDITIONALLY_REQUIRED | Required where reading or audio playback exists. |
| Multilingual Content | REQUIRED | Meaning-aligned supported variants. |
| Progression | REQUIRED | Order, unlock, completion, repeat, and return behavior. |
| Persistence | REQUIRED | Correct Journey and stage save/restore. |
| Routing | REQUIRED | Exact route, Journey ID, Story ID, and parameters. |
| Loading / Error / Fallback | REQUIRED | Safe state behavior without wrong-content substitution. |
| Accessibility | REQUIRED | Semantics, focus, text, contrast, motion, and input. |
| Rights Evidence | CONDITIONALLY_REQUIRED | Approved provenance for sourced or protected material. |

Story and Discovery MUST each submit a one-sentence Function Contract. Challenge, Reflection, Writing, Memory, and Completion MUST also submit Function Contracts under the Narrative and Discovery Standard.

Copying or paraphrasing the same content across stages is prohibited.

## 5. Story contract

Every Story MUST:

- use an independently identifiable protagonist and causal Relationship;
- establish place or realm through lived action;
- contain a specific Goal, connected Conflict, enacted Choice, and caused Consequence;
- develop an Emotional Arc;
- integrate the cultural anchor into action, stakes, relationship, choice, or consequence;
- begin with an active situation, need, disruption, obligation, or relationship tension;
- contain causal progression and a decisive climax;
- end in a changed state;
- remain distinguishable from every other Journey in opening, structure, climax, and ending;
- avoid generic tourism narration, factual-exposition-first Story design, filler, and interchangeable city references;
- keep IDs, annotations, translations, vocabulary, Challenge, Reflection, Writing, Memory, Completion, and narration aligned.

Automated scores cannot approve literary quality.

## 6. Story / Discovery functional separation

Story is narrative experience. Discovery is verified explanation that adds knowledge not already delivered by Story.

Every Journey MUST record:

- Story Function;
- Discovery Function;
- Story-only information;
- Discovery-only information;
- intentional overlap and justification;
- Functional Separation Result;
- Evidence Level.

Exact-text difference does not prove functional separation. Functional duplication is blocking.

## 7. Normal Journey rules

Normal Journeys MAY share page skeleton, stage order, navigation, narration controls, multilingual rules, persistence, reward framework, state components, and evidence methods.

Each normal Journey MUST independently define protagonist identity, role, Relationship, Goal, Conflict, Choice, Consequence, Emotional Arc, cultural anchor, narrative engine, daily-life or place-specific setting, climax, ending, visual composition, and memory anchor.

A city name, landmark, fact swap, recolor, or weather change applied to the same causal structure is not an independent Journey.

## 8. Special Journey rules

Special Journeys MAY share product infrastructure but MUST preserve literary and visual independence.

Each special Journey MUST independently define literary structure, protagonist mode, Relationship, Goal, Conflict, Choice, Consequence, Emotional Arc, narrative engine, imagery, environment, memory anchor, and approved extraordinary mechanism.

Anonymous second-person narration is permitted only under the conditions in the Narrative and Discovery Standard. Special Journeys MUST NOT use one shared fantasy filter, reveal pattern, magical device, generic level adaptation, or uniform visual composition.

## 9. Library-level differentiation

Library-level differentiation is REQUIRED evidence for every proposal, repair, pilot, batch, and new Journey.

Use [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md) to compare title, opening, protagonist, role, Relationship, Goal, Conflict, Choice, Consequence, Emotional Arc, engine, climax, ending, daily-life setting, cultural anchor, perspective, interpersonal method, pace, theme, memory anchor, visual motif, and special mechanism.

One numeric similarity score cannot approve the library result.

## 10. Level adaptation

Phoenix Lv.1 through Lv.10 MUST preserve protagonist, Relationship, Goal, Conflict, key Choice, Consequence, event order, Emotional Arc, cultural anchor, ending state, memory anchor, and special mechanism where applicable.

Vocabulary, grammar, sentence length, paragraph density, dialogue quantity, and explanatory detail MAY change. Simplification MUST NOT remove causality or turn Story into tourism exposition.

All special Journeys require an explicitly approved special or Journey-specific adaptation policy.

## 11. Shared systems

The following SHOULD remain centralized where architecture supports it:

- route and parameter validation;
- Journey access and entitlement;
- stage navigation and progress;
- narration and interruption state;
- language and locale selection;
- persistence and migration;
- reward and stamp storage;
- Loading, Error, Empty, and Fallback presentation;
- accessibility semantics;
- privacy boundaries;
- stable-baseline comparison.

Consistency MUST NOT override Journey-specific identity.

## 12. Routing and data integrity

Review exact Journey ID, Story ID, route, parameters, Journey Type, page component, language record, asset path, stage mapping, progress key, completion event, reward, Stamp applicability, and fallback behavior.

Fallback MUST NOT load another Journey's content. Closed PRs `#138` through `#141` are historical evidence only and MUST NOT be used as a development baseline.

## 13. Multilingual alignment

Supported variants MUST preserve event order, protagonist, Relationship, Goal, Conflict, Choice, Consequence, cultural meaning, Story / Discovery separation, vocabulary, annotations, Challenge answers, Reflection and Writing intent, Memory, Completion, accessibility labels, and narration locale.

Natural translation is allowed; factual, causal, emotional, or learning-objective drift is not.

## 14. Narration, visual, progress, and states

Where narration exists, verify correct text and locale, play, pause, resume, replay, stop, speed, temporary playback continuation, highlight/progress synchronization, interruption, lifecycle restore, error, and fallback.

Visual stages MUST meet Phoenix UI and Visual Standard and preserve PR `#137` as the minimum quality. File existence, dimensions, hashes, automated scores, or rights records alone cannot produce visual `PASS`.

Progression MUST define entry, eligibility, stage order, permitted return, partial save, resume, completion, replay, reward idempotency, Stamp behavior, unlock effects, and migration. Cross-Journey contamination, duplicate rewards, or lost stable state is `REGRESSION`.

Loading, Error, Empty, and Fallback are separate evidence states. Failure MUST NOT silently load a different Journey, stale translation, unrelated image, or generic placeholder.

## 15. Accessibility, rights, and disclosure

Every Journey MUST support applicable semantic headings, reading/focus order, meaningful control states, text scaling, non-color feedback, image alternatives, reduced motion, keyboard and assistive input, accessible narration, and non-audio alternatives.

Rights evidence MUST identify source, license or permission, modification constraints, attribution, and approved use. Rights approval does not establish literary, cultural, audio, or visual quality. Unpublished Phoenix content MUST NOT be sent to an unapproved external service.

## 16. Acceptance evidence

Acceptance MUST include:

- proposal and design record;
- complete Story / Discovery Design Matrix;
- exact paths, IDs, routes, Commit, Tree, and parent;
- Story and Discovery Function Contracts;
- protagonist-mode evidence;
- Relationship causality;
- Goal, Conflict, enacted Choice, and caused Consequence evidence;
- opening, climax, ending, and narrative-engine evidence;
- library differentiation;
- level invariants;
- multilingual, narration, progress, persistence, visual, mobile, and rights evidence;
- separate automated structural and human literary results;
- isolated Preview;
- `STABLE_BASELINE_COMPARISON`;
- Founder mobile approval where required.

Use [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md) for new Journeys.

## 17. Blocking rules

A Journey MUST NOT be marked Completed when:

- a REQUIRED element is missing;
- an applicable CONDITIONALLY_REQUIRED element is missing;
- a required row is not `PASS` with `VERIFIED` evidence;
- Story and Discovery functionally overlap;
- protagonist identity or causal Relationship is unverified;
- Choice is not enacted or Consequence is not caused;
- content or visuals are interchangeable templates;
- library differentiation or level invariants are unverified;
- automated score is used as literary approval;
- pilot or batch gates are violated;
- route, ID, asset, language, progress, reward, or Stamp mapping is unverified;
- stable comparison is missing or a regression exists;
- required Founder approval is not `APPROVED`.

New Journey execution follows [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md). This standard does not authorize content repair or pilot implementation.
