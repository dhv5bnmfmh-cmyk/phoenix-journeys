import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const picker = readFileSync(
  'app/lib/widgets/journey_picker_sheet.dart',
  'utf8',
);

test('home flight runs once and remains at the selected destination', () => {
  assert.match(explore, /duration: const Duration\(seconds: 14\)/);
  assert.match(explore, /_controller\.forward\(\)/);
  assert.doesNotMatch(explore, /duration: const Duration\(seconds: 14\),\s*\)\.\.repeat\(\)/);
  assert.match(explore, /late String _animatedJourneyId/);
  assert.match(explore, /journeyId != _animatedJourneyId/);
  assert.match(explore, /\.\.value = 0\s*\.\.forward\(\)/);
});

test('camera, cruise and landing form one continuous arrival sequence', () => {
  assert.match(explore, /Interval\(0, \.38, curve: Curves\.easeInOutCubic\)/);
  assert.match(explore, /\.20,\s*\.78,\s*curve: Curves\.easeInOutCubic/);
  assert.match(explore, /\.78,\s*\.94,\s*curve: Curves\.easeInCubic/);
  assert.match(explore, /\.68,\s*1\.0,\s*curve: Curves\.easeInOutCubic/);
  assert.match(explore, /landingPoint\(landingT\)/);
  assert.match(explore, /active: state\.activeJourneyStampEarned \|\| landingT > \.35/);
});

test('premium aircraft replaces the low-resolution system icon', () => {
  assert.match(explore, /class _PremiumAircraftPainter extends CustomPainter/);
  assert.match(explore, /phoenix-premium-map-aircraft/);
  assert.match(explore, /size: const Size\(50, 56\)/);
  assert.match(explore, /angle: angle \+ math\.pi \/ 2/);
  assert.doesNotMatch(explore, /Icons\.flight_rounded/);
});

test('painted relief map uses per-city calibrated destinations', () => {
  const binding = readFileSync(
    'app/lib/services/journey_location_binding.dart',
    'utf8',
  );
  for (const location of [
    'beijing/forbidden-city',
    'beijing/summer-palace',
    'shanghai/bund',
    'xian/city-wall',
    'hangzhou/west-lake',
    'chengdu/kuanzhai-alley',
    'nanjing/qinhuai-river',
    'guangzhou/chen-clan-ancestral-hall',
  ]) {
    assert.match(binding, new RegExp(`'${location}'`));
  }
  assert.match(binding, /'hangzhou\/west-lake': JourneyMapPoint\(x: 0\.70, y: 0\.49\)/);
  assert.match(explore, /hanoi = Offset\(size\.width \* \.30, size\.height \* \.76\)/);
});

test('map flight respects reduced-motion accessibility', () => {
  assert.match(explore, /disableAnimations/);
  assert.match(explore, /queryParameters\['motion'\] == 'on'/);
  assert.match(explore, /if \(reduceMotion\)[\s\S]{0,100}_controller[\s\S]{0,80}\.\.value = 1/);
});

test('arrival reveals a direct destination-selection handoff', () => {
  assert.match(explore, /required this\.onArrived/);
  assert.match(explore, /final VoidCallback onArrived/);
  assert.match(explore, /\.92,\s*1\.0,\s*curve: Curves\.easeOutCubic/);
  assert.match(explore, /flight-arrival-destination-picker/);
  assert.match(explore, /onPressed: widget\.onArrived/);
  assert.match(explore, /选择景点/);
  assert.match(explore, /已抵达 · 选择景点继续/);
  assert.match(explore, /onArrived: \(\) => unawaited\(chooseArrivedCityDestination\(\)\)/);
});

test('arrival picker is locked to landmarks in the landed city', () => {
  assert.match(explore, /chooseArrivedCityDestination/);
  assert.match(explore, /initialCityId: state\.activeJourneyMetadata\.cityId/);
  assert.match(explore, /lockToInitialCity: true/);
  assert.match(explore, /onArrived: \(\) => unawaited\(chooseArrivedCityDestination\(\)\)/);

  assert.match(picker, /String\? initialCityId/);
  assert.match(picker, /bool lockToInitialCity = false/);
  assert.match(picker, /initialCityId \?\? state\.activeJourneyMetadata\.cityId/);
  assert.match(picker, /lockToInitialCity\s*\?\s*1\s*:\s*publishedJourneyStartupCityCatalog\.length/);
  assert.match(picker, /lockToInitialCity[\s\S]{0,120}\? selectedCity[\s\S]{0,160}: publishedJourneyStartupCityCatalog\[index\]/);
  assert.match(picker, /你已抵达\$\{selectedCity\.name\}，请选择本城景点/);
});
