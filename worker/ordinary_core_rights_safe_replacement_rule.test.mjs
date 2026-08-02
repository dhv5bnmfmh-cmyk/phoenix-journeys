import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
import {existsSync,readFileSync,readdirSync,statSync} from 'node:fs';
import test from 'node:test';
import {resolve} from 'node:path';

const root=resolve(import.meta.dirname,'..');
const parameters=JSON.parse(readFileSync(resolve(root,'design/sources/ordinary-core-v1/parameters.json'),'utf8'));
const manifest=JSON.parse(readFileSync(resolve(root,'design/evidence/ORDINARY_CORE_V1_MANIFEST.json'),'utf8'));
const runtime=readFileSync(resolve(root,'app/lib/data/journey_background_generated.dart'),'utf8');
const policy=readFileSync(resolve(root,'app/lib/services/journey_background_policy.dart'),'utf8');
const pubspec=readFileSync(resolve(root,'app/pubspec.yaml'),'utf8');
const evidence=readFileSync(resolve(root,'design/evidence/ORDINARY_CORE_V1_EVIDENCE.md'),'utf8');

test('Phase 3A contains exactly 27 independently directed ordinary Journey entries',()=>{
  assert.equal(parameters.journeys.length,27);assert.equal(new Set(parameters.journeys.map(j=>j.id)).size,27);
  assert.equal(new Set(parameters.journeys.map(j=>j.motif)).size,27);
  assert.equal(new Set(parameters.journeys.map(j=>j.anchor)).size,27);
  assert.equal(manifest.assets.length,27);
});

test('every Phase 3A master and release is safe, registered and runtime reachable',()=>{
  const hashes=new Set();
  for(const asset of manifest.assets){
    const release=resolve(root,`app/${asset.newPath}`),master=resolve(root,asset.editableMaster);
    assert.ok(existsSync(release),asset.newPath);assert.ok(existsSync(master),asset.editableMaster);
    assert.ok(statSync(release).size>5000,`${asset.newPath} too small`);
    const svg=readFileSync(master,'utf8');assert.match(svg,/xmlns="http:\/\/www\.w3\.org\/2000\/svg"/);
    assert.doesNotMatch(svg,/<script|<image|\s(?:href|xlink:href)=/i);
    assert.match(runtime,new RegExp(asset.newPath.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')));
    assert.doesNotMatch(runtime,new RegExp(asset.oldPath.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')));
    assert.match(pubspec,new RegExp(`rights-safe-core-v1/${asset.journeyId}/`));
    hashes.add(createHash('sha256').update(readFileSync(release)).digest('hex'));
  }
  assert.equal(hashes.size,27,'release files must not be byte duplicates');
});

test('programmatic entry assets are limited to entry surfaces and selected first',()=>{
  assert.equal((runtime.match(/origin: JourneyBackgroundOrigin\.programmaticOriginal/g)??[]).length,27);
  assert.equal((runtime.match(/JourneyBackgroundPage\.explore/g)??[]).length,27);
  assert.equal((runtime.match(/JourneyBackgroundPage\.passport/g)??[]).length,27);
  assert.equal((runtime.match(/JourneyBackgroundPage\.profile/g)??[]).length,27);
  assert.match(policy,/programmaticOriginal\.isNotEmpty/);
  assert.match(policy,/rights-safe-core-v1/);
});

test('Phase 3A preserves fallback, reduced motion and disclosure boundaries',()=>{
  assert.match(evidence,/External Visual Service Used: `NONE`/);
  assert.match(evidence,/Repository Content Sent to Third Parties: `NO`/);
  const widget=readFileSync(resolve(root,'app/lib/widgets/destination_background.dart'),'utf8');
  assert.match(widget,/errorBuilder:/);assert.match(widget,/_BackgroundFallback/);assert.match(widget,/_destinationReduceMotion/);assert.match(widget,/\.dispose\(\)/);
});
