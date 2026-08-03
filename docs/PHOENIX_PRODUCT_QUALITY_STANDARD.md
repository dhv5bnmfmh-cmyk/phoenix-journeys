# Phoenix Product Quality Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Quality law

Every candidate MUST satisfy:

> `NEW RESULT >= CURRENT STABLE BASELINE`

Quality claims require exact scope, Result, Evidence Level, candidate Commit, and reproducible evidence. A checkbox, file existence, automated score, or terminal CI result proves only the check it actually performs.

This standard is binding together with [Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), Journey System Standard, UI and Visual Standard, New Journey Creation Standard, Full Application Audit Standard, and Development Completion Standard.

## 2. Evidence model

Allowed Result values:

- `PASS`
- `REQUIRES_REVISION`
- `REGRESSION`
- `BLOCKED`
- `NOT_APPLICABLE`

Allowed Evidence Level values:

- `VERIFIED`
- `PARTIALLY_VERIFIED`
- `UNVERIFIED`
- `CONTRADICTORY`

`PASS` requires `VERIFIED` evidence. `NOT_APPLICABLE` requires a documented product decision, applicability reason, and evidence.

## 3. Quality domains

Every applicable change and audit MUST independently assess:

- Function;
- Interaction;
- Mobile;
- Accessibility;
- Performance;
- Content;
- Story and Discovery;
- Language and translation;
- Narration and audio;
- Visual mapping and visual quality;
- Rights and provenance;
- Routing and identity;
- Persistence and migration;
- Access and entitlement;
- Privacy, Secret storage, and external processing;
- stable-baseline comparison.

One domain's PASS does not imply another domain's PASS.

## 4. Content Quality

Content Quality is not reducible to factual correctness, polished language, length, field presence, or an aggregate score.

Binding rules:

- factual accuracy does not replace narrative quality;
- polished language does not replace causal Story structure;
- exact-text difference does not prove Story / Discovery separation;
- aggregate content scores cannot approve library differentiation;
- Story, Discovery, Reflection, Writing, and Memory MUST have distinct product functions;
- content changes require Journey-level and library-level evidence;
- Story MUST include an independently identifiable protagonist, causal Relationship, specific Goal, Goal-connected Conflict, enacted Choice, caused Consequence, Emotional Arc, cultural anchor in action, decisive climax, and changed ending state;
- Discovery MUST add verified understanding without retelling Story;
- generic tourism narration, repeated opening systems, repeated ending systems, and city substitution are prohibited;
- Phoenix Lv.1 through Lv.10 MUST preserve narrative invariants;
- special mechanisms MUST NOT be flattened by generic adaptation;
- automated structural Result and human literary Result MUST be recorded separately.

Use Phoenix Narrative and Discovery Standard and Phoenix Story / Discovery Design Matrix for every Story, Discovery, repair pilot, controlled batch, and new Journey.

## 5. Visual and rights quality

PR `#137` is the minimum visual-quality baseline. Runtime page evidence is required for visual PASS. Filenames, paths, hashes, dimensions, metadata, automated compliance fields, successful bundling, and rights records do not establish visual quality.

Rights approval and visual approval are separate. Rights compliance MUST NOT be achieved by replacing an approved visual with a lower-quality placeholder or generic programmatic asset.

## 6. Functional and interaction quality

Correct behavior requires exact route, ID, component, state, input, output, Loading, Error, Empty, Fallback, back navigation, keyboard, lifecycle, accessibility, and persistence evidence. App launch alone is not functional PASS.

## 7. Persistence and access quality

Critical completion, reward, stamp, wallet, unlock, and entitlement changes require idempotent and recoverable behavior. Static code cannot prove injected failure recovery.

Access decisions MUST be verified separately for development, production, free, paid, locked, unlocked, Random / Daily, direct entry, restored state, stale state, and offline behavior where applicable.

## 8. Language, narration, and accessibility quality

Supported language scope MUST distinguish interface script, explanation language, translation records, narration locale, and accessibility labels. No language may be declared complete without page and Journey evidence.

Narration evidence includes play, pause, resume, stop, replay, speed, temporary playback, synchronization, interruption, route/lifecycle behavior, failed voice, and accessibility alternative.

Accessibility includes semantics, reading/focus order, text scaling, reflow, contrast, non-color feedback, reduced motion, touch targets, keyboard, assistive input, and non-audio alternatives.

## 9. Automated validation boundary

Automated validation MAY verify fields, IDs, lengths, paragraph counts, language records, annotations, exact duplication, route mappings, and structural integrity.

It cannot by itself approve protagonist independence, Relationship quality, Goal significance, Conflict quality, Choice meaning, Consequence strength, Emotional Arc, cultural integration, Story / Discovery functional separation, library differentiation, literary quality, visual quality, mobile experience, or Founder experience.

Claims such as `360 / 360 PASS`, `score 100`, `average 100`, and `all fields present` MUST include the exact implemented check scope and MUST NOT create overall Story Quality PASS.

## 10. Regression and blocking

Any result below the current stable baseline is `REGRESSION`. Any missing critical evidence is `BLOCKED`. Regression blocks Completed, Ready, merge, content expansion, and the next phase.

A repair is not accepted until the same domain, route, Journey, state, and device scope is reverified.

## 11. Approval

Technical success, human literary approval, visual approval, rights approval, and Founder approval are separate gates. Required Founder mobile approval MUST be tied to the exact candidate Commit and Preview.

This standard does not authorize a content repair, pilot, new Journey, Ready action, or merge.
