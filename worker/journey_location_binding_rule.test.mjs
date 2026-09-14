import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);
const policy = readFileSync(
  'app/lib/services/journey_background_policy.dart',
  'utf8',
);
const location = readFileSync(
  'app/lib/services/journey_location_binding.dart',
  'utf8',
);

test('map, records and backgrounds share one Journey location binding', () => {
  assert.match(location, /storageNamespace => 'journey\.\$locationPath'/);
  assert.match(location, /generatedBackgroundDirectory/);
  assert.match(location, /placeNode\.latitude/);
  assert.match(location, /placeNode\.longitude/);
  assert.match(state, /activeJourneyLocation/);
  assert.match(state, /binding\.storageNamespace/);
  assert.match(state, /binding\.legacyStorageNamespace/);
  assert.match(explore, /destination\.mapPoint/);
  assert.match(explore, /final Offset destination/);
  assert.doesNotMatch(explore, /final Offset beijing/);
  assert.match(background, /locationPath: location\.locationPath/);
  assert.match(policy, /_matchesLocation\(asset, locationPath\)/);
});
