import test from 'node:test';import assert from 'node:assert/strict';import{readFileSync}from'node:fs';
const catalog=readFileSync(new URL('../app/lib/data/journey_expansion_batch_four.dart',import.meta.url),'utf8');
const pingyaoGold=readFileSync(new URL('../app/lib/data/pingyao_ancient_city_gold_content.dart',import.meta.url),'utf8');
const geo=readFileSync(new URL('../app/lib/data/world_geo_catalog.dart',import.meta.url),'utf8');
const backgrounds=readFileSync(new URL('../app/lib/data/journey_background_generated.dart',import.meta.url),'utf8');
const journeys=[['pingyao-ancient-city','平遥','平遥古城'],['qufu-confucius-sites','曲阜','孔庙'],['leshan-giant-buddha','乐山','乐山大佛'],['wuyishan-nine-bend-stream','武夷山','九曲溪'],['honghe-hani-rice-terraces','红河','哈尼梯田']];
test('five-journey expansion follows content passport and background contracts',()=>{for(const[id,city,place]of journeys){const source=id==='pingyao-ancient-city'?`${catalog}\n${pingyaoGold}`:catalog;assert.match(source,new RegExp(`'${id}'`));assert.match(catalog,new RegExp(`city:'${city}'|city: '${city}'`));assert.match(backgrounds,new RegExp(`journeyId:'${id}'|journeyId: '${id}'`));assert.match(geo,new RegExp(`name:'${place}'|name: '${place}'`));}});
test('batch-four journeys retain verified authority coverage',()=>{assert.equal((catalog.match(/StoryVerificationStatus\.verified/g)??[]).length,11);assert.equal((catalog.match(/StorySourceKind\.unesco/g)??[]).length,5);assert.equal((catalog.match(/StorySourceKind\.government/g)??[]).length,6);});
