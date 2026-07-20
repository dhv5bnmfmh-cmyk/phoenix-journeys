from pathlib import Path
import re


def read(path: str) -> str:
    return Path(path).read_text(encoding='utf-8')


def write(path: str, text: str) -> None:
    Path(path).write_text(text, encoding='utf-8')


def replace_once(path: str, old: str, new: str) -> None:
    text = read(path)
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{path}: expected one match, found {count}: {old[:100]!r}')
    write(path, text.replace(old, new, 1))


controller_path = 'app/lib/services/narration_controller.dart'
controller = read(controller_path)

controller = controller.replace(
    "    _bindHandlers();\n  }\n\n  static const double nativeDefaultRate = 1.0;",
    "    _speechRate = _sharedSpeechRate;\n"
    "    _instances.add(this);\n"
    "    _bindHandlers();\n"
    "  }\n\n"
    "  static const double nativeDefaultRate = 1.0;\n"
    "  static double _sharedSpeechRate = nativeDefaultRate;\n"
    "  static final Set<NarrationController> _instances =\n"
    "      <NarrationController>{};",
    1,
)

controller, count = re.subn(
    r"  static const speedOptions = <NarrationSpeedOption>\[\n(?:    NarrationSpeedOption.*\n)+  \];",
    "  static const speedOptions = <NarrationSpeedOption>[\n"
    "    NarrationSpeedOption(label: '0.5×', rate: .5),\n"
    "    NarrationSpeedOption(label: '0.75×', rate: .75),\n"
    "    NarrationSpeedOption(label: '1.0×', rate: 1.0),\n"
    "    NarrationSpeedOption(label: '1.25×', rate: 1.25),\n"
    "    NarrationSpeedOption(label: '1.5×', rate: 1.5),\n"
    "  ];",
    controller,
    count=1,
)
if count != 1:
    raise RuntimeError('NarrationController speedOptions block not found')

controller = controller.replace(
    "  double get speechRate => _speechRate;\n",
    "  double get speechRate => _speechRate;\n"
    "  int get _speechRateIndex {\n"
    "    final index = speedOptions.indexWhere(\n"
    "      (option) => (option.rate - _speechRate).abs() < .001,\n"
    "    );\n"
    "    return index < 0 ? 0 : index;\n"
    "  }\n"
    "\n"
    "  double? get slowerSpeechRate {\n"
    "    final index = _speechRateIndex;\n"
    "    return index <= 0 ? null : speedOptions[index - 1].rate;\n"
    "  }\n"
    "\n"
    "  double? get fasterSpeechRate {\n"
    "    final index = _speechRateIndex;\n"
    "    return index >= speedOptions.length - 1\n"
    "        ? null\n"
    "        : speedOptions[index + 1].rate;\n"
    "  }\n"
    "\n"
    "  bool get canDecreaseSpeechRate => slowerSpeechRate != null;\n"
    "  bool get canIncreaseSpeechRate => fasterSpeechRate != null;\n"
    "\n"
    "  Future<void> decreaseSpeechRate() async {\n"
    "    final rate = slowerSpeechRate;\n"
    "    if (rate != null) await setSpeechRate(rate);\n"
    "  }\n"
    "\n"
    "  Future<void> increaseSpeechRate() async {\n"
    "    final rate = fasterSpeechRate;\n"
    "    if (rate != null) await setSpeechRate(rate);\n"
    "  }\n",
    1,
)

old_setter = """  Future<void> setSpeechRate(double rate) async {
    final option = speedOptions.reduce(
      (current, next) => (next.rate - rate).abs() < (current.rate - rate).abs()
          ? next
          : current,
    );
    if ((_speechRate - option.rate).abs() < .001) return;

    _speechRate = option.rate;
    if (_webSpeech.isAvailable && _status == NarrationStatus.paused) {
      _restartWebSpeechOnResume = true;
    }
    _safeNotify();
  }
"""
new_setter = """  Future<void> setSpeechRate(double rate) async {
    final option = speedOptions.reduce(
      (current, next) => (next.rate - rate).abs() < (current.rate - rate).abs()
          ? next
          : current,
    );

    _sharedSpeechRate = option.rate;
    final controllers = List<NarrationController>.of(_instances);
    for (final controller in controllers) {
      await controller._applySharedSpeechRate(option.rate);
    }
  }

  Future<void> _applySharedSpeechRate(double rate) async {
    if (_disposed || (_speechRate - rate).abs() < .001) return;

    final wasPlaying =
        _status == NarrationStatus.playing &&
        _speechMode == _NarrationSpeechMode.narration &&
        !_plan.isEmpty;
    final resumeOffset = _currentOffset;
    if (wasPlaying) await pauseAtOffset(resumeOffset);
    if (_disposed) return;

    _speechRate = rate;
    if (_webSpeech.isAvailable && _status == NarrationStatus.paused) {
      _restartWebSpeechOnResume = true;
    }
    _safeNotify();

    if (wasPlaying && !_disposed) {
      await resumeFromOffset(resumeOffset);
    }
  }
"""
if old_setter not in controller:
    raise RuntimeError('NarrationController setSpeechRate block not found')
controller = controller.replace(old_setter, new_setter, 1)
controller = controller.replace(
    "if (kIsWeb) return multiplier.clamp(0.5, 2.0).toDouble();",
    "if (kIsWeb) return multiplier.clamp(0.5, 1.5).toDouble();",
    1,
)
controller = controller.replace(
    "  void dispose() {\n    _speechSessionToken += 1;",
    "  void dispose() {\n    _instances.remove(this);\n    _speechSessionToken += 1;",
    1,
)
write(controller_path, controller)

speed_widget_path = 'app/lib/widgets/narration_speed_stepper.dart'
write(
    speed_widget_path,
    """import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

typedef NarrationRateChange = Future<void> Function(double rate);

class NarrationSpeedStepper extends StatelessWidget {
  const NarrationSpeedStepper({
    required this.controller,
    this.onRateChange,
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final NarrationController controller;
  final NarrationRateChange? onRateChange;
  final bool dark;
  final bool compact;

  void _setRate(double? rate) {
    if (rate == null) return;
    final callback = onRateChange;
    if (callback == null) {
      unawaited(controller.setSpeechRate(rate));
    } else {
      unawaited(callback(rate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final foreground = dark ? Colors.white : PhoenixTheme.red;
        final muted = dark ? Colors.white38 : Colors.black26;
        final background = dark
            ? Colors.white.withValues(alpha: .13)
            : PhoenixTheme.red.withValues(alpha: .08);
        final border = dark
            ? Colors.white.withValues(alpha: .16)
            : PhoenixTheme.red.withValues(alpha: .16);

        return Semantics(
          container: true,
          label: '当前朗读速度 ${controller.speedLabel}，可减速或加速',
          child: Container(
            key: const ValueKey('narration-speed-stepper'),
            padding: EdgeInsets.fromLTRB(
              compact ? 5 : 7,
              compact ? 3 : 4,
              compact ? 5 : 7,
              compact ? 2 : 3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.speedLabel,
                  key: const ValueKey('narration-current-speed'),
                  style: TextStyle(
                    color: foreground,
                    fontSize: compact ? 9 : 10,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SpeedAction(
                      key: const ValueKey('narration-slow-down'),
                      label: '减速',
                      enabled: controller.canDecreaseSpeechRate,
                      foreground: foreground,
                      disabled: muted,
                      onPressed: () => _setRate(controller.slowerSpeechRate),
                    ),
                    Container(
                      width: 1,
                      height: 11,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: border,
                    ),
                    _SpeedAction(
                      key: const ValueKey('narration-speed-up'),
                      label: '加速',
                      enabled: controller.canIncreaseSpeechRate,
                      foreground: foreground,
                      disabled: muted,
                      onPressed: () => _setRate(controller.fasterSpeechRate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpeedAction extends StatelessWidget {
  const _SpeedAction({
    required this.label,
    required this.enabled,
    required this.foreground,
    required this.disabled,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool enabled;
  final Color foreground;
  final Color disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? foreground : disabled,
            fontSize: 7.5,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
""",
)

player_path = 'app/lib/widgets/narration_player_card.dart'
player = read(player_path)
player = player.replace(
    "import 'phoenix_media_button.dart';\n",
    "import 'narration_speed_stepper.dart';\nimport 'phoenix_media_button.dart';\n",
    1,
)
old_player_control = """                    PopupMenuButton<double>(
                      key: const ValueKey('narration-speed-control'),
                      tooltip: '调整朗读语速',
                      padding: EdgeInsets.zero,
                      onSelected: (rate) {
                        unawaited(_setSpeechRate(rate));
                      },
                      itemBuilder: (context) => NarrationController.speedOptions
                          .map(
                            (option) => PopupMenuItem<double>(
                              value: option.rate,
                              child: Text('${option.label} 语速'),
                            ),
                          )
                          .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          widget.controller.speedLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
"""
new_player_control = """                    NarrationSpeedStepper(
                      key: const ValueKey('narration-speed-control'),
                      controller: widget.controller,
                      onRateChange: _setSpeechRate,
                      dark: true,
                      compact: compact,
                    ),
"""
if old_player_control not in player:
    raise RuntimeError('NarrationPlayerCard speed popup not found')
write(player_path, player.replace(old_player_control, new_player_control, 1))

word_path = 'app/lib/widgets/word_detail_sheet.dart'
word = read(word_path)
word = word.replace(
    "import 'word_mark.dart';\n",
    "import 'narration_speed_stepper.dart';\nimport 'word_mark.dart';\n",
    1,
)
old_word_control = """                  AnimatedBuilder(
                    animation: widget.narrationController,
                    builder: (context, _) => PopupMenuButton<double>(
                      key: const ValueKey('word-detail-speed-control'),
                      tooltip: '调整朗读语速',
                      onSelected: (rate) => unawaited(
                        widget.narrationController.setSpeechRate(rate),
                      ),
                      itemBuilder: (context) => NarrationController.speedOptions
                          .map(
                            (option) => PopupMenuItem<double>(
                              value: option.rate,
                              child: Text('${option.label} 语速'),
                            ),
                          )
                          .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.red.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          widget.narrationController.speedLabel,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
"""
new_word_control = """                  NarrationSpeedStepper(
                    key: const ValueKey('word-detail-speed-control'),
                    controller: widget.narrationController,
                    compact: true,
                  ),
"""
if old_word_control not in word:
    raise RuntimeError('WordDetail speed popup not found')
write(word_path, word.replace(old_word_control, new_word_control, 1))

journey_path = 'app/lib/screens/journey_screen.dart'
journey = read(journey_path)
journey = journey.replace(
    "import '../widgets/narration_player_card.dart';\n",
    "import '../widgets/narration_player_card.dart';\n"
    "import '../widgets/narration_speed_stepper.dart';\n",
    1,
)
old_support_control = """            AnimatedBuilder(
              animation: controller,
              builder: (context, _) => PopupMenuButton<double>(
                key: const ValueKey('support-speed-control'),
                tooltip: '调整朗读语速',
                onSelected: (rate) => unawaited(controller.setSpeechRate(rate)),
                itemBuilder: (context) => NarrationController.speedOptions
                    .map(
                      (option) => PopupMenuItem<double>(
                        value: option.rate,
                        child: Text('${option.label} 语速'),
                      ),
                    )
                    .toList(growable: false),
                child: Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    controller.speedLabel,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
"""
new_support_control = """            NarrationSpeedStepper(
              key: const ValueKey('support-speed-control'),
              controller: controller,
              compact: true,
            ),
"""
if old_support_control not in journey:
    raise RuntimeError('Reading support speed popup not found')
write(journey_path, journey.replace(old_support_control, new_support_control, 1))

workflow_path = 'docs/development-workflow.md'
workflow_doc = read(workflow_path).replace('0.5×–2.0×', '0.5×–1.5×')
needle = "2. 用户可调范围固定为 `0.5×–1.5×`；调整速度后必须从当前准确位置继续，禁止重新从头朗读。\n"
addition = (
    needle
    + "   - 速度数字下方必须固定显示“减速”和“加速”两个选择；禁止改回独立倍率弹出菜单。\n"
    + "   - 任一入口调整速度时，所有现有与之后打开的朗读入口必须立刻同步为同一倍率。\n"
)
if needle not in workflow_doc:
    raise RuntimeError('Permanent narration range rule not found')
workflow_doc = workflow_doc.replace(needle, addition, 1)
write(workflow_path, workflow_doc)

template_path = '.github/pull_request_template.md'
template = read(template_path).replace('0.5×–2.0×', '0.5×–1.5×')
anchor = "- [ ] 所有朗读默认 `1.0×` 本地自然语速，范围为 `0.5×–1.5×`\n"
if anchor not in template:
    raise RuntimeError('PR narration speed checklist line not found')
template = template.replace(
    anchor,
    anchor
    + "- [ ] 速度数字下方显示“减速 / 加速”，调整后全部朗读入口同步同一倍率\n",
    1,
)
write(template_path, template)

for test_file in Path('worker').glob('*.test.mjs'):
    text = test_file.read_text(encoding='utf-8')
    text = text.replace('0.5×–2.0×', '0.5×–1.5×')
    text = text.replace('0\\.5×–2\\.0×', '0\\.5×–1\\.5×')
    text = text.replace(
        "assert.match(controller, /NarrationSpeedOption\\(label: '2\\.0×', rate: 2\\.0\\)/);",
        "assert.match(controller, /NarrationSpeedOption\\(label: '1\\.5×', rate: 1\\.5\\)/);\n"
        "  assert.doesNotMatch(controller, /1\\.75×|2\\.0×/);",
    )
    test_file.write_text(text, encoding='utf-8')

rule_test_path = 'worker/narration_speed_stepper_rule.test.mjs'
write(
    rule_test_path,
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');
const controller = read('app/lib/services/narration_controller.dart');
const speedControl = read('app/lib/widgets/narration_speed_stepper.dart');
const player = read('app/lib/widgets/narration_player_card.dart');
const wordSheet = read('app/lib/widgets/word_detail_sheet.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const processDoc = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');

test('Phoenix speed range is permanently limited to 0.5x through 1.5x', () => {
  assert.match(controller, /NarrationSpeedOption\(label: '0\.5×', rate: \.5\)/);
  assert.match(controller, /NarrationSpeedOption\(label: '1\.5×', rate: 1\.5\)/);
  assert.doesNotMatch(controller, /NarrationSpeedOption\(label: '1\.75×'/);
  assert.doesNotMatch(controller, /NarrationSpeedOption\(label: '2\.0×'/);
  assert.match(controller, /multiplier\.clamp\(0\.5, 1\.5\)/);
});

test('the current speed has slow-down and speed-up choices directly underneath', () => {
  assert.match(speedControl, /ValueKey\('narration-current-speed'\)/);
  assert.match(speedControl, /label: '减速'/);
  assert.match(speedControl, /label: '加速'/);
  assert.match(speedControl, /ValueKey\('narration-slow-down'\)/);
  assert.match(speedControl, /ValueKey\('narration-speed-up'\)/);
  assert.doesNotMatch(player, /PopupMenuButton<double>/);
  assert.doesNotMatch(wordSheet, /PopupMenuButton<double>/);
  assert.doesNotMatch(journey, /key: const ValueKey\('support-speed-control'\)[\s\S]{0,220}PopupMenuButton/);
});

test('changing speed synchronizes every narration controller and future controller', () => {
  assert.match(controller, /static double _sharedSpeechRate = nativeDefaultRate/);
  assert.match(controller, /static final Set<NarrationController> _instances/);
  assert.match(controller, /_speechRate = _sharedSpeechRate/);
  assert.match(controller, /_instances\.add\(this\)/);
  assert.match(controller, /List<NarrationController>\.of\(_instances\)/);
  assert.match(controller, /controller\._applySharedSpeechRate\(option\.rate\)/);
  assert.match(controller, /resumeFromOffset\(resumeOffset\)/);
  assert.match(controller, /_instances\.remove\(this\)/);
});

test('permanent documents and pull requests enforce the same speed rule', () => {
  assert.match(processDoc, /0\.5×–1\.5×/);
  assert.match(processDoc, /速度数字下方必须固定显示“减速”和“加速”/);
  assert.match(processDoc, /所有现有与之后打开的朗读入口必须立刻同步/);
  assert.match(template, /0\.5×–1\.5×/);
  assert.match(template, /减速 \/ 加速/);
  assert.match(template, /全部朗读入口同步同一倍率/);
});
""",
)

# Remove the one-off migration machinery from the resulting product commit.
Path('.github/scripts/apply_speed_stepper_rule.py').unlink(missing_ok=True)
Path('.github/workflows/apply-speed-stepper-rule.yml').unlink(missing_ok=True)
