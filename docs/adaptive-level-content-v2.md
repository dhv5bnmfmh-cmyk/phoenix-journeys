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

## Guardrails

- `main` remains untouched until founder approval.
- Every journey keeps multilingual reading support aligned with the selected story sentences.
- HSK and TOCFL retain independent profile identities.
- The first-use prompt must remain optional, non-blocking, and limited to one appearance per stored preference cycle.
- The legacy in-journey difficulty menu must not return after the unified exam selector is enabled.
- Flutter tests and Node product-rule tests cover the published journey catalog, first-use guidance, and unified selector behavior.
