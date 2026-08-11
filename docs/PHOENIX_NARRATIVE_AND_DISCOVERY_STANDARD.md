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
- structural integrity;
- normalized semantic fingerprint completeness;
- active Story source identity;
- exact Story-evidence span presence;
- evidence dimension/mechanism alignment;
- semantic-rationale field completeness;
- deterministic CORE semantic collision thresholds.

Automated validation cannot by itself approve:

- protagonist independence;
- Relationship quality;
- Goal significance;
- Conflict quality;
- Choice meaning;
- Consequence strength;
- emotional arc;
- cultural integration;
- semantic sufficiency of a Narrative Mechanism classification;
- Story/Discovery functional separation;
- literary quality;
- Founder experience.

Semantic taxonomy assignment still requires truthful human/Agent classification against the active Story. CI may prove that cited spans are active Story text and that a rationale exists; it MUST NOT claim that string-presence tests independently understand or prove natural-language semantic entailment. Founder/Agent review determines whether the evidence plus rationale actually supports the normalized mechanism family. Once a truthful classification is assigned, the normalized fingerprint comparison and Rule A / Rule B arithmetic are deterministic.

Statements such as `360 / 360 PASS`, `score 100`, `average 100`, and `all fields present` MUST be reported only as evidence for the checks actually implemented. They MUST NOT produce overall Story Quality `PASS`.

Automated structural Result and human literary/semantic Result MUST be recorded separately.

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
- `SEMANTIC_TEMPLATE_COLLISION`
- `NARRATIVE_DNA_ACTIVE_STORY_EVIDENCE_MISSING`
- `NARRATIVE_DNA_LEGACY_STORY_DRIFT`
- `NARRATIVE_MECHANISM_RATIONALE_MISSING`
- `NARRATIVE_MECHANISM_SEMANTIC_SUFFICIENCY_UNVERIFIED`
- `NARRATIVE_MECHANISM_TAXONOMY_LAUNDERING`
- `LIBRARY_DIFFERENTIATION_UNVERIFIED`
- `LEVEL_ADAPTATION_IDENTITY_LOSS`
- `SPECIAL_MECHANISM_FLATTENED`
- `AUTOMATED_SCORE_NOT_LITERARY_APPROVAL`
- `BATCH_EXPANSION_BEFORE_PILOT_APPROVAL`
- `SOURCE_EVIDENCE_INSUFFICIENT`
- `UNVERIFIED_FACTUAL_CLAIM`
- `REAL_HISTORICAL_PERSON_FABRICATION`
- `GENERIC_PLACE_STORY`
- `PLACE_CAUSAL_MECHANISM_UNVERIFIED`
- `STORY_MECHANISM_INCOMPLETE`
- `LV1_CAUSAL_PROOF_FAILED`
- `FACT_FIRST_PIPELINE_VIOLATION`

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

## 17. Semantic Anti-Template Standard

### 17.1 Two-layer originality model

Phoenix evaluates Journey originality at two separate layers.

**Layer 1 — Surface Identity** includes, but is not limited to:

- character name;
- city or realm;
- profession;
- physical object;
- visual motif;
- cultural or historical subject;
- narration voice, age, time of day, and other incidental presentation choices.

**Layer 2 — Dramatic Mechanism** includes:

- opening mechanism;
- goal mechanism;
- conflict mechanism;
- choice mechanism;
- climax mechanism;
- consequence mechanism;
- protagonist transformation mechanism;
- relationship geometry;
- ending mechanism;
- cultural-anchor function;
- dramatic engine family;
- supporting structural mechanisms used by the canonical semantic fingerprint.

**Binding rule:** Different names, professions, cities, objects, wording, historical subjects, or visual motifs do NOT establish narrative originality when the underlying causal dramatic mechanism remains materially duplicated.

A Story MUST NOT be classified as distinct merely because its descriptive Narrative DNA uses different prose strings.

### 17.2 Descriptive Narrative DNA and normalized semantic fingerprint

Phoenix maintains two complementary representations:

1. **Descriptive Narrative DNA** for rich Journey-specific human review.
2. **Normalized Semantic Narrative Fingerprint** for deterministic machine gating.

The normalized fingerprint is the authoritative machine comparison source and MUST use controlled semantic identifiers rather than arbitrary prose equality. The canonical implementation is `app/lib/data/journey_semantic_fingerprint_catalog.dart`.

The normalized fingerprint MUST represent at least:

1. opening mechanism;
2. protagonist role pattern;
3. relationship geometry;
4. goal mechanism;
5. conflict mechanism;
6. choice mechanism;
7. climax mechanism;
8. consequence mechanism;
9. transformation mechanism;
10. ending mechanism;
11. cultural-anchor function;
12. artifact/object narrative function;
13. movement/spatial mechanism;
14. temporal pressure mechanism;
15. supporting-character function;
16. dramatic engine family.

Semantic identifiers MUST be reusable mechanism families. Journey-, city-, character-, landmark-, or candidate-specific identifiers are prohibited because they defeat comparison.

### 17.3 Active Story evidence binding: provenance vs semantic sufficiency

Narrative DNA and every CORE normalized mechanism MUST be traceable to the **ACTIVE canonical production Story**.

Phoenix formally distinguishes two evidence requirements.

**Evidence Provenance — deterministically enforced**

CI MAY and MUST verify, where implemented:

- the evidence record belongs to the registered Journey;
- the active Story source identifier is the approved active source;
- every cited Story span is non-empty;
- every cited Story span literally occurs in the active canonical Story;
- the evidence record names the same semantic dimension as the fingerprint registration;
- the evidence record names the same normalized mechanism family as the fingerprint registration;
- a required semantic rationale field is present and non-empty.

**Evidence Semantic Sufficiency — evidence-supported and human-auditable**

Exact Story provenance alone does **not** establish semantic correctness. Each CORE Narrative Mechanism classification MUST include sufficient active-Story evidence and a concise causal `semanticRationale` explaining why those cited events, choices, consequences, relationships, spatial functions, or transformations support the normalized mechanism family.

Founder/Agent review MUST judge whether the cited evidence plus rationale makes the classification understandable and defensible. Phoenix CI MUST NOT represent deterministic string-presence, enum-alignment, or non-empty-rationale checks as natural-language semantic proof.

Each CORE mechanism evidence record MUST identify:

- Journey ID;
- semantic dimension;
- normalized semantic family;
- active Story package or source ID;
- one or more exact active-Story source spans;
- required semantic rationale.

A single source span MAY be used where it sufficiently exposes the causal mechanism. Multiple exact source spans SHOULD be used where conflict, transformation, dramatic engine, relationship geometry, or another mechanism depends on a sequence that cannot be audited from one short sentence. Every cited span MUST independently occur in the active Story. Invented bridging prose MUST NOT be inserted into `sourceTexts` and represented as Story evidence.

Evidence MUST remain focused. Copying entire Story levels into each record merely to guarantee a string match is prohibited evidence padding.

Bare location names, protagonist biographies, incidental scenery, or isolated object mentions are not sufficient evidence for a causal Narrative Mechanism unless the dimension being evidenced is specifically that surface fact. Relationship evidence must expose the relevant relationship function or meaningful absence of a decisive actor. Cultural-anchor evidence must show how the place-specific anchor participates in conflict, interpretation, choice, consequence, or transformation. Transformation evidence must show changed understanding, behavior, responsibility, or model. Dramatic-engine evidence must show enough of the causal sequence to make the engine assignment auditable.

Legacy, abandoned, superseded, migration-only, or test-only Story prose MUST NOT satisfy active Narrative DNA evidence, even when a rationale is present. Metadata MUST conform to the active Story. The Story MUST NOT be rewritten merely to preserve stale metadata.

### 17.4 CORE collision dimensions

The deterministic CORE set is:

- opening mechanism;
- conflict mechanism;
- choice mechanism;
- climax mechanism;
- consequence mechanism;
- transformation mechanism;
- ending mechanism;
- relationship geometry;
- cultural-anchor function;
- dramatic engine family.

Incidental similarities such as young protagonists, third-person narration, one-day duration, mentor presence, heritage setting, physical-object presence, student status, or nighttime ending do not independently establish a template collision.

### 17.5 Deterministic blocking threshold

The implementation MUST use named thresholds and the following minimum-strength rules:

**Rule A — same dramatic engine:**

A candidate is a semantic template collision when it has the same `dramaticEngineFamily` as a reference approved Gold Journey **AND at least 3 additional matching CORE mechanism families**.

Implementation constant:

`semanticCollisionSameEngineAdditionalCoreThreshold = 3`

**Rule B — CORE structural reuse:**

A candidate is a semantic template collision when it has **at least 4 matching CORE mechanism families**, even when the top-level dramatic-engine labels differ.

Implementation constant:

`semanticCollisionIndependentCoreThreshold = 4`

A weighted or descriptive similarity score MAY supplement reporting but MUST NOT weaken or replace these deterministic rules without a separately approved, demonstrably stricter regression-tested standard change.

### 17.6 Difference Matrix structural output

Free-form Difference Matrix prose is not sufficient. Every candidate-vs-reference comparison MUST resolve from the canonical semantic fingerprint and report at least:

- dramatic-engine match;
- opening-mechanism match;
- conflict-mechanism match;
- choice-mechanism match;
- climax-mechanism match;
- consequence-mechanism match;
- transformation-mechanism match;
- ending-mechanism match;
- relationship-geometry match;
- cultural-anchor-function match;
- total CORE matches;
- matching secondary dimensions;
- deterministic collision result.

Different descriptive wording MUST NOT override a normalized structural match.

### 17.7 Existing approved collision debt

The semantic engine MUST audit all approved Gold-to-Gold pairs.

If an already approved Gold pair now exceeds the deterministic threshold, it MUST be reported as:

`EXISTING_SEMANTIC_COLLISION_DEBT`

Existing debt MUST NOT be hidden by category splitting, Journey-specific identifiers, allowlists, exclusions, threshold reduction, or dishonest reclassification. Infrastructure tests MAY remain green by asserting the truthful debt result. Existing debt does not authorize Story rewriting without separate Founder instruction and does not create precedent for future Gold acceptance.

### 17.8 Future Gold hard gate

For every NEW Gold Journey candidate, semantic comparison against **every approved Gold Journey** is mandatory before Gold acceptance.

If any comparison is a semantic collision, the required result is:

`TEMPLATE COLLISION - NOT GOLD READY`

The Gold acceptance gate MUST fail until the dramatic mechanism is redesigned and the collision is removed.

There is no per-Journey bypass, city bypass, candidate allowlist, Founder-name bypass, temporary semantic exception, alternate test-only registry, or prose-only override.

### 17.9 One semantic source of truth

Semantic tests, pairwise catalog audit, normalized Difference Matrix reporting, and future Gold acceptance MUST resolve from the same canonical semantic fingerprint registry. Manually synchronized parallel semantic maps are prohibited where the canonical registry can be consumed directly.

### 17.10 New mechanism-family governance

A new `NarrativeMechanismFamily` MUST NOT be introduced merely to make a candidate appear different from an existing Gold Journey.

Before extending the controlled taxonomy, the design/review record MUST state:

```text
Proposed mechanism family:
Causal function:
Why no existing mechanism family is semantically equivalent:
Nearest existing mechanism families considered:
Causal distinction from each nearest family:
Why the distinction affects collision analysis rather than surface wording:
Journey-specific naming check: PASS / FAIL
Taxonomy-laundering check: PASS / FAIL
Reviewer:
Result:
```

If an existing reusable family is materially equivalent in causal function, that existing family MUST be used. Near-synonym splitting such as renaming one responsible-refusal family into a candidate-specific or operationally reworded variant solely to evade collision is prohibited. New families MUST remain general enough to compare across cities, characters, professions, objects, and future Journeys.

This governance artifact is reviewed by Founder/Agent judgment. It does not require an LLM, embedding model, probabilistic semantic score, or network dependency in CI.

### 17.11 Agent execution order

Before final Story approval for a new Journey, the responsible Agent MUST:

1. read the current approved-Gold semantic fingerprint catalog;
2. define the candidate semantic fingerprint using the existing taxonomy where causally equivalent;
3. compare it against every approved Gold Journey;
4. bind every CORE mechanism to one or more exact active Story spans;
5. provide a concise semantic rationale for every CORE mechanism;
6. use enough focused evidence to demonstrate causal function without evidence padding;
7. reject bare landmark/name/biography evidence for causal classifications;
8. justify any genuinely new semantic family against the nearest existing families before adding it;
9. reject collisions rather than disguise them through Layer 1 changes or taxonomy laundering;
10. redesign the dramatic engine or causal structure when required;
11. update Narrative DNA only after the canonical Story is locked;
12. rerun the semantic anti-template gate after Story or fingerprint changes.

This semantic standard is deterministic and local where machine enforcement is claimed. CI MUST NOT depend on an external LLM, embeddings API, network semantic service, or external vector database to decide collision arithmetic or evidence provenance. Human/Agent review remains authoritative for semantic sufficiency.

## 18. Story Truth + Place-Causality Blocking Standard

### 18.1 Binding development sequence

For every future new Journey, every future Story remediation explicitly authorized by Founder, and every future Gold promotion, Story development MUST proceed in this order:

> **FACT FIRST**  
> → **PLACE CAUSALITY**  
> → **STORY MECHANISM**  
> → **ANTI-TEMPLATE COMPARISON**  
> → **LV1 CAUSAL PROOF**  
> → **STORY LOCK**  
> → **LV1-LV10 EXPANSION**  
> → **STORY / DISCOVERY SEPARATION**  
> → **LEARNING PACKAGE**  
> → **GOLD PROMOTION**

An Agent MUST NOT jump directly from a Journey location to drafting a complete Lv1-Lv10 Story. Full Story drafting before the pre-lock gates pass is `FACT_FIRST_PIPELINE_VIOLATION`.

This governance extension does not reopen any already approved Gold Story. Existing approved Gold Story prose, Narrative DNA, and fingerprints remain the comparison baseline unless a separate Founder task explicitly authorizes remediation.

### 18.2 Blocking Gate A — Source Truth

Authoritative place research is REQUIRED before Story architecture is locked.

Preferred source hierarchy, in order:

1. UNESCO or equivalent international heritage authority;
2. national, provincial, or municipal government;
3. official museum, heritage, monument, or site authority;
4. official cultural institution;
5. reputable academic or institutional source when required.

Tourism blogs, social-media posts, unsourced travel articles, search-result snippets, AI-generated summaries, and unreviewed secondary summaries MUST NOT become binding factual evidence.

At minimum, factual claims involving history, dates, historical development, real historical people, architecture, construction, restoration, conservation, heritage status, cultural practices, traditional crafts, spatial organization, building functions, landscape design, water systems, paths, bridges, gates, pavilions, windows, materials, inscriptions, rituals, regulations, prohibitions, named historical events, current heritage management, and factual site-specific cause/effect claims require approved source provenance when asserted as fact.

If a factual statement materially supports Goal, Conflict, Choice, Climax, Consequence, Transformation, Ending, Cultural Anchor, or the dramatic engine, its approved source provenance is mandatory.

Binding stop condition:

`SOURCE EVIDENCE INSUFFICIENT — STORY DEVELOPMENT STOPPED`

When evidence is insufficient the Agent may only:

A. remove the unsupported claim;
B. replace it with a verified factual mechanism;
C. convert the relevant action into clearly fictional contemporary character behavior when that conversion does not falsely imply historical truth; or
D. stop and report insufficient evidence.

Inventing a plausible fact is never an allowed option.

An untraceable factual premise produces:

`UNVERIFIED FACTUAL CLAIM — BLOCKED`

### 18.3 Blocking Gate B — Fact / Fiction Boundary

Phoenix may use fictional narrative. The following are permitted when compatible with the verified setting and clearly treated as fiction:

- fictional protagonist;
- fictional supporting characters;
- fictional contemporary assignment;
- fictional dialogue;
- fictional personal motivation;
- fictional interpersonal conflict;
- fictional present-day action;
- fictional object created or used by the protagonist.

Before Story lock the source-governance record MUST classify material premises as one of:

- `VERIFIED FACT`
- `FICTIONAL CHARACTER ACTION`
- `FICTIONAL DIALOGUE`
- `FICTIONAL PERSONAL MOTIVATION`
- `INTERPRETIVE STORY DEVICE`
- `UNSUPPORTED FACTUAL CLAIM`

`UNSUPPORTED FACTUAL CLAIM` is always `BLOCKED`.

Fictional actions MUST NOT be represented as documented historical events or practices. An interpretive Story device is allowed only when it does not falsely assert unsupported historical fact.

### 18.4 Real historical person protection

Phoenix MUST NOT invent consequential actions, dialogue, private thoughts, intentions, motives, or design purposes for a real historical person and present them as fact.

A sentence equivalent to `乾隆在这里决定……` requires approved evidence that supports that specific action. A statement equivalent to `the architect intentionally built this feature specifically so that…` requires approved evidence of that intention.

Observed spatial effect, present-day interpretation, and documented historical intention are three different claim types. One MUST NOT be silently converted into another.

Unsupported real-person action, intention, or dialogue is `REAL_HISTORICAL_PERSON_FABRICATION` and `UNVERIFIED FACTUAL CLAIM — BLOCKED`.

### 18.5 Blocking Gate C — Place Causality

A Phoenix Gold Story MUST NOT be `GENERIC STORY + FAMOUS PLACE SKIN`.

Before Story drafting, submit a `PLACE_CAUSAL_MECHANISM` record:

```text
Verified place property:
Authoritative source IDs:
Why this property creates the dramatic possibility:
Why the same Story would not work unchanged in a generic place:
Affected Goal / Conflict / Choice / Climax / Consequence / Transformation / Ending dimensions:
Generic Place Substitution Test: PASS / FAIL
Human semantic-sufficiency review:
Result:
```

**Generic Place Substitution Test:** ask whether the exact Goal → Conflict → Choice → Climax → Consequence chain would work substantially unchanged if the named location were replaced by a generic city park, café, museum, old street, school, or unrelated attraction.

If YES, the required stop result is:

`GENERIC-PLACE STORY — NOT GOLD READY`

The location's verified properties MUST affect at least one major causal dimension and SHOULD affect more than one. A place name or decorative reference to a pavilion, bridge, lotus, old wall, tea, river, palace, garden, carving, or other motif does not satisfy place causality by itself.

The design record MUST identify what causal element breaks when the place property is removed. CI may verify that the record and source links exist and that a declared substitution result is present; Founder/Agent review determines whether that causal claim is intellectually and creatively sufficient.

### 18.6 Blocking Gate D — Story Mechanism

Before Lv1-Lv10 drafting, define the candidate architecture separately from prose:

```text
PROTAGONIST:
RELATIONSHIP_GEOMETRY:
GOAL:
CONFLICT:
CHOICE:
CLIMAX:
CONSEQUENCE:
TRANSFORMATION:
ENDING:
CULTURAL_ANCHOR_FUNCTION:
DRAMATIC_ENGINE:
```

Missing required architecture is `STORY_MECHANISM_INCOMPLETE` and blocks Story lock.

Every Gold Story MUST have a genuinely distinct causal/dramatic structure. Changing city, name, gender, age, profession, historical period, supporting character, object, Memory anchor, scenery, dialogue, vocabulary, or descriptive wording does not establish originality when the causal machine remains materially duplicated.

### 18.7 Blocking Gate E — Semantic Anti-Template

The existing normalized semantic fingerprint architecture and Rule A / Rule B are the only machine collision system. This section creates no parallel semantic registry.

Before Story lock, compare the candidate against **every approved Gold Journey**. Source uniqueness and narrative uniqueness are independent requirements. Different historical facts do not make a repeated causal template acceptable.

Any collision returns the existing binding result:

`TEMPLATE COLLISION - NOT GOLD READY`

The response to collision is to redesign Story causality, not wording, profession, object, city, protagonist, enum name, or NarrativeMechanismFamily label.

Taxonomy laundering remains prohibited. A new mechanism family requires the review record in §17.10 and MUST be reusable beyond one Journey. A Journey-specific or near-synonym family introduced solely to evade collision is `NARRATIVE_MECHANISM_TAXONOMY_LAUNDERING` and `BLOCKED`.

**Distinctness never overrides truth.** If a distinct mechanism requires fabricated history, heritage behavior, architecture, cultural practice, rule, or real-person action, Story development MUST stop and another verified place mechanism must be found.

### 18.8 Blocking Gate F — Lv1 Causal Proof

Before Lv2-Lv10 expansion, Lv1 MUST already contain the essential causal skeleton:

- protagonist;
- concrete goal;
- conflict;
- enacted choice;
- climax or decisive event;
- caused consequence.

A Lv1 that provides only person + place + atmosphere fails even if the planned Lv10 is structurally complete.

Failure result:

`LV1 CAUSAL PROOF FAILED — DO NOT EXPAND`

Only after Source Truth, Fact/Fiction Boundary, Place Causality, Story Mechanism, Anti-Template, and Lv1 Causal Proof all pass may the architecture be recorded as `STORY LOCKED` and expanded across Lv1-Lv10.

### 18.9 Story lock and Lv1-Lv10 expansion

After `STORY LOCKED`, Lv2-Lv10 deepen the same causal Story. They may deepen action, relationship, environment, emotion, material detail, causal context, and language complexity. They MUST NOT silently replace the dramatic engine.

Lv10 MUST remain Story. It MUST NOT become an academic essay, semantic audit, validation explanation, anti-template defense, architecture lecture, or historical textbook. Structural distinction should be experienced through action.

Story / Discovery separation in §6 remains binding: Story owns lived causality; Discovery owns verified knowledge that adds understanding without retelling Story.

### 18.10 Machine-verifiable contract vs human authority

Phoenix explicitly separates **MACHINE-VERIFIABLE CONTRACT** from **HUMAN SEMANTIC SUFFICIENCY REVIEW**.

CI can deterministically verify, where implemented:

- source records exist;
- source authority classification is present;
- required fact/fiction claim classification is present;
- a verified factual claim references approved evidence;
- unsupported factual claims are blocked;
- place-causality record fields exist;
- declared generic-place substitution outcome exists;
- Story mechanism fields exist;
- normalized fingerprint completeness;
- Rule A / Rule B arithmetic against the canonical Gold catalog;
- mechanism-family governance record completeness;
- Lv1 causal-proof fields exist;
- pipeline ordering flags and stop states.

CI cannot independently prove:

- that a factual interpretation is intellectually honest beyond its recorded evidence;
- that a Story truly feels native to the place;
- that two Stories are creatively too similar despite passing deterministic thresholds;
- that a cultural interpretation is nuanced enough;
- literary quality;
- emotional effectiveness;
- whether prose feels artificial.

Founder / human review remains authoritative for those judgments. Phoenix MUST NOT describe deterministic record checks as machine proof of historical truth, cultural truth, place-native literary quality, or natural-language semantic entailment.

### 18.11 Governance scope

This Story Truth + Place-Causality gate applies to:

1. future new Journeys;
2. future Story remediations only when separately authorized;
3. future Gold promotions.

It does **not** retroactively reopen or rewrite the eight approved Gold Stories on the current baseline. It does not authorize Suzhou continuation, background generation, visual changes, Passport/map/location-hierarchy changes, or any unrelated runtime work.
