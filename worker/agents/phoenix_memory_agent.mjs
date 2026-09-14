function safeString(value, limit = 120) {
  return typeof value === 'string' ? value.trim().slice(0, limit) : '';
}

export function safeStringList(
  value,
  { limit = 8, itemLimit = 500 } = {},
) {
  if (!Array.isArray(value)) return [];
  return value
    .filter((item) => typeof item === 'string' && item.trim())
    .slice(-limit)
    .map((item) => item.trim().slice(0, itemLimit));
}

export function safeLearnerProfile(value) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {};

  return {
    interfaceLanguage: safeString(value.interfaceLanguage, 40),
    scriptMode: safeString(value.scriptMode, 24),
    currentLevel:
      safeString(value.currentLevel, 80) || '根据本次文字动态判断',
    examGoal: safeString(value.examGoal, 80),
    savedWords: safeStringList(value.savedWords, {
      limit: 40,
      itemLimit: 40,
    }),
    completedJourneys: safeStringList(value.completedJourneys, {
      limit: 24,
      itemLimit: 120,
    }),
    recentGuideObservations: safeStringList(value.recentGuideObservations, {
      limit: 8,
      itemLimit: 500,
    }),
    recentWritingInsights: safeStringList(value.recentWritingInsights, {
      limit: 8,
      itemLimit: 600,
    }),
    recurringErrors: safeStringList(value.recurringErrors, {
      limit: 12,
      itemLimit: 180,
    }),
  };
}

function compactMemory(profile) {
  return {
    level: profile.currentLevel || '',
    goal: profile.examGoal || '',
    language: profile.interfaceLanguage || '',
    script: profile.scriptMode || '',
    savedWords: profile.savedWords ?? [],
    completedJourneys: profile.completedJourneys ?? [],
    recentObservations: profile.recentGuideObservations ?? [],
    recentWritingInsights: profile.recentWritingInsights ?? [],
    recurringErrors: profile.recurringErrors ?? [],
  };
}

export class PhoenixMemoryAgent {
  prepare(rawProfile) {
    const profile = safeLearnerProfile(rawProfile);
    const memory = compactMemory(profile);

    return {
      profile,
      memory,
      metadata: {
        agent: 'PhoenixMemoryAgent',
        storage: 'client-private',
        serverPersisted: false,
        savedWordCount: memory.savedWords.length,
        completedJourneyCount: memory.completedJourneys.length,
        observationCount: memory.recentObservations.length,
        writingInsightCount: memory.recentWritingInsights.length,
      },
    };
  }
}

export { compactMemory };
