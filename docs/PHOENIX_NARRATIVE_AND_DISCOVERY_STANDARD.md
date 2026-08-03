# Phoenix Narrative and Discovery Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

All work governed by this standard MUST obey:

> **NEW RESULT >= CURRENT STABLE BASELINE**

## 1. Purpose and scope

This standard applies to:

- new Journeys;
- existing Journey Story repairs;
- Discovery creation and repair;
- Phoenix Lv.1 through Lv.10 adaptation;
- translations and ReadingAnnotations;
- content review and audit;
- pull-request approval;
- controlled repair batches and future expansion.

Shared product structure MAY be consistent. Narrative identity, cultural identity, emotional identity, causal structure, and literary structure MUST NOT become templates.

This standard is binding together with the Phoenix Journey System Standard, Phoenix New Journey Creation Standard, Phoenix Product Quality Standard, Phoenix Full Application Audit Standard, and their matrices.

## 2. Canonical content functions

Every Journey design MUST submit a one-sentence **Function Contract** for every applicable stage.

| Stage | Canonical function |
|---|---|
| Story | A narrative experience built around protagonist, relationship, goal, conflict, enacted choice, caused consequence, and emotional movement. |
| Discovery | Cultural, historical, social, spatial, ecological, technical, or literary explanation that adds verified understanding without retelling Story. |
| Reflection | Explorer interpretation or emotional response. |
| Writing | Meaningful learner production. |
| Memory | A Journey-specific durable recall anchor. |
| Challenge | Validated understanding or application of Story and Discovery. |
| Completion | Outcome, progress, and next action. |

Required record:

```text
Stage:
Function Contract:
Unique learner value:
Inputs:
Outputs:
Evidence path:
Result:
Evidence Level:
```

A field, paragraph, or screen does not satisfy a stage merely by existing. Its product function MUST be independently demonstrated.

## 3. Story functional contract

Every Story MUST:

1. contain an independently identifiable protagonist;
2. define Relationship separately;
3. define Goal separately;
4. connect Conflict to Goal;
5. show an enacted Choice;
6. show a visible Consequence caused by the Choice;
7. contain an identifiable emotional movement;
8. establish place or realm through lived action;
9. integrate the cultural anchor into stakes, action, relationship, choice, or consequence;
10. contain an opening disruption, need, obligation, or active situation;
11. contain causal progression;
12. contain a climax or decisive moment;
13. end with a changed state, relationship, responsibility, understanding, or consequence;
14. remain distinguishable from the catalog in opening, structure, climax, and ending.

Factual exposition MUST NOT be the Story's primary narrative engine.

A Story MUST NOT be accepted merely because it is accurate, elegant, long, culturally informative, grammatically correct, structurally populated, or assigned a high automated score.

## 4. Protagonist modes

### 4.1 Normal Journey

The protagonist MUST be named or uniquely identifiable through a stable role, responsibility, background, and lived situation.

Generic `you`, `visitor`, `traveller`, `traveler`, `explorer`, or anonymous observer alone does not satisfy protagonist independence.

### 4.2 Special Journey

Anonymous second-person narration is permitted only when all of the following are present:

- a Journey-specific role or life context;
- an explicit Relationship;
- a concrete Goal;
- a real Conflict;
- an enacted Choice;
- a visible Consequence;
- a Journey-specific emotional arc;
- an independent literary mechanism.

Second person is a narrative perspective, not a substitute for character identity.

## 5. Relationship causality

Relationship MUST affect at least one of:

- Goal;
- Conflict;
- Choice;
- Consequence;
- Emotional Arc;
- Ending.

A person merely mentioned in exposition does not satisfy Relationship.

Dialogue is not mandatory in every Journey. The relationship MUST nevertheless be visible through action, memory, obligation, disagreement, trust, loss, responsibility, dependence, promise, or another concrete interaction.

Required evidence:

```text
Relationship parties:
Relationship state at opening:
Causal function:
Affected Goal / Conflict / Choice / Consequence / Emotional Arc / Ending:
Exact Story evidence:
Result:
Evidence Level:
```

## 6. Story and Discovery separation

Story MAY contain only the cultural facts required for action, understanding, and emotional stakes.

Discovery MUST add verified knowledge that Story does not already explain.

Discovery MUST NOT:

- summarize Story;
- retell Story events;
- replace Story with cultural exposition;
- duplicate Story using different wording;
- repeat the same conclusion;
- use Story character names merely to disguise duplicated explanation.

Every Journey MUST submit:

```text
Story Function:
Discovery Function:
Information unique to Story:
Information unique to Discovery:
Intentional overlap:
Why the overlap is necessary:
Functional Separation Result:
Evidence Level:
```

Exact-text difference is insufficient. Functional duplication is a blocking issue.

## 7. Narrative engine declaration

Each Journey MUST declare its primary narrative engine and any secondary engine.

Possible engines include work task, family relationship, investigation, deadline, ethical dilemma, community responsibility, apprenticeship, letter, recording, archive, disappearance, promise, environmental change, dialogue conflict, or extraordinary mechanism. These examples are not an approved template list.

Required record:

```text
Primary narrative engine:
Secondary narrative engine, if any:
How the engine creates causal progression:
Closest existing Journey engines:
How this engine differs:
Substitution test:
Result:
Evidence Level:
```

A city name, landmark, historical fact, object recolor, different weather, or different visual skin applied to the same causal structure does not create an independent Journey.

## 8. Opening, progression, climax, and ending independence

### 8.1 Opening

The Story MUST begin with a character situation, need, disruption, obligation, relationship tension, or meaningful action.

A scenic opening is permitted only when it immediately connects to the protagonist's situation.

Patterns such as the following MUST NOT dominate a batch or library:

- `清晨，你走进……`
- `傍晚，你沿着……`
- `夜色中，你站在……`
- `薄雾里，你来到……`

### 8.2 Progression

Facts SHOULD emerge through action, discovery, dialogue, evidence, conflict, or consequence where applicable. Paragraph order MUST preserve causal progression rather than accumulate facts.

### 8.3 Climax

The climax MUST include a decisive action, discovery, confrontation, commitment, or irreversible recognition. A final fact paragraph is not a climax.

### 8.4 Ending

The ending MUST show the result of the Journey's action or choice. A philosophical summary alone does not satisfy Consequence.

Patterns such as the following MUST NOT function as the main ending structure across multiple Journeys:

- `不只是……而是……`
- `真正……不是……`
- `保护不仅……也……`
- `你会发现……`
- `理解……需要……`

Opening, progression, climax, and ending MUST each be compared against materially similar catalog entries.

## 9. Cultural-anchor integration

The cultural anchor MUST:

- affect the protagonist or relationship;
- affect Goal, Conflict, Choice, or Consequence;
- be necessary to this Journey;
- be non-interchangeable with another city or realm;
- be supported by approved internal source evidence.

Decorative facts, landmark names, appended trivia, or a cultural paragraph placed after an otherwise interchangeable Story do not satisfy integration.

The design record MUST explain what breaks if the cultural anchor is removed or replaced. If nothing material changes, use `CULTURAL_ANCHOR_DECORATIVE`.

## 10. Library differentiation matrix

Every proposal, pilot, repair batch, and new Journey MUST compare against the current catalog using [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md).

The comparison MUST include:

- title pattern;
- opening pattern;
- protagonist identity;
- protagonist role;
- relationship;
- goal;
- conflict;
- choice;
- consequence;
- emotional arc;
- narrative engine;
- climax;
- ending pattern;
- daily-life setting;
- cultural anchor;
- perspective;
- dialogue or interpersonal-action method;
- pace;
- theme;
- memory anchor;
- visual motif;
- special mechanism when applicable.

Similarity alone is not automatic failure. It becomes blocking when it causes:

- interchangeable Journey identity;
- repeated causal structure;
- repeated opening or ending system;
- city or realm substitution;
- Story/Discovery functional duplication;
- literary flattening;
- lower quality than the stable baseline.

One unsupported numeric similarity score MUST NOT be used as approval.

## 11. Batch anti-template rule

Within the same implementation batch, no two Journeys may share the same combined pattern of:

- opening type;
- protagonist type;
- relationship type;
- goal;
- conflict;
- key choice;
- consequence;
- climax;
- ending structure.

Before one pilot receives Founder mobile approval:

- no batch Story rewrite;
- no 27-Journey rewrite;
- no nine-special-Journey rewrite;
- no second pilot implementation;
- no template inferred from the first draft.

After pilot approval:

- default repair batch size is two to three Journeys;
- every Journey keeps an independent acceptance record;
- batch approval does not replace Journey-level approval;
- reduced quality at scale blocks expansion;
- library differentiation MUST be rerun after every batch.

## 12. Level-adaptation invariants

Across Phoenix Lv.1 through Lv.10, the following are narrative invariants:

- protagonist identity;
- relationship;
- goal;
- conflict;
- key choice;
- consequence;
- event order;
- emotional arc;
- cultural anchor;
- ending state;
- Journey-specific memory anchor;
- special mechanism when applicable.

Level adaptation MAY change:

- vocabulary;
- grammar;
- sentence length;
- paragraph density;
- amount of dialogue;
- explanatory detail.

Simplification MUST NOT remove causality or turn Story back into tourism exposition.

All special Journeys MUST use an explicitly approved special or Journey-specific adaptation policy. Generic adaptation is prohibited when it flattens the literary mechanism.

Each level MUST receive a separate Result and Evidence Level in the design matrix.

## 13. Automated validation limitations

Automated validation MAY verify:

- required fields;
- empty content;
- paragraph count;
- length;
- language records;
- annotations;
- exact duplication;
- IDs;
- structural integrity.

Automated validation cannot by itself approve:

- protagonist independence;
- Relationship quality;
- Goal significance;
- Conflict quality;
- Choice meaning;
- Consequence strength;
- emotional arc;
- cultural integration;
- Story/Discovery functional separation;
- library differentiation;
- literary quality;
- Founder experience.

Statements such as `360 / 360 PASS`, `score 100`, `average 100`, and `all fields present` MUST be reported only as evidence for the checks actually implemented. They MUST NOT produce overall Story Quality `PASS`.

Automated structural Result and human literary Result MUST be recorded separately.

## 14. Blocking codes

The following codes are binding minimum codes:

- `PROTAGONIST_IDENTITY_MISSING`
- `RELATIONSHIP_NOT_CAUSAL`
- `GOAL_NOT_PERSONAL_OR_SPECIFIC`
- `CONFLICT_NOT_CONNECTED_TO_GOAL`
- `CHOICE_NOT_ENACTED`
- `CONSEQUENCE_NOT_CAUSED`
- `EMOTIONAL_ARC_UNVERIFIED`
- `CULTURAL_ANCHOR_DECORATIVE`
- `STORY_IS_PRIMARY_EXPOSITION`
- `STORY_DISCOVERY_FUNCTION_OVERLAP`
- `OPENING_TEMPLATE_REUSE`
- `ENDING_TEMPLATE_REUSE`
- `NARRATIVE_ENGINE_DUPLICATION`
- `LIBRARY_DIFFERENTIATION_UNVERIFIED`
- `LEVEL_ADAPTATION_IDENTITY_LOSS`
- `SPECIAL_MECHANISM_FLATTENED`
- `AUTOMATED_SCORE_NOT_LITERARY_APPROVAL`
- `BATCH_EXPANSION_BEFORE_PILOT_APPROVAL`

Every blocking-code record MUST include:

```text
Blocking Code:
Result:
Evidence Level:
Affected Journey IDs:
Exact evidence:
Required action:
Verification method:
Owner:
Founder Approval Required:
Status:
```

A code MUST NOT be closed by a checkbox, aggregate score, or a different code's evidence.

## 15. Existing Story repair pilot

Existing-library repair MUST begin with exactly two separately authorized pilots, in this order.

### Pilot N1

- Type: one normal Journey
- Recommended first candidate: `beijing-summer-palace`

### Pilot S1

- Type: one special Journey
- Recommended first candidate: `tide-letter`

Each pilot MUST include:

- complete Story / Discovery Design Matrix;
- Story and Discovery Function Contracts;
- level invariants;
- annotations;
- translations;
- vocabulary;
- Challenge;
- Reflection;
- Writing;
- Memory;
- Completion;
- narration;
- stable comparison;
- isolated Preview;
- Founder mobile approval.

Pilot rejection returns the same pilot to revision. It does not authorize switching to mass production, replacing the pilot with another Journey, starting the second pilot, or inferring a reusable Story template.

Pilot N1 MUST be decided before Pilot S1 implementation begins. Pilot S1 MUST be decided before controlled batch expansion begins.

## 16. Approval boundary

A Story, Discovery, pilot, batch, or new Journey is not approved unless:

- every applicable blocking code is absent or closed with VERIFIED evidence;
- the Story / Discovery Design Matrix is complete;
- Journey-level and library-level review both pass;
- automated and human results are separately recorded;
- stable comparison passes;
- required Founder approval is explicitly tied to the candidate Commit and Preview.

This standard establishes governance only. It does not authorize content repair, pilot implementation, batch rewriting, or a new Journey.
