import path from 'node:path';
import { gitOutput, matchesAny, normalizePaths, nowIso, scanSecrets } from './utils.mjs';

const WRITE_ACTIONS = new Set([
  'WRITE_FILES','MODIFY_CODE','COMMIT','PUSH','CREATE_PR','UPDATE_PR','READY',
  'MERGE','AUTO_MERGE','RELEASE','DEPLOY','DELETE_PREVIEW','DELETE_BRANCH',
  'START_NEXT_PHASE','CLOSE_FINDING',
]);

function findingFromRule({ rule, task, title, actual, paths = [], result = 'BLOCKED', evidenceLevel = 'VERIFIED' }) {
  return {
    finding_id: `PDA-F-${rule.rule_id}-${Math.random().toString(16).slice(2, 10)}`,
    rule_id: rule.rule_id,
    title,
    area: rule.founder_gate || 'governance',
    severity: rule.severity,
    result,
    evidence_level: evidenceLevel,
    expected: rule.requirement,
    actual,
    exact_paths: paths,
    candidate_sha: task.current_head_sha,
    stable_sha: '5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977',
    evidence: rule.required_evidence,
    root_cause: rule.failure_result,
    required_action: `Stop and resolve ${rule.failure_result} under the applicable Founder gate.`,
    proposed_scope: paths,
    auto_fix_permitted: false,
    founder_authorization_required: rule.founder_authorization_required,
    status: rule.founder_authorization_required ? 'AUTHORIZATION_REQUIRED' : 'OPEN',
  };
}

function emptyRuleResults(registry) {
  return new Map(registry.rules.map((rule) => [
    rule.rule_id,
    {
      rule_id: rule.rule_id,
      enforcement_type: rule.enforcement_type,
      result: rule.enforcement_type === 'AI_REVIEW'
        ? 'NOT_RUN'
        : rule.enforcement_type === 'FOUNDER_GATE'
          ? 'NOT_APPLICABLE'
          : 'PASS',
      message: rule.enforcement_type === 'AI_REVIEW'
        ? 'AI review was not executed in Phase A.'
        : 'No violation detected by the Phase A deterministic runner.',
    },
  ]));
}

export function auditTask({
  task,
  registry,
  evidenceManifest = null,
  event = null,
  changedPaths = [],
  repoRoot = null,
  agentManifests = [],
  capabilityPolicy,
  scopePolicy,
}) {
  const rulesById = new Map(registry.rules.map((rule) => [rule.rule_id, rule]));
  const ruleResults = emptyRuleResults(registry);
  const findings = [];
  const limitations = [];
  const markFailure = (ruleId, title, actual, paths = [], result = 'BLOCKED') => {
    const rule = rulesById.get(ruleId);
    if (!rule) throw new Error(`Internal rule lookup failed for ${ruleId}`);
    ruleResults.set(ruleId, {
      rule_id: ruleId,
      enforcement_type: rule.enforcement_type,
      result,
      message: actual,
    });
    findings.push(findingFromRule({ rule, task, title, actual, paths, result }));
  };

  const allowedModes = new Set(capabilityPolicy.allowed_task_modes);
  if (!allowedModes.has(task.task_mode)) {
    markFailure(
      'PDA-R025',
      'Task mode is disabled in Phase A',
      `Requested task mode ${task.task_mode} is disabled pending Founder authorization.`,
    );
  }

  const eventRepository = event?.repository?.full_name ?? process.env.GITHUB_REPOSITORY ?? task.repository;
  if (eventRepository !== task.repository) {
    markFailure(
      'PDA-R001',
      'Repository identity mismatch',
      `Task Contract repository ${task.repository}; event repository ${eventRepository}.`,
    );
  }

  const eventBaseSha = event?.pull_request?.base?.sha;
  const eventBaseRef = event?.pull_request?.base?.ref;
  const eventHeadSha = event?.pull_request?.head?.sha;
  const eventHeadRef = event?.pull_request?.head?.ref;

  if (task.expected_main !== task.base_sha) {
    markFailure(
      'PDA-R002',
      'Expected main and Base SHA differ',
      `expected_main=${task.expected_main}; base_sha=${task.base_sha}.`,
    );
  }
  if (eventBaseSha && eventBaseSha !== task.base_sha) {
    markFailure(
      'PDA-R002',
      'Event Base SHA differs from Task Contract',
      `event=${eventBaseSha}; task=${task.base_sha}.`,
    );
  }
  if (eventBaseRef && eventBaseRef !== task.base_branch) {
    markFailure(
      'PDA-R002',
      'Event Base branch differs from Task Contract',
      `event=${eventBaseRef}; task=${task.base_branch}.`,
    );
  }
  if (eventHeadSha && eventHeadSha !== task.current_head_sha) {
    markFailure(
      'PDA-R003',
      'Event Candidate Head differs from Task Contract',
      `event=${eventHeadSha}; task=${task.current_head_sha}.`,
    );
  }
  if (eventHeadRef && eventHeadRef !== task.head_branch) {
    markFailure(
      'PDA-R003',
      'Event Head branch differs from Task Contract',
      `event=${eventHeadRef}; task=${task.head_branch}.`,
    );
  }

  if (repoRoot) {
    const head = gitOutput(repoRoot, ['rev-parse', 'HEAD']);
    if (head.ok && head.stdout !== task.current_head_sha) {
      markFailure(
        'PDA-R003',
        'Checked-out Head differs from Task Contract',
        `checkout=${head.stdout}; task=${task.current_head_sha}.`,
      );
    } else if (!head.ok) {
      limitations.push(`Git Head could not be verified: ${head.stderr || 'unknown error'}`);
    }
  }

  const changed = normalizePaths(changedPaths);
  const unexpectedPaths = changed.filter(
    (file) => !matchesAny(file, task.allowed_paths)
      || matchesAny(file, task.forbidden_paths)
      || !matchesAny(file, scopePolicy.allowed_paths)
      || matchesAny(file, scopePolicy.forbidden_paths),
  );
  if (unexpectedPaths.length > 0) {
    markFailure(
      'PDA-R005',
      'Changed paths exceed the authorized scope',
      `Unexpected paths: ${unexpectedPaths.join(', ')}`,
      unexpectedPaths,
      'BLOCKED',
    );
    markFailure(
      'PDA-R006',
      'Scope expansion is required',
      'The Runner stopped instead of expanding scope automatically.',
      unexpectedPaths,
      'BLOCKED',
    );
    ruleResults.set('PDA-R015', {
      rule_id: 'PDA-R015',
      enforcement_type: 'FOUNDER_GATE',
      result: 'REQUIRED',
      message: 'Founder scope-expansion authorization is required.',
    });
  }

  const unknownRules = task.applicable_rules.filter((ruleId) => !rulesById.has(ruleId));
  if (unknownRules.length > 0) {
    markFailure(
      'PDA-R001',
      'Task Contract references unknown Rule IDs',
      `Unknown Rule IDs: ${unknownRules.join(', ')}`,
    );
  }

  if (!task.external_disclosure || typeof task.external_disclosure.permitted !== 'boolean') {
    markFailure(
      'PDA-R017',
      'External disclosure is not declared',
      'Task Contract must explicitly declare external disclosure.',
    );
  } else if (
    task.external_disclosure.permitted
    || task.external_disclosure.services.length > 0
    || task.external_disclosure.content.length > 0
  ) {
    markFailure(
      'PDA-R017',
      'External disclosure is not authorized for Phase A',
      JSON.stringify(task.external_disclosure),
    );
  }

  const secretMatches = scanSecrets({ task, evidenceManifest });
  if (secretMatches.length > 0) {
    markFailure(
      'PDA-R016',
      'Potential secret material detected',
      `Detected patterns: ${secretMatches.join(', ')}`,
    );
  }

  if (task.builder_agent === task.auditor_agent) {
    markFailure(
      'PDA-R014',
      'Builder and Auditor are the same Agent',
      `${task.builder_agent} cannot be both Builder and Auditor.`,
    );
  }

  const manifests = new Map(agentManifests.map((manifest) => [manifest.agent_id, manifest]));
  for (const requestedAgent of task.requested_agents) {
    const manifest = manifests.get(requestedAgent);
    if (!manifest) {
      markFailure(
        'PDA-R001',
        'Task requests an unknown Agent',
        `Unknown Agent: ${requestedAgent}`,
      );
      continue;
    }
    if (
      manifest.status === 'DISABLED_PENDING_FOUNDER_AUTHORIZATION'
      && task.requested_actions.some((action) => WRITE_ACTIONS.has(action))
    ) {
      const ruleId = requestedAgent === 'PhoenixBuilderAgent' ? 'PDA-R023' : 'PDA-R024';
      markFailure(
        ruleId,
        `${requestedAgent} cannot perform writes in Phase A`,
        `Requested write actions: ${task.requested_actions.filter((action) => WRITE_ACTIONS.has(action)).join(', ')}`,
      );
    }
  }

  if (evidenceManifest) {
    if (evidenceManifest.candidate_sha !== task.current_head_sha) {
      markFailure(
        'PDA-R004',
        'Evidence Manifest belongs to another Candidate Head',
        `manifest=${evidenceManifest.candidate_sha}; current=${task.current_head_sha}.`,
      );
    }
    for (const evidence of evidenceManifest.evidence ?? []) {
      if (evidence.candidate_sha !== task.current_head_sha
          && String(evidence.result).toUpperCase() === 'PASS') {
        markFailure(
          'PDA-R009',
          'PASS evidence belongs to an older Candidate Head',
          `${evidence.evidence_id}: ${evidence.candidate_sha}`,
        );
      }
    }
  } else if (task.required_evidence.length > 0) {
    limitations.push('No Evidence Manifest was supplied to this audit run.');
  }

  const requested = new Set(task.requested_actions);
  if (requested.has('READY') && task.founder_gates.ready_authorization !== 'PRESENT') {
    ruleResults.set('PDA-R012', {
      rule_id: 'PDA-R012',
      enforcement_type: 'FOUNDER_GATE',
      result: 'REQUIRED',
      message: 'Ready Authorization is NOT_PRESENT.',
    });
  }
  if (requested.has('MERGE') && task.founder_gates.merge_authorization !== 'PRESENT') {
    ruleResults.set('PDA-R013', {
      rule_id: 'PDA-R013',
      enforcement_type: 'FOUNDER_GATE',
      result: 'REQUIRED',
      message: 'Merge Authorization is NOT_PRESENT.',
    });
  }
  if (requested.has('AUTO_MERGE')) {
    markFailure('PDA-R019', 'Auto-merge is prohibited', 'AUTO_MERGE was requested.');
  }
  if (requested.has('DELETE_PREVIEW')
      && task.founder_gates.preview_deletion_authorization !== 'PRESENT') {
    ruleResults.set('PDA-R021', {
      rule_id: 'PDA-R021',
      enforcement_type: 'FOUNDER_GATE',
      result: 'REQUIRED',
      message: 'Preview deletion authorization is NOT_PRESENT.',
    });
  }
  if (requested.has('START_NEXT_PHASE')
      && task.founder_gates.next_phase_authorization !== 'PRESENT') {
    ruleResults.set('PDA-R020', {
      rule_id: 'PDA-R020',
      enforcement_type: 'FOUNDER_GATE',
      result: 'REQUIRED',
      message: 'Next phase authorization is NOT_PRESENT.',
    });
  }

  ruleResults.set('PDA-R022', {
    rule_id: 'PDA-R022',
    enforcement_type: 'DETERMINISTIC_CHECK',
    result: 'PASS',
    message: 'AI Review Result is truthfully NOT_RUN.',
  });
  ruleResults.set('PDA-R026', {
    rule_id: 'PDA-R026',
    enforcement_type: 'DETERMINISTIC_CHECK',
    result: 'PASS',
    message: 'Deterministic PASS is not represented as full product PASS.',
  });

  const hardFailures = [...ruleResults.values()].filter(
    (entry) => entry.enforcement_type === 'HARD_GATE'
      && ['BLOCKED','FAILURE','REGRESSION','REQUIRES_REVISION'].includes(entry.result),
  );
  const deterministicFailures = [...ruleResults.values()].filter(
    (entry) => entry.enforcement_type === 'DETERMINISTIC_CHECK'
      && ['BLOCKED','FAILURE','REGRESSION','REQUIRES_REVISION'].includes(entry.result),
  );

  let deterministicResult = hardFailures.length > 0 || deterministicFailures.length > 0
    ? 'FAILURE'
    : 'PASS';
  let finalDecision = deterministicResult === 'PASS'
    ? 'DETERMINISTIC_GATES_PASS_FOUNDER_GOVERNANCE_REVIEW_REQUIRED'
    : 'FAILURE';

  if (findings.some((finding) => finding.rule_id === 'PDA-R025')) {
    finalDecision = 'MODE_DISABLED_PENDING_FOUNDER_AUTHORIZATION';
  } else if (unexpectedPaths.length > 0) {
    finalDecision = 'SCOPE_EXPANSION_REQUIRED';
  }

  const report = {
    report_id: `PDA-AUDIT-${task.task_id}-${Date.now()}`,
    task_id: task.task_id,
    repository: task.repository,
    base_sha: task.base_sha,
    candidate_sha: task.current_head_sha,
    generated_at: nowIso(),
    deterministic_result: deterministicResult,
    ai_review_result: 'NOT_RUN',
    founder_gate_result: task.founder_gates.founder_governance_review === 'APPROVED'
      ? 'APPROVED'
      : 'REQUIRED',
    final_agent_decision: finalDecision,
    rule_results: [...ruleResults.values()],
    findings,
    summary: {
      changed_paths: changed,
      unexpected_paths: unexpectedPaths,
      hard_gate_failures: hardFailures.length,
      deterministic_failures: deterministicFailures.length,
    },
    limitations: [
      ...limitations,
      'No external AI review was executed.',
      'Deterministic checks do not establish product quality or Founder approval.',
    ],
  };

  return {
    report,
    exitCode: hardFailures.length > 0 || deterministicFailures.length > 0 ? 2 : 0,
  };
}

export function reportToMarkdown(report) {
  const lines = [
    '# Phoenix Development Agent Audit',
    '',
    `- Task: \`${report.task_id}\``,
    `- Repository: \`${report.repository}\``,
    `- Base SHA: \`${report.base_sha}\``,
    `- Candidate SHA: \`${report.candidate_sha}\``,
    '',
    `**Deterministic Result:** ${report.deterministic_result}`,
    '',
    `**AI Review Result:** ${report.ai_review_result}`,
    '',
    `**Founder Gate Result:** ${report.founder_gate_result}`,
    '',
    `**Final Agent Decision:** ${report.final_agent_decision}`,
    '',
    '## Scope',
    '',
    `- Changed paths: ${report.summary.changed_paths.length}`,
    `- Unexpected paths: ${report.summary.unexpected_paths.length}`,
    `- HARD_GATE failures: ${report.summary.hard_gate_failures}`,
    `- Deterministic failures: ${report.summary.deterministic_failures}`,
  ];
  if (report.summary.unexpected_paths.length > 0) {
    lines.push('', '### Unexpected Paths', '');
    for (const file of report.summary.unexpected_paths) lines.push(`- \`${file}\``);
  }
  if (report.findings.length > 0) {
    lines.push('', '## Findings', '');
    for (const finding of report.findings) {
      lines.push(`- **${finding.finding_id}** ${finding.title} (${finding.result})`);
    }
  }
  lines.push('', '## Limitations', '');
  for (const limitation of report.limitations) lines.push(`- ${limitation}`);
  lines.push('');
  return lines.join('\n');
}
