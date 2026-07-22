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

export const PHOENIX_OFFLINE_IMAGES_PER_DESTINATION = 10;

const libraryVariants = Object.freeze([
  {
    slug: 'sunrise-arrival',
    mood: 'story-immersive',
    timeOfDay: 'sunrise',
    weather: 'clear air',
    camera: 'wide establishing view',
    scene: 'quiet arrival',
  },
  {
    slug: 'morning-street',
    mood: 'study-calm',
    timeOfDay: 'early morning',
    weather: 'soft cloud cover',
    camera: 'street-level human perspective',
    scene: 'local daily life without identifiable people',
  },
  {
    slug: 'misty-detail',
    mood: 'discovery-cultural',
    timeOfDay: 'morning',
    weather: 'light mist',
    camera: 'architectural detail with deep background',
    scene: 'heritage detail',
  },
  {
    slug: 'bright-panorama',
    mood: 'general-light',
    timeOfDay: 'bright afternoon',
    weather: 'clear air',
    camera: 'elevated panoramic perspective',
    scene: 'open city panorama',
  },
  {
    slug: 'after-rain',
    mood: 'reflection-soft',
    timeOfDay: 'afternoon',
    weather: 'after rain',
    camera: 'low reflective perspective',
    scene: 'wet stone and soft reflections',
  },
  {
    slug: 'seasonal-landscape',
    mood: 'memory-warm',
    timeOfDay: 'late afternoon',
    weather: 'soft cloud cover',
    camera: 'layered landscape view',
    scene: 'seasonal landscape',
  },
  {
    slug: 'golden-hour',
    mood: 'writing-gentle',
    timeOfDay: 'golden hour',
    weather: 'warm clear sky',
    camera: 'side-lit architectural perspective',
    scene: 'warm departure',
  },
  {
    slug: 'blue-hour',
    mood: 'discovery-evening',
    timeOfDay: 'blue hour',
    weather: 'calm evening air',
    camera: 'wide evening perspective',
    scene: 'first city lights',
  },
  {
    slug: 'lantern-night',
    mood: 'story-night',
    timeOfDay: 'night',
    weather: 'clear night',
    camera: 'street-level cinematic depth',
    scene: 'illuminated evening atmosphere',
  },
  {
    slug: 'quiet-night-panorama',
    mood: 'completion-calm',
    timeOfDay: 'late night',
    weather: 'light haze',
    camera: 'elevated quiet panorama',
    scene: 'calm closing view',
  },
]);

// Published libraries may keep human-friendly art-direction slugs while the
// scheduler uses stable semantic slot IDs. Canonicalizing shipped IDs here
// prevents the Agent from regenerating a destination whose ten slots already
// exist in the reviewed offline library.
const publishedSlotAliases = Object.freeze({
  'beijing-forbidden-city-01-twilight-courtyard':
    'beijing-forbidden-city-01-sunrise-arrival',
  'beijing-forbidden-city-02-moonlit-palace':
    'beijing-forbidden-city-02-morning-street',
  'beijing-forbidden-city-03-golden-gate':
    'beijing-forbidden-city-03-misty-detail',
  'beijing-forbidden-city-04-winter-snow':
    'beijing-forbidden-city-04-bright-panorama',
  'beijing-forbidden-city-05-after-rain':
    'beijing-forbidden-city-05-after-rain',
  'beijing-forbidden-city-06-autumn-maples':
    'beijing-forbidden-city-06-seasonal-landscape',
  'beijing-forbidden-city-07-clear-morning':
    'beijing-forbidden-city-07-golden-hour',
  'beijing-forbidden-city-08-sunlit-corridor':
    'beijing-forbidden-city-08-blue-hour',
  'beijing-forbidden-city-09-misty-courtyard':
    'beijing-forbidden-city-09-lantern-night',
  'beijing-forbidden-city-10-sunset-panorama':
    'beijing-forbidden-city-10-quiet-night-panorama',
});

const canonicalSlotId = (id) => publishedSlotAliases[id] ?? id;

export class PhoenixBackgroundAgent {
  constructor({
    targetPerDestination = PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
  } = {}) {
    this.targetPerDestination = targetPerDestination;
  }

  planOfflineLibrary({
    journeyIds = Object.keys(destinationBriefs),
    existingIds = [],
    maxNewImages = Number.POSITIVE_INFINITY,
  } = {}) {
    const existing = new Set(existingIds.map(canonicalSlotId));
    const allSlots = journeyIds.flatMap((journeyId) =>
      libraryVariants
        .slice(0, this.targetPerDestination)
        .map((variant, index) => this._buildJob({ journeyId, variant, index })),
    );
    const missingSlots = allSlots.filter((job) => !existing.has(job.id));
    return missingSlots.slice(0, Math.max(0, maxNewImages));
  }

  // Compatibility for older callers. The offline plan is stable and never
  // requires image generation while an explorer is using the app.
  planDailyJobs({ journeyIds = Object.keys(destinationBriefs) } = {}) {
    return this.planOfflineLibrary({ journeyIds });
  }

  _buildJob({ journeyId, variant, index }) {
    const varietyKey = [
      journeyId,
      variant.timeOfDay,
      variant.weather,
      variant.camera,
      variant.scene,
    ].join('|');
    return {
      id: `${journeyId}-${String(index + 1).padStart(2, '0')}-${variant.slug}`,
      journeyId,
      fileName: `${journeyId}-${String(index + 1).padStart(2, '0')}-${variant.slug}.webp`,
      slot: index + 1,
      mood: variant.mood,
      timeOfDay: variant.timeOfDay,
      weather: variant.weather,
      camera: variant.camera,
      scene: variant.scene,
      varietyKey,
      prompt: [
        'Create an original vertical mobile app background illustration for the Phoenix Journeys offline library.',
        destinationBriefs[journeyId],
        `Library slot ${index + 1} of ${PHOENIX_OFFLINE_IMAGES_PER_DESTINATION}.`,
        `Mood: ${variant.mood}.`,
        `Scene variation: ${variant.timeOfDay}, ${variant.weather}, ${variant.camera}, ${variant.scene}.`,
        'Make this composition visibly different from every other city slot.',
        'Elegant editorial travel illustration, atmospheric depth, calm edges and spacious center for readable Chinese learning UI cards.',
        'Historically plausible but not a replica of any photograph or artwork.',
        'Original composition, no text, no logo, no trademark, no copyrighted character, no celebrity, no signature, no watermark and no artist imitation.',
      ].join(' '),
      negativePrompt:
        'No text, no logo, no trademark, no brand mark, no copyrighted character, no movie character, no anime character, no celebrity, no signature, no watermark, no copied poster, no artist imitation and no repeated generic composition.',
    };
  }
}

export const PHOENIX_BACKGROUND_DESTINATIONS = Object.freeze(
  Object.keys(destinationBriefs),
);
