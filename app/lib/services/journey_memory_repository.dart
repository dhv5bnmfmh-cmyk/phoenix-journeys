import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journey_memory_entry.dart';
import 'journey_memory_photo_backend.dart';

class JourneyMemoryRepository {
  JourneyMemoryRepository(this.preferences, {JourneyMemoryPhotoBackend? photos})
      : photos = photos ?? createJourneyMemoryPhotoBackend();

  static const metadataKey = 'journeyMemory.entries.v1';
  static const legacyKey = 'memories';
  final SharedPreferences preferences;
  final JourneyMemoryPhotoBackend photos;

  Future<List<JourneyMemoryEntry>> load() async {
    final raw = preferences.getString(metadataKey);
    final entries = raw == null
        ? <JourneyMemoryEntry>[]
        : (jsonDecode(raw) as List).map((e) => JourneyMemoryEntry.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    final migrated = _migrateLegacy(entries, preferences.getStringList(legacyKey) ?? const []);
    if (migrated.length != entries.length) await _saveAll(migrated);
    migrated.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return migrated;
  }

  List<JourneyMemoryEntry> _migrateLegacy(List<JourneyMemoryEntry> entries, List<String> legacy) {
    final result = [...entries];
    final existingNotes = result.map((e) => e.initialNote).toSet();
    for (var i = 0; i < legacy.length; i++) {
      final raw = legacy[i];
      final split = raw.split('｜');
      final note = split.length > 1 ? split.sublist(1).join('｜') : raw;
      if (existingNotes.contains(note)) {
        continue;
      }
      final known = raw.startsWith('北京 · 紫禁城｜');
      final time = DateTime.fromMillisecondsSinceEpoch(i);
      result.add(JourneyMemoryEntry(
        id: 'legacy-${raw.hashCode}-$i', journeyId: known ? 'beijing-forbidden-city' : 'legacy-$i',
        city: known ? '北京' : '旧回忆', place: known ? '紫禁城' : '',
        journeyTitle: split.first, sessionLevel: 1, initialNote: note,
        initialCreatedAt: time, updatedNote: '', updatedAt: time,
        isVisited: false, photoRefs: const [], legacy: !known,
      ));
    }
    return result;
  }

  Future<JourneyMemoryEntry> upsert(JourneyMemoryEntry entry) async {
    final entries = await load();
    final index = entries.indexWhere((e) => e.journeyId == entry.journeyId && !e.legacy);
    if (index < 0) {
      entries.add(entry);
    } else {
      entries[index] = entry;
    }
    await _saveAll(entries);
    return entry;
  }

  Future<void> _saveAll(List<JourneyMemoryEntry> entries) => preferences.setString(
        metadataKey, jsonEncode(entries.map((e) => e.toJson()).toList()),
      );

  Future<String> addPhoto(String entryId, Uint8List bytes, {DateTime? now}) async {
    final ref = '$entryId-${(now ?? DateTime.now()).microsecondsSinceEpoch}';
    await photos.put(ref, bytes);
    return ref;
  }
  Future<Uint8List?> readPhoto(String ref) => photos.get(ref);
  Future<void> deletePhoto(String ref) => photos.delete(ref);
}
