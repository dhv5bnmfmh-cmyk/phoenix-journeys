# Phoenix Development Agent System

**Phase:** A, Read-only Governance and Audit Foundation  
**Status:** Founder Governance Review Required  
**Repository:** `dhv5bnmfmh-cmyk/phoenix-journeys`  
**Authorized Base:** `main` at `d13129dfe2a7a25ea27d2a8f6d9b4da99f4b59f5`

## 1. Purpose

Phase A converts the existing Phoenix standards into a specification-driven governance system that Agents can read, validate, and report without gaining product-code write authority.

This phase creates role manifests, machine-readable policies and schemas, a deterministic read-only Runner, a read-only GitHub Actions workflow, fixtures, and report formats. It does not enable autonomous remediation.

## 2. Normative authority

The Agent System extends and operationalizes the existing Phoenix standards. It does not replace or weaken them.

Primary sources:

- `docs/PHOENIX_STABLE_BASELINE_STANDARD.md`
- `docs/PHOENIX_PRODUCT_QUALITY_STANDARD.md`
- `docs/PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md`
- `docs/PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md`
- `.github/pull_request_template.md`

When a machine-readable rule conflicts with a binding source document, the source document controls and the registry must be corrected through an authorized governance change.

## 3. Phase A boundary

Allowed Task modes:

- `READ_ONLY_AUDIT`
- `GOVERNANCE_DOCUMENTATION`

Disabled pending separate Founder authorization:

- `AUTHORIZED_REMEDIATION`
- `RUNTIME_DEVELOPMENT`
- `VISUAL_REMEDIATION`

The Phase A Runner must not modify audited code, Commit, Push, create comments, edit a PR, move a PR to Ready, Merge, enable auto-merge, Release, deploy Production, delete a Preview, delete a Branch, or start a next phase.

No external AI, external translation, image generation, or external repository-processing service is called by the Runner.

## 4. Agent roles

| Agent | Phase A status | Responsibility |
|---|---|---|
| PhoenixGovernorAgent | `ACTIVE_READ_ONLY` | Validate identity, Task Contract, scope, drift, and governance gates. |
| PhoenixPlannerAgent | `ACTIVE_READ_ONLY` | Map Founder authorization to rules, paths, tests, evidence, and stop conditions. |
| PhoenixBuilderAgent | `DISABLED_PENDING_FOUNDER_AUTHORIZATION` | Future implementation under an approved Task Contract. |
| PhoenixVerifierAgent | `ACTIVE_READ_ONLY` | Prove deterministic checks only. |
| PhoenixAuditAgent | `ACTIVE_READ_ONLY` | Independently inspect actual Diff and evidence and produce Findings. |
| PhoenixRemediationAgent | `DISABLED_PENDING_FOUNDER_AUTHORIZATION` | Future repair of specifically authorized Findings. |

## 5. Permanent separation of duties

The system permanently enforces:

- Builder cannot approve its own work.
- Remediator cannot close its own Finding.
- Verifier proves deterministic checks only.
- Audit Agent independently reads the actual Diff.
- CI PASS does not equal AI Audit PASS.
- AI Audit PASS does not equal Founder Experience PASS.
- Founder Experience PASS does not equal Ready Authorization.
- Ready Authorization does not equal Merge Authorization.
- Merge Authorization does not equal Preview deletion or next-phase authorization.
- No Agent may simultaneously act as Developer, Final Auditor, and Merge Authority.

## 6. Task Contract

A Task Contract binds work to exact repository and candidate identity, authorized paths, applicable rules, evidence, prohibited actions, and Founder gates.

The Runner rejects unsupported Phase A modes with:

`MODE_DISABLED_PENDING_FOUNDER_AUTHORIZATION`

A changed path outside the contract produces:

`SCOPE_EXPANSION_REQUIRED`

The Runner never transfers authorization to a new Base or Head.

## 7. Finding and Evidence model

Findings use the canonical Phoenix Result and Evidence Level values. Findings are never automatically closed in Phase A.

Evidence is typed as repository, commit, diff, test, CI, Preview, mobile, AI review, or Founder evidence. PASS evidence must bind to the exact current Candidate SHA. Old-SHA evidence may remain historical but cannot support a new Head.

## 8. Runner decision layers

Every report separates:

1. **Deterministic Result**
2. **AI Review Result**
3. **Founder Gate Result**
4. **Final Agent Decision**

When no AI review actually runs:

`AI Review Result: NOT_RUN`

A deterministic PASS is not a complete product PASS. The successful Phase A terminal decision is:

`DETERMINISTIC_GATES_PASS_FOUNDER_GOVERNANCE_REVIEW_REQUIRED`

## 9. GitHub Actions boundary

`.github/workflows/phoenix-agent-audit.yml` uses only:

```yaml
permissions:
  contents: read
  pull-requests: read
```

It checks out the exact Candidate Head, validates JSON and manifests, runs Runner tests, executes the read-only audit, uploads the report artifact, and writes a Step Summary.

It does not comment, modify the PR body, create a Commit, access Production Secrets, call external AI, deploy, delete Preview resources, Ready, or Merge.

## 10. Phase transition

Phase B requires a separate Founder authorization. Phase A does not prove that Builder or Remediator write capability is enabled, safe, or approved.

**Founder Product Preview:** `NOT_REQUIRED`  
**Founder Governance Review:** `REQUIRED`  
**Ready Authorization:** `NOT_PRESENT`  
**Merge Authorization:** `NOT_PRESENT`  
**External disclosure:** `NOT_PERMITTED / NONE / NO`
