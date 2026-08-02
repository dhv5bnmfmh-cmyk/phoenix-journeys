# Phoenix Full Application Audit Matrix

Use this template with [Phoenix Full Application Audit Standard](../PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md).

**Stable PR:** `#137`  
**Stable Commit:** `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## Audit identity

```text
Repository:
Audited Branch:
Audited Commit:
Audited Tree:
Stable PR:
Stable Commit:
Audit Scope:
Audit Mode: READ_ONLY
Available Environments:
Available Preview:
Auditor:
Started:
Completed:
```

## Allowed values

**Result:** `PASS` / `REQUIRES_REVISION` / `REGRESSION` / `BLOCKED` / `NOT_APPLICABLE`  
**Severity:** `P0` / `P1` / `P2` / `P3`  
**Evidence Level:** `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`  
**Founder Approval Required:** `YES` / `NO`

`PASS` requires `VERIFIED` evidence. A result below the stable baseline MUST be `REGRESSION`.

## Copyable audit table

| Audit ID | Area | Page or Route | File Path | Journey ID | Stage | Standard Requirement | Stable Baseline Evidence | Candidate Evidence | Expected | Actual | Result | Severity | Evidence Level | Issue | Required Action | Owner | Verification | Founder Approval Required |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| AUD-0001 |  |  |  |  |  |  |  |  |  |  | `BLOCKED` | `P2` | `UNVERIFIED` |  |  |  |  | `NO` |
| AUD-0002 |  |  |  |  |  |  |  |  |  |  | `BLOCKED` | `P2` | `UNVERIFIED` |  |  |  |  | `NO` |
| AUD-0003 |  |  |  |  |  |  |  |  |  |  | `BLOCKED` | `P2` | `UNVERIFIED` |  |  |  |  | `NO` |

## Row rules

1. Use one independently verifiable requirement per row.
2. Use exact repository paths, route names, Journey IDs, stage names, Commit SHAs, CI run IDs, and Preview paths.
3. Do not use “looks good,” “mostly correct,” numeric quality scores, or checkbox counts as evidence.
4. Use `NONE` or `NOT_APPLICABLE` explicitly rather than leaving a material field ambiguous.
5. Record stable evidence and candidate evidence separately.
6. A screenshot MUST identify route, state, viewport/device, and candidate Commit.
7. A command result MUST identify command, environment, Commit, output, and terminal status.
8. Rights evidence does not replace visual, content, audio, or mobile approval.
9. Desktop evidence does not fully verify mobile behavior.
10. A read-only audit MUST NOT modify product files.

## Coverage checklist

| Coverage area | Inventory source | Total expected | Audited | PASS | REQUIRES_REVISION | REGRESSION | BLOCKED | NOT_APPLICABLE | Evidence level | Notes |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|---|
| Routes |  |  |  |  |  |  |  |  |  |  |
| Major pages |  |  |  |  |  |  |  |  |  |  |
| Normal Journeys |  |  |  |  |  |  |  |  |  |  |
| Special Journeys |  |  |  |  |  |  |  |  |  |  |
| Learning stages |  |  |  |  |  |  |  |  |  |  |
| Runtime images |  |  |  |  |  |  |  |  |  |  |
| Narration/audio flows |  |  |  |  |  |  |  |  |  |  |
| Supported languages |  |  |  |  |  |  |  |  |  |  |
| Free/paid states |  |  |  |  |  |  |  |  |  |  |
| Locked/unlocked states |  |  |  |  |  |  |  |  |  |  |
| Loading states |  |  |  |  |  |  |  |  |  |  |
| Error states |  |  |  |  |  |  |  |  |  |  |
| Empty states |  |  |  |  |  |  |  |  |  |  |
| Fallback states |  |  |  |  |  |  |  |  |  |  |
| Small-screen/Safe Area |  |  |  |  |  |  |  |  |  |  |
| Reduced Motion |  |  |  |  |  |  |  |  |  |  |
| Persistence/Migration |  |  |  |  |  |  |  |  |  |  |
| Privacy/Secrets |  |  |  |  |  |  |  |  |  |  |
| External disclosure |  |  |  |  |  |  |  |  |  |  |
| Stable comparison |  |  |  |  |  |  |  |  |  |  |

## Severity ledger

| Issue ID | Audit IDs | Severity | User impact | Reach | Recoverability | Stable regression | Owner | Required action | Verification | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| ISSUE-0001 |  | `P0/P1/P2/P3` |  |  |  | `YES/NO` |  |  |  |  |

## Audit conclusion

```text
Coverage Decision:
P0 Count:
P1 Count:
P2 Count:
P3 Count:
Regression Count:
Blocked Count:
Contradictory Evidence Count:
Founder Approval Items:
Read-Only Confirmation: NO PRODUCT CHANGES MADE
Final Audit Decision:
Next Authorized Action:
```

The audit conclusion MUST NOT authorize fixes, merge, or a new Journey unless a separate task explicitly does so.