# Phoenix Approved Gold Semantic Audit

**Status:** DETERMINISTIC AUDIT RECORD  
**Catalog scope:** the seven approved Gold Journeys present when the semantic anti-template gate was introduced  
**Source of truth:** `app/lib/data/journey_semantic_fingerprint_catalog.dart`  
**Pair count:** 21 unique pairs

This document records the deterministic output of the normalized semantic fingerprint catalog. It does not override the catalog. If a fingerprint changes, regenerate/review this audit from the canonical registry and active Story evidence.

Collision thresholds are binding in [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md):

- **Rule A:** same dramatic engine + at least 3 additional CORE matches.
- **Rule B:** at least 4 CORE matches, even when dramatic-engine labels differ.

`EXISTING_SEMANTIC_COLLISION_DEBT` records a collision between already-approved Gold Journeys. It is not an allowlist and is not precedent for a future Gold candidate.

## Pairwise audit

| # | Journey A | Journey B | Same engine | Matching CORE dimensions | CORE count | Matching secondary dimensions | Story evidence | Classification | Notes |
|---:|---|---|---|---|---:|---|---|---|---|
| 1 | beijing-summer-palace | beijing-forbidden-city | NO | none | 0 | none | VERIFIED | DISTINCT | Both concern judgment and heritage traces, but Summer uses a forced creative tradeoff; Forbidden uses responsible refusal of available access. |
| 2 | beijing-summer-palace | shanghai-bund | NO | none | 0 | none | VERIFIED | DISTINCT | Creative authorship/recovered photograph vs intergenerational continuity through a river crossing. |
| 3 | beijing-summer-palace | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | Forced photographic tradeoff vs completed closed circuit becoming open continuation. |
| 4 | beijing-summer-palace | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Both create records, but Summer's causal pivot is a forced relational tradeoff; Hangzhou is evidence-driven reclassification. |
| 5 | beijing-summer-palace | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Creative tradeoff and inherited photograph vs field-survey reclassification. |
| 6 | beijing-summer-palace | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Both sacrifice an ideal result and alter a senior relationship, but the CORE causal mechanisms differ: rescue/recomposition vs refusal of an unsafe/unapproved shortcut. |
| 7 | beijing-forbidden-city | shanghai-bund | NO | none | 0 | none | VERIFIED | DISTINCT | Boundary restraint vs carried-document continuity through crossing. |
| 8 | beijing-forbidden-city | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | Deliberate non-crossing/blank vs deliberate continuation beyond a completed circuit. |
| 9 | beijing-forbidden-city | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Responsible refusal vs evidence-driven authenticity reclassification. |
| 10 | beijing-forbidden-city | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Responsible refusal vs evidence-driven authenticity reclassification. |
| 11 | beijing-forbidden-city | nanjing-qinhuai-river | YES | conflict, choice, consequence, transformation, ending, dramatic engine | 6 | none | VERIFIED | EXISTING_SEMANTIC_COLLISION_DEBT | Both pursue completion, encounter an available but irresponsible shortcut/boundary crossing, refuse it, retain visible incompletion, move from completion-drive to restraint, and end with senior trust/responsibility transfer. Opening, climax form, relationship subtype, and cultural-anchor subtype remain different but do not erase the CORE collision. |
| 12 | shanghai-bund | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | One-way river crossing reframes historical continuity; closed wall circuit becomes an onward home route. |
| 13 | shanghai-bund | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Intergenerational carried-object continuity vs evidence-driven field-recording reclassification. |
| 14 | shanghai-bund | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Intergenerational carried-object continuity vs evidence-driven survey reclassification. |
| 15 | shanghai-bund | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | River crossing/continuity vs operational countdown/refusal. |
| 16 | xian-city-wall | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Open continuation after a completed circuit vs evidence-driven reclassification. |
| 17 | xian-city-wall | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Belonging through continuation vs evidence-driven preservation-model revision. |
| 18 | xian-city-wall | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Self-declared farewell completion becomes continuation vs deadline refusal with visible operational incompletion. |
| 19 | hangzhou-west-lake | chengdu-kuanzhai-alley | YES | relationship geometry, conflict, choice, climax, consequence, transformation, ending, dramatic engine | 8 | supporting-character function | VERIFIED | EXISTING_SEMANTIC_COLLISION_DEBT | Both begin fieldwork with a purity/authenticity model, lived evidence contradicts that model, the protagonist stops filtering evidence, enacts reclassification in a record/artifact, retains the changed evidence, and ends with a revised record preserving changed understanding. |
| 20 | hangzhou-west-lake | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Evidence-driven soundscape reclassification vs operational shortcut refusal. |
| 21 | chengdu-kuanzhai-alley | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Evidence-driven survey reclassification vs operational shortcut refusal. |

## Required explicit pair conclusions

### Forbidden City vs Nanjing Qinhuai

**Result:** `EXISTING_SEMANTIC_COLLISION_DEBT`  
**CORE matches:** conflict, choice, consequence, transformation, ending, dramatic engine (6).  
**Same dramatic engine:** YES.  
**Rule A:** COLLISION.  
**Rule B:** COLLISION.

The normalized classification is supported by active Story evidence. Different professional settings, objects, timing, landmarks, and descriptive strings do not remove the shared causal mechanism.

### Hangzhou West Lake vs Chengdu Kuanzhai Alley

**Result:** `EXISTING_SEMANTIC_COLLISION_DEBT`  
**CORE matches:** relationship geometry, conflict, choice, climax, consequence, transformation, ending, dramatic engine (8).  
**Secondary match:** supporting-character function.  
**Same dramatic engine:** YES.  
**Rule A:** COLLISION.  
**Rule B:** COLLISION.

The sound recording and survey sheet are different surface artifacts, but both perform the same deeper function: evidence forces an authenticity model to be revised and the revised record becomes ending evidence.

### Summer Palace family result

**Result:** `DISTINCT` from Forbidden City and Nanjing under the normalized gate.

Summer Palace shares broad themes of accepting imperfection and changed senior trust, but its causal engine is a forced choice between preserving the ideal photographic opportunity and recovering a relational memory object. The lost light causes a new composition; the ending entrusts an inherited photograph. Those functions are not normalized as responsible refusal of an available shortcut or intentional visible incompletion.

### Shanghai Bund distinctness

**Result:** `DISTINCT` from all six other current Gold Journeys.

Its engine is a one-way spatial crossing that reframes a false past/future split through an intergenerational trade document carried into a chosen new career.

### Xi'an City Wall distinctness

**Result:** `DISTINCT` from all six other current Gold Journeys.

Its engine is a deliberately completed closed circuit that becomes the departure point for an open continuation, with the running record extending past the declared finish toward the new home.

## Debt policy

The two existing debt findings are reported rather than suppressed. This audit does **not** authorize literary remediation in the affected Stories. A future Gold candidate cannot rely on this debt as precedent: any candidate collision is `TEMPLATE COLLISION - NOT GOLD READY` until its dramatic mechanism is redesigned.
