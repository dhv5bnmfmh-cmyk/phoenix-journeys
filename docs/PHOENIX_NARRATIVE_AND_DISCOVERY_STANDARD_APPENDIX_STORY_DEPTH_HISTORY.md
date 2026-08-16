# Phoenix Narrative and Discovery Standard — Story Depth + Historical Story Universe Appendix

**Status:** BINDING CANONICAL APPENDIX  
**Parent authority:** [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) §§17–20  
**Scope:** Story Depth Architecture, Historical Truth Architecture, Historical Story Universe, and Place Story Universe Experience semantics  

This appendix is an inseparable supporting extension of the existing Phoenix Narrative and Discovery Standard. It is **not** a parallel narrative standard and MUST NOT replace, weaken, or reinterpret the parent standard. When wording conflicts, the stricter requirement and the parent standard control.

This appendix is governance only. It does not authorize learner-visible Journey content, runtime Story rotation, persistence changes, progress UI, data-model migration, a second same-Place Story, or any new Journey implementation.

## A. Historical truth is the highest narrative constraint

Phoenix may use literary storytelling. Phoenix MUST NOT fabricate historical truth.

Binding principles:

- `HISTORICAL TRUTH OVERRIDES NARRATIVE CONVENIENCE`.
- `NARRATIVE COMPLETENESS NEVER OVERRIDES HISTORICAL TRUTH`.
- `A BEAUTIFUL FALSE STORY IS A PHOENIX FAILURE`.
- `NO RELIABLE SOURCE → NO VERIFIED FACT CLAIM`.
- `UNKNOWN REMAINS UNKNOWN`.
- `CONTESTED REMAINS CONTESTED`.
- `UNCERTAINTY IS PART OF HISTORICAL TRUTH`.

An Agent MUST NOT invent a historical fact because a Story needs a transition, motivation, relationship, causal link, dialogue beat, missing chronology, missing artifact owner, or satisfying ending.

### A.1 Claim-level provenance

Every material historical claim that supports Goal, Conflict, Choice, Cost, Climax, Consequence, Transformation, Ending, Cultural Anchor, Primary Depth, or the dramatic engine MUST be traceable to approved evidence.

Required production record:

```text
CLAIM:
TRUTH STATUS:
SOURCE ID / LOCATION:
SOURCE TYPE:
SOURCE CONFIDENCE:
STORY USE:
INTERPRETATION BOUNDARY:
RESULT:
```

Learner-facing prose does not need citation markers, but the production claim ledger MUST exist before Story Lock where historical claims materially drive the Story.

The parent §18.2 source hierarchy remains binding. This appendix adds no weaker source tier.

### A.2 Source confidence

Historical source confidence is recorded as:

- `HIGH` — strong primary, official, institutional, or multiple mutually supporting authoritative sources;
- `MEDIUM` — credible evidence exists but attribution, dating, interpretation, or detail retains meaningful uncertainty;
- `CONTESTED` — reputable scholarly or institutional disagreement exists;
- `LEGENDARY` — folklore, legend, literary tradition, oral tradition, or cultural memory rather than verified history;
- `UNKNOWN` — available evidence is insufficient.

A lower-confidence claim MUST NOT be rewritten into higher certainty for cleaner prose. Translation MUST preserve the same certainty strength.

### A.3 Fact / interpretation / fiction separation

The parent §18.3 claim classes remain binding and are extended, where applicable, by:

- `VERIFIED HISTORICAL ACTION`;
- `VERIFIED HISTORICAL QUOTE`;
- `VERIFIED CULTURAL PRACTICE`;
- `CONTESTED INTERPRETATION`;
- `LEGEND / FOLKLORE`;
- `UNKNOWN`.

`UNSUPPORTED FACTUAL CLAIM` remains blocked.

The ledger MUST distinguish verified world claims from fictional human material. Canonical fictional categories include identity, backstory, action, relationship, dialogue, personal motivation, personal choice, personal cost, and personal consequence. These categories do not require documentary proof for a clearly fictional ordinary character; they require plausibility, period compatibility, and non-contradiction with verified world conditions.

`FICTIONAL CHARACTER ACTION != VERIFIED HISTORICAL ACTION` and `FICTIONAL CHARACTER ACTION != UNSUPPORTED FACTUAL CLAIM`.

Interpretive narration MUST NOT silently become documentary fact. Fiction MUST NOT imply that an invented event, relationship, motive, quote, or causal explanation is documented history.

### A.4 Real historical person protection

The parent §18.4 protection remains binding and receives this stricter production test.

For a real historical person, separately record where applicable:

```text
VERIFIED IDENTITY:
VERIFIED ROLE:
VERIFIED ACTION:
VERIFIED EVENT:
VERIFIED RELATIONSHIP:
VERIFIED QUOTE:
VERIFIED PLACE CONNECTION:
INTERPRETIVE NARRATION:
```

Unless directly supported, Phoenix MUST NOT invent and present as fact:

- consequential actions;
- private motives;
- inner thoughts;
- personal beliefs;
- decisive dialogue;
- relationships;
- design intentions;
- secret plans;
- emotional reactions.

If a real historical person cannot remain protagonist without fabricated interior life or unsupported action, choose another truthful architecture. Historical celebrity value never overrides truth.

### A.5 Fictional character in verified historical setting

A fictional ordinary character MAY have a complete invented literary life in a verified historical setting. Name, age, family, occupation, relationship, personal history, home, possession, memory, dialogue, Goal, desire, fear, conflict, mistake, choice, personal cost, emotion, transformation, and ending action may be fictional. Documentary evidence that this exact person existed or performed the private action is not required.

The fictional character remains valid only when:

- the character is clearly classified as fictional in production governance;
- the historical setting and material premises remain source-grounded;
- the fictional character is not made the false cause of a real major event;
- an invented relationship with a real historical person does not masquerade as documentation;
- fictional dialogue does not convert uncertain history into fact.

The character's actions must be historically, socially, and physically plausible. They MUST NOT require invented architecture, technology, institutional duty, access restriction, punishment, law, official order, religious rule, cultural custom, or other world claim. A fictional ordinary person may respond privately to a verified world condition; fiction may not silently rewrite that condition.

Review examples:

- **VALID:** Yungang construction under Northern Wei imperial patronage is verified; a fictional ordinary worker argues with a fictional family member over a personal decision created by that changing environment, without inventing an institutional rule.
- **INVALID unless sourced:** every Yungang artisan was legally required to surrender family property before joining construction.
- **VALID:** a fictional resident feels conflicted about a verified change in the city and makes a fictional personal choice.
- **HIGH-RISK / BLOCKED unless directly supported:** a named emperor privately tells a fictional artisan why he commissioned a cave; this invents a real ruler's dialogue and motive.

### A.6 Artifact provenance and Object Biography

Binding principles:

- `ARTIFACT != FACT CONTAINER`.
- `UNKNOWN PROVENANCE != INVENTED PROVENANCE`.

An artifact may support an `OBJECT BIOGRAPHY` through verified stages such as creation, maker/workshop where known, use, ownership where known, movement, transfer, loss, burial, damage, discovery, excavation, collection, conservation, restoration, display, or reinterpretation.

Every asserted stage MUST be evidence-supported. Missing ownership, movement, discovery, dating, or restoration links remain missing.

An Object Biography is Story only when the object's material life, use, movement, damage, preservation, or changing meaning creates human causal pressure. A chronology of museum facts is Discovery, not a Gold Story engine.

### A.7 Temporal consistency

Every Historical Story candidate MUST perform a `TEMPORAL CONSISTENCY TEST` before Story Lock where applicable:

```text
Historical person exists in this period:
Artifact exists in this period:
Site/building phase exists in this period:
Institution/title/office exists in this period:
Technology exists in this period:
Material/practice is supported for this period:
Transport/route is supported for this period:
Event ordering is correct:
Result:
```

Anachronism introduced for narrative convenience is blocked.

### A.8 Multilingual truth parity

Chinese, Pinyin support, Vietnamese, and English MUST preserve the same:

- factual certainty;
- uncertainty;
- attribution;
- legendary status;
- contested status;
- causality;
- historical relationship strength.

A cautious source claim MUST NOT become certain in translation.

### A.9 Additional minimal blocking codes

The following additional blocking codes are binding and supplement, rather than replace, §14:

- `ARTIFACT_PROVENANCE_FABRICATED`;
- `TEMPORAL_ANACHRONISM`;
- `PRIMARY_DEPTH_DECORATIVE`.

Existing `SOURCE_EVIDENCE_INSUFFICIENT`, `UNVERIFIED_FACTUAL_CLAIM`, `REAL_HISTORICAL_PERSON_FABRICATION`, `TRUTH_MODE_UNDECLARED`, and `FOLKLORE_PRESENTED_AS_VERIFIED_HISTORY` remain authoritative for their existing scopes. Do not create duplicate near-synonym blockers.

## B. Phoenix Story Depth Architecture

### B.1 Story depth principle

`STORY DEPTH != MORE FACTS`  
`STORY DEPTH != LONGER STORY`  
`STORY DEPTH != MORE CULTURAL TERMS`  
`STORY DEPTH != MORE LITERARY TECHNIQUES`

Story depth exists when a real place, cultural, material, social, temporal, ecological, sensory, or human force changes what a character can do, cannot do, must do, chooses, loses, protects, understands, or becomes.

`DEPTH MUST CHANGE ACTION`.

### B.2 Sixteen-dimensional possibility space

Phoenix recognizes the following Story Depth possibility space:

1. `PLACE / SPATIAL CAUSALITY`;
2. `MATERIAL CAUSALITY`;
3. `PRACTICE / RITUAL CAUSALITY`;
4. `SOCIAL CAUSALITY`;
5. `INSTITUTIONAL / POWER CAUSALITY`;
6. `ECONOMIC / LIVELIHOOD CAUSALITY`;
7. `ECOLOGICAL CAUSALITY`;
8. `TEMPORAL TRACE`;
9. `INTERGENERATIONAL TRANSMISSION`;
10. `COLLECTIVE MEMORY`;
11. `CULTURAL VALUE TENSION`;
12. `SENSORY CAUSALITY`;
13. `LOCAL VOICE`;
14. `AMBIGUITY / UNCERTAINTY`;
15. `ABSENCE / LOSS`;
16. `NARRATIVE SUBTEXT / RESTRAINT`.

These are a possibility space, **not sixteen mandatory boxes**.

### B.3 Story Depth Profile

Every new Gold Story and every Founder-authorized major Story remediation MUST declare before Story Lock:

```text
PRIMARY_DEPTH_MECHANISM:
SECONDARY_DEPTH_MECHANISMS: normally 1–3
SUPPORTING_DEPTH: optional
INTENTIONALLY_UNUSED_DEPTH: meaningful possibilities intentionally preserved
```

The `PRIMARY_DEPTH_MECHANISM` is exactly one dominant depth entrance. Secondary depth supports it. No Story is required to consume the entire place.

`INTENTIONALLY_UNUSED_DEPTH` is not a deficiency. It protects future independent Story space and prevents encyclopedia writing.

### B.4 Depth Action Test

Every Primary Depth and every Secondary Depth used as Gold evidence MUST pass:

```text
DEPTH MECHANISM:
SOURCE / PLACE BASIS:
CHARACTER ENCOUNTER:
ACTION CAUSED:
CONSTRAINT / PRESSURE:
CHOICE EFFECT:
COST EFFECT:
CONSEQUENCE EFFECT:
REMOVAL TEST:
RESULT:
```

If removing the depth leaves the Story's Goal, Conflict, Choice, Cost, and Consequence substantially unchanged, classify it `DEPTH_DECORATIVE`.

A decorative mechanism MUST NOT serve as Primary Depth evidence. `PRIMARY_DEPTH_DECORATIVE` blocks Gold.

The Depth Action Test does not replace the Cultural Fact Action Test or Place Causality. It proves that the chosen depth mechanism shapes the human causal machine.

### B.5 Depth-specific constraints

- `MATERIAL != PROP`: material must constrain physical, cultural, professional, ethical, or preservation action rather than merely appear.
- `SENSORY DETAIL != DECORATION`: sight, sound, touch, distance, light, temperature, echo, smell, weight, or obstruction counts as depth only when it changes perception or action.
- `HISTORY IS NOT A BACKDROP. HISTORY IS A CAUSAL FORCE.` History must change what people know, can know, are allowed to do, can make, can preserve, risk, inherit, or lose.
- Practice / ritual counts as causal depth only when sequence, permission, timing, responsibility, relationship, risk, or outcome changes.
- Social, institutional, economic, and ecological depth MUST be evidence-supported where factual claims are involved and MUST NOT be inserted merely to increase complexity.
- `TEMPORAL TRACE` enters through surviving evidence, wear, damage, repair, ruins, archives, routes, practices, material residue, institutional continuity, or memory, not only narrator exposition.
- Intergenerational transmission may include preservation, change, refusal, forgetting, misremembering, relearning, or partial survival. Phoenix MUST NOT romanticize transmission automatically.
- Multiple legitimate cultural values MAY remain in tension. Do not force a false binary or manufacture controversy.
- `ABSENCE / LOSS` may itself be truthful Story pressure. Missing evidence MUST NOT be filled by invention.

### B.6 Local Voice and literary restraint

`LOCAL VOICE` may reflect age, relationship, profession, social role, and lived language context without requiring dialect or stereotype.

`MEANING SHOULD SURVIVE WITHOUT EXPLANATION`.

Prefer action, gesture, silence, physical distance, object handling, changed behavior, repeated-but-altered action, and spatial relationship over author explanation or moral summary when the Story supports such restraint.

Advanced literary possibilities include motif, symbolic recurrence, structural echo, irony, silence, narrative distance, nonlinear time, parallel imagery, unreliable perception, repeated objects with changed meaning, and withheld dialogue.

`LITERARY POSSIBILITY != MANDATORY TECHNIQUE`.

No Gold Story needs a symbol, motif, ironic ending, or nonlinear narration merely to satisfy a checklist.

### B.7 Story Signature

Every locked Gold Story SHOULD be able to state:

```text
STORY SIGNATURE = Primary Depth × Human Need / Relationship × Place / Historical Mechanism
```

The Story Signature is a concise identity record, not a marketing tagline and not a substitute for semantic anti-template comparison.

### B.8 Gold defect, depth opportunity, and future Story opportunity

Phoenix distinguishes:

- `GOLD DEFECT` — blocks Gold because truth, causality, humanity, place mechanism, cultural action, distinctness, Primary Depth, or another binding requirement fails;
- `GOLD DEPTH OPPORTUNITY` — Story already satisfies Gold but could someday deepen;
- `FUTURE PLACE STORY OPPORTUNITY` — a meaningful human/cultural/material/social/temporal direction belongs to a future independent same-Place Story rather than the current Story.

Binding principle:

`DEPTH OPPORTUNITY != GOLD DEFECT`.

`STORY IMPROVEMENT MAY BE INFINITE. GOLD COMPLETION IS NOT.`

A Gold Story may freeze when all binding Gold requirements pass and no blocking defect remains. Further possibilities become Depth Opportunities or Future Place Story Opportunities rather than automatic reopen requests.

## C. Historical Story Universe

### C.1 Story Universe coordinates

Phoenix MUST NOT solve Story diversity by creating dozens of rigid templates. A Story may instead be described through coordinates:

```text
SUBJECT
× TIME LAYER
× HUMAN LENS
× HISTORICAL SCALE
× TRUTH MODE
× CULTURAL SLICE
× PRIMARY DEPTH
× HUMAN NEED
× NARRATIVE ENGINE
```

These coordinates describe identity and comparison. They are not quotas and do not automatically generate Story ideas.

### C.2 Subject axis

Possible subjects include:

- `HUMAN`;
- `ARTIFACT`;
- `CRAFT`;
- `PLACE`;
- `COMMUNITY / INSTITUTION`;
- `ECOLOGY`;
- `IDEA / PRACTICE`.

### C.3 Human lens

Possible human lenses include, where truthful and useful:

- named historical person;
- ordinary historical person;
- maker / craftsperson;
- user;
- owner;
- witness;
- resident;
- family member;
- child;
- elder;
- scholar;
- conservator;
- researcher;
- staff;
- visitor;
- community.

Famous people have no automatic priority over truthful ordinary perspectives.

### C.4 Place Time Universe

A Place MAY contain verified time layers such as:

- `ORIGIN`;
- `FORMATION`;
- `FLOURISHING`;
- `TRANSFORMATION`;
- `DISRUPTION`;
- `LOSS`;
- `REDISCOVERY`;
- `RESTORATION / CONSERVATION`;
- `CONTEMPORARY LIFE`;
- `FUTURE RESPONSIBILITY`.

Not every Place has every layer. Time layers MUST come from verified history, not a generic heritage template.

### C.5 Historical scale

Possible scales include:

- `MOMENT`;
- `DAY / EVENT`;
- `LIFETIME`;
- `GENERATION`;
- `OBJECT LIFE`;
- `INSTITUTION LIFE`;
- `PLACE LIFE`;
- `REGIONAL NETWORK`;
- `CIVILIZATIONAL NETWORK`.

Longer time span does not imply deeper Story.

### C.6 Continuity × Change Test

For Stories spanning meaningful time, record where applicable:

```text
WHAT SURVIVED:
WHAT CHANGED:
WHY:
WHO / WHAT CAUSED THE CHANGE:
WHO EXPERIENCED THE COST:
WHAT MEANING CHANGED:
WHAT REMAINS:
SOURCE BASIS:
RESULT:
```

### C.7 Multiple perspectives

`ONE EVENT MAY CONTAIN MULTIPLE HUMAN TRUTHS` when evidence supports different lived perspectives.

`MULTIPLE PERSPECTIVES != MANUFACTURED CONTROVERSY`.

Do not invent symmetrical opposing viewpoints merely to make the Story sophisticated.

### C.8 Place Network Story

A `PLACE NETWORK STORY` MAY follow truthful cultural movement through trade, migration, pilgrimage, religious transmission, technology, craft, material sourcing, rivers, sea routes, roads, language contact, political networks, or artistic exchange.

Every asserted network connection remains subject to claim-level provenance.

### C.9 Historical Story families

Descriptive Story families may include:

- `CONTEMPORARY HUMAN STORY`;
- `HISTORICAL HUMAN STORY`;
- `ARTIFACT / OBJECT LIFE STORY`;
- `CRAFT / MAKER STORY`;
- `PLACE THROUGH TIME STORY`;
- `INSTITUTION / COMMUNITY STORY`;
- `MEMORY / LOSS / RECOVERY STORY`;
- `CONTEMPORARY ENCOUNTER WITH HISTORY`;
- `PLACE NETWORK STORY`.

These are descriptive families, not templates. `HISTORICAL DEPTH != HISTORICAL EXPOSITION`.

History should enter through human action, object life, or place change rather than a list of dates.

## D. Place Story Universe Experience Model

### D.1 Canonical future hierarchy

The parent §20 Place Story Universe is extended conceptually as:

`PLACE → PLACE STORY UNIVERSE → STORY EXPERIENCE → JOURNEY RUN`.

- `PLACE` is the stable geographic/cultural identity.
- `PLACE STORY UNIVERSE` is the set of Founder-approved Gold Story Experiences belonging to that Place.
- `STORY EXPERIENCE` is one complete Gold Story identity and learning package.
- `JOURNEY RUN` is one user's active run through one selected Story Experience.

This is a content/experience model only. It does not change the current runtime data model.

### D.2 Complete Gold Story Experience

Every future Story Experience remains a complete Gold package:

`Story → Lv1–Lv10 → Vocabulary → Discovery → Reading Support → Challenge → Memory → Completion`.

It additionally carries its Truth governance, Story Depth Profile, and Story Signature.

Phoenix MUST NOT create experience diversity through one Gold Story plus runtime-generated mini stories.

`EXPERIENCE DIVERSITY COMES FROM MULTIPLE APPROVED GOLD STORIES, NOT RUNTIME-GENERATED RANDOMNESS`.

### D.3 Same Place, new human experience

Binding principles:

- `SAME PLACE, NEW HUMAN EXPERIENCE`;
- `SAME PLACE, DIFFERENT TIME, DIFFERENT LIFE, DIFFERENT HISTORY`;
- `CULTURAL COVERAGE IS ACCUMULATIVE ACROSS STORIES`.

A later same-Place Story SHOULD create a materially new combination of human life and cultural understanding rather than simply changing names, profession, era, artifact, or wording.

In addition to §20.3, same-Place comparison SHOULD include:

```text
SUBJECT
TIME LAYER
HUMAN LENS
HISTORICAL SCALE
TRUTH MODE
CULTURAL SLICE
PRIMARY DEPTH
SECONDARY DEPTH
HUMAN NEED
SOCIAL POSITION
MATERIAL / PRACTICE
VALUE TENSION
MEMORY TYPE
EMOTIONAL TEXTURE
STORY SIGNATURE
INCREMENTAL HUMAN VALUE
INCREMENTAL CULTURAL VALUE
```

`ONE STORY SHOULD NOT EXHAUST THE PLACE` remains binding. Unused valid cultural worlds may remain for future Stories.

### D.4 Future Story Experience identity

Future product architecture MAY distinguish a stable `placeId` from an independent `storyExperienceId`. This appendix defines only the semantic need for identity separation. It does not authorize a schema migration.

### D.5 Future selection semantics

When a future Place has multiple approved Gold Story Experiences, the target selection principles are:

- `UNSEEN FIRST`;
- `DIFFERENT PER NEW RUN`;
- `STABLE WITHIN THE RUN`.

Conceptually:

`NEW JOURNEY RUN → SELECT STORY EXPERIENCE → LOCK STORY EXPERIENCE FOR ENTIRE RUN`.

Pure random selection is not the preferred primary strategy.

Opening a screen, navigating, reopening the app, resuming, or continuing language levels is not automatically a new Journey Run and MUST NOT silently replace the selected Story Experience.

These are future semantics only. No runtime implementation is authorized by this appendix.

### D.6 Level stability

Story Experience selection sits above language Level.

Within one Story Experience, Lv1–Lv10 remain adaptations of the same Story Spine. Phoenix MUST NOT select Story A at Lv1, Story B at Lv5, and Story C at Lv10 inside one run.

### D.7 Future progress semantics

Future product design MAY distinguish:

- `PLACE PROGRESS`;
- `STORY EXPERIENCE PROGRESS`.

A Place may eventually track Story Experiences as discovered, in progress, completed, or undiscovered. Place-level Stamp identity may remain separate from Story Experience progress.

No UI, persistence, Stamp, Passport, or progress implementation is authorized here.

## E. Design selection, freeze, and Round 2

### E.1 Future Place Story opportunities

A Story design MAY record `FUTURE_PLACE_STORY_OPPORTUNITIES` for meaningful unused time layers, subjects, artifacts, practices, communities, historical people, conservation questions, ecology, family memory, institutional responsibility, or network history.

This record is planning only and never authorizes implementation.

### E.2 No checklist inflation

Phoenix MUST NOT convert Story Depth, Story Universe coordinates, historical families, time layers, or human lenses into mechanical category counts.

No Place needs one Story per family, one Story per era, or all sixteen depth dimensions.

### E.3 Story Depth Round 2

After several real Founder-reviewed Journeys use this Round 1 architecture, Phoenix SHOULD perform `PHOENIX STORY DEPTH MODEL · ROUND 2` and audit:

- which dimensions genuinely improved Story quality;
- which overlap;
- which are too theoretical;
- which should become stronger MUST requirements;
- which should remain optional;
- which should be removed or merged;
- which missing dimensions real Story work reveals.

Round 2 MUST be evidence-led. New ideas are not automatically canonical.

## F. Governance and implementation boundary

For standards-only work using this appendix:

```text
AUTHORIZED_JOURNEY_SET = EMPTY
JOURNEY_CONTENT_DELTA = NONE
RUNTIME_IMPLEMENTED = NO
MULTI_STORY_SELECTION_IMPLEMENTED = NO
DATA_MODEL_CHANGED = NO
```

For future Journey work, this appendix operates together with the parent standard's Source Truth, Place Causality, Story × Culture × Level, Semantic Anti-Template, Same-Place Anti-Template, Journey Scope Isolation, and exact-head Founder approval rules.

A standards change, green CI, or this appendix alone MUST NOT start a new Journey, reopen an approved Story, or authorize runtime multi-Story behavior.
