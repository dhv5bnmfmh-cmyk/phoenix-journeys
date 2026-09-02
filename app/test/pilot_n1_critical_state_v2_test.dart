import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/critical_persistence_store.dart';
import 'package:phoenix_journeys/services/journey_access_policy.dart';
import 'package:phoenix_journeys/state/access_controlled_app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _summerPalaceId = 'beijing-summer-palace';
const _seed =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('schema v1 migrates atomically to v2 and maps legacy steps 3, 4, 5',
      () async {
    for (final legacyStep in <int>[3, 4, 5]) {
      final sourceBackend = _MemoryCriticalBackend();
      final source = await _newState(sourceBackend);
      final payload = _deepCopy(await source.readCommittedCriticalPayload());
      final journey = _journeyPayload(payload);

      journey
        ..remove('flowVersion')
        ..remove('compositeSubstage')
        ..remove('challengeAttemptSequence')
        ..remove('challengeAttemptId')
        ..remove('guideFeedbackInputIdentity')
        ..remove('writingFeedbackInputIdentity')
        ..['step'] = legacyStep
        ..['furthestStep'] = legacyStep
        ..['completed'] = legacyStep == 5
        ..['wonderDraft'] = legacyStep >= 3 ? '我看见修复留下的选择。' : ''
        ..['expressDraft'] = legacyStep >= 4 ? '她先捡照片，所以错过光线。' : ''
        ..['guideFeedbackReply'] = legacyStep >= 4 ? '继续说明选择与后果。' : ''
        ..['writingFeedbackCorrected'] =
            legacyStep >= 4 ? '她先捡回照片，因此错过光线。' : ''
        ..['writingFeedbackExplanation'] = legacyStep >= 4 ? '因果顺序清楚。' : ''
        ..['writingFeedbackNatural'] = legacyStep >= 4 ? '这个表达很自然。' : ''
        ..['writingFeedbackEncouragement'] = legacyStep >= 4 ? '继续保持。' : '';

      final stamps = (payload['earnedJourneyStampIds'] as List<dynamic>)
          .cast<String>()
          .toSet();
      if (legacyStep == 5) stamps.add(_summerPalaceId);
      payload['earnedJourneyStampIds'] = stamps.toList()..sort();

      final backend = _MemoryCriticalBackend();
      await CriticalPersistenceStore(
        backend,
        schemaVersion:
            CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
        readableSchemaVersions: const <int>{
          CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
        },
      ).commitInitial(payload);

      final restored = await _newState(backend);
      expect(restored.loadStatus, AppLoadStatus.ready, reason: 'step $legacyStep');
      expect(restored.activeJourneyId, 'beijing-forbidden-city');
      expect(
        restored.criticalSchemaVersion,
        CriticalPersistenceStore.phoenixCriticalStateSchemaVersion,
      );
      final migratedJourney = _journeyPayload(
        _deepCopy(await restored.readCommittedCriticalPayload()),
      );
      expect(migratedJourney['flowVersion'], summerPalaceJourneyFlowVersion);
      expect(
        migratedJourney['compositeSubstage'],
        switch (legacyStep) {
          3 => 'reflection',
          4 => 'memory',
          _ => 'completed',
        },
        reason: 'step $legacyStep',
      );
      if (legacyStep == 4) {
        expect(migratedJourney['guideFeedbackInputIdentity'], isNotEmpty);
        expect(migratedJourney['writingFeedbackInputIdentity'], isNotEmpty);
      }
    }
  });

  test('interrupted v1 to v2 migration keeps v1 authoritative and retries',
      () async {
    final sourceBackend = _MemoryCriticalBackend();
    final source = await _newState(sourceBackend);
    final payload = _deepCopy(await source.readCommittedCriticalPayload());
    _journeyPayload(payload)
      ..remove('flowVersion')
      ..remove('compositeSubstage')
      ..['step'] = 3
      ..['furthestStep'] = 3
      ..['completed'] = false;

    final backend = _MemoryCriticalBackend();
    await CriticalPersistenceStore(
      backend,
      schemaVersion:
          CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
      readableSchemaVersions: const <int>{
        CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
      },
    ).commitInitial(payload);

    backend.failWriteNumber = backend.writeCount + 2;
    final interrupted = await _newState(backend);
    expect(interrupted.loadStatus, AppLoadStatus.error);

    final authoritative = await CriticalPersistenceStore(backend).readCommitted();
    expect(
      authoritative?.schemaVersion,
      CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
    );
    expect(authoritative?.payload['activeJourneyId'], 'beijing-forbidden-city');

    backend.failWriteNumber = null;
    final retried = await _newState(backend);
    expect(retried.loadStatus, AppLoadStatus.ready);
    expect(
      retried.criticalSchemaVersion,
      CriticalPersistenceStore.phoenixCriticalStateSchemaVersion,
    );
    final migratedJourney = _journeyPayload(
      _deepCopy(await retried.readCommittedCriticalPayload()),
    );
    expect(migratedJourney['compositeSubstage'], 'reflection');
  });

  test('hidden Pilot N1 feedback identities survive migration and reopen',
      () async {
    const wonder = '她选择先保存旧照片。';
    const express = '她先捡回照片，因此错过最佳光线。';
    final sourceBackend = _MemoryCriticalBackend();
    final source = await _newState(sourceBackend);
    final payload = _deepCopy(await source.readCommittedCriticalPayload());
    _journeyPayload(payload)
      ..remove('flowVersion')
      ..remove('compositeSubstage')
      ..remove('guideFeedbackInputIdentity')
      ..remove('writingFeedbackInputIdentity')
      ..['step'] = 4
      ..['furthestStep'] = 4
      ..['completed'] = false
      ..['wonderDraft'] = wonder
      ..['expressDraft'] = express
      ..['guideFeedbackReply'] = '这个选择连接了关系与修复。'
      ..['writingFeedbackCorrected'] = '她先捡回照片，因此错过了最佳光线。'
      ..['writingFeedbackExplanation'] = '“因此”明确连接选择与后果。'
      ..['writingFeedbackNatural'] = '她为保存旧照片放弃了最佳光线。'
      ..['writingFeedbackEncouragement'] = '因果关系表达得很清楚。';

    final backend = _MemoryCriticalBackend();
    await CriticalPersistenceStore(
      backend,
      schemaVersion:
          CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
      readableSchemaVersions: const <int>{
        CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion,
      },
    ).commitInitial(payload);

    final first = await _newState(backend);
    expect(first.loadStatus, AppLoadStatus.ready);
    expect(first.activeJourneyId, 'beijing-forbidden-city');

    final firstHidden = _journeyPayload(
      _deepCopy(await first.readCommittedCriticalPayload()),
    );
    final reflectionIdentity = journeyFeedbackInputIdentity(wonder);
    final writingIdentity = journeyFeedbackInputIdentity(express);
    expect(firstHidden['compositeSubstage'], 'memory');
    expect(firstHidden['guideFeedbackInputIdentity'], reflectionIdentity);
    expect(firstHidden['writingFeedbackInputIdentity'], writingIdentity);

    final reopened = await _newState(backend);
    expect(reopened.loadStatus, AppLoadStatus.ready);
    final reopenedHidden = _journeyPayload(
      _deepCopy(await reopened.readCommittedCriticalPayload()),
    );
    expect(reopenedHidden['guideFeedbackInputIdentity'], reflectionIdentity);
    expect(reopenedHidden['writingFeedbackInputIdentity'], writingIdentity);
    expect(reopenedHidden['compositeSubstage'], 'memory');
  });
}

Future<AccessControlledAppState> _newState(
  _MemoryCriticalBackend backend,
) async {
  final preferences = await SharedPreferences.getInstance();
  final state = AccessControlledAppState(
    clock: () => DateTime(2026, 8, 5, 9),
    preferencesLoader: () async => preferences,
    accessMode: JourneyAccessMode.developmentExperience,
    explorerSeedGenerator: () => _seed,
    criticalPersistenceBackend: backend,
  );
  await state.load();
  return state;
}

Map<String, dynamic> _deepCopy(Map<String, dynamic> value) {
  return (jsonDecode(jsonEncode(value)) as Map<dynamic, dynamic>).map(
    (key, item) => MapEntry(key.toString(), item),
  );
}

Map<String, dynamic> _journeyPayload(Map<String, dynamic> payload) {
  final journeys = payload['journeys'] as Map<dynamic, dynamic>;
  return (journeys[_summerPalaceId] as Map<dynamic, dynamic>).map(
    (key, item) => MapEntry(key.toString(), item),
  )..also((copy) => journeys[_summerPalaceId] = copy);
}

extension _Also<T> on T {
  T also(void Function(T value) action) {
    action(this);
    return this;
  }
}

class _MemoryCriticalBackend implements CriticalPersistenceBackend {
  final Map<String, String> values = <String, String>{};
  int writeCount = 0;
  int? failWriteNumber;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<bool> write(String key, String value) async {
    writeCount += 1;
    if (writeCount == failWriteNumber) return false;
    values[key] = value;
    return true;
  }
}
