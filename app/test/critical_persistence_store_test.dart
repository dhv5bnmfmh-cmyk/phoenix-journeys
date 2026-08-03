import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/critical_persistence_store.dart';

class _MemoryBackend implements CriticalPersistenceBackend {
  final Map<String, String> values = <String, String>{};
  String? failWriteKey;
  String? throwWriteKey;
  String? mismatchReadKey;
  int writes = 0;

  @override
  Future<String?> read(String key) async {
    final value = values[key];
    if (mismatchReadKey == key) {
      mismatchReadKey = null;
      return value == null ? 'mismatch' : '$value-mismatch';
    }
    return value;
  }

  @override
  Future<bool> write(String key, String value) async {
    writes += 1;
    if (throwWriteKey == key) {
      throwWriteKey = null;
      throw StateError('injected write exception');
    }
    if (failWriteKey == key) {
      failWriteKey = null;
      return false;
    }
    values[key] = value;
    return true;
  }
}

Map<String, dynamic> _payload(int value) => <String, dynamic>{
      'value': value,
      'nested': <String, dynamic>{'stable': true},
    };

void main() {
  test('empty store creates the first valid committed record', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);

    final committed = await store.commitInitial(_payload(1));

    expect(committed.revision, 1);
    expect(committed.payload, _payload(1));
    expect(committed.slot, 'a');
    expect(await store.readCommitted(), isNotNull);
  });

  test('a valid record reloads exactly', () async {
    final backend = _MemoryBackend();
    final first = CriticalPersistenceStore(backend);
    final committed = await first.commitInitial(_payload(7));

    final reloaded = await CriticalPersistenceStore(backend).readCommitted();

    expect(reloaded?.revision, committed.revision);
    expect(reloaded?.payloadHash, committed.payloadHash);
    expect(reloaded?.payload, _payload(7));
  });

  test('write false leaves the previous committed record unchanged', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    final first = await store.commitInitial(_payload(1));
    backend.failWriteKey = CriticalPersistenceStore.recordKeyForSlot('b');

    await expectLater(
      store.commitPayload(_payload(2), expectedRevision: first.revision),
      throwsA(isA<CriticalPersistenceException>()),
    );

    final restored = await CriticalPersistenceStore(backend).readCommitted();
    expect(restored?.revision, 1);
    expect(restored?.payload, _payload(1));
  });

  test('write exception leaves the previous committed record unchanged', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    final first = await store.commitInitial(_payload(1));
    backend.throwWriteKey = CriticalPersistenceStore.recordKeyForSlot('b');

    await expectLater(
      store.commitPayload(_payload(2), expectedRevision: first.revision),
      throwsA(isA<CriticalPersistenceException>()),
    );

    final restored = await CriticalPersistenceStore(backend).readCommitted();
    expect(restored?.revision, 1);
    expect(restored?.payload, _payload(1));
  });

  test('readback mismatch rejects candidate and retains previous generation',
      () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    final first = await store.commitInitial(_payload(1));
    backend.mismatchReadKey = CriticalPersistenceStore.recordKeyForSlot('b');

    await expectLater(
      store.commitPayload(_payload(2), expectedRevision: first.revision),
      throwsA(isA<CriticalPersistenceException>()),
    );

    final restored = await CriticalPersistenceStore(backend).readCommitted();
    expect(restored?.revision, 1);
    expect(restored?.payload, _payload(1));
  });

  test('corrupt authoritative payload fails closed', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    await store.commitInitial(_payload(1));
    backend.values[CriticalPersistenceStore.recordKeyForSlot('a')] =
        '{not-json';

    await expectLater(
      CriticalPersistenceStore(backend).readCommitted(),
      throwsA(isA<CriticalPersistenceException>()),
    );
  });

  test('unsupported authoritative schema fails closed', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    await store.commitInitial(_payload(1));
    final witnessKey = CriticalPersistenceStore.witnessKeyForSlot('a');
    final witness = jsonDecode(backend.values[witnessKey]!) as Map;
    witness['schemaVersion'] = 99;
    backend.values[witnessKey] = jsonEncode(witness);

    await expectLater(
      CriticalPersistenceStore(backend).readCommitted(),
      throwsA(
        isA<CriticalPersistenceException>().having(
          (error) => error.reason,
          'reason',
          contains('No valid committed critical state'),
        ),
      ),
    );
  });

  test('revision never moves backward', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    final first = await store.commitInitial(_payload(1));
    final second = await store.commitPayload(
      _payload(2),
      expectedRevision: first.revision,
    );

    expect(second.revision, 2);
    await expectLater(
      store.commitPayload(_payload(3), expectedRevision: 1),
      throwsA(isA<CriticalPersistenceException>()),
    );
    expect((await store.readCommitted())?.revision, 2);
  });

  test('concurrent commits are serialized in deterministic order', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    await store.commitInitial(_payload(0));

    Future<int> increment() async {
      final result = await store.transact<int>((current) {
        final value = current.payload['value'] as int;
        return CriticalMutation<int>.changed(
          payload: _payload(value + 1),
          result: value + 1,
        );
      });
      return result.result;
    }

    final results = await Future.wait([increment(), increment()]);
    final committed = await store.readCommitted();

    expect(results, [1, 2]);
    expect(committed?.revision, 3);
    expect(committed?.payload['value'], 2);
  });

  test('a stale candidate cannot overwrite a newer commit', () async {
    final backend = _MemoryBackend();
    final store = CriticalPersistenceStore(backend);
    final first = await store.commitInitial(_payload(1));
    await store.commitPayload(_payload(2), expectedRevision: first.revision);

    await expectLater(
      store.commitPayload(_payload(99), expectedRevision: first.revision),
      throwsA(isA<CriticalPersistenceException>()),
    );

    final committed = await store.readCommitted();
    expect(committed?.payload['value'], 2);
    expect(committed?.revision, 2);
  });

  test('an interrupted migration record without witness is not committed',
      () async {
    final backend = _MemoryBackend();
    backend.values[CriticalPersistenceStore.recordKeyForSlot('a')] =
        jsonEncode(<String, dynamic>{'partial': true});

    final committed = await CriticalPersistenceStore(backend).readCommitted();

    expect(committed, isNull);
  });
}
