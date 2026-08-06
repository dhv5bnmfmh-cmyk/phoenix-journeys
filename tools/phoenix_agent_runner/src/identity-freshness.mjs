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

export const REAUDIT_CONTINUITY_FIELDS = Object.freeze([
  'repository',
  'pr_number',
  'base_branch',
  'base_sha',
  'head_branch',
  'candidate_sha',
  'candidate_tree',
  'task_contract_digest',
  'governance_body_digest',
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

function assertGithubRecordUrl(value, repository, fragment, code) {
  let url;
  try {
    url = new URL(String(value ?? ''));
  } catch {
    fail(code);
  }
  if (!['api.github.com', 'github.com'].includes(url.hostname)) fail(code);
  if (!url.pathname.includes(`/repos/${repository}/`)
      && !url.pathname.includes(`/${repository}/`)) fail(code);
  if (!url.pathname.includes(fragment)) fail(code);
  return String(value);
}

export async function fetchAuthoritativePreviousEvidenceProvenance({
  repository,
  prNumber,
  currentIdentity,
  artifactId,
  policy,
  request,
  now = new Date(),
}) {
  if (typeof request !== 'function') fail('TRUSTED_GITHUB_API_BOUNDARY_MISSING');
  const id = positiveId(artifactId, 'PREVIOUS_ARTIFACT_ID_INVALID');
  const artifactPath = `/repos/${repository}/actions/artifacts/${id}`;
  const artifact = await request(artifactPath);
  if (!artifact || typeof artifact !== 'object' || Array.isArray(artifact)) {
    fail('PREVIOUS_ARTIFACT_RECORD_MALFORMED');
  }
  if (positiveId(artifact.id, 'PREVIOUS_ARTIFACT_ID_MISMATCH') !== id) {
    fail('PREVIOUS_ARTIFACT_ID_MISMATCH');
  }
  if (artifact.expired === true) fail('PREVIOUS_ARTIFACT_EXPIRED');
  const digest = String(artifact.digest ?? '').toLowerCase();
  if (!/^sha256:[0-9a-f]{64}$/u.test(digest)) fail('PREVIOUS_ARTIFACT_DIGEST_INVALID');
  const authority = policy?.github_record_authority?.reaudit_artifact ?? {};
  const namePattern = new RegExp(String(authority.name_pattern ?? 'a^'), 'u');
  if (!namePattern.test(String(artifact.name ?? ''))) fail('PREVIOUS_ARTIFACT_NAME_NOT_ALLOWED');
  const artifactCreated = parseTime(artifact.created_at, 'PREVIOUS_ARTIFACT_CREATED_AT_INVALID');
  const artifactExpires = parseTime(artifact.expires_at, 'PREVIOUS_ARTIFACT_EXPIRES_AT_INVALID');
  if (artifactExpires <= artifactCreated || artifactExpires <= now.getTime()) {
    fail('PREVIOUS_ARTIFACT_EXPIRED');
  }
  assertGithubRecordUrl(artifact.url, repository, `/actions/artifacts/${id}`, 'PREVIOUS_ARTIFACT_URL_MISMATCH');
  const runId = positiveId(artifact?.workflow_run?.id, 'PREVIOUS_RUN_ID_INVALID');
  const runPath = `/repos/${repository}/actions/runs/${runId}`;
  const run = await request(runPath);
  if (!run || typeof run !== 'object' || Array.isArray(run)) fail('PREVIOUS_RUN_RECORD_MALFORMED');
  if (positiveId(run.id, 'PREVIOUS_RUN_ID_MISMATCH') !== runId) fail('PREVIOUS_RUN_ID_MISMATCH');
  if (run?.repository?.full_name !== repository) fail('PREVIOUS_RUN_REPOSITORY_MISMATCH');
  if (positiveId(run.workflow_id, 'PREVIOUS_RUN_WORKFLOW_ID_INVALID')
      !== positiveId(authority.workflow_id, 'PREVIOUS_RUN_WORKFLOW_POLICY_ID_INVALID')) {
    fail('PREVIOUS_RUN_WORKFLOW_ID_MISMATCH');
  }
  if (run.path !== authority.workflow_path) fail('PREVIOUS_RUN_WORKFLOW_PATH_MISMATCH');
  if (!(authority.allowed_events ?? []).includes(run.event)) fail('PREVIOUS_RUN_EVENT_NOT_ALLOWED');
  if (run.status !== 'completed') fail('PREVIOUS_RUN_NOT_TERMINAL');
  if (!(authority.allowed_conclusions ?? []).includes(run.conclusion)) {
    fail('PREVIOUS_RUN_CONCLUSION_NOT_ALLOWED');
  }
  const attempt = positiveId(run.run_attempt, 'PREVIOUS_RUN_ATTEMPT_INVALID');
  const runCreated = parseTime(run.created_at, 'PREVIOUS_RUN_CREATED_AT_INVALID');
  const runUpdated = parseTime(run.updated_at, 'PREVIOUS_RUN_UPDATED_AT_INVALID');
  if (runUpdated < runCreated || artifactCreated < runCreated) fail('PREVIOUS_RUN_TIMESTAMP_ORDER_INVALID');
  assertGithubRecordUrl(run.url, repository, `/actions/runs/${runId}`, 'PREVIOUS_RUN_API_URL_MISMATCH');
  assertGithubRecordUrl(run.html_url, repository, `/actions/runs/${runId}`, 'PREVIOUS_RUN_HTML_URL_MISMATCH');
  const pulls = Array.isArray(run.pull_requests) ? run.pull_requests : [];
  const pr = pulls.find((item) => Number(item?.number) === Number(prNumber));
  if (!pr || pulls.length !== 1) fail('PREVIOUS_RUN_PR_BINDING_MISMATCH');
  const expected = {
    repository,
    pr_number: Number(prNumber),
    base_branch: currentIdentity?.base_branch,
    base_sha: currentIdentity?.base_sha,
    head_branch: currentIdentity?.head_branch,
    candidate_sha: currentIdentity?.candidate_sha,
  };
  const actual = {
    repository: run.repository.full_name,
    pr_number: Number(pr.number),
    base_branch: pr.base?.ref,
    base_sha: pr.base?.sha,
    head_branch: pr.head?.ref,
    candidate_sha: run.head_sha,
  };
  const mismatch = Object.keys(expected).filter((field) => expected[field] !== actual[field]);
  if (mismatch.length > 0) fail('PREVIOUS_RUN_IDENTITY_MISMATCH', mismatch);
  if (artifact?.workflow_run?.head_sha && artifact.workflow_run.head_sha !== run.head_sha) {
    fail('PREVIOUS_ARTIFACT_HEAD_MISMATCH');
  }
  return {
    artifact_id: id,
    artifact_digest: digest,
    artifact_name: artifact.name,
    artifact_expired: false,
    artifact_created_at: artifact.created_at,
    artifact_expires_at: artifact.expires_at,
    repository,
    pr_number: Number(prNumber),
    base_branch: pr.base.ref,
    base_sha: pr.base.sha,
    head_branch: pr.head.ref,
    candidate_sha: run.head_sha,
    workflow_run_id: String(runId),
    run_attempt: attempt,
    workflow_id: run.workflow_id,
    workflow_path: run.path,
    event: run.event,
    status: run.status,
    conclusion: run.conclusion,
    run_created_at: run.created_at,
    run_updated_at: run.updated_at,
    run_api_url: run.url,
    run_html_url: run.html_url,
  };
}

export function assertPreviousEvidenceContinuity(previousEvidenceIdentity, currentAuditIdentity) {
  const stale = REAUDIT_CONTINUITY_FIELDS.filter(
    (field) => previousEvidenceIdentity?.[field] !== currentAuditIdentity?.[field],
  );
  if (stale.length > 0) fail('EVIDENCE_STALE_REAUDIT_REQUIRED', stale);
  return true;
}

export function assertPreviousEvidenceProvenance(previousEvidenceIdentity, previousProvenance) {
  if (!previousProvenance || typeof previousProvenance !== 'object'
      || Array.isArray(previousProvenance)) {
    fail('PREVIOUS_EVIDENCE_PROVENANCE_REQUIRED');
  }
  const artifactId = Number(previousProvenance.artifact_id);
  if (!Number.isSafeInteger(artifactId) || artifactId < 1) {
    fail('PREVIOUS_ARTIFACT_ID_INVALID');
  }
  const artifactDigest = String(previousProvenance.artifact_digest ?? '');
  const downloadedDigest = String(previousProvenance.downloaded_artifact_digest ?? '');
  if (!/^sha256:[0-9a-f]{64}$/u.test(artifactDigest)
      || !/^sha256:[0-9a-f]{64}$/u.test(downloadedDigest)) {
    fail('PREVIOUS_ARTIFACT_DIGEST_INVALID');
  }
  if (artifactDigest !== downloadedDigest) fail('PREVIOUS_ARTIFACT_DIGEST_MISMATCH');
  if (previousProvenance.artifact_expired !== false) fail('PREVIOUS_ARTIFACT_EXPIRED');
  if (!/^phoenix-trusted-audit-[1-9][0-9]*-[1-9][0-9]*$/u.test(
    String(previousProvenance.artifact_name ?? ''),
  )) fail('PREVIOUS_ARTIFACT_NAME_NOT_ALLOWED');
  if (Number(previousProvenance.workflow_id) !== 327680704
      || previousProvenance.workflow_path !== '.github/workflows/phoenix-agent-audit.yml') {
    fail('PREVIOUS_RUN_WORKFLOW_IDENTITY_MISMATCH');
  }
  if (!['pull_request_target', 'workflow_dispatch'].includes(previousProvenance.event)) {
    fail('PREVIOUS_RUN_EVENT_NOT_ALLOWED');
  }
  if (previousProvenance.status !== 'completed'
      || !['success', 'failure'].includes(previousProvenance.conclusion)) {
    fail('PREVIOUS_RUN_NOT_TERMINAL');
  }
  const created = Date.parse(String(previousProvenance.run_created_at ?? ''));
  const updated = Date.parse(String(previousProvenance.run_updated_at ?? ''));
  if (!Number.isFinite(created) || !Number.isFinite(updated) || updated < created) {
    fail('PREVIOUS_RUN_TIMESTAMP_ORDER_INVALID');
  }
  const bindings = {
    repository: previousProvenance.repository,
    pr_number: Number(previousProvenance.pr_number),
    base_branch: previousProvenance.base_branch,
    base_sha: previousProvenance.base_sha,
    head_branch: previousProvenance.head_branch,
    candidate_sha: previousProvenance.candidate_sha,
    workflow_run_id: String(previousProvenance.workflow_run_id ?? ''),
    run_attempt: Number(previousProvenance.run_attempt),
  };
  const mismatches = Object.entries(bindings)
    .filter(([field, value]) => previousEvidenceIdentity?.[field] !== value)
    .map(([field]) => field);
  if (mismatches.length > 0) fail('PREVIOUS_EVIDENCE_PROVENANCE_MISMATCH', mismatches);
  return true;
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
  const previousEvidenceIdentity = canonicalIdentityFromEvidence(previousEvidence);
  assertPreviousEvidenceProvenance(previousEvidenceIdentity, previousEvidence?.provenance);
  assertPreviousEvidenceContinuity(previousEvidenceIdentity, currentIdentity);
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
  let prResponse;
  try {
    prResponse = await fetchImpl(`${apiUrl}/repos/${repository}/pulls/${prNumber}`, { headers });
  } catch {
    fail('LIVE_PR_FETCH_FAILED:NETWORK');
  }
  if (!prResponse?.ok) fail(`LIVE_PR_FETCH_FAILED:${prResponse?.status ?? 'UNKNOWN'}`);
  const pr = await prResponse.json();
  let commitResponse;
  try {
    commitResponse = await fetchImpl(
      `${apiUrl}/repos/${repository}/git/commits/${pr?.head?.sha ?? ''}`,
      { headers },
    );
  } catch {
    fail('LIVE_HEAD_FETCH_FAILED:NETWORK');
  }
  if (!commitResponse?.ok) fail(`LIVE_HEAD_FETCH_FAILED:${commitResponse?.status ?? 'UNKNOWN'}`);
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
