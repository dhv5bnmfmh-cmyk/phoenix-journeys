# Phoenix Candidate Evidence

> Single entry contract: `docs/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md`. Do not copy old checklists into this PR. Evidence, not checkbox volume, decides acceptance.

## 1. Identity and authorization

- STARTING_MAIN_SHA: `<full sha>`
- Candidate SHA: `<full sha>`
- Candidate Tree: `<full sha>`
- Parent SHA: `<full sha>`
- Authorized scope: `<exact scope>`
- AUTHORIZED_JOURNEY_SET: `<IDs or EMPTY>`
- Changed paths: `<exact added / modified / deleted paths>`
- UI change authorized: `YES / NO`
- Visual/core interaction change: `YES / NO`
- External disclosure of unpublished content: `YES / NO`

`NO UI AUTHORIZATION` means current `main` UI must remain unchanged.

## 2. Scope isolation

```text
AUTHORIZED_JOURNEY_DELTA = EXPECTED / UNEXPECTED
SHARED_INFRASTRUCTURE_DELTA = NONE / EXPECTED / UNEXPECTED
OTHER_JOURNEY_CONTENT_DELTA = NONE / FOUND
JOURNEY_SCOPE_LEAKAGE = NONE / FOUND
```

Any unauthorized learner-visible delta blocks Ready and merge.

## 3. Journey content gate, when Journey content is touched

Record evidence, not just PASS words.

| Area | Result | Evidence |
|---|---|---|
| Story narrative + place causality |  |  |
| Lv1-Lv10 substantive progression |  |  |
| Vocabulary CURRENT-level provenance |  |  |
| Discovery grounded / non-retell |  |  |
| Challenge 3 modes + teach-before-test + one best answer |  |  |
| Memory current-level closure |  |  |
| Completion current-level closure |  |  |
| ReadingAnnotation source/Pinyin/native language/English alignment |  |  |
| Historical/cultural source verification |  |  |
| Cross-Journey anti-template review |  |  |
| Human literary/semantic review |  |  |

Automated structural result and human literary/semantic result must remain separate. Aggregate score cannot approve Story quality.

## 4. Failure history

For every material failure repaired on this candidate line:

```text
Failure:
Classification: REAL PRODUCT / HARNESS-TEST / DEPLOY-INFRA
Direct evidence:
Changed paths:
Why the fix matches the classification:
Regression protection added:
```

Do not change product/UI for a harness failure.

## 5. Exact-head technical evidence

| Gate | Candidate SHA | Run / evidence | Result |
|---|---|---|---|
| Phoenix Agent / Node |  |  |  |
| Flutter Analyze |  |  |  |
| Flutter Test |  |  |  |
| Web Build |  |  |  |
| Worker bundle |  |  |  |
| Content Quality |  |  |  |
| Preview Deploy |  |  |  |
| Health / Release SHA |  |  |  |

A run from another SHA is historical evidence only.

## 6. Browser / mobile evidence

- Preview URL: `<bare reproducible URL>`
- Deployed SHA: `<full sha>`
- Desktop required levels/stages: `<result + run>`
- ReadingAnnotation browser verification: `<result + run>`
- Mobile WebKit / target phone bare startup: `<result + run>`
- Journey-specific mobile depth/interaction gate: `<result + run>`
- pageErrors / failedRequests blocking defects: `<NONE / evidence>`

For the Reference Journey, preserve Lv1/Lv3/Lv5/Lv8/Lv10 six-stage proof, current-level Annotation proof, and Mobile Discovery `2/2/2/2/3/3/3/3/3/3`.

## 7. Stable baseline comparison

Before Ready, include the canonical `STABLE_BASELINE_COMPARISON` required by `docs/PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md`. Do not invent a shorter substitute when that standard applies.

- Stable comparison result: `PASS / REQUIRES_REVISION / REGRESSION / BLOCKED`
- Unexpected regression: `NONE / details`
- Evidence level: `VERIFIED / PARTIALLY_VERIFIED / UNVERIFIED / CONTRADICTORY`

## 8. Final exact-head lock

```text
FINAL_PR_HEAD =
TESTED_HEAD =
DEPLOYED_SHA =
HEAD_DRIFT = NONE / FOUND
```

All three identities must match for final candidate delivery.

## 9. Founder decision

- Founder Preview required: `YES / NO`
- Founder Preview result: `APPROVED / REJECTED / PENDING / NOT_REQUIRED`
- Founder approval evidence: `<exact record>`
- Explicit Ready authorization: `YES / NO`
- Explicit Merge authorization: `YES / NO`

No silence-based approval. No merge without explicit authorization.
