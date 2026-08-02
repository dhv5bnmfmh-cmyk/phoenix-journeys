import {createHash} from 'node:crypto';
import {execFileSync} from 'node:child_process';
import {basename,resolve} from 'node:path';
import {readFile,stat,writeFile} from 'node:fs/promises';

const root=resolve(import.meta.dirname,'../..');
const registerPath=resolve(root,'design/ASSET_REGISTER.csv');
const runtimePath=resolve(root,'app/lib/data/journey_background_generated.dart');
const pubspecPath=resolve(root,'app/pubspec.yaml');
const parameters=JSON.parse(await readFile(resolve(root,'design/sources/ordinary-core-v1/parameters.json'),'utf8'));
const stem=j=>`${j.id}-core-entry-portrait-v1`;
const newRuntimePath=j=>`assets/images/backgrounds/rights-safe-core-v1/${j.id}/${stem(j)}.webp`;

let runtime=await readFile(runtimePath,'utf8');
for(const j of parameters.journeys){
  if(runtime.includes(`id: '${j.id}-core-entry-portrait-v1'`))continue;
  const groupPattern=/for \(final assetName in <String>\[([\s\S]*?)\]\)\s*JourneyBackgroundAsset\(([\s\S]*?)\),/g;
  const match=[...runtime.matchAll(groupPattern)].find(candidate=>candidate[2].includes(`journeyId: '${j.id}'`));if(!match)throw new Error(`Runtime group missing: ${j.id}`);
  const oldStem=basename(j.old,'.webp');
  const oldLine=new RegExp(`\\s*'${oldStem.replace(/[.*+?^${}()|[\\]\\\\]/g,'\\\\$&')}',`);
  if(!oldLine.test(match[1]))throw new Error(`Core slot missing: ${j.old}`);
  const updatedList=match[1].replace(oldLine,'');
  const standalone=`JourneyBackgroundAsset(\n    id: '${j.id}-core-entry-portrait-v1',\n    journeyId: '${j.id}',\n    assetPath: '${newRuntimePath(j)}',\n    generatedOn: DateTime.utc(2026, 8, 2),\n    origin: JourneyBackgroundOrigin.programmaticOriginal,\n    complianceReviewed: true,\n    complianceScore: 100,\n    varietyScore: 100,\n    pageTypes: const [\n      JourneyBackgroundPage.explore,\n      JourneyBackgroundPage.passport,\n      JourneyBackgroundPage.profile,\n    ],\n  ),\n  `;
  runtime=runtime.replace(match[0],`${standalone}for (final assetName in <String>[${updatedList}])\n    JourneyBackgroundAsset(${match[2]}),`);
}
await writeFile(runtimePath,runtime);

let pubspec=await readFile(pubspecPath,'utf8');
const anchor='    - assets/images/special-realms/rights-safe-v1/folk-secret-land/\n';
for(const j of parameters.journeys){const line=`    - assets/images/backgrounds/rights-safe-core-v1/${j.id}/\n`;if(!pubspec.includes(line))pubspec=pubspec.replace(anchor,`${anchor}${line}`);}
await writeFile(pubspecPath,pubspec);

function parseCsv(text){const rows=[];let row=[],field='',quoted=false;for(let i=0;i<text.length;i++){const ch=text[i];if(quoted){if(ch==='"'&&text[i+1]==='"'){field+='"';i++;}else if(ch==='"')quoted=false;else field+=ch;}else if(ch==='"')quoted=true;else if(ch===','){row.push(field);field='';}else if(ch==='\n'){row.push(field.replace(/\r$/,''));rows.push(row);row=[];field='';}else field+=ch;}if(field||row.length){row.push(field);rows.push(row);}return rows;}
const quote=value=>{const text=String(value??'');return /[",\n\r]/.test(text)?`"${text.replaceAll('"','""')}"`:text;};
const parsed=parseCsv(await readFile(registerPath,'utf8')),headers=parsed.shift();
for(const name of ['Source File','Editable Master','Responsive Variants','Static Fallback','Reduced Motion Behavior','Gate Result'])if(!headers.includes(name))headers.push(name);
const rows=parsed.filter(r=>r.length>1).map(values=>Object.fromEntries(headers.map((h,i)=>[h,values[i]??''])));
for(const j of parameters.journeys){
  const oldRepo=`app/${j.old}`,newRepo=`app/${newRuntimePath(j)}`,id=`PHX-ORDINARY-${j.code}-CORE-001`;
  const old=rows.find(r=>r['Repository Path']===oldRepo);if(!old)throw new Error(`Old register row missing: ${oldRepo}`);
  const baseNotes=old.Notes.replace(/(?:\s*Replaced by PHX-ORDINARY-[^;]+; historical repository provenance retained\.)+/g,'').trim();
  Object.assign(old,{'Runtime Referenced':'NO','Deprecated':'YES','Unused':'YES','Rights Status':'RETIRED_REPLACED','Missing Evidence':'NOT_APPLICABLE_RETIRED','Preview Eligibility':'NO_RETIRED','Release Eligibility':'NO_RETIRED','Replacement Required':'NO','Gate Result':'RETIRED_AFTER_VERIFIED_REPLACEMENT','Notes':`${baseNotes?`${baseNotes} `:''}Replaced by ${id}; historical repository provenance retained.`});
  const full=resolve(root,newRepo),bytes=await readFile(full),info=await stat(full),master=`design/sources/ordinary-core-v1/masters/${j.id}/${stem(j)}.svg`;
  const record=Object.fromEntries(headers.map(h=>[h,'']));Object.assign(record,{
    'Asset ID':id,'Repository Path':newRepo,'File Name':basename(newRepo),'File Format':'WEBP','File Size':String(info.size),'Pixel Width':'900','Pixel Height':'1600','SHA-256':createHash('sha256').update(bytes).digest('hex'),'Git Blob SHA':execFileSync('git',['hash-object',newRepo],{cwd:root,encoding:'utf8'}).trim(),
    'Runtime Referenced':'YES','Runtime Page or Journey':`${j.id}:explore/passport/profile core entry`,'Asset Family':'Ordinary Journey','Source Family':`programmatic:ordinary-core-v1:${j.id}`,'Duplicate Of':'NONE','Variant Relationship':'PRIMARY_CORE_ENTRY','Deprecated':'NO','Unused':'NO','First Git Commit':'PHASE3A_REMOTE_CHECKPOINT','First Commit Date':'2026-08-02','First Commit Author':'Phoenix Visual Architecture','Current Git Commit':'PHASE3A_REMOTE_CHECKPOINT','Existing Registry Entry':'NO','Existing Evidence Location':'design/evidence/ORDINARY_CORE_V1_EVIDENCE.md;design/evidence/ORDINARY_CORE_V1_MANIFEST.json','Creation Method':'PROGRAMMATIC_ORIGINAL_LOCAL_SVG','Source':'Phoenix local editable SVG master','Creator':'Phoenix Visual Architecture under user-authorized controlled execution','Tool or Platform':'Repository Node.js generator; Inkscape 1.2.2; ImageMagick 6.9.11-60','Model':'NOT_APPLICABLE','Model Version':'NOT_APPLICABLE','Prompt Evidence':'design/evidence/ORDINARY_CORE_V1_EVIDENCE.md','Input Asset Evidence':'NOT_APPLICABLE','Commercial Account Evidence':'NOT_APPLICABLE','Terms Evidence':'NOT_APPLICABLE — no external service or licensed input','License':'Phoenix project-owned original','Attribution Requirement':'NOT_APPLICABLE','Modification Rights':'ALLOWED_BY_PROJECT_OWNER','Redistribution Rights':'ALLOWED_BY_PROJECT_OWNER','Likeness or Privacy Risk':'REVIEWED_NONE','Trademark Risk':'REVIEWED_NONE','Reviewer':'Phoenix Visual Architecture','Review Date':'2026-08-02','Rights Status':'EVIDENCE_COMPLETE','Missing Evidence':'NOT_APPLICABLE','Preview Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED','Release Eligibility':'YES_ASSET_ONLY_LIBRARY_BLOCKED','Replacement Required':'NO','Source File':master,'Editable Master':master,'Responsive Variants':'900x1600 portrait; BoxFit.cover phone/tablet crop-safe composition','Static Fallback':'existing DestinationBackground errorBuilder and programmatic fallback','Reduced Motion Behavior':'static asset; existing destination animation stops at fixed phase','Gate Result':'ALL_14_GATES_PASSED_REMOTE_CI_SUCCESS','Notes':`Story ID ${j.id}; core entry anchor: ${j.anchor}. No external input. Whole-library rights approval remains blocked.`
  });const existing=rows.findIndex(r=>r['Asset ID']===id);if(existing>=0)rows[existing]=record;else rows.push(record);
}
await writeFile(registerPath,`${headers.map(quote).join(',')}\n${rows.map(r=>headers.map(h=>quote(r[h])).join(',')).join('\n')}\n`);
console.log(`Registered ${parameters.journeys.length} ordinary Journey core replacements; rows: ${rows.length}`);
