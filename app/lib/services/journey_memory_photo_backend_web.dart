import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'journey_memory_photo_backend.dart';

JourneyMemoryPhotoBackend createBackend() => _IndexedDbPhotoBackend();

class _IndexedDbPhotoBackend implements JourneyMemoryPhotoBackend {
  static const _dbName = 'phoenix_journey_memory';
  static const _storeName = 'photos';

  Future<web.IDBDatabase> _open() {
    final completer = Completer<web.IDBDatabase>();
    final request = web.window.indexedDB.open(_dbName, 1);
    request.onupgradeneeded = ((web.Event _) {
      final db = request.result as web.IDBDatabase;
      if (!db.objectStoreNames.contains(_storeName)) db.createObjectStore(_storeName);
    }).toJS;
    request.onsuccess = ((web.Event _) => completer.complete(request.result as web.IDBDatabase)).toJS;
    request.onerror = ((web.Event _) => completer.completeError(StateError('IndexedDB open failed'))).toJS;
    return completer.future;
  }

  Future<void> _completed(web.IDBTransaction transaction) {
    final completer = Completer<void>();
    transaction.oncomplete = ((web.Event _) => completer.complete()).toJS;
    transaction.onerror = ((web.Event _) => completer.completeError(StateError('IndexedDB transaction failed'))).toJS;
    return completer.future;
  }

  @override
  Future<void> put(String ref, Uint8List bytes) async {
    final db = await _open();
    final transaction = db.transaction(_storeName.toJS, 'readwrite');
    transaction.objectStore(_storeName).put(bytes.toJS, ref.toJS);
    await _completed(transaction);
    db.close();
  }

  @override
  Future<Uint8List?> get(String ref) async {
    final db = await _open();
    final transaction = db.transaction(_storeName.toJS, 'readonly');
    final request = transaction.objectStore(_storeName).get(ref.toJS);
    final completer = Completer<JSAny?>();
    request.onsuccess = ((web.Event _) => completer.complete(request.result)).toJS;
    request.onerror = ((web.Event _) => completer.completeError(StateError('IndexedDB read failed'))).toJS;
    final value = await completer.future;
    db.close();
    return value == null ? null : (value as JSUint8Array).toDart;
  }

  @override
  Future<void> delete(String ref) async {
    final db = await _open();
    final transaction = db.transaction(_storeName.toJS, 'readwrite');
    transaction.objectStore(_storeName).delete(ref.toJS);
    await _completed(transaction);
    db.close();
  }
}
