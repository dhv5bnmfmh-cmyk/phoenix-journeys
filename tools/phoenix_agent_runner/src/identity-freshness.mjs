import { createHash } from 'node:crypto';

export function canonicalJson(value) {
  if (Array.isArray(value)) return `[${value.map(canonicalJson).join(',')}]`;
  if (value && typeof value === 'object') {
    return `{${Object.keys(value).sort().map(k => `${JSON.stringify(k)}:${canonicalJson(value[k])}`).join(',')}}`;
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
  let contract;
  try { contract = JSON.parse(match[1]); } catch { throw new Error('TASK_CONTRACT_MALFORMED'); }
  return contract;
}

export function buildLiveIdentity({ metadata, taskContract, runId, runAttempt, eventType, producedAt }) {
  const required = ['number', 'base_branch', 'base_sha', 'head_sha', 'head_tree', 'body'];
  for (const field of required) if (metadata[field] === undefined || metadata[field] === null || metadata[field] === '') throw new Error(`LIVE_METADATA_MISSING:${field}`);
  const taskContractDigest = sha256Text(canonicalJson(taskContract));
  const bodyDigest = sha256Text(normalizeGovernanceBody(metadata.body));
  return {
    pr_number: Number(metadata.number),
    base_branch: metadata.base_branch,
    base_sha: metadata.base_sha,
    candidate_sha: metadata.head_sha,
    candidate_tree: metadata.head_tree,
    draft: Boolean(metadata.draft),
    task_contract_digest: taskContractDigest,
    governance_body_digest: bodyDigest,
    workflow_run_id: String(runId),
    run_attempt: Number(runAttempt),
    event_type: String(eventType),
    produced_at: producedAt,
  };
}

export function assertEvidenceFresh(previous, current) {
  const keys = ['pr_number','base_branch','base_sha','candidate_sha','candidate_tree','task_contract_digest','governance_body_digest','workflow_run_id','run_attempt'];
  const stale = keys.filter(key => previous?.[key] !== current?.[key]);
  if (stale.length) {
    const error = new Error('EVIDENCE_STALE_REAUDIT_REQUIRED');
    error.stale_fields = stale;
    throw error;
  }
  return true;
}

export async function fetchLivePullRequest({ repository, prNumber, token, apiUrl = 'https://api.github.com' }) {
  if (!token) throw new Error('TRUSTED_GITHUB_TOKEN_MISSING');
  const headers = { Accept: 'application/vnd.github+json', Authorization: `Bearer ${token}`, 'X-GitHub-Api-Version': '2022-11-28' };
  const prResponse = await fetch(`${apiUrl}/repos/${repository}/pulls/${prNumber}`, { headers });
  if (!prResponse.ok) throw new Error(`LIVE_PR_FETCH_FAILED:${prResponse.status}`);
  const pr = await prResponse.json();
  const commitResponse = await fetch(`${apiUrl}/repos/${repository}/git/commits/${pr.head.sha}`, { headers });
  if (!commitResponse.ok) throw new Error(`LIVE_HEAD_FETCH_FAILED:${commitResponse.status}`);
  const commit = await commitResponse.json();
  return {
    number: pr.number,
    base_branch: pr.base.ref,
    base_sha: pr.base.sha,
    head_sha: pr.head.sha,
    head_tree: commit.tree.sha,
    body: pr.body ?? '',
    draft: pr.draft,
    state: pr.state,
  };
}
