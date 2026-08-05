#!/usr/bin/env node
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolve } from 'node:path';
import { buildTrustedIdentity, classifyAuthorityChanges } from './trusted-audit.mjs';
import { scanCandidateRepository, sanitizeScanError, assertSafeText } from './secret-scanner.mjs';

function arg(name, fallback = '') {
  const index = process.argv.indexOf(`--${name}`);
  return index >= 0 ? process.argv[index + 1] : fallback;
}

const candidate = resolve(arg('candidate', 'candidate'));
const output = resolve(arg('output', 'phoenix-agent-audit'));
mkdirSync(output, { recursive: true });
const event = JSON.parse(readFileSync(arg('event'), 'utf8'));
const pr = event.pull_request || {};
const baseSha = arg('base-sha', pr.base?.sha);
const candidateSha = arg('candidate-sha', pr.head?.sha);
const identity = buildTrustedIdentity({
  trustedRunnerSha: arg('trusted-runner-sha'),
  trustedRunnerTree: arg('trusted-runner-tree'),
  trustedWorkflowPath: '.github/workflows/phoenix-agent-audit.yml',
  trustedRuleInventoryDigest: arg('rule-digest'),
  trustedSchemaDigest: arg('schema-digest'),
  candidateSha,
  candidateTree: arg('candidate-tree'),
  baseSha,
  prNumber: pr.number || event.number,
  runId: process.env.GITHUB_RUN_ID || 'local',
  runAttempt: process.env.GITHUB_RUN_ATTEMPT || 1,
  eventType: process.env.GITHUB_EVENT_NAME || 'local',
});

try {
  const scan = scanCandidateRepository({
    repo: candidate,
    baseSha,
    candidateSha,
    governanceBody: pr.body || '',
    taskContract: arg('task-contract-json'),
    evidenceManifest: arg('evidence-manifest-json'),
  });
  const changedPaths = scan.records.flatMap(record =>
    record.destination ? [record.source, record.destination] : [record.path],
  );
  const report = {
    deterministic_result: 'PASS',
    ai_review_result: 'NOT_RUN',
    founder_gate_result: 'REQUIRED',
    final_agent_decision: 'P0_TRUST_BOUNDARY_AND_SECRET_GATE_PASS_BOOTSTRAP_PENDING_MERGE',
    identity,
    authority_changes: classifyAuthorityChanges(changedPaths),
    secret_scan: { result: scan.result, scanned: scan.scanned, historical: scan.historical },
  };
  const text = JSON.stringify(report, null, 2);
  assertSafeText(text, 'generated_report');
  writeFileSync(resolve(output, 'audit-report.json'), text);
  const summary = '# Phoenix Trusted Audit\n\n- Deterministic Result: PASS\n- AI Review Result: NOT_RUN\n- Bootstrap: operational activation pending merge\n';
  assertSafeText(summary, 'step_summary');
  writeFileSync(resolve(output, 'audit-summary.md'), summary);
} catch (error) {
  const safe = sanitizeScanError(error);
  writeFileSync(resolve(output, 'audit-report.json'), JSON.stringify({
    deterministic_result: 'BLOCKED',
    ai_review_result: 'NOT_RUN',
    identity,
    error: safe,
  }, null, 2));
  process.exitCode = 1;
}
