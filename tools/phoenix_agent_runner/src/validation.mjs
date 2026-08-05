import fs from 'node:fs';
import path from 'node:path';
import { readJson } from './utils.mjs';

function valueType(value) {
  if (Array.isArray(value)) return 'array';
  if (value === null) return 'null';
  if (Number.isInteger(value)) return 'integer';
  return typeof value;
}

export function validateAgainstSchema(value, schema, location = '$') {
  const errors = [];
  if (!schema || typeof schema !== 'object') return errors;

  if (schema.type) {
    const actual = valueType(value);
    const accepted = schema.type === 'number'
      ? ['number', 'integer']
      : [schema.type];
    if (!accepted.includes(actual)) {
      errors.push(`${location}: expected ${schema.type}, received ${actual}`);
      return errors;
    }
  }

  if (schema.enum && !schema.enum.includes(value)) {
    errors.push(`${location}: value is not in enum`);
  }
  if (schema.const !== undefined && value !== schema.const) {
    errors.push(`${location}: value does not equal const`);
  }

  if (typeof value === 'string') {
    if (schema.minLength !== undefined && value.length < schema.minLength) {
      errors.push(`${location}: string is shorter than minLength ${schema.minLength}`);
    }
    if (schema.pattern && !(new RegExp(schema.pattern, 'u')).test(value)) {
      errors.push(`${location}: string does not match ${schema.pattern}`);
    }
  }

  if (typeof value === 'number') {
    if (schema.minimum !== undefined && value < schema.minimum) {
      errors.push(`${location}: value is less than minimum ${schema.minimum}`);
    }
    if (schema.maximum !== undefined && value > schema.maximum) {
      errors.push(`${location}: value is greater than maximum ${schema.maximum}`);
    }
  }

  if (Array.isArray(value)) {
    if (schema.minItems !== undefined && value.length < schema.minItems) {
      errors.push(`${location}: array has fewer than ${schema.minItems} items`);
    }
    if (schema.items) {
      value.forEach((entry, index) => {
        errors.push(...validateAgainstSchema(entry, schema.items, `${location}[${index}]`));
      });
    }
  }

  if (value && typeof value === 'object' && !Array.isArray(value)) {
    for (const required of schema.required ?? []) {
      if (!(required in value)) errors.push(`${location}.${required}: required property is missing`);
    }
    const properties = schema.properties ?? {};
    for (const [key, entry] of Object.entries(value)) {
      if (properties[key]) {
        errors.push(...validateAgainstSchema(entry, properties[key], `${location}.${key}`));
      } else if (schema.additionalProperties === false) {
        errors.push(`${location}.${key}: additional property is not allowed`);
      }
    }
  }

  return errors;
}

export function validateAgentManifest(manifest) {
  const required = [
    'agent_id','version','mission','inputs','outputs','allowed_tools','allowed_actions',
    'forbidden_actions','required_evidence','stop_conditions','escalation_conditions',
    'founder_gates','self_approval_prohibited','status',
  ];
  const errors = [];
  for (const key of required) {
    if (!(key in manifest)) errors.push(`${manifest.agent_id ?? 'unknown'}: missing ${key}`);
  }
  for (const key of [
    'inputs','outputs','allowed_tools','allowed_actions','forbidden_actions',
    'required_evidence','stop_conditions','escalation_conditions','founder_gates',
  ]) {
    if (key in manifest && !Array.isArray(manifest[key])) {
      errors.push(`${manifest.agent_id ?? 'unknown'}: ${key} must be an array`);
    }
  }
  if (manifest.self_approval_prohibited !== true) {
    errors.push(`${manifest.agent_id ?? 'unknown'}: self_approval_prohibited must be true`);
  }
  if (!['ACTIVE_READ_ONLY','DISABLED_PENDING_FOUNDER_AUTHORIZATION'].includes(manifest.status)) {
    errors.push(`${manifest.agent_id ?? 'unknown'}: unsupported status`);
  }
  return errors;
}

export function validateRuleRegistry(registry) {
  const errors = [];
  const allowedTypes = new Set(['HARD_GATE','DETERMINISTIC_CHECK','AI_REVIEW','FOUNDER_GATE']);
  if (!Array.isArray(registry.rules) || registry.rules.length < 15) {
    errors.push('Rule Registry must contain at least 15 rules.');
    return errors;
  }
  const ids = new Set();
  const required = [
    'rule_id','title','source_document','source_section','requirement','applies_when',
    'enforcement_type','required_evidence','failure_result','severity',
    'auto_fix_permitted','founder_authorization_required','founder_gate','stop_condition',
  ];
  for (const rule of registry.rules) {
    for (const key of required) {
      if (!(key in rule)) errors.push(`${rule.rule_id ?? 'unknown'}: missing ${key}`);
    }
    if (ids.has(rule.rule_id)) errors.push(`${rule.rule_id}: duplicate rule_id`);
    ids.add(rule.rule_id);
    if (!allowedTypes.has(rule.enforcement_type)) {
      errors.push(`${rule.rule_id}: unsupported enforcement_type`);
    }
    if (!String(rule.source_document ?? '').startsWith('docs/')
        && rule.source_document !== '.github/pull_request_template.md') {
      errors.push(`${rule.rule_id}: source_document must reference an existing Phoenix governance path`);
    }
  }
  return errors;
}

export function validateRepositoryConfig(root) {
  const errors = [];
  const agentDir = path.join(root, 'ai/development/agents');
  const agentFiles = fs.readdirSync(agentDir).filter((name) => name.endsWith('.agent.json'));
  if (agentFiles.length !== 6) errors.push(`Expected 6 agent manifests, found ${agentFiles.length}.`);
  const manifests = agentFiles.map((name) => readJson(path.join(agentDir, name)));
  for (const manifest of manifests) errors.push(...validateAgentManifest(manifest));

  const byId = new Map(manifests.map((entry) => [entry.agent_id, entry]));
  for (const disabled of ['PhoenixBuilderAgent','PhoenixRemediationAgent']) {
    if (byId.get(disabled)?.status !== 'DISABLED_PENDING_FOUNDER_AUTHORIZATION') {
      errors.push(`${disabled} must remain DISABLED_PENDING_FOUNDER_AUTHORIZATION.`);
    }
    if ((byId.get(disabled)?.allowed_tools ?? []).length !== 0
        || (byId.get(disabled)?.allowed_actions ?? []).length !== 0) {
      errors.push(`${disabled} must have no tools or actions in Phase A.`);
    }
  }

  const registry = readJson(path.join(root, 'ai/development/policies/rule_registry.json'));
  errors.push(...validateRuleRegistry(registry));

  const schemaDir = path.join(root, 'ai/development/schemas');
  const schemas = Object.fromEntries(
    fs.readdirSync(schemaDir)
      .filter((name) => name.endsWith('.schema.json'))
      .map((name) => [name, readJson(path.join(schemaDir, name))]),
  );
  if (Object.keys(schemas).length !== 4) {
    errors.push(`Expected 4 schemas, found ${Object.keys(schemas).length}.`);
  }

  const taskSchema = schemas['task_contract.schema.json'];
  const findingSchema = schemas['finding.schema.json'];
  const reportSchema = schemas['audit_report.schema.json'];
  const examples = path.join(root, 'ai/development/examples');
  for (const file of ['valid_read_only_task.json','invalid_scope_task.json']) {
    errors.push(
      ...validateAgainstSchema(readJson(path.join(examples, file)), taskSchema, file),
    );
  }
  errors.push(
    ...validateAgainstSchema(
      readJson(path.join(examples, 'sample_finding.json')),
      findingSchema,
      'sample_finding.json',
    ),
  );
  errors.push(
    ...validateAgainstSchema(
      readJson(path.join(examples, 'sample_audit_report.json')),
      reportSchema,
      'sample_audit_report.json',
    ),
  );

  return { errors, manifests, registry, schemas };
}
