import { createHash } from 'node:crypto';

export const CANONICAL_FRESHNESS_FIELDS = Object.freeze([
  'repository',
  'pr_number',
  'base_branch',
  'base_sha',
  'head_branch',
  'candidate_sha',
  'candidate_tree',
  'task_contract_digest',
  'governance_body_digest',
  'workflow_run_id',
  'run_attempt',
]);

export const AUDIT_MODES = Object.freeze(['FRESH_AUDIT', 'REAUDIT']);

function fail(code, staleFields = []) {
  const error = new Error(code);
  error.code = code;
  if (staleFields.length > 0) error.stale_fields = staleFields;
  throw error;
}

export function canonicalJson(value) {
  if (Array.isArray(value)) return `[${value.map(canonicalJson).join(',')}]`;
  if (value && typeof value === 'object') {
    return `{${Object.keys(value).sort().map((key) => `${JSON.stringify(key)}:${canonicalJson(value[key])}`).join(',')}}`;
  }
  return JSON.stringify(value);
}

export function sha256Text(value) {
  return createHash('sha256').update(String(value), 'utf8').digest('hex');
}

export function normalizeGovernanceBody(body) {
  return String(body ?? '').replace(/\r\n/g, '\n').replace(/[ \t]+$/gm, '').trim();
}

export function extractTaskContract(body) {
  const normalized = normalizeGovernanceBody(body);
  const match = normalized.match(/<!-- PHOENIX_TASK_CONTRACT_JSON_START -->\s*```json\s*([\s\S]*?)\s*```\s*<!-- PHOENIX_TASK_CONTRACT_JSON_END -->/u);
  if (!match) fail('TASK_CONTRACT_MISSING');
  try {
    return JSON.parse(match[1]);
  } catch {
    fail('TASK_CONTRACT_MALFORMED');
  }
}

function requireMetadata(metadata, fields) {
  for (const field of fields) {
    if (metadata?.[field] === undefined || metadata[field] === null || metadata[field] === '') {
      fail(`LIVE_METADATA_MISSING:${field}`);
    }
  }
}

export function buildLiveIdentity({
  metadata,
  taskContract,
  runId,
  runAttempt,
  eventType,
  producedAt,
}) {
  requireMetadata(metadata, [
    'repository',
    'number',
    'base_branch',
    'base_sha',
    'head_branch',
    'head_sha',
    'head_tree',
    'body',
  ]);
  const attempt = Number(runAttempt);
  if (!Number.isInteger(attempt) || attempt < 1) fail('RUN_ATTEMPT_INVALID');
  if (!String(runId ?? '').trim()) fail('WORKFLOW_RUN_ID_INVALID');
  return {
    repository: String(metadata.repository),
    pr_number: Number(metadata.number),
    base_branch: String(metadata.base_branch),
    base_sha: String(metadata.base_sha),
    head_branch: String(metadata.head_branch),
    candidate_sha: String(metadata.head_sha),
    candidate_tree: String(metadata.head_tree),
    draft: Boolean(metadata.draft),
    state: String(metadata.state ?? 'unknown').toLowerCase(),
    task_contract_digest: sha256Text(canonicalJson(taskContract)),
    governance_body_digest: sha256Text(normalizeGovernanceBody(metadata.body)),
    workflow_run_id: String(runId),
    run_attempt: attempt,
    event_type: String(eventType),
    produced_at: String(producedAt),
  };
}

export function assertCanonicalFreshness(expected, current) {
  const stale = CANONICAL_FRESHNESS_FIELDS.filter(
    (field) => expected?.[field] !== current?.[field],
  );
  if (stale.length > 0) fail('EVIDENCE_STALE_REAUDIT_REQUIRED', stale);
  return true;
}

export const assertEvidenceFresh = assertCanonicalFreshness;

export function canonicalIdentityFromEvidence(value) {
  const source = value?.evidence_manifest ?? value?.identity ?? value;
  if (!source || typeof source !== 'object' || Array.isArray(source)) {
    fail('PREVIOUS_EVIDENCE_IDENTITY_INVALID');
  }
  const identity = Object.fromEntries(
    CANONICAL_FRESHNESS_FIELDS.map((field) => [field, source[field]]),
  );
  const missing = CANONICAL_FRESHNESS_FIELDS.filter(
    (field) => identity[field] === undefined || identity[field] === null || identity[field] === '',
  );
  if (missing.length > 0) fail('PREVIOUS_EVIDENCE_IDENTITY_INVALID', missing);
  return identity;
}

export function normalizeAuditMode(value) {
  const mode = String(value ?? '').trim().toUpperCase();
  if (!mode) fail('AUDIT_MODE_REQUIRED');
  if (!AUDIT_MODES.includes(mode)) fail('AUDIT_MODE_INVALID');
  return mode;
}

export function assertAuditEvidenceMode({ auditMode, previousEvidence, currentIdentity }) {
  const mode = normalizeAuditMode(auditMode);
  if (mode === 'FRESH_AUDIT') {
    if (previousEvidence !== null && previousEvidence !== undefined) {
      fail('FRESH_AUDIT_PREVIOUS_EVIDENCE_FORBIDDEN');
    }
    return mode;
  }
  if (previousEvidence === null || previousEvidence === undefined) {
    fail('PREVIOUS_EVIDENCE_REQUIRED');
  }
  assertCanonicalFreshness(canonicalIdentityFromEvidence(previousEvidence), currentIdentity);
  return mode;
}

function validSha(value) {
  return /^[0-9a-f]{40}$/u.test(String(value ?? ''));
}

export function assertTrustedSourceIdentity({
  observedTrustedCheckoutSha,
  declaredTrustedCheckoutSha,
  authorizedTrustedSourceSha,
  liveBaseSha,
}) {
  const values = [
    observedTrustedCheckoutSha,
    declaredTrustedCheckoutSha,
    authorizedTrustedSourceSha,
    liveBaseSha,
  ];
  if (!values.every(validSha) || new Set(values).size !== 1) {
    fail('TRUSTED_SOURCE_IDENTITY_MISMATCH');
  }
  return true;
}

export function assertTaskContractIdentity(taskContract, liveIdentity, prNumber) {
  const expected = {
    repository: taskContract?.repository,
    pr_number: Number(prNumber),
    base_branch: taskContract?.base_branch,
    base_sha: taskContract?.base_sha,
    head_branch: taskContract?.head_branch,
    candidate_sha: taskContract?.current_head_sha,
  };
  const mismatches = Object.entries(expected)
    .filter(([field, value]) => value !== liveIdentity?.[field])
    .map(([field]) => field);
  if (mismatches.length > 0) fail('EVIDENCE_STALE_REAUDIT_REQUIRED', mismatches);
  return true;
}

export function metadataFromPullRequestEvent(event, candidateTree) {
  const pr = event?.pull_request;
  if (!pr) return null;
  return {
    repository: event?.repository?.full_name,
    number: pr.number,
    base_branch: pr.base?.ref,
    base_sha: pr.base?.sha,
    head_branch: pr.head?.ref,
    head_sha: pr.head?.sha,
    head_tree: candidateTree,
    body: pr.body ?? '',
    draft: pr.draft,
    state: pr.state,
  };
}

export async function fetchLivePullRequest({
  repository,
  prNumber,
  token,
  apiUrl = 'https://api.github.com',
  fetchImpl = fetch,
}) {
  if (!token) fail('TRUSTED_GITHUB_TOKEN_MISSING');
  if (!/^[^/]+\/[^/]+$/u.test(String(repository))) fail('TRUSTED_REPOSITORY_INVALID');
  if (!Number.isInteger(Number(prNumber)) || Number(prNumber) < 1) fail('TRUSTED_PR_NUMBER_INVALID');
  const headers = {
    Accept: 'application/vnd.github+json',
    Authorization: `Bearer ${token}`,
    'X-GitHub-Api-Version': '2022-11-28',
  };
  const prResponse = await fetchImpl(`${apiUrl}/repos/${repository}/pulls/${prNumber}`, { headers });
  if (!prResponse.ok) fail(`LIVE_PR_FETCH_FAILED:${prResponse.status}`);
  const pr = await prResponse.json();
  const commitResponse = await fetchImpl(
    `${apiUrl}/repos/${repository}/git/commits/${pr?.head?.sha ?? ''}`,
    { headers },
  );
  if (!commitResponse.ok) fail(`LIVE_HEAD_FETCH_FAILED:${commitResponse.status}`);
  const commit = await commitResponse.json();
  return {
    repository,
    number: pr.number,
    base_branch: pr.base?.ref,
    base_sha: pr.base?.sha,
    head_branch: pr.head?.ref,
    head_sha: pr.head?.sha,
    head_tree: commit?.tree?.sha,
    body: pr.body ?? '',
    draft: pr.draft,
    state: pr.state,
  };
}
