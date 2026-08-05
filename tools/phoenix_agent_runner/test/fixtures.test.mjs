import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

import { auditTask } from '../src/audit.mjs';
import { validateRepositoryConfig } from '../src/validation.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(here, '../../..');
const read = (relative) => JSON.parse(
  fs.readFileSync(path.join(repoRoot, relative), 'utf8'),
);

const registry = read('ai/development/policies/rule_registry.json');
const capabilityPolicy = read('ai/development/policies/capability_policy.json');
const scopePolicy = read('ai/development/policies/scope_policy.json');
const agents = fs.readdirSync(path.join(repoRoot, 'ai/development/agents'))
  .filter((name) => name.endsWith('.agent.json'))
  .map((name) => read(`ai/development/agents/${name}`));

test('JSON, Agent Manifest, Rule Registry, Schema, and example fixtures validate', () => {
  const { errors, manifests, registry: loadedRegistry, schemas } =
    validateRepositoryConfig(repoRoot);
  assert.deepEqual(errors, []);
  assert.equal(manifests.length, 6);
  assert.ok(loadedRegistry.rules.length >= 15);
  assert.equal(Object.keys(schemas).length, 4);
});

test('valid_read_only_task fixture passes', () => {
  const task = read('ai/development/examples/valid_read_only_task.json');
  const evidenceManifest = read('ai/development/examples/example_evidence_manifest.json');
  const { report, exitCode } = auditTask({
    task,
    registry,
    evidenceManifest,
    changedPaths: [],
    repoRoot: null,
    agentManifests: agents,
    capabilityPolicy,
    scopePolicy,
  });
  assert.equal(exitCode, 0);
  assert.equal(report.deterministic_result, 'PASS');
});

test('invalid_scope_task fixture fails when supplied a forbidden runtime path', () => {
  const task = read('ai/development/examples/invalid_scope_task.json');
  const evidenceManifest = read('ai/development/examples/example_evidence_manifest.json');
  const { report, exitCode } = auditTask({
    task,
    registry,
    evidenceManifest,
    changedPaths: ['app/lib/main.dart'],
    repoRoot: null,
    agentManifests: agents,
    capabilityPolicy,
    scopePolicy,
  });
  assert.equal(exitCode, 2);
  assert.equal(report.final_agent_decision, 'SCOPE_EXPANSION_REQUIRED');
});

test('GitHub workflow preserves read-only permissions and required triggers', () => {
  const workflow = fs.readFileSync(
    path.join(repoRoot, '.github/workflows/phoenix-agent-audit.yml'),
    'utf8',
  );
  for (const trigger of ['opened','synchronize','reopened','ready_for_review','workflow_dispatch']) {
    assert.ok(workflow.includes(trigger), `missing trigger ${trigger}`);
  }
  assert.match(workflow, /contents:\s*read/u);
  assert.match(workflow, /pull-requests:\s*read/u);
  for (const forbidden of [
    'contents: write',
    'pull-requests: write',
    'issues: write',
    'deployments: write',
    'actions: write',
    'secrets.',
    'wrangler delete',
    'enable_auto_merge',
  ]) {
    assert.ok(!workflow.includes(forbidden), `forbidden workflow content: ${forbidden}`);
  }
  assert.ok(workflow.includes('actions/upload-artifact@v4'));
  assert.ok(workflow.includes('GITHUB_STEP_SUMMARY'));
  assert.ok(workflow.includes('github.event.pull_request.head.sha || github.sha'));
});
