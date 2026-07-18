from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
source = path.read_text()
old = '''  bool _isNarrating(String contentId, int itemIndex) {
    final isActive =
        _narration.status == NarrationStatus.playing ||
        _narration.status == NarrationStatus.paused;
    return isActive &&
        _narration.contentId == contentId &&
        _narration.currentItemIndex == itemIndex;
  }

'''
if old not in source:
    raise SystemExit('unused _isNarrating helper not found')
path.write_text(source.replace(old, '', 1))
