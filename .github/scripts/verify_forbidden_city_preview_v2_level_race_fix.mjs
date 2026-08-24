import { readFile, writeFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';
import path from 'node:path';

const sourceUrl = new URL('./verify_forbidden_city_preview_v2.mjs', import.meta.url);
const source = await readFile(sourceUrl, 'utf8');

const original = `async function setLevel(page, target) {
  let level = await currentLevel(page);
  for (let guard = 0; level !== target && guard < 12; guard += 1) {
    const before = level;
    await tapButton(page, level < target ? '提高当前难度' : '降低当前难度', { prefix: true });
    for (let i = 0; i < 40; i += 1) {
      await sleep(100);
      level = await currentLevel(page);
      if (level !== before) break;
    }
    if (level === before) throw new Error(\`level selector did not move from \${before}\`);
  }
  if (level !== target) throw new Error(\`failed to select Lv\${target}; current Lv\${level}\`);
}`;

const replacement = `async function setLevel(page, target) {
  for (let guard = 0; guard < 12; guard += 1) {
    const level = await currentLevel(page);
    if (level === target) return;

    const direction = level < target ? '提高当前难度' : '降低当前难度';
    const rs = await records(page);
    const matches = rs.filter((r) =>
      r.visible && r.role === 'button' && recText(r).startsWith(direction)
    ).sort((a, b) => a.area - b.area);
    if (!matches.length) throw new Error(\`level selector button missing: \${direction}\`);

    const button = matches[0];
    if (button.disabled) {
      for (let i = 0; i < 20; i += 1) {
        await sleep(100);
        const settled = await currentLevel(page);
        if (settled === target) return;
        if (settled !== level) break;
      }
      const settled = await currentLevel(page);
      if (settled === target) return;
      if (settled !== level) continue;
      throw new Error(\`level selector button disabled before target: current Lv\${settled}, target Lv\${target}, button \${direction}\`);
    }

    const before = level;
    try {
      await page.locator('flt-semantics').nth(button.index).tap({ timeout: 2000 });
    } catch (error) {
      await sleep(100);
      const settled = await currentLevel(page).catch(() => before);
      if (settled === target) return;
      if (settled !== before) continue;
      throw error;
    }

    let moved = false;
    for (let i = 0; i < 40; i += 1) {
      await sleep(100);
      const settled = await currentLevel(page);
      if (settled === target) return;
      if (settled !== before) {
        moved = true;
        break;
      }
    }
    if (!moved) throw new Error(\`level selector did not move from \${before}\`);
  }

  const finalLevel = await currentLevel(page);
  if (finalLevel === target) return;
  throw new Error(\`failed to select Lv\${target}; current Lv\${finalLevel}\`);
}`;

if (!source.includes(original)) {
  throw new Error('Lv10 level-selector patch target did not match exact harness source');
}

const patched = source.replace(original, replacement);
const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `verify_forbidden_city_preview_v2_level_race_fix_${process.pid}.mjs`,
);
await writeFile(tempPath, patched, 'utf8');
await import(pathToFileURL(tempPath).href);
