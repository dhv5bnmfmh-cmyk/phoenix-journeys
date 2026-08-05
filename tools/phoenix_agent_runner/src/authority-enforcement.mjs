const FORBIDDEN_ACTIONS = new Set([
  'WRITE_FILES','MODIFY_CODE','COMMIT','PUSH','UPDATE_PR','READY','MERGE','AUTO_MERGE','RELEASE','DEPLOY','DELETE_PREVIEW','DELETE_BRANCH','START_NEXT_PHASE','CLOSE_FINDING',
]);
const READ_ACTIONS = new Set(['READ_REPOSITORY','READ_PR_METADATA','READ_DIFF','VALIDATE_CONFIG','VALIDATE_EVIDENCE','GENERATE_AUDIT_REPORT','RUN_TRUSTED_TESTS']);
const FOUNDER_ACTIONS = new Set(['GOVERNANCE_PASS','READY_AUTHORIZATION','MERGE_AUTHORIZATION','PREVIEW_DELETION_AUTHORIZATION','NEXT_PHASE_AUTHORIZATION']);

export function normalizeAction(action) {
  const normalized = String(action ?? '').trim().toUpperCase().replace(/[\s-]+/g, '_');
  if (!normalized || (!READ_ACTIONS.has(normalized) && !FORBIDDEN_ACTIONS.has(normalized))) throw new Error(`UNKNOWN_ACTION_FAIL_CLOSED:${normalized || 'EMPTY'}`);
  return normalized;
}

export function assertPhaseAActions(actions) {
  for (const action of actions ?? []) {
    const normalized = normalizeAction(action);
    if (FORBIDDEN_ACTIONS.has(normalized)) throw new Error(`PHASE_A_ACTION_PROHIBITED:${normalized}`);
  }
  return true;
}

export function assertPrincipalSeparation(principals) {
  const byId = new Map();
  for (const principal of principals ?? []) {
    const id = principal.execution_principal_id;
    if (!id) throw new Error('EXECUTION_PRINCIPAL_ID_MISSING');
    const roles = byId.get(id) ?? new Set();
    roles.add(principal.role);
    byId.set(id, roles);
  }
  for (const [id, roles] of byId) {
    const conflicts = [
      ['BUILDER','FINAL_AUDITOR'],
      ['BUILDER','FOUNDER_APPROVAL_AUTHORITY'],
      ['FINAL_AUDITOR','FOUNDER_APPROVAL_AUTHORITY'],
    ];
    if (conflicts.some(([a,b]) => roles.has(a) && roles.has(b))) throw new Error(`EXECUTION_PRINCIPAL_ROLE_CONFLICT:${id}`);
  }
  return true;
}

export function validateFounderAuthorization(record, expected) {
  if (!record) throw new Error('FOUNDER_AUTHORIZATION_NOT_PRESENT');
  if (record.trust_class !== 'TRUSTED_GITHUB_RECORD') throw new Error('CANDIDATE_FOUNDER_CLAIM_UNTRUSTED');
  if (!FOUNDER_ACTIONS.has(record.action_type)) throw new Error('FOUNDER_ACTION_TYPE_INVALID');
  if (record.repository !== expected.repository || Number(record.pr_number) !== Number(expected.prNumber) || record.exact_head !== expected.head) throw new Error('FOUNDER_AUTHORIZATION_IDENTITY_MISMATCH');
  if (record.revoked === true) throw new Error('FOUNDER_AUTHORIZATION_REVOKED');
  if (!record.founder_github_identity || !record.trusted_evidence_source) throw new Error('FOUNDER_AUTHORIZATION_SOURCE_MISSING');
  if (record.expires_at && Date.parse(record.expires_at) <= Date.now()) throw new Error('FOUNDER_AUTHORIZATION_EXPIRED');
  return true;
}

export function candidateGateClaims(taskContract) {
  const claims = [];
  const visit = (value, path = '') => {
    if (value && typeof value === 'object') for (const [key, child] of Object.entries(value)) visit(child, path ? `${path}.${key}` : key);
    else if (['PASS','PRESENT','APPROVED'].includes(String(value).toUpperCase())) claims.push({ path, value, trust: 'UNTRUSTED_CANDIDATE_CLAIM' });
  };
  visit(taskContract);
  return claims;
}
