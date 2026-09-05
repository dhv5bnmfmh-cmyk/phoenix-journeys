from pathlib import Path

p = Path('app/lib/services/journey_memory_photo_picker.dart')
text = p.read_text()
old = "Future<Uint8List?> pickJourneyMemoryPhoto() => pickPhoto();\n"
new = """Future<Uint8List?> pickJourneyMemoryPhoto() => pickPhoto();

// Compatibility for existing Memory detail editor. The V1 picker itself is
// singular, so callers can receive at most one photo.
Future<List<Uint8List>> pickJourneyMemoryPhotos() async {
  final photo = await pickPhoto();
  return photo == null ? const <Uint8List>[] : <Uint8List>[photo];
}
"""
if text.count(old) != 1:
    raise SystemExit(f'picker compatibility anchor count: {text.count(old)}')
p.write_text(text.replace(old, new, 1))
