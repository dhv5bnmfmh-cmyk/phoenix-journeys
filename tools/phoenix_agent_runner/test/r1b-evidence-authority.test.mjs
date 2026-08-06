import test from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { cpSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';

import {
  buildLiveIdentity,
  assertCanonicalFreshness,
  assertTaskContractIdentity,
} from '../src/identity-freshness.mjs';
import {
  TRUSTED_EVIDENCE_TYPES,
  createTrustedEvidenceManifest,
  normalizeRequiredEvidenceTypes,
  produceTrustedEvidenceEntries,
  validateEvidenceManifest,
} from '../src/evidence-authority.mjs';
import { runTrustedAudit } from '../src/trusted-cli.mjs';

const sha = (character) => character.repeat(40);
const digest = (character) => character.repeat(64);
const producedAt = '2026-08-06T00:00:00Z';
const now = new Date(producedAt);

const identity = {
  repository: 'o/r',
  pr_number: 148,
  base_branch: 'main',
  base_sha: sha('a'),
  head_branch: 'governance/development-agent-system-phase-a',
  candidate_sha: sha('b'),
  candidate_tree: sha('c'),
  task_contract_digest: digest('d'),
  governance_body_digest: digest('e'),
  workflow_run_id: '100',
  run_attempt: 2,
};

const policy = {
  evidence_types: [...TRUSTED_EVIDENCE_TYPES],
  required_fields: [
    'evidence_id',
    'evidence_type',
    'source',
    'command_or_path',
    'candidate_sha',
    'produced_at',
    'result',
    'evidence_level',
    'limitations',
  ],
};

function proof(type, overrides = {}) {
  const common = {
    status: 'completed',
    result: 'PASS',
    candidate_sha: identity.candidate_sha,
    source: `trusted-${type}`,
    command_or_path: `verify:${type}`,
    limitations: [],
  };
  const byType = {
    repository: { repository: identity.repository },
    commit: {
      base_sha: identity.base_sha,
      candidate_tree: identity.candidate_tree,
    },
    diff: { base_sha: identity.base_sha },
    changed_paths: { paths: ['a.txt'] },
    test: { total: 3, passed: 3, failed: 0, skipped: 0 },
    ci: {
      status: 'completed',
      conclusion: 'success',
      head_sha: identity.candidate_sha,
    },
    workflow: {
      workflow_run_id: identity.workflow_run_id,
      run_attempt: identity.run_attempt,
    },
    founder: {
      trust_class: 'TRUSTED_GITHUB_RECORD',
      repository: identity.repository,
      pr_number: identity.pr_number,
      exact_head: identity.candidate_sha,
      revoked: false,
      result: 'PASS',
    },
  };
  return { ...common, ...byType[type], ...overrides };
}

function allProofs() {
  return Object.fromEntries(TRUSTED_EVIDENCE_TYPES.map((type) => [type, proof(type)]));
}

function validManifest(requiredTypes = TRUSTED_EVIDENCE_TYPES) {
  const entries = produceTrustedEvidenceEntries({
    identity,
    requiredTypes,
    proofs: allProofs(),
    producedAt,
  });
  return createTrustedEvidenceManifest({
    identity,
    requiredTypes,
    entries,
    producedAt,
  });
}

for (const [name, field, value] of [
  ['Base branch changed with same SHA', 'base_branch', 'release'],
  ['Head branch changed with same SHA', 'head_branch', 'renamed-branch'],
  ['PR Body digest stale', 'governance_body_digest', digest('f')],
  ['Task Contract digest stale', 'task_contract_digest', digest('f')],
  ['old run attempt', 'run_attempt', 1],
  ['no-op Commit stale evidence', 'candidate_sha', sha('f')],
  ['old Artifact reuse', 'workflow_run_id', '99'],
]) {
  test(`${name} is blocked by canonical freshness`, () => {
    assert.throws(
      () => assertCanonicalFreshness({ ...identity, [field]: value }, identity),
      (error) => error.message === 'EVIDENCE_STALE_REAUDIT_REQUIRED'
        && error.stale_fields.includes(field),
    );
  });
}

test('all canonical freshness fields exactly match', () => {
  assert.equal(assertCanonicalFreshness(identity, structuredClone(identity)), true);
});

test('Task Contract binds repository, PR, Base branch, Head branch, and SHA', () => {
  const task = {
    repository: identity.repository,
    base_branch: identity.base_branch,
    base_sha: identity.base_sha,
    head_branch: identity.head_branch,
    current_head_sha: identity.candidate_sha,
  };
  assert.equal(assertTaskContractIdentity(task, identity, 148), true);
  assert.throws(
    () => assertTaskContractIdentity({ ...task, base_branch: 'release' }, identity, 148),
    /EVIDENCE_STALE_REAUDIT_REQUIRED/u,
  );
});

test('buildLiveIdentity includes live branch identity and digests', () => {
  const task = {
    repository: 'o/r',
    base_branch: 'main',
    base_sha: sha('a'),
    head_branch: 'feature',
    current_head_sha: sha('b'),
  };
  const built = buildLiveIdentity({
    metadata: {
      repository: 'o/r',
      number: 148,
      base_branch: 'main',
      base_sha: sha('a'),
      head_branch: 'feature',
      head_sha: sha('b'),
      head_tree: sha('c'),
      body: '<!-- PHOENIX_TASK_CONTRACT_JSON_START -->\n```json\n{}\n```\n<!-- PHOENIX_TASK_CONTRACT_JSON_END -->',
      draft: true,
      state: 'open',
    },
    taskContract: task,
    runId: '10',
    runAttempt: 2,
    eventType: 'pull_request_target',
    producedAt,
  });
  assert.equal(built.repository, 'o/r');
  assert.equal(built.head_branch, 'feature');
  assert.match(built.task_contract_digest, /^[0-9a-f]{64}$/u);
  assert.match(built.governance_body_digest, /^[0-9a-f]{64}$/u);
});

test('Task Contract evidence names normalize only to registered Base types', () => {
  assert.deepEqual(
    normalizeRequiredEvidenceTypes([
      'repository evidence',
      'commit evidence',
      'diff evidence',
      'changed paths evidence',
      'test evidence',
      'ci evidence',
      'workflow evidence',
      'founder evidence',
    ]),
    TRUSTED_EVIDENCE_TYPES,
  );
});

test('unknown evidence type blocks', () => {
  assert.throws(
    () => normalizeRequiredEvidenceTypes(['unregistered evidence']),
    /EVIDENCE_TYPE_UNREGISTERED/u,
  );
});

test('every registered evidence type has a type-specific producer', () => {
  const manifest = validManifest();
  assert.deepEqual(
    manifest.evidence.map((entry) => entry.evidence_type),
    TRUSTED_EVIDENCE_TYPES,
  );
  assert.ok(manifest.evidence.every((entry) => entry.result === 'PASS'));
});

test('Founder evidence without a trusted Founder proof blocks', () => {
  assert.throws(
    () => produceTrustedEvidenceEntries({
      identity,
      requiredTypes: ['founder'],
      proofs: {},
      producedAt,
    }),
    /EVIDENCE_PROOF_MISSING:founder/u,
  );
  assert.throws(
    () => produceTrustedEvidenceEntries({
      identity,
      requiredTypes: ['founder'],
      proofs: { founder: proof('founder', { trust_class: 'CANDIDATE_CLAIM' }) },
      producedAt,
    }),
    /FOUNDER_EVIDENCE_UNTRUSTED/u,
  );
});

test('test evidence without a terminal test result blocks', () => {
  assert.throws(
    () => produceTrustedEvidenceEntries({
      identity,
      requiredTypes: ['test'],
      proofs: { test: proof('test', { status: 'in_progress' }) },
      producedAt,
    }),
    /EVIDENCE_NOT_TERMINAL:test/u,
  );
});

test('CI evidence for an old Head blocks', () => {
  assert.throws(
    () => produceTrustedEvidenceEntries({
      identity,
      requiredTypes: ['ci'],
      proofs: { ci: proof('ci', { head_sha: sha('f') }) },
      producedAt,
    }),
    /EVIDENCE_STALE_HEAD:ci/u,
  );
});

test('Candidate request does not synthesize PASS without type proof', () => {
  assert.throws(
    () => produceTrustedEvidenceEntries({
      identity,
      requiredTypes: ['repository', 'test'],
      proofs: { repository: proof('repository') },
      producedAt,
    }),
    /EVIDENCE_PROOF_MISSING:test/u,
  );
});

test('Evidence entry missing command_or_path blocks production validation', () => {
  const manifest = validManifest(['repository']);
  delete manifest.evidence[0].command_or_path;
  assert.throws(
    () => validateEvidenceManifest(manifest, {
      identity,
      requiredTypes: ['repository'],
      policy,
      now,
    }),
    /EVIDENCE_ENTRY_FIELD_MISSING:command_or_path/u,
  );
});

test('Evidence entry missing produced_at blocks production validation', () => {
  const manifest = validManifest(['repository']);
  delete manifest.evidence[0].produced_at;
  assert.throws(
    () => validateEvidenceManifest(manifest, {
      identity,
      requiredTypes: ['repository'],
      policy,
      now,
    }),
    /EVIDENCE_ENTRY_FIELD_MISSING:produced_at/u,
  );
});

test('old Artifact manifest binding blocks', () => {
  const manifest = validManifest(['workflow']);
  manifest.workflow_run_id = '99';
  assert.throws(
    () => validateEvidenceManifest(manifest, {
      identity,
      requiredTypes: ['workflow'],
      policy,
      now,
    }),
    /EVIDENCE_BINDING_MISMATCH:workflow_run_id/u,
  );
});

test('old run attempt entry blocks', () => {
  const manifest = validManifest(['workflow']);
  manifest.evidence[0].run_attempt = 1;
  assert.throws(
    () => validateEvidenceManifest(manifest, {
      identity,
      requiredTypes: ['workflow'],
      policy,
      now,
    }),
    /EVIDENCE_ENTRY_STALE_RUN/u,
  );
});

test('fully bound, schema-shaped manifest validates', () => {
  const manifest = validManifest();
  assert.match(
    validateEvidenceManifest(manifest, {
      identity,
      requiredTypes: TRUSTED_EVIDENCE_TYPES,
      policy,
      now,
    }),
    /^[0-9a-f]{64}$/u,
  );
});


function git(repo, ...args) {
  return execFileSync('git', ['-C', repo, ...args], { encoding: 'utf8' }).trim();
}

function contractBody(contract, suffix = '') {
  return [
    '<!-- PHOENIX_TASK_CONTRACT_JSON_START -->',
    '```json',
    JSON.stringify(contract, null, 2),
    '```',
    '<!-- PHOENIX_TASK_CONTRACT_JSON_END -->',
    suffix,
  ].join('\n');
}

function productionFixture() {
  const root = mkdtempSync(join(tmpdir(), 'phoenix-r1b2a-production-'));
  const trusted = join(root, 'trusted');
  const candidate = join(root, 'candidate');
  const output = join(root, 'output');
  mkdirSync(join(trusted, 'ai/development'), { recursive: true });
  mkdirSync(join(trusted, 'tools/phoenix_agent_runner'), { recursive: true });
  const sourceRoot = resolve(import.meta.dirname, '../../..');
  cpSync(join(sourceRoot, 'ai/development/policies'), join(trusted, 'ai/development/policies'), { recursive: true });
  cpSync(join(sourceRoot, 'ai/development/schemas'), join(trusted, 'ai/development/schemas'), { recursive: true });

  git(trusted, 'init', '-q');
  git(trusted, 'config', 'user.email', 'phoenix@example.invalid');
  git(trusted, 'config', 'user.name', 'Phoenix Trusted Test');
  writeFileSync(join(trusted, 'README.md'), 'trusted\n');
  git(trusted, 'add', '.');
  git(trusted, 'commit', '-qm', 'trusted base');

  mkdirSync(candidate, { recursive: true });
  git(candidate, 'init', '-q');
  git(candidate, 'config', 'user.email', 'phoenix@example.invalid');
  git(candidate, 'config', 'user.name', 'Phoenix Candidate Test');
  writeFileSync(join(candidate, 'README.md'), 'base\n');
  git(candidate, 'add', '.');
  git(candidate, 'commit', '-qm', 'base');
  const baseSha = git(candidate, 'rev-parse', 'HEAD');
  writeFileSync(join(candidate, 'README.md'), 'candidate\n');
  git(candidate, 'add', '.');
  git(candidate, 'commit', '-qm', 'candidate');
  const priorHead = git(candidate, 'rev-parse', 'HEAD');
  git(candidate, 'commit', '--allow-empty', '-qm', 'no-op identity advance');
  const headSha = git(candidate, 'rev-parse', 'HEAD');
  const headTree = git(candidate, 'rev-parse', 'HEAD^{tree}');

  const contract = {
    task_id: 'PHOENIX-R1B2A-PRODUCTION-TEST',
    task_title: 'Production freshness and evidence authority test',
    task_mode: 'READ_ONLY_AUDIT',
    repository: 'o/r',
    expected_main: baseSha,
    base_branch: 'main',
    base_sha: baseSha,
    head_branch: 'feature',
    initial_head_sha: priorHead,
    current_head_sha: headSha,
    authorized_scope: 'Read-only production entry verification.',
    allowed_paths: ['**'],
    forbidden_paths: [],
    authorized_findings: [],
    prohibited_actions: [],
    applicable_rules: Array.from({ length: 26 }, (_, index) =>
      `PDA-R${String(index + 1).padStart(3, '0')}`),
    required_tests: ['R1-B evidence freshness tests'],
    required_evidence: [
      'repository evidence',
      'commit evidence',
      'diff evidence',
      'test evidence',
    ],
    founder_gates: {
      founder_governance_review: 'NOT_APPROVED',
      ready_authorization: 'NOT_PRESENT',
      merge_authorization: 'NOT_PRESENT',
      preview_deletion_authorization: 'NOT_PRESENT',
      next_phase_authorization: 'NOT_PRESENT',
    },
    external_disclosure: { permitted: false, services: [], content: [] },
    retry_limit: 0,
    stop_conditions: ['evidence_not_bound_to_remote_head'],
    builder_agent: 'PhoenixBuilderAgent',
    auditor_agent: 'PhoenixAuditAgent',
    requested_agents: ['PhoenixAuditAgent'],
    requested_actions: ['READ_REPOSITORY', 'READ_PR_METADATA', 'READ_DIFF', 'VALIDATE_EVIDENCE', 'GENERATE_AUDIT_REPORT'],
  };
  const body = contractBody(contract);
  const live = {
    repository: 'o/r',
    number: 148,
    base_branch: 'main',
    base_sha: baseSha,
    head_branch: 'feature',
    head_sha: headSha,
    head_tree: headTree,
    body,
    draft: true,
    state: 'open',
  };
  const event = {
    repository: { full_name: 'o/r' },
    pull_request: {
      number: 148,
      base: { ref: 'main', sha: baseSha },
      head: { ref: 'feature', sha: headSha },
      body,
      draft: true,
      state: 'open',
    },
  };
  const eventPath = join(root, 'event.json');
  writeFileSync(eventPath, JSON.stringify(event));
  const env = {
    GITHUB_REPOSITORY: 'o/r',
    GITHUB_TOKEN: 'test-token-not-a-real-secret',
    GITHUB_API_URL: 'https://api.github.invalid',
    GITHUB_RUN_ID: '100',
    GITHUB_RUN_ATTEMPT: '2',
    GITHUB_EVENT_NAME: 'pull_request_target',
    GITHUB_ACTOR: 'phoenix-test',
    GITHUB_TRIGGERING_ACTOR: 'phoenix-test',
  };
  const tap = [
    'TAP version 13',
    '1..2',
    '# tests 2',
    '# pass 2',
    '# fail 0',
    '# skipped 0',
  ].join('\n');
  const args = [
    '--trusted', trusted,
    '--candidate', candidate,
    '--event', eventPath,
    '--pr-number', '148',
    '--output', output,
  ];
  return {
    root, trusted, candidate, output, contract, body, live, event, eventPath,
    env, args, baseSha, priorHead, headSha, headTree,
    fetchLive: async () => structuredClone(live),
    runTests: () => tap,
    cleanup: () => rmSync(root, { recursive: true, force: true }),
  };
}

async function runProduction(fixture, overrides = {}) {
  const event = structuredClone(overrides.event ?? fixture.event);
  writeFileSync(fixture.eventPath, JSON.stringify(event));
  const argv = [...fixture.args];
  if (overrides.previousIdentity) {
    const previousPath = join(fixture.root, 'previous-identity.json');
    writeFileSync(previousPath, JSON.stringify(overrides.previousIdentity));
    argv.push('--previous-identity', previousPath);
  }
  return runTrustedAudit({
    argv,
    env: { ...fixture.env, ...(overrides.env ?? {}) },
    fetchLive: overrides.fetchLive ?? fixture.fetchLive,
    runTests: fixture.runTests,
  });
}

function currentFixtureIdentity(fixture, overrides = {}) {
  return buildLiveIdentity({
    metadata: fixture.live,
    taskContract: fixture.contract,
    runId: overrides.runId ?? fixture.env.GITHUB_RUN_ID,
    runAttempt: overrides.runAttempt ?? Number(fixture.env.GITHUB_RUN_ATTEMPT),
    eventType: fixture.env.GITHUB_EVENT_NAME,
    producedAt: producedAt,
  });
}

for (const productionCase of [
  {
    name: 'production entry blocks Base branch retarget with the same SHA',
    mutate(fixture, event) { event.pull_request.base.ref = 'release'; },
    field: 'base_branch',
  },
  {
    name: 'production entry blocks Head branch rename with the same SHA',
    mutate(fixture, event) { event.pull_request.head.ref = 'renamed-feature'; },
    field: 'head_branch',
  },
  {
    name: 'production entry blocks a stale same-Head PR Body digest',
    mutate(fixture, event) { event.pull_request.body = contractBody(fixture.contract, 'stale event body'); },
    field: 'governance_body_digest',
  },
  {
    name: 'production entry blocks a stale Task Contract digest',
    mutate(fixture, event) {
      event.pull_request.body = contractBody({ ...fixture.contract, task_title: 'old title' });
    },
    field: 'task_contract_digest',
  },
]) {
  test(productionCase.name, async () => {
    const fixture = productionFixture();
    try {
      const event = structuredClone(fixture.event);
      productionCase.mutate(fixture, event);
      const { report, exitCode } = await runProduction(fixture, { event });
      assert.equal(exitCode, 1);
      assert.equal(report.deterministic_result, 'BLOCKED');
      assert.equal(report.error_code, 'EVIDENCE_STALE_REAUDIT_REQUIRED');
      assert.ok(report.error_details.stale_fields.includes(productionCase.field));
      assert.equal(report.evidence_manifest.evidence[0].result, 'BLOCKED');
      assert.equal(report.findings[0].result, 'BLOCKED');
      assert.doesNotThrow(() => JSON.parse(readFileSync(join(fixture.output, 'audit-report.json'))));
    } finally {
      fixture.cleanup();
    }
  });
}

test('production entry blocks old run-attempt Evidence', async () => {
  const fixture = productionFixture();
  try {
    const previous = currentFixtureIdentity(fixture, { runAttempt: 1 });
    const { report, exitCode } = await runProduction(fixture, { previousIdentity: previous });
    assert.equal(exitCode, 1);
    assert.equal(report.error_code, 'EVIDENCE_STALE_REAUDIT_REQUIRED');
    assert.ok(report.error_details.stale_fields.includes('run_attempt'));
  } finally {
    fixture.cleanup();
  }
});

test('production entry blocks old Artifact reuse', async () => {
  const fixture = productionFixture();
  try {
    const previous = currentFixtureIdentity(fixture, { runId: '99' });
    const { report, exitCode } = await runProduction(fixture, { previousIdentity: previous });
    assert.equal(exitCode, 1);
    assert.equal(report.error_code, 'EVIDENCE_STALE_REAUDIT_REQUIRED');
    assert.ok(report.error_details.stale_fields.includes('workflow_run_id'));
  } finally {
    fixture.cleanup();
  }
});

test('production entry blocks old Evidence after a no-op Commit', async () => {
  const fixture = productionFixture();
  try {
    const previous = {
      ...currentFixtureIdentity(fixture),
      candidate_sha: fixture.priorHead,
    };
    const { report, exitCode } = await runProduction(fixture, { previousIdentity: previous });
    assert.equal(exitCode, 1);
    assert.equal(report.error_code, 'EVIDENCE_STALE_REAUDIT_REQUIRED');
    assert.ok(report.error_details.stale_fields.includes('candidate_sha'));
    assert.equal(fixture.headTree, git(fixture.candidate, 'rev-parse', `${fixture.priorHead}^{tree}`));
  } finally {
    fixture.cleanup();
  }
});

test('production entry emits fully schema-valid PASS only after all identity gates', async () => {
  const fixture = productionFixture();
  try {
    const previous = currentFixtureIdentity(fixture);
    const { report, exitCode } = await runProduction(fixture, { previousIdentity: previous });
    assert.equal(exitCode, 0);
    assert.equal(report.deterministic_result, 'PASS');
    assert.deepEqual(
      report.evidence_manifest.evidence.map((item) => item.evidence_type),
      ['repository', 'commit', 'diff', 'test'],
    );
    assert.ok(report.evidence_manifest.evidence.every((item) => item.result === 'PASS'));
    assert.equal(report.identity.freshness_status, 'PASS');
    assert.deepEqual(report.identity.candidate_gate_claims, []);
    const written = JSON.parse(readFileSync(join(fixture.output, 'audit-report.json')));
    assert.deepEqual(written, report);
  } finally {
    fixture.cleanup();
  }
});
