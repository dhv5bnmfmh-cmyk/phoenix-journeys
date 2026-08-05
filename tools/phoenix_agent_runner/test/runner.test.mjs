import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

import { auditTask } from '../src/audit.mjs';
import { validateAgainstSchema } from '../src/validation.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(here, '../../..');

const read = (relative) => JSON.parse(
  fs.readFileSync(path.join(repoRoot, relative), 'utf8'),
);
const baseTask = read('ai/development/examples/valid_read_only_task.json');
const registry = read('ai/development/policies/rule_registry.json');
const capabilityPolicy = read('ai/development/policies/capability_policy.json');
const scopePolicy = read('ai/development/policies/scope_policy.json');
const taskSchema = read('ai/development/schemas/task_contract.schema.json');
const agentManifests = fs.readdirSync(path.join(repoRoot, 'ai/development/agents'))
  .filter((name) => name.endsWith('.agent.json'))
  .map((name) => read(`ai/development/agents/${name}`));
const evidence = read('ai/development/examples/example_evidence_manifest.json');

function clone(value) {
  return JSON.parse(JSON.stringify(value));
}

function run(task, overrides = {}) {
  return auditTask({
    task,
    registry,
    evidenceManifest: overrides.evidenceManifest ?? evidence,
    event: overrides.event ?? null,
    changedPaths: overrides.changedPaths ?? [],
    repoRoot: null,
    agentManifests,
    capabilityPolicy,
    scopePolicy,
  });
}

function resultFor(report, ruleId) {
  return report.rule_results.find((entry) => entry.rule_id === ruleId);
}

test('1. valid read-only Task Contract passes deterministic gates', () => {
  const { report, exitCode } = run(clone(baseTask));
  assert.equal(exitCode, 0);
  assert.equal(report.deterministic_result, 'PASS');
  assert.equal(report.ai_review_result, 'NOT_RUN');
});

test('2. missing repository is BLOCKED by schema validation', () => {
  const task = clone(baseTask);
  delete task.repository;
  const errors = validateAgainstSchema(task, taskSchema, 'task');
  assert.ok(errors.some((entry) => entry.includes('repository')));
});

test('3. Base SHA mismatch is BLOCKED', () => {
  const task = clone(baseTask);
  task.base_sha = 'a'.repeat(40);
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R002').result, 'BLOCKED');
});

test('4. missing Candidate SHA is BLOCKED by schema validation', () => {
  const task = clone(baseTask);
  delete task.current_head_sha;
  const errors = validateAgainstSchema(task, taskSchema, 'task');
  assert.ok(errors.some((entry) => entry.includes('current_head_sha')));
});

test('5. unauthorized path produces FAILURE and scope expansion stop', () => {
  const { report, exitCode } = run(clone(baseTask), {
    changedPaths: ['app/lib/main.dart'],
  });
  assert.equal(exitCode, 2);
  assert.deepEqual(report.summary.unexpected_paths, ['app/lib/main.dart']);
  assert.equal(report.final_agent_decision, 'SCOPE_EXPANSION_REQUIRED');
});

test('6. evidence from an old Head produces FAILURE', () => {
  const stale = clone(evidence);
  stale.candidate_sha = 'b'.repeat(40);
  stale.evidence[0].candidate_sha = 'b'.repeat(40);
  const { report, exitCode } = run(clone(baseTask), { evidenceManifest: stale });
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R004').result, 'BLOCKED');
});

test('7. unknown Rule ID produces FAILURE', () => {
  const task = clone(baseTask);
  task.applicable_rules.push('PDA-R999');
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.ok(report.findings.some((entry) => entry.title.includes('unknown Rule')));
});

test('8. Builder and Auditor cannot be the same Agent', () => {
  const task = clone(baseTask);
  task.builder_agent = task.auditor_agent;
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R014').result, 'BLOCKED');
});

test('9. missing Ready Authorization does not allow Ready', () => {
  const task = clone(baseTask);
  task.requested_actions.push('READY');
  const { report } = run(task);
  assert.equal(resultFor(report, 'PDA-R012').result, 'REQUIRED');
});

test('10. missing Merge Authorization does not allow Merge', () => {
  const task = clone(baseTask);
  task.requested_actions.push('MERGE');
  const { report } = run(task);
  assert.equal(resultFor(report, 'PDA-R013').result, 'REQUIRED');
});

test('11. AI Review that did not run is always NOT_RUN', () => {
  const { report } = run(clone(baseTask));
  assert.equal(report.ai_review_result, 'NOT_RUN');
  assert.equal(resultFor(report, 'PDA-R022').result, 'PASS');
});

test('12. disabled Builder write request fails', () => {
  const task = clone(baseTask);
  task.requested_agents.push('PhoenixBuilderAgent');
  task.requested_actions.push('WRITE_FILES');
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R023').result, 'BLOCKED');
});

test('13. disabled Remediator write request fails', () => {
  const task = clone(baseTask);
  task.requested_agents.push('PhoenixRemediationAgent');
  task.requested_actions.push('WRITE_FILES');
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R024').result, 'BLOCKED');
});

test('14. scope expansion stops without automatic continuation', () => {
  const { report } = run(clone(baseTask), {
    changedPaths: ['worker/index.js'],
  });
  assert.equal(report.final_agent_decision, 'SCOPE_EXPANSION_REQUIRED');
  assert.equal(resultFor(report, 'PDA-R015').result, 'REQUIRED');
});

test('15. undeclared external disclosure is BLOCKED', () => {
  const task = clone(baseTask);
  delete task.external_disclosure;
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R017').result, 'BLOCKED');
});

test('16. secret material in input produces FAILURE', () => {
  const task = clone(baseTask);
  task.notes.push('OPENAI_API_KEY=not-a-real-but-forbidden-test-secret');
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(resultFor(report, 'PDA-R016').result, 'BLOCKED');
});

test('17. HARD_GATE failure returns non-zero exit code', () => {
  const task = clone(baseTask);
  task.repository = 'wrong/repository';
  const { exitCode } = run(task, {
    event: { repository: { full_name: baseTask.repository } },
  });
  assert.equal(exitCode, 2);
});

test('18. deterministic-only PASS cannot claim full product PASS', () => {
  const { report } = run(clone(baseTask));
  assert.equal(
    report.final_agent_decision,
    'DETERMINISTIC_GATES_PASS_FOUNDER_GOVERNANCE_REVIEW_REQUIRED',
  );
  assert.notEqual(report.final_agent_decision, 'PASS');
});

test('disabled task modes return MODE_DISABLED_PENDING_FOUNDER_AUTHORIZATION', () => {
  const task = clone(baseTask);
  task.task_mode = 'RUNTIME_DEVELOPMENT';
  const { report, exitCode } = run(task);
  assert.equal(exitCode, 2);
  assert.equal(
    report.final_agent_decision,
    'MODE_DISABLED_PENDING_FOUNDER_AUTHORIZATION',
  );
});
