# Phoenix Full Application Audit Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the required method for a read-only, evidence-based audit of the complete Phoenix application. The audit begins only after the Product Standard System is approved and merged. It does not authorize fixes, runtime changes, new Journeys, or visual replacement.

## 2. Audit principles

The audit MUST:

- start from the latest approved stable `main`;
- use PR `#137` and Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977` until a later baseline is explicitly approved;
- remain read-only unless a separate repair task is authorized;
- distinguish repository evidence, automated evidence, Preview evidence, mobile evidence, and Founder approval;
- record uncertainty instead of guessing;
- compare current candidate behavior with the stable baseline;
- avoid treating PR `#132` or closed PRs `#138`–`#141` as the current baseline;
- use the matrix in [Phoenix Full Application Audit Matrix](templates/PHOENIX_FULL_APPLICATION_AUDIT_MATRIX.md).

## 3. Mandatory audit scope

The audit MUST cover, where present:

- all routes;
- all major pages;
- all normal Journeys;
- all special Journeys;
- all learning stages;
- all runtime images and asset mappings;
- all narration and audio flows;
- all supported languages;
- free and paid states;
- locked and unlocked states;
- Random / Daily Journey Access;
- loading states;
- error states;
- empty states;
- fallback states;
- small-screen layouts;
- safe-area behavior;
- reduced-motion behavior;
- progress and persistence;
- migration behavior;
- privacy and secrets;
- external disclosure;
- current stable-baseline comparison.

An item omitted from coverage MUST be recorded as `BLOCKED` or `NOT_APPLICABLE` with a reason and evidence. Silence is not coverage.

## 4. Audit preparation

Before reviewing product behavior, the auditor MUST record:

- repository;
- audited branch and Commit;
- audited Tree when available;
- stable PR and Commit;
- PR or candidate identity, if any;
- authorized read-only scope;
- available environments;
- available CI and Preview evidence;
- supported devices and viewport plan;
- supported language list;
- Journey inventory;
- route inventory;
- known entitlement states;
- Random / Daily Journey Access configuration and test identities;
- known limitations and inaccessible evidence.

If repository, Commit, stable baseline, or scope cannot be established, the audit is `BLOCKED`.

## 5. Audit units

Each audit row MUST represent one independently verifiable requirement. Do not combine unrelated failures into a single row.

Every final audit row MUST include:

- Audit ID;
- Area;
- Route;
- File Path;
- Journey ID;
- Stage;
- Standard Requirement;
- Stable Evidence;
- Candidate Evidence;
- Expected;
- Actual;
- Result;
- Issue Severity;
- Evidence Level;
- Issue;
- Required Action;
- Owner;
- Verification;
- Founder Approval Required.

Use `NONE` or `NOT_APPLICABLE` explicitly when a field does not apply. Blank Issue Severity is prohibited in a final audit record.

## 6. Result states

Use only:

- `PASS`;
- `REQUIRES_REVISION`;
- `REGRESSION`;
- `BLOCKED`;
- `NOT_APPLICABLE`.

`PASS` requires `VERIFIED` evidence. `NOT_APPLICABLE` requires an applicability reason and evidence and is not `PASS`. A finding below the stable baseline MUST be `REGRESSION`, even when it also violates a new standard.

## 7. Evidence levels

Use only:

- `VERIFIED`;
- `PARTIALLY_VERIFIED`;
- `UNVERIFIED`;
- `CONTRADICTORY`.

Evidence MUST identify its source and candidate Commit. A screenshot without route, state, and candidate identity is incomplete. A test without command, output, and Commit is incomplete. A rights record without runtime and visual evidence cannot approve the visual result.

Evidence Level and Issue Severity are separate fields and MUST NOT substitute for one another.

## 8. Issue Severity

Allowed Issue Severity values are:

- `NONE`
- `P0`
- `P1`
- `P2`
- `P3`

`NONE` is not a fifth problem severity. It means the row contains no identified Issue.

| Issue Severity | Definition | Required response |
|---|---|---|
| `NONE` | No Issue is identified for the row. Required for `PASS` and `NOT_APPLICABLE`. | Do not include in P0/P1/P2/P3 counts. |
| `P0` | Critical safety, privacy, secret exposure, severe data corruption/loss, unusable core application, or release-wide failure. | Immediate block. No release or unrelated expansion. Isolate risk and authorize a dedicated repair. |
| `P1` | Major core flow, access, payment/entitlement, routing, persistence, widespread visual/interaction regression, or major accessibility failure. | Blocks Ready and merge. Repair before P2/P3 improvement work. |
| `P2` | Material quality, consistency, content, performance, visual differentiation, or localized functional problem that harms the product but does not meet P0/P1. | Record and prioritize after P0/P1 according to roadmap. |
| `P3` | Minor wording, polish, local spacing, low-impact consistency, or maintainability issue with no material user harm. | Record and schedule without masking higher severity. |

Rules:

1. When `Result = PASS`, `Issue Severity` MUST be `NONE`.
2. When `Result = NOT_APPLICABLE`, `Issue Severity` MUST be `NONE`, and the row MUST include the applicability reason and evidence.
3. When `Result = REQUIRES_REVISION`, `REGRESSION`, or `BLOCKED` and an Issue exists, `Issue Severity` MUST be `P0`, `P1`, `P2`, or `P3`.
4. A PASS row MUST NOT be assigned a fabricated `P3`.
5. `NONE` MUST NOT be counted in P0/P1/P2/P3 totals.
6. Blank Issue Severity is prohibited in final audit records.
7. Issue Severity is based on impact, reach, recoverability, and stable-baseline loss, not effort to fix.

## 9. Route audit

For every route, verify:

- route exists and is reachable through the intended entry;
- parameters and Journey IDs are validated;
- the correct page component opens;
- invalid or missing parameters fail safely;
- back, deep-link, refresh, and restore behavior are correct where supported;
- entitlement and unlock state are enforced;
- loading, error, empty, and fallback states are defined;
- route does not load content or assets from another Journey;
- route matches or exceeds the stable behavior.

## 10. Major page audit

Audit Home, Explore, Passport, Profile, Shadowing, and all other major pages for:

- complete function and navigation;
- correct hierarchy and components;
- loading, error, empty, and fallback;
- small-screen and safe-area behavior;
- text scaling and accessibility;
- performance and state restoration;
- multilingual behavior;
- stable-baseline visual and interaction comparison.

## 11. Journey audit

For every normal and special Journey, verify all `REQUIRED` and applicable `CONDITIONALLY_REQUIRED` elements in [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md), including:

- identity and IDs;
- protagonist, relationship, goal, conflict, choice, consequence, emotional arc, and cultural anchor;
- Story, Vocabulary, ReadingAnnotation applicability, Discovery, Challenge, Reflection, Writing, Memory, Completion, Reward, and Stamp applicability;
- multilingual alignment;
- visual differentiation and mobile crop;
- narration and audio;
- progression and persistence;
- routing and fallback;
- rights evidence;
- stable-baseline comparison.

The audit MUST detect repeated story templates, repeated visual compositions, generic city substitution, and shared fantasy mechanisms that erase special-Journey independence.

## 12. Runtime image audit

For every runtime image or visual mapping, verify:

- exact path and referencing code/data path;
- intended route, Journey, and stage;
- file type, dimensions, and technical validity;
- actual runtime load and crop;
- focal point and readable region;
- visual quality and differentiation;
- loading and failure fallback;
- rights evidence;
- stable-baseline visual comparison;
- Founder approval record when required.

File existence, hash, or compliance metadata alone cannot produce `PASS`.

## 13. Narration and audio audit

For every supported narration or audio flow, verify:

- correct language, text, and stage;
- play, pause, resume, stop, replay, speed, and voice behavior where available;
- highlight and progress synchronization;
- temporary vocabulary or annotation playback and correct continuation;
- route changes and system interruptions;
- error, retry, offline, and silent-device behavior;
- no unintended overlap;
- accessibility and non-audio alternative;
- stable-baseline comparison.

## 14. Language audit

For every supported language, verify:

- UI completeness;
- correct locale and script;
- Journey content completeness;
- meaning alignment;
- annotations and segmentation;
- narration language;
- challenge answer validity;
- accessibility labels;
- text expansion and layout;
- no unintended mixed-language leakage.

## 15. Access and entitlement audit

Verify applicable:

- free and paid behavior;
- locked and unlocked behavior;
- upgrade and downgrade behavior;
- entitlement restoration;
- direct-link protection;
- offline or stale entitlement handling;
- reward and Journey access consistency;
- no exposure of paid content through fallback or incorrect route;
- all access decisions use `JourneyAccessPolicy`.

### 15.1 Random / Daily Journey Access audit

Random / Daily Journey Access MUST be audited independently from generic free/paid and locked/unlocked coverage. Record:

- account state;
- Development / Preview / Production mode;
- stable user identifier or test identifier;
- local date;
- local timezone;
- morning / afternoon slot;
- generated Journey ID;
- expected Journey ID behavior;
- actual Journey ID behavior;
- same-slot refresh result;
- app restart result;
- re-login result;
- persistence result;
- morning and afternoon duplication result;
- Journey library size;
- configuration evidence;
- route;
- exact code or policy path;
- Result;
- Issue Severity when an Issue exists;
- Evidence Level.

The audit MUST verify:

1. The same user, local date, and slot produce a stable result.
2. Refresh does not redraw the Journey.
3. App restart does not redraw the Journey.
4. Re-login remains consistent with the approved design.
5. When the Journey library size is greater than one, morning and afternoon do not duplicate on the same day.
6. After the afternoon release, Journeys already released that day remain usable.
7. The logic is unified through `JourneyAccessPolicy`.
8. Development and PR Preview remain open under `developmentExperience` rules.
9. Commercial slot times and strategy remain configurable and are not hard-coded into Journey content.

Missing Random / Daily evidence is not covered merely because free/paid behavior passed.

## 16. State audit

Loading, error, empty, and fallback MUST be audited as separate states, not inferred from the success state. Each state must be reachable or supported by direct code and reproducible evidence.

Fallback MUST NOT silently substitute the wrong Journey, language, image, content, reward, or entitlement.

## 17. Mobile, safe area, and reduced motion audit

The audit MUST include representative small phones and supported target viewports. Verify:

- no overflow or clipping;
- safe-area compliance;
- keyboard reachability;
- tap areas and spacing;
- scrolling and persistent controls;
- image crop and focal point;
- text scaling;
- dialogs and sheets;
- reduced-motion alternatives;
- route and lifecycle stability.

Desktop-only evidence cannot fully verify mobile quality.

## 18. Persistence and migration audit

Verify applicable:

- partial progress save and resume;
- completion, reward, stamp, and unlock state;
- preference persistence;
- sign-out/sign-in and account changes;
- duplicate event handling;
- stale state and schema migration;
- Journey ID or content-version migration;
- failed write recovery;
- cross-Journey isolation;
- preservation of stable user data.

## 19. Privacy, secrets, and external disclosure audit

Verify:

- no secrets in repository, client, logs, errors, screenshots, or Preview URLs;
- approved data collection and retention;
- least-privilege access;
- external processors and data paths;
- no unauthorized external disclosure of unpublished Phoenix content;
- privacy behavior in analytics, AI, translation, image, and audio services;
- safe failure messages.

Any confirmed secret exposure or severe private-data leak is P0.

## 20. Stable baseline comparison

Every material audit area MUST compare the audited candidate with the stable baseline. Record:

- stable route, page, Journey, feature, or asset evidence;
- candidate evidence under equivalent conditions;
- expected preserved or improved behavior;
- actual result;
- any unexpected loss.

A full audit summary MUST use the report in [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md) when evaluating a development candidate.

## 21. Audit execution order

The approved order is:

1. establish inventories and evidence availability;
2. audit P0/P1 risk domains first: secrets, privacy, data, access, core routes, persistence, critical failures;
3. audit major pages and shared systems;
4. audit normal Journeys;
5. audit special Journeys;
6. audit visuals, audio, languages, accessibility, states, and Random / Daily Journey Access;
7. compare all material areas with stable baseline;
8. deduplicate findings without losing evidence;
9. create the P0/P1/P2/P3 ledger; `NONE` is excluded from severity counts;
10. stop. Do not fix without separate authorization.

## 22. Audit output

The audit output MUST contain:

- audit identity and scope;
- coverage inventory;
- completed matrix;
- evidence limitations;
- findings grouped by Issue Severity;
- stable-baseline regressions;
- blocked areas;
- exact recommended repair order;
- Founder approvals required;
- explicit statement that no fixes were made during a read-only audit.

No phase or audit area may be marked Completed without evidence. The roadmap in [Phoenix Quality Unification Roadmap](PHOENIX_QUALITY_UNIFICATION_ROADMAP.md) governs work after the audit.

## 23. Binding Narrative and Discovery audit extension

[Phoenix Narrative and Discovery Standard](PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) is binding for Story and Discovery audit coverage.

The audit MUST require one Story Function Contract and one Discovery Function Contract per Journey and MUST also verify:

- a complete library differentiation matrix;
- opening pattern review;
- ending pattern review;
- narrative-engine review;
- normal and special protagonist-mode review;
- Relationship causality;
- enacted Choice;
- Consequence causality;
- cultural anchor in action;
- climax and changed ending state;
- Story / Discovery functional separation beyond exact-text difference;
- Phoenix Lv.1 through Lv.10 narrative invariants;
- applicable special-mechanism preservation.

Automated scores cannot approve literary quality. The audit MUST separate:

```text
Automated Structural Result:
Automated Structural Evidence Level:
Implemented automated checks:
Human Literary Result:
Human Literary Evidence Level:
Human reviewer:
```

A structural field count, exact-duplication test, `360 / 360 PASS`, `score 100`, `average 100`, or `all fields present` proves only its implemented check. It MUST NOT create human literary PASS, close Story / Discovery functional overlap, or approve library differentiation.

Use [Phoenix Story / Discovery Design Matrix](templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md) for candidate design evidence and the Narrative and Discovery coverage rows in the Full Application Audit Matrix for audit results. Existing Issue Severity rules remain unchanged.
