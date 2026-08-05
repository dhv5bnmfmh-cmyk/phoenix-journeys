import { canonicalJson, sha256Text } from './identity-freshness.mjs';

export function semanticRuleRecord(rule) {
  return {
    rule_id: rule.rule_id,
    severity: rule.severity,
    enforcement_type: rule.enforcement_type,
    source_document: rule.source_document,
    source_section: rule.source_section,
    requirement: String(rule.requirement).trim().replace(/\s+/g, ' '),
    founder_gate: rule.founder_gate,
    auto_fix_permitted: rule.auto_fix_permitted,
  };
}

export function semanticRuleDigest(rule) { return sha256Text(canonicalJson(semanticRuleRecord(rule))); }

export function assertMandatoryRuleInventory(registry, inventory) {
  if (!Array.isArray(registry?.rules) || !Array.isArray(inventory?.rules)) throw new Error('TRUSTED_RULE_INVENTORY_INVALID');
  const expectedIds = Array.from({ length: 26 }, (_, i) => `PDA-R${String(i + 1).padStart(3, '0')}`);
  const actualIds = registry.rules.map(r => r.rule_id);
  if (new Set(actualIds).size !== actualIds.length) throw new Error('TRUSTED_RULE_DUPLICATE');
  for (const id of expectedIds) if (!actualIds.includes(id)) throw new Error(`TRUSTED_RULE_MISSING:${id}`);
  if (actualIds.length !== expectedIds.length) throw new Error('TRUSTED_RULE_UNEXPECTED');
  const expected = new Map(inventory.rules.map(r => [r.rule_id, r]));
  for (const rule of registry.rules) {
    const authority = expected.get(rule.rule_id);
    if (!authority) throw new Error(`TRUSTED_RULE_UNAUTHORIZED:${rule.rule_id}`);
    const normalized = semanticRuleRecord(rule);
    for (const field of ['severity','enforcement_type','source_document','source_section','founder_gate','auto_fix_permitted']) {
      if (normalized[field] !== authority[field]) throw new Error(`TRUSTED_RULE_AUTHORITY_CHANGED:${rule.rule_id}:${field}`);
    }
    if (semanticRuleDigest(rule) !== authority.semantic_digest) throw new Error(`TRUSTED_RULE_AUTHORITY_CHANGED:${rule.rule_id}:requirement_semantics`);
  }
  return sha256Text(canonicalJson(inventory));
}

export function assertTrustedSchemaInventory(schemas, inventory) {
  const expected = new Map(inventory.schemas.map(item => [item.path, item.sha256]));
  for (const [path, schema] of Object.entries(schemas)) {
    if (!expected.has(path)) throw new Error(`TRUSTED_SCHEMA_UNAUTHORIZED:${path}`);
    if (sha256Text(canonicalJson(schema)) !== expected.get(path)) throw new Error(`TRUSTED_SCHEMA_AUTHORITY_CHANGED:${path}`);
  }
  for (const path of expected.keys()) if (!(path in schemas)) throw new Error(`TRUSTED_SCHEMA_MISSING:${path}`);
  return sha256Text(canonicalJson(inventory));
}
