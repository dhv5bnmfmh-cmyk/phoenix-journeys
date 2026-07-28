# Adaptive Phoenix Levels 1–10

Base: `main@7d5a7b6ec767dcb9807396239e4464da6ddb8510`

## Explorer experience

- Replace the public HSK and TOCFL picker with one compact `− Lv.N +` control.
- Keep the control fixed in the upper-right corner of Explore, Passport, and Me, and in the Journey app bar for every story, vocabulary, discovery, challenge, memory, and completion step.
- Let explorers change freely from Phoenix Level 1 through Level 10.
- Apply a level change immediately without leaving the current page or losing journey progress, drafts, coins, stamps, or unlocks.
- Stop narration that belongs to the previous level, update speech rate, clear stale AI feedback, and rebuild the current challenge.
- Disable minus at Level 1 and plus at Level 10.

## Unified content model

- Phoenix Level 1–10 is the only difficulty model shown to explorers.
- HSK and TOCFL catalogs remain internal calibration evidence for vocabulary selection and legacy-setting migration; Phoenix does not present the levels as official certificate equivalence.
- Existing `hsk:*` and `tocfl:*` preferences migrate automatically to the nearest Phoenix level.
- New explorers begin at Phoenix Level 5 and can adjust immediately.
- The ten plans gradually change paragraph shape, character range, sentence length, vocabulary count, cultural vocabulary quota, grammar load, known-word coverage, and narration speed.
- Story, discovery, vocabulary, comprehension prompts, expression prompts, and challenge pedagogy respond together.

## Reading and challenge behavior

- Keep the approved reading shape: one integrated deep paragraph or two shorter paragraphs.
- Build stories from aligned Chinese, pinyin, Vietnamese, and English sentence packets.
- Preserve one or two discoveries while ensuring each discovery adds information rather than repeats the story.
- Keep all three challenge modes, the three-attempt limit, the gold, silver, bronze, and fragment reward ladder, and four unique answer candidates.
- When the level changes on the challenge page, reset only the active level-dependent challenge state and regenerate its distractors, hints, explanations, and narration.

## Quality and release guardrails

- `main` remains untouched until founder approval.
- `PhoenixJourneyContentQualityAgent` inspects every published journey across all ten Phoenix levels before a preview may deploy.
- The expected release matrix is eight published journeys × ten Phoenix levels = eighty journey-level inspections.
- A critical issue, warning, missing multilingual annotation, duplicated discovery, invalid vocabulary entry, or failed level rule blocks release.
- Flutter tests cover persistence, legacy migration, level boundaries, plus/minus interaction, immediate journey refresh, challenge rebuilding, and every journey at every Phoenix level.
- Node product rules prevent the modal exam picker, legacy journey selector, or partial-page-only level control from returning.
