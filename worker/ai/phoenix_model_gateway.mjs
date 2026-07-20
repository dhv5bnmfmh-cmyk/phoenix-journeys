import { extractModelOutput, stripCodeFence } from '../ai_model_utils.mjs';
import {
  OpenAIResponsesProvider,
  OPENAI_DEFAULT_MODEL,
} from './openai_responses_provider.mjs';

export const CLOUDFLARE_FALLBACK_MODEL = '@cf/zai-org/glm-4.7-flash';

function parseStructuredOutput(output) {
  if (output && typeof output === 'object') return output;
  if (typeof output !== 'string') return null;
  try {
    return JSON.parse(stripCodeFence(output));
  } catch (_) {
    return null;
  }
}

export class PhoenixModelGateway {
  constructor(env, options = {}) {
    this.env = env;
    this.openai = new OpenAIResponsesProvider(env, options);
    this.cloudflare = env?.AI;
    this.fallbackModel =
      typeof env?.CLOUDFLARE_AI_MODEL === 'string' &&
      env.CLOUDFLARE_AI_MODEL.trim()
        ? env.CLOUDFLARE_AI_MODEL.trim()
        : CLOUDFLARE_FALLBACK_MODEL;
  }

  get isAvailable() {
    return (
      this.openai.isAvailable ||
      Boolean(this.cloudflare && typeof this.cloudflare.run === 'function')
    );
  }

  get primaryModel() {
    return this.openai.isAvailable ? this.openai.model : this.fallbackModel;
  }

  async generate({
    messages,
    maxOutputTokens = 900,
    reasoningEffort = 'medium',
    temperature = 0.35,
    schema,
    schemaName,
    purpose = 'phoenix',
  }) {
    if (this.openai.isAvailable) {
      try {
        return await this.openai.generate({
          messages,
          maxOutputTokens,
          reasoningEffort,
          schema,
          schemaName,
        });
      } catch (error) {
        console.error('Phoenix OpenAI request failed; using Cloudflare fallback', {
          purpose,
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }

    if (!this.cloudflare || typeof this.cloudflare.run !== 'function') {
      throw new Error('No Phoenix AI provider is available.');
    }

    const result = await this.cloudflare.run(this.fallbackModel, {
      messages,
      temperature,
      max_completion_tokens: maxOutputTokens,
    });
    const output = extractModelOutput(result);
    if (!output || (typeof output === 'string' && !output.trim())) {
      throw new Error('Cloudflare fallback returned no output.');
    }

    return {
      output,
      provider: 'cloudflare',
      model: this.fallbackModel,
      requestId: '',
    };
  }

  async generateStructured(options) {
    const result = await this.generate(options);
    const value = parseStructuredOutput(result.output);
    if (!value) throw new Error('Phoenix structured output was invalid.');
    return { ...result, value };
  }
}

export { OPENAI_DEFAULT_MODEL, parseStructuredOutput };
