# Phoenix Failure Lessons

## 2026-08-25 — Shanghai Bund V3 validation capture helper

- **Classification:** HARNESS / PATCH-MECHANISM FAILURE.
- **Workflow:** `Shanghai Bund Preserve-First Verify V3`.
- **Run / job:** `32814724621` / `97700622623`.
- **Failed step:** `Capture helper generator outside repository tree`.
- **Observed failure:** the validation wrapper required one exact multi-line Shanghai prompt block and exited with `expected one Shanghai prompt block` when that brittle capture target was not matched exactly once.
- **Cost consequence:** validation stopped before the exact-base reset, Flutter setup, dependency installation, Shanghai targeted tests, Analyze, and Full Flutter Test. The expensive product test stages never started.
- **Product evidence:** none. No learner-product test had executed, so the failure could not be used as evidence to modify Shanghai product code or UI.

### Rule

A failure in helper capture, helper rewriting, patch generation, patch application, or validation orchestration is a harness failure until a product test running against the intended exact product diff produces product-failure evidence. Never change learner product behavior to satisfy a broken validation mechanism.

### Cheap preflight

Before Flutter setup or dependency installation, validation must:

1. capture the helper outside the repository tree;
2. require every intended helper-patch target to match **exactly once**;
3. prefer the smallest unique structural or line target over brittle multi-line block matching;
4. apply the helper-only patch;
5. run `python3 -m py_compile` on the captured helper;
6. stop immediately and classify the result as HARNESS / PATCH-MECHANISM FAILURE if any target matches zero or multiple times, or if compilation fails.

Only after this preflight passes may the workflow spend time on Flutter setup, dependencies, targeted contracts, Analyze, or the full test suite.

### Applied correction

The V3 capture logic was narrowed from an exact multi-line Shanghai prompt block to a unique prompt-line replacement with an explicit `count == 1` guard, followed by Python compilation. This is the cheap preflight boundary for this validation path.

## 2026-08-25 — Shanghai Bund browser interaction mode mismatch

- **Classification:** HARNESS / BROWSER-INTERACTION FAILURE.
- **Workflow / run / job:** `Reference Journey E2E` / `32821905863` / `97721629985`.
- **Failed step:** `Verify Shanghai Bund Chromium and WebKit six-stage journey`.
- **Failure:** the Shanghai browser harness used universal `locator.tap()` activation for both desktop Chromium and touch WebKit.
- **Observed evidence:** Forbidden City Lv1/Lv3/Lv5/Lv8/Lv10 six-stage, Story Reading Support, iPhone 13 WebKit startup, Discovery depth, and exact preview SHA all passed first. Shanghai then failed on Chromium Lv1 at the first semantic button with `The page does not support tap. Use hasTouch context option to enable touch support.` No Shanghai learner stage had executed.
- **Product evidence:** none. The failure occurred in browser input dispatch before Shanghai Story, Vocabulary, Discovery, Challenge, Memory, or Completion could run.

### Root cause

The browser harness modeled semantic targets but failed to model browser interaction capability separately. Desktop Chromium was created without touch capability, correctly representing desktop evidence, while the harness still issued a touch-only `tap()` action.

### Correct fix

Use one explicit semantic activation abstraction with browser mode registration:

- desktop Chromium → click semantics;
- mobile WebKit with touch context → tap semantics.

All semantic activation sites must use the same abstraction, including ordinary buttons, grammar-repair segment selection, and challenge option selection.

### Forbidden fix

- Do **not** enable `hasTouch` on desktop Chromium merely to make `tap()` pass. That would mutate the evidence mode instead of fixing the harness.
- Do **not** modify learner product, Shanghai content, UI, screens, widgets, navigation, or routing to accommodate a browser-harness capability bug.

### BROWSER MODE PREFLIGHT

Before expensive multi-level browser E2E, every browser mode must prove one stable semantic interaction against the intended exact preview:

1. desktop interaction path: Chromium desktop, no synthetic touch capability, activate a stable semantic button through `click`, and verify the expected next semantic state;
2. mobile touch interaction path: WebKit mobile with touch capability, activate the same class of stable semantic button through `tap`, and verify the expected next semantic state.

Run JavaScript syntax validation first. Only when both browser-mode interaction paths pass may the harness start multi-level Story → Vocabulary → Discovery → Challenge → Memory → Completion E2E.