import 'dart:typed_data';

import 'journey_memory_photo_picker_stub.dart'
    if (dart.library.html) 'journey_memory_photo_picker_web.dart';

Future<List<Uint8List>> pickJourneyMemoryPhotos() => pickPhotos();
