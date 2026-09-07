from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: apply_founder_device_nav_fix.py <journey_screen.dart>")

path = Path(sys.argv[1])
text = path.read_text()
old = """    await _stopJourneyNarration();
    if (!mounted || safeStep == step) return;

    setState(() => step = safeStep);
"""
new = """    try {
      await _stopJourneyNarration().timeout(const Duration(milliseconds: 500));
    } on TimeoutException {
      // External speech cleanup must never block Journey step navigation.
    }
    if (!mounted || safeStep == step) return;

    setState(() => step = safeStep);
"""
count = text.count(old)
if count != 1:
    raise SystemExit(f"expected exactly one transition anchor, found {count}")
path.write_text(text.replace(old, new, 1))
