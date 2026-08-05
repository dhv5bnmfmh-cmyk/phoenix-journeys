# Phoenix Development Agent System

This directory contains the machine-readable Phase A governance foundation.

## Layout

- `agents/`: six Agent manifests and their Phase A capabilities.
- `policies/`: Rule Registry, capability, scope, Founder gate, and evidence policies.
- `schemas/`: Task Contract, Finding, Evidence Manifest, and Audit Report JSON Schemas.
- `examples/`: valid and invalid contracts plus sample Finding, Evidence, and Audit records.

## Phase A operating rule

Only `READ_ONLY_AUDIT` and `GOVERNANCE_DOCUMENTATION` are accepted. Builder and Remediation Agents remain disabled. No file in this directory grants repository write authority.

The canonical standards remain the Markdown governance documents in `docs/` and the PR evidence template. Machine-readable rules operationalize those standards and must be corrected if a conflict is found.

## Runner

`tools/phoenix_agent_runner/` validates these files and emits JSON and Markdown audit reports without third-party dependencies or external AI calls.

## Decision language

- Deterministic checks report their actual result.
- AI Review is `NOT_RUN` unless it genuinely executed.
- Founder gates remain independent.
- Deterministic PASS is never represented as full product PASS.
