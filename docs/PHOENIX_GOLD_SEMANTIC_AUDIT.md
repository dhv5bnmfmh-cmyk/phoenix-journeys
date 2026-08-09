# Phoenix Approved Gold Semantic Audit

**Status:** DETERMINISTIC AUDIT RECORD  
**Catalog scope:** seven approved Gold Journeys  
**Source of truth:** `app/lib/data/journey_semantic_fingerprint_catalog.dart`  
**Pair count:** 21 unique pairs

This document records the deterministic output of the normalized semantic fingerprint catalog. It does not override the catalog. If a fingerprint changes, regenerate/review this audit from the canonical registry and active Story evidence.

Collision thresholds remain binding and unchanged:

- **Rule A:** same dramatic engine + at least 3 additional CORE matches.
- **Rule B:** at least 4 CORE matches, even when dramatic-engine labels differ.

`EXISTING_SEMANTIC_COLLISION_DEBT` records a collision between already-approved Gold Journeys. It is not an allowlist and is not precedent for a future Gold candidate.

## Evidence status meaning

`VERIFIED` means the registered CORE evidence contract has valid active-Story provenance, aligned dimension/mechanism metadata, and a non-empty semantic rationale. It does **not** mean CI independently understands or proves natural-language semantic classification. Semantic sufficiency remains a Founder/Agent review of cited active-Story spans plus causal rationale.

## Pairwise audit

| # | Journey A | Journey B | Same engine | Matching CORE dimensions | CORE count | Matching secondary dimensions | Story evidence | Classification | Notes |
|---:|---|---|---|---|---:|---|---|---|---|
| 1 | beijing-summer-palace | beijing-forbidden-city | NO | none | 0 | none | VERIFIED | DISTINCT | Forced creative/relational tradeoff vs synthesis of two simultaneously valid route perspectives. |
| 2 | beijing-summer-palace | shanghai-bund | NO | none | 0 | none | VERIFIED | DISTINCT | Creative authorship/recovered photograph vs intergenerational continuity through a river crossing. |
| 3 | beijing-summer-palace | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | Forced photographic tradeoff vs completed closed circuit becoming open continuation. |
| 4 | beijing-summer-palace | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Forced relational tradeoff vs evidence-driven reclassification. |
| 5 | beijing-summer-palace | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Creative tradeoff/inherited photograph vs field-survey reclassification. |
| 6 | beijing-summer-palace | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Rescue/recomposition vs refusal of an unsafe/unapproved shortcut. |
| 7 | beijing-forbidden-city | shanghai-bund | NO | none | 0 | none | VERIFIED | DISTINCT | Comparative route synthesis vs carried-document continuity through one-way crossing. |
| 8 | beijing-forbidden-city | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | Shared-node overlay/divergence vs completion of a closed circuit followed by onward continuation. |
| 9 | beijing-forbidden-city | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Two valid perspectives are retained; Hangzhou replaces a purity model after contradictory field evidence. |
| 10 | beijing-forbidden-city | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Composite preservation of two valid routes vs evidence-driven authenticity reclassification. |
| 11 | beijing-forbidden-city | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Forbidden now aligns and preserves two valid routes to reveal relational spatial information; Nanjing remains responsible refusal of an unsafe/unapproved shortcut with visible incompletion and responsibility transfer. |
| 12 | shanghai-bund | xian-city-wall | NO | none | 0 | none | VERIFIED | DISTINCT | One-way river crossing reframes historical continuity; closed wall circuit becomes an onward home route. |
| 13 | shanghai-bund | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Intergenerational carried-object continuity vs evidence-driven field-recording reclassification. |
| 14 | shanghai-bund | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Intergenerational carried-object continuity vs evidence-driven survey reclassification. |
| 15 | shanghai-bund | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | River crossing/continuity vs operational countdown/refusal. |
| 16 | xian-city-wall | hangzhou-west-lake | NO | none | 0 | none | VERIFIED | DISTINCT | Open continuation after a completed circuit vs evidence-driven reclassification. |
| 17 | xian-city-wall | chengdu-kuanzhai-alley | NO | none | 0 | none | VERIFIED | DISTINCT | Belonging through continuation vs evidence-driven preservation-model revision. |
| 18 | xian-city-wall | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Self-declared farewell completion becomes continuation vs deadline refusal with visible operational incompletion. |
| 19 | hangzhou-west-lake | chengdu-kuanzhai-alley | YES | relationship geometry, conflict, choice, climax, consequence, transformation, ending, dramatic engine | 8 | supporting-character function | VERIFIED | EXISTING_SEMANTIC_COLLISION_DEBT | Both begin fieldwork with a purity/authenticity model, lived evidence contradicts it, the protagonist stops filtering evidence, enacts reclassification in a record/artifact, retains the changed evidence, and ends with a revised record preserving changed understanding. |
| 20 | hangzhou-west-lake | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Evidence-driven soundscape reclassification vs operational shortcut refusal. |
| 21 | chengdu-kuanzhai-alley | nanjing-qinhuai-river | NO | none | 0 | none | VERIFIED | DISTINCT | Evidence-driven survey reclassification vs operational shortcut refusal. |

## Required explicit pair conclusions

### Forbidden City vs Nanjing Qinhuai

**Result:** `DISTINCT`  
**CORE matches:** none (0).  
**Same dramatic engine:** NO.  
**Rule A:** NOT TRIGGERED.  
**Rule B:** NOT TRIGGERED.

The previous six-CORE debt is removed by active Story remediation, not taxonomy renaming. Forbidden City no longer uses completion-vs-boundary conflict, shortcut refusal, intentional visible incompletion, completion-drive-to-restraint transformation, or mentor responsibility transfer. Its causal engine now requires two simultaneously valid partial route perspectives, comparison/alignment, enacted preservation through overlay, a shared-node overlap/divergence discovery, and a composite representation containing more relational information than either input alone.

### Hangzhou West Lake vs Chengdu Kuanzhai Alley

**Result:** `EXISTING_SEMANTIC_COLLISION_DEBT`  
**CORE matches:** relationship geometry, conflict, choice, climax, consequence, transformation, ending, dramatic engine (8).  
**Secondary match:** supporting-character function.  
**Same dramatic engine:** YES.  
**Rule A:** COLLISION.  
**Rule B:** COLLISION.

This debt is untouched by Forbidden City remediation. The sound recording and survey sheet remain different surface artifacts that perform the same deeper function: evidence forces an authenticity model to be revised and the revised record becomes ending evidence.

### Forbidden City all-Gold result

**Result:** `DISTINCT` from all six other approved Gold Journeys.

Its new engine is `coexistingValidPerspectivesSynthesizeRelationalModel`. Two valid perspectives remain simultaneously true and become more informative through composite representation. No other current Gold Journey uses that causal mechanism.

### Summer Palace family result

**Result:** `DISTINCT` from all six other current Gold Journeys.

Its engine remains a forced choice between preserving an ideal photographic opportunity and recovering a relational memory object, producing a recomposed artifact and intergenerational entrustment.

### Shanghai Bund distinctness

**Result:** `DISTINCT` from all six other current Gold Journeys.

Its engine remains a one-way spatial crossing that reframes a false past/future split through an intergenerational trade document carried into a chosen new career.

### Xi'an City Wall distinctness

**Result:** `DISTINCT` from all six other current Gold Journeys.

Its engine remains a deliberately completed closed circuit that becomes the departure point for an open continuation, with the running record extending past the declared finish toward the new home.

## Debt policy

The current catalog contains **one** historical semantic collision debt:

1. `hangzhou-west-lake` ↔ `chengdu-kuanzhai-alley`

Forbidden City ↔ Nanjing debt is remediated and no longer classified as collision debt. No allowlist or exception was created. This audit does **not** authorize remediation of Hangzhou or Chengdu, and a future Gold candidate cannot use historical debt as precedent: any candidate collision remains `TEMPLATE COLLISION - NOT GOLD READY` until its causal dramatic mechanism is redesigned.
