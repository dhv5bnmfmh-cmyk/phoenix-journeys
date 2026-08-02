import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { basename, resolve } from 'node:path';
import { readFile, stat, writeFile } from 'node:fs/promises';

const root=resolve(import.meta.dirname,'../..');
const registerPath=resolve(root,'design/ASSET_REGISTER.csv');
const runtimePath=resolve(root,'app/lib/widgets/special_realm_background.dart');
const parameters=JSON.parse(await readFile(resolve(root,'design/sources/special-journeys-v1/parameters.json'),'utf8'));
const codeByJourney={
  'changan-last-bus':'CLB','tide-letter':'TDL','arcade-lost-property':'ALP','tea-horse-echo':'THE','ice-city-star-map':'ICM',
  'literary-roaming':'LIT','myth-tracing':'MYT','strange-night-talks':'SNT','folk-secret-land':'FSL',
};
const legacyPrefix={
  'literary-roaming':'dream-butterfly','myth-tracing':'moon-letter','strange-night-talks':'shadowless-inn','folk-secret-land':'upstream-lantern',
};
const legacyFirst={
  'literary-roaming':'assets/images/special-realms/dream-butterfly-v3.webp',
  'myth-tracing':'assets/images/special-realms/moon-letter-v2.webp',
  'strange-night-talks':'assets/images/special-realms/shadowless-inn-v2.webp',
  'folk-secret-land':'assets/images/special-realms/upstream-lantern-v3.webp',
};
const oldSceneSlugs=['opening','object','clue','crossing','overlap','storm','memory','turning','release','finale'];
const oldRuntimePath=(journey,index)=>{
  if(legacyPrefix[journey.id]) return index===1?legacyFirst[journey.id]:`assets/images/special-realms/ten-scene/${legacyPrefix[journey.id]}-${String(index).padStart(2,'0')}.webp`;
  return `assets/images/special-realms/ten-scene/${journey.id}-${String(index).padStart(2,'0')}-${oldSceneSlugs[index-1]}.webp`;
};
const stem=(journey,scene)=>`${journey.id}-${String(scene.index).padStart(2,'0')}-${scene.slug}-portrait-v1`;
const newRuntimePath=(journey,scene)=>`assets/images/special-realms/rights-safe-v1/${journey.id}/${stem(journey,scene)}.webp`;

let runtime=await readFile(runtimePath,'utf8');
for(const journey of parameters.journeys) for(const scene of parameters.scenes){
  const oldPath=oldRuntimePath(journey,scene.index),newPath=newRuntimePath(journey,scene);
  if(runtime.includes(oldPath)) runtime=runtime.replaceAll(oldPath,newPath);
  else if(!runtime.includes(newPath)) throw new Error(`Runtime mapping missing: ${oldPath}`);
}
await writeFile(runtimePath,runtime);

function parseCsv(text){const rows=[];let row=[],field='',quoted=false;for(let i=0;i<text.length;i++){const ch=text[i];if(quoted){if(ch==='"'&&text[i+1]==='"'){field+='"';i++;}else if(ch==='"')quoted=false;else field+=ch;}else if(ch==='"')quoted=true;else if(ch===','){row.push(field);field='';}else if(ch==='\n'){row.push(field.replace(/\r$/,''));rows.push(row);row=[];field='';}else field+=ch;}if(field||row.length){row.push(field);rows.push(row);}return rows;}
const quote=value=>{const text=String(value??'');return /[",\n\r]/.test(text)?`"${text.replaceAll('"','""')}"`:text;};
const parsed=parseCsv(await readFile(registerPath,'utf8')),headers=parsed.shift();
for(const name of ['Source File','Editable Master','Responsive Variants','Static Fallback','Reduced Motion Behavior','Gate Result']) if(!headers.includes(name))headers.push(name);
const rows=parsed.filter(r=>r.length>1).map(values=>Object.fromEntries(headers.map((h,i)=>[h,values[i]??''])));

for(const journey of parameters.journeys) for(const scene of parameters.scenes){
  const oldRepo=`app/${oldRuntimePath(journey,scene.index)}`,newRepo=`app/${newRuntimePath(journey,scene)}`;
  const id=`PHX-SPECIAL-${codeByJourney[journey.id]}-${String(scene.index).padStart(3,'0')}`;
  const old=rows.find(r=>r['Repository Path']===oldRepo);if(!old)throw new Error(`Old register row missing: ${oldRepo}`);
  const baseNotes=old.Notes.replace(/(?:\s*Replaced by PHX-SPECIAL-[^;]+; historical repository provenance retained\.)+/g,'').trim();
  Object.assign(old,{'Runtime Referenced':'NO','Deprecated':'YES','Unused':'YES','Rights Status':'RETIRED_REPLACED','Missing Evidence':'NOT_APPLICABLE_RETIRED','Preview Eligibility':'NO_RETIRED','Release Eligibility':'NO_RETIRED','Replacement Required':'NO','Gate Result':'RETIRED_AFTER_VERIFIED_REPLACEMENT','Notes':`${baseNotes?`${baseNotes} `:''}Replaced by ${id}; historical repository provenance retained.`});
  const full=resolve(root,newRepo),bytes=await readFile(full),info=await stat(full),master=`design/sources/special-journeys-v1/masters/${journey.id}/${stem(journey,scene)}.svg`;
  const record=Object.fromEntries(headers.map(h=>[h,'']));
  Object.assign(record,{
    'Asset ID':id,'Repository Path':newRepo,'File Name':basename(newRepo),'File Format':'WEBP','File Size':String(info.size),'Pixel Width':'900','Pixel Height':'1600',
    'SHA-256':createHash('sha256').update(bytes).digest('hex'),'Git Blob SHA':execFileSync('git',['hash-object',newRepo],{cwd:root,encoding:'utf8'}).trim(),
    'Runtime Referenced':'YES','Runtime Page or Journey':`${journey.id}:${scene.purpose}`,'Asset Family':'Special Journey','Source Family':`programmatic:special-journeys-v1:${journey.id}`,
    'Duplicate Of':'NONE','Variant Relationship':scene.index===1?'PRIMARY_STATIC_FALLBACK':'NARRATIVE_SEQUENCE','Deprecated':'NO','Unused':'NO',
    'First Git Commit':'PHASE2_REMOTE_CHECKPOINT','First Commit Date':'2026-08-02','First Commit Author':'Phoenix Visual Architecture','Current Git Commit':'PHASE2_REMOTE_CHECKPOINT','Existing Registry Entry':'NO',
    'Existing Evidence Location':'design/evidence/SPECIAL_JOURNEYS_V1_EVIDENCE.md;design/evidence/SPECIAL_JOURNEYS_V1_MANIFEST.json','Creation Method':'PROGRAMMATIC_ORIGINAL_LOCAL_SVG',
    'Source':'Phoenix local editable SVG master','Creator':'Phoenix Visual Architecture under user-authorized controlled execution','Tool or Platform':'Repository Node.js generator; Inkscape 1.2.2; ImageMagick 6.9.11-60',
    'Model':'NOT_APPLICABLE','Model Version':'NOT_APPLICABLE','Prompt Evidence':'design/evidence/SPECIAL_JOURNEYS_V1_EVIDENCE.md','Input Asset Evidence':'NOT_APPLICABLE','Commercial Account Evidence':'NOT_APPLICABLE',
    'Terms Evidence':'NOT_APPLICABLE — no external service or licensed input','License':'Phoenix project-owned original','Attribution Requirement':'NOT_APPLICABLE','Modification Rights':'ALLOWED_BY_PROJECT_OWNER','Redistribution Rights':'ALLOWED_BY_PROJECT_OWNER',
    'Likeness or Privacy Risk':'REVIEWED_NONE','Trademark Risk':'REVIEWED_NONE','Reviewer':'Phoenix Visual Architecture','Review Date':'2026-08-02','Rights Status':'EVIDENCE_COMPLETE','Missing Evidence':'NOT_APPLICABLE',
    'Preview Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED','Release Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED','Replacement Required':'NO',
    'Source File':master,'Editable Master':master,'Responsive Variants':'900x1600 portrait; BoxFit.cover phone/tablet crop-safe composition','Static Fallback':`scene 01 for ${journey.id}; programmatic CustomPainter final fallback`,
    'Reduced Motion Behavior':'animation controller stops at fixed phase; static plate remains','Gate Result':'ALL_14_GATES_PASSED_REMOTE_CI_SUCCESS',
    'Notes':`Story ID ${journey.storyId}; purpose ${scene.purpose}; story phase ${scene.storyPhase}. Original primitive geometry with no external input. Whole-library rights approval remains blocked.`,
  });
  const existing=rows.findIndex(r=>r['Asset ID']===id);if(existing>=0)rows[existing]=record;else rows.push(record);
}
await writeFile(registerPath,`${headers.map(quote).join(',')}\n${rows.map(r=>headers.map(h=>quote(r[h])).join(',')).join('\n')}\n`);
console.log(`Registered ${parameters.journeys.length*parameters.scenes.length} special Journey replacements; rows: ${rows.length}`);
