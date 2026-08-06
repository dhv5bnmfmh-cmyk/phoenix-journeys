#!/usr/bin/env node
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolve, join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { execFileSync } from 'node:child_process';
import {
  fetchLivePullRequest,
  extractTaskContract,
  buildLiveIdentity,
  metadataFromPullRequestEvent,
  assertCanonicalFreshness,
  assertTaskContractIdentity,
  sha256Text,
  canonicalJson,
} from './identity-freshness.mjs';
import {
  createTrustedEvidenceManifest,
  createBlockedEvidenceManifest,
  produceTrustedEvidenceEntries,
  validateEvidenceManifest,
  normalizeRequiredEvidenceTypes,
} from './evidence-authority.mjs';
import {
  assertPhaseAActions,
  assertPrincipalSeparation,
  candidateGateClaims,
} from './authority-enforcement.mjs';
import {
  assertMandatoryRuleInventory,
  assertTrustedSchemaInventory,
} from './rule-authority.mjs';
import { validateObject } from './schema-validator.mjs';
import {
  scanCandidateRepository,
  assertSafeText,
} from './secret-scanner.mjs';

const ZERO_SHA = '0'.repeat(40);
const ZERO_DIGEST = '0'.repeat(64);
const STABLE_SHA = '5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977';

function arg(argv, name, fallback = '') {
  const index = argv.indexOf(`--${name}`);
  return index >= 0 ? argv[index + 1] : fallback;
}

function load(path) {
  return JSON.parse(readFileSync(path, 'utf8'));
}

function git(repo, args) {
  return execFileSync('git', ['-C', repo, ...args], {
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
    maxBuffer: 64 * 1024 * 1024,
  }).trim();
}

function parseOptionalJson(value) {
  if (!value) return null;
  try {
    return JSON.parse(value);
  } catch {
    const error = new Error('TRUSTED_PROOF_JSON_MALFORMED');
    error.code = 'TRUSTED_PROOF_JSON_MALFORMED';
    throw error;
  }
}

function terminalTestProof({ trusted, candidateSha, runTests = execFileSync }) {
  let output = '';
  try {
    output = runTests('npm', ['run', 'test:r1b', '--silent'], {
      cwd: join(trusted, 'tools/phoenix_agent_runner'),
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'pipe'],
      maxBuffer: 64 * 1024 * 1024,
    });
  } catch (error) {
    const failure = new Error('TRUSTED_TEST_EVIDENCE_FAILED');
    failure.code = 'TRUSTED_TEST_EVIDENCE_FAILED';
    throw failure;
  }
  const count = (label) => {
    const matches = [...String(output).matchAll(new RegExp(`^# ${label} (\\d+)$`, 'gmu'))];
    return matches.length ? Number(matches.at(-1)[1]) : NaN;
  };
  const total = count('tests');
  const passed = count('pass');
  const failed = count('fail');
  const skipped = count('skipped');
  if (![total, passed, failed, skipped].every(Number.isInteger)) {
    const error = new Error('TRUSTED_TEST_EVIDENCE_MALFORMED');
    error.code = 'TRUSTED_TEST_EVIDENCE_MALFORMED';
    throw error;
  }
  return {
    status: 'completed',
    result: failed === 0 ? 'PASS' : 'FAILURE',
    candidate_sha: candidateSha,
    total,
    passed,
    failed,
    skipped,
    source: 'trusted-node-test-runner',
    command_or_path: 'npm run test:r1b --silent',
    limitations: [],
  };
}

function safeError(error) {
  const rawCode = String(error?.code ?? error?.message ?? 'TRUSTED_AUDIT_FAILURE')
    .split(/\s/u)[0]
    .toUpperCase()
    .replace(/[^A-Z0-9_:.-]/gu, '_')
    .slice(0, 160);
  return {
    code: rawCode || 'TRUSTED_AUDIT_FAILURE',
    stale_fields: Array.isArray(error?.stale_fields)
      ? error.stale_fields.filter((field) => typeof field === 'string')
      : [],
  };
}

function fallbackIdentity({
  repository,
  prNumber,
  runId,
  runAttempt,
  eventType,
  producedAt,
  live,
  taskContract,
  ruleDigest,
  schemaDigest,
}) {
  const safeAttempt = Number.isInteger(Number(runAttempt)) && Number(runAttempt) >= 1
    ? Number(runAttempt)
    : 1;
  return {
    repository: repository || 'unknown/unknown',
    pr_number: Number.isInteger(Number(prNumber)) && Number(prNumber) >= 1
      ? Number(prNumber)
      : 1,
    base_branch: live?.base_branch || taskContract?.base_branch || 'unknown',
    base_sha: live?.base_sha || taskContract?.base_sha || ZERO_SHA,
    head_branch: live?.head_branch || taskContract?.head_branch || 'unknown',
    candidate_sha: live?.head_sha || taskContract?.current_head_sha || ZERO_SHA,
    candidate_tree: live?.head_tree || ZERO_SHA,
    task_contract_digest: taskContract
      ? sha256Text(canonicalJson(taskContract))
      : ZERO_DIGEST,
    governance_body_digest: live?.body !== undefined
      ? sha256Text(String(live.body).replace(/\r\n/g, '\n').replace(/[ \t]+$/gm, '').trim())
      : ZERO_DIGEST,
    workflow_run_id: String(runId || 'unknown-run'),
    run_attempt: safeAttempt,
    event_type: String(eventType || 'unknown'),
    produced_at: producedAt,
    state: ['open', 'closed'].includes(String(live?.state).toLowerCase())
      ? String(live.state).toLowerCase()
      : 'unknown',
    draft: Boolean(live?.draft),
    freshness_status: 'BLOCKED',
    rule_inventory_digest: ruleDigest || ZERO_DIGEST,
    schema_inventory_digest: schemaDigest || ZERO_DIGEST,
    secret_scan: 'NOT_RUN',
    candidate_gate_claims: taskContract ? candidateGateClaims(taskContract) : [],
  };
}

function errorFinding(identity, code) {
  return {
    finding_id: `PDA-F-TRUSTED-${sha256Text(`${code}:${identity.candidate_sha}`).slice(0, 16)}`,
    rule_id: 'PDA-R004',
    title: 'Trusted audit failed closed',
    area: 'evidence_binding',
    severity: 'P1',
    result: 'BLOCKED',
    evidence_level: 'VERIFIED',
    expected: 'Fresh, schema-valid trusted evidence bound to the live pull request identity.',
    actual: `Trusted audit stopped with ${code}.`,
    exact_paths: [],
    candidate_sha: identity.candidate_sha,
    stable_sha: STABLE_SHA,
    evidence: ['trusted audit error boundary'],
    root_cause: code,
    required_action: 'Generate fresh trusted evidence and perform an independent source re-audit.',
    proposed_scope: [],
    auto_fix_permitted: false,
    founder_authorization_required: false,
    status: 'BLOCKED',
  };
}

function reportId({ identity, trustedRunnerSha, result, code = '' }) {
  return sha256Text(canonicalJson({
    repository: identity.repository,
    pr: identity.pr_number,
    base: identity.base_sha,
    head: identity.candidate_sha,
    tree: identity.candidate_tree,
    task: identity.task_contract_digest,
    body: identity.governance_body_digest,
    run: identity.workflow_run_id,
    attempt: identity.run_attempt,
    runner: trustedRunnerSha,
    result,
    code,
  }));
}

function validateCompleteOutput({ schemas, manifest, findings, report }) {
  validateObject(
    schemas['ai/development/schemas/evidence_manifest.schema.json'],
    manifest,
    'evidence_manifest',
  );
  for (const finding of findings) {
    validateObject(
      schemas['ai/development/schemas/finding.schema.json'],
      finding,
      'finding',
    );
  }
  validateObject(
    schemas['ai/development/schemas/audit_report.schema.json'],
    report,
    'audit_report',
  );
}

function writeOutput({ output, report }) {
  const text = `${JSON.stringify(report, null, 2)}\n`;
  assertSafeText(text, 'generated_report');
  writeFileSync(join(output, 'audit-report.json'), text, 'utf8');
  const summary = [
    '# Phoenix Trusted Audit',
    '',
    `- Deterministic Result: ${report.deterministic_result}`,
    '- AI Review Result: NOT_RUN',
    '- Founder Governance: NOT_APPROVED',
    `- Candidate SHA: ${report.candidate_sha}`,
    `- Workflow Run: ${report.workflow_run_id}`,
    `- Run Attempt: ${report.run_attempt}`,
    `- Final Agent Decision: ${report.final_agent_decision}`,
    '',
  ].join('\n');
  assertSafeText(summary, 'step_summary');
  writeFileSync(join(output, 'audit-summary.md'), summary, 'utf8');
}

export async function runTrustedAudit({
  argv = process.argv.slice(2),
  env = process.env,
  fetchLive = fetchLivePullRequest,
  runTests = execFileSync,
} = {}) {
  const trusted = resolve(arg(argv, 'trusted', 'trusted'));
  const candidate = resolve(arg(argv, 'candidate', 'candidate'));
  const output = resolve(arg(argv, 'output', 'phoenix-agent-audit'));
  mkdirSync(output, { recursive: true });
  const producedAt = new Date().toISOString();
  const repository = env.GITHUB_REPOSITORY || '';
  const prNumber = Number(arg(argv, 'pr-number'));
  const runId = env.GITHUB_RUN_ID || '';
  const runAttempt = Number(env.GITHUB_RUN_ATTEMPT);
  const eventType = env.GITHUB_EVENT_NAME || '';
  let schemas = {};
  let schemaInventory = null;
  let schemaDigest = ZERO_DIGEST;
  let ruleDigest = ZERO_DIGEST;
  let live = null;
  let contract = null;
  let trustedRunnerSha = ZERO_SHA;

  try {
    schemaInventory = load(join(
      trusted,
      'ai/development/policies/trusted_schema_inventory.json',
    ));
    for (const item of schemaInventory.schemas) {
      schemas[item.path] = load(join(trusted, item.path));
    }
    schemaDigest = assertTrustedSchemaInventory(schemas, schemaInventory);
    const evidencePolicy = load(join(
      trusted,
      'ai/development/policies/evidence_policy.json',
    ));

    live = await fetchLive({
      repository,
      prNumber,
      token: env.GITHUB_TOKEN,
      apiUrl: env.GITHUB_API_URL,
    });
    contract = extractTaskContract(live.body);
    validateObject(
      schemas['ai/development/schemas/task_contract.schema.json'],
      contract,
      'task_contract',
    );

    const candidateSha = git(candidate, ['rev-parse', 'HEAD']);
    const candidateTree = git(candidate, ['rev-parse', 'HEAD^{tree}']);
    const currentIdentity = buildLiveIdentity({
      metadata: live,
      taskContract: contract,
      runId,
      runAttempt,
      eventType,
      producedAt,
    });

    const eventPath = arg(argv, 'event');
    const event = eventPath ? load(resolve(eventPath)) : null;
    const eventMetadata = metadataFromPullRequestEvent(event, candidateTree);
    if (eventMetadata) {
      const eventContract = extractTaskContract(eventMetadata.body);
      const eventIdentity = buildLiveIdentity({
        metadata: eventMetadata,
        taskContract: eventContract,
        runId,
        runAttempt,
        eventType,
        producedAt,
      });
      assertCanonicalFreshness(eventIdentity, currentIdentity);
    }

    if (candidateSha !== currentIdentity.candidate_sha
        || candidateTree !== currentIdentity.candidate_tree) {
      const error = new Error('EVIDENCE_STALE_REAUDIT_REQUIRED');
      error.code = 'EVIDENCE_STALE_REAUDIT_REQUIRED';
      error.stale_fields = [
        ...(candidateSha !== currentIdentity.candidate_sha ? ['candidate_sha'] : []),
        ...(candidateTree !== currentIdentity.candidate_tree ? ['candidate_tree'] : []),
      ];
      throw error;
    }

    // Canonical Task Contract and live branch assertion. This must remain
    // before every type-specific PASS producer.
    assertTaskContractIdentity(contract, currentIdentity, prNumber);

    const previousIdentityPath = arg(argv, 'previous-identity');
    if (previousIdentityPath) {
      assertCanonicalFreshness(load(resolve(previousIdentityPath)), currentIdentity);
    }

    assertPhaseAActions(contract.requested_actions);

    const principal = {
      execution_principal_id: `github-actions:${runId}`,
      actor: env.GITHUB_ACTOR,
      triggering_actor: env.GITHUB_TRIGGERING_ACTOR,
      workflow_identity: '.github/workflows/phoenix-agent-audit.yml',
      role: 'FINAL_AUDITOR',
      run_id: String(runId),
      run_attempt: Number(runAttempt),
      candidate_sha: live.head_sha,
      authorized_actions: contract.requested_actions,
    };
    assertPrincipalSeparation([principal]);
    validateObject(
      schemas['ai/development/schemas/execution_principal.schema.json'],
      principal,
      'execution_principal',
    );

    const ruleRegistry = load(join(
      trusted,
      'ai/development/policies/rule_registry.json',
    ));
    const ruleInventory = load(join(
      trusted,
      'ai/development/policies/trusted_rule_inventory.json',
    ));
    ruleDigest = assertMandatoryRuleInventory(ruleRegistry, ruleInventory);

    const changedPathsCommand = [
      'diff', '--name-only', live.base_sha, live.head_sha,
    ];
    const changedPaths = git(candidate, changedPathsCommand)
      .split(/\r?\n/u)
      .filter(Boolean);
    const scan = scanCandidateRepository({
      repo: candidate,
      baseSha: live.base_sha,
      candidateSha: live.head_sha,
      governanceBody: live.body,
      taskContract: canonicalJson(contract),
    });

    const requiredTypes = normalizeRequiredEvidenceTypes(contract.required_evidence);
    const proofs = {
      repository: {
        status: 'completed',
        result: 'PASS',
        repository,
        source: 'live-github-pr',
        command_or_path: `GET /repos/${repository}/pulls/${prNumber}`,
        limitations: [],
      },
      commit: {
        status: 'completed',
        result: 'PASS',
        base_sha: live.base_sha,
        candidate_sha: live.head_sha,
        candidate_tree: live.head_tree,
        source: 'live-github-commit-and-candidate-git',
        command_or_path: `git rev-parse HEAD && git rev-parse HEAD^{tree}`,
        limitations: [],
      },
      diff: {
        status: 'completed',
        result: scan.result,
        base_sha: live.base_sha,
        candidate_sha: live.head_sha,
        source: 'trusted-git-diff',
        command_or_path: `git diff ${live.base_sha} ${live.head_sha}`,
        limitations: [],
      },
      changed_paths: {
        status: 'completed',
        result: 'PASS',
        candidate_sha: live.head_sha,
        paths: changedPaths,
        source: 'trusted-git-diff-name-only',
        command_or_path: `git diff --name-only ${live.base_sha} ${live.head_sha}`,
        limitations: [],
      },
      workflow: {
        status: 'completed',
        result: 'PASS',
        candidate_sha: live.head_sha,
        workflow_run_id: String(runId),
        run_attempt: Number(runAttempt),
        source: 'trusted-github-actions-run',
        command_or_path: '.github/workflows/phoenix-agent-audit.yml',
        limitations: [],
      },
    };
    if (requiredTypes.includes('test')) {
      proofs.test = terminalTestProof({
        trusted,
        candidateSha: live.head_sha,
        runTests,
      });
    }
    const ciProof = parseOptionalJson(env.PHOENIX_CI_EVIDENCE_JSON);
    if (ciProof) proofs.ci = ciProof;
    const founderProof = parseOptionalJson(env.PHOENIX_FOUNDER_EVIDENCE_JSON);
    if (founderProof) proofs.founder = founderProof;

    // No trusted PASS Evidence exists before the canonical freshness, Task
    // Contract, principal, rule, schema, diff, scan, and terminal-proof gates.
    const entries = produceTrustedEvidenceEntries({
      identity: currentIdentity,
      requiredTypes,
      proofs,
      producedAt,
    });
    const manifest = createTrustedEvidenceManifest({
      identity: currentIdentity,
      requiredTypes,
      entries,
      producedAt,
    });
    validateEvidenceManifest(manifest, {
      identity: currentIdentity,
      requiredTypes,
      policy: evidencePolicy,
      now: new Date(producedAt),
    });

    trustedRunnerSha = git(trusted, ['rev-parse', 'HEAD']);
    const reportIdentity = {
      ...currentIdentity,
      freshness_status: 'PASS',
      rule_inventory_digest: ruleDigest,
      schema_inventory_digest: schemaDigest,
      secret_scan: scan.result,
      candidate_gate_claims: candidateGateClaims(contract),
    };
    const findings = [];
    const report = {
      report_id: reportId({
        identity: reportIdentity,
        trustedRunnerSha,
        result: 'PASS',
      }),
      repository,
      pr_number: prNumber,
      base_sha: live.base_sha,
      candidate_sha: live.head_sha,
      candidate_tree: live.head_tree,
      trusted_runner_sha: trustedRunnerSha,
      workflow_run_id: currentIdentity.workflow_run_id,
      run_attempt: currentIdentity.run_attempt,
      deterministic_result: 'PASS',
      ai_review_result: 'NOT_RUN',
      founder_gate_result: 'NOT_APPROVED',
      final_agent_decision: 'DETERMINISTIC_SOURCE_GATES_PASS_BOOTSTRAP_PENDING_MERGE',
      identity: reportIdentity,
      evidence_manifest: manifest,
      findings,
      produced_at: producedAt,
    };
    validateCompleteOutput({ schemas, manifest, findings, report });
    writeOutput({ output, report });
    return { report, exitCode: 0 };
  } catch (error) {
    const safe = safeError(error);
    const identity = fallbackIdentity({
      repository,
      prNumber,
      runId,
      runAttempt,
      eventType,
      producedAt,
      live,
      taskContract: contract,
      ruleDigest,
      schemaDigest,
    });
    try {
      trustedRunnerSha = git(trusted, ['rev-parse', 'HEAD']);
    } catch {
      trustedRunnerSha = ZERO_SHA;
    }
    const manifest = createBlockedEvidenceManifest({
      identity,
      producedAt,
      code: safe.code,
    });
    const findings = [errorFinding(identity, safe.code)];
    const report = {
      report_id: reportId({
        identity,
        trustedRunnerSha,
        result: 'BLOCKED',
        code: safe.code,
      }),
      repository: identity.repository,
      pr_number: identity.pr_number,
      base_sha: identity.base_sha,
      candidate_sha: identity.candidate_sha,
      candidate_tree: identity.candidate_tree,
      trusted_runner_sha: trustedRunnerSha,
      workflow_run_id: identity.workflow_run_id,
      run_attempt: identity.run_attempt,
      deterministic_result: 'BLOCKED',
      ai_review_result: 'NOT_RUN',
      founder_gate_result: 'NOT_APPROVED',
      final_agent_decision: safe.code === 'EVIDENCE_STALE_REAUDIT_REQUIRED'
        ? 'EVIDENCE_STALE_REAUDIT_REQUIRED'
        : 'TRUSTED_EVIDENCE_BLOCKED_REAUDIT_REQUIRED',
      identity,
      evidence_manifest: manifest,
      findings,
      produced_at: producedAt,
      error_code: safe.code,
      error_details: safe.stale_fields.length
        ? { stale_fields: safe.stale_fields }
        : {},
    };
    if (Object.keys(report.error_details).length === 0) delete report.error_details;
    validateCompleteOutput({ schemas, manifest, findings, report });
    writeOutput({ output, report });
    return { report, exitCode: 1 };
  }
}

async function main() {
  const { exitCode } = await runTrustedAudit();
  process.exitCode = exitCode;
}

const invokedPath = process.argv[1] ? pathToFileURL(resolve(process.argv[1])).href : '';
if (import.meta.url === invokedPath) {
  await main();
}
