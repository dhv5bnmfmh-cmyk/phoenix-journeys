export const OPENAI_DEFAULT_MODEL = 'gpt-5.6';
export const OPENAI_RESPONSES_URL = 'https://api.openai.com/v1/responses';

function outputTextFromResponse(value) {
  if (!value || typeof value !== 'object') return '';
  if (typeof value.output_text === 'string' && value.output_text.trim()) {
    return value.output_text.trim();
  }

  const parts = [];
  for (const item of Array.isArray(value.output) ? value.output : []) {
    for (const content of Array.isArray(item?.content) ? item.content : []) {
      if (
        content?.type === 'output_text' &&
        typeof content.text === 'string' &&
        content.text.trim()
      ) {
        parts.push(content.text.trim());
      }
    }
  }
  return parts.join('\n').trim();
}

function splitMessages(messages) {
  const instructions = [];
  const input = [];

  for (const message of Array.isArray(messages) ? messages : []) {
    if (!message || typeof message.content !== 'string') continue;
    const content = message.content.trim();
    if (!content) continue;
    if (message.role === 'system' || message.role === 'developer') {
      instructions.push(content);
      continue;
    }
    if (message.role === 'user' || message.role === 'assistant') {
      input.push({ role: message.role, content });
    }
  }

  return {
    instructions: instructions.join('\n\n'),
    input,
  };
}

export class OpenAIResponsesProvider {
  constructor(env, { fetchImpl = fetch } = {}) {
    this.apiKey = typeof env?.OPENAI_API_KEY === 'string'
      ? env.OPENAI_API_KEY.trim()
      : '';
    this.model =
      typeof env?.OPENAI_MODEL === 'string' && env.OPENAI_MODEL.trim()
        ? env.OPENAI_MODEL.trim()
        : OPENAI_DEFAULT_MODEL;
    this.fetchImpl = fetchImpl;
  }

  get isAvailable() {
    return Boolean(this.apiKey);
  }

  async generate({
    messages,
    maxOutputTokens = 900,
    reasoningEffort = 'medium',
    schema,
    schemaName = 'phoenix_response',
    timeoutMs = 30000,
  }) {
    if (!this.isAvailable) {
      throw new Error('OpenAI provider is not configured.');
    }

    const { instructions, input } = splitMessages(messages);
    const body = {
      model: this.model,
      store: false,
      instructions,
      input,
      max_output_tokens: maxOutputTokens,
      reasoning: { effort: reasoningEffort },
    };

    if (schema) {
      body.text = {
        format: {
          type: 'json_schema',
          name: schemaName,
          strict: true,
          schema,
        },
      };
    }

    const abort = new AbortController();
    const timer = setTimeout(() => abort.abort(), timeoutMs);
    let response;
    try {
      response = await this.fetchImpl(OPENAI_RESPONSES_URL, {
        method: 'POST',
        headers: {
          authorization: `Bearer ${this.apiKey}`,
          'content-type': 'application/json',
        },
        body: JSON.stringify(body),
        signal: abort.signal,
      });
    } finally {
      clearTimeout(timer);
    }

    const raw = await response.text();
    let value;
    try {
      value = raw ? JSON.parse(raw) : {};
    } catch (_) {
      value = {};
    }

    if (!response.ok) {
      const message = value?.error?.message || `OpenAI request failed (${response.status}).`;
      throw new Error(message);
    }

    const output = outputTextFromResponse(value);
    if (!output) throw new Error('OpenAI returned no output text.');

    return {
      output,
      provider: 'openai',
      model: value?.model || this.model,
      requestId: response.headers.get('x-request-id') || '',
    };
  }
}

export { outputTextFromResponse, splitMessages };
