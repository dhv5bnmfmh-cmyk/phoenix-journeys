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
  const match = normalized.match(/<!-- PHOENIX_TASK_CONTRACT_JSON_START -->\s*```json\s*([\s\S]*?)\s*```\s*<!-- PHOENIX_TASK_CONTRACT_JSON_END -->/);
  if (!match) throw new Error('TASK_CONTRACT_MISSING');
  try {
    return JSON.parse(match[1]);
  } catch {
    throw new Error('TASK_CONTRACT_MALFORMED');
  }
}

function requireMetadata(metadata, fields) {
  for (const field of fields) {
    if (metadata?.[field] === undefined || metadata[field] === null || metadata[field] === '') {
      throw new Error(`LIVE_METADATA_MISSING:${field}`);
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
  const taskContractDigest = sha256Text(canonicalJson(taskContract));
  const bodyDigest = sha256Text(normalizeGovernanceBody(metadata.body));
  const attempt = Number(runAttempt);
  if (!Number.isInteger(attempt) || attempt < 1) throw new Error('RUN_ATTEMPT_INVALID');
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
    task_contract_digest: taskContractDigest,
    governance_body_digest: bodyDigest,
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
  if (stale.length > 0) {
    const error = new Error('EVIDENCE_STALE_REAUDIT_REQUIRED');
    error.code = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
    error.stale_fields = stale;
    throw error;
  }
  return true;
}

// Backward-compatible name used by existing trusted tests and callers.
export const assertEvidenceFresh = assertCanonicalFreshness;

export function assertTaskContractIdentity(taskContract, liveIdentity, prNumber) {
  const mismatches = [];
  const expected = {
    repository: taskContract?.repository,
    pr_number: Number(prNumber),
    base_branch: taskContract?.base_branch,
    base_sha: taskContract?.base_sha,
    head_branch: taskContract?.head_branch,
    candidate_sha: taskContract?.current_head_sha,
  };
  for (const [field, value] of Object.entries(expected)) {
    if (value !== liveIdentity?.[field]) mismatches.push(field);
  }
  if (mismatches.length > 0) {
    const error = new Error('EVIDENCE_STALE_REAUDIT_REQUIRED');
    error.code = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
    error.stale_fields = mismatches;
    throw error;
  }
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
}) {
  if (!token) throw new Error('TRUSTED_GITHUB_TOKEN_MISSING');
  const headers = {
    Accept: 'application/vnd.github+json',
    Authorization: `Bearer ${token}`,
    'X-GitHub-Api-Version': '2022-11-28',
  };
  const prResponse = await fetch(`${apiUrl}/repos/${repository}/pulls/${prNumber}`, { headers });
  if (!prResponse.ok) throw new Error(`LIVE_PR_FETCH_FAILED:${prResponse.status}`);
  const pr = await prResponse.json();
  const commitResponse = await fetch(`${apiUrl}/repos/${repository}/git/commits/${pr.head.sha}`, { headers });
  if (!commitResponse.ok) throw new Error(`LIVE_HEAD_FETCH_FAILED:${commitResponse.status}`);
  const commit = await commitResponse.json();
  return {
    repository,
    number: pr.number,
    base_branch: pr.base.ref,
    base_sha: pr.base.sha,
    head_branch: pr.head.ref,
    head_sha: pr.head.sha,
    head_tree: commit.tree.sha,
    body: pr.body ?? '',
    draft: pr.draft,
    state: pr.state,
  };
}
