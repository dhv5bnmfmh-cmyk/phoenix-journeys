const destinationBriefs = {
  'beijing-forbidden-city':
    'Forbidden City red walls, golden glazed roofs, ceremonial courtyards, Beijing atmosphere',
  'shanghai-bund':
    'the Bund waterfront, historic stone facades and a distant modern Pudong skyline',
  'xian-city-wall':
    'Xi’an city wall, gate tower, brick ramparts and broad ancient-capital horizon',
  'hangzhou-west-lake':
    'West Lake water, willow branches, causeway, distant hills and a restrained pagoda silhouette',
  'chengdu-kuanzhai-alley':
    'Kuanzhai Alley courtyards, grey brick lanes, bamboo and warm lantern light',
  'nanjing-qinhuai-river':
    'Qinhuai River, white-wall black-roof houses, arch bridge and gentle lantern reflections',
  'guangzhou-chen-clan':
    'Chen Clan Ancestral Hall, Lingnan roof ridges, courtyards and subtle ceramic ornament',
};

const pageMoods = [
  'story-immersive',
  'discovery-cultural',
  'study-calm',
  'general-light',
];

export class PhoenixBackgroundAgent {
  constructor({ variantsPerDestination = 4 } = {}) {
    this.variantsPerDestination = variantsPerDestination;
  }

  planDailyJobs({ date, journeyIds = Object.keys(destinationBriefs) }) {
    return journeyIds.flatMap((journeyId) =>
      Array.from({ length: this.variantsPerDestination }, (_, index) => {
        const mood = pageMoods[index % pageMoods.length];
        return {
          id: `${journeyId}-${date}-${mood}`,
          journeyId,
          date,
          mood,
          prompt: [
            'Create an original vertical mobile app background illustration.',
            destinationBriefs[journeyId],
            `Mood: ${mood}.`,
            'Elegant editorial travel illustration, atmospheric depth, calm edges, spacious center for readable UI cards.',
            'Historically plausible but not a replica of any photograph or artwork.',
            'Original composition, no text, no logo, no trademark, no copyrighted character, no celebrity, no signature, no watermark, no artist imitation.',
          ].join(' '),
          negativePrompt:
            'No text, no logo, no trademark, no brand mark, no copyrighted character, no movie character, no anime character, no celebrity, no signature, no watermark, no copied poster, no artist imitation.',
        };
      }),
    );
  }
}

export const PHOENIX_BACKGROUND_DESTINATIONS = Object.freeze(
  Object.keys(destinationBriefs),
);
