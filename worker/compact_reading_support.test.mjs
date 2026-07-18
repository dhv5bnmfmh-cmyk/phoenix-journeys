import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('annotation sheet follows content and never occupies most of the screen', () => {
  assert.doesNotMatch(journey, /heightFactor:\s*\.72/);
  assert.match(journey, /MediaQuery\.sizeOf\(sheetContext\)\.height \* \.52/);
  assert.match(journey, /constraints: BoxConstraints\(maxHeight: maxHeight\)/);
  assert.match(journey, /class _ReadingSupportSheet[\s\S]*mainAxisSize: MainAxisSize\.min/);
});
