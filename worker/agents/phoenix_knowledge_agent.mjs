import { getJourneyContext } from './phoenix_guide_agent.mjs';

function safeJourneyId(value) {
  return typeof value === 'string' && value.trim()
    ? value.trim().slice(0, 120)
    : 'beijing-forbidden-city';
}

export class PhoenixKnowledgeAgent {
  ground(journeyId) {
    const safeId = safeJourneyId(journeyId);
    const journey = getJourneyContext(safeId);

    return {
      journeyId: safeId,
      journey: {
        city: journey.city,
        place: journey.place,
        context: journey.context,
        reflection: journey.reflection,
      },
      boundaries: [
        '只使用 Phoenix 已审核 Journey 背景中的文化与历史信息。',
        '背景没有提供的具体年代、人物、数字或事件不得猜测。',
        '无法确认时必须明确说明不确定。',
      ],
      metadata: {
        agent: 'PhoenixKnowledgeAgent',
        source: 'phoenix-reviewed-journey-catalog',
        grounded: true,
        journeyId: safeId,
      },
    };
  }
}

export { safeJourneyId };
