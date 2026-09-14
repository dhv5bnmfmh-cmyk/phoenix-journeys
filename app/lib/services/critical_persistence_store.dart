import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Application-level journal for Phoenix critical local state.
///
/// SharedPreferences is only the local byte store. This class does not claim
/// database-level ACID guarantees. It keeps two generations and publishes a
/// generation only after its complete envelope has been written and read back.
abstract class CriticalPersistenceBackend {
  Future<String?> read(String key);

  Future<bool> write(String key, String value);
}

class SharedPreferencesCriticalPersistenceBackend
    implements CriticalPersistenceBackend {
  const SharedPreferencesCriticalPersistenceBackend(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<String?> read(String key) async => preferences.getString(key);

  @override
  Future<bool> write(String key, String value) =>
      preferences.setString(key, value);
}

class CriticalPersistenceException implements Exception {
  const CriticalPersistenceException(this.reason);

  final String reason;

  @override
  String toString() => 'CriticalPersistenceException($reason)';
}

class CriticalCommittedRecord {
  const CriticalCommittedRecord({
    required this.domain,
    required this.schemaVersion,
    required this.revision,
    required this.slot,
    required this.payload,
    required this.payloadHash,
  });

  final String domain;
  final int schemaVersion;
  final int revision;
  final String slot;
  final Map<String, dynamic> payload;
  final String payloadHash;
}

class CriticalMutation<T> {
  const CriticalMutation.changed({
    required this.payload,
    required this.result,
  }) : changed = true;

  const CriticalMutation.unchanged({required this.result})
      : changed = false,
        payload = null;

  final bool changed;
  final Map<String, dynamic>? payload;
  final T result;
}

class CriticalTransactionResult<T> {
  const CriticalTransactionResult({
    required this.record,
    required this.result,
    required this.committed,
  });

  final CriticalCommittedRecord record;
  final T result;
  final bool committed;
}

typedef CriticalMutationBuilder<T> = FutureOr<CriticalMutation<T>> Function(
  CriticalCommittedRecord current,
);

class CriticalPersistenceStore {
  CriticalPersistenceStore(
    this.backend, {
    this.domain = phoenixCriticalStateDomain,
    this.schemaVersion = phoenixCriticalStateSchemaVersion,
    Set<int>? readableSchemaVersions,
  }) : readableSchemaVersions = Set<int>.unmodifiable(
          readableSchemaVersions ??
              <int>{
                phoenixCriticalStateLegacySchemaVersion,
                schemaVersion,
              },
        );

  static const String phoenixCriticalStateDomain =
      'phoenix.critical-local-state';
  static const int phoenixCriticalStateLegacySchemaVersion = 1;
  static const int phoenixCriticalStateSchemaVersion = 2;

  static const String _recordAKey = 'phoenix.critical.record.a';
  static const String _recordBKey = 'phoenix.critical.record.b';
  static const String _witnessAKey = 'phoenix.critical.witness.a';
  static const String _witnessBKey = 'phoenix.critical.witness.b';

  static String recordKeyForSlot(String slot) =>
      slot == 'a' ? _recordAKey : _recordBKey;

  static String witnessKeyForSlot(String slot) =>
      slot == 'a' ? _witnessAKey : _witnessBKey;

  final CriticalPersistenceBackend backend;
  final String domain;
  final int schemaVersion;
  final Set<int> readableSchemaVersions;

  Future<void> _tail = Future<void>.value();

  Future<CriticalCommittedRecord?> readCommitted() =>
      _serialized(_readCommittedUnlocked);

  Future<CriticalCommittedRecord> commitInitial(
    Map<String, dynamic> payload,
  ) {
    return _serialized(() async {
      final existing = await _readCommittedUnlocked();
      if (existing != null) return existing;
      return _commitUnlocked(
        payload: payload,
        expectedRevision: 0,
        current: null,
      );
    });
  }

  Future<CriticalCommittedRecord> commitPayload(
    Map<String, dynamic> payload, {
    required int expectedRevision,
  }) {
    return _serialized(() async {
      final current = await _readCommittedUnlocked();
      final actualRevision = current?.revision ?? 0;
      if (actualRevision != expectedRevision) {
        throw CriticalPersistenceException(
          'Stale critical-state revision: expected $expectedRevision, '
          'found $actualRevision.',
        );
      }
      return _commitUnlocked(
        payload: payload,
        expectedRevision: expectedRevision,
        current: current,
      );
    });
  }

  Future<CriticalTransactionResult<T>> transact<T>(
    CriticalMutationBuilder<T> build,
  ) {
    return _serialized(() async {
      final current = await _readCommittedUnlocked();
      if (current == null) {
        throw const CriticalPersistenceException(
          'Critical state has not been initialized.',
        );
      }
      final mutation = await build(current);
      if (!mutation.changed) {
        return CriticalTransactionResult<T>(
          record: current,
          result: mutation.result,
          committed: false,
        );
      }
      final payload = mutation.payload;
      if (payload == null) {
        throw const CriticalPersistenceException(
          'Changed critical mutation did not provide a candidate payload.',
        );
      }
      final committed = await _commitUnlocked(
        payload: payload,
        expectedRevision: current.revision,
        current: current,
      );
      return CriticalTransactionResult<T>(
        record: committed,
        result: mutation.result,
        committed: true,
      );
    });
  }

  Future<T> _serialized<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  Future<CriticalCommittedRecord?> _readCommittedUnlocked() async {
    final values = <String, String?>{};
    try {
      for (final slot in const ['a', 'b']) {
        values[recordKeyForSlot(slot)] =
            await backend.read(recordKeyForSlot(slot));
        values[witnessKeyForSlot(slot)] =
            await backend.read(witnessKeyForSlot(slot));
      }
    } catch (error) {
      throw CriticalPersistenceException(
        'Critical-state read failed: $error',
      );
    }

    final hasAnyWitness = const ['a', 'b'].any(
      (slot) => values[witnessKeyForSlot(slot)] != null,
    );
    if (!hasAnyWitness) {
      // A record without a witness is staging only. It is never authoritative,
      // so an interrupted first migration can safely retry from intact legacy
      // keys.
      return null;
    }

    final valid = <CriticalCommittedRecord>[];
    final invalidRevisions = <int>[];
    final failures = <String>[];

    for (final slot in const ['a', 'b']) {
      final witnessText = values[witnessKeyForSlot(slot)];
      if (witnessText == null) continue;

      try {
        final witness = _decodeMap(witnessText, 'witness $slot');
        final witnessDomain = witness['domain'];
        final witnessSchema = witness['schemaVersion'];
        final witnessRevision = witness['revision'];
        final witnessSlot = witness['slot'];
        final witnessHash = witness['payloadHash'];

        if (witnessRevision is int) invalidRevisions.add(witnessRevision);
        if (witnessDomain != domain) {
          throw CriticalPersistenceException(
            'Critical witness domain mismatch in slot $slot.',
          );
        }
        if (witnessSchema is! int ||
            !readableSchemaVersions.contains(witnessSchema)) {
          throw CriticalPersistenceException(
            'Unsupported critical-state schema in witness $slot: '
            '$witnessSchema.',
          );
        }
        if (witnessRevision is! int || witnessRevision < 1) {
          throw CriticalPersistenceException(
            'Invalid critical-state revision in witness $slot.',
          );
        }
        if (witnessSlot != slot || witnessHash is! String) {
          throw CriticalPersistenceException(
            'Invalid critical witness binding in slot $slot.',
          );
        }

        final recordText = values[recordKeyForSlot(slot)];
        if (recordText == null) {
          throw CriticalPersistenceException(
            'Committed witness $slot has no matching record.',
          );
        }
        final envelope = _decodeMap(recordText, 'record $slot');
        final record = _validateEnvelope(envelope, expectedSlot: slot);
        if (record.schemaVersion != witnessSchema ||
            record.revision != witnessRevision ||
            record.payloadHash != witnessHash) {
          throw CriticalPersistenceException(
            'Critical witness and record mismatch in slot $slot.',
          );
        }
        invalidRevisions.remove(witnessRevision);
        valid.add(record);
      } catch (error) {
        failures.add('$slot: $error');
      }
    }

    if (valid.isEmpty) {
      throw CriticalPersistenceException(
        'No valid committed critical state. ${failures.join(' | ')}',
      );
    }

    valid.sort((left, right) => left.revision.compareTo(right.revision));
    final selected = valid.last;
    final newestInvalid = invalidRevisions.isEmpty
        ? -1
        : invalidRevisions.reduce((left, right) => left > right ? left : right);
    if (newestInvalid >= selected.revision) {
      throw CriticalPersistenceException(
        'Newest committed critical generation is unreadable or unsupported. '
        '${failures.join(' | ')}',
      );
    }
    if (valid.length > 1 &&
        valid[valid.length - 2].revision == selected.revision &&
        valid[valid.length - 2].payloadHash != selected.payloadHash) {
      throw const CriticalPersistenceException(
        'Conflicting critical records share the same revision.',
      );
    }
    return selected;
  }

  Future<CriticalCommittedRecord> _commitUnlocked({
    required Map<String, dynamic> payload,
    required int expectedRevision,
    required CriticalCommittedRecord? current,
  }) async {
    final currentRevision = current?.revision ?? 0;
    if (currentRevision != expectedRevision) {
      throw CriticalPersistenceException(
        'Stale critical-state revision: expected $expectedRevision, '
        'found $currentRevision.',
      );
    }

    final revision = expectedRevision + 1;
    final slot = current?.slot == 'a' ? 'b' : 'a';
    final payloadCopy = _decodeMap(
      canonicalJson(payload),
      'candidate payload',
    );
    final hash = criticalPayloadHash(
      domain: domain,
      schemaVersion: schemaVersion,
      revision: revision,
      payload: payloadCopy,
    );
    final envelope = <String, dynamic>{
      'domain': domain,
      'schemaVersion': schemaVersion,
      'revision': revision,
      'slot': slot,
      'payload': payloadCopy,
      'payloadHash': hash,
    };
    final witness = <String, dynamic>{
      'domain': domain,
      'schemaVersion': schemaVersion,
      'revision': revision,
      'slot': slot,
      'payloadHash': hash,
    };
    final envelopeText = canonicalJson(envelope);
    final witnessText = canonicalJson(witness);

    await _writeAndVerify(
      recordKeyForSlot(slot),
      envelopeText,
      label: 'critical record revision $revision',
    );
    await _writeAndVerify(
      witnessKeyForSlot(slot),
      witnessText,
      label: 'critical witness revision $revision',
    );

    final committed = await _readCommittedUnlocked();
    if (committed == null ||
        committed.schemaVersion != schemaVersion ||
        committed.revision != revision ||
        committed.payloadHash != hash ||
        committed.slot != slot) {
      throw CriticalPersistenceException(
        'Critical-state commit verification failed for revision $revision.',
      );
    }
    return committed;
  }

  Future<void> _writeAndVerify(
    String key,
    String value, {
    required String label,
  }) async {
    try {
      final written = await backend.write(key, value);
      if (!written) {
        throw CriticalPersistenceException('$label write returned false.');
      }
      final readback = await backend.read(key);
      if (readback != value) {
        throw CriticalPersistenceException('$label readback mismatch.');
      }
    } on CriticalPersistenceException {
      rethrow;
    } catch (error) {
      throw CriticalPersistenceException('$label write failed: $error');
    }
  }

  CriticalCommittedRecord _validateEnvelope(
    Map<String, dynamic> envelope, {
    required String expectedSlot,
  }) {
    final envelopeDomain = envelope['domain'];
    final envelopeSchema = envelope['schemaVersion'];
    final revision = envelope['revision'];
    final slot = envelope['slot'];
    final rawPayload = envelope['payload'];
    final hash = envelope['payloadHash'];

    if (envelopeDomain != domain) {
      throw const CriticalPersistenceException(
        'Critical record domain mismatch.',
      );
    }
    if (envelopeSchema is! int ||
        !readableSchemaVersions.contains(envelopeSchema)) {
      throw CriticalPersistenceException(
        'Unsupported critical-state schema: $envelopeSchema.',
      );
    }
    if (revision is! int || revision < 1) {
      throw const CriticalPersistenceException(
        'Critical record revision is invalid.',
      );
    }
    if (slot != expectedSlot || (slot != 'a' && slot != 'b')) {
      throw const CriticalPersistenceException(
        'Critical record slot binding is invalid.',
      );
    }
    if (rawPayload is! Map || hash is! String) {
      throw const CriticalPersistenceException(
        'Critical record payload or integrity hash is invalid.',
      );
    }
    final payload = rawPayload.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final expectedHash = criticalPayloadHash(
      domain: domain,
      schemaVersion: envelopeSchema,
      revision: revision,
      payload: payload,
    );
    if (hash != expectedHash) {
      throw const CriticalPersistenceException(
        'Critical record integrity validation failed.',
      );
    }
    return CriticalCommittedRecord(
      domain: domain,
      schemaVersion: envelopeSchema,
      revision: revision,
      slot: slot,
      payload: payload,
      payloadHash: hash,
    );
  }

  static Map<String, dynamic> _decodeMap(String value, String label) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map) {
        throw FormatException('$label is not a JSON object.');
      }
      return decoded.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    } catch (error) {
      throw CriticalPersistenceException('Cannot decode $label: $error');
    }
  }
}

String canonicalJson(Object? value) => jsonEncode(_canonicalize(value));

dynamic _canonicalize(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();
    return <String, dynamic>{
      for (final key in keys) key: _canonicalize(value[key]),
    };
  }
  if (value is Iterable) {
    return value.map(_canonicalize).toList(growable: false);
  }
  if (value == null || value is String || value is num || value is bool) {
    return value;
  }
  throw CriticalPersistenceException(
    'Unsupported critical payload value: ${value.runtimeType}.',
  );
}

String criticalPayloadHash({
  required String domain,
  required int schemaVersion,
  required int revision,
  required Map<String, dynamic> payload,
}) {
  final source = canonicalJson(<String, dynamic>{
    'domain': domain,
    'schemaVersion': schemaVersion,
    'revision': revision,
    'payload': payload,
  });
  var hash = 0x811c9dc5;
  for (final unit in utf8.encode(source)) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
