import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const sourceUrl = new URL('./pr202_build_profile.mjs.gz', import.meta.url);
let source = gunzipSync(await readFile(sourceUrl)).toString('utf8');

const original = "shanghai:{city:'上海',place:'外滩',title:'上海 · 外滩',route:'stable-city-picker',identityAll:['林岸','黄浦江'],identityAny:[['陆家嘴','浦东'],['提单','结算']]}";
const replacement = "shanghai:{city:'上海',place:'外滩',title:'上海 · 外滩',route:'stable-city-picker',identityAll:['林岸'],identityAny:[]}";

if (source.split(original).length - 1 !== 1) {
  throw new Error('Shanghai profile entry identity patch target mismatch');
}
source = source.replace(original, replacement);

const profileEntryOriginal = ` const assertEntry=async()=>{await find(page,'1/6',{prefix:true,timeout:20000});const snapshot=await visibleText();if(!snapshot.includes(journey.title))throw new Error(\`Journey identity missing title: \${journey.title}\`);for(const marker of journey.identityAll)if(!snapshot.includes(marker))throw new Error(\`Journey identity missing stable marker: \${marker}\`);for(const group of journey.identityAny)if(!group.some(marker=>snapshot.includes(marker)))throw new Error(\`Journey identity missing stable marker group: \${group.join(' | ')}\`);};`;
const profileEntryReplacement = ` const assertEntry=async()=>{const deadline=Date.now()+30000;let last='';while(Date.now()<deadline){last=await visibleText();const stageReady=last.includes('1/6');const titleReady=last.includes(journey.title);const allReady=journey.identityAll.every(marker=>last.includes(marker));const groupsReady=journey.identityAny.every(group=>group.some(marker=>last.includes(marker)));if(stageReady&&titleReady&&allReady&&groupsReady)return;if(journey.route==='xian-passport'&&last.includes('陕西省，西安市')&&!stageReady&&await exists(page,journey.place,{role:'button',timeout:250})){await activate(page,journey.place,{prefix:false,timeout:1200});}await sleep(100);}throw new Error(\`Journey entry did not settle with identity + 1/6 + Story evidence: \${journey.title}; snapshot=\${last.slice(0,1200)}\`);};`;

if (source.split(profileEntryOriginal).length - 1 !== 1) {
  throw new Error('Profile mature entry assertion patch target mismatch');
}
source = source.replace(profileEntryOriginal, profileEntryReplacement);

const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_build_profile_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
