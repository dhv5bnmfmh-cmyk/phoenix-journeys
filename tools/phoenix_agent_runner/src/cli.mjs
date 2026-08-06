#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import {
  extractTaskContractFromEvent,
  obtainChangedPaths,
  parseArgs,
  readJson,
  writeJson,
} from './utils.mjs';
import { auditTask, reportToMarkdown } from './audit.mjs';
import {
  validateAgainstSchema,
  validateRepositoryConfig,
} from './validation.mjs';

function resolve(root, candidate) {
  return path.isAbsolute(candidate) ? candidate : path.join(root, candidate);
}

function loadTask({ args, root, event }) {
  if (args.task) return readJson(resolve(root, args.task));
  const extracted = extractTaskContractFromEvent(event);
  if (extracted.taskContractPath) {
    return readJson(resolve(root, extracted.taskContractPath));
  }
  return extracted;
}

function loadAgents(root) {
  const dir = path.join(root, 'ai/development/agents');
  return fs.readdirSync(dir)
    .filter((name) => name.endsWith('.agent.json'))
    .map((name) => readJson(path.join(dir, name)));
}

function validateConfigCommand(args) {
  const root = path.resolve(args.root ?? process.cwd());
  const result = validateRepositoryConfig(root);
  if (result.errors.length > 0) {
    for (const error of result.errors) console.error(error);
    process.exitCode = 2;
    return;
  }
  console.log(`JSON parse validation: PASS`);
  console.log(`Agent Manifest validation: PASS (${result.manifests.length})`);
  console.log(`Rule Registry validation: PASS (${result.registry.rules.length})`);
  console.log(`Schema file validation: PASS (${Object.keys(result.schemas).length})`);
}

function auditCommand(args) {
  const root = path.resolve(args.root ?? args['repo-root'] ?? process.cwd());
  const event = args.event ? readJson(resolve(root, args.event)) : null;
  const task = loadTask({ args, root, event });
  const taskSchema = readJson(path.join(root, 'ai/development/schemas/task_contract.schema.json'));
  const taskErrors = validateAgainstSchema(task, taskSchema, 'task_contract');
  if (taskErrors.length > 0) {
    for (const error of taskErrors) console.error(error);
    process.exitCode = 2;
    return;
  }

  const registry = readJson(path.join(root, 'ai/development/policies/rule_registry.json'));
  const capabilityPolicy = readJson(path.join(root, 'ai/development/policies/capability_policy.json'));
  const scopePolicy = readJson(path.join(root, 'ai/development/policies/scope_policy.json'));
  const evidencePath = args.evidence ?? task.evidence_manifest_path;
  const evidenceManifest = evidencePath && fs.existsSync(resolve(root, evidencePath))
    ? readJson(resolve(root, evidencePath))
    : null;

  const changed = obtainChangedPaths({
    repoRoot: args['repo-root'] ? root : null,
    baseSha: task.base_sha,
    headSha: task.current_head_sha,
    changedPathsFile: args['changed-paths-file']
      ? resolve(root, args['changed-paths-file'])
      : null,
  });

  const { report, exitCode } = auditTask({
    task,
    registry,
    evidenceManifest,
    event,
    changedPaths: changed.paths,
    repoRoot: args['repo-root'] ? root : null,
    agentManifests: loadAgents(root),
    capabilityPolicy,
    scopePolicy,
  });
  if (changed.limitation) report.limitations.unshift(changed.limitation);

  const outputDir = resolve(root, args['output-dir'] ?? 'phoenix-agent-audit');
  fs.mkdirSync(outputDir, { recursive: true });
  const jsonPath = path.join(outputDir, 'audit-report.json');
  const markdownPath = path.join(outputDir, 'audit-summary.md');
  writeJson(jsonPath, report);
  fs.writeFileSync(markdownPath, `${reportToMarkdown(report)}\n`, 'utf8');

  console.log(`Deterministic Result: ${report.deterministic_result}`);
  console.log(`AI Review Result: ${report.ai_review_result}`);
  console.log(`Founder Gate Result: ${report.founder_gate_result}`);
  console.log(`Final Agent Decision: ${report.final_agent_decision}`);
  console.log(`JSON report: ${jsonPath}`);
  console.log(`Markdown summary: ${markdownPath}`);
  process.exitCode = exitCode;
}

const args = parseArgs(process.argv.slice(2));
try {
  if (args.command === 'validate-config') {
    validateConfigCommand(args);
  } else if (args.command === 'audit') {
    auditCommand(args);
  } else {
    throw new Error(`Unknown command: ${args.command}`);
  }
} catch (error) {
  console.error(error instanceof Error ? error.stack : String(error));
  process.exitCode = 2;
}
