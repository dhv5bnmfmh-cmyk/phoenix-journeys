import { readFile, writeFile, stat } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { basename, resolve } from 'node:path';

const root = resolve(import.meta.dirname, '../..');
const registerPath = resolve(root, 'design/ASSET_REGISTER.csv');

function parseCsv(text) {
  const rows = [];
  let row = [], field = '', quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    if (quoted) {
      if (char === '"' && text[i + 1] === '"') { field += '"'; i += 1; }
      else if (char === '"') quoted = false;
      else field += char;
    } else if (char === '"') quoted = true;
    else if (char === ',') { row.push(field); field = ''; }
    else if (char === '\n') { row.push(field.replace(/\r$/, '')); rows.push(row); row = []; field = ''; }
    else field += char;
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

const quote = (value) => {
  const text = String(value ?? '');
  return /[",\n\r]/.test(text) ? `"${text.replaceAll('"', '""')}"` : text;
};

const oldToNew = [
  ['app/assets/images/home/phoenix-world-language-journey-v1.webp','PHX-GLOBAL-HOME-001','app/assets/images/home/phoenix-home-journey-keyart-portrait-v1.webp','Home','Global Explore Home','design/sources/global-critical-v1/phoenix-home-journey-keyart-portrait-v1.svg','BoxFit.cover across phone/tablet','Explore gradient errorBuilder','Home camera stops at fixed phase'],
  ['app/assets/images/maps/world-flight-atlas-v1.webp','PHX-GLOBAL-MAP-WORLD-001','app/assets/images/maps/phoenix-world-route-atlas-landscape-v1.webp','Map','Explore flight / Passport continent','design/sources/global-critical-v1/phoenix-world-route-atlas-landscape-v1.svg','cover in Explore; contain in Passport','_FlightMapFallback / passport gradient','Flutter route animation stops'],
  ['app/assets/images/maps/east-asia-flight-relief-v2.webp','PHX-GLOBAL-MAP-ASIA-001','app/assets/images/maps/phoenix-east-asia-route-atlas-landscape-v1.webp','Map','Explore destination flight / Passport Asia','design/sources/global-critical-v1/phoenix-east-asia-route-atlas-landscape-v1.svg','cover in Explore; contain in Passport','_FlightMapFallback / passport gradient','Flutter route animation stops'],
  ['app/assets/images/maps/china-passport-atlas-v2.webp','PHX-GLOBAL-MAP-CHINA-001','app/assets/images/maps/phoenix-china-passport-atlas-portrait-v1.webp','Map','Passport China','design/sources/global-critical-v1/phoenix-china-passport-atlas-portrait-v1.svg','contain; InteractiveViewer phone/tablet','passport-atlas-static-fallback','NOT_APPLICABLE'],
  ['app/assets/images/phoenix-time-earth-v2.webp','PHX-GLOBAL-SPLASH-001','app/assets/images/phoenix-launch-journey-cover-portrait-v1.webp','Splash','Web startup Splash','design/sources/global-critical-v1/phoenix-launch-journey-cover-portrait-v1.svg','CSS cover with safe-area layout','solid and gradient CSS startup background','prefers-reduced-motion disables cover animation'],
  ['app/assets/images/phoenix-flight-cycle-v4.webp','PHX-GLOBAL-DYNAMIC-001','app/assets/images/phoenix-launch-flight-sprite-landscape-v1.webp','Dynamic Layer','Web startup Dynamic Layer','design/sources/global-critical-v1/phoenix-launch-flight-sprite-landscape-v1.svg','three equal landscape frames','static first frame / hidden layer','prefers-reduced-motion disables sprite animation'],
  ['app/web/favicon.svg','PHX-GLOBAL-ICON-064-001','app/web/phoenix-app-mark-square-64-v1.svg','Icon','Web favicon','design/sources/global-critical-v1/phoenix-app-mark-square-64-v1.svg','SVG viewBox and 64 px intrinsic size','browser no-icon fallback','NOT_APPLICABLE'],
  ['app/web/icons/Icon-192.svg','PHX-GLOBAL-ICON-192-001','app/web/icons/phoenix-app-mark-square-192-v1.svg','Icon','Web manifest 192','design/sources/global-critical-v1/phoenix-app-mark-square-192-v1.svg','SVG viewBox and 192 px intrinsic size','manifest icon omission is non-blocking','NOT_APPLICABLE'],
  ['app/web/icons/Icon-512.svg','PHX-GLOBAL-ICON-512-001','app/web/icons/phoenix-app-mark-square-512-v1.svg','Icon','Web manifest 512','design/sources/global-critical-v1/phoenix-app-mark-square-512-v1.svg','SVG viewBox and 512 px intrinsic size','manifest icon omission is non-blocking','NOT_APPLICABLE'],
];

const parsed = parseCsv(await readFile(registerPath, 'utf8'));
const headers = parsed.shift();
for (const name of ['Source File','Editable Master','Responsive Variants','Static Fallback','Reduced Motion Behavior','Gate Result']) {
  if (!headers.includes(name)) headers.push(name);
}
const rows = parsed.filter((r) => r.length > 1).map((values) => Object.fromEntries(headers.map((h,i) => [h, values[i] ?? ''])));

for (const [oldPath,id,newPath,family,page,master,responsive,fallback,motion] of oldToNew) {
  const old = rows.find((r) => r['Repository Path'] === oldPath);
  if (!old) throw new Error(`Missing old register row: ${oldPath}`);
  Object.assign(old, {
    'Runtime Referenced':'NO','Deprecated':'YES','Unused':'YES','Rights Status':'RETIRED_REPLACED',
    'Missing Evidence':'NOT_APPLICABLE_RETIRED','Preview Eligibility':'NO_RETIRED','Release Eligibility':'NO_RETIRED',
    'Replacement Required':'NO','Gate Result':'RETIRED_AFTER_VERIFIED_REPLACEMENT',
    'Notes':`${old.Notes ? `${old.Notes} ` : ''}Replaced by ${id}; historical repository provenance retained.`,
  });
  const full = resolve(root,newPath), bytes = await readFile(full), info = await stat(full);
  const dimensions = newPath.endsWith('.svg')
    ? [
        bytes.toString('utf8').match(/\bwidth="(\d+)"/)?.[1],
        bytes.toString('utf8').match(/\bheight="(\d+)"/)?.[1],
      ]
    : execFileSync('identify',['-format','%w|%h',full],{encoding:'utf8'}).trim().split('|');
  if (!dimensions[0] || !dimensions[1]) throw new Error(`Missing dimensions: ${newPath}`);
  const blob = execFileSync('git',['hash-object',newPath],{cwd:root,encoding:'utf8'}).trim();
  const format = newPath.endsWith('.svg') ? 'SVG' : 'WEBP';
  const sourceFamily = `programmatic:global-critical-v1:${id.toLowerCase()}`;
  const record = Object.fromEntries(headers.map((h) => [h,'']));
  Object.assign(record, {
    'Asset ID':id,'Repository Path':newPath,'File Name':basename(newPath),'File Format':format,
    'File Size':String(info.size),'Pixel Width':dimensions[0],'Pixel Height':dimensions[1],
    'SHA-256':createHash('sha256').update(bytes).digest('hex'),'Git Blob SHA':blob,
    'Runtime Referenced':'YES','Runtime Page or Journey':page,'Asset Family':family,'Source Family':sourceFamily,
    'Duplicate Of':'NONE','Variant Relationship':'PRIMARY','Deprecated':'NO','Unused':'NO',
    'First Git Commit':'PHASE1_REMOTE_CHECKPOINT','First Commit Date':'2026-08-01','First Commit Author':'Phoenix Visual Architecture',
    'Current Git Commit':'PHASE1_REMOTE_CHECKPOINT','Existing Registry Entry':'NO',
    'Existing Evidence Location':'design/evidence/GLOBAL_CRITICAL_V1_EVIDENCE.md',
    'Creation Method':'PROGRAMMATIC_ORIGINAL_LOCAL_SVG','Source':'Phoenix local editable SVG master',
    'Creator':'Phoenix Visual Architecture under user-authorized controlled execution',
    'Tool or Platform':'Repository Node.js generator; Inkscape 1.2.2; ImageMagick 6.9.11-60',
    'Model':'NOT_APPLICABLE','Model Version':'NOT_APPLICABLE',
    'Prompt Evidence':'design/evidence/GLOBAL_CRITICAL_V1_EVIDENCE.md',
    'Input Asset Evidence':'NOT_APPLICABLE — no input assets','Commercial Account Evidence':'NOT_APPLICABLE',
    'Terms Evidence':'NOT_APPLICABLE — no external service or licensed input',
    'License':'Phoenix project-owned original','Attribution Requirement':'NOT_APPLICABLE',
    'Modification Rights':'ALLOWED_BY_PROJECT_OWNER','Redistribution Rights':'ALLOWED_BY_PROJECT_OWNER',
    'Likeness or Privacy Risk':'REVIEWED_NONE','Trademark Risk':'REVIEWED_NONE',
    'Reviewer':'Phoenix Visual Architecture','Review Date':'2026-08-01','Rights Status':'EVIDENCE_COMPLETE',
    'Missing Evidence':'NOT_APPLICABLE','Preview Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED',
    'Release Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED','Replacement Required':'NO',
    'Source File':master,'Editable Master':master,'Responsive Variants':responsive,
    'Static Fallback':fallback,'Reduced Motion Behavior':motion,'Gate Result':'LOCAL_14_GATES_PASSED_REMOTE_CI_PENDING',
    'Notes':'Original local primitive geometry; no external disclosure, service, dataset, icon library, trademark, likeness, or third-party input. Whole-library rights approval remains blocked.',
  });
  const existing = rows.findIndex((r) => r['Asset ID'] === id);
  if (existing >= 0) rows[existing] = record; else rows.push(record);
}

await writeFile(registerPath, `${headers.map(quote).join(',')}\n${rows.map((r) => headers.map((h) => quote(r[h])).join(',')).join('\n')}\n`);
console.log(`Updated ${oldToNew.length} replacements; register rows: ${rows.length}`);
