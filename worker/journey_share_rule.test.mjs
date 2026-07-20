import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const pubspec = readFileSync('app/pubspec.yaml', 'utf8');
const button = readFileSync(
  'app/lib/widgets/journey_share_button.dart',
  'utf8',
);
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const passport = readFileSync('app/lib/screens/passport_screen.dart', 'utf8');

test('journey sharing uses the supported cross-platform plugin', () => {
  assert.match(pubspec, /share_plus: \^12\.0\.2/);
  assert.match(button, /SharePlus\.instance\.share/);
  assert.match(button, /ShareParams\(/);
});

test('iPad receives a non-empty share position origin', () => {
  assert.match(button, /sharePositionOrigin: _shareOrigin\(\)/);
  assert.match(button, /box\.localToGlobal\(Offset\.zero\) & box\.size/);
  assert.match(button, /Rect\.fromCenter/);
});

test('share copy points to the stable production experience', () => {
  assert.match(
    button,
    /https:\/\/phoenix-journeys-alpha\.7hn5tyrjgh\.workers\.dev\//,
  );
  assert.match(button, /String city = '北京'/);
  assert.match(button, /String place = '紫禁城'/);
  assert.match(button, /\$city·\$place/);
  assert.match(button, /城市印章/);
});

test('journey completion page offers sharing without replacing replay', () => {
  const start = journey.indexOf('Widget _completePage');
  const end = journey.indexOf('class _CompactTextBlock', start);
  const body = journey.slice(start, end);

  assert.match(body, /JourneyShareButton\(/);
  assert.match(body, /city: _experience\.city/);
  assert.match(body, /分享旅程/);
  assert.match(body, /_restartJourney/);
});

test('passport shares earned city stamps and protects locked journeys', () => {
  const start = passport.indexOf('class _CityStampCard');
  const body = passport.slice(start);

  assert.match(body, /earned\s*\?\s*Row\([\s\S]*JourneyShareButton\(/);
  assert.match(body, /city: journey\.city/);
  assert.match(body, /分享印章/);
  assert.match(body, /isToday \|\| active/);
  assert.match(body, /等待成为今日旅程/);
});
