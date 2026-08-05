import Ajv2020 from 'ajv/dist/2020.js';

const DRAFT_2020_12 = 'https://json-schema.org/draft/2020-12/schema';

function normalizeLabel(label) {
  return String(label || 'object')
    .trim()
    .replace(/[^A-Za-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .toUpperCase() || 'OBJECT';
}

function sanitizeErrors(errors = []) {
  return errors.map(error => ({
    instancePath: String(error.instancePath || ''),
    schemaPath: String(error.schemaPath || ''),
    keyword: String(error.keyword || 'unknown'),
    message: String(error.message || 'validation failed'),
    params: Object.fromEntries(
      Object.entries(error.params || {}).map(([key, value]) => [
        key,
        typeof value === 'string' && value.length > 160
          ? `${value.slice(0, 157)}...`
          : value,
      ]),
    ),
  }));
}

export class TrustedSchemaError extends Error {
  constructor(code, errors = []) {
    super(code);
    this.name = 'TrustedSchemaError';
    this.code = code;
    this.errors = sanitizeErrors(errors);
  }
}

function createAjv() {
  return new Ajv2020({
    strict: true,
    strictSchema: true,
    strictTypes: true,
    strictTuples: true,
    strictRequired: true,
    allErrors: true,
    validateFormats: false,
    allowUnionTypes: false,
    removeAdditional: false,
    useDefaults: false,
    coerceTypes: false,
    messages: true,
  });
}

export function compileTrustedSchema(schema, label = 'schema') {
  const code = `${normalizeLabel(label)}_SCHEMA_COMPILE_INVALID`;
  if (!schema || typeof schema !== 'object' || Array.isArray(schema)) {
    throw new TrustedSchemaError(code, [{
      keyword: 'type',
      message: 'schema must be a non-null object',
      instancePath: '',
      schemaPath: '',
      params: {},
    }]);
  }
  if (schema.$schema !== DRAFT_2020_12) {
    throw new TrustedSchemaError(code, [{
      keyword: '$schema',
      message: `schema must declare ${DRAFT_2020_12}`,
      instancePath: '',
      schemaPath: '/$schema',
      params: { expected: DRAFT_2020_12 },
    }]);
  }
  try {
    return createAjv().compile(structuredClone(schema));
  } catch (error) {
    throw new TrustedSchemaError(code, [{
      keyword: 'compile',
      message: error instanceof Error ? error.message : 'schema compilation failed',
      instancePath: '',
      schemaPath: '',
      params: {},
    }]);
  }
}

export function validateObject(schema, value, label = 'object') {
  const normalized = normalizeLabel(label);
  const validate = compileTrustedSchema(schema, label);
  let valid;
  try {
    valid = validate(value);
  } catch (error) {
    throw new TrustedSchemaError(`${normalized}_SCHEMA_VALIDATION_FAILED`, [{
      keyword: 'runtime',
      message: error instanceof Error ? error.message : 'schema validation failed',
      instancePath: '',
      schemaPath: '',
      params: {},
    }]);
  }
  if (!valid) {
    throw new TrustedSchemaError(
      `${normalized}_SCHEMA_INVALID`,
      validate.errors || [],
    );
  }
  return value;
}
