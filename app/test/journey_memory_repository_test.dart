import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_memory_entry.dart';
import 'package:phoenix_journeys/services/journey_memory_photo_backend.dart';
import 'package:phoenix_journeys/services/journey_memory_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

JourneyMemoryEntry entry({
  String note = '第一次看见午门的感受',
  int level = 5,
  List<String> photos = const [],
  bool visited = false,
  DateTime? visitedAt,
  String visitNote = '',
}) {
  final now = DateTime.utc(2026, 9, 2);
  return JourneyMemoryEntry(
    id: 'memory-beijing-forbidden-city',
    journeyId: 'beijing-forbidden-city',
    city: '北京', place: '紫禁城', journeyTitle: '两条都能走通的路线',
    sessionLevel: level, initialNote: note, initialCreatedAt: now,
    updatedNote: '', updatedAt: now, isVisited: visited,
    visitedAt: visitedAt, visitNote: visitNote, photoRefs: photos,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('create, reopen and update one Journey memory without duplicates', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final photos = MemoryJourneyPhotoBackend();
    var repository = JourneyMemoryRepository(prefs, photos: photos);
    await repository.upsert(entry());

    repository = JourneyMemoryRepository(prefs, photos: photos);
    var restored = await repository.load();
    expect(restored.single.note, '第一次看见午门的感受');
    expect(restored.single.sessionLevel, 5, reason: 'mounted Journey level stays locked');

    await repository.upsert(restored.single.copyWith(updatedNote: '后来我真的来了', updatedAt: DateTime.utc(2026, 9, 3)));
    restored = await JourneyMemoryRepository(prefs, photos: photos).load();
    expect(restored, hasLength(1));
    expect(restored.single.note, '后来我真的来了');
  });

  test('photo add/read/delete remains binary and metadata persists separately', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final binary = MemoryJourneyPhotoBackend();
    var repository = JourneyMemoryRepository(prefs, photos: binary);
    final ref = await repository.addPhoto('memory-beijing-forbidden-city', Uint8List.fromList([1, 2, 3]), now: DateTime.utc(2026, 9, 2));
    await repository.upsert(entry(photos: [ref]));

    repository = JourneyMemoryRepository(prefs, photos: binary);
    expect((await repository.load()).single.photoRefs, [ref]);
    expect(await repository.readPhoto(ref), Uint8List.fromList([1, 2, 3]));
    expect(prefs.getString(JourneyMemoryRepository.metadataKey), isNot(contains('AQID')));

    await repository.deletePhoto(ref);
    await repository.upsert(entry(photos: const []));
    repository = JourneyMemoryRepository(prefs, photos: binary);
    expect((await repository.load()).single.photoRefs, isEmpty);
    expect(await repository.readPhoto(ref), isNull);
  });

  test('visited date and现场感受 survive repository reopen', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = JourneyMemoryRepository(prefs, photos: MemoryJourneyPhotoBackend());
    await repository.upsert(entry(visited: true, visitedAt: DateTime.utc(2026, 8, 18), visitNote: '雨后的红墙很安静'));
    final restored = (await JourneyMemoryRepository(prefs, photos: MemoryJourneyPhotoBackend()).load()).single;
    expect(restored.isVisited, isTrue);
    expect(restored.visitedAt, DateTime.utc(2026, 8, 18));
    expect(restored.visitNote, '雨后的红墙很安静');
  });

  test('legacy strings migrate without loss and unknown entries remain visible', () async {
    SharedPreferences.setMockInitialValues({'memories': <String>['北京 · 紫禁城｜红墙', '旧格式无法识别']});
    final prefs = await SharedPreferences.getInstance();
    final restored = await JourneyMemoryRepository(prefs, photos: MemoryJourneyPhotoBackend()).load();
    expect(restored, hasLength(2));
    expect(restored.any((item) => item.journeyId == 'beijing-forbidden-city' && !item.legacy), isTrue);
    expect(restored.any((item) => item.legacy && item.note == '旧格式无法识别'), isTrue);
  });
}
