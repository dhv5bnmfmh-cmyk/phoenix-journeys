import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const theme = readFileSync('app/lib/theme/phoenix_theme.dart', 'utf8');
const workflow = readFileSync('docs/development-workflow.md', 'utf8');

test('Think, Express and Journey Memory share one high-contrast surface', () => {
  for (const page of ['_wonderPage', '_expressPage', '_memoryPage']) {
    const start = screen.indexOf(`Widget ${page}`);
    const end = screen.indexOf('Widget _', start + 8);
    const body = screen.slice(start, end);

    assert.match(body, /_JourneyWritingSurface\(/);
    assert.match(body, /PhoenixTheme\.journeyWritingQuestionStyle/);
    assert.match(body, /style: PhoenixTheme\.journeyWritingInputStyle/);
    assert.match(
      body,
      /decoration: PhoenixTheme\.journeyWritingInputDecoration\(/,
    );
  }
});

test('writing colors never depend on destination images or inherited defaults', () => {
  assert.match(theme, /static const writingInk = Colors\.white/);
  assert.match(theme, /static const writingSurface = Color\(0x38000000\)/);
  assert.match(theme, /journeyWritingQuestionStyle = TextStyle\([\s\S]*color: writingInk/);
  assert.match(theme, /journeyWritingInputStyle = TextStyle\([\s\S]*color: writingInk/);
  assert.match(theme, /journeyWritingHintStyle = TextStyle\([\s\S]*color: writingSecondary/);
  assert.match(theme, /journeyWritingPanelDecoration[\s\S]*color: writingSurface/);
  assert.match(theme, /fillColor: const Color\(0x24000000\)/);
  assert.match(
    workflow,
    /思考、表达和旅程回忆必须共用透明玻璃书写面板并保留背景图可见/,
  );
});
