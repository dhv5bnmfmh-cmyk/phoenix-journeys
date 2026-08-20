import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_level_catalog.dart';
import '../services/critical_persistence_store.dart';
import '../services/journey_access_policy.dart';
import '../services/journey_location_binding.dart';
import 'app_state.dart';

export 'app_state.dart';

class JourneyAccessDeniedException implements Exception {
  const JourneyAccessDeniedException({
    required this.journeyId,
    required this.reason,
  });

  final String journeyId;
  final String reason;

  String get userMessage => '这段旅程目前尚未开放。';

  @override
  String toString() =>
      'JourneyAccessDeniedException(journeyId: $journeyId, reason: $reason)';
}

typedef ExplorerSeedPersister = Future<bool> Function(
  SharedPreferences preferences,
  String seed,
  int version,
);

class AccessControlledAppState extends AppState {
  // ignore: use_super_parameters
  AccessControlledAppState({
    DateTime Function()? clock,
    Future<SharedPreferences> Function()? preferencesLoader,
    Uri? runtimeUri,
    bool? debugBuild,
    JourneyAccessMode? accessMode,
    String Function()? explorerSeedGenerator,
    ExplorerSeedPersister? explorerSeedPersister,
    CriticalPersistenceBackend? criticalPersistenceBackend,
  })  : _clock = clock ?? DateTime.now,
        _preferencesLoader =
            preferencesLoader ?? SharedPreferences.getInstance,
        _runtimeUri = runtimeUri ?? Uri.base,
        _debugBuild = debugBuild ?? kDebugMode,
        _forcedAccessMode = accessMode,
        _explorerSeedGenerator =
            explorerSeedGenerator ?? _generateOpaqueExplorerSeed,
        _legacySeedCommitGuard = explorerSeedPersister,
        _injectedCriticalBackend = criticalPersistenceBackend,
        super(clock: clock, preferencesLoader: preferencesLoader);

  @visibleForTesting
  static const String explorerSeedStorageKey = 'explorer.localSeed';
  @visibleForTesting
  static const String explorerSeedVersionStorageKey =
      'explorer.localSeedVersion';
  @visibleForTesting
  static const int explorerSeedVersion = 1;

  static const String _activeJourneyIdStorageKey = 'activeJourney.id';
  static const String _activeJourneyNamespaceStorageKey =
      'activeJourney.storageNamespace';
  static const String _activeJourneyVersionStorageKey =
      'activeJourney.identityVersion';
  static const int _activeJourneyIdentityVersion = 1;
  static const String _trustedPreviewAccount = '7hn5tyrjgh';

  static const Set<String> heldSpecialJourneyIds = <String>{
    'changan-last-bus',
    'tide-letter',
    'arcade-lost-property',
    'tea-horse-echo',
    'ice-city-star-map',
  };

  static const Set<String> _releasedSpecialJourneyIds = <String>{
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  };

  static final Set<String> _regularJourneyIds =
      Set<String>.unmodifiable(dailyJourneyIds);

  static final Set<String> _registeredJourneyIds = Set<String>.unmodifiable(
    <String>{
      ...dailyJourneyIds,
      ..._releasedSpecialJourneyIds,
      ...heldSpecialJourneyIds,
    },
  );

  static bool _isRegisteredJourneyId(String journeyId) =>
      _registeredJourneyIds.contains(journeyId);

  static String _storageNamespaceForJourneyId(String journeyId) {
    final separator = journeyId.indexOf('-');
    final cityId =
        separator <= 0 ? journeyId : journeyId.substring(0, separator);
    final destinationId = journeyId == 'guangzhou-chen-clan-academy'
        ? 'chen-clan-ancestral-hall'
        : separator < 0 || separator == journeyId.length - 1
            ? journeyId
            : journeyId.substring(separator + 1);
    return 'journey.$cityId/$destinationId';
  }

  static String _legacyStorageNamespaceForJourneyId(String journeyId) =>
      'journey.$journeyId';

  final DateTime Function() _clock;
  final Future<SharedPreferences> Function() _preferencesLoader;
  final Uri _runtimeUri;
  final bool _debugBuild;
  final JourneyAccessMode? _forcedAccessMode;
  final String Function() _explorerSeedGenerator;
  final ExplorerSeedPersister? _legacySeedCommitGuard;
  final CriticalPersistenceBackend? _injectedCriticalBackend;

  CriticalPersistenceStore? _criticalStore;
  _PhoenixCriticalSnapshot? _committedSnapshot;
  SharedPreferences? _preferences;
  bool _activeIdentityReady = false;
  int _criticalStep = 0;
  int _criticalFurthestStep = 0;
  final Map<String, String> _criticalNarrationSignatures = <String, String>{};
  final Map<String, int> _criticalNarrationOffsets = <String, int>{};

  String? criticalPersistenceFailureReason;
  String? explorerSeedFailureReason;
  int criticalRevision = 0;
  int criticalSchemaVersion = 0;

  String get localExplorerSeed => _committedSnapshot?.explorerSeed ?? '';

  JourneyAccessMode get journeyAccessMode =>
      _forcedAccessMode ??
      ((_debugBuild || _isTrustedPreviewUri(_runtimeUri))
          ? JourneyAccessMode.developmentExperience
          : JourneyAccessMode.productionFreeExplorer);

  bool get isDevelopmentExperience =>
      journeyAccessMode == JourneyAccessMode.developmentExperience;

  List<String> get eligibleRegularJourneyIds => dailyJourneyIds;

  DailyJourneyAssignment get dailyAssignment {
    if (!_isValidExplorerSeed(localExplorerSeed)) {
      throw StateError('A valid committed local Explorer Seed is required.');
    }
    return JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: eligibleRegularJourneyIds,
      explorerSeed: localExplorerSeed,
      localDate: _clock(),
    );
  }

  Set<JourneyReleaseSlot> get releasedDailySlots {
    final localNow = _clock();
    return <JourneyReleaseSlot>{
      JourneyReleaseSlot.morning,
      if (localNow.hour >= 12) JourneyReleaseSlot.afternoon,
    };
  }

  JourneyReleaseSlot get currentDailySlot =>
      _clock().hour >= 12
          ? JourneyReleaseSlot.afternoon
          : JourneyReleaseSlot.morning;

  String get morningDailyJourneyId => dailyAssignment.morningJourneyId;
  String get afternoonDailyJourneyId => dailyAssignment.afternoonJourneyId;

  Set<String> get releasedDailyJourneyIds =>
      dailyAssignment.unlockedJourneyIds(releasedDailySlots);

  Set<String> get policyAccessibleRegularJourneyIds =>
      JourneyAccessPolicy.accessibleJourneyIds(
        mode: journeyAccessMode,
        allJourneyIds: eligibleRegularJourneyIds,
        freeAssignment: dailyAssignment,
        releasedFreeSlots: releasedDailySlots,
      );

  @override
  DailyJourneyExperience get todayJourney {
    if (!_isValidExplorerSeed(localExplorerSeed)) {
      throw StateError(
        'Daily Journey cannot be resolved without a valid committed '
        'local Explorer Seed.',
      );
    }
    return requireDailyJourneyExperience(
      dailyAssignment.journeyIdFor(currentDailySlot),
    );
  }

  @override
  int get journeyStep => _criticalStep;

  @override
  int get journeyFurthestStep => _criticalFurthestStep;

  @override
  int get beijingJourneyStep => _criticalStep;

  @override
  int get beijingJourneyFurthestStep => _criticalFurthestStep;

  @override
  bool get hasJourneyInProgress => !journeyCompleted && _criticalStep > 0;

  @override
  double get journeyProgress {
    if (journeyCompleted) return 1;
    return (_criticalStep + 1) / (AppState.journeyLastStep + 1);
  }

  @override
  int get journeyProgressPercent => (journeyProgress * 100).round();

  @override
  double get beijingJourneyProgress => journeyProgress;

  @override
  int get beijingJourneyProgressPercent => journeyProgressPercent;

  @override
  String get journeyStepLabel => displayText(
        _journeyLabelFor(_criticalStep, journeyCompositeSubstage),
      );

  @override
  String get journeyFurthestStepLabel => displayText(
        AppState.journeyStepLabels[_safeJourneyStep(_criticalFurthestStep)],
      );

  String _journeyLabelFor(int step, JourneyCompositeSubstage substage) {
    if (activeJourneyId == 'beijing-summer-palace') {
      if (step == 3) {
        return substage == JourneyCompositeSubstage.challenge ? '挑战' : '思考';
      }
      if (step == 4) {
        return substage == JourneyCompositeSubstage.memory ? '回忆' : '表达';
      }
    }
    return AppState.journeyStepLabels[_safeJourneyStep(step)];
  }

  @override
  String get beijingJourneyStepLabel => journeyStepLabel;

  @override
  String get beijingJourneyFurthestStepLabel => journeyFurthestStepLabel;

  @override
  String? journeyNarrationSignatureFor(String contentId) =>
      _criticalNarrationSignatures[contentId];

  @override
  int journeyNarrationOffsetFor(String contentId) =>
      _criticalNarrationOffsets[contentId] ?? 0;

  bool canOpenJourney(String journeyId) {
    final journey = journeyExperienceById(journeyId);
    if (journey == null) return false;

    if (_isRegularJourneyId(journeyId)) {
      return policyAccessibleRegularJourneyIds.contains(journeyId);
    }

    if (isDevelopmentExperience) return true;
    if (heldSpecialJourneyIds.contains(journeyId)) return false;
    return isSpecialJourneyUnlocked(journeyId);
  }

  bool canResumeActiveJourney(String journeyId) {
    if (!_activeIdentityReady || journeyId != activeJourneyId) return false;
    if (!_isRegularJourneyId(journeyId)) return canOpenJourney(journeyId);
    if (policyAccessibleRegularJourneyIds.contains(journeyId)) return true;
    return _hasResumableActiveJourney;
  }

  String? dailySlotLabelForJourney(String journeyId) {
    final assignment = dailyAssignment;
    final isMorning = assignment.morningJourneyId == journeyId;
    final isAfternoon = assignment.afternoonJourneyId == journeyId;
    if (isMorning && isAfternoon) return '全天旅程';
    if (isMorning) return '上午旅程';
    if (isAfternoon) return '下午旅程';
    return null;
  }

  bool isDailyJourneyReleased(String journeyId) =>
      releasedDailyJourneyIds.contains(journeyId);

  @override
  Future<void> load() async {
    loadStatus = AppLoadStatus.loading;
    loadErrorMessage = null;
    activeJourneyRestoreFailureId = null;
    activeJourneyRestoreFailureReason = null;
    explorerSeedFailureReason = null;
    criticalPersistenceFailureReason = null;
    _activeIdentityReady = false;
    notifyListeners();

    try {
      final preferences = await _preferencesLoader();
      _preferences = preferences;
      _restoreNonCriticalPreferences(preferences);
      _criticalStore ??= CriticalPersistenceStore(
        _injectedCriticalBackend ??
            SharedPreferencesCriticalPersistenceBackend(preferences),
      );

      var committed = await _criticalStore!.readCommitted();
      if (committed == null) {
        final legacy = await _buildLegacySnapshot(preferences);
        legacy.snapshot.validate();
        if (legacy.generatedSeed && _legacySeedCommitGuard != null) {
          final allowed = await _legacySeedCommitGuard(
            preferences,
            legacy.snapshot.explorerSeed,
            explorerSeedVersion,
          );
          if (!allowed) {
            _failExplorerSeed('Explorer Seed persistence failed.');
          }
        }
        committed = await _criticalStore!.commitInitial(
          legacy.snapshot.toJson(),
        );
      } else if (committed.schemaVersion ==
          CriticalPersistenceStore.phoenixCriticalStateLegacySchemaVersion) {
        final migrated = _PhoenixCriticalSnapshot.fromJson(committed.payload)
            .migratedToV2()
          ..validate();
        committed = await _criticalStore!.commitPayload(
          migrated.toJson(),
          expectedRevision: committed.revision,
        );
      }

      if (committed.schemaVersion !=
          CriticalPersistenceStore.phoenixCriticalStateSchemaVersion) {
        throw CriticalPersistenceException(
          'Critical state did not reach schema v2: '
          '${committed.schemaVersion}.',
        );
      }
      final snapshot = _PhoenixCriticalSnapshot.fromJson(committed.payload)
        ..validate();
      _applyCommitted(
        snapshot,
        revision: committed.revision,
        schemaVersion: committed.schemaVersion,
      );

      if (!_canRestoreActiveJourney(activeJourneyId)) {
        throw StateError(
          'Persisted active Journey is not eligible for safe restore.',
        );
      }

      _activeIdentityReady = true;
      loadStatus = AppLoadStatus.ready;
    } catch (error, stackTrace) {
      final reason = error.toString();
      criticalPersistenceFailureReason = reason;
      if (reason.contains('Explorer Seed')) {
        explorerSeedFailureReason ??= reason;
      }
      debugPrint('Failed to restore committed Phoenix state: $error');
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = activeJourneyRestoreFailureId == null
          ? '无法安全恢复本机关键状态，上一份记录仍被保留。请重新尝试。'
          : '无法安全恢复旅程“${activeJourneyRestoreFailureId!}”，'
              '没有加载其他旅程。请重新尝试。';
    }

    notifyListeners();
  }

  @override
  Future<void> activateJourney(String journeyId) async {
    final journey = requireDailyJourneyExperience(journeyId);
    if (!canOpenJourney(journeyId) && !canResumeActiveJourney(journeyId)) {
      throw JourneyAccessDeniedException(
        journeyId: journeyId,
        reason: _accessDenialReason(journeyId),
      );
    }
    final binding = requireJourneyLocation(journey.id);

    await _transact<void>((current) {
      if (current.activeJourneyId == journey.id &&
          current.activeJourneyNamespace == binding.storageNamespace) {
        return const _SnapshotMutation<void>.unchanged(null);
      }
      return _SnapshotMutation<void>.changed(
        current.copyWith(
          activeJourneyId: journey.id,
          activeJourneyNamespace: binding.storageNamespace,
        ),
        null,
      );
    });
    _activeIdentityReady = true;
  }

  Future<bool> tryActivateJourney(String journeyId) async {
    try {
      await activateJourney(journeyId);
      return true;
    } on JourneyAccessDeniedException {
      return false;
    }
  }

  @override
  Future<void> refreshDailyJourney() async {
    await activateJourney(todayJourney.id);
  }

  @override
  Future<void> saveJourneyProgress({
    required int step,
    required String wonder,
    required String express,
    required String memory,
    JourneyCompositeSubstage? compositeSubstage,
  }) async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      final safeStep = _safeJourneyStep(step);
      final updated = existing.copyWith(
        flowVersion: journeyFlowVersionFor(journeyId),
        step: safeStep,
        furthestStep: math.max(existing.furthestStep, safeStep).toInt(),
        compositeSubstage: journeyId == 'beijing-summer-palace'
            ? compositeSubstage ?? existing.compositeSubstage
            : JourneyCompositeSubstage.none,
        wonderDraft: wonder,
        expressDraft: express,
        memoryDraft: memory,
        updatedAt: _clock().toIso8601String(),
      );
      return _SnapshotMutation<void>.changed(
        current.withJourney(updated),
        null,
      );
    });
  }

  @override
  Future<String> ensureChallengeAttemptIdentity() async {
    final journeyId = activeJourneyId;
    return _transact<String>((current) {
      final existing = current.requireJourney(journeyId);
      if (existing.challengeAttemptId.isNotEmpty) {
        return _SnapshotMutation<String>.unchanged(
          existing.challengeAttemptId,
        );
      }
      final sequence = existing.challengeAttemptSequence + 1;
      final attemptId =
          '$journeyId:flow-v${existing.flowVersion}:attempt-$sequence';
      return _SnapshotMutation<String>.changed(
        current.withJourney(
          existing.copyWith(
            challengeAttemptSequence: sequence,
            challengeAttemptId: attemptId,
            updatedAt: _clock().toIso8601String(),
          ),
        ),
        attemptId,
      );
    });
  }

  @override
  Future<void> saveJourneyNarrationPosition({
    required String contentId,
    required String contentSignature,
    required int offset,
  }) async {
    final journeyId = activeJourneyId;
    final safeOffset = math.max(0, offset);
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      final signatures = Map<String, String>.from(
        existing.narrationSignatures,
      )..[contentId] = contentSignature;
      final offsets = Map<String, int>.from(existing.narrationOffsets)
        ..[contentId] = safeOffset;
      final updated = existing.copyWith(
        narrationContentId: contentId,
        narrationContentSignature: contentSignature,
        narrationOffset: safeOffset,
        narrationSignatures: signatures,
        narrationOffsets: offsets,
        updatedAt: _clock().toIso8601String(),
      );
      return _SnapshotMutation<void>.changed(
        current.withJourney(updated),
        null,
      );
    });
  }

  @override
  Future<void> clearJourneyNarrationPosition({String? contentId}) async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      if (contentId == null) {
        if (!existing.hasNarration) {
          return const _SnapshotMutation<void>.unchanged(null);
        }
        return _SnapshotMutation<void>.changed(
          current.withJourney(existing.clearNarration()),
          null,
        );
      }

      final signatures = Map<String, String>.from(
        existing.narrationSignatures,
      )..remove(contentId);
      final offsets = Map<String, int>.from(existing.narrationOffsets)
        ..remove(contentId);
      final clearsCurrent = existing.narrationContentId == contentId;
      final updated = existing.copyWith(
        narrationContentId: clearsCurrent
            ? null
            : existing.narrationContentId,
        narrationContentSignature: clearsCurrent
            ? null
            : existing.narrationContentSignature,
        narrationOffset: clearsCurrent ? 0 : existing.narrationOffset,
        narrationSignatures: signatures,
        narrationOffsets: offsets,
        updatedAt: _clock().toIso8601String(),
        replaceNullableNarration: true,
      );
      return _SnapshotMutation<void>.changed(
        current.withJourney(updated),
        null,
      );
    });
  }

  @override
  Future<void> saveGuideFeedback({
    required String reply,
    required bool isOfflineFallback,
    String inputIdentity = '',
  }) async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      final resolvedIdentity = inputIdentity.isNotEmpty
          ? inputIdentity
          : existing.wonderDraft.trim().isNotEmpty
              ? journeyFeedbackInputIdentity(existing.wonderDraft)
              : '';
      return _SnapshotMutation<void>.changed(
        current.withJourney(
          existing.copyWith(
            guideFeedbackReply: reply.trim(),
            guideFeedbackOffline: isOfflineFallback,
            guideFeedbackInputIdentity: resolvedIdentity,
            compositeSubstage: journeyId == 'beijing-summer-palace'
                ? JourneyCompositeSubstage.challenge
                : JourneyCompositeSubstage.none,
            updatedAt: _clock().toIso8601String(),
          ),
        ),
        null,
      );
    });
  }

  @override
  Future<void> clearGuideFeedback() async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      if (existing.guideFeedbackReply.isEmpty &&
          !existing.guideFeedbackOffline &&
          existing.guideFeedbackInputIdentity.isEmpty) {
        return const _SnapshotMutation<void>.unchanged(null);
      }
      return _SnapshotMutation<void>.changed(
        current.withJourney(
          existing.copyWith(
            guideFeedbackReply: '',
            guideFeedbackOffline: false,
            guideFeedbackInputIdentity: '',
            compositeSubstage: journeyId == 'beijing-summer-palace' &&
                    existing.step == 3
                ? JourneyCompositeSubstage.reflection
                : existing.compositeSubstage,
            updatedAt: _clock().toIso8601String(),
          ),
        ),
        null,
      );
    });
  }

  @override
  Future<void> saveWritingFeedback({
    required String corrected,
    required String explanation,
    required String natural,
    required String encouragement,
    required bool isOfflineFallback,
    String inputIdentity = '',
  }) async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      final resolvedIdentity = inputIdentity.isNotEmpty
          ? inputIdentity
          : existing.expressDraft.trim().isNotEmpty
              ? journeyFeedbackInputIdentity(existing.expressDraft)
              : '';
      return _SnapshotMutation<void>.changed(
        current.withJourney(
          existing.copyWith(
            writingFeedbackCorrected: corrected.trim(),
            writingFeedbackExplanation: explanation.trim(),
            writingFeedbackNatural: natural.trim(),
            writingFeedbackEncouragement: encouragement.trim(),
            writingFeedbackOffline: isOfflineFallback,
            writingFeedbackInputIdentity: resolvedIdentity,
            compositeSubstage: journeyId == 'beijing-summer-palace'
                ? JourneyCompositeSubstage.memory
                : JourneyCompositeSubstage.none,
            updatedAt: _clock().toIso8601String(),
          ),
        ),
        null,
      );
    });
  }

  @override
  Future<void> clearWritingFeedback() async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      if (!existing.hasWritingFeedback &&
          existing.writingFeedbackInputIdentity.isEmpty) {
        return const _SnapshotMutation<void>.unchanged(null);
      }
      return _SnapshotMutation<void>.changed(
        current.withJourney(
          existing.copyWith(
            writingFeedbackCorrected: '',
            writingFeedbackExplanation: '',
            writingFeedbackNatural: '',
            writingFeedbackEncouragement: '',
            writingFeedbackOffline: false,
            writingFeedbackInputIdentity: '',
            compositeSubstage: journeyId == 'beijing-summer-palace' &&
                    existing.step == 4
                ? JourneyCompositeSubstage.writing
                : existing.compositeSubstage,
            updatedAt: _clock().toIso8601String(),
          ),
        ),
        null,
      );
    });
  }

  @override
  Future<void> restartJourney() async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      final restarted = existing.copyWith(
        flowVersion: journeyFlowVersionFor(journeyId),
        step: 0,
        furthestStep: 0,
        completed: false,
        compositeSubstage: JourneyCompositeSubstage.none,
        challengeAttemptId: '',
        wonderDraft: '',
        expressDraft: '',
        memoryDraft: '',
        guideFeedbackReply: '',
        guideFeedbackOffline: false,
        guideFeedbackInputIdentity: '',
        writingFeedbackCorrected: '',
        writingFeedbackExplanation: '',
        writingFeedbackNatural: '',
        writingFeedbackEncouragement: '',
        writingFeedbackOffline: false,
        writingFeedbackInputIdentity: '',
        updatedAt: _clock().toIso8601String(),
      ).clearNarration();
      return _SnapshotMutation<void>.changed(
        current.withJourney(restarted),
        null,
      );
    });
  }

  @override
  Future<void> completeJourney(String memory) async {
    final journeyId = activeJourneyId;
    await _transact<void>((current) {
      final existing = current.requireJourney(journeyId);
      if (existing.completed &&
          current.earnedJourneyStampIds.contains(journeyId)) {
        return const _SnapshotMutation<void>.unchanged(null);
      }

      final stamps = Set<String>.from(current.earnedJourneyStampIds)
        ..add(journeyId);
      final nextMemories = List<String>.from(current.memories);
      final trimmed = memory.trim();
      if (trimmed.isNotEmpty) {
        final entry =
            '${requireDailyJourneyExperience(journeyId).stampTitle}｜$trimmed';
        if (!nextMemories.contains(entry)) nextMemories.insert(0, entry);
      }
      final completedJourney = existing.copyWith(
        step: AppState.journeyLastStep,
        furthestStep: AppState.journeyLastStep,
        completed: true,
        compositeSubstage: journeyId == 'beijing-summer-palace'
            ? JourneyCompositeSubstage.completed
            : JourneyCompositeSubstage.none,
        challengeAttemptId: '',
        wonderDraft: '',
        expressDraft: '',
        memoryDraft: '',
        updatedAt: _clock().toIso8601String(),
      ).clearNarration();
      return _SnapshotMutation<void>.changed(
        current.copyWith(
          journeys: <String, _JourneyCriticalState>{
            ...current.journeys,
            journeyId: completedJourney,
          },
          earnedJourneyStampIds: stamps.toList()..sort(),
          memories: nextMemories,
        ),
        null,
      );
    });
  }

  @override
  Future<bool> awardChallengeRewardOnce({
    required String reward,
    required String awardId,
  }) async {
    return _transact<bool>((current) {
      if (current.awardedChallengeIds.contains(awardId)) {
        return const _SnapshotMutation<bool>.unchanged(false);
      }
      final awards = Set<String>.from(current.awardedChallengeIds)
        ..add(awardId);
      var gold = current.goldCoins;
      var silver = current.silverCoins;
      var bronze = current.bronzeCoins;
      var fragments = current.silverFragments;
      switch (reward) {
        case '金币':
          gold += 1;
        case '银币':
          silver += 1;
        case '铜币':
          bronze += 1;
        default:
          fragments += 1;
      }
      return _SnapshotMutation<bool>.changed(
        current.copyWith(
          goldCoins: gold,
          silverCoins: silver,
          bronzeCoins: bronze,
          silverFragments: fragments,
          awardedChallengeIds: awards.toList()..sort(),
        ),
        true,
      );
    });
  }

  @override
  Future<void> awardChallengeReward(String reward) async {
    await awardChallengeRewardOnce(
      reward: reward,
      awardId:
          'legacy:${_clock().microsecondsSinceEpoch}:${awardedChallengeIds.length}',
    );
  }

  @override
  Future<SpecialJourneyUnlockResult> unlockSpecialJourney({
    required String journeyId,
    required String currency,
    required int cost,
  }) async {
    requireDailyJourneyExperience(journeyId);
    return _transact<SpecialJourneyUnlockResult>((current) {
      final balance = current.walletBalance(currency);
      if (current.unlockedSpecialJourneyIds.contains(journeyId)) {
        return _SnapshotMutation<SpecialJourneyUnlockResult>.unchanged(
          SpecialJourneyUnlockResult(
            status: SpecialJourneyUnlockStatus.alreadyUnlocked,
            currency: currency,
            cost: cost,
            balance: balance,
          ),
        );
      }
      if (cost < 0 || balance < cost) {
        return _SnapshotMutation<SpecialJourneyUnlockResult>.unchanged(
          SpecialJourneyUnlockResult(
            status: SpecialJourneyUnlockStatus.insufficientFunds,
            currency: currency,
            cost: cost,
            balance: balance,
          ),
        );
      }

      var gold = current.goldCoins;
      var silver = current.silverCoins;
      var bronze = current.bronzeCoins;
      var fragments = current.silverFragments;
      switch (currency) {
        case '金币':
          gold -= cost;
        case '银币':
          silver -= cost;
        case '铜币':
          bronze -= cost;
        default:
          fragments -= cost;
      }
      final unlocked = Set<String>.from(current.unlockedSpecialJourneyIds)
        ..add(journeyId);
      final candidate = current.copyWith(
        goldCoins: gold,
        silverCoins: silver,
        bronzeCoins: bronze,
        silverFragments: fragments,
        unlockedSpecialJourneyIds: unlocked.toList()..sort(),
      );
      return _SnapshotMutation<SpecialJourneyUnlockResult>.changed(
        candidate,
        SpecialJourneyUnlockResult(
          status: SpecialJourneyUnlockStatus.unlocked,
          currency: currency,
          cost: cost,
          balance: candidate.walletBalance(currency),
        ),
      );
    });
  }

  @visibleForTesting
  Future<Map<String, dynamic>> readCommittedCriticalPayload() async {
    final record = await _criticalStore?.readCommitted();
    if (record == null) {
      throw StateError('Critical state is not committed.');
    }
    return record.payload;
  }

  @visibleForTesting
  Future<CriticalCommittedRecord> readCommittedCriticalRecord() async {
    final record = await _criticalStore?.readCommitted();
    if (record == null) {
      throw StateError('Critical state is not committed.');
    }
    return record;
  }

  Future<T> _transact<T>(
    _SnapshotMutation<T> Function(_PhoenixCriticalSnapshot current) build,
  ) async {
    final store = _criticalStore;
    if (store == null || _committedSnapshot == null) {
      throw const CriticalPersistenceException(
        'Critical state is not ready for mutation.',
      );
    }

    try {
      final transaction = await store.transact<T>((record) {
        if (record.schemaVersion !=
            CriticalPersistenceStore.phoenixCriticalStateSchemaVersion) {
          throw CriticalPersistenceException(
            'Mutation requires critical schema v2, found '
            '${record.schemaVersion}.',
          );
        }
        final current = _PhoenixCriticalSnapshot.fromJson(record.payload)
          ..validate();
        final mutation = build(current);
        if (!mutation.changed) {
          return CriticalMutation<T>.unchanged(result: mutation.result);
        }
        final candidate = mutation.snapshot!;
        candidate.validate();
        return CriticalMutation<T>.changed(
          payload: candidate.toJson(),
          result: mutation.result,
        );
      });
      final committed = _PhoenixCriticalSnapshot.fromJson(
        transaction.record.payload,
      )..validate();
      if (transaction.committed) {
        _applyCommitted(
          committed,
          revision: transaction.record.revision,
          schemaVersion: transaction.record.schemaVersion,
        );
        notifyListeners();
      }
      return transaction.result;
    } catch (error) {
      criticalPersistenceFailureReason = error.toString();
      rethrow;
    }
  }

  void _applyCommitted(
    _PhoenixCriticalSnapshot snapshot, {
    required int revision,
    required int schemaVersion,
  }) {
    _committedSnapshot = snapshot;
    criticalRevision = revision;
    criticalSchemaVersion = schemaVersion;
    activeJourneyId = snapshot.activeJourneyId;
    activeJourneyRestoreFailureId = null;
    activeJourneyRestoreFailureReason = null;

    memories
      ..clear()
      ..addAll(snapshot.memories);
    earnedJourneyStampIds
      ..clear()
      ..addAll(snapshot.earnedJourneyStampIds);
    goldCoins = snapshot.goldCoins;
    silverCoins = snapshot.silverCoins;
    bronzeCoins = snapshot.bronzeCoins;
    silverFragments = snapshot.silverFragments;
    awardedChallengeIds
      ..clear()
      ..addAll(snapshot.awardedChallengeIds);
    unlockedSpecialJourneyIds
      ..clear()
      ..addAll(snapshot.unlockedSpecialJourneyIds);

    final journey = snapshot.requireJourney(snapshot.activeJourneyId);
    _criticalStep = journey.step;
    _criticalFurthestStep = journey.furthestStep;
    journeyCompleted = journey.completed;
    journeyFlowVersion = journey.flowVersion;
    journeyCompositeSubstage = journey.compositeSubstage;
    journeyChallengeAttemptSequence = journey.challengeAttemptSequence;
    journeyChallengeAttemptId = journey.challengeAttemptId;
    wonderDraft = journey.wonderDraft;
    expressDraft = journey.expressDraft;
    memoryDraft = journey.memoryDraft;
    guideFeedbackReply = journey.guideFeedbackReply;
    guideFeedbackOffline = journey.guideFeedbackOffline;
    guideFeedbackInputIdentity = journey.guideFeedbackInputIdentity;
    writingFeedbackCorrected = journey.writingFeedbackCorrected;
    writingFeedbackExplanation = journey.writingFeedbackExplanation;
    writingFeedbackNatural = journey.writingFeedbackNatural;
    writingFeedbackEncouragement = journey.writingFeedbackEncouragement;
    writingFeedbackOffline = journey.writingFeedbackOffline;
    writingFeedbackInputIdentity = journey.writingFeedbackInputIdentity;
    journeyNarrationContentId = journey.narrationContentId;
    journeyNarrationContentSignature = journey.narrationContentSignature;
    journeyNarrationOffset = journey.narrationOffset;
    _criticalNarrationSignatures
      ..clear()
      ..addAll(journey.narrationSignatures);
    _criticalNarrationOffsets
      ..clear()
      ..addAll(journey.narrationOffsets);
    journeyUpdatedAt = DateTime.tryParse(journey.updatedAt ?? '');

    final preferences = _preferences;
    if (preferences != null) {
      final currentNamespace = _storageNamespaceForJourneyId(activeJourneyId);
      final legacyNamespace =
          _legacyStorageNamespaceForJourneyId(activeJourneyId);
      final storedDifficulty =
          preferences.getString('$currentNamespace.difficulty') ??
              preferences.getString('$legacyNamespace.difficulty');
      journeyDifficulty = parseJourneyDifficulty(storedDifficulty);
      journeyDifficultyChosen = storedDifficulty != null;
    }
  }

  void _restoreNonCriticalPreferences(SharedPreferences preferences) {
    scriptMode = preferences.getBool('traditional') == true
        ? ScriptMode.traditional
        : ScriptMode.simplified;
    translationLanguage =
        preferences.getString('translationLanguage') ?? '越南语';
    savedWords
      ..clear()
      ..addAll(preferences.getStringList('savedWords') ?? <String>[]);
  }

  Future<({bool generatedSeed, _PhoenixCriticalSnapshot snapshot})>
      _buildLegacySnapshot(SharedPreferences preferences) async {
    final hasSeed = preferences.containsKey(explorerSeedStorageKey);
    final hasSeedVersion =
        preferences.containsKey(explorerSeedVersionStorageKey);
    var generatedSeed = false;
    late final String seed;

    if (!hasSeed && !hasSeedVersion) {
      generatedSeed = true;
      seed = _explorerSeedGenerator();
      if (!_isValidExplorerSeed(seed)) {
        _failExplorerSeed('Generated Explorer Seed is invalid.');
      }
    } else {
      if (!hasSeed || !hasSeedVersion) {
        _failExplorerSeed('Explorer Seed record is incomplete.');
      }
      seed = preferences.getString(explorerSeedStorageKey) ?? '';
      final version = preferences.getInt(explorerSeedVersionStorageKey);
      if (version != explorerSeedVersion) {
        _failExplorerSeed(
          'Explorer Seed version is missing or unsupported: $version.',
        );
      }
      if (!_isValidExplorerSeed(seed)) {
        _failExplorerSeed('Persisted Explorer Seed is empty or corrupt.');
      }
    }

    final hasActiveId = preferences.containsKey(_activeJourneyIdStorageKey);
    final hasActiveNamespace =
        preferences.containsKey(_activeJourneyNamespaceStorageKey);
    final hasActiveVersion =
        preferences.containsKey(_activeJourneyVersionStorageKey);

    late final String initialJourneyId;
    late final String initialNamespace;
    if (!hasActiveId && !hasActiveNamespace && !hasActiveVersion) {
      final assignment = JourneyAccessPolicy.assignDailyJourneys(
        journeyIds: eligibleRegularJourneyIds,
        explorerSeed: seed,
        localDate: _clock(),
      );
      initialJourneyId = assignment.journeyIdFor(currentDailySlot);
      initialNamespace = _storageNamespaceForJourneyId(initialJourneyId);
    } else {
      if (!hasActiveId || !hasActiveNamespace || !hasActiveVersion) {
        final requested =
            preferences.getString(_activeJourneyIdStorageKey) ?? '';
        _failActiveIdentity(
          requested,
          'Persisted active Journey identity is incomplete.',
        );
      }
      initialJourneyId =
          preferences.getString(_activeJourneyIdStorageKey) ?? '';
      if (initialJourneyId.trim().isEmpty ||
          !_isRegisteredJourneyId(initialJourneyId)) {
        _failActiveIdentity(
          initialJourneyId,
          'Persisted active Journey is missing or no longer registered.',
        );
      }
      final expectedNamespace =
          _storageNamespaceForJourneyId(initialJourneyId);
      initialNamespace =
          preferences.getString(_activeJourneyNamespaceStorageKey) ?? '';
      final version = preferences.getInt(_activeJourneyVersionStorageKey);
      if (version != _activeJourneyIdentityVersion) {
        _failActiveIdentity(
          initialJourneyId,
          'Active Journey identity version is missing or unsupported: '
          '$version.',
        );
      }
      if (initialNamespace != expectedNamespace) {
        _failActiveIdentity(
          initialJourneyId,
          'Active Journey namespace mismatch: expected '
          '$expectedNamespace, found $initialNamespace.',
        );
      }
    }

    final journeys = <String, _JourneyCriticalState>{};
    for (final journeyId in _registeredJourneyIds) {
      journeys[journeyId] = _readLegacyJourney(preferences, journeyId);
    }

    final stamps = <String>{
      ...?preferences.getStringList('earnedJourneyStampIds'),
    };
    if (preferences.getBool('beijingStampEarned') == true ||
        preferences.getBool('journeyCompleted') == true) {
      stamps.add('beijing-forbidden-city');
    }

    return (
      generatedSeed: generatedSeed,
      snapshot: _PhoenixCriticalSnapshot(
        explorerSeed: seed,
        explorerSeedVersion: explorerSeedVersion,
        activeJourneyId: initialJourneyId,
        activeJourneyNamespace: initialNamespace,
        activeIdentityVersion: _activeJourneyIdentityVersion,
        journeys: journeys,
        earnedJourneyStampIds: stamps.toList()..sort(),
        memories: List<String>.from(
          preferences.getStringList('memories') ?? <String>[],
        ),
        awardedChallengeIds: <String>{
          ...?preferences.getStringList('challenge.awardedIds'),
        }.toList()
          ..sort(),
        goldCoins: math.max(0, preferences.getInt('wallet.gold') ?? 0),
        silverCoins: math.max(0, preferences.getInt('wallet.silver') ?? 0),
        bronzeCoins: math.max(0, preferences.getInt('wallet.bronze') ?? 0),
        silverFragments:
            math.max(0, preferences.getInt('wallet.fragment') ?? 0),
        unlockedSpecialJourneyIds: <String>{
          ...?preferences.getStringList('specialJourney.unlockedIds'),
        }.toList()
          ..sort(),
      ),
    );
  }

  _JourneyCriticalState _readLegacyJourney(
    SharedPreferences preferences,
    String journeyId,
  ) {
    final current = _storageNamespaceForJourneyId(journeyId);
    final legacy = _legacyStorageNamespaceForJourneyId(journeyId);
    final isBeijing = journeyId == 'beijing-forbidden-city';

    int? readInt(String suffix) =>
        preferences.getInt('$current.$suffix') ??
        preferences.getInt('$legacy.$suffix');
    bool? readBool(String suffix) =>
        preferences.getBool('$current.$suffix') ??
        preferences.getBool('$legacy.$suffix');
    String? readString(String suffix) =>
        preferences.getString('$current.$suffix') ??
        preferences.getString('$legacy.$suffix');

    final rawStep = readInt('step') ??
        (isBeijing ? preferences.getInt('beijingJourneyStep') : null) ??
        0;
    final rawFurthest = readInt('furthestStep') ??
        (isBeijing
            ? preferences.getInt('beijingJourneyFurthestStep')
            : null) ??
        rawStep;
    final completed = readBool('completed') ??
        (isBeijing ? preferences.getBool('journeyCompleted') : null) ??
        false;
    final step = completed
        ? AppState.journeyLastStep
        : _safeJourneyStep(rawStep);
    final furthest = completed
        ? AppState.journeyLastStep
        : math.max(step, _safeJourneyStep(rawFurthest)).toInt();

    final wonder = readString('wonderDraft') ??
        (isBeijing ? preferences.getString('wonderDraft') : null) ??
        '';
    final express = readString('expressDraft') ??
        (isBeijing ? preferences.getString('expressDraft') : null) ??
        '';
    final guideReply = readString('guideFeedbackReply') ?? '';
    final writingCorrected = readString('writingFeedbackCorrected') ?? '';
    final writingExplanation =
        readString('writingFeedbackExplanation') ?? '';
    final writingNatural = readString('writingFeedbackNatural') ?? '';
    final writingEncouragement =
        readString('writingFeedbackEncouragement') ?? '';
    final writingOffline = readBool('writingFeedbackOffline') ?? false;
    final hasWriting = writingCorrected.isNotEmpty ||
        writingExplanation.isNotEmpty ||
        writingNatural.isNotEmpty ||
        writingEncouragement.isNotEmpty ||
        writingOffline;

    final contentId = readString('narrationContentId');
    final contentSignature = readString('narrationContentSignature');
    final narrationOffset = math.max(0, readInt('narrationOffset') ?? 0);
    final signatures = <String, String>{};
    final offsets = <String, int>{};
    for (final id in const ['story', 'discovery']) {
      final signature =
          preferences.getString('$current.narration.$id.signature') ??
          preferences.getString('$legacy.narration.$id.signature') ??
          (contentId == id ? contentSignature : null);
      final offset =
          preferences.getInt('$current.narration.$id.offset') ??
          preferences.getInt('$legacy.narration.$id.offset') ??
          (contentId == id ? narrationOffset : 0);
      if (signature != null && offset > 0) {
        signatures[id] = signature;
        offsets[id] = offset;
      }
    }

    return _JourneyCriticalState(
      journeyId: journeyId,
      storageNamespace: current,
      flowVersion: journeyFlowVersionFor(journeyId),
      step: step,
      furthestStep: furthest,
      completed: completed,
      compositeSubstage: _inferCompositeSubstage(
        journeyId: journeyId,
        step: step,
        completed: completed,
        hasGuideFeedback: guideReply.isNotEmpty,
        hasWritingFeedback: hasWriting,
      ),
      challengeAttemptSequence: math.max(
        0,
        readInt('challengeAttemptSequence') ?? 0,
      ),
      challengeAttemptId: readString('challengeAttemptId') ?? '',
      wonderDraft: wonder,
      expressDraft: express,
      memoryDraft: readString('memoryDraft') ??
          (isBeijing ? preferences.getString('memoryDraft') : null) ??
          '',
      guideFeedbackReply: guideReply,
      guideFeedbackOffline: readBool('guideFeedbackOffline') ?? false,
      guideFeedbackInputIdentity:
          readString('guideFeedbackInputIdentity') ??
              (guideReply.isNotEmpty && wonder.trim().isNotEmpty
                  ? journeyFeedbackInputIdentity(wonder)
                  : ''),
      writingFeedbackCorrected: writingCorrected,
      writingFeedbackExplanation: writingExplanation,
      writingFeedbackNatural: writingNatural,
      writingFeedbackEncouragement: writingEncouragement,
      writingFeedbackOffline: writingOffline,
      writingFeedbackInputIdentity:
          readString('writingFeedbackInputIdentity') ??
              (hasWriting && express.trim().isNotEmpty
                  ? journeyFeedbackInputIdentity(express)
                  : ''),
      narrationContentId: contentId,
      narrationContentSignature: contentSignature,
      narrationOffset: narrationOffset,
      narrationSignatures: signatures,
      narrationOffsets: offsets,
      updatedAt: readString('updatedAt') ??
          (isBeijing ? preferences.getString('journeyUpdatedAt') : null),
    );
  }

  bool _canRestoreActiveJourney(String journeyId) {
    if (_isRegularJourneyId(journeyId)) return true;
    if (isDevelopmentExperience) return true;
    if (heldSpecialJourneyIds.contains(journeyId)) return false;
    return isSpecialJourneyUnlocked(journeyId);
  }

  bool get _hasResumableActiveJourney =>
      !journeyCompleted &&
      (hasJourneyInProgress ||
          wonderDraft.trim().isNotEmpty ||
          expressDraft.trim().isNotEmpty ||
          memoryDraft.trim().isNotEmpty ||
          journeyNarrationOffset > 0);

  bool _isRegularJourneyId(String journeyId) =>
      _regularJourneyIds.contains(journeyId);

  String _accessDenialReason(String journeyId) {
    if (_isRegularJourneyId(journeyId)) {
      return 'Regular Journey is outside the released Daily slots and is not '
          'an eligible resumable active Journey.';
    }
    if (heldSpecialJourneyIds.contains(journeyId)) {
      return 'Special Journey is held from publication.';
    }
    return 'Special Journey is not unlocked.';
  }

  int _safeJourneyStep(int value) =>
      value.clamp(0, AppState.journeyLastStep).toInt();

  Never _failExplorerSeed(String reason) {
    explorerSeedFailureReason = reason;
    throw StateError(reason);
  }

  Never _failActiveIdentity(String requestedId, String reason) {
    activeJourneyRestoreFailureId = requestedId;
    activeJourneyRestoreFailureReason = reason;
    throw StateError(
      'Cannot restore active Journey "$requestedId": $reason',
    );
  }

  static bool _isTrustedPreviewUri(Uri uri) {
    if (uri.scheme != 'https') return false;
    return RegExp(
      '^phoenix-journeys-pr-\\d+\\.$_trustedPreviewAccount\\.workers\\.dev\$',
    ).hasMatch(uri.host.toLowerCase());
  }

  static bool _isValidExplorerSeed(String seed) =>
      RegExp(r'^[0-9a-f]{64}$').hasMatch(seed);

  static String _generateOpaqueExplorerSeed() {
    final random = math.Random.secure();
    final buffer = StringBuffer();
    for (var index = 0; index < 32; index += 1) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}

class _SnapshotMutation<T> {
  const _SnapshotMutation.changed(this.snapshot, this.result) : changed = true;

  const _SnapshotMutation.unchanged(this.result)
      : changed = false,
        snapshot = null;

  final bool changed;
  final _PhoenixCriticalSnapshot? snapshot;
  final T result;
}

class _PhoenixCriticalSnapshot {
  const _PhoenixCriticalSnapshot({
    required this.explorerSeed,
    required this.explorerSeedVersion,
    required this.activeJourneyId,
    required this.activeJourneyNamespace,
    required this.activeIdentityVersion,
    required this.journeys,
    required this.earnedJourneyStampIds,
    required this.memories,
    required this.awardedChallengeIds,
    required this.goldCoins,
    required this.silverCoins,
    required this.bronzeCoins,
    required this.silverFragments,
    required this.unlockedSpecialJourneyIds,
  });

  factory _PhoenixCriticalSnapshot.fromJson(Map<String, dynamic> json) {
    final rawJourneys = json['journeys'];
    if (rawJourneys is! Map) {
      throw const CriticalPersistenceException(
        'Critical Journey map is missing or invalid.',
      );
    }
    return _PhoenixCriticalSnapshot(
      explorerSeed: json['explorerSeed'] as String? ?? '',
      explorerSeedVersion: json['explorerSeedVersion'] as int? ?? -1,
      activeJourneyId: json['activeJourneyId'] as String? ?? '',
      activeJourneyNamespace:
          json['activeJourneyNamespace'] as String? ?? '',
      activeIdentityVersion: json['activeIdentityVersion'] as int? ?? -1,
      journeys: <String, _JourneyCriticalState>{
        for (final entry in rawJourneys.entries)
          entry.key.toString(): _JourneyCriticalState.fromJson(
            _asStringMap(entry.value, 'Journey ${entry.key}'),
          ),
      },
      earnedJourneyStampIds:
          _stringList(json['earnedJourneyStampIds'], 'earned Journey stamps'),
      memories: _stringList(json['memories'], 'memories'),
      awardedChallengeIds:
          _stringList(json['awardedChallengeIds'], 'awarded Challenge IDs'),
      goldCoins: json['goldCoins'] as int? ?? -1,
      silverCoins: json['silverCoins'] as int? ?? -1,
      bronzeCoins: json['bronzeCoins'] as int? ?? -1,
      silverFragments: json['silverFragments'] as int? ?? -1,
      unlockedSpecialJourneyIds: _stringList(
        json['unlockedSpecialJourneyIds'],
        'unlocked Special Journey IDs',
      ),
    );
  }

  final String explorerSeed;
  final int explorerSeedVersion;
  final String activeJourneyId;
  final String activeJourneyNamespace;
  final int activeIdentityVersion;
  final Map<String, _JourneyCriticalState> journeys;
  final List<String> earnedJourneyStampIds;
  final List<String> memories;
  final List<String> awardedChallengeIds;
  final int goldCoins;
  final int silverCoins;
  final int bronzeCoins;
  final int silverFragments;
  final List<String> unlockedSpecialJourneyIds;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'explorerSeed': explorerSeed,
        'explorerSeedVersion': explorerSeedVersion,
        'activeJourneyId': activeJourneyId,
        'activeJourneyNamespace': activeJourneyNamespace,
        'activeIdentityVersion': activeIdentityVersion,
        'journeys': <String, dynamic>{
          for (final entry in journeys.entries)
            entry.key: entry.value.toJson(),
        },
        'earnedJourneyStampIds': earnedJourneyStampIds,
        'memories': memories,
        'awardedChallengeIds': awardedChallengeIds,
        'goldCoins': goldCoins,
        'silverCoins': silverCoins,
        'bronzeCoins': bronzeCoins,
        'silverFragments': silverFragments,
        'unlockedSpecialJourneyIds': unlockedSpecialJourneyIds,
      };

  _PhoenixCriticalSnapshot migratedToV2() {
    return copyWith(
      journeys: <String, _JourneyCriticalState>{
        for (final entry in journeys.entries)
          entry.key: entry.value.migratedToV2(),
      },
    );
  }

  _PhoenixCriticalSnapshot copyWith({
    String? activeJourneyId,
    String? activeJourneyNamespace,
    Map<String, _JourneyCriticalState>? journeys,
    List<String>? earnedJourneyStampIds,
    List<String>? memories,
    List<String>? awardedChallengeIds,
    int? goldCoins,
    int? silverCoins,
    int? bronzeCoins,
    int? silverFragments,
    List<String>? unlockedSpecialJourneyIds,
  }) {
    return _PhoenixCriticalSnapshot(
      explorerSeed: explorerSeed,
      explorerSeedVersion: explorerSeedVersion,
      activeJourneyId: activeJourneyId ?? this.activeJourneyId,
      activeJourneyNamespace:
          activeJourneyNamespace ?? this.activeJourneyNamespace,
      activeIdentityVersion: activeIdentityVersion,
      journeys: journeys ?? this.journeys,
      earnedJourneyStampIds:
          earnedJourneyStampIds ?? this.earnedJourneyStampIds,
      memories: memories ?? this.memories,
      awardedChallengeIds:
          awardedChallengeIds ?? this.awardedChallengeIds,
      goldCoins: goldCoins ?? this.goldCoins,
      silverCoins: silverCoins ?? this.silverCoins,
      bronzeCoins: bronzeCoins ?? this.bronzeCoins,
      silverFragments: silverFragments ?? this.silverFragments,
      unlockedSpecialJourneyIds:
          unlockedSpecialJourneyIds ?? this.unlockedSpecialJourneyIds,
    );
  }

  _PhoenixCriticalSnapshot withJourney(_JourneyCriticalState journey) {
    return copyWith(
      journeys: <String, _JourneyCriticalState>{
        ...journeys,
        journey.journeyId: journey,
      },
    );
  }

  _JourneyCriticalState requireJourney(String journeyId) {
    final journey = journeys[journeyId];
    if (journey == null) {
      throw CriticalPersistenceException(
        'Critical state has no Journey payload for $journeyId.',
      );
    }
    return journey;
  }

  int walletBalance(String currency) {
    return switch (currency) {
      '金币' => goldCoins,
      '银币' => silverCoins,
      '铜币' => bronzeCoins,
      _ => silverFragments,
    };
  }

  void validate() {
    if (!AccessControlledAppState._isValidExplorerSeed(explorerSeed)) {
      throw const CriticalPersistenceException(
        'Committed Explorer Seed is empty or corrupt.',
      );
    }
    if (explorerSeedVersion != AccessControlledAppState.explorerSeedVersion) {
      throw CriticalPersistenceException(
        'Unsupported committed Explorer Seed version: '
        '$explorerSeedVersion.',
      );
    }
    if (!AccessControlledAppState._isRegisteredJourneyId(activeJourneyId)) {
      throw CriticalPersistenceException(
        'Committed active Journey is not registered: $activeJourneyId.',
      );
    }
    final expectedNamespace =
        AccessControlledAppState._storageNamespaceForJourneyId(activeJourneyId);
    if (activeJourneyNamespace != expectedNamespace) {
      throw CriticalPersistenceException(
        'Committed active Journey namespace mismatch for $activeJourneyId.',
      );
    }
    if (activeIdentityVersion !=
        AccessControlledAppState._activeJourneyIdentityVersion) {
      throw CriticalPersistenceException(
        'Unsupported active Journey identity version: '
        '$activeIdentityVersion.',
      );
    }
    if (!journeys.containsKey(activeJourneyId)) {
      throw const CriticalPersistenceException(
        'Committed active Journey payload is missing.',
      );
    }
    for (final entry in journeys.entries) {
      if (entry.key != entry.value.journeyId ||
          !AccessControlledAppState._isRegisteredJourneyId(entry.key)) {
        throw CriticalPersistenceException(
          'Invalid committed Journey domain identity: ${entry.key}.',
        );
      }
      entry.value.validate();
    }
    _validateUniqueIds(earnedJourneyStampIds, 'earned Journey stamps');
    _validateUniqueIds(awardedChallengeIds, 'awarded Challenge IDs');
    _validateUniqueIds(
      unlockedSpecialJourneyIds,
      'unlocked Special Journey IDs',
    );
    for (final id in <String>{
      ...earnedJourneyStampIds,
      ...unlockedSpecialJourneyIds,
    }) {
      if (!AccessControlledAppState._isRegisteredJourneyId(id)) {
        throw CriticalPersistenceException(
          'Committed Journey ID is not registered: $id.',
        );
      }
    }
    if (goldCoins < 0 ||
        silverCoins < 0 ||
        bronzeCoins < 0 ||
        silverFragments < 0) {
      throw const CriticalPersistenceException(
        'Committed wallet contains a negative balance.',
      );
    }
    for (final journey in journeys.values.where((item) => item.completed)) {
      if (!earnedJourneyStampIds.contains(journey.journeyId)) {
        throw CriticalPersistenceException(
          'Completed Journey ${journey.journeyId} has no committed Stamp.',
        );
      }
    }
  }

  static void _validateUniqueIds(List<String> values, String label) {
    if (values.any((value) => value.trim().isEmpty) ||
        values.toSet().length != values.length) {
      throw CriticalPersistenceException(
        'Committed $label contains empty or duplicate IDs.',
      );
    }
  }
}

class _JourneyCriticalState {
  const _JourneyCriticalState({
    required this.journeyId,
    required this.storageNamespace,
    required this.flowVersion,
    required this.step,
    required this.furthestStep,
    required this.completed,
    required this.compositeSubstage,
    required this.challengeAttemptSequence,
    required this.challengeAttemptId,
    required this.wonderDraft,
    required this.expressDraft,
    required this.memoryDraft,
    required this.guideFeedbackReply,
    required this.guideFeedbackOffline,
    required this.guideFeedbackInputIdentity,
    required this.writingFeedbackCorrected,
    required this.writingFeedbackExplanation,
    required this.writingFeedbackNatural,
    required this.writingFeedbackEncouragement,
    required this.writingFeedbackOffline,
    required this.writingFeedbackInputIdentity,
    required this.narrationContentId,
    required this.narrationContentSignature,
    required this.narrationOffset,
    required this.narrationSignatures,
    required this.narrationOffsets,
    required this.updatedAt,
  });

  factory _JourneyCriticalState.fromJson(Map<String, dynamic> json) {
    final journeyId = json['journeyId'] as String? ?? '';
    final step = json['step'] as int? ?? -1;
    final completed = json['completed'] as bool? ?? false;
    final wonder = json['wonderDraft'] as String? ?? '';
    final express = json['expressDraft'] as String? ?? '';
    final guideReply = json['guideFeedbackReply'] as String? ?? '';
    final writingCorrected =
        json['writingFeedbackCorrected'] as String? ?? '';
    final writingExplanation =
        json['writingFeedbackExplanation'] as String? ?? '';
    final writingNatural = json['writingFeedbackNatural'] as String? ?? '';
    final writingEncouragement =
        json['writingFeedbackEncouragement'] as String? ?? '';
    final writingOffline = json['writingFeedbackOffline'] as bool? ?? false;
    final hasWriting = writingCorrected.isNotEmpty ||
        writingExplanation.isNotEmpty ||
        writingNatural.isNotEmpty ||
        writingEncouragement.isNotEmpty ||
        writingOffline;
    final rawSubstage = json['compositeSubstage'] as String?;

    return _JourneyCriticalState(
      journeyId: journeyId,
      storageNamespace: json['storageNamespace'] as String? ?? '',
      flowVersion:
          json['flowVersion'] as int? ?? journeyFlowVersionFor(journeyId),
      step: step,
      furthestStep: json['furthestStep'] as int? ?? -1,
      completed: completed,
      compositeSubstage: rawSubstage == null
          ? _inferCompositeSubstage(
              journeyId: journeyId,
              step: step,
              completed: completed,
              hasGuideFeedback: guideReply.isNotEmpty,
              hasWritingFeedback: hasWriting,
            )
          : parseJourneyCompositeSubstage(rawSubstage),
      challengeAttemptSequence:
          json['challengeAttemptSequence'] as int? ?? 0,
      challengeAttemptId: json['challengeAttemptId'] as String? ?? '',
      wonderDraft: wonder,
      expressDraft: express,
      memoryDraft: json['memoryDraft'] as String? ?? '',
      guideFeedbackReply: guideReply,
      guideFeedbackOffline: json['guideFeedbackOffline'] as bool? ?? false,
      guideFeedbackInputIdentity:
          json['guideFeedbackInputIdentity'] as String? ??
              (guideReply.isNotEmpty && wonder.trim().isNotEmpty
                  ? journeyFeedbackInputIdentity(wonder)
                  : ''),
      writingFeedbackCorrected: writingCorrected,
      writingFeedbackExplanation: writingExplanation,
      writingFeedbackNatural: writingNatural,
      writingFeedbackEncouragement: writingEncouragement,
      writingFeedbackOffline: writingOffline,
      writingFeedbackInputIdentity:
          json['writingFeedbackInputIdentity'] as String? ??
              (hasWriting && express.trim().isNotEmpty
                  ? journeyFeedbackInputIdentity(express)
                  : ''),
      narrationContentId: json['narrationContentId'] as String?,
      narrationContentSignature:
          json['narrationContentSignature'] as String?,
      narrationOffset: json['narrationOffset'] as int? ?? 0,
      narrationSignatures: _stringMap(
        json['narrationSignatures'],
        'narration signatures',
      ),
      narrationOffsets: _intMap(
        json['narrationOffsets'],
        'narration offsets',
      ),
      updatedAt: json['updatedAt'] as String?,
    );
  }

  final String journeyId;
  final String storageNamespace;
  final int flowVersion;
  final int step;
  final int furthestStep;
  final bool completed;
  final JourneyCompositeSubstage compositeSubstage;
  final int challengeAttemptSequence;
  final String challengeAttemptId;
  final String wonderDraft;
  final String expressDraft;
  final String memoryDraft;
  final String guideFeedbackReply;
  final bool guideFeedbackOffline;
  final String guideFeedbackInputIdentity;
  final String writingFeedbackCorrected;
  final String writingFeedbackExplanation;
  final String writingFeedbackNatural;
  final String writingFeedbackEncouragement;
  final bool writingFeedbackOffline;
  final String writingFeedbackInputIdentity;
  final String? narrationContentId;
  final String? narrationContentSignature;
  final int narrationOffset;
  final Map<String, String> narrationSignatures;
  final Map<String, int> narrationOffsets;
  final String? updatedAt;

  bool get hasNarration =>
      narrationContentId != null ||
      narrationContentSignature != null ||
      narrationOffset > 0 ||
      narrationSignatures.isNotEmpty ||
      narrationOffsets.isNotEmpty;

  bool get hasWritingFeedback =>
      writingFeedbackCorrected.isNotEmpty ||
      writingFeedbackExplanation.isNotEmpty ||
      writingFeedbackNatural.isNotEmpty ||
      writingFeedbackEncouragement.isNotEmpty ||
      writingFeedbackOffline;

  _JourneyCriticalState migratedToV2() => copyWith(
        flowVersion: journeyFlowVersionFor(journeyId),
        compositeSubstage: _inferCompositeSubstage(
          journeyId: journeyId,
          step: step,
          completed: completed,
          hasGuideFeedback: guideFeedbackReply.isNotEmpty,
          hasWritingFeedback: hasWritingFeedback,
        ),
        guideFeedbackInputIdentity: guideFeedbackInputIdentity.isNotEmpty
            ? guideFeedbackInputIdentity
            : guideFeedbackReply.isNotEmpty && wonderDraft.trim().isNotEmpty
                ? journeyFeedbackInputIdentity(wonderDraft)
                : '',
        writingFeedbackInputIdentity: writingFeedbackInputIdentity.isNotEmpty
            ? writingFeedbackInputIdentity
            : hasWritingFeedback && expressDraft.trim().isNotEmpty
                ? journeyFeedbackInputIdentity(expressDraft)
                : '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'journeyId': journeyId,
        'storageNamespace': storageNamespace,
        'flowVersion': flowVersion,
        'step': step,
        'furthestStep': furthestStep,
        'completed': completed,
        'compositeSubstage': compositeSubstage.storageValue,
        'challengeAttemptSequence': challengeAttemptSequence,
        'challengeAttemptId': challengeAttemptId,
        'wonderDraft': wonderDraft,
        'expressDraft': expressDraft,
        'memoryDraft': memoryDraft,
        'guideFeedbackReply': guideFeedbackReply,
        'guideFeedbackOffline': guideFeedbackOffline,
        'guideFeedbackInputIdentity': guideFeedbackInputIdentity,
        'writingFeedbackCorrected': writingFeedbackCorrected,
        'writingFeedbackExplanation': writingFeedbackExplanation,
        'writingFeedbackNatural': writingFeedbackNatural,
        'writingFeedbackEncouragement': writingFeedbackEncouragement,
        'writingFeedbackOffline': writingFeedbackOffline,
        'writingFeedbackInputIdentity': writingFeedbackInputIdentity,
        'narrationContentId': narrationContentId,
        'narrationContentSignature': narrationContentSignature,
        'narrationOffset': narrationOffset,
        'narrationSignatures': narrationSignatures,
        'narrationOffsets': narrationOffsets,
        'updatedAt': updatedAt,
      };

  _JourneyCriticalState copyWith({
    int? flowVersion,
    int? step,
    int? furthestStep,
    bool? completed,
    JourneyCompositeSubstage? compositeSubstage,
    int? challengeAttemptSequence,
    String? challengeAttemptId,
    String? wonderDraft,
    String? expressDraft,
    String? memoryDraft,
    String? guideFeedbackReply,
    bool? guideFeedbackOffline,
    String? guideFeedbackInputIdentity,
    String? writingFeedbackCorrected,
    String? writingFeedbackExplanation,
    String? writingFeedbackNatural,
    String? writingFeedbackEncouragement,
    bool? writingFeedbackOffline,
    String? writingFeedbackInputIdentity,
    String? narrationContentId,
    String? narrationContentSignature,
    int? narrationOffset,
    Map<String, String>? narrationSignatures,
    Map<String, int>? narrationOffsets,
    String? updatedAt,
    bool replaceNullableNarration = false,
  }) {
    return _JourneyCriticalState(
      journeyId: journeyId,
      storageNamespace: storageNamespace,
      flowVersion: flowVersion ?? this.flowVersion,
      step: step ?? this.step,
      furthestStep: furthestStep ?? this.furthestStep,
      completed: completed ?? this.completed,
      compositeSubstage: compositeSubstage ?? this.compositeSubstage,
      challengeAttemptSequence:
          challengeAttemptSequence ?? this.challengeAttemptSequence,
      challengeAttemptId: challengeAttemptId ?? this.challengeAttemptId,
      wonderDraft: wonderDraft ?? this.wonderDraft,
      expressDraft: expressDraft ?? this.expressDraft,
      memoryDraft: memoryDraft ?? this.memoryDraft,
      guideFeedbackReply: guideFeedbackReply ?? this.guideFeedbackReply,
      guideFeedbackOffline:
          guideFeedbackOffline ?? this.guideFeedbackOffline,
      guideFeedbackInputIdentity:
          guideFeedbackInputIdentity ?? this.guideFeedbackInputIdentity,
      writingFeedbackCorrected:
          writingFeedbackCorrected ?? this.writingFeedbackCorrected,
      writingFeedbackExplanation:
          writingFeedbackExplanation ?? this.writingFeedbackExplanation,
      writingFeedbackNatural:
          writingFeedbackNatural ?? this.writingFeedbackNatural,
      writingFeedbackEncouragement:
          writingFeedbackEncouragement ?? this.writingFeedbackEncouragement,
      writingFeedbackOffline:
          writingFeedbackOffline ?? this.writingFeedbackOffline,
      writingFeedbackInputIdentity:
          writingFeedbackInputIdentity ?? this.writingFeedbackInputIdentity,
      narrationContentId: replaceNullableNarration
          ? narrationContentId
          : narrationContentId ?? this.narrationContentId,
      narrationContentSignature: replaceNullableNarration
          ? narrationContentSignature
          : narrationContentSignature ?? this.narrationContentSignature,
      narrationOffset: narrationOffset ?? this.narrationOffset,
      narrationSignatures:
          narrationSignatures ?? this.narrationSignatures,
      narrationOffsets: narrationOffsets ?? this.narrationOffsets,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  _JourneyCriticalState clearNarration() => copyWith(
        narrationContentId: null,
        narrationContentSignature: null,
        narrationOffset: 0,
        narrationSignatures: const <String, String>{},
        narrationOffsets: const <String, int>{},
        replaceNullableNarration: true,
      );

  void validate() {
    final expectedNamespace =
        AccessControlledAppState._storageNamespaceForJourneyId(journeyId);
    if (storageNamespace != expectedNamespace) {
      throw CriticalPersistenceException(
        'Journey namespace mismatch for $journeyId.',
      );
    }
    if (flowVersion != journeyFlowVersionFor(journeyId)) {
      throw CriticalPersistenceException(
        'Journey flow version is invalid for $journeyId: $flowVersion.',
      );
    }
    if (step < 0 ||
        step > AppState.journeyLastStep ||
        furthestStep < step ||
        furthestStep > AppState.journeyLastStep) {
      throw CriticalPersistenceException(
        'Journey step range is invalid for $journeyId.',
      );
    }
    if (completed &&
        (step != AppState.journeyLastStep ||
            furthestStep != AppState.journeyLastStep)) {
      throw CriticalPersistenceException(
        'Journey completion state is inconsistent for $journeyId.',
      );
    }
    if (journeyId == 'beijing-summer-palace') {
      final allowedSubstages = switch (step) {
        3 => const <JourneyCompositeSubstage>{
            JourneyCompositeSubstage.reflection,
            JourneyCompositeSubstage.challenge,
          },
        4 => const <JourneyCompositeSubstage>{
            JourneyCompositeSubstage.writing,
            JourneyCompositeSubstage.memory,
          },
        5 when completed => const <JourneyCompositeSubstage>{
            JourneyCompositeSubstage.completed,
          },
        _ => const <JourneyCompositeSubstage>{
            JourneyCompositeSubstage.none,
          },
      };
      if (!allowedSubstages.contains(compositeSubstage)) {
        throw CriticalPersistenceException(
          'Composite substage ${compositeSubstage.name} is invalid for '
          '$journeyId step $step.',
        );
      }
    } else if (compositeSubstage != JourneyCompositeSubstage.none) {
      throw CriticalPersistenceException(
        'Non-pilot Journey $journeyId cannot persist a composite substage.',
      );
    }
    if (challengeAttemptSequence < 0) {
      throw CriticalPersistenceException(
        'Challenge attempt sequence is invalid for $journeyId.',
      );
    }
    if (challengeAttemptId.isNotEmpty &&
        challengeAttemptId !=
            '$journeyId:flow-v$flowVersion:attempt-$challengeAttemptSequence') {
      throw CriticalPersistenceException(
        'Challenge attempt identity is invalid for $journeyId.',
      );
    }
    if (guideFeedbackReply.isNotEmpty &&
        wonderDraft.trim().isNotEmpty &&
        guideFeedbackInputIdentity.isEmpty) {
      throw CriticalPersistenceException(
        'Reflection feedback input identity is missing for $journeyId.',
      );
    }
    if (hasWritingFeedback &&
        expressDraft.trim().isNotEmpty &&
        writingFeedbackInputIdentity.isEmpty) {
      throw CriticalPersistenceException(
        'Writing feedback input identity is missing for $journeyId.',
      );
    }
    if (narrationOffset < 0 ||
        narrationOffsets.values.any((offset) => offset < 0)) {
      throw CriticalPersistenceException(
        'Journey narration offset is invalid for $journeyId.',
      );
    }
    if (narrationOffsets.keys.toSet().difference(
          narrationSignatures.keys.toSet(),
        ).isNotEmpty) {
      throw CriticalPersistenceException(
        'Journey narration signature binding is incomplete for $journeyId.',
      );
    }
    if (updatedAt != null && DateTime.tryParse(updatedAt!) == null) {
      throw CriticalPersistenceException(
        'Journey updatedAt is invalid for $journeyId.',
      );
    }
  }
}

JourneyCompositeSubstage _inferCompositeSubstage({
  required String journeyId,
  required int step,
  required bool completed,
  required bool hasGuideFeedback,
  required bool hasWritingFeedback,
}) {
  if (journeyId != 'beijing-summer-palace') {
    return JourneyCompositeSubstage.none;
  }
  if (completed || step >= AppState.journeyLastStep) {
    return JourneyCompositeSubstage.completed;
  }
  if (step == 3) {
    return hasGuideFeedback
        ? JourneyCompositeSubstage.challenge
        : JourneyCompositeSubstage.reflection;
  }
  if (step == 4) {
    return hasWritingFeedback
        ? JourneyCompositeSubstage.memory
        : JourneyCompositeSubstage.writing;
  }
  return JourneyCompositeSubstage.none;
}

Map<String, dynamic> _asStringMap(Object? value, String label) {
  if (value is! Map) {
    throw CriticalPersistenceException('$label is not a JSON object.');
  }
  return value.map((key, item) => MapEntry(key.toString(), item));
}

List<String> _stringList(Object? value, String label) {
  if (value is! List || value.any((item) => item is! String)) {
    throw CriticalPersistenceException('$label is not a string list.');
  }
  return value.cast<String>().toList(growable: false);
}

Map<String, String> _stringMap(Object? value, String label) {
  if (value is! Map || value.values.any((item) => item is! String)) {
    throw CriticalPersistenceException('$label is not a string map.');
  }
  return value.map(
    (key, item) => MapEntry(key.toString(), item as String),
  );
}

Map<String, int> _intMap(Object? value, String label) {
  if (value is! Map || value.values.any((item) => item is! int)) {
    throw CriticalPersistenceException('$label is not an integer map.');
  }
  return value.map(
    (key, item) => MapEntry(key.toString(), item as int),
  );
}

extension JourneyAccessAppState on AppState {
  AccessControlledAppState? get _accessControlledState =>
      this is AccessControlledAppState
          ? this as AccessControlledAppState
          : null;

  bool get isDevelopmentExperience =>
      _accessControlledState?.isDevelopmentExperience ?? true;

  bool canOpenJourney(String journeyId) =>
      _accessControlledState?.canOpenJourney(journeyId) ??
      journeyExperienceById(journeyId) != null;

  bool canResumeActiveJourney(String journeyId) =>
      _accessControlledState?.canResumeActiveJourney(journeyId) ??
      (journeyId == activeJourneyId &&
          journeyExperienceById(journeyId) != null);

  Future<bool> tryActivateJourney(String journeyId) async {
    final accessState = _accessControlledState;
    if (accessState != null) {
      return accessState.tryActivateJourney(journeyId);
    }
    await activateJourney(journeyId);
    return true;
  }

  String? dailySlotLabelForJourney(String journeyId) =>
      _accessControlledState?.dailySlotLabelForJourney(journeyId);

  bool isDailyJourneyReleased(String journeyId) =>
      _accessControlledState?.isDailyJourneyReleased(journeyId) ?? true;

  Set<String> get releasedDailyJourneyIds =>
      _accessControlledState?.releasedDailyJourneyIds ??
      <String>{for (final journey in dailyJourneyExperiences) journey.id};
}
