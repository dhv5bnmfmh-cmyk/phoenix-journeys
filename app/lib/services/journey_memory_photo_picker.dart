import 'dart:typed_data';

import 'journey_memory_photo_picker_stub.dart'
    if (dart.library.html) 'journey_memory_photo_picker_web.dart';

Future<Uint8List?> pickJourneyMemoryPhoto() => pickPhoto();

// Compatibility for existing Memory detail editor. The V1 picker itself is
// singular, so callers can receive at most one photo.
Future<List<Uint8List>> pickJourneyMemoryPhotos() async {
  final photo = await pickPhoto();
  return photo == null ? const <Uint8List>[] : <Uint8List>[photo];
}
