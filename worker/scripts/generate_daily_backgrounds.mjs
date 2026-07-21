import { mkdir, readFile, writeFile, unlink } from 'node:fs/promises';
import path from 'node:path';

import {
  PhoenixBackgroundScheduler,
  BACKGROUND_KPI,
} from '../agents/phoenix_background_scheduler.mjs';
import { PhoenixVisualComplianceAgent } from '../agents/phoenix_visual_compliance_agent.mjs';

const root = process.cwd();
const today = new Date().toISOString().slice(0, 10);
const outputDirectory = path.join(
  root,
  'app/assets/images/backgrounds/generated',
);
const manifestPath = path.join(
  root,
  'app/assets/images/backgrounds/manifest.json',
);
const dartPath = path.join(
  root,
  'app/lib/data/journey_background_generated.dart',
);
const reportDirectory = path.join(root, 'reports/backgrounds');
const apiKey = process.env.OPENAI_API_KEY ?? '';
const imageModel = process.env.PHOENIX_IMAGE_MODEL || 'gpt-image-2';

if (!apiKey) {
  throw new Error(
    'OPENAI_API_KEY GitHub Actions secret is required for the daily background KPI.',
  );
}

await mkdir(outputDirectory, { recursive: true });
await mkdir(reportDirectory, { recursive: true });

const scheduler = new PhoenixBackgroundScheduler();
const compliance = new PhoenixVisualComplianceAgent();
const plan = scheduler.createDailyPlan({ date: today });
const previous = await readJson(manifestPath, []);
const accepted = [];
const rejected = [...plan.rejectedJobs];

for (const job of plan.approvedJobs) {
  try {
    const generation = await openAi('/v1/images/generations', {
      model: imageModel,
      prompt: `${job.prompt} Avoid: ${job.negativePrompt}`,
      size: '1024x1536',
      quality: 'medium',
      output_format: 'webp',
      moderation: 'auto',
      n: 1,
    });
    const imageBase64 = generation?.data?.[0]?.b64_json;
    if (!imageBase64) throw new Error('Image API did not return b64_json.');

    const review = await compliance.reviewGeneratedImage({
      imageBase64,
      callResponsesApi: reviewWithVision,
    });
    if (!review.approved) {
      rejected.push({ ...job, imageReview: review });
      continue;
    }

    const filename = `${job.id}.webp`;
    await writeFile(
      path.join(outputDirectory, filename),
      Buffer.from(imageBase64, 'base64'),
    );
    accepted.push({
      id: job.id,
      journeyId: job.journeyId,
      assetPath: `assets/images/backgrounds/generated/${filename}`,
      generatedOn: today,
      origin: 'aiGenerated',
      complianceReviewed: true,
      complianceScore: review.score,
      varietyScore: review.varietyScore,
      varietyKey: job.varietyKey,
      timeOfDay: job.timeOfDay,
      weather: job.weather,
      camera: job.camera,
      scene: job.scene,
      pageTypes: [
        'explore',
        'passport',
        'profile',
        'story',
        'vocabulary',
        'discovery',
        'reflection',
        'writing',
        'memory',
        'completion',
      ],
    });
  } catch (error) {
    rejected.push({ ...job, error: String(error) });
  }
}

const combined = [...accepted, ...previous].sort((left, right) =>
  right.generatedOn.localeCompare(left.generatedOn),
);
const kept = [];
const counts = new Map();
for (const item of combined) {
  const count = counts.get(item.journeyId) ?? 0;
  if (count >= 24) {
    if (item.assetPath?.includes('/generated/')) {
      await unlink(path.join(root, 'app', item.assetPath)).catch(() => {});
    }
    continue;
  }
  counts.set(item.journeyId, count + 1);
  kept.push(item);
}

await writeFile(manifestPath, `${JSON.stringify(kept, null, 2)}\n`);
await writeFile(dartPath, renderDart(kept));

const report = {
  date: today,
  model: imageModel,
  expected: plan.expected,
  approved: accepted.length,
  rejected: rejected.length,
  kpi: BACKGROUND_KPI,
  passedDailyGenerationKpi: accepted.length === plan.expected,
  publishedInventory: Object.fromEntries(counts),
  approvedVarietyKeys: accepted.map((item) => item.varietyKey),
  minimumVarietyScore: BACKGROUND_KPI.minimumVarietyScore,
  rejectedItems: rejected,
};
await writeFile(
  path.join(reportDirectory, `${today}.json`),
  `${JSON.stringify(report, null, 2)}\n`,
);

if (!report.passedDailyGenerationKpi) {
  throw new Error(
    `Background KPI failed: ${accepted.length}/${plan.expected} approved.`,
  );
}

async function openAi(endpoint, body) {
  const response = await fetch(`https://api.openai.com${endpoint}`, {
    method: 'POST',
    headers: {
      authorization: `Bearer ${apiKey}`,
      'content-type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  const value = await response.json();
  if (!response.ok) {
    throw new Error(value?.error?.message || `OpenAI ${response.status}`);
  }
  return value;
}

async function reviewWithVision({ model, instruction, imageBase64 }) {
  const result = await openAi('/v1/responses', {
    model,
    store: false,
    input: [
      {
        role: 'user',
        content: [
          { type: 'input_text', text: instruction },
          {
            type: 'input_image',
            image_url: `data:image/webp;base64,${imageBase64}`,
          },
        ],
      },
    ],
    text: {
      format: {
        type: 'json_schema',
        name: 'visual_compliance',
        strict: true,
        schema: {
          type: 'object',
          additionalProperties: false,
          required: ['approved', 'score', 'varietyScore', 'issues'],
          properties: {
            approved: { type: 'boolean' },
            score: { type: 'integer', minimum: 0, maximum: 100 },
            varietyScore: { type: 'integer', minimum: 0, maximum: 100 },
            issues: { type: 'array', items: { type: 'string' } },
          },
        },
      },
    },
  });
  const outputText = result?.output
    ?.flatMap((item) => item.content ?? [])
    ?.find((item) => item.type === 'output_text')?.text;
  return JSON.parse(outputText || '{}');
}

async function readJson(file, fallback) {
  try {
    return JSON.parse(await readFile(file, 'utf8'));
  } catch {
    return fallback;
  }
}

function renderDart(items) {
  const rows = items
    .map(
      (item) => `  JourneyBackgroundAsset(
    id: '${escapeDart(item.id)}',
    journeyId: '${escapeDart(item.journeyId)}',
    assetPath: '${escapeDart(item.assetPath)}',
    generatedOn: DateTime.utc(${item.generatedOn.replaceAll('-', ', ')}),
    origin: JourneyBackgroundOrigin.aiGenerated,
    complianceReviewed: true,
    complianceScore: ${item.complianceScore},
  ),`,
    )
    .join('\n');
  return `import '../models/journey_background.dart';\n\nfinal generatedJourneyBackgrounds = <JourneyBackgroundAsset>[\n${rows}\n];\n`;
}

function escapeDart(value) {
  return String(value).replaceAll('\\', '\\\\').replaceAll("'", "\\'");
}
