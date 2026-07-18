from pathlib import Path
import re

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()

controller_marker = '  Future<void> pause() async {\n'
controller_insert = '''  /// Keeps the visible word highlight moving while a browser continues to
  /// speak but reports an unreliable completion/progress state.
  void syncPlaybackHighlight({
    required String contentId,
    required int offset,
  }) {
    if (_disposed || _plan.isEmpty || _contentId != contentId) return;

    final maxOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    _applyProgress(safeOffset);
  }

  void clearPlaybackHighlight({required String contentId}) {
    if (_disposed || _contentId != contentId) return;
    NarrationHighlightBus.instance.clear(contentId: contentId);
  }

'''
if controller_insert not in controller:
    if controller_marker not in controller:
        raise SystemExit('NarrationController pause marker not found')
    controller = controller.replace(
        controller_marker,
        controller_insert + controller_marker,
        1,
    )
controller_path.write_text(controller)

player_path = Path('app/lib/widgets/narration_player_card.dart')
player = player_path.read_text()

new_clock = '''  void _startPositionClock() {
    _positionClock?.cancel();
    _positionClock = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (!mounted || !_sessionPlaying) return;

      final total = widget.controller.totalCharacters;
      final nextOffset = _estimatedSessionOffset();

      if (total > 0 && nextOffset >= total) {
        _positionClock?.cancel();
        widget.controller.clearPlaybackHighlight(contentId: widget.contentId);
        setState(() {
          _sessionPlaying = false;
          _sessionPaused = false;
          _displayOffset = total;
          _resumeOffset = total;
          _displayItemIndex = null;
        });
        return;
      }

      // The local Phoenix clock is the source of truth for live highlighting.
      // Safari can announce completion while audio is still playing, which
      // otherwise leaves the text unhighlighted until the user presses pause.
      widget.controller.syncPlaybackHighlight(
        contentId: widget.contentId,
        offset: nextOffset,
      );
      final nextItem = widget.controller.currentItemIndex ?? _displayItemIndex;

      if (nextOffset != _displayOffset || nextItem != _displayItemIndex) {
        setState(() {
          _displayOffset = nextOffset;
          _displayItemIndex = nextItem;
        });
      }
    });
  }
'''
player, count = re.subn(
    r'  void _startPositionClock\(\) \{[\s\S]*?\n  \}\n\n  void _beginLocalPlayback',
    new_clock + '\n  void _beginLocalPlayback',
    player,
    count=1,
)
if count != 1:
    raise SystemExit(f'_startPositionClock replacement count: {count}')

old_begin_tail = '''    });
    _startPositionClock();
  }

  void _handleMainPressed()'''
new_begin_tail = '''    });
    widget.controller.syncPlaybackHighlight(
      contentId: widget.contentId,
      offset: offset,
    );
    _startPositionClock();
  }

  void _handleMainPressed()'''
if new_begin_tail not in player:
    if old_begin_tail not in player:
        raise SystemExit('_beginLocalPlayback tail not found')
    player = player.replace(old_begin_tail, new_begin_tail, 1)
player_path.write_text(player)

test_path = Path('worker/live_narration_highlight.test.mjs')
test_path.write_text('''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('Phoenix clock drives highlighting during active playback', () => {
  assert.match(controller, /void syncPlaybackHighlight\(/);
  assert.match(player, /widget\.controller\.syncPlaybackHighlight\([\s\S]*offset: nextOffset/);
});

test('highlight clears only after the local playback clock reaches the end', () => {
  assert.match(
    player,
    /if \(total > 0 && nextOffset >= total\)[\s\S]*clearPlaybackHighlight/,
  );
});
''')
