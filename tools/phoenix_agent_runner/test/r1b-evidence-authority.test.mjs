import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  AUDIT_MODES,
  assertTrustedSourceIdentity,
  assertAuditEvidenceMode,
  assertCanonicalFreshness,
  fetchAuthoritativePreviousEvidenceProvenance,
} from '../src/identity-freshness.mjs';
import {
  TRUSTED_EVIDENCE_TYPES,
  normalizeRequiredEvidenceTypes,
  assertNoSelfAssertedEvidence,
  fetchAuthoritativeCiEvidence,
  fetchAuthoritativeFounderEvidence,
  produceTrustedEvidenceEntries,
} from '../src/evidence-authority.mjs';
import {
  createTrustedGithubRequest,
  requiredFounderAction,
} from '../src/trusted-cli.mjs';
import { validateObject } from '../src/schema-validator.mjs';

const sha = (c) => c.repeat(40);
const dig = (c) => c.repeat(64);
const identity = {
  repository: 'o/r',
  pr_number: 148,
  base_branch: 'main',
  base_sha: sha('a'),
  head_branch: 'feature',
  candidate_sha: sha('b'),
  candidate_tree: sha('c'),
  task_contract_digest: dig('d'),
  governance_body_digest: dig('e'),
  workflow_run_id: '100',
  run_attempt: 2,
};
const previousIdentity = {
  ...identity,
  workflow_run_id: '7',
  run_attempt: 1,
};
const now = new Date('2026-08-06T00:00:00Z');
const root = resolve(import.meta.dirname, '../../..');
const founderSchema = JSON.parse(readFileSync(
  resolve(root, 'ai/development/schemas/founder_authorization.schema.json'),
  'utf8',
));
const policy = {
  github_record_authority: {
    reaudit_artifact: {
      name_pattern: '^phoenix-trusted-audit-[1-9][0-9]*-[1-9][0-9]*$',
      workflow_id: 327680704,
      workflow_path: '.github/workflows/phoenix-agent-audit.yml',
      allowed_events: ['pull_request_target', 'workflow_dispatch'],
      allowed_conclusions: ['success', 'failure'],
    },
    ci: {
      workflow_id: 327680704,
      workflow_path: '.github/workflows/phoenix-agent-audit.yml',
      allowed_check_names: ['Phoenix Agent Bootstrap Source Tests'],
      check_app_id: 15368,
      check_app_slug: 'github-actions',
      allowed_events: ['pull_request'],
    },
    founder: {
      allowed_github_identities: ['founder'],
      allowed_author_associations: ['OWNER'],
    },
  },
};
const prBinding = (o = {}) => ({
  number: 148,
  head: { ref: 'feature', sha: previousIdentity.candidate_sha, repo: { url: 'https://api.github.com/repos/o/r' } },
  base: { ref: 'main', sha: previousIdentity.base_sha, repo: { url: 'https://api.github.com/repos/o/r' } },
  ...o,
});
const run = (o = {}) => ({
  id: 7,
  name: 'Phoenix Agent Audit',
  workflow_id: 327680704,
  path: '.github/workflows/phoenix-agent-audit.yml',
  repository: { id: 1, full_name: 'o/r' },
  head_sha: identity.candidate_sha,
  status: 'completed',
  conclusion: 'success',
  run_attempt: 2,
  event: 'pull_request',
  created_at: '2026-08-05T23:00:00Z',
  updated_at: '2026-08-05T23:01:00Z',
  url: 'https://api.github.com/repos/o/r/actions/runs/7',
  html_url: 'https://github.com/o/r/actions/runs/7',
  check_suite_id: 44,
  pull_requests: [prBinding()],
  ...o,
});
const priorRun = (o = {}) => run({
  head_sha: previousIdentity.candidate_sha,
  run_attempt: 1,
  event: 'pull_request_target',
  ...o,
});
const artifact = (o = {}) => ({
  id: 9,
  name: 'phoenix-trusted-audit-7-1',
  expired: false,
  digest: `sha256:${dig('f')}`,
  url: 'https://api.github.com/repos/o/r/actions/artifacts/9',
  created_at: '2026-08-05T23:00:30Z',
  updated_at: '2026-08-05T23:00:31Z',
  workflow_run: { id: 7, head_sha: previousIdentity.candidate_sha },
  expires_at: '2026-09-05T23:00:30Z',
  ...o,
});
const priorRequest = ({ artifactRecord = artifact(), runRecord = priorRun(), error = null } = {}) => async (path) => {
  if (error) throw error;
  if (path === '/repos/o/r/actions/artifacts/9') return artifactRecord;
  if (path === '/repos/o/r/actions/runs/7') return runRecord;
  throw new Error(`unexpected path ${path}`);
};
const previousArgs = (overrides = {}) => ({
  repository: 'o/r',
  prNumber: 148,
  currentIdentity: identity,
  artifactId: '9',
  policy,
  request: priorRequest(),
  ...overrides,
});

const auth = (o = {}) => ({
  trust_class: 'TRUSTED_GITHUB_RECORD',
  repository: 'o/r',
  pr_number: 148,
  exact_head: identity.candidate_sha,
  action_type: 'GOVERNANCE_PASS',
  founder_github_identity: 'founder',
  trusted_evidence_source: 'https://api.github.com/repos/o/r/pulls/148/reviews/9',
  issued_at: '2026-08-05T23:00:00Z',
  expires_at: null,
  revoked: false,
  ...o,
});
const body = (a) => `<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_START -->\n\`\`\`json\n${JSON.stringify(a)}\n\`\`\`\n<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_END -->`;
const review = (a = auth(), o = {}) => ({
  id: 9,
  state: 'APPROVED',
  commit_id: identity.candidate_sha,
  url: 'https://api.github.com/repos/o/r/pulls/148/reviews/9',
  html_url: 'https://github.com/o/r/pull/148#pullrequestreview-9',
  body: body(a),
  user: { login: 'founder' },
  author_association: 'OWNER',
  submitted_at: '2026-08-05T23:00:00Z',
  ...o,
});
const commentAuth = (o = {}) => auth({
  trusted_evidence_source: 'https://api.github.com/repos/o/r/issues/comments/10',
  issued_at: '2026-08-05T23:05:00Z',
  ...o,
});
const comment = (a = commentAuth(), o = {}) => ({
  id: 10,
  url: 'https://api.github.com/repos/o/r/issues/comments/10',
  html_url: 'https://github.com/o/r/pull/148#issuecomment-10',
  issue_url: 'https://api.github.com/repos/o/r/issues/148',
  body: body(a),
  user: { login: 'founder' },
  author_association: 'OWNER',
  created_at: '2026-08-05T23:00:00Z',
  updated_at: '2026-08-05T23:05:00Z',
  ...o,
});
const founderArgs = (record, reference = { review_id: '9' }) => ({
  repository: 'o/r',
  prNumber: 148,
  identity,
  reference,
  expectedAction: 'GOVERNANCE_PASS',
  policy,
  founderSchema,
  validateAuthorization: validateObject,
  request: async () => record,
  now,
});
const ciArgs = (record) => ({
  repository: 'o/r',
  identity,
  reference: { workflow_run_id: '7' },
  policy,
  request: async () => record,
});

// Trusted source and explicit audit modes.
test('1 exact trusted checkout SHA equals live Base SHA', () => assert.equal(assertTrustedSourceIdentity({
  observedTrustedCheckoutSha: identity.base_sha,
  declaredTrustedCheckoutSha: identity.base_sha,
  authorizedTrustedSourceSha: identity.base_sha,
  liveBaseSha: identity.base_sha,
}), true));
test('2 trusted checkout SHA mismatch blocks', () => assert.throws(() => assertTrustedSourceIdentity({
  observedTrustedCheckoutSha: sha('f'),
  declaredTrustedCheckoutSha: sha('f'),
  authorizedTrustedSourceSha: identity.base_sha,
  liveBaseSha: identity.base_sha,
}), /TRUSTED_SOURCE_IDENTITY_MISMATCH/u));
test('3 workflow dispatch default-branch race blocks', () => assert.throws(() => assertTrustedSourceIdentity({
  observedTrustedCheckoutSha: sha('f'),
  declaredTrustedCheckoutSha: sha('f'),
  authorizedTrustedSourceSha: sha('f'),
  liveBaseSha: identity.base_sha,
}), /TRUSTED_SOURCE_IDENTITY_MISMATCH/u));
test('4 Base branch same SHA retarget blocks', () => assert.throws(
  () => assertCanonicalFreshness({ ...identity, base_branch: 'release' }, identity),
  /EVIDENCE_STALE_REAUDIT_REQUIRED/u,
));
test('5 FRESH_AUDIT with no old Evidence passes', () => assert.equal(assertAuditEvidenceMode({
  auditMode: 'FRESH_AUDIT', previousEvidence: null, currentIdentity: identity,
}), 'FRESH_AUDIT'));
test('6 REAUDIT missing previous identity blocks', () => assert.throws(() => assertAuditEvidenceMode({
  auditMode: 'REAUDIT', previousEvidence: null, currentIdentity: identity,
}), /PREVIOUS_EVIDENCE_REQUIRED/u));
test('explicit audit mode inventory', () => assert.deepEqual(AUDIT_MODES, ['FRESH_AUDIT', 'REAUDIT']));

// Prior Artifact provenance and cross-run continuity.
test('7 prior Run A Artifact plus new Run B passes', async () => {
  const provenance = await fetchAuthoritativePreviousEvidenceProvenance(previousArgs());
  provenance.downloaded_artifact_digest = provenance.artifact_digest;
  assert.equal(assertAuditEvidenceMode({
    auditMode: 'REAUDIT',
    previousEvidence: { evidence_manifest: previousIdentity, provenance },
    currentIdentity: identity,
  }), 'REAUDIT');
});
test('8 previous Run ID different from current is legal', async () => {
  const provenance = await fetchAuthoritativePreviousEvidenceProvenance(previousArgs());
  assert.notEqual(provenance.workflow_run_id, identity.workflow_run_id);
});
test('9 previous attempt different from current is legal', async () => {
  const provenance = await fetchAuthoritativePreviousEvidenceProvenance(previousArgs());
  assert.notEqual(provenance.run_attempt, identity.run_attempt);
});
test('10 wrong prior Artifact digest blocks', async () => {
  const provenance = await fetchAuthoritativePreviousEvidenceProvenance(previousArgs());
  provenance.downloaded_artifact_digest = `sha256:${dig('0')}`;
  assert.throws(() => assertAuditEvidenceMode({
    auditMode: 'REAUDIT',
    previousEvidence: { evidence_manifest: previousIdentity, provenance },
    currentIdentity: identity,
  }), /PREVIOUS_ARTIFACT_DIGEST_MISMATCH/u);
});
test('11 wrong prior Repository blocks', async () => assert.rejects(
  fetchAuthoritativePreviousEvidenceProvenance(previousArgs({
    request: priorRequest({ runRecord: priorRun({ repository: { id: 2, full_name: 'x/y' } }) }),
  })),
  /PREVIOUS_RUN_REPOSITORY_MISMATCH/u,
));
test('12 wrong prior Workflow blocks', async () => assert.rejects(
  fetchAuthoritativePreviousEvidenceProvenance(previousArgs({
    request: priorRequest({ runRecord: priorRun({ workflow_id: 1 }) }),
  })),
  /PREVIOUS_RUN_WORKFLOW_ID_MISMATCH/u,
));
test('13 old Candidate Head blocks', async () => assert.rejects(
  fetchAuthoritativePreviousEvidenceProvenance(previousArgs({
    request: priorRequest({ runRecord: priorRun({ head_sha: sha('9') }) }),
  })),
  /PREVIOUS_RUN_IDENTITY_MISMATCH/u,
));
test('14 no-op Commit old Evidence blocks through tree continuity', async () => {
  const provenance = await fetchAuthoritativePreviousEvidenceProvenance(previousArgs());
  provenance.downloaded_artifact_digest = provenance.artifact_digest;
  assert.throws(() => assertAuditEvidenceMode({
    auditMode: 'REAUDIT',
    previousEvidence: {
      evidence_manifest: { ...previousIdentity, candidate_tree: sha('9') },
      provenance,
    },
    currentIdentity: identity,
  }), /EVIDENCE_STALE_REAUDIT_REQUIRED/u);
});
test('15 expired Artifact blocks', async () => assert.rejects(
  fetchAuthoritativePreviousEvidenceProvenance(previousArgs({
    request: priorRequest({ artifactRecord: artifact({ expired: true }) }),
  })),
  /PREVIOUS_ARTIFACT_EXPIRED/u,
));
test('16 deleted Artifact fails closed', async () => assert.rejects(
  fetchAuthoritativePreviousEvidenceProvenance(previousArgs({
    request: priorRequest({ error: Object.assign(new Error('404'), { code: 'TRUSTED_GITHUB_API_REQUEST_FAILED:404' }) }),
  })),
  /404/u,
));

// CI immutable authority.
test('17 fabricated CI JSON blocks', () => assert.throws(
  () => assertNoSelfAssertedEvidence({ PHOENIX_CI_EVIDENCE_JSON: '{"result":"PASS"}' }),
  /SELF_ASSERTED_CI_EVIDENCE_FORBIDDEN/u,
));
test('18 missing Check or Workflow Run ID blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence({ ...ciArgs(run()), reference: {} }),
  /CI_GITHUB_RECORD_REFERENCE_REQUIRED/u,
));
test('19 nonexistent Run ID fails closed', async () => assert.rejects(
  fetchAuthoritativeCiEvidence({
    ...ciArgs(run()),
    request: async () => { throw Object.assign(new Error('404'), { code: 'TRUSTED_GITHUB_API_REQUEST_FAILED:404' }); },
  }),
  /404/u,
));
test('20 same name wrong Workflow ID blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ workflow_id: 1 }))),
  /WORKFLOW_ID_MISMATCH/u,
));
test('21 same name wrong Workflow path blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ path: '.github/workflows/spoof.yml' }))),
  /WORKFLOW_PATH_MISMATCH/u,
));
test('22 correct ID path exact Head terminal success passes', async () => assert.equal(
  (await fetchAuthoritativeCiEvidence(ciArgs(run()))).authority,
  'GITHUB_API_VERIFIED',
));
test('23 Run belongs to other Repository blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ repository: { full_name: 'x/y' } }))),
  /REPOSITORY_MISMATCH/u,
));
test('24 Run belongs to old Head blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ head_sha: sha('f') }))),
  /HEAD_MISMATCH/u,
));
test('25 non-terminal Run blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ status: 'in_progress', conclusion: null }))),
  /NOT_TERMINAL/u,
));
test('26 failed Run blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({ conclusion: 'failure' }))),
  /NOT_SUCCESS/u,
));
test('27 reversed Workflow timestamps block', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(ciArgs(run({
    created_at: '2026-08-05T23:02:00Z', updated_at: '2026-08-05T23:01:00Z',
  }))),
  /TIMESTAMP_ORDER_INVALID/u,
));

const checkRecord = (o = {}) => ({
  id: 11,
  name: 'Phoenix Agent Bootstrap Source Tests',
  head_sha: identity.candidate_sha,
  status: 'completed',
  conclusion: 'success',
  app: { id: 15368, slug: 'github-actions' },
  check_suite: { id: 44 },
  started_at: '2026-08-05T23:00:00Z',
  completed_at: '2026-08-05T23:01:00Z',
  url: 'https://api.github.com/repos/o/r/check-runs/11',
  html_url: 'https://github.com/o/r/runs/11',
  details_url: 'https://github.com/o/r/actions/runs/7',
  ...o,
});
const suiteRecord = (o = {}) => ({
  id: 44,
  repository: { full_name: 'o/r' },
  head_sha: identity.candidate_sha,
  app: { id: 15368, slug: 'github-actions' },
  status: 'completed',
  conclusion: 'success',
  ...o,
});
const checkArgs = ({ check = checkRecord(), suite = suiteRecord(), runs = { workflow_runs: [{ id: 7, check_suite_id: 44 }] }, workflow = run() } = {}) => ({
  repository: 'o/r',
  identity,
  reference: { check_run_id: '11' },
  policy,
  request: async (path) => {
    if (path === '/repos/o/r/check-runs/11') return check;
    if (path === '/repos/o/r/check-suites/44') return suite;
    if (path === '/repos/o/r/actions/runs?check_suite_id=44&per_page=2') return runs;
    if (path === '/repos/o/r/actions/runs/7') return workflow;
    throw new Error(`unexpected ${path}`);
  },
});
test('28 wrong Check App blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(checkArgs({ check: checkRecord({ app: { id: 1, slug: 'spoof' } }) })),
  /CHECK_APP/u,
));
test('29 wrong Check Suite blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(checkArgs({ suite: suiteRecord({ head_sha: sha('f') }) })),
  /CHECK_SUITE_HEAD_MISMATCH/u,
));
test('30 spoofed details_url blocks', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(checkArgs({ check: checkRecord({ details_url: 'https://example.com/spoof' }) })),
  /CHECK_DETAILS_URL_MISMATCH/u,
));
test('31 reversed Check timestamps block', async () => assert.rejects(
  fetchAuthoritativeCiEvidence(checkArgs({ check: checkRecord({
    started_at: '2026-08-05T23:02:00Z', completed_at: '2026-08-05T23:01:00Z',
  }) })),
  /CHECK_TIMESTAMP_ORDER_INVALID/u,
));
test('32 candidate trust_class cannot create CI PASS', () => assert.throws(() => produceTrustedEvidenceEntries({
  identity,
  requiredTypes: ['ci'],
  proofs: { ci: {
    authority: 'CANDIDATE_CLAIM', record_id: 7, record_url: 'x', status: 'completed',
    conclusion: 'success', head_sha: identity.candidate_sha, repository: 'o/r', run_attempt: 2,
    source: 'x', command_or_path: 'x',
  } },
  producedAt: now.toISOString(),
}), /GITHUB_AUTHORITY_MISSING/u));

// Founder immutable record authority.
test('33 fabricated TRUSTED_GITHUB_RECORD JSON blocks', () => assert.throws(
  () => assertNoSelfAssertedEvidence({ PHOENIX_FOUNDER_EVIDENCE_JSON: '{"trust_class":"TRUSTED_GITHUB_RECORD"}' }),
  /SELF_ASSERTED_FOUNDER_EVIDENCE_FORBIDDEN/u,
));
test('34 missing Founder record ID blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence({ ...founderArgs(review()), reference: {} }),
  /RECORD_REFERENCE_REQUIRED/u,
));
test('35 Review commit_id equals current Head passes', async () => assert.equal(
  (await fetchAuthoritativeFounderEvidence(founderArgs(review()))).authority,
  'GITHUB_API_VERIFIED',
));
test('36 Review old commit_id blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth(), { commit_id: sha('f') }))),
  /REVIEW_COMMIT_MISMATCH/u,
));
test('37 dismissed Review blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth(), { state: 'DISMISSED' }))),
  /REVIEW_NOT_APPROVED/u,
));
test('38 edited comment matching updated_at semantics passes', async () => assert.equal(
  (await fetchAuthoritativeFounderEvidence(founderArgs(comment(), { comment_id: '10' }))).record_type,
  'issue_comment',
));
test('39 edited comment stale issued_at blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(
    comment(commentAuth({ issued_at: '2026-08-05T23:00:00Z' })),
    { comment_id: '10' },
  )),
  /ISSUED_AT_MISMATCH/u,
));
test('40 deleted Founder record fails closed', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence({
    ...founderArgs(review()),
    request: async () => { throw Object.assign(new Error('404'), { code: 'TRUSTED_GITHUB_API_REQUEST_FAILED:404' }); },
  }),
  /404/u,
));
test('41 wrong Founder identity blocks even with OWNER association', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(
    auth({ founder_github_identity: 'attacker' }),
    { user: { login: 'attacker' }, author_association: 'OWNER' },
  ))),
  /IDENTITY_NOT_ALLOWED/u,
));
test('Founder record with unapproved association blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(
    auth(),
    { author_association: 'NONE' },
  ))),
  /AUTHOR_ASSOCIATION_NOT_ALLOWED/u,
));
test('42 wrong PR blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ pr_number: 149 })))),
  /PR_MISMATCH/u,
));
test('43 wrong Head blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ exact_head: sha('f') })))),
  /HEAD_MISMATCH/u,
));
test('44 wrong action type blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ action_type: 'READY_AUTHORIZATION' })))),
  /ACTION_MISMATCH/u,
));
test('45 MERGE authorization cannot replace READY', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence({
    ...founderArgs(review(auth({ action_type: 'MERGE_AUTHORIZATION' }))),
    expectedAction: 'READY_AUTHORIZATION',
  }),
  /ACTION_MISMATCH/u,
));
test('46 READY authorization cannot replace GOVERNANCE', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ action_type: 'READY_AUTHORIZATION' })))),
  /ACTION_MISMATCH/u,
));
test('47 expired authorization blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ expires_at: '2026-08-05T23:30:00Z' })))),
  /EXPIRED/u,
));
test('48 revoked authorization blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ revoked: true })))),
  /REVOKED/u,
));
test('49 malformed issued_at blocks', async () => assert.rejects(
  fetchAuthoritativeFounderEvidence(founderArgs(review(auth({ issued_at: 'bad' })))),
  /SCHEMA_INVALID|ISSUED_AT_INVALID/u,
));
test('50 Founder record schema is authoritative', () => assert.equal(
  validateObject(founderSchema, auth(), 'founder_authorization').action_type,
  'GOVERNANCE_PASS',
));
test('51 action mapping is exact', () => {
  assert.equal(requiredFounderAction({ requested_actions: ['READY'] }), 'READY_AUTHORIZATION');
  assert.equal(requiredFounderAction({ requested_actions: [] }), 'GOVERNANCE_PASS');
});
test('52 trusted GitHub client rejects untrusted API path', async () => {
  const request = createTrustedGithubRequest({
    repository: 'o/r',
    token: 'test',
    apiUrl: 'https://api.github.com',
    fetchImpl: async () => ({ ok: true, json: async () => ({}) }),
  });
  await assert.rejects(request('/repos/x/y/actions/runs/1'), /API_PATH_INVALID/u);
});
test('53 evidence inventory remains exact', () => assert.deepEqual(
  normalizeRequiredEvidenceTypes([
    'repository evidence', 'commit evidence', 'diff evidence', 'changed paths evidence',
    'test evidence', 'ci evidence', 'workflow evidence', 'founder evidence',
  ]),
  TRUSTED_EVIDENCE_TYPES,
));
