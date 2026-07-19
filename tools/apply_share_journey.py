from pathlib import Path

JOURNEY = Path('app/lib/screens/journey_screen.dart')
PASSPORT = Path('app/lib/screens/passport_screen.dart')
RULE = Path('worker/journey_share_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing replacement target: {label}')
    return text.replace(old, new, 1)


journey = JOURNEY.read_text(encoding='utf-8')
if "JourneyShareButton(" not in journey:
    journey = replace_once(
        journey,
        "import '../widgets/interactive_story_text.dart';\n",
        "import '../widgets/interactive_story_text.dart';\n"
        "import '../widgets/journey_share_button.dart';\n",
        'journey share import',
    )
    journey = replace_once(
        journey,
        "          SizedBox(\n"
        "            height: 34,\n"
        "            child: OutlinedButton.icon(\n"
        "              onPressed: () => unawaited(_restartJourney()),\n"
        "              style: OutlinedButton.styleFrom(\n"
        "                visualDensity: VisualDensity.compact,\n"
        "              ),\n"
        "              icon: const Icon(Icons.replay_rounded, size: 16),\n"
        "              label: const Text(\n"
        "                '重新体验北京 Journey',\n"
        "                style: TextStyle(fontSize: 10.5),\n"
        "              ),\n"
        "            ),\n"
        "          ),\n",
        "          SizedBox(\n"
        "            height: 36,\n"
        "            child: Row(\n"
        "              children: [\n"
        "                Expanded(\n"
        "                  child: JourneyShareButton(\n"
        "                    isTraditional: _appState.isTraditional,\n"
        "                    compact: true,\n"
        "                    label: _appState.displayText('分享旅程'),\n"
        "                  ),\n"
        "                ),\n"
        "                const SizedBox(width: 6),\n"
        "                Expanded(\n"
        "                  child: OutlinedButton.icon(\n"
        "                    onPressed: () => unawaited(_restartJourney()),\n"
        "                    style: OutlinedButton.styleFrom(\n"
        "                      visualDensity: VisualDensity.compact,\n"
        "                      padding: const EdgeInsets.symmetric(horizontal: 8),\n"
        "                    ),\n"
        "                    icon: const Icon(Icons.replay_rounded, size: 16),\n"
        "                    label: const Text(\n"
        "                      '重新体验',\n"
        "                      maxLines: 1,\n"
        "                      overflow: TextOverflow.ellipsis,\n"
        "                      style: TextStyle(fontSize: 10.5),\n"
        "                    ),\n"
        "                  ),\n"
        "                ),\n"
        "              ],\n"
        "            ),\n"
        "          ),\n",
        'journey completion actions',
    )
    JOURNEY.write_text(journey, encoding='utf-8')

passport = PASSPORT.read_text(encoding='utf-8')
if "JourneyShareButton(" not in passport:
    passport = replace_once(
        passport,
        "import '../widgets/forbidden_city_stamp.dart';\n",
        "import '../widgets/forbidden_city_stamp.dart';\n"
        "import '../widgets/journey_share_button.dart';\n",
        'passport share import',
    )
    passport = replace_once(
        passport,
        "                if (!earned) ...[\n",
        "                if (earned) ...[\n"
        "                  const Spacer(),\n"
        "                  SizedBox(\n"
        "                    width: double.infinity,\n"
        "                    height: 36,\n"
        "                    child: JourneyShareButton(\n"
        "                      isTraditional: state.isTraditional,\n"
        "                      compact: true,\n"
        "                      label: state.displayText('分享北京印章'),\n"
        "                    ),\n"
        "                  ),\n"
        "                ],\n"
        "                if (!earned) ...[\n",
        'passport earned share action',
    )
    PASSPORT.write_text(passport, encoding='utf-8')

RULE.write_text(
    """import test from 'node:test';
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
  assert.match(button, /北京·紫禁城/);
  assert.match(button, /城市印章/);
});

test('journey completion page offers sharing without replacing replay', () => {
  const start = journey.indexOf('Widget _completePage');
  const end = journey.indexOf('class _CompactTextBlock', start);
  const body = journey.slice(start, end);

  assert.match(body, /JourneyShareButton\(/);
  assert.match(body, /分享旅程/);
  assert.match(body, /_restartJourney/);
});

test('passport shows sharing only after the Beijing stamp is earned', () => {
  const start = passport.indexOf('class _BeijingStampCard');
  const end = passport.indexOf('class _PassportGridPainter', start);
  const body = passport.slice(start, end);

  assert.match(body, /if \(earned\) \.\.\.[\s\S]*JourneyShareButton\(/);
  assert.match(body, /分享北京印章/);
  assert.match(body, /if \(!earned\) \.\.\.[\s\S]*开始北京 Journey/);
});
""",
    encoding='utf-8',
)
