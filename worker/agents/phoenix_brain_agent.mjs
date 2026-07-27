import { PhoenixModelGateway } from '../ai/phoenix_model_gateway.mjs';
import { PhoenixGuideAgent } from './phoenix_guide_agent.mjs';
import { PhoenixWritingAgent } from './phoenix_writing_agent.mjs';
import { PhoenixConversationAgent } from './phoenix_conversation_agent.mjs';
import { PhoenixLearningAgent } from './phoenix_learning_agent.mjs';
import { PhoenixVocabularyAgent } from './phoenix_vocabulary_agent.mjs';
import { PhoenixMemoryAgent } from './phoenix_memory_agent.mjs';
import { PhoenixKnowledgeAgent } from './phoenix_knowledge_agent.mjs';

export const PHOENIX_AI_MODES = [
  'guide',
  'writing',
  'conversation',
  'learning',
  'vocabulary',
];

export class PhoenixBrainAgent {
  constructor(env, { gateway } = {}) {
    this.gateway = gateway ?? new PhoenixModelGateway(env);
    this.memory = new PhoenixMemoryAgent();
    this.knowledge = new PhoenixKnowledgeAgent();
    this.guide = new PhoenixGuideAgent(env, { gateway: this.gateway });
    this.writing = new PhoenixWritingAgent(env, { gateway: this.gateway });
    this.conversation = new PhoenixConversationAgent(env, {
      gateway: this.gateway,
    });
    this.learning = new PhoenixLearningAgent(env, { gateway: this.gateway });
    this.vocabulary = new PhoenixVocabularyAgent(env, {
      gateway: this.gateway,
    });
  }

  get isAvailable() {
    return this.gateway.isAvailable;
  }

  async run(payload) {
    if (!PHOENIX_AI_MODES.includes(payload?.mode)) {
      throw new TypeError('不支持的 AI 模式。');
    }

    const preparedMemory = this.memory.prepare(payload.learnerProfile);
    const groundedKnowledge = this.knowledge.ground(payload.journeyId);
    const specialistPayload = {
      ...payload,
      learnerProfile: preparedMemory.profile,
      memory: preparedMemory.memory,
      knowledge: groundedKnowledge,
    };

    let result;
    switch (payload.mode) {
      case 'guide':
        result = await this.guide.respond(specialistPayload);
        break;
      case 'writing':
        result = await this.writing.review(specialistPayload);
        break;
      case 'conversation':
        result = await this.conversation.respond(specialistPayload);
        break;
      case 'learning':
        result = await this.learning.analyze(specialistPayload);
        break;
      case 'vocabulary':
        result = await this.vocabulary.generate(specialistPayload);
        break;
      default:
        throw new TypeError('不支持的 AI 模式。');
    }

    return {
      ...result,
      orchestrator: 'PhoenixBrainAgent',
      memory: preparedMemory.metadata,
      knowledge: groundedKnowledge.metadata,
    };
  }
}
