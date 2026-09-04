# Contributing

The product acceptance source of truth is `docs/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md`. Tests implement the current product contract; legacy tests do not override Founder-approved behavior.

1. Create a focused branch and keep one feature or fix per pull request.
2. Add or update the smallest relevant tests. Record sources for factual content and licensing for every visual or audio asset.
3. Use the three validation levels below. Do not repeat an expensive suite on the same exact SHA without new evidence or a materially different environment.
4. Do not add ads, streak pressure, or content paywalls. Founder experience approval is required for core Journey changes. Merge requires explicit authorization.

## Validation levels

### Level 1 — Fast feedback

Use while developing a focused change:

- affected targeted tests;
- `flutter analyze` or the relevant static validation.

For isolated visual/copy changes such as border, background, spacing, shadow, color, copy, or small layout that do not change navigation, state/data models, Journey engine, persistence, Challenge logic, or content contracts, stop local validation here after the targeted checks pass. The PR release gate still runs the complete required suite once.

### Level 2 — PR release gate

For one exact candidate SHA:

`Preflight → Analyze → Full Flutter Test ONCE → Quality evaluation from that same test run → Worker bundle validation → Build ONCE`

Phoenix agent tests remain independent when applicable. A successful exact-head gate is reused; do not rerun it merely to obtain a newer timestamp.

### Level 3 — Deploy verification

After the release gate:

`Deploy built candidate → Verify exact deployed SHA + reachability/smoke → Publish Preview`

Do not rerun the Flutter suite during deploy verification.

## Failure triage and observability

Every failure is classified from direct evidence before code changes:

- `REAL PRODUCT FAILURE`
- `HARNESS / TEST FAILURE`
- `DEPLOY / INFRASTRUCTURE FAILURE`

Do not change product behavior for a harness failure. Full Flutter CI must preserve the complete test log and expose the first useful failure context in GitHub evidence so the test file/name, expected/actual values, and first useful project stack frame can be recovered without changing the workflow after failure.
