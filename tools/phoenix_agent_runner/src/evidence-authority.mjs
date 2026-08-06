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
const FOUNDER_START = '<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_START -->';
const FOUNDER_END = '<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_END -->';

function fail(code) {
  const error = new Error(code);
  error.code = code;
  throw error;
}

function nonEmpty(value, code) {
  const text = String(value ?? '').trim();
  if (!text) fail(code);
  return text;
}

function positiveId(value, code) {
  const id = Number(value);
  if (!Number.isSafeInteger(id) || id < 1) fail(code);
  return id;
}

function parseTime(value, code) {
  const time = Date.parse(String(value ?? ''));
  if (!Number.isFinite(time)) fail(code);
  return time;
}

function assertRecordUrl(url, repository, fragment, code) {
  const encodedRepository = repository.split('/').map(encodeURIComponent).join('/');
  const value = nonEmpty(url, code);
  if (!value.includes(`/repos/${encodedRepository}/`) && !value.includes(`/${repository}/`)) {
    fail(code);
  }
  if (!value.includes(fragment)) fail(code);
  return value;
}

export function assertNoSelfAssertedEvidence(env = {}) {
  if (String(env.PHOENIX_CI_EVIDENCE_JSON ?? '').trim()) {
    fail('SELF_ASSERTED_CI_EVIDENCE_FORBIDDEN');
  }
  if (String(env.PHOENIX_FOUNDER_EVIDENCE_JSON ?? '').trim()) {
    fail('SELF_ASSERTED_FOUNDER_EVIDENCE_FORBIDDEN');
  }
  return true;
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
  if (!Array.isArray(requiredTypes)) fail('EVIDENCE_TYPES_INVALID');
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
  return nonEmpty(proof.command_or_path, `EVIDENCE_COMMAND_OR_PATH_MISSING:${type}`);
}

function requireGithubAuthority(proof, type) {
  if (proof.authority !== 'GITHUB_API_VERIFIED') fail(`EVIDENCE_GITHUB_AUTHORITY_MISSING:${type}`);
  positiveId(proof.record_id, `EVIDENCE_GITHUB_RECORD_ID_MISSING:${type}`);
  nonEmpty(proof.record_url, `EVIDENCE_GITHUB_RECORD_URL_MISSING:${type}`);
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
    requireGithubAuthority(proof, 'ci');
    if (String(proof.status).toLowerCase() !== 'completed') fail('EVIDENCE_NOT_TERMINAL:ci');
    if (String(proof.conclusion).toLowerCase() !== 'success') fail('EVIDENCE_PROOF_BLOCKED:ci');
    requireHead(proof, identity, 'ci', 'head_sha');
    if (proof.repository !== identity.repository) fail('EVIDENCE_REPOSITORY_MISMATCH:ci');
    if (Number(proof.run_attempt) !== identity.run_attempt) fail('EVIDENCE_STALE_RUN_ATTEMPT:ci');
    return verifiedEntry({
      type: 'ci', identity, proof, producedAt, index,
      source: String(proof.source),
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
    requireGithubAuthority(proof, 'founder');
    if (proof.repository !== identity.repository
        || Number(proof.pr_number) !== identity.pr_number
        || proof.exact_head !== identity.candidate_sha) {
      fail('FOUNDER_EVIDENCE_IDENTITY_MISMATCH');
    }
    if (proof.revoked === true) fail('FOUNDER_EVIDENCE_REVOKED');
    if (String(proof.result).toUpperCase() !== 'PASS') fail('FOUNDER_EVIDENCE_NOT_APPROVED');
    return verifiedEntry({
      type: 'founder', identity, proof, producedAt, index,
      source: String(proof.source),
      commandOrPath: requireCommand(proof, 'founder'),
      limitations: proof.limitations ?? [],
    });
  },
});

export function produceTrustedEvidenceEntries({ identity, requiredTypes, proofs = {}, producedAt }) {
  const normalized = normalizeRequiredEvidenceTypes(requiredTypes);
  return normalized.map((type, index) => TYPE_PRODUCERS[type]({
    identity,
    proof: proofs[type],
    producedAt,
    index,
  }));
}

export function createTrustedEvidenceManifest({ identity, requiredTypes, entries, producedAt }) {
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

export function createBlockedEvidenceManifest({ identity, producedAt, code }) {
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
  { identity, requiredTypes, policy, now = new Date(), maxAgeMs = 24 * 60 * 60 * 1000 },
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
    for (const field of policy?.binding_fields ?? []) {
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

function ciPolicy(policy) {
  return policy?.github_record_authority?.ci ?? {};
}

function founderPolicy(policy) {
  return policy?.github_record_authority?.founder ?? {};
}

function verifyWorkflowRun(record, { repository, identity, policy, recordId }) {
  if (!record || typeof record !== 'object' || Array.isArray(record)) fail('CI_GITHUB_RECORD_MALFORMED');
  if (positiveId(record.id, 'CI_GITHUB_RECORD_ID_MISMATCH') !== recordId) {
    fail('CI_GITHUB_RECORD_ID_MISMATCH');
  }
  if (record?.repository?.full_name !== repository) fail('CI_GITHUB_RECORD_REPOSITORY_MISMATCH');
  if (record.head_sha !== identity.candidate_sha) fail('CI_GITHUB_RECORD_HEAD_MISMATCH');
  if (String(record.status).toLowerCase() !== 'completed') fail('CI_GITHUB_RECORD_NOT_TERMINAL');
  if (String(record.conclusion).toLowerCase() !== 'success') fail('CI_GITHUB_RECORD_NOT_SUCCESS');
  if (Number(record.run_attempt) !== identity.run_attempt) fail('CI_GITHUB_RECORD_ATTEMPT_MISMATCH');
  const allowedNames = new Set(ciPolicy(policy).allowed_workflow_names ?? []);
  if (!allowedNames.has(record.name)) fail('CI_GITHUB_RECORD_IDENTITY_NOT_ALLOWED');
  const allowedEvents = new Set(ciPolicy(policy).allowed_events ?? []);
  if (!allowedEvents.has(record.event)) fail('CI_GITHUB_RECORD_EVENT_NOT_ALLOWED');
  const created = parseTime(record.created_at, 'CI_GITHUB_RECORD_CREATED_AT_INVALID');
  const completed = parseTime(record.updated_at, 'CI_GITHUB_RECORD_COMPLETED_AT_INVALID');
  if (completed < created) fail('CI_GITHUB_RECORD_TIMESTAMP_ORDER_INVALID');
  const recordUrl = assertRecordUrl(
    record.url ?? record.html_url,
    repository,
    `/actions/runs/${recordId}`,
    'CI_GITHUB_RECORD_URL_MISMATCH',
  );
  return {
    record,
    recordUrl,
    createdAt: record.created_at,
    completedAt: record.updated_at,
  };
}

export async function fetchAuthoritativeCiEvidence({
  repository,
  identity,
  reference,
  policy,
  request,
}) {
  if (typeof request !== 'function') fail('TRUSTED_GITHUB_API_BOUNDARY_MISSING');
  const workflowId = reference?.workflow_run_id ? positiveId(
    reference.workflow_run_id,
    'CI_GITHUB_RECORD_REFERENCE_INVALID',
  ) : null;
  const checkId = reference?.check_run_id ? positiveId(
    reference.check_run_id,
    'CI_GITHUB_RECORD_REFERENCE_INVALID',
  ) : null;
  if ((workflowId ? 1 : 0) + (checkId ? 1 : 0) !== 1) {
    fail('CI_GITHUB_RECORD_REFERENCE_REQUIRED');
  }

  if (workflowId) {
    const path = `/repos/${repository}/actions/runs/${workflowId}`;
    const verified = verifyWorkflowRun(await request(path), {
      repository, identity, policy, recordId: workflowId,
    });
    return {
      authority: 'GITHUB_API_VERIFIED',
      record_id: workflowId,
      record_type: 'workflow_run',
      record_url: verified.recordUrl,
      repository,
      workflow_or_check_name: verified.record.name,
      status: 'completed',
      conclusion: 'success',
      result: 'PASS',
      head_sha: identity.candidate_sha,
      candidate_sha: identity.candidate_sha,
      workflow_run_id: String(workflowId),
      run_attempt: Number(verified.record.run_attempt),
      event: verified.record.event,
      created_at: verified.createdAt,
      completed_at: verified.completedAt,
      source: 'trusted-github-api-workflow-run',
      command_or_path: `GET ${path}`,
      limitations: [],
    };
  }

  const checkPath = `/repos/${repository}/check-runs/${checkId}`;
  const check = await request(checkPath);
  if (!check || typeof check !== 'object' || Array.isArray(check)) fail('CI_GITHUB_RECORD_MALFORMED');
  if (positiveId(check.id, 'CI_GITHUB_RECORD_ID_MISMATCH') !== checkId) {
    fail('CI_GITHUB_RECORD_ID_MISMATCH');
  }
  if (check.head_sha !== identity.candidate_sha) fail('CI_GITHUB_RECORD_HEAD_MISMATCH');
  if (String(check.status).toLowerCase() !== 'completed') fail('CI_GITHUB_RECORD_NOT_TERMINAL');
  if (String(check.conclusion).toLowerCase() !== 'success') fail('CI_GITHUB_RECORD_NOT_SUCCESS');
  const allowedChecks = new Set(ciPolicy(policy).allowed_check_names ?? []);
  if (!allowedChecks.has(check.name)) fail('CI_GITHUB_RECORD_IDENTITY_NOT_ALLOWED');
  parseTime(check.started_at, 'CI_GITHUB_RECORD_CREATED_AT_INVALID');
  parseTime(check.completed_at, 'CI_GITHUB_RECORD_COMPLETED_AT_INVALID');
  const checkUrl = assertRecordUrl(
    check.url ?? check.html_url,
    repository,
    `/check-runs/${checkId}`,
    'CI_GITHUB_RECORD_URL_MISMATCH',
  );
  const details = String(check.details_url ?? check.html_url ?? '');
  const runMatch = details.match(/\/actions\/runs\/(\d+)/u);
  if (!runMatch) fail('CI_CHECK_RUN_WORKFLOW_IDENTITY_MISSING');
  const associatedRunId = positiveId(runMatch[1], 'CI_CHECK_RUN_WORKFLOW_IDENTITY_INVALID');
  const runPath = `/repos/${repository}/actions/runs/${associatedRunId}`;
  const verifiedRun = verifyWorkflowRun(await request(runPath), {
    repository, identity, policy, recordId: associatedRunId,
  });
  return {
    authority: 'GITHUB_API_VERIFIED',
    record_id: checkId,
    record_type: 'check_run',
    record_url: checkUrl,
    repository,
    workflow_or_check_name: check.name,
    status: 'completed',
    conclusion: 'success',
    result: 'PASS',
    head_sha: identity.candidate_sha,
    candidate_sha: identity.candidate_sha,
    workflow_run_id: String(associatedRunId),
    run_attempt: Number(verifiedRun.record.run_attempt),
    event: verifiedRun.record.event,
    created_at: check.started_at,
    completed_at: check.completed_at,
    source: 'trusted-github-api-check-run',
    command_or_path: `GET ${checkPath}; GET ${runPath}`,
    limitations: [],
  };
}

export function extractFounderAuthorization(body) {
  const text = String(body ?? '');
  const start = text.indexOf(FOUNDER_START);
  const end = text.indexOf(FOUNDER_END);
  if (start < 0 || end < 0 || end <= start) fail('FOUNDER_AUTHORIZATION_RECORD_MISSING');
  const enclosed = text.slice(start + FOUNDER_START.length, end).trim();
  const match = enclosed.match(/^```json\s*([\s\S]*?)\s*```$/u);
  if (!match) fail('FOUNDER_AUTHORIZATION_RECORD_MALFORMED');
  try {
    return JSON.parse(match[1]);
  } catch {
    fail('FOUNDER_AUTHORIZATION_RECORD_MALFORMED');
  }
}

export async function fetchAuthoritativeFounderEvidence({
  repository,
  prNumber,
  identity,
  reference,
  expectedAction,
  policy,
  founderSchema,
  validateAuthorization,
  request,
  now = new Date(),
}) {
  if (typeof request !== 'function') fail('TRUSTED_GITHUB_API_BOUNDARY_MISSING');
  if (typeof validateAuthorization !== 'function') fail('FOUNDER_SCHEMA_VALIDATOR_MISSING');
  const reviewId = reference?.review_id ? positiveId(
    reference.review_id,
    'FOUNDER_GITHUB_RECORD_REFERENCE_INVALID',
  ) : null;
  const commentId = reference?.comment_id ? positiveId(
    reference.comment_id,
    'FOUNDER_GITHUB_RECORD_REFERENCE_INVALID',
  ) : null;
  if ((reviewId ? 1 : 0) + (commentId ? 1 : 0) !== 1) {
    fail('FOUNDER_GITHUB_RECORD_REFERENCE_REQUIRED');
  }

  const isReview = Boolean(reviewId);
  const id = reviewId ?? commentId;
  const path = isReview
    ? `/repos/${repository}/pulls/${prNumber}/reviews/${id}`
    : `/repos/${repository}/issues/comments/${id}`;
  const record = await request(path);
  if (!record || typeof record !== 'object' || Array.isArray(record)) {
    fail('FOUNDER_GITHUB_RECORD_MALFORMED');
  }
  if (positiveId(record.id, 'FOUNDER_GITHUB_RECORD_ID_MISMATCH') !== id) {
    fail('FOUNDER_GITHUB_RECORD_ID_MISMATCH');
  }
  if (!isReview) {
    assertRecordUrl(
      record.issue_url,
      repository,
      `/issues/${Number(prNumber)}`,
      'FOUNDER_GITHUB_RECORD_PR_MISMATCH',
    );
  } else if (String(record.state).toUpperCase() !== 'APPROVED') {
    fail('FOUNDER_GITHUB_REVIEW_NOT_APPROVED');
  }
  const recordUrl = assertRecordUrl(
    record.url ?? record.html_url,
    repository,
    isReview ? `/reviews/${id}` : `/comments/${id}`,
    'FOUNDER_GITHUB_RECORD_URL_MISMATCH',
  );
  const authorization = extractFounderAuthorization(record.body);
  validateAuthorization(founderSchema, authorization, 'founder_authorization');

  if (authorization.repository !== repository) fail('FOUNDER_AUTHORIZATION_REPOSITORY_MISMATCH');
  if (Number(authorization.pr_number) !== Number(prNumber)) fail('FOUNDER_AUTHORIZATION_PR_MISMATCH');
  if (authorization.exact_head !== identity.candidate_sha) fail('FOUNDER_AUTHORIZATION_HEAD_MISMATCH');
  if (authorization.action_type !== expectedAction) fail('FOUNDER_AUTHORIZATION_ACTION_MISMATCH');
  if (authorization.revoked === true) fail('FOUNDER_AUTHORIZATION_REVOKED');

  const author = nonEmpty(record?.user?.login, 'FOUNDER_GITHUB_IDENTITY_MISSING');
  if (authorization.founder_github_identity !== author) fail('FOUNDER_GITHUB_IDENTITY_MISMATCH');
  const allowedIdentities = new Set(founderPolicy(policy).allowed_github_identities ?? []);
  const allowedAssociations = new Set(founderPolicy(policy).allowed_author_associations ?? []);
  if (!allowedIdentities.has(author) && !allowedAssociations.has(record.author_association)) {
    fail('FOUNDER_GITHUB_IDENTITY_NOT_ALLOWED');
  }

  const recordIssuedAt = isReview ? record.submitted_at : record.created_at;
  const recordIssued = parseTime(recordIssuedAt, 'FOUNDER_GITHUB_RECORD_ISSUED_AT_INVALID');
  const authorizationIssued = parseTime(
    authorization.issued_at,
    'FOUNDER_AUTHORIZATION_ISSUED_AT_INVALID',
  );
  if (recordIssued !== authorizationIssued) fail('FOUNDER_AUTHORIZATION_ISSUED_AT_MISMATCH');
  if (authorizationIssued > now.getTime() + 60_000) fail('FOUNDER_AUTHORIZATION_ISSUED_AT_FUTURE');
  if (authorization.expires_at !== undefined && authorization.expires_at !== null) {
    const expires = parseTime(authorization.expires_at, 'FOUNDER_AUTHORIZATION_EXPIRES_AT_INVALID');
    if (expires <= now.getTime()) fail('FOUNDER_AUTHORIZATION_EXPIRED');
  }
  if (authorization.trusted_evidence_source !== record.url) {
    fail('FOUNDER_AUTHORIZATION_SOURCE_MISMATCH');
  }

  return {
    authority: 'GITHUB_API_VERIFIED',
    record_id: id,
    record_type: isReview ? 'pull_request_review' : 'issue_comment',
    record_url: recordUrl,
    repository,
    pr_number: Number(prNumber),
    exact_head: identity.candidate_sha,
    founder_github_identity: author,
    author_association: record.author_association,
    action_type: expectedAction,
    issued_at: authorization.issued_at,
    expires_at: authorization.expires_at ?? null,
    revoked: false,
    result: 'PASS',
    status: 'completed',
    source: isReview
      ? 'trusted-github-api-founder-review'
      : 'trusted-github-api-founder-comment',
    command_or_path: `GET ${path}`,
    limitations: [],
    authorization,
  };
}
