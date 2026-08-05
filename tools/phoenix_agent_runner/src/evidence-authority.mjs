import { canonicalJson, sha256Text } from './identity-freshness.mjs';

const TERMINAL = new Set(['PASS','BLOCKED','FAILURE','NOT_APPLICABLE']);

export function createTrustedEvidenceManifest({ identity, requiredTypes, entries, producedAt }) {
  return {
    manifest_version: '2.0.0',
    trust_class: 'TRUSTED_RUNNER_GENERATED',
    repository: identity.repository,
    pr_number: identity.pr_number,
    base_sha: identity.base_sha,
    candidate_sha: identity.candidate_sha,
    candidate_tree: identity.candidate_tree,
    task_contract_digest: identity.task_contract_digest,
    governance_body_digest: identity.governance_body_digest,
    workflow_run_id: identity.workflow_run_id,
    run_attempt: identity.run_attempt,
    produced_at: producedAt,
    required_evidence_types: [...requiredTypes].sort(),
    evidence: entries,
  };
}

export function validateEvidenceManifest(manifest, { identity, requiredTypes, now = new Date(), maxAgeMs = 24 * 60 * 60 * 1000 }) {
  if ((requiredTypes?.length ?? 0) > 0 && !manifest) throw new Error('EVIDENCE_MANIFEST_REQUIRED');
  if (!manifest || manifest.trust_class !== 'TRUSTED_RUNNER_GENERATED') throw new Error('EVIDENCE_MANIFEST_UNTRUSTED');
  if (!Array.isArray(manifest.evidence) || manifest.evidence.length === 0) throw new Error('EVIDENCE_MANIFEST_EMPTY');
  const bindings = ['base_sha','candidate_sha','candidate_tree','task_contract_digest','workflow_run_id','run_attempt'];
  for (const key of bindings) if (manifest[key] !== identity[key]) throw new Error(`EVIDENCE_BINDING_MISMATCH:${key}`);
  const produced = Date.parse(manifest.produced_at);
  if (!Number.isFinite(produced)) throw new Error('EVIDENCE_TIMESTAMP_INVALID');
  if (produced > now.getTime() + 60_000) throw new Error('EVIDENCE_TIMESTAMP_FUTURE');
  if (now.getTime() - produced > maxAgeMs) throw new Error('EVIDENCE_EXPIRED');
  const types = new Set(manifest.evidence.map(item => item.evidence_type));
  for (const type of requiredTypes ?? []) if (!types.has(type)) throw new Error(`EVIDENCE_TYPE_MISSING:${type}`);
  for (const item of manifest.evidence) {
    if (!item.evidence_id || !item.source || !item.limitations || !TERMINAL.has(item.result)) throw new Error('EVIDENCE_ENTRY_INVALID');
    if (item.candidate_sha !== identity.candidate_sha) throw new Error('EVIDENCE_ENTRY_STALE_HEAD');
    if (item.base_sha !== identity.base_sha) throw new Error('EVIDENCE_ENTRY_STALE_BASE');
    if (item.task_contract_digest !== identity.task_contract_digest) throw new Error('EVIDENCE_ENTRY_WRONG_TASK_DIGEST');
  }
  return sha256Text(canonicalJson(manifest));
}
