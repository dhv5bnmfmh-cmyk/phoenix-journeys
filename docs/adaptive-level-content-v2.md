# Adaptive Level Content V2

Base: `main@7d5a7b6ec767dcb9807396239e4464da6ddb8510`

## Scope

- Apply the saved HSK or TOCFL profile to every regular and special journey.
- Build story reading from aligned Chinese, pinyin, Vietnamese, and English sentence packets.
- Keep the approved reading shape: one deep paragraph or two shorter paragraphs.
- Adjust discoveries, vocabulary selection, reflection prompts, and writing prompts together.
- Expose one global level selector in the active Passport header.
- Expose the same HSK and TOCFL selector inside every journey, not only the Summer Palace journey.
- Apply a newly selected profile immediately to the current journey, stop outdated narration, clear stale AI feedback, and reset the active challenge.
- Show first-time explorers one non-blocking prompt when no exam profile exists, with a direct action to open the existing HSK or TOCFL picker.
- Persist the prompt state so it does not interrupt later journeys; saving a profile also suppresses the prompt.
- Keep the legacy three-level catalog only as a safe fallback until an explorer selects an exam profile.
- Give every adaptive challenge five candidate answers, with closer content-based distractors at higher levels.
- Rank distractors by distance from the correct answer length, remove duplicate candidates, and keep a common minimum option-card height so answer length does not reveal the solution.
- Adapt both challenge hints by level: beginner guidance is direct, standard guidance preserves the complete learning path, and advanced guidance emphasizes discourse structure, reference chains, and logical relationships.
- Adapt challenge explanations and memory tips by level; advanced grammar repair adds a dedicated structure-analysis line while beginner grammar repair keeps only the essential correction steps.

## Guardrails

- `main` remains untouched until founder approval.
- Every journey keeps multilingual reading support aligned with the selected story sentences.
- HSK and TOCFL retain independent profile identities.
- The first-use prompt must remain optional, non-blocking, and limited to one appearance per stored preference cycle.
- The legacy in-journey difficulty menu must not return after the unified exam selector is enabled.
- Every challenge mode must keep five unique candidates while preserving the three-attempt reward ladder.
- Candidate balancing must never truncate the answer text or introduce a duplicate of the correct answer.
- Adaptive teaching support must not change the correct answer, the three-attempt limit, or the gold, silver, bronze, and fragment reward ladder.
- Flutter tests and Node product-rule tests cover the published journey catalog, first-use guidance, unified selector behavior, five-option challenges, answer-length balancing, and level-adaptive challenge pedagogy.
