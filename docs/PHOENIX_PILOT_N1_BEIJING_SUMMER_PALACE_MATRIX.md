# Phoenix Pilot N1 — Beijing Summer Palace Matrix

**Status:** REMEDIATION IN PROGRESS  
**Governance Phase ID:** `PILOT_N1`  
**Primary Finding:** `PROTAGONIST_IDENTITY_MISSING`  
**Journey ID:** `beijing-summer-palace`  
**Journey Type:** NORMAL  
**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`  
**Starting main:** `c3d7a8d61c13a734a0787dfcda5babbbd57018f3`

## 1. Identity

- Title: 《留下痕迹的风景》
- Perspective: third-person close focus through Xu Cheng
- Protagonist: 许澄, a seventeen-year-old student photographer
- Relationship: grandmother Zhou Lan, a former Long Corridor painting conservator
- Goal: create a flawless Summer Palace photograph for a school exhibition and prove independence from Zhou Lan
- Conflict: Zhou Lan asks Xu Cheng to see conservation traces; ideal light and a falling archival photograph demand incompatible actions
- Enacted Choice: Xu Cheng abandons the postcard view, retrieves the photograph and reframes grandmother, photograph and landscape together
- Caused Consequence: she loses the ideal light, creates 《留下痕迹的风景》 and receives Zhou Lan’s trust and photograph
- Emotional opening: impatient certainty
- Turning point: the photograph falls as the ideal light appears
- Emotional ending: attentive responsibility and accepted inheritance
- Cultural anchor: borrowed scenery and conservation evidence actively determine the photographic choice
- Narrative engine: framed-restoration choice
- Climax: Seventeen-Arch Bridge choice
- Ending state: Xu Cheng becomes keeper of the photograph instead of a photographer erasing time
- Memory anchor: worn paper edge, Zhou Lan’s hand and Longevity Hill in three layers

## 2. Stage Function Contracts

### Story Function Contract

Through Xu Cheng and Zhou Lan’s conflict over a flawless landscape versus readable restoration traces, Story enacts a choice and consequence that lets the explorer experience conservation as preserving time and relationship.

### Discovery Function Contract

Discovery independently explains borrowed scenery, opposite views, corridor sightline sequencing, historical damage and conservation records without retelling Xu Cheng’s events.

### Other stages

- Vocabulary: teaches words used by the Story and Discovery.
- Reflection: asks the explorer to interpret what changed when Xu Cheng abandoned the flawless image.
- Challenge: validates understanding and keeps the existing Reward quantity contract.
- Writing: asks the explorer to produce a school-exhibition explanation of the choice.
- Memory: records a personal durable recall anchor.
- Completion: commits completion, Stamp and Memory through the existing critical transaction.

## 3. Story / Discovery Separation

- Story-only information: Xu Cheng, Zhou Lan, school exhibition, archival photograph, conflict, choice, relational consequence.
- Discovery-only information: landscape framework, borrowed scenery, opposite view, movement sequencing, 1750/1860/1886 chronology, conservation-record method.
- Intentional overlap: Long Corridor, Seventeen-Arch Bridge and restoration vocabulary.
- Overlap justification: the same cultural anchors create action in Story and receive factual explanation in Discovery.
- Functional duplication detected: NO
- Exact-text comparison evidence: separate source constants and paragraphs.
- Functional comparison evidence: Story contains character event causality; Discovery contains no Xu Cheng, Zhou Lan or archival-photo event.

## 4. Catalog comparison

| Compared Journey | Shared elements | Independent evidence | Risk | Decision |
|---|---|---|---|---|
| beijing-forbidden-city | Beijing heritage setting | student photographer, conservator grandmother, archival photograph and conservation choice | Low | Independent causal engine |
| suzhou-humble-administrators-garden | garden design vocabulary | school exhibition deadline and intergenerational restoration relationship | Medium | Cultural overlap permitted; plot and ending differ |
| dunhuang-mogao-caves | conservation theme | borrowed-scenery photography choice at a bridge, not cave restoration duty | Medium | Different relationship, mechanism and climax |
| shanghai-bund | photography-compatible city view | loss of ideal light and acceptance of material traces | Low | Different cultural action and ending |

## 5. Phoenix Lv.1–10 Narrative Invariants

Every level must preserve:

1. Xu Cheng as protagonist.
2. Zhou Lan as grandmother and former conservator.
3. The school-exhibition photograph goal.
4. Tension between flawlessness and readable restoration traces.
5. The old photograph falling at the moment of ideal light.
6. Xu Cheng choosing the photograph and relationship over the postcard view.
7. Loss of ideal light as the immediate consequence.
8. A photograph combining old paper, Zhou Lan’s hand and distant landscape.
9. Recognition that restoration does not erase the past.
10. Zhou Lan entrusting the old photograph to Xu Cheng.

| Phoenix level | Invariants | Result | Evidence Level |
|---:|---|---|---|
| 1 | Preserved in beginner reduction | PASS | VERIFIED_BY_CODE_AND_TEST |
| 2 | Preserved in beginner reduction | PASS | VERIFIED_BY_CODE_AND_TEST |
| 3 | Preserved in elementary form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 4 | Preserved in elementary form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 5 | Preserved in intermediate form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 6 | Preserved in intermediate form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 7 | Preserved in standard form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 8 | Preserved in standard form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 9 | Preserved in standard/challenge form | PASS | VERIFIED_BY_CODE_AND_TEST |
| 10 | Preserved in challenge form | PASS | VERIFIED_BY_CODE_AND_TEST |

## 6. Reflection / Writing Composite Compatibility

- Critical State schema version: `2`
- Legacy readable schema version: `1`
- Migration rule: a complete schema-v2 record and witness are committed atomically before v2 becomes authoritative.
- Interrupted migration rule: a staged record without its matching witness is not authoritative and migration safely retries from the last committed generation.
- Top-level step range: `0–5`
- Step 3: Reflection followed by Challenge inside the same committed step.
- Step 4: Writing followed by Memory inside the same committed step.
- Journey flow version: `2` for `beijing-summer-palace`; all other Journeys remain flow version `1`.
- Persisted composite substage field: YES, scoped to the Summer Palace Pilot flow.
- Legacy step 3 mapping: Guide feedback present → Challenge; otherwise Reflection.
- Legacy step 4 mapping: Writing feedback present → Memory; otherwise Writing.
- Legacy step 5 mapping: Completed, with existing Stamp and Memory semantics unchanged.
- Journey ID or namespace change: NO
- Existing completed `step=5` reinterpreted: NO
- Reflection feedback identity: bound to the normalized Reflection input.
- Writing feedback identity: bound to the normalized Writing input.
- Challenge attempt identity: stable across retry and close/reopen within the persisted Journey flow.
- Challenge Reward persistence: Award identity and wallet mutation commit together before UI success is accepted.
- Old narration offset: cleared when the existing content signature does not match revised Story or Discovery.

## 7. Compatibility

- B1 routing and Active Journey identity: unchanged.
- B2 access and Morning/Afternoon assignment: unchanged.
- Critical State domain and two-generation record/witness journal: unchanged.
- Critical State payload schema: migrated from v1 to v2 under Founder authorization.
- Wallet and Special unlock rules: unchanged.
- Reward quantities and issuance rules: unchanged.
- Held Special Journeys: unchanged and unpublished.
- Images and audio assets: unchanged.
- Other Journey content: unchanged.
- Global background zoom behavior: unchanged and explicitly outside this PR.
- Stable quality rule: `NEW RESULT >= CURRENT STABLE BASELINE`.

## 8. Automated Validation Boundary

- Automated checks implemented: Story shape, identity constants, enacted-choice evidence, Story/Discovery separation, language evidence, vocabulary-in-context evidence, difficulty invariants, Phoenix Lv.1–10 invariants, composite page mapping, schema v1→v2 migration, interrupted migration, Reward retry/reopen, feedback identity, top-level step guard and full regression suite.
- Fields not approved by automation: literary naturalness, emotional credibility, cultural tone, final mobile experience.
- Automated Structural Result: PENDING FINAL HEAD GATES
- Automated Structural Evidence Level: UNVERIFIED UNTIL FINAL HEAD
- Human Literary Reviewer: Founder
- Human Literary Result: PENDING
- Human Literary Evidence Level: UNVERIFIED
- Automated score used as literary approval: NO

## 9. Founder Gate

- Founder Preview required: YES
- Founder approval state: PENDING
- PR must remain Draft: YES
- Ready authorized: NO
- Merge authorized: NO
- Pilot S1 authorized: NO
- Batch expansion authorized: NO

## 10. Candidate Decision

- Blocking codes targeted: protagonist, relationship, goal, conflict, choice, consequence, emotional arc, tourism exposition, Story/Discovery overlap, opening reuse, catalog differentiation and level identity.
- Stable comparison result: pending final-head gates and Founder experience.
- Automated structural result: PENDING FINAL HEAD GATES
- Human literary result: PENDING
- Founder approval required: YES
- Founder approval state: PENDING
- Next phase authorized: NO
- Final Result: PENDING_FINAL_HEAD_EVIDENCE
