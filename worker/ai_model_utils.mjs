export function safeLanguage(value) {
  const language = typeof value === 'string' ? value.trim() : '';
  return ['越南语', '英语', '双语', '中文解释'].includes(language)
    ? language
    : '越南语';
}

export function extractModelOutput(result) {
  if (typeof result === 'string') return result.trim();
  if (!result || typeof result !== 'object') return '';

  if (typeof result.response === 'string') return result.response.trim();
  if (result.response && typeof result.response === 'object') {
    return result.response;
  }

  if (typeof result.result === 'string') return result.result.trim();
  if (result.result && typeof result.result === 'object') {
    if (typeof result.result.response === 'string') {
      return result.result.response.trim();
    }
    if (result.result.response && typeof result.result.response === 'object') {
      return result.result.response;
    }
    if (Array.isArray(result.result.choices)) {
      const content = result.result.choices[0]?.message?.content;
      if (typeof content === 'string') return content.trim();
    }
  }

  if (Array.isArray(result.choices)) {
    const content = result.choices[0]?.message?.content;
    if (typeof content === 'string') return content.trim();
  }

  return '';
}

export function stripCodeFence(value) {
  return value
    .replace(/^```(?:json)?\s*/i, '')
    .replace(/\s*```$/i, '')
    .trim();
}
