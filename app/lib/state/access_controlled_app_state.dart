import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/daily_journey_catalog.dart';
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
  })  : _clock = clock ?? DateTime.now,
        _preferencesLoader =
            preferencesLoader ?? SharedPreferences.getInstance,
        _runtimeUri = runtimeUri ?? Uri.base,
        _debugBuild = debugBuild ?? kDebugMode,
        _forcedAccessMode = accessMode,
        _explorerSeedGenerator =
            explorerSeedGenerator ?? _generateOpaqueExplorerSeed,
        _explorerSeedPersister =
            explorerSeedPersister ?? _persistExplorerSeed,
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

  static const Set<String> heldSpecialJourneyIds = <String>{
    'changan-last-bus',
    'tide-letter',
    'arcade-lost-property',
    'tea-horse-echo',
    'ice-city-star-map',
  };

  final DateTime Function() _clock;
  final Future<SharedPreferences> Function() _preferencesLoader;
  final Uri _runtimeUri;
  final bool _debugBuild;
  final JourneyAccessMode? _forcedAccessMode;
  final String Function() _explorerSeedGenerator;
  final ExplorerSeedPersister _explorerSeedPersister;

  String localExplorerSeed = '';
  String? explorerSeedFailureReason;
  bool _activeIdentityReady = false;

  JourneyAccessMode get journeyAccessMode =>
      _forcedAccessMode ??
      ((_debugBuild || _isTrustedPreviewUri(_runtimeUri))
          ? JourneyAccessMode.developmentExperience
          : JourneyAccessMode.productionFreeExplorer);

  bool get isDevelopmentExperience =>
      journeyAccessMode == JourneyAccessMode.developmentExperience;

  List<String> get eligibleRegularJourneyIds =>
      List<String>.unmodifiable(
        <String>{for (final journey in dailyJourneyExperiences) journey.id},
      );

  DailyJourneyAssignment get dailyAssignment {
    if (!_isValidExplorerSeed(localExplorerSeed)) {
      throw StateError('A valid local Explorer Seed is required.');
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
      return dailyJourneyForDate(_clock());
    }
    return requireDailyJourneyExperience(
      dailyAssignment.journeyIdFor(currentDailySlot),
    );
  }

  bool canOpenJourney(String journeyId) {
    final journey = journeyExperienceById(journeyId);
    if (journey == null) return false;

    if (_isRegularJourneyId(journeyId)) {
      if (policyAccessibleRegularJourneyIds.contains(journeyId)) return true;
      return _activeIdentityReady && journeyId == activeJourneyId;
    }

    if (isDevelopmentExperience) return true;
    if (heldSpecialJourneyIds.contains(journeyId)) return false;
    return isSpecialJourneyUnlocked(journeyId);
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
    explorerSeedFailureReason = null;
    _activeIdentityReady = false;

    try {
      final preferences = await _preferencesLoader();
      await _restoreOrCreateExplorerSeed(preferences);
      await _ensureFreshInstallActiveIdentity(preferences);
    } catch (error, stackTrace) {
      debugPrint('Failed to restore local Explorer identity: $error');
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = '无法安全恢复本机 Explorer 身份，没有重新抽取旅程。请重新尝试。';
      notifyListeners();
      return;
    }

    await super.load();
    if (loadStatus != AppLoadStatus.ready) return;

    if (!_canRestoreActiveJourney(activeJourneyId)) {
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = '当前旅程不再具备安全恢复条件，没有打开其他旅程。';
      notifyListeners();
      return;
    }

    _activeIdentityReady = true;
    notifyListeners();
  }

  @override
  Future<void> activateJourney(String journeyId) async {
    requireDailyJourneyExperience(journeyId);
    if (!canOpenJourney(journeyId)) {
      throw JourneyAccessDeniedException(
        journeyId: journeyId,
        reason: _accessDenialReason(journeyId),
      );
    }

    await super.activateJourney(journeyId);
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

  Future<void> _restoreOrCreateExplorerSeed(
    SharedPreferences preferences,
  ) async {
    final hasSeed = preferences.containsKey(explorerSeedStorageKey);
    final hasVersion = preferences.containsKey(explorerSeedVersionStorageKey);

    if (!hasSeed && !hasVersion) {
      final generated = _explorerSeedGenerator();
      if (!_isValidExplorerSeed(generated)) {
        _failExplorerSeed('Generated Explorer Seed is invalid.');
      }
      final persisted = await _explorerSeedPersister(
        preferences,
        generated,
        explorerSeedVersion,
      );
      if (!persisted) {
        _failExplorerSeed('Explorer Seed persistence failed.');
      }
      localExplorerSeed = generated;
      return;
    }

    if (!hasSeed || !hasVersion) {
      _failExplorerSeed('Explorer Seed record is incomplete.');
    }

    final persistedSeed = preferences.getString(explorerSeedStorageKey) ?? '';
    final persistedVersion = preferences.getInt(
      explorerSeedVersionStorageKey,
    );
    if (persistedVersion != explorerSeedVersion) {
      _failExplorerSeed(
        'Explorer Seed version is missing or unsupported: '
        '$persistedVersion.',
      );
    }
    if (!_isValidExplorerSeed(persistedSeed)) {
      _failExplorerSeed('Persisted Explorer Seed is empty or corrupt.');
    }

    localExplorerSeed = persistedSeed;
  }

  Future<void> _ensureFreshInstallActiveIdentity(
    SharedPreferences preferences,
  ) async {
    final hasId = preferences.containsKey(_activeJourneyIdStorageKey);
    final hasNamespace = preferences.containsKey(
      _activeJourneyNamespaceStorageKey,
    );
    final hasVersion = preferences.containsKey(
      _activeJourneyVersionStorageKey,
    );

    if (hasId || hasNamespace || hasVersion) return;

    final initialJourneyId = dailyAssignment.journeyIdFor(currentDailySlot);
    final binding = requireJourneyLocation(initialJourneyId);
    final writes = await Future.wait<bool>([
      preferences.setString(
        _activeJourneyIdStorageKey,
        binding.journeyId,
      ),
      preferences.setString(
        _activeJourneyNamespaceStorageKey,
        binding.storageNamespace,
      ),
      preferences.setInt(
        _activeJourneyVersionStorageKey,
        _activeJourneyIdentityVersion,
      ),
    ]);
    if (writes.any((result) => !result)) {
      throw StateError('Initial active Journey identity persistence failed.');
    }
  }

  bool _canRestoreActiveJourney(String journeyId) {
    if (_isRegularJourneyId(journeyId)) return true;
    if (isDevelopmentExperience) return true;
    if (heldSpecialJourneyIds.contains(journeyId)) return false;
    return isSpecialJourneyUnlocked(journeyId);
  }

  bool _isRegularJourneyId(String journeyId) =>
      dailyJourneyExperiences.any((journey) => journey.id == journeyId);

  String _accessDenialReason(String journeyId) {
    if (_isRegularJourneyId(journeyId)) {
      return 'Regular Journey is outside the released Daily slots and is not '
          'the persisted resumable active Journey.';
    }
    if (heldSpecialJourneyIds.contains(journeyId)) {
      return 'Special Journey is held from publication.';
    }
    return 'Special Journey is not unlocked.';
  }

  Never _failExplorerSeed(String reason) {
    explorerSeedFailureReason = reason;
    throw StateError(reason);
  }

  static bool _isTrustedPreviewUri(Uri uri) {
    if (uri.scheme != 'https') return false;
    return RegExp(
      r'^phoenix-journeys-pr-\d+\.[a-z0-9-]+\.workers\.dev$',
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

  static Future<bool> _persistExplorerSeed(
    SharedPreferences preferences,
    String seed,
    int version,
  ) async {
    final seedWritten = await preferences.setString(
      explorerSeedStorageKey,
      seed,
    );
    final versionWritten = await preferences.setInt(
      explorerSeedVersionStorageKey,
      version,
    );
    return seedWritten && versionWritten;
  }
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
