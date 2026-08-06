import { canonicalJson, sha256Text } from './identity-freshness.mjs';

export const TRUSTED_EVIDENCE_TYPES = Object.freeze([
  'repository',
  'commit',
  'diff',
  'changed_paths',
  'test',
  'ci',
  'workflow',
  'founder',
]);

export const REQUIRED_EVIDENCE_ENTRY_FIELDS = Object.freeze([
  'evidence_id',
  'evidence_type',
  'source',
  'command_or_path',
  'candidate_sha',
  'produced_at',
  'result',
  'evidence_level',
  'limitations',
]);

const REGISTERED = new Set(TRUSTED_EVIDENCE_TYPES);
const TERMINAL_RESULTS = new Set(['PASS', 'BLOCKED', 'FAILURE', 'NOT_APPLICABLE']);

function fail(code) {
  const error = new Error(code);
  error.code = code;
  throw error;
}

export function normalizeEvidenceType(value) {
  const normalized = String(value ?? '')
    .trim()
    .toLowerCase()
    .replace(/[\s-]+/g, '_')
    .replace(/_evidence$/u, '');
  const aliases = {
    repository_identity: 'repository',
    commit_identity: 'commit',
    changed_path: 'changed_paths',
    changed_paths_inventory: 'changed_paths',
    tests: 'test',
    continuous_integration: 'ci',
    github_workflow: 'workflow',
    founder_authorization: 'founder',
  };
  const type = aliases[normalized] ?? normalized;
  if (!REGISTERED.has(type)) fail(`EVIDENCE_TYPE_UNREGISTERED:${type || 'EMPTY'}`);
  return type;
}

export function normalizeRequiredEvidenceTypes(requiredTypes = []) {
  const normalized = requiredTypes.map(normalizeEvidenceType);
  if (new Set(normalized).size !== normalized.length) fail('EVIDENCE_TYPE_DUPLICATE');
  return normalized;
}

function requireObject(proof, type) {
  if (!proof || typeof proof !== 'object' || Array.isArray(proof)) {
    fail(`EVIDENCE_PROOF_MISSING:${type}`);
  }
  return proof;
}

function requireTerminalPass(proof, type) {
  if (proof.status !== undefined && String(proof.status).toLowerCase() !== 'completed') {
    fail(`EVIDENCE_NOT_TERMINAL:${type}`);
  }
  const result = String(proof.result ?? proof.conclusion ?? '').toUpperCase();
  if (!TERMINAL_RESULTS.has(result)) fail(`EVIDENCE_NOT_TERMINAL:${type}`);
  if (result !== 'PASS') fail(`EVIDENCE_PROOF_BLOCKED:${type}`);
}

function requireHead(proof, identity, type, field = 'candidate_sha') {
  if (proof[field] !== identity.candidate_sha) fail(`EVIDENCE_STALE_HEAD:${type}`);
}

function requireCommand(proof, type) {
  const command = String(proof.command_or_path ?? '').trim();
  if (!command) fail(`EVIDENCE_COMMAND_OR_PATH_MISSING:${type}`);
  return command;
}

function verifiedEntry({
  type,
  identity,
  proof,
  producedAt,
  index,
  source,
  commandOrPath,
  limitations = [],
}) {
  return {
    evidence_id: `trusted-${type}-${String(index + 1).padStart(2, '0')}`,
    evidence_type: type,
    source,
    command_or_path: commandOrPath,
    candidate_sha: identity.candidate_sha,
    produced_at: producedAt,
    result: 'PASS',
    evidence_level: 'VERIFIED',
    limitations: limitations.map(String),
    base_sha: identity.base_sha,
    task_contract_digest: identity.task_contract_digest,
    governance_body_digest: identity.governance_body_digest,
    workflow_run_id: identity.workflow_run_id,
    run_attempt: identity.run_attempt,
  };
}

const TYPE_PRODUCERS = Object.freeze({
  repository({ identity, proof, producedAt, index }) {
    requireObject(proof, 'repository');
    requireTerminalPass(proof, 'repository');
    if (proof.repository !== identity.repository) fail('EVIDENCE_REPOSITORY_MISMATCH');
    return verifiedEntry({
      type: 'repository', identity, proof, producedAt, index,
      source: String(proof.source ?? 'live-github-pr'),
      commandOrPath: requireCommand(proof, 'repository'),
      limitations: proof.limitations ?? [],
    });
  },

  commit({ identity, proof, producedAt, index }) {
    requireObject(proof, 'commit');
    requireTerminalPass(proof, 'commit');
    requireHead(proof, identity, 'commit');
    if (proof.base_sha !== identity.base_sha) fail('EVIDENCE_STALE_BASE:commit');
    if (proof.candidate_tree !== identity.candidate_tree) fail('EVIDENCE_STALE_TREE:commit');
    return verifiedEntry({
      type: 'commit', identity, proof, producedAt, index,
      source: String(proof.source ?? 'live-github-commit'),
      commandOrPath: requireCommand(proof, 'commit'),
      limitations: proof.limitations ?? [],
    });
  },

  diff({ identity, proof, producedAt, index }) {
    requireObject(proof, 'diff');
    requireTerminalPass(proof, 'diff');
    requireHead(proof, identity, 'diff');
    if (proof.base_sha !== identity.base_sha) fail('EVIDENCE_STALE_BASE:diff');
    return verifiedEntry({
      type: 'diff', identity, proof, producedAt, index,
      source: String(proof.source ?? 'trusted-git-diff'),
      commandOrPath: requireCommand(proof, 'diff'),
      limitations: proof.limitations ?? [],
    });
  },

  changed_paths({ identity, proof, producedAt, index }) {
    requireObject(proof, 'changed_paths');
    requireTerminalPass(proof, 'changed_paths');
    requireHead(proof, identity, 'changed_paths');
    if (!Array.isArray(proof.paths)) fail('EVIDENCE_CHANGED_PATHS_MISSING');
    return verifiedEntry({
      type: 'changed_paths', identity, proof, producedAt, index,
      source: String(proof.source ?? 'trusted-git-diff-name-only'),
      commandOrPath: requireCommand(proof, 'changed_paths'),
      limitations: proof.limitations ?? [],
    });
  },

  test({ identity, proof, producedAt, index }) {
    requireObject(proof, 'test');
    requireTerminalPass(proof, 'test');
    requireHead(proof, identity, 'test');
    if (!Number.isInteger(proof.total) || !Number.isInteger(proof.passed)
        || !Number.isInteger(proof.failed) || !Number.isInteger(proof.skipped)) {
      fail('EVIDENCE_TEST_COUNTS_MISSING');
    }
    if (proof.failed !== 0 || proof.passed !== proof.total - proof.skipped) {
      fail('EVIDENCE_TEST_RESULT_INCONSISTENT');
    }
    return verifiedEntry({
      type: 'test', identity, proof, producedAt, index,
      source: String(proof.source ?? 'trusted-node-test-runner'),
      commandOrPath: requireCommand(proof, 'test'),
      limitations: proof.limitations ?? [],
    });
  },

  ci({ identity, proof, producedAt, index }) {
    requireObject(proof, 'ci');
    if (String(proof.status ?? '').toLowerCase() !== 'completed') fail('EVIDENCE_NOT_TERMINAL:ci');
    if (String(proof.conclusion ?? '').toLowerCase() !== 'success') fail('EVIDENCE_PROOF_BLOCKED:ci');
    requireHead(proof, identity, 'ci', 'head_sha');
    return verifiedEntry({
      type: 'ci', identity, proof, producedAt, index,
      source: String(proof.source ?? 'trusted-github-checks'),
      commandOrPath: requireCommand(proof, 'ci'),
      limitations: proof.limitations ?? [],
    });
  },

  workflow({ identity, proof, producedAt, index }) {
    requireObject(proof, 'workflow');
    requireTerminalPass(proof, 'workflow');
    requireHead(proof, identity, 'workflow');
    if (String(proof.workflow_run_id) !== identity.workflow_run_id) {
      fail('EVIDENCE_STALE_RUN:workflow');
    }
    if (Number(proof.run_attempt) !== identity.run_attempt) {
      fail('EVIDENCE_STALE_RUN_ATTEMPT:workflow');
    }
    return verifiedEntry({
      type: 'workflow', identity, proof, producedAt, index,
      source: String(proof.source ?? 'trusted-github-actions-run'),
      commandOrPath: requireCommand(proof, 'workflow'),
      limitations: proof.limitations ?? [],
    });
  },

  founder({ identity, proof, producedAt, index }) {
    requireObject(proof, 'founder');
    if (proof.trust_class !== 'TRUSTED_GITHUB_RECORD') {
      fail('FOUNDER_EVIDENCE_UNTRUSTED');
    }
    if (proof.repository !== identity.repository
        || Number(proof.pr_number) !== identity.pr_number
        || proof.exact_head !== identity.candidate_sha) {
      fail('FOUNDER_EVIDENCE_IDENTITY_MISMATCH');
    }
    if (proof.revoked === true) fail('FOUNDER_EVIDENCE_REVOKED');
    if (String(proof.result ?? '').toUpperCase() !== 'PASS') {
      fail('FOUNDER_EVIDENCE_NOT_APPROVED');
    }
    return verifiedEntry({
      type: 'founder', identity, proof, producedAt, index,
      source: String(proof.source ?? proof.trusted_evidence_source ?? 'trusted-founder-record'),
      commandOrPath: requireCommand(proof, 'founder'),
      limitations: proof.limitations ?? [],
    });
  },
});

export function produceTrustedEvidenceEntries({
  identity,
  requiredTypes,
  proofs = {},
  producedAt,
}) {
  const normalized = normalizeRequiredEvidenceTypes(requiredTypes);
  return normalized.map((type, index) => TYPE_PRODUCERS[type]({
    identity,
    proof: proofs[type],
    producedAt,
    index,
  }));
}

export function createTrustedEvidenceManifest({
  identity,
  requiredTypes,
  entries,
  producedAt,
}) {
  const normalized = normalizeRequiredEvidenceTypes(requiredTypes);
  return {
    manifest_version: '2.1.0',
    trust_class: 'TRUSTED_RUNNER_GENERATED',
    repository: identity.repository,
    pr_number: identity.pr_number,
    base_branch: identity.base_branch,
    base_sha: identity.base_sha,
    head_branch: identity.head_branch,
    candidate_sha: identity.candidate_sha,
    candidate_tree: identity.candidate_tree,
    task_contract_digest: identity.task_contract_digest,
    governance_body_digest: identity.governance_body_digest,
    workflow_run_id: identity.workflow_run_id,
    run_attempt: identity.run_attempt,
    produced_at: producedAt,
    required_evidence_types: [...normalized].sort(),
    evidence: entries,
  };
}

export function createBlockedEvidenceManifest({
  identity,
  producedAt,
  code,
}) {
  const entry = {
    evidence_id: 'trusted-workflow-blocked-01',
    evidence_type: 'workflow',
    source: 'trusted-runner-error-boundary',
    command_or_path: '.github/workflows/phoenix-agent-audit.yml',
    candidate_sha: identity.candidate_sha,
    produced_at: producedAt,
    result: 'BLOCKED',
    evidence_level: 'VERIFIED',
    limitations: [`Fail-closed error: ${String(code)}`],
    base_sha: identity.base_sha,
    task_contract_digest: identity.task_contract_digest,
    governance_body_digest: identity.governance_body_digest,
    workflow_run_id: identity.workflow_run_id,
    run_attempt: identity.run_attempt,
  };
  return createTrustedEvidenceManifest({
    identity,
    requiredTypes: ['workflow'],
    entries: [entry],
    producedAt,
  });
}

export function validateEvidenceManifest(
  manifest,
  {
    identity,
    requiredTypes,
    policy,
    now = new Date(),
    maxAgeMs = 24 * 60 * 60 * 1000,
  },
) {
  if ((requiredTypes?.length ?? 0) > 0 && !manifest) fail('EVIDENCE_MANIFEST_REQUIRED');
  if (!manifest || manifest.trust_class !== 'TRUSTED_RUNNER_GENERATED') {
    fail('EVIDENCE_MANIFEST_UNTRUSTED');
  }
  if (!Array.isArray(manifest.evidence) || manifest.evidence.length === 0) {
    fail('EVIDENCE_MANIFEST_EMPTY');
  }
  const normalizedRequired = normalizeRequiredEvidenceTypes(requiredTypes ?? []);
  const policyTypes = new Set(policy?.evidence_types ?? TRUSTED_EVIDENCE_TYPES);
  for (const type of TRUSTED_EVIDENCE_TYPES) {
    if (!policyTypes.has(type)) fail(`EVIDENCE_POLICY_TYPE_MISSING:${type}`);
  }

  const bindings = [
    'repository', 'pr_number', 'base_branch', 'base_sha', 'head_branch',
    'candidate_sha', 'candidate_tree', 'task_contract_digest',
    'governance_body_digest', 'workflow_run_id', 'run_attempt',
  ];
  for (const key of bindings) {
    if (manifest[key] !== identity[key]) fail(`EVIDENCE_BINDING_MISMATCH:${key}`);
  }

  const produced = Date.parse(manifest.produced_at);
  if (!Number.isFinite(produced)) fail('EVIDENCE_TIMESTAMP_INVALID');
  if (produced > now.getTime() + 60_000) fail('EVIDENCE_TIMESTAMP_FUTURE');
  if (now.getTime() - produced > maxAgeMs) fail('EVIDENCE_EXPIRED');

  const types = new Set();
  for (const item of manifest.evidence) {
    const type = normalizeEvidenceType(item.evidence_type);
    if (types.has(type)) fail(`EVIDENCE_TYPE_DUPLICATE:${type}`);
    types.add(type);
    for (const field of policy?.required_fields ?? REQUIRED_EVIDENCE_ENTRY_FIELDS) {
      if (!(field in item)) fail(`EVIDENCE_ENTRY_FIELD_MISSING:${field}`);
    }
    if (!String(item.command_or_path ?? '').trim()) fail('EVIDENCE_COMMAND_OR_PATH_MISSING');
    if (!Number.isFinite(Date.parse(item.produced_at))) fail('EVIDENCE_ENTRY_TIMESTAMP_INVALID');
    if (!TERMINAL_RESULTS.has(item.result)) fail('EVIDENCE_ENTRY_RESULT_INVALID');
    if (!Array.isArray(item.limitations)) fail('EVIDENCE_ENTRY_LIMITATIONS_INVALID');
    if (item.candidate_sha !== identity.candidate_sha) fail('EVIDENCE_ENTRY_STALE_HEAD');
    if (item.base_sha !== identity.base_sha) fail('EVIDENCE_ENTRY_STALE_BASE');
    if (item.task_contract_digest !== identity.task_contract_digest) {
      fail('EVIDENCE_ENTRY_WRONG_TASK_DIGEST');
    }
    if (item.governance_body_digest !== identity.governance_body_digest) {
      fail('EVIDENCE_ENTRY_WRONG_BODY_DIGEST');
    }
    if (item.workflow_run_id !== identity.workflow_run_id
        || item.run_attempt !== identity.run_attempt) {
      fail('EVIDENCE_ENTRY_STALE_RUN');
    }
  }
  for (const type of normalizedRequired) {
    if (!types.has(type)) fail(`EVIDENCE_TYPE_MISSING:${type}`);
  }
  return sha256Text(canonicalJson(manifest));
}
