import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

import {
  assertMandatoryRuleInventory,
  assertTrustedSchemaInventory,
} from '../src/rule-authority.mjs';
import { compileTrustedSchema, validateObject } from '../src/schema-validator.mjs';
import { canonicalJson, sha256Text } from '../src/identity-freshness.mjs';

const root = resolve(import.meta.dirname, '../../..');
const load = (path) => JSON.parse(readFileSync(resolve(root, path), 'utf8'));
const registry = load('ai/development/policies/rule_registry.json');
const ruleInventory = load('ai/development/policies/trusted_rule_inventory.json');
const schemaInventory = load('ai/development/policies/trusted_schema_inventory.json');
const policy = load('ai/development/policies/evidence_policy.json');
const schemas = Object.fromEntries(
  schemaInventory.schemas.map((item) => [item.path, load(item.path)]),
);

const sha = (character) => character.repeat(40);
const digest = (character) => character.repeat(64);
const producedAt = '2026-08-06T00:00:00Z';

const identity = {
  repository: 'o/r',
  pr_number: 148,
  base_branch: 'main',
  base_sha: sha('a'),
  head_branch: 'feature',
  candidate_sha: sha('b'),
  candidate_tree: sha('c'),
  task_contract_digest: digest('d'),
  governance_body_digest: digest('e'),
  workflow_run_id: '10',
  run_attempt: 1,
  event_type: 'pull_request_target',
  produced_at: producedAt,
  state: 'open',
  draft: true,
  freshness_status: 'PASS',
  rule_inventory_digest: digest('f'),
  schema_inventory_digest: digest('1'),
  secret_scan: 'PASS',
  candidate_gate_claims: [],
};

const entry = {
  evidence_id: 'trusted-repository-01',
  evidence_type: 'repository',
  source: 'live-github-pr',
  command_or_path: 'GET /repos/o/r/pulls/148',
  candidate_sha: identity.candidate_sha,
  produced_at: producedAt,
  result: 'PASS',
  evidence_level: 'VERIFIED',
  limitations: [],
  base_sha: identity.base_sha,
  task_contract_digest: identity.task_contract_digest,
  governance_body_digest: identity.governance_body_digest,
  workflow_run_id: identity.workflow_run_id,
  run_attempt: identity.run_attempt,
};

const manifest = {
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
  required_evidence_types: ['repository'],
  evidence: [entry],
};

const validReport = {
  report_id: digest('2'),
  repository: identity.repository,
  pr_number: identity.pr_number,
  base_sha: identity.base_sha,
  candidate_sha: identity.candidate_sha,
  candidate_tree: identity.candidate_tree,
  trusted_runner_sha: sha('f'),
  workflow_run_id: identity.workflow_run_id,
  run_attempt: identity.run_attempt,
  deterministic_result: 'PASS',
  ai_review_result: 'NOT_RUN',
  founder_gate_result: 'NOT_APPROVED',
  final_agent_decision: 'DETERMINISTIC_SOURCE_GATES_PASS_BOOTSTRAP_PENDING_MERGE',
  identity,
  evidence_manifest: manifest,
  findings: [],
  produced_at: producedAt,
};

test('mandatory PDA-R001 through PDA-R026 inventory passes', () => {
  assert.match(
    assertMandatoryRuleInventory(registry, ruleInventory),
    /^[0-9a-f]{64}$/u,
  );
});

test('Missing PDA-R016 blocks', () => {
  const candidate = structuredClone(registry);
  candidate.rules = candidate.rules.filter((rule) => rule.rule_id !== 'PDA-R016');
  assert.throws(
    () => assertMandatoryRuleInventory(candidate, ruleInventory),
    /PDA-R016/u,
  );
});

test('Changed Rule severity blocks', () => {
  const candidate = structuredClone(registry);
  candidate.rules[0].severity = 'P3';
  assert.throws(
    () => assertMandatoryRuleInventory(candidate, ruleInventory),
    /AUTHORITY_CHANGED/u,
  );
});

test('Changed enforcement type blocks', () => {
  const candidate = structuredClone(registry);
  candidate.rules[0].enforcement_type = 'AI_REVIEW';
  assert.throws(
    () => assertMandatoryRuleInventory(candidate, ruleInventory),
    /AUTHORITY_CHANGED/u,
  );
});

test('all trusted Schemas compile in strict Draft 2020-12 mode', () => {
  for (const [path, schema] of Object.entries(schemas)) {
    assert.equal(typeof compileTrustedSchema(schema, path), 'function');
  }
});

test('Evidence policy type inventory is exact and producer-specific', () => {
  assert.deepEqual(policy.evidence_types, [
    'repository',
    'commit',
    'diff',
    'changed_paths',
    'test',
    'ci',
    'workflow',
    'founder',
  ]);
  assert.deepEqual(
    Object.keys(policy.type_specific_authority),
    policy.evidence_types,
  );
  for (const type of policy.evidence_types) {
    assert.equal(
      policy.type_specific_authority[type].terminal_proof_required,
      true,
    );
    assert.ok(policy.type_specific_authority[type].producer);
  }
});

test('Policy and Evidence Schema required fields do not drift', () => {
  const evidenceSchema =
    schemas['ai/development/schemas/evidence_manifest.schema.json'];
  const required = new Set(evidenceSchema.$defs.evidenceEntry.required);
  for (const field of policy.required_fields) assert.ok(required.has(field));
  for (const field of policy.binding_fields) assert.ok(required.has(field));
  assert.deepEqual(
    evidenceSchema.$defs.evidenceEntry.properties.evidence_type.enum,
    policy.evidence_types,
  );
});

test('Audit Report uses strict nested identity, Evidence, and Finding refs', () => {
  const reportSchema = schemas['ai/development/schemas/audit_report.schema.json'];
  assert.equal(reportSchema.properties.identity.$ref, '#/$defs/identity');
  assert.equal(
    reportSchema.properties.evidence_manifest.$ref,
    '#/$defs/evidenceManifest',
  );
  assert.equal(
    reportSchema.properties.findings.items.$ref,
    '#/$defs/finding',
  );
  for (const nested of ['identity', 'evidenceManifest', 'finding']) {
    assert.equal(reportSchema.$defs[nested].additionalProperties, false);
  }
});

test('valid complete Audit Report passes', () => {
  assert.equal(
    validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      validReport,
      'audit_report',
    ),
    validReport,
  );
});

test('invalid nested Finding blocks', () => {
  const candidate = structuredClone(validReport);
  candidate.findings = [{ finding_id: 'incomplete' }];
  assert.throws(
    () => validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    /AUDIT_REPORT_SCHEMA_INVALID/u,
  );
});

test('invalid nested Evidence Manifest blocks', () => {
  const candidate = structuredClone(validReport);
  delete candidate.evidence_manifest.evidence[0].command_or_path;
  assert.throws(
    () => validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    /AUDIT_REPORT_SCHEMA_INVALID/u,
  );
});

test('invalid nested identity blocks', () => {
  const candidate = structuredClone(validReport);
  delete candidate.identity.head_branch;
  assert.throws(
    () => validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    /AUDIT_REPORT_SCHEMA_INVALID/u,
  );
});

test('malformed BLOCKED report blocks', () => {
  const candidate = structuredClone(validReport);
  candidate.deterministic_result = 'BLOCKED';
  candidate.final_agent_decision = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
  delete candidate.findings;
  assert.throws(
    () => validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    /AUDIT_REPORT_SCHEMA_INVALID/u,
  );
});

test('malformed error report blocks', () => {
  const candidate = structuredClone(validReport);
  candidate.deterministic_result = 'BLOCKED';
  candidate.error_code = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
  candidate.identity.freshness_status = 'BLOCKED';
  delete candidate.evidence_manifest;
  assert.throws(
    () => validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    /AUDIT_REPORT_SCHEMA_INVALID/u,
  );
});

test('well-formed BLOCKED error report passes the same Audit Report Schema', () => {
  const candidate = structuredClone(validReport);
  candidate.deterministic_result = 'BLOCKED';
  candidate.final_agent_decision = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
  candidate.error_code = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
  candidate.identity.freshness_status = 'BLOCKED';
  candidate.identity.secret_scan = 'NOT_RUN';
  candidate.evidence_manifest.required_evidence_types = ['workflow'];
  candidate.evidence_manifest.evidence[0] = {
    ...candidate.evidence_manifest.evidence[0],
    evidence_id: 'trusted-workflow-blocked-01',
    evidence_type: 'workflow',
    source: 'trusted-runner-error-boundary',
    command_or_path: '.github/workflows/phoenix-agent-audit.yml',
    result: 'BLOCKED',
    limitations: ['Fail-closed error'],
  };
  candidate.findings = [{
    finding_id: 'PDA-F-TRUSTED-0001',
    rule_id: 'PDA-R004',
    title: 'Trusted audit failed closed',
    area: 'evidence_binding',
    severity: 'P1',
    result: 'BLOCKED',
    evidence_level: 'VERIFIED',
    expected: 'Fresh trusted evidence.',
    actual: 'Evidence was stale.',
    exact_paths: [],
    candidate_sha: identity.candidate_sha,
    stable_sha: sha('9'),
    evidence: ['trusted audit error boundary'],
    root_cause: 'EVIDENCE_STALE_REAUDIT_REQUIRED',
    required_action: 'Re-audit.',
    proposed_scope: [],
    auto_fix_permitted: false,
    founder_authorization_required: false,
    status: 'BLOCKED',
  }];
  assert.equal(
    validateObject(
      schemas['ai/development/schemas/audit_report.schema.json'],
      candidate,
      'audit_report',
    ),
    candidate,
  );
});

test('trusted Schema inventory passes exact canonical digests', () => {
  assert.match(
    assertTrustedSchemaInventory(schemas, schemaInventory),
    /^[0-9a-f]{64}$/u,
  );
});

test('trusted inventory digest mismatch blocks', () => {
  const candidate = structuredClone(schemaInventory);
  const target = candidate.schemas.find((item) =>
    item.path.endsWith('evidence_manifest.schema.json'));
  target.sha256 = digest('0');
  assert.throws(
    () => assertTrustedSchemaInventory(schemas, candidate),
    /AUTHORITY_CHANGED/u,
  );
});

test('non-target Schema digest change blocks', () => {
  const candidate = structuredClone(schemaInventory);
  const target = candidate.schemas.find((item) =>
    item.path.endsWith('task_contract.schema.json'));
  target.sha256 = digest('0');
  assert.throws(
    () => assertTrustedSchemaInventory(schemas, candidate),
    /AUTHORITY_CHANGED/u,
  );
});

test('unknown Schema added blocks', () => {
  const candidate = {
    ...schemas,
    'ai/development/schemas/unexpected.schema.json': {
      $schema: 'https://json-schema.org/draft/2020-12/schema',
      $id: 'https://phoenix.local/schemas/unexpected.schema.json',
      type: 'object',
      properties: {},
    },
  };
  assert.throws(
    () => assertTrustedSchemaInventory(candidate, schemaInventory),
    /TRUSTED_SCHEMA_UNAUTHORIZED/u,
  );
});

test('only the three authorized Schema digests changed', () => {
  const old = {
    'ai/development/schemas/task_contract.schema.json':
      '40cae12746df8c206b7c5cccde4a31403c6ec5e927cbd2c217916eef2d1b2ef8',
    'ai/development/schemas/evidence_manifest.schema.json':
      'b0ca5ba088f98c8dc02485ad2b6fbe9f27a02d0c831e1e3a671e227b5ff376ef',
    'ai/development/schemas/finding.schema.json':
      '485cdffc8c4b77582d9e04f70a5eaec4ae1c4a1a38a5870279ce62549319dba4',
    'ai/development/schemas/audit_report.schema.json':
      '238cf0275b680caeffcaa0fdf174b91476401b2c79618be0ac2fac5cd0430b78',
    'ai/development/schemas/execution_principal.schema.json':
      'f1dc2e05540aa73701b83cf209664f8c2560a217c33b86da4b391b392cef869a',
    'ai/development/schemas/founder_authorization.schema.json':
      '7af6deecb3fc4c3fff516b21f47e8b7d80231358da971c2fea4c63897b4f8536',
  };
  const allowed = new Set([
    'ai/development/schemas/evidence_manifest.schema.json',
    'ai/development/schemas/finding.schema.json',
    'ai/development/schemas/audit_report.schema.json',
  ]);
  for (const item of schemaInventory.schemas) {
    if (allowed.has(item.path)) assert.notEqual(item.sha256, old[item.path]);
    else assert.equal(item.sha256, old[item.path]);
  }
});

test('three updated Schema digests equal the exact canonical files', () => {
  for (const item of schemaInventory.schemas) {
    if (![
      'ai/development/schemas/evidence_manifest.schema.json',
      'ai/development/schemas/finding.schema.json',
      'ai/development/schemas/audit_report.schema.json',
    ].includes(item.path)) continue;
    assert.equal(
      item.sha256,
      sha256Text(canonicalJson(schemas[item.path])),
      item.path,
    );
  }
});
