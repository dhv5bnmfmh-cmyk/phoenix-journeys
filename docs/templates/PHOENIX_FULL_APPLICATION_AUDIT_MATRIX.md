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
**Issue Severity:** `NONE` / `P0` / `P1` / `P2` / `P3`  
**Evidence Level:** `VERIFIED` / `PARTIALLY_VERIFIED` / `UNVERIFIED` / `CONTRADICTORY`  
**Founder Approval Required:** `YES` / `NO`

`NONE` is not a fifth problem severity. It means no Issue was identified for the row.

Rules:

- `PASS` requires `VERIFIED` evidence and `Issue Severity = NONE`.
- `NOT_APPLICABLE` requires an applicability reason, supporting evidence, and `Issue Severity = NONE`; it is not `PASS`.
- `REQUIRES_REVISION`, `REGRESSION`, or `BLOCKED` with an identified Issue requires `P0`, `P1`, `P2`, or `P3`.
- A result below the stable baseline MUST be `REGRESSION`.
- Do not assign a fabricated `P3` to a PASS row.
- Do not count `NONE` in P0/P1/P2/P3 totals.
- Blank Issue Severity is prohibited in final audit records.
- Evidence Level and Issue Severity are independent fields.

## Copyable audit table

| Audit ID | Area | Page or Route | File Path | Journey ID | Stage | Standard Requirement | Stable Baseline Evidence | Candidate Evidence | Expected | Actual | Result | Issue Severity | Evidence Level | Issue | Required Action | Owner | Verification | Founder Approval Required |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| AUD-0001 |  |  |  |  |  |  |  |  |  |  | `BLOCKED` | `P2` | `UNVERIFIED` |  |  |  |  | `NO` |
| AUD-0002 |  |  |  |  |  |  |  |  |  |  | `PASS` | `NONE` | `VERIFIED` | `NONE` | `NONE` |  |  | `NO` |
| AUD-0003 |  |  |  |  |  |  |  |  |  |  | `NOT_APPLICABLE` | `NONE` | `VERIFIED` | Applicability reason required | `NONE` |  |  | `NO` |

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
11. A PASS row MUST use `Issue Severity = NONE` and MUST NOT contain an unresolved Issue.
12. A NOT_APPLICABLE row MUST use `Issue Severity = NONE` and include applicability reason plus evidence.
13. Blank Issue Severity is prohibited in the final matrix.

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
| Random / Daily Journey Access |  |  |  |  |  |  |  |  |  | Independent coverage required; not satisfied by free/paid or locked/unlocked rows |
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

## Random / Daily Journey Access audit record

Create one or more rows for each independently verifiable mode, account state, date, and slot. Do not combine all behavior into one unsupported summary.

| Access Audit ID | Account state | Mode | Stable user/test identifier | Local date | Local timezone | Slot | Generated Journey ID | Expected behavior | Actual behavior | Same-slot refresh | App restart | Re-login | Persistence | Morning/afternoon duplication | Journey library size | Configuration evidence | Route | Exact code/policy path | Result | Issue Severity | Evidence Level | Issue / Required action |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---:|---|---|---|---|---|---|---|
| ACCESS-0001 |  | `developmentExperience / preview / production` |  |  |  | `morning / afternoon` |  |  |  |  |  |  |  |  |  |  |  | `JourneyAccessPolicy` path | `BLOCKED` | `P1/P2/P3` | `UNVERIFIED` |  |

### Required Random / Daily assertions

Record evidence for each assertion:

1. Same user + same local date + same slot produces a stable Journey ID.
2. Refresh does not redraw the Journey.
3. App restart does not redraw the Journey.
4. Re-login remains consistent with the approved design.
5. When Journey library size is greater than one, morning and afternoon do not duplicate on the same day.
6. After the afternoon release, Journeys already released that day remain usable.
7. Access logic is unified through `JourneyAccessPolicy`.
8. Development and PR Preview use `developmentExperience` and keep all published Journeys open.
9. Commercial slot times and strategy are configurable and are not hard-coded into Journey content.

A missing assertion is `BLOCKED`, not silently covered.

## Issue Severity ledger

| Issue ID | Audit IDs | Issue Severity | User impact | Reach | Recoverability | Stable regression | Owner | Required action | Verification | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| ISSUE-0001 |  | `P0/P1/P2/P3` |  |  |  | `YES/NO` |  |  |  |  |

Rows with `Issue Severity = NONE` MUST NOT enter the issue ledger and MUST NOT be included in P0/P1/P2/P3 counts.

## Audit conclusion

```text
Coverage Decision:
P0 Count:
P1 Count:
P2 Count:
P3 Count:
NONE Row Count:
Regression Count:
Blocked Count:
Contradictory Evidence Count:
Random / Daily Journey Access Coverage Decision:
Founder Approval Items:
Read-Only Confirmation: NO PRODUCT CHANGES MADE
Final Audit Decision:
Next Authorized Action:
```

The audit conclusion MUST NOT authorize fixes, merge, or a new Journey unless a separate task explicitly does so.