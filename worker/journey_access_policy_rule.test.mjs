import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const policy = readFileSync('app/lib/services/journey_access_policy.dart', 'utf8');
const workflow = readFileSync('docs/development-workflow.md', 'utf8');
const prTemplate = readFileSync('.github/pull_request_template.md', 'utf8');

test('development and paid explorers keep all journeys open', () => {
  assert.match(policy, /developmentExperience/);
  assert.match(policy, /productionPaidExplorer/);
  assert.match(policy, /allJourneyIds\.toSet\(\)/);
  assert.match(workflow, /å¼€å‘åˆ†æ”¯ã€PR ç‹¬ç«‹ä½“éªŒç‰ˆå’Œå†…éƒ¨éªŒæ”¶ç¯å¢ƒå¿…é¡»å¼€æ”¾å…¨éƒ¨å·²å‘å¸ƒæ—…ç¨‹/);
  assert.match(workflow, /ä»˜è´¹æ¢ç´¢è€…å¯ä»¥æ‰“å¼€å…¨éƒ¨å·²å‘å¸ƒæ—…ç¨‹/);
});

test('free explorers receive stable random morning and afternoon journeys', () => {
  assert.match(policy, /JourneyReleaseSlot \{ morning, afternoon \}/);
  assert.match(policy, /explorerSeed\|\$dateKey\|morning/);
  assert.match(policy, /explorerSeed\|\$dateKey|afternoon/);
  assert.match(policy, /if \(afternoonIndex == morningIndex\)/);
  assert.match(workflow, /ù¥êy."ºaâ¹¥/¹. 9«­{ï#9."ùcb9a£zaâ¹¥/¹. 9«­KÊNÂˆ\ÜÙ\›X]Ú
ÛÜšÙ›İËùb-ù¥¬8à zaãyd+ù¢%ºaãy¥¬9ænùoey.#yo¥úaãy¥¬9¢¯ycå‹ÊNÂˆ\ÜÙ\›X]Ú
ÛÜšÙ›İËùd#9. 9i*y¥êy."¹.#¹."ùcb9æ¡9¥áyê"ù.#yo¥úaãyi#KÊNÂŸJNÂ‚\İ
	Ú›İ\›™^HXØÙ\ÜÈ™[XZ[œÈÛÛ™šYİ\˜X›H[™Ù[˜[^™YÚ]İ]\XØ][™ÈˆÚXÚÛ\İÉË

HOˆÂˆ\ÜÙ\›X]Ú
ÛÜšÙ›İËùîçù. 9îãú/áÈ›İ\›™^PXØÙ\ÜÔÛXŞX9b)9¥«KÊNÂˆ\ÜÙ\›X]Ú
ÛÜšÙ›İËùamù/dù¥êy."¹d£9."ùcb9æ¡:d§ùà®xà y.íù¨/8à z+åyå*9§'øà zaãyi#yfçº`oùdj9§'ù.#¹/àúe 9¥®y¨b9oázhnù/çyåfy..¹cëúacyïk¹ea¹.&¹ëe¹åiKÊNÂˆ\ÜÙ\›X]Ú
•[\]KÔÚ[™ÛH[HÛÛ˜XİˆØÜ×ÔÑS’VÒ“ÕT“‘VWĞPĞÑTSÑWĞÓÓ•PÕ›YÊNÂˆ\ÜÙ\›X]Ú
•[\]KÑÈ›İÛÜHÛÚXÚÛ\İÈ[È\È‹ÊNÂˆ\ÜÙ\›X]Ú
•[\]KĞ[H[˜]]Üš^™YX\›™\‹]š\ÚX›H[H›ØÚÜÈ™XYH[™Y\™ÙKÊNÂŸJNÂ