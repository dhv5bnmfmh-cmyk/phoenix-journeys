import 'journey_memory_photo_backend.dart';

// Native implementations can replace this with app-private persistent files
// without changing JourneyMemoryRepository or its metadata schema.
JourneyMemoryPhotoBackend createBackend() => MemoryJourneyPhotoBackend();
