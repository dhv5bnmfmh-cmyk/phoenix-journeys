import 'dart:typed_data';

import 'journey_memory_photo_backend_stub.dart'
    if (dart.library.html) 'journey_memory_photo_backend_web.dart';

abstract class JourneyMemoryPhotoBackend {
  Future<void> put(String ref, Uint8List bytes);
  Future<Uint8List?> get(String ref);
  Future<void> delete(String ref);
}

JourneyMemoryPhotoBackend createJourneyMemoryPhotoBackend() => createBackend();

class MemoryJourneyPhotoBackend implements JourneyMemoryPhotoBackend {
  final Map<String, Uint8List> _values = {};
  @override Future<void> put(String ref, Uint8List bytes) async => _values[ref] = Uint8List.fromList(bytes);
  @override Future<Uint8List?> get(String ref) async => _values[ref] == null ? null : Uint8List.fromList(_values[ref]!);
  @override Future<void> delete(String ref) async => _values.remove(ref);
}
