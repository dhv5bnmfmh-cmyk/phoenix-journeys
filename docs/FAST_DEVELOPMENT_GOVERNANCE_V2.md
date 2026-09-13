# Phoenix Journeys Fast Development Governance V2

## Purpose

Validate each risk once, at the right time. Product quality, Founder acceptance, exact-head discipline, complete release regression coverage, build integrity, and deployed-artifact verification are not reduced.

This governance is infrastructure. Normal feature work uses it and does not reopen a full governance audit unless pipeline architecture materially changes, a governance regression is proven, a new platform/build system is introduced, or the Founder explicitly requests a new audit.

## Two-speed model

### Level 1: fast development feedback

Normal iteration:

`change -> focused tests -> flutter analyze -> push`

Run from the repository root:

`./.github/scripts/run_fast_feedback.sh <base-ref>`

The selector is deliberately small and explicit. It does not attempt to replace the final regression suite.

### Level 2: exact release candidate

Every exact Preview candidate keeps the complete safety net:

`Preflight -> Analyze once -> Full Flutter once -> Quality aggregation -> Build once -> Worker/artifact validation -> Deploy same artifact -> Smoke verify exact release -> Publish`

Quality consumes evidence produced by the one Full Flutter run. It does not rerun Analyze, Flutter tests, or Build.

## Change risk

- LOW: visual style, color, spacing, copy, isolated asset reference. Focused widget/regression tests plus Analyze when Dart changes.
- MEDIUM: widget behavior, challenge mechanics, feature logic, state transitions local to a feature. Focused unit/widget/integration tests plus Analyze.
- HIGH: narration synchronization, audio, persistence, navigation/startup, shared state, content engine, deployment/build architecture. Focused tests plus the relevant scoped specialized check and Analyze.

The exact release candidate still receives Full Flutter once regardless of development risk class.

## Affected-test mapping

| Code area | Fast tests | Risk |
| --- | --- | --- |
| `InteractiveStoryText` | `story_discovery_no_yellow_dots_test.dart`, `founder_real_device_ux_test.dart` | LOW unless synchronization behavior changes |
| HSK challenge / Sentence Rebuild / Grammar / Completion engine | gold challenge contract tests, Forbidden City lifecycle consistency | MEDIUM |
| Narration controller / follow coordinator / narration controls | narration contract + compact progress + Founder UX regression | HIGH |
| App state / persistence | daily Journey state + access slots + lifecycle consistency | HIGH |
| App shell / Explore / Journey navigation / Passport / progress header | entry widget + passport + Founder UX regression | HIGH |
| Forbidden City / adaptive content engine | City Standard + backlog + lifecycle consistency | HIGH |

When a Founder-confirmed bug is practical to automate, its focused regression test becomes part of this mapping. The Story/Discovery yellow vocabulary contract is the current example: yellow emphasis present, dotted decoration absent, outer narration frame absent.

## Specialized workflow ownership

Specialized browser/performance workflows are path-scoped to unique risks and remain manually dispatchable when a developer needs extra evidence.

- Startup Performance: startup shell, startup metadata/probe, Explore/Journey entry paths, web bootstrap, and startup measurement harnesses.
- Mobile Interaction: app shell, Explore/Journey/Passport navigation, state/level controls, city picker/progress navigation, web bootstrap, and its mobile harness.
- Reference Journey E2E: Forbidden City stage flow, adaptive/content engine, challenge mechanics, state, narration controller, progress/finale controls, Forbidden City assets, and its reference harnesses.

A pure `InteractiveStoryText` style change does not automatically buy three browser suites. Its focused regression and final Full Flutter protect the visual contract. A real narration/navigation/content-engine change still triggers the appropriate specialized risk check.

Workflow-only and harness-only changes receive lightweight Governance Static Validation. They do not require unrelated product E2E unless the changed harness itself owns that E2E.

## Failure handling

Use the first useful failure:

`FIRST FAILURE -> CLASSIFY -> MINIMAL ROOT-CAUSE FIX -> CONTINUE`

Classify as one of:

- REAL PRODUCT FAILURE
- HARNESS / TEST FAILURE
- DEPLOY / INFRA FAILURE

Do not rerun blindly, repair unrelated warnings, regenerate product work, or reopen this governance audit. Failure evidence should expose the failing test/check, first useful assertion, expected/actual where available, file or project stack, and relevant log artifact.

## Artifact identity

The release web artifact is built once in the Preview job. Wrangler dry-run validates the generated bundle without rebuilding Flutter. Deployment runs from the same checked-out exact SHA and same `app/build/web`, then `/api/health?commit=<sha>` must report the exact release before publish status is emitted.

Caches may accelerate deterministic SDK/package setup, but no final application artifact is reused across different exact SHAs as a substitute for Build.
