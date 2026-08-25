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