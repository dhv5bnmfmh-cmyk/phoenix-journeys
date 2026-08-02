# Phoenix Product Quality Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Stable baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines the minimum evidence and acceptance rules for Phoenix product quality. It applies to documentation, implementation, content, assets, Preview, audit, review, and release decisions.

All work MUST comply with [Phoenix Stable Baseline Standard](PHOENIX_STABLE_BASELINE_STANDARD.md):

> **NEW RESULT >= CURRENT STABLE BASELINE**

## 2. Canonical result states

Every evaluated requirement MUST use one result:

| Result | Meaning | Release effect |
|---|---|---|
| `PASS` | Requirement is satisfied and required evidence is VERIFIED. | May proceed if no other blocker exists. |
| `REQUIRES_REVISION` | Quality or completeness is insufficient but no verified stable-baseline downgrade has yet been established. | Blocks completion until revised and reverified. |
| `REGRESSION` | Candidate is below the current stable baseline in an applicable category. | Blocks Completed, Ready, merge, expansion, and next stage. |
| `BLOCKED` | Evaluation cannot proceed because a dependency, environment, permission, Preview, or evidence is unavailable. | Blocks completion and approval. |
| `NOT_APPLICABLE` | Requirement genuinely does not apply to the authorized scope. | Must include a reason; never used to hide missing evidence. |

## 3. Canonical evidence levels

Every material claim MUST use one evidence level:

| Evidence level | Meaning |
|---|---|
| `VERIFIED` | Direct, reproducible evidence supports the claim. |
| `PARTIALLY_VERIFIED` | Some direct evidence exists, but required coverage is incomplete. |
| `UNVERIFIED` | No adequate direct evidence is available. |
| `CONTRADICTORY` | Available evidence conflicts or disproves the claim. |

`PASS` requires `VERIFIED` evidence. Checkboxes, assertions, summaries, aggregate scores, compliance fields, file existence, and hashes are not sufficient by themselves.

## 4. Quality domains

### 4.1 Functional completeness

The candidate MUST:

- implement the authorized behavior completely;
- preserve stable features outside the task scope;
- expose the correct user entry points;
- handle valid, invalid, delayed, interrupted, and repeated actions;
- avoid dead controls, unreachable states, duplicated actions, and silent failure;
- verify entitlement and access behavior when applicable.

Missing stable behavior is `REGRESSION`.

### 4.2 Page completeness

Every affected page MUST verify:

- correct route and route parameters;
- correct page component;
- correct Journey ID, stage, and data source;
- complete header, body, controls, status states, and navigation exits;
- no blank, partially wired, or placeholder page;
- stable back navigation and state restoration.

### 4.3 Visual quality

Visual quality MUST meet [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md). PR `#137` is the minimum visual standard. Rights evidence, asset presence, dimensions, hashes, or successful loading do not establish visual approval.

### 4.4 Interaction quality

Interactions MUST be:

- understandable without hidden knowledge;
- responsive to tap, keyboard, and supported assistive input;
- protected against accidental duplicate submission;
- consistent across equivalent stages;
- reversible where the stable experience permits reversal;
- accompanied by visible feedback;
- free from unexpected focus loss, gesture conflict, or navigation trap.

### 4.5 Mobile quality

Mobile verification MUST include applicable small-screen layouts, safe areas, orientation policy, keyboard appearance, scrolling, tap targets, image crop, text wrapping, modal reachability, and system-bar overlap. Desktop Preview alone cannot produce `PASS` for mobile quality.

### 4.6 Performance

The candidate MUST NOT introduce a user-visible slowdown below the stable baseline. Evidence SHOULD cover applicable startup, route transition, first meaningful content, image decode, interaction response, animation stability, audio start, and persistence operations.

Measurements MUST state device, build, method, sample, and comparison condition. Unsupported precision or a context-free numeric score is prohibited.

### 4.7 Loading state

Every asynchronous user-visible operation MUST provide an appropriate loading state that:

- begins promptly;
- preserves layout stability where practical;
- identifies the operation when ambiguity is possible;
- prevents destructive duplicate actions;
- resolves into success, empty, error, or fallback;
- does not remain indefinitely without recovery.

### 4.8 Error state

Errors MUST:

- be visible and understandable;
- avoid exposing secrets or internal sensitive details;
- explain the affected action;
- preserve recoverable user input and progress;
- provide retry, back, or safe alternative where applicable;
- distinguish permanent, permission, validation, network, and service failures when user action differs.

### 4.9 Empty state

An empty state MUST be intentional, readable, and actionable. It MUST NOT resemble loading, failure, or a broken layout. It MUST explain why content is absent and what the user can do next when an action exists.

### 4.10 Failure fallback

Fallback behavior MUST:

- preserve core use when the product design permits;
- avoid routing to incorrect Journey, content, image, language, or entitlement;
- clearly indicate degraded behavior when user understanding is affected;
- return to the preferred path after recovery;
- never promote a low-quality placeholder into the release experience.

### 4.11 Accessibility

Applicable verification MUST include:

- semantic names, roles, values, and state changes;
- logical focus and reading order;
- keyboard and assistive navigation;
- text scaling and reflow;
- contrast and non-color cues;
- meaningful image alternatives;
- captions or equivalent treatment where required;
- reduced motion;
- touch target size and spacing;
- error identification and recovery.

An automated accessibility scan is supporting evidence, not complete user-experience proof.

### 4.12 Multilingual quality

All supported languages MUST maintain:

- complete and correctly routed content;
- meaning alignment across translations;
- correct script, punctuation, segmentation, and locale behavior;
- no mixed-language leakage unless intentionally authored;
- layout resilience for text expansion;
- correct language for narration, labels, errors, and accessibility text;
- synchronized identifiers and learning intent.

A change to one language MUST identify and verify all dependent language variants.

### 4.13 Content quality

Content MUST be accurate, coherent, purposeful, age-appropriate for the product, culturally grounded, and free of filler or repeated template language. Story, learning, discovery, challenge, reflection, writing, memory, completion, and reward content MUST serve distinct product functions.

Journey-specific requirements are defined in [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md).

### 4.14 Narration and audio

Applicable audio verification MUST cover:

- correct content and language;
- play, pause, resume, stop, replay, and interruption behavior;
- progress and highlight synchronization;
- speed and voice controls when provided;
- switching pages, stages, language, or audio source;
- headset, background, and system interruption behavior where supported;
- failure, retry, and silent-device handling;
- accessibility and non-audio alternatives;
- no overlapping unintended playback.

Repository inspection or successful file loading alone cannot establish audio experience `PASS`.

### 4.15 Progress and persistence

The candidate MUST preserve correct progress, completion, reward, entitlement, preferences, and resumable state. Verification MUST cover applicable restart, sign-out/sign-in, upgrade, migration, stale data, partial completion, and interrupted write behavior.

Data loss, cross-Journey contamination, incorrect unlock, or rollback of stable progress is `REGRESSION` and may be P0 or P1 depending on impact.

### 4.16 Privacy and secrets

The product MUST:

- collect and retain only authorized data;
- keep credentials and secrets outside client code and repository content;
- prevent sensitive information in logs, errors, analytics, screenshots, and Preview URLs;
- document external processors and data paths;
- avoid transmitting unpublished Phoenix content without explicit approval;
- enforce least privilege and appropriate retention.

### 4.17 External disclosure

Unpublished Phoenix content MUST NOT be sent to external translation, image, AI, analysis, or storage services unless the Founder has explicitly approved that service and disclosure scope. Public repository access does not automatically authorize republishing or processing through a new third party.

### 4.18 Technical validation

Technical validation MUST identify exact commands, environment, Commit, results, logs, and terminal status. Required checks depend on scope and MAY include analysis, tests, build, route/data validation, asset validation, link validation, CI, and security checks.

When no local execution environment exists, the report MUST state:

`NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT`

It MUST NOT convert unrun checks into `PASS`.

### 4.19 User-experience validation

User-experience validation MUST use reproducible routes and applicable real-device or representative Preview evidence. Founder mobile approval is mandatory for visual and core interaction changes. Automated validation cannot replace mobile experience evaluation.

## 5. Evidence requirements

Acceptable evidence includes one or more of:

- exact repository path;
- exact Commit SHA and Tree SHA;
- exact diff or file content;
- terminal command and complete relevant output;
- CI run ID, job ID, and terminal conclusion;
- reproducible Preview path;
- screenshot or video tied to a candidate Commit;
- measured comparison with stated method;
- Founder approval record tied to the candidate.

Evidence MUST be current, scoped, and attributable. Contradictory evidence blocks approval until resolved.

## 6. Decision rules

A task MUST NOT be Completed when:

- any mandatory domain is `REQUIRES_REVISION`, `REGRESSION`, or `BLOCKED`;
- required evidence is `PARTIALLY_VERIFIED`, `UNVERIFIED`, or `CONTRADICTORY`;
- the stable baseline comparison is missing;
- Founder approval is required but absent or pending;
- changed paths exceed authorization;
- CI or required validation has not reached a successful terminal state.

All completion decisions follow [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md).