# Phoenix New Journey Acceptance Matrix

Use with [Phoenix New Journey Creation Standard](../PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md), [Phoenix Journey System Standard](../PHOENIX_JOURNEY_SYSTEM_STANDARD.md), [Phoenix Narrative and Discovery Standard](../PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), and [PHOENIX AI BACKGROUND PRODUCTION STANDARD](../PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md).

**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## Journey identity

```text
Repository:
Candidate Branch:
Candidate Commit:
Candidate Tree:
Parent Commit:
Journey ID:
Story ID:
Journey Type:
City / Realm:
Current Phase:
Preview Link:
Owner:
Reviewer:
Expansion Layer: LAYER 1 / LAYER 2 / LAYER 3
Parent Province-Level Region:
Parent City:
Parent Place:
Existing Place Story Inventory:
Candidate Story Universe Slot:
Truth Mode:
Incremental Cultural Value:
Incremental Human Value:
Same-Place Differentiation Result:
Whole-Library Differentiation Result:
Founder Strategic Authorization:
```

## Allowed values

- Requirement: `REQUIRED` / `CONDITIONALLY_REQUIRED` / `OPTIONAL`
- Result: `PASS` / `REQUIRES_REVISION` / `REGRESSION` / `BLOCKED` / `NOT_APPLICABLE`
- Evidence Level: `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`
- Founder Approval: `APPROVED` / `REJECTED` / `PENDING` / `NOT_REQUIRED`
- Background Gate State: `PASS` / `FAIL` / `PENDING` / `BLOCKED`

Legacy records map `MANDATORY` to `REQUIRED` and `CONDITIONAL` to `CONDITIONALLY_REQUIRED`. New records MUST use the canonical terms above.

Every `REQUIRED` item and every applicable `CONDITIONALLY_REQUIRED` item MUST be `PASS` with `VERIFIED` evidence before Completed. `NOT_APPLICABLE` requires an applicability reason and evidence. Any regression blocks Ready, merge, expansion, and the next phase.

For background-production rows, `Background Gate State` is a subordinate visual-production gate. `PASS` means the item is verified and eligible to support the canonical acceptance Result. `FAIL` means the candidate must be regenerated, corrected, or rejected. `PENDING` means required evidence or human/Founder review is incomplete. `BLOCKED` means no further production or runtime integration is allowed until the blocking condition is resolved. A background row cannot produce canonical `PASS` unless its Background Gate State is `PASS` and Evidence Level is `VERIFIED`.

## Acceptance table

| ID | Acceptance item | Requirement | Expected evidence | Actual evidence | Result | Evidence Level | Issue / Required action | Owner | Founder Approval |
|---|---|---|---|---|---|---|---|---|---|
| NJ-001 | Proposal uniqueness | REQUIRED | Existing-catalog comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-002 | Story uniqueness | REQUIRED | Independent opening, structure, climax, consequence, ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-003 | Cultural authenticity | REQUIRED | Reviewed cultural anchor and sources |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-004 | Protagonist independence | REQUIRED | Independent protagonist with agency and evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-005 | Relationship | REQUIRED | Relationship identity, narrative function, influence on the Journey, and exact evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-006 | Goal | REQUIRED | Protagonist goal, why it matters, relationship to the conflict, and exact evidence path |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-007 | Conflict | REQUIRED | Concrete obstacle or dilemma connected to the goal |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-008 | Choice | REQUIRED | Meaningful decision |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-009 | Consequence | REQUIRED | Result caused by action or choice |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-010 | Emotional arc | REQUIRED | Emotional movement from opening to ending |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-011 | Learning value | REQUIRED | Defined outcomes served by each stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-012 | Vocabulary | REQUIRED | Contextual words and language support |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-013 | ReadingAnnotation | CONDITIONALLY_REQUIRED | When Story, Discovery, or other explorer-readable learning text exists: text, pronunciation, segmentation, and translation alignment. Otherwise: `NOT_APPLICABLE` reason and evidence that no applicable reading text exists. |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-014 | Discovery | REQUIRED | Cultural/context learning distinct from Story |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-015 | Challenge | REQUIRED | Valid task, answer, and feedback |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-016 | Reflection | REQUIRED | Interpretation or emotional prompt |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-017 | Writing | REQUIRED | Meaningful learner production |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-018 | Memory | REQUIRED | Journey-specific recall anchor |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-019 | Completion | REQUIRED | Completion, save, next action, replay |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-020 | Reward | REQUIRED | Correct reward, unlock, and persistence |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-021 | Stamp | CONDITIONALLY_REQUIRED | Required when completion, reward, Passport, collection, or progress design includes Stamp. Otherwise: explicit product design basis, evidence, and `NOT_APPLICABLE`. |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-022 | Multilingual alignment | REQUIRED | Meaning and learning intent aligned in all supported languages |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-023 | Narration | CONDITIONALLY_REQUIRED | Correct language, controls, sync, interruption, fallback when narration exists; otherwise evidence-backed `NOT_APPLICABLE` |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-024 | Visual concept | REQUIRED | Concept tied to story and PR #137 minimum quality |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-025 | Visual differentiation | REQUIRED | Independent composition, environment, lighting, cultural detail |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-026 | Mobile crop | REQUIRED | Target-phone focal point, readable region, safe area |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-027 | Visual pilot limit | REQUIRED | One Journey, one to three samples, one isolated Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-028 | Routing | REQUIRED | Exact route, component, Journey ID, Story ID, stage |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-029 | Persistence | REQUIRED | Progress, resume, completion, reward, migration |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-030 | Loading | REQUIRED | Correct asynchronous loading states |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-031 | Error | REQUIRED | Safe error, preserved state, recovery |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-032 | Fallback | REQUIRED | No wrong Journey, language, image, entitlement, or runtime placeholder |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-033 | Accessibility | REQUIRED | Semantics, focus, scaling, contrast, reduced motion, touch targets |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-034 | Performance | REQUIRED | Reproducible no-regression comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-035 | Rights | CONDITIONALLY_REQUIRED | Approved source, license, permission, or creation evidence for protected or sourced material; otherwise reasoned `NOT_APPLICABLE` |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-036 | Stable comparison | REQUIRED | Complete `STABLE_BASELINE_COMPARISON`, including Tree, Parent, Routes, Journey IDs, Persistence, Access/Entitlement, and Evidence Levels |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-037 | Founder mobile approval | REQUIRED | Explicit approval tied to candidate Commit or Preview |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-038 | Single-pilot rule | REQUIRED | No second Journey entered implementation |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-039 | Story Function Contract | REQUIRED | Exact one-sentence Story Function, unique learner value, inputs, outputs, path, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-040 | Discovery Function Contract | REQUIRED | Exact one-sentence Discovery Function, unique learner value, inputs, outputs, path, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-041 | Story / Discovery Functional Separation | REQUIRED | Story-only and Discovery-only information, intentional overlap, justification, human review, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-042 | Narrative Engine Independence | REQUIRED | Declared engine, causal operation, closest catalog engines, substitution test, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-043 | Opening Independence | REQUIRED | Opening type, exact evidence, catalog pattern comparison, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-044 | Relationship Causality | REQUIRED | Parties, opening state, causal function, affected Goal/Conflict/Choice/Consequence/Arc/Ending, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-045 | Enacted Choice | REQUIRED | Exact action or commitment evidence, changed state, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-046 | Caused Consequence | REQUIRED | Exact causal link from Choice to visible Consequence, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-047 | Climax and Changed Ending State | REQUIRED | Decisive moment, before/after state, non-summary ending, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-048 | Cultural Anchor in Action | REQUIRED | Approved source, effect on action/stakes, non-interchangeability, Result, Evidence Level, issue/action, and owner |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-049 | Catalog-Level Differentiation Matrix | REQUIRED | Complete current-catalog matrix, risks, decisions, exact evidence, Result, Evidence Level, issue/action, owner, and Founder state |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-050 | Level-Adaptation Narrative Invariants | REQUIRED | Phoenix Lv.1–Lv.10 matrix preserving identity, causality, event order, anchor, ending, memory, and special mechanism with Result/Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-051 | Automated Literary Approval Limitation | REQUIRED | Exact automated scope, excluded literary judgments, separate human review, declaration `Automated score used as literary approval: NO`, Result/Evidence Level |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-052 | Repair / Creation Pilot Batch Gate | REQUIRED | Work type, batch size, prior pilot Commit and Founder decision, next-phase authorization, Result, Evidence Level, issue/action, owner, Founder state |  | BLOCKED | UNVERIFIED |  |  | PENDING |
| NJ-053 | Source Truth Gate | REQUIRED | Authoritative source inventory plus verified factual premises; material Story facts trace to approved source IDs |  | BLOCKED | UNVERIFIED | `SOURCE EVIDENCE INSUFFICIENT — STORY DEVELOPMENT STOPPED` when evidence is insufficient |  | NOT_REQUIRED |
| NJ-054 | Fact / Fiction Classification | REQUIRED | Every material premise classified as VERIFIED FACT / FICTIONAL CHARACTER ACTION / FICTIONAL DIALOGUE / FICTIONAL PERSONAL MOTIVATION / INTERPRETIVE STORY DEVICE / UNSUPPORTED FACTUAL CLAIM |  | BLOCKED | UNVERIFIED | `UNVERIFIED FACTUAL CLAIM — BLOCKED` for unsupported factual claims |  | NOT_REQUIRED |
| NJ-055 | Real Historical Person Protection | CONDITIONALLY_REQUIRED | Where a real historical person appears: exact source support for factual actions/intentions/dialogue; explicit separation from fictional/interpretive material |  | BLOCKED | UNVERIFIED | No invented private thought, intention, consequential action, or dialogue presented as fact |  | NOT_REQUIRED |
| NJ-056 | Place Causal Mechanism | REQUIRED | Verified place property, approved source IDs, causal mechanism rationale, affected Story dimensions |  | BLOCKED | UNVERIFIED | Place name/decorative motif alone does not pass |  | NOT_REQUIRED |
| NJ-057 | Generic Place Substitution Test | REQUIRED | Human-auditable answer to whether Goal→Conflict→Choice→Climax→Consequence survives generic-place replacement |  | BLOCKED | UNVERIFIED | `GENERIC-PLACE STORY — NOT GOLD READY` when substantially interchangeable |  | NOT_REQUIRED |
| NJ-058 | Pre-Prose Story Mechanism | REQUIRED | Protagonist, relationship geometry, Goal, Conflict, Choice, Climax, Consequence, Transformation, Ending, cultural-anchor function, dramatic engine |  | BLOCKED | UNVERIFIED | Full Lv1-Lv10 prose cannot precede this record |  | NOT_REQUIRED |
| NJ-059 | All-Gold Semantic Comparison | REQUIRED | Candidate fingerprint compared against every approved Gold Journey using canonical registry and unchanged Rule A / Rule B |  | BLOCKED | UNVERIFIED | `TEMPLATE COLLISION - NOT GOLD READY` on any collision |  | NOT_REQUIRED |
| NJ-060 | Mechanism Family Governance | CONDITIONALLY_REQUIRED | For a new family: nearest existing families, why none is equivalent, causal structural distinction, reusable naming, anti-laundering review |  | BLOCKED | UNVERIFIED | Journey-specific or collision-escape near-synonym family is BLOCKED |  | NOT_REQUIRED |
| NJ-061 | Lv1 Causal Proof | REQUIRED | Lv1 already contains protagonist, concrete Goal, Conflict, enacted Choice, decisive event/climax, and caused Consequence |  | BLOCKED | UNVERIFIED | `LV1 CAUSAL PROOF FAILED — DO NOT EXPAND` |  | NOT_REQUIRED |
| NJ-062 | Story Lock Pipeline Order | REQUIRED | FACT FIRST → PLACE CAUSALITY → STORY MECHANISM → ANTI-TEMPLATE → LV1 CAUSAL PROOF all PASS before STORY LOCK and Lv2-Lv10 expansion |  | BLOCKED | UNVERIFIED | Early full-Story drafting or expansion is blocked |  | NOT_REQUIRED |
| NJ-063 | Machine / Human Authority Boundary | REQUIRED | Machine-verifiable contract and human semantic/literary sufficiency recorded separately; no claim that CI proves historical interpretation or literary truth |  | BLOCKED | UNVERIFIED | Automated contract PASS cannot replace Founder/Agent review |  | NOT_REQUIRED |
| NJ-064 | Cultural Fact Action Test | REQUIRED | Fact/mechanism, authoritative source, Story location, character action, pressure, non-exposition rationale, removal effect |  | BLOCKED | UNVERIFIED | Character inaction = `DECORATIVE CULTURAL FACT` |  | NOT_REQUIRED |
| NJ-065 | Human Place Causality | REQUIRED | Removing the place materially breaks key Choice/Cost/Consequence, not only names |  | BLOCKED | UNVERIFIED | Generic-place survival = FAIL |  | NOT_REQUIRED |
| NJ-066 | Cultural Knowledge Residue | REQUIRED | Natural Story-only residue appropriate to level; no quota stuffing |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-067 | Story / Discovery Bridge | REQUIRED | `Story encounter → Discovery explanation`; Discovery does not retell event chain |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-068 | Discovery Page Depth | REQUIRED | Exact default `2/2/2/2/3/3/3/3/3/3`, one theme per level, independent sourced multilingual units; documented approval for deviation |  | BLOCKED | UNVERIFIED | Splitting/repetition/automatic 4+ expansion fails |  | PENDING |
| NJ-069 | Three-Gradient Level Model | REQUIRED | Language + Story understanding + cultural understanding evidence for Lv1–Lv10 |  | BLOCKED | UNVERIFIED | Language load alone cannot pass |  | NOT_REQUIRED |
| NJ-070 | Five Cognitive Bands | REQUIRED | Event, Place, Relationship×Place, Cultural Mechanism, Mastery/Judgment content targets |  | BLOCKED | UNVERIFIED | Content semantics only; no new stage |  | NOT_REQUIRED |
| NJ-071 | Level Semantic Delta | REQUIRED | Lv2–Lv10 each prove new causal, relational, or cultural understanding beyond surface-string/length change |  | BLOCKED | UNVERIFIED | `NEW PHRASE != NEW UNDERSTANDING` |  | NOT_REQUIRED |
| NJ-072 | Level Backward Completeness | REQUIRED | Every selected level independently contains full Story spine |  | BLOCKED | UNVERIFIED | Level is not chapter sequence |  | NOT_REQUIRED |
| NJ-073 | Story Spine Invariant | REQUIRED | Same protagonist, relationship, conflict, Choice, Cost, Climax, Ending, Memory Moment across Lv1–Lv10 |  | BLOCKED | UNVERIFIED | No alternate level Story |  | NOT_REQUIRED |
| NJ-074 | Lv10 Mastery Delta | REQUIRED | Lv10-only mature action, evidence awareness, relationship/cultural/conservation judgment |  | BLOCKED | UNVERIFIED | Lv9 plus length/words/Discovery fails |  | NOT_REQUIRED |
| NJ-075 | Optional Lv10 Mastery Capstone | CONDITIONALLY_REQUIRED | When Lv9→Lv10 remains weak: advanced existing Express/record/comparison/judgment without new Story event/stage |  | BLOCKED | UNVERIFIED | Applicability rationale required |  | PENDING |
| NJ-076 | Four-Language Exact Semantic Alignment | REQUIRED | Every active event/unit moves or disappears together in CN/Pinyin/VI/EN |  | BLOCKED | UNVERIFIED | Reading Support cannot retain legacy/extra meaning |  | NOT_REQUIRED |
| NJ-077 | Vocabulary Provenance | REQUIRED | Every active word appears in current Story or any current active Discovery; knownWords preserves target/provenance |  | BLOCKED | UNVERIFIED | No unseen advanced filler |  | NOT_REQUIRED |
| NJ-078 | Minimum Sufficient Story | REQUIRED | Complete spine + residue + semantic delta using least natural length; maximum treated as ceiling |  | BLOCKED | UNVERIFIED | Do not fill ceiling |  | NOT_REQUIRED |
| NJ-079 | Founder-Visible QA Language Ban | REQUIRED | Exact sweep of Story, Discovery, Challenge, Wonder, Express, Memory, Completion, Entry |  | BLOCKED | UNVERIFIED | Internal QA/test/Gate/PASS/FAIL language prohibited |  | NOT_REQUIRED |
| NJ-080 | Exact-Head Founder Authority | REQUIRED | PR head = reviewed Candidate = Preview release; later source commit invalidates approval |  | BLOCKED | UNVERIFIED | Full revalidation/review after any source change |  | PENDING |
| NJ-081 | Final Founder Audit | REQUIRED | Full Story/Culture/Level/end-to-end review with MUST FIX / SHOULD FIX / LATER and no endless polish loop |  | BLOCKED | UNVERIFIED |  |  | PENDING |

## Additional Expansion acceptance rows

| ID | Acceptance item | Requirement | Expected evidence | Actual evidence | Result | Evidence Level | Issue / Required action | Owner | Founder Approval |
|---|---|---|---|---|---|---|---|---|---|
| NJ-100 | Expansion context declared | REQUIRED | Expansion Layer, Parent hierarchy, Candidate Story Universe Slot |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-101 | Parent hierarchy verified | REQUIRED | Parent Province-Level Region, Parent City, Parent Place evidence |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-102 | Same-Place inventory reviewed | REQUIRED | Existing Place Story Inventory and comparison table |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-103 | Truth Mode declared | REQUIRED | Declared Truth Mode and evidence classification |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-104 | Incremental cultural value verified | REQUIRED | Rationale and evidence showing cultural incremental value vs existing Stories |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-105 | Incremental human value verified | REQUIRED | Rationale and evidence showing human-value incremental difference |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-106 | Same-Place Story collision absent | REQUIRED | Human Same-Place differentiation result and de-skinned spine comparison |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-107 | Whole-library differentiation verified | REQUIRED | Normalized semantic fingerprint comparison and human gate result |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-108 | Coverage quota did not override Gold | REQUIRED | Evidence showing coverage not used to justify acceptance |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| NJ-109 | Founder strategic authorization verified | REQUIRED | Founder strategic authorization record or explicit note (if required) |  | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |

## Background production acceptance extension

This section is REQUIRED whenever a new or replacement Journey background is in scope. It implements the binding gates from [PHOENIX AI BACKGROUND PRODUCTION STANDARD](../PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md). The original Journey rows above remain binding and are not replaced by this extension.

`FAIL`, `PENDING`, or `BLOCKED` in any applicable REQUIRED background row blocks runtime integration. `PENDING` is not approval. A Rights Gate other than `PASS` always blocks runtime integration.

| ID | Background acceptance item | Requirement | Expected evidence | Actual evidence | Background Gate State | Canonical Result | Evidence Level | Issue / Required action | Owner | Founder Approval |
|---|---|---|---|---|---|---|---|---|---|---|
| BG-001 | Visual DNA | REQUIRED | Versioned Visual DNA covering place, Story identity, period, mood, geography, architecture, materials, season/weather/time/light, Color DNA, people/clothing/transport/objects, FG/MG/BG, camera/depth/atmosphere, mobile region, Memory Anchor, forbidden motifs, cross-Journey differences |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-002 | Cross-Journey Differentiation | REQUIRED | Comparison against approved Journeys for composition, camera height/distance, geometry, foreground, density, materials, weather/light/time, color, Story relation, rhythm, Memory Anchor |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-003 | Shot Plan | REQUIRED | Versioned per-shot plan with Shot ID, purpose, Story relation, place/time/weather, camera position/height/distance/direction, FG/MG/BG, focal hierarchy, human density, lighting, mobile region, history/culture verification, IP notes, anti-template note |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-004 | Pilot Count | REQUIRED | Exactly 1–3 Pilot candidates for each new visual direction before full-library production |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-005 | Pilot Approval Before Full Production | REQUIRED | Evidence that full production remained blocked until all applicable Pilot QA and Founder review passed |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-006 | AI Original | REQUIRED | `AI Original: YES`, or explicit separately documented commercial-rights exception |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-007 | Third-party Production Asset Absence | REQUIRED | `Third-party production asset used: NO`, or exact approved rights exception and commercial-use evidence |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-008 | IP Safety | REQUIRED | Prompt/source review shows no direct living-artist, specific-photographer, movie/game, protected-character, key-art, or protected-composition imitation |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-009 | IP Similarity Review | REQUIRED | Similarity review result `PASS`; `REGENERATE` or `BLOCKED` cannot advance |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-010 | Rights Gate | REQUIRED | Rights Gate `PASS`; rights uncertainty produces `BLOCKED`, never inferred approval |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-011 | Provenance | REQUIRED | Journey ID, Asset ID, Shot ID, Visual DNA/Shot Plan/Prompt versions, generation method/tool/date, AI-original status, third-party use, Rights/IP/Cultural/Historical/Mobile/Founder/runtime states, asset version |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-012 | Location Accuracy | REQUIRED | Verified geographic/place identity and no wrong-city substitution |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-013 | Cultural Accuracy | REQUIRED | Architecture, roads/bridges/boats/walls, clothes/plants/objects/transport/behavior/religious details/decor/signage/morphology/technology reviewed as applicable |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-014 | Historical Accuracy | CONDITIONALLY_REQUIRED | For historical Story: era, building existence/restoration, clothes, transport, lighting tech, road materials, landscape, architectural state; otherwise evidence-backed `NOT_APPLICABLE` |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-015 | Architecture / Geography QA | CONDITIONALLY_REQUIRED | Applicable architecture and geography verification tied to research evidence |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-016 | Visual Quality | REQUIRED | High-DPI/4K-class source detail or equivalent, sharp focal subject, stable geometry, realistic materials/depth/reflections/shadows/atmosphere; no AI defects, pseudo-text, watermark, logo, or caption |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-017 | Foreground / Midground / Background | REQUIRED | Meaningful spatial depth where appropriate; flat repeated imagery rejected |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-018 | Focal Point | REQUIRED | Intentional primary and secondary focal hierarchy appropriate to the Shot Plan |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-019 | Mobile Crop | REQUIRED | Target portrait viewport evidence for subject, architecture, human scale, top/bottom safe zones, Story text and button areas, no critical clipping |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-020 | UI Readable Region | REQUIRED | Intentional quiet region for runtime UI; heavy blur not used as a composition rescue |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-021 | Anti-Template | REQUIRED | No simple landmark substitution or repeated framing/central landmark/foreground tree/golden hour/water reflection/camera height/visual rhythm pattern |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-022 | Performance / Asset Weight | REQUIRED | Optimized runtime format/size, decode and memory review, mobile loading check, visual-fidelity check; raw giant generation masters excluded from runtime |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-023 | Final Library Minimum | CONDITIONALLY_REQUIRED | `>=10` approved images where current destination/background runtime policy requires it, only after Pilot approval |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-024 | Library Internal Diversity | CONDITIONALLY_REQUIRED | Full-library QA for camera, distance, focal relation, weather/light, density, depth, tension, Story purpose, negative space, movement implication where a library is produced |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-025 | Story World Coverage | REQUIRED | Images collectively support Story World and applicable opening/movement/turning point/conflict/weather/resolution/ending/Memory Anchor relationships |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-026 | Content / Visual Separation | REQUIRED | Evidence canonical Story, Words, Discovery, Challenge, Memory, and Complete were not modified to accommodate visuals |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| BG-027 | Versioning | REQUIRED | Asset ID, Version, Previous Version, Replacement Reason, Review Status |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-028 | Rollback Path | REQUIRED | Recoverable previous approved imagery or documented restoration path |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-029 | Safe Fallback | REQUIRED | No silent wrong-city, wrong-Journey, or wrong-era fallback; safe Phoenix fallback verified |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-030 | Automated-score Limitation | REQUIRED | Declaration that complianceScore, varietyScore, resolution, AI metadata, hash, dimensions, or asset count were not used as sole visual approval |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |
| BG-031 | Founder Visual Approval | CONDITIONALLY_REQUIRED | Explicit `APPROVED` tied to the candidate/Preview wherever UI/visual/Journey standards require Founder review; otherwise justified `NOT_REQUIRED` |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-032 | Runtime Integration Eligibility | REQUIRED | All mandatory background gates `PASS`, applicable Founder approval complete, final runtime metadata/count rules satisfied, relevant tests pass |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | PENDING |
| BG-033 | No-Bypass Governance | REQUIRED | No hard-coded PASS, no skipped Rights/Founder/Pilot gate, no lowered baseline, no Story rewrite, no removed/weakened tests, exceptions explicitly documented and approved |  | BLOCKED | BLOCKED | UNVERIFIED |  |  | NOT_REQUIRED |

### Background phase rule

Background production MUST follow:

> Story Gold → Visual DNA → Cross-Journey Differentiation → Shot Plan → 1–3 Pilot → Rights/IP QA → Historical/Cultural QA → Mobile QA → Founder Review where required → Full Production Library → Runtime Integration

A new Journey may not jump from Story Gold directly to 10-image generation.

## Conditional applicability record

Every `CONDITIONALLY_REQUIRED` item MUST include:

```text
Acceptance Item:
Applicability Condition:
Condition Met: YES / NO
Applicability Evidence:
Result:
Evidence Level:
Reason when NOT_APPLICABLE:
```

A blank conditional decision is `BLOCKED`.

## Phase decision record

| Phase | Inputs | Required deliverables | Evidence | Blockers | Owner | Result | Evidence Level | Next phase authorized |
|---|---|---|---|---|---|---|---|---|
| A: Journey Proposal |  | Story source inventory, fact/fiction record, Place Causal Mechanism, Story Mechanism, all-Gold semantic comparison |  | Source/place/semantic blocker |  | BLOCKED | UNVERIFIED | NO |
| B: Story and Learning Design |  | Lv1 causal proof before Lv2-Lv10; Relationship, Goal, ReadingAnnotation applicability, Stamp applicability, and all other classified design elements |  | Lv1 or Story Lock blocker |  | BLOCKED | UNVERIFIED | NO |
| C: Visual Concept Pilot | Story Gold, visual baseline, AI Background Production Standard | Visual DNA, Cross-Journey Differentiation, Shot Plan, 1–3 Pilot plan, rights/IP plan, historical/cultural plan, mobile/readable-region plan |  | Missing mandatory background gate |  | BLOCKED | UNVERIFIED | NO |
| D: Implementation |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| E: Automated Validation |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| F: Stable Baseline Comparison |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| G: Founder Mobile Preview |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |
| H: Approval and Controlled Release |  |  |  |  |  | BLOCKED | UNVERIFIED | NO |

Narrative extension for phase records:

- Phase A requires FACT FIRST source truth, explicit fact/fiction classification, real-person protection where applicable, Place Causal Mechanism, Generic Place Substitution Test, Story Mechanism architecture, and canonical all-Gold semantic comparison before full Story prose.
- Phase B begins with Lv1 Causal Proof; Lv2-Lv10 expansion is blocked until Lv1 and all pre-lock gates pass and Story is `STORY LOCKED`.
- Phase A additionally requires narrative engine, Story Function, Discovery Function, opening type, climax type, ending type, catalog differentiation matrix, and level-invariant plan.
- Phase B additionally requires the complete Story / Discovery Design Matrix, causal Relationship evidence, enacted Choice evidence, caused Consequence evidence, functional separation, opening and ending independence, library review, and automated-score limitation acknowledgment.
- Phase E records that automated validation success does not establish literary PASS, factual-interpretation sufficiency, place-native Story quality, or visual background PASS.
- Phase G reviews Story identity, Discovery distinction, emotional continuity, place causality, semantic distinctness beyond mechanical thresholds, level adaptation, Journey memorability, and applicable background mobile/visual approval.

## Final decision

```text
Required Items Total:
Required PASS + VERIFIED:
Required Missing or Failed:
Conditionally Required Items Total:
Conditionally Required PASS + VERIFIED:
Conditionally Required NOT_APPLICABLE with Reason + Evidence:
Conditionally Required Missing or Failed:
Regression Items:
Blocked Items:
Source Truth Gate:
Unsupported Factual Claims:
Fact / Fiction Boundary:
Real Historical Person Protection:
Place Causal Mechanism:
Generic Place Substitution Test:
Story Mechanism Gate:
All-Gold Semantic Comparison:
Taxonomy Governance:
Lv1 Causal Proof:
Story Lock State:
Machine / Human Authority Separation:
Background Required Rows Total:
Background Gate PASS + VERIFIED:
Background Gate FAIL:
Background Gate PENDING:
Background Gate BLOCKED:
Rights Gate:
IP Similarity Review:
Founder Mobile Approval:
Second Journey Implementation Detected: YES / NO
Stable Baseline Comparison Decision:
Runtime Background Integration Eligible: YES / NO
Final Journey Decision:
Controlled Release Authorized: YES / NO
```

Any missing `REQUIRED` item or applicable `CONDITIONALLY_REQUIRED` item blocks Completed. Any required background gate that is `FAIL`, `PENDING`, or `BLOCKED` blocks background runtime integration.
