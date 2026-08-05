import { createHash } from 'node:crypto';

export const AUDIT_AUTHORITY_PATHS = Object.freeze([
  '.github/workflows/phoenix-agent-audit.yml',
  'tools/phoenix_agent_runner/',
  'ai/development/policies/',
  'ai/development/schemas/',
]);

export function sha256(value) {
  return createHash('sha256').update(value).digest('hex');
}

export function classifyAuthorityChanges(changedPaths) {
  return changedPaths.filter(path =>
    AUDIT_AUTHORITY_PATHS.some(prefix => prefix.endsWith('/') ? path.startsWith(prefix) : path === prefix)
  ).map(path => ({
    path,
    authority: 'CANDIDATE_UNTRUSTED_CHANGE',
    execution_effect: 'NONE_FOR_CURRENT_AUDIT',
  }));
}

export function buildTrustedIdentity({
  trustedRunnerSha,
  trustedRunnerTree,
  trustedWorkflowPath,
  trustedRuleInventoryDigest,
  trustedSchemaDigest,
  candidateSha,
  candidateTree,
  baseSha,
  prNumber,
  runId,
  runAttempt,
  eventType,
}) {
  const record = {
    trusted_runner_sha: trustedRunnerSha,
    trusted_runner_tree: trustedRunnerTree,
    trusted_workflow_path: trustedWorkflowPath,
    trusted_rule_inventory_digest: trustedRuleInventoryDigest,
    trusted_schema_digest: trustedSchemaDigest,
    candidate_sha: candidateSha,
    candidate_tree: candidateTree,
    base_sha: baseSha,
    pr_number: Number(prNumber),
    run_id: String(runId),
    run_attempt: Number(runAttempt),
    event_type: eventType,
    candidate_execution: 'PROHIBITED',
    candidate_token_access: 'PROHIBITED',
    bootstrap_status: 'TRUSTED_SOURCE_IMPLEMENTED_OPERATIONAL_ACTIVATION_PENDING_MERGE',
  };
  for (const [key, value] of Object.entries(record)) {
    if (value === '' || value === undefined || value === null || Number.isNaN(value)) {
      throw new Error(`TRUSTED_IDENTITY_FIELD_MISSING:${key}`);
    }
  }
  return record;
}

export function assertCandidateNotExecuted(command) {
  const normalized = String(command).replaceAll('\\', '/');
  const forbidden = [
    /\bnode\s+candidate\//i,
    /\bnpm\s+(?:ci|install|test|run)\b.*candidate/i,
    /\bflutter\s+(?:test|analyze|build)\b.*candidate/i,
    /\bcandidate\/.*(?:\.sh|\.mjs|\.js|package\.json)\b/i,
  ];
  if (forbidden.some(pattern => pattern.test(normalized))) throw new Error('CANDIDATE_EXECUTION_PROHIBITED');
}
