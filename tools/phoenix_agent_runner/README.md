# Phoenix Agent Runner

The Phase A Runner is a dependency-free Node.js ESM tool for deterministic, read-only governance checks.

## Commands

- `node src/cli.mjs validate-config --root <repository-root>`
- `node src/cli.mjs audit --root <repository-root> --task <task-contract.json> --changed-paths-file <paths.txt> --output-dir <dir>`
- On GitHub Actions pull-request events, omit `--task` and provide `--event "$GITHUB_EVENT_PATH"`; the Runner extracts the JSON contract between the Phoenix Task Contract markers in the PR body.

## Guarantees

- It accepts only `READ_ONLY_AUDIT` and `GOVERNANCE_DOCUMENTATION`.
- It does not modify audited files, Commit, Push, comment, Ready, Merge, deploy, or delete Preview resources.
- It uses no external AI or third-party package.
- `AI Review Result` is `NOT_RUN` unless an independently authorized future system actually performs that review.
- A HARD_GATE failure returns a non-zero process exit code.
- A deterministic PASS never claims complete product approval.
