# Phoenix Journey Content Quality Agent

`PhoenixJourneyContentQualityAgent` is a deterministic **automated content-contract gate**. It is not the release authority for literary quality, human Story differentiation, Founder approval, or Gold promotion.

The binding Story-quality authority remains the combination of:

- `docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md`;
- `docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md` where applicable;
- `docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md` and the current acceptance matrices;
- `ai/AI_BEHAVIOR.md`;
- the canonical semantic fingerprint registry for Rule A / Rule B;
- explicit Founder approval where required.

## Automated decisions

The deterministic agent may return:

- `approved`: automated content-contract checks pass; the content is **eligible to enter human/Founder review**;
- `needsRevision`: one or more automated improvement findings remain;
- `blocked`: one or more automated blocking findings remain.

`approved`, `isPublishable`, and `canPublish` are legacy/runtime names whose scope is strictly the automated content gate. They MUST NOT be read or reported as `STORY QUALITY PASS`, `NARRATIVE QUALITY PASS`, `GOLD READY`, or Founder approval.

## Separate authority states

Every Story-quality report must keep these states distinct:

```text
MACHINE_CONTENT_GATE: PASS / FAIL
MACHINE_SEMANTIC_GATE: PASS / FAIL
AGENT_SEMANTIC_SUFFICIENCY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
AGENT_LITERARY_REVIEW: PASS / REQUIRES_REVISION / BLOCKED / PENDING
HUMAN_NARRATIVE_ANTI_TEMPLATE: PASS / REQUIRES_REVISION / BLOCKED / PENDING
FOUNDER_STORY_APPROVAL: APPROVED / REJECTED / PENDING
OVERALL_STORY_QUALITY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
AUTOMATED_SCORE_USED_AS_LITERARY_APPROVAL: NO
```

Rule A = 0 and Rule B = 0 establish only the machine semantic-collision result. They do not establish human-reader differentiation.

## What the deterministic agent reviews

The agent runs across the configured Phoenix Journey catalog and language levels. Depending on current implementation it may review:

- approved character ranges and paragraph shape;
- required structural fields and content presence;
- opening/closing contract signals implemented by code;
- pinyin, Vietnamese, and English alignment checks implemented by code;
- Discovery novelty/depth checks implemented by code;
- vocabulary validity and duplication;
- separation between comprehension and expression prompts;
- special-Journey genre signals;
- exact duplication and other deterministic content rules.

The report must state the exact implemented scope rather than imply natural-language understanding that the code does not possess.

## What the deterministic agent cannot prove

Automated green status cannot prove:

- that a protagonist feels alive;
- that a Goal matters for a human reason;
- that a Relationship is emotionally or causally meaningful;
- that a Choice carries a real cost;
- that a climax is more than a revised method succeeding;
- that Chinese prose feels natural rather than engineered;
- that exposition is artistically restrained;
- that a Story contains a memorable human moment;
- that Story Shape is genuinely different to a reader;
- that a de-skinned Story spine does not collide with an approved Gold Story;
- that Lv5 works as literature;
- that Lv10 deepens rather than inflates;
- that removing the final explanation improves the ending;
- that Founder approved the exact candidate.

Those are Agent/human/Founder review responsibilities defined by the canonical Story standards and design matrix.

## Human literary and anti-template handoff

After the automated content gate and machine semantic gate pass, the Story must still complete the human gates in `PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md`, including:

- protagonist humanity;
- relationship deletion test;
- human stakes;
- Cost of Choice Review;
- climax-quality review;
- behavioral transformation;
- Story Memory Moment;
- Story Shape;
- de-skinned Story Spine against every current Founder-approved Gold Story;
- nearest Story collision;
- Chinese narrative quality;
- exposition / AI case-study tone risk;
- Lv1 Human Story Proof;
- Lv5 primary literary review;
- Lv10 deepen-not-inflate review;
- LAST_EXPLANATION_REMOVAL_TEST.

A human Story collision blocks Gold readiness even when deterministic semantic collision arithmetic is green.

## Visible PR report

`app/tool/generate_journey_quality_report.dart` must expose the automated gate separately from pending human/Founder states. A clean automated report should use language equivalent to:

`AUTOMATED CONTENT GATE: PASS — ELIGIBLE FOR HUMAN REVIEW`

It must not say that machine green alone authorizes release or Gold Story acceptance.

## CI enforcement

CI may enforce deterministic contract failures and may verify that required human-review records/states exist. CI must not hard-code literary approval or claim that string presence, scores, test counts, or enum arithmetic independently prove literary quality.

A valid build may be machine-green while `OVERALL_STORY_QUALITY = PENDING` because human literary review or Founder review is still pending. That is a truthful state, not a CI failure by itself unless the current workflow phase explicitly requires those approvals.
