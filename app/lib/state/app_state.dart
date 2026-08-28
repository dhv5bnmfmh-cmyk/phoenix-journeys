import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:pinyin/pinyin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_level_catalog.dart';
import '../services/journey_location_binding.dart';
import '../services/language_level_preference_store.dart';

enum ScriptMode { simplified, traditional }

enum AppLoadStatus { loading, ready, error }

enum JourneyCompositeSubstage {
  none,
  reflection,
  challenge,
  writing,
  memory,
  completed,
}

extension JourneyCompositeSubstageStorage on JourneyCompositeSubstage {
  String get storageValue => name;
}

JourneyCompositeSubstage parseJourneyCompositeSubstage(String? value) {
  return JourneyCompositeSubstage.values.firstWhere(
    (entry) => entry.storageValue == value,
    orElse: () => JourneyCompositeSubstage.none,
  );
}

const int summerPalaceJourneyFlowVersion = 2;

int journeyFlowVersionFor(String journeyId) =>
    journeyId == 'beijing-summer-palace' ? summerPalaceJourneyFlowVersion : 1;

String journeyFeedbackInputIdentity(String input) {
  final normalized = input.trim().replaceAll(RegExp(r'\s+'), ' ');
  var hash = 0x811c9dc5;
  for (final unit in utf8.encode(normalized)) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return 'fnv1a32:${hash.toRadixString(16).padLeft(8, '0')}:${normalized.length}';
}

enum SpecialJourneyUnlockStatus {
  unlocked,
  alreadyUnlocked,
  insufficientFunds,
  busy,
}

class SpecialJourneyUnlockResult {
  const SpecialJourneyUnlockResult({
    required this.status,
    required this.currency,
    required this.cost,
    required this.balance,
  });

  final SpecialJourneyUnlockStatus status;
  final String currency;
  final int cost;
  final int balance;

  int get missing => math.max(0, cost - balance).toInt();
}

class AppState extends ChangeNotifier {
  AppState({
    DateTime Function()? clock,
    Future<SharedPreferences> Function()? preferencesLoader,
  })  : _clock = clock ?? DateTime.now,
        _preferencesLoader =
            preferencesLoader ?? SharedPreferences.getInstance {
    activeJourneyId = dailyJourneyIdForDate(_clock());
  }

  static const int journeyLastStep = 5;
  static const List<String> journeyStepLabels = [
    '故事',
    '单词',
    '发现',
    '挑战',
    '回忆',
    '完成',
  ];

  // Compatibility aliases for stable widgets and older tests.
  static const int beijingJourneyLastStep = journeyLastStep;
  static const List<String> beijingJourneyStepLabels = journeyStepLabels;

  @visibleForTesting
  static const String activeJourneyIdStorageKey = 'activeJourney.id';
  @visibleForTesting
  static const String activeJourneyNamespaceStorageKey =
      'activeJourney.storageNamespace';
  @visibleForTesting
  static const String activeJourneyVersionStorageKey =
      'activeJourney.identityVersion';
  @visibleForTesting
  static const int activeJourneyIdentityVersion = 1;

  final DateTime Function() _clock;
  final Future<SharedPreferences> Function() _preferencesLoader;
  static const LanguageLevelPreferenceStore _languageLevelStore =
      LanguageLevelPreferenceStore();
  Future<void> _journeyNarrationPersistence = Future<void>.value();

  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  JourneyDifficulty journeyDifficulty = JourneyDifficulty.standard;
  bool journeyDifficultyChosen = false;
  int selectedTab = 0;
  bool journeyCompleted = false;
  final List<String> memories = [];
  final Set<String> savedWords = <String>{};
  final Set<String> earnedJourneyStampIds = <String>{};
  int goldCoins = 0;
  int silverCoins = 0;
  int bronzeCoins = 0;
  int silverFragments = 0;
  final Set<String> awardedChallengeIds = <String>{};
  final Set<String> unlockedSpecialJourneyIds = <String>{};
  final Set<String> _specialJourneyUnlocksInFlight = <String>{};

  late String activeJourneyId;
  int _journeyStep = 0;
  int _journeyFurthestStep = 0;
  int journeyFlowVersion = 1;
  JourneyCompositeSubstage journeyCompositeSubstage =
      JourneyCompositeSubstage.none;
  int journeyChallengeAttemptSequence = 0;
  String journeyChallengeAttemptId = '';
  String wonderDraft = '';
  String expressDraft = '';
  String memoryDraft = '';
  String guideFeedbackReply = '';
  bool guideFeedbackOffline = false;
  String guideFeedbackInputIdentity = '';
  String writingFeedbackCorrected = '';
  String writingFeedbackExplanation = '';
  String writingFeedbackNatural = '';
  String writingFeedbackEncouragement = '';
  bool writingFeedbackOffline = false;
  String writingFeedbackInputIdentity = '';
  String? journeyNarrationContentId;
  String? journeyNarrationContentSignature;
  int journeyNarrationOffset = 0;
  final Map<String, String> _journeyNarrationSignatures = <String, String>{};
  final Map<String, int> _journeyNarrationOffsets = <String, int>{};
  DateTime? journeyUpdatedAt;

  AppLoadStatus loadStatus = AppLoadStatus.loading;
  String? loadErrorMessage;
  String? activeJourneyRestoreFailureId;
  String? activeJourneyRestoreFailureReason;

  bool get isReady => loadStatus == AppLoadStatus.ready;
  bool get isTraditional => scriptMode == ScriptMode.traditional;
  DailyJourneyExperience get activeJourney =>
      requireDailyJourneyExperience(activeJourneyId);
  DailyJourneyExperience get todayJourney => dailyJourneyForDate(_clock());
  JourneyLocationBinding get activeJourneyLocation =>
      requireJourneyLocation(activeJourneyId);
  String get activeJourneyStoragePath => activeJourneyLocation.storageNamespace;
  bool get activeJourneyStampEarned =>
      earnedJourneyStampIds.contains(activeJourneyId);
  bool get beijingStampEarned =>
      earnedJourneyStampIds.contains('beijing-forbidden-city');
  int get earnedStampCount => earnedJourneyStampIds.length;

  int get journeyStep => _journeyStep;
  int get journeyFurthestStep => _journeyFurthestStep;
  int get beijingJourneyStep => _journeyStep;
  int get beijingJourneyFurthestStep => _journeyFurthestStep;

  String displayText(String text) {
    return isTraditional
        ? ChineseHelper.convertToTraditionalChinese(text)
        : ChineseHelper.convertToSimplifiedChinese(text);
  }

  bool get hasJourneyInProgress => !journeyCompleted && _journeyStep > 0;

  double get journeyProgress {
    if (journeyCompleted) return 1;
    return (_journeyStep + 1) / (journeyLastStep + 1);
  }

  int get journeyProgressPercent => (journeyProgress * 100).round();
  double get beijingJourneyProgress => journeyProgress;
  int get beijingJourneyProgressPercent => journeyProgressPercent;

  String get journeyStepLabel => displayText(
        _journeyLabelFor(_journeyStep, journeyCompositeSubstage),
      );
  String get journeyFurthestStepLabel =>
      displayText(journeyStepLabels[_safeJourneyStep(_journeyFurthestStep)]);
  String get beijingJourneyStepLabel => journeyStepLabel;
  String get beijingJourneyFurthestStepLabel => journeyFurthestStepLabel;

  String _journeyLabelFor(int step, JourneyCompositeSubstage substage) {
    return journeyStepLabels[_safeJourneyStep(step)];
  }

  bool get hasGuideFeedback => guideFeedbackReply.trim().isNotEmpty;
  bool get hasWritingFeedback =>
      writingFeedbackCorrected.trim().isNotEmpty ||
      writingFeedbackExplanation.trim().isNotEmpty ||
      writingFeedbackNatural.trim().isNotEmpty ||
      writingFeedbackEncouragement.trim().isNotEmpty;

  bool hasGuideFeedbackFor(String inputIdentity) =>
      hasGuideFeedback &&
      inputIdentity.isNotEmpty &&
      guideFeedbackInputIdentity == inputIdentity;

  bool hasWritingFeedbackFor(String inputIdentity) =>
      hasWritingFeedback &&
      inputIdentity.isNotEmpty &&
      writingFeedbackInputIdentity == inputIdentity;

  bool isWordSaved(String word) => savedWords.contains(word);
  bool isJourneyStampEarned(String journeyId) =>
      earnedJourneyStampIds.contains(journeyId);

  String? journeyNarrationSignatureFor(String contentId) =>
      _journeyNarrationSignatures[contentId];

  int journeyNarrationOffsetFor(String contentId) =>
      _journeyNarrationOffsets[contentId] ?? 0;

  String _narrationKey(String contentId, String suffix) =>
      _key('narration.$contentId.$suffix');

  String _key(String suffix, [String? journeyId]) {
    final binding = requireJourneyLocation(journeyId ?? activeJourneyId);
    return '${binding.storageNamespace}.$suffix';
  }

  String _legacyKey(String suffix, [String? journeyId]) {
    final binding = requireJourneyLocation(journeyId ?? activeJourneyId);
    return '${binding.legacyStorageNamespace}.$suffix';
  }

  int? _readJourneyInt(SharedPreferences prefs, String suffix) =>
      prefs.getInt(_key(suffix)) ?? prefs.getInt(_legacyKey(suffix));

  bool? _readJourneyBool(SharedPreferences prefs, String suffix) =>
      prefs.getBool(_key(suffix)) ?? prefs.getBool(_legacyKey(suffix));

  String? _readJourneyString(SharedPreferences prefs, String suffix) =>
      prefs.getString(_key(suffix)) ?? prefs.getString(_legacyKey(suffix));

  Future<void> load() async {
    loadStatus = AppLoadStatus.loading;
    loadErrorMessage = null;
    activeJourneyRestoreFailureId = null;
    activeJourneyRestoreFailureReason = null;
    notifyListeners();

    try {
      final prefs = await _preferencesLoader();
      scriptMode = prefs.getBool('traditional') == true
          ? ScriptMode.traditional
          : ScriptMode.simplified;
      translationLanguage = prefs.getString('translationLanguage') ?? '越南语';
      await _languageLevelStore.initializePhoenixLevel();
      memories
        ..clear()
        ..addAll(prefs.getStringList('memories') ?? <String>[]);
      savedWords
        ..clear()
        ..addAll(prefs.getStringList('savedWords') ?? <String>[]);
      earnedJourneyStampIds
        ..clear()
        ..addAll(prefs.getStringList('earnedJourneyStampIds') ?? <String>[]);
      goldCoins = prefs.getInt('wallet.gold') ?? 0;
      silverCoins = prefs.getInt('wallet.silver') ?? 0;
      bronzeCoins = prefs.getInt('wallet.bronze') ?? 0;
      silverFragments = prefs.getInt('wallet.fragment') ?? 0;
      awardedChallengeIds
        ..clear()
        ..addAll(prefs.getStringList('challenge.awardedIds') ?? <String>[]);
      unlockedSpecialJourneyIds
        ..clear()
        ..addAll(
          prefs.getStringList('specialJourney.unlockedIds') ?? <String>[],
        );

      // Migrate the original single-city stamp without losing it.
      if (prefs.getBool('beijingStampEarned') == true ||
          prefs.getBool('journeyCompleted') == true) {
        earnedJourneyStampIds.add('beijing-forbidden-city');
      }

      await _restoreActiveJourneyIdentity(prefs);
      loadStatus = AppLoadStatus.ready;
    } catch (error, stackTrace) {
      debugPrint(
        'Failed to load Phoenix state'
        '${activeJourneyRestoreFailureId == null ? '' : ' '
            '(activeJourneyId=${activeJourneyRestoreFailureId!})'}: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = activeJourneyRestoreFailureId == null
          ? '暂时无法读取你的旅程记录，请重新尝试。'
          : '无法安全恢复旅程“${activeJourneyRestoreFailureId!}”，'
              '没有加载其他旅程。请重新尝试。';
    }

    notifyListeners();
  }

  Future<void> _restoreActiveJourneyIdentity(
    SharedPreferences prefs,
  ) async {
    final hasId = prefs.containsKey(activeJourneyIdStorageKey);
    final hasNamespace = prefs.containsKey(activeJourneyNamespaceStorageKey);
    final hasVersion = prefs.containsKey(activeJourneyVersionStorageKey);

    if (!hasId && !hasNamespace && !hasVersion) {
      final defaultJourney = dailyJourneyForDate(_clock());
      activeJourneyId = defaultJourney.id;
      _loadActiveJourney(prefs);
      await _migrateActiveJourneyStorage(prefs);
      await _persistActiveJourneyIdentity(
        prefs,
        requireJourneyLocation(defaultJourney.id),
      );
      return;
    }

    final persistedId = prefs.getString(activeJourneyIdStorageKey) ?? '';
    activeJourneyId = persistedId;
    if (persistedId.trim().isEmpty) {
      _failActiveJourneyRestore(
        persistedId,
        'Persisted active Journey ID is missing or empty.',
      );
    }

    final journey = journeyExperienceById(persistedId);
    if (journey == null) {
      _failActiveJourneyRestore(
        persistedId,
        'Persisted active Journey is no longer registered.',
      );
    }

    final binding = requireJourneyLocation(journey.id);
    final persistedNamespace = prefs.getString(
      activeJourneyNamespaceStorageKey,
    );
    final persistedVersion = prefs.getInt(activeJourneyVersionStorageKey);
    if (persistedVersion != activeJourneyIdentityVersion) {
      _failActiveJourneyRestore(
        persistedId,
        'Active Journey identity version is missing or unsupported: '
        '$persistedVersion.',
      );
    }
    if (persistedNamespace != binding.storageNamespace) {
      _failActiveJourneyRestore(
        persistedId,
        'Active Journey namespace mismatch: expected '
        '${binding.storageNamespace}, found $persistedNamespace.',
      );
    }

    _loadActiveJourney(prefs);
    await _migrateActiveJourneyStorage(prefs);
  }

  Never _failActiveJourneyRestore(String requestedId, String reason) {
    activeJourneyRestoreFailureId = requestedId;
    activeJourneyRestoreFailureReason = reason;
    throw StateError(
      'Cannot restore active Journey "$requestedId": $reason',
    );
  }

  Future<void> _persistActiveJourneyIdentity(
    SharedPreferences prefs,
    JourneyLocationBinding binding,
  ) async {
    await Future.wait([
      prefs.setString(activeJourneyIdStorageKey, binding.journeyId),
      prefs.setString(
        activeJourneyNamespaceStorageKey,
        binding.storageNamespace,
      ),
      prefs.setInt(
        activeJourneyVersionStorageKey,
        activeJourneyIdentityVersion,
      ),
    ]);
  }

  void _loadActiveJourney(SharedPreferences prefs) {
    final isLegacyBeijing = activeJourneyId == 'beijing-forbidden-city';
    final isSummerPalace = activeJourneyId == 'beijing-summer-palace';
    final storedDifficulty = _readJourneyString(prefs, 'difficulty');
    journeyDifficulty = parseJourneyDifficulty(storedDifficulty);
    journeyDifficultyChosen = storedDifficulty != null;
    final storedStep =
        _readJourneyInt(prefs, 'step') ??
        (isLegacyBeijing ? prefs.getInt('beijingJourneyStep') : null) ??
        0;
    final storedFurthest =
        _readJourneyInt(prefs, 'furthestStep') ??
        (isLegacyBeijing ? prefs.getInt('beijingJourneyFurthestStep') : null) ??
        storedStep;

    _journeyStep = _safeJourneyStep(storedStep);
    _journeyFurthestStep = math
        .max(_journeyStep, _safeJourneyStep(storedFurthest))
        .toInt();
    journeyCompleted =
        _readJourneyBool(prefs, 'completed') ??
        (isLegacyBeijing ? prefs.getBool('journeyCompleted') ?? false : false);
    wonderDraft =
        _readJourneyString(prefs, 'wonderDraft') ??
        (isLegacyBeijing ? prefs.getString('wonderDraft') : null) ??
        '';
    expressDraft =
        _readJourneyString(prefs, 'expressDraft') ??
        (isLegacyBeijing ? prefs.getString('expressDraft') : null) ??
        '';
    memoryDraft =
        _readJourneyString(prefs, 'memoryDraft') ??
        (isLegacyBeijing ? prefs.getString('memoryDraft') : null) ??
        '';
    guideFeedbackReply = _readJourneyString(prefs, 'guideFeedbackReply') ?? '';
    guideFeedbackOffline =
        _readJourneyBool(prefs, 'guideFeedbackOffline') ?? false;
    guideFeedbackInputIdentity =
        _readJourneyString(prefs, 'guideFeedbackInputIdentity') ??
        (guideFeedbackReply.isNotEmpty && wonderDraft.trim().isNotEmpty
            ? journeyFeedbackInputIdentity(wonderDraft)
            : '');
    writingFeedbackCorrected =
        _readJourneyString(prefs, 'writingFeedbackCorrected') ?? '';
    writingFeedbackExplanation =
        _readJourneyString(prefs, 'writingFeedbackExplanation') ?? '';
    writingFeedbackNatural =
        _readJourneyString(prefs, 'writingFeedbackNatural') ?? '';
    writingFeedbackEncouragement =
        _readJourneyString(prefs, 'writingFeedbackEncouragement') ?? '';
    writingFeedbackOffline =
        _readJourneyBool(prefs, 'writingFeedbackOffline') ?? false;
    writingFeedbackInputIdentity =
        _readJourneyString(prefs, 'writingFeedbackInputIdentity') ??
        (hasWritingFeedback && expressDraft.trim().isNotEmpty
            ? journeyFeedbackInputIdentity(expressDraft)
            : '');
    journeyFlowVersion =
        _readJourneyInt(prefs, 'flowVersion') ??
        journeyFlowVersionFor(activeJourneyId);
    journeyChallengeAttemptSequence = math.max(
      0,
      _readJourneyInt(prefs, 'challengeAttemptSequence') ?? 0,
    );
    journeyChallengeAttemptId =
        _readJourneyString(prefs, 'challengeAttemptId') ?? '';
    final storedSubstage = _readJourneyString(prefs, 'compositeSubstage');
    journeyCompositeSubstage = isSummerPalace
        ? storedSubstage == null
            ? _inferLegacySummerPalaceSubstage()
            : parseJourneyCompositeSubstage(storedSubstage)
        : JourneyCompositeSubstage.none;
    journeyNarrationContentId = _readJourneyString(
      prefs,
      'narrationContentId',
    );
    journeyNarrationContentSignature = _readJourneyString(
      prefs,
      'narrationContentSignature',
    );
    journeyNarrationOffset = math.max(
      0,
      _readJourneyInt(prefs, 'narrationOffset') ?? 0,
    );
    _journeyNarrationSignatures.clear();
    _journeyNarrationOffsets.clear();
    for (final contentId in const ['story', 'discovery']) {
      final signature =
          prefs.getString(_narrationKey(contentId, 'signature')) ??
          (journeyNarrationContentId == contentId
              ? journeyNarrationContentSignature
              : null);
      final offset =
          prefs.getInt(_narrationKey(contentId, 'offset')) ??
          (journeyNarrationContentId == contentId
              ? journeyNarrationOffset
              : 0);
      if (signature != null && offset > 0) {
        _journeyNarrationSignatures[contentId] = signature;
        _journeyNarrationOffsets[contentId] = offset;
      }
    }
    journeyUpdatedAt = DateTime.tryParse(
      _readJourneyString(prefs, 'updatedAt') ??
          (isLegacyBeijing ? prefs.getString('journeyUpdatedAt') : null) ??
          '',
    );

    if (journeyCompleted) {
      _journeyStep = journeyLastStep;
      _journeyFurthestStep = journeyLastStep;
      journeyCompositeSubstage = isSummerPalace
          ? JourneyCompositeSubstage.completed
          : JourneyCompositeSubstage.none;
      journeyChallengeAttemptId = '';
    }
  }

  JourneyCompositeSubstage _inferLegacySummerPalaceSubstage() {
    if (journeyCompleted || _journeyStep >= journeyLastStep) {
      return JourneyCompositeSubstage.completed;
    }
    if (_journeyStep == 3) {
      return hasGuideFeedback
          ? JourneyCompositeSubstage.challenge
          : JourneyCompositeSubstage.reflection;
    }
    if (_journeyStep == 4) {
      return hasWritingFeedback
          ? JourneyCompositeSubstage.memory
          : JourneyCompositeSubstage.writing;
    }
    return JourneyCompositeSubstage.none;
  }

  Future<void> _migrateActiveJourneyStorage(SharedPreferences prefs) async {
    if (prefs.containsKey(_key('step')) &&
        prefs.containsKey(_key('flowVersion'))) {
      return;
    }

    final writes = <Future<bool>>[
      prefs.setInt(_key('step'), _journeyStep),
      prefs.setInt(_key('furthestStep'), _journeyFurthestStep),
      prefs.setBool(_key('completed'), journeyCompleted),
      prefs.setInt(_key('flowVersion'), journeyFlowVersion),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
      prefs.setInt(
        _key('challengeAttemptSequence'),
        journeyChallengeAttemptSequence,
      ),
      prefs.setString(_key('challengeAttemptId'), journeyChallengeAttemptId),
      prefs.setString(_key('wonderDraft'), wonderDraft),
      prefs.setString(_key('expressDraft'), expressDraft),
      prefs.setString(_key('memoryDraft'), memoryDraft),
      prefs.setString(_key('guideFeedbackReply'), guideFeedbackReply),
      prefs.setBool(_key('guideFeedbackOffline'), guideFeedbackOffline),
      prefs.setString(
        _key('guideFeedbackInputIdentity'),
        guideFeedbackInputIdentity,
      ),
      prefs.setString(
        _key('writingFeedbackCorrected'),
        writingFeedbackCorrected,
      ),
      prefs.setString(
        _key('writingFeedbackExplanation'),
        writingFeedbackExplanation,
      ),
      prefs.setString(_key('writingFeedbackNatural'), writingFeedbackNatural),
      prefs.setString(
        _key('writingFeedbackEncouragement'),
        writingFeedbackEncouragement,
      ),
      prefs.setBool(_key('writingFeedbackOffline'), writingFeedbackOffline),
      prefs.setString(
        _key('writingFeedbackInputIdentity'),
        writingFeedbackInputIdentity,
      ),
    ];
    if (journeyUpdatedAt != null) {
      writes.add(
        prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
      );
    }
    await Future.wait(writes);
  }

  int _safeJourneyStep(int value) {
    return value.clamp(0, journeyLastStep).toInt();
  }

  Future<void> activateJourney(String journeyId) async {
    final journey = requireDailyJourneyExperience(journeyId);
    final binding = requireJourneyLocation(journey.id);
    final prefs = await _preferencesLoader();

    if (journey.id != activeJourneyId) {
      activeJourneyId = journey.id;
      activeJourneyRestoreFailureId = null;
      activeJourneyRestoreFailureReason = null;
      _loadActiveJourney(prefs);
      await _migrateActiveJourneyStorage(prefs);
    }

    await _persistActiveJourneyIdentity(prefs, binding);
    notifyListeners();
  }

  Future<void> refreshDailyJourney() async {
    final dailyId = dailyJourneyForDate(_clock()).id;
    if (dailyId == activeJourneyId) return;
    await activateJourney(dailyId);
  }

  Future<void> toggleScript() async {
    scriptMode = scriptMode == ScriptMode.simplified
        ? ScriptMode.traditional
        : ScriptMode.simplified;
    notifyListeners();

    final prefs = await _preferencesLoader();
    await prefs.setBool('traditional', scriptMode == ScriptMode.traditional);
  }

  void setTab(int value) {
    selectedTab = value.clamp(0, 4).toInt();
    notifyListeners();
  }

  Future<void> setTranslationLanguage(String value) async {
    translationLanguage = value;
    final prefs = await _preferencesLoader();
    await prefs.setString('translationLanguage', value);
    notifyListeners();
  }

  Future<void> setJourneyDifficulty(JourneyDifficulty value) async {
    journeyDifficulty = value;
    journeyDifficultyChosen = true;
    notifyListeners();

    final prefs = await _preferencesLoader();
    await prefs.setString(_key('difficulty'), value.storageValue);
  }

  bool isSpecialJourneyUnlocked(String journeyId) {
    return unlockedSpecialJourneyIds.contains(journeyId);
  }

  int walletBalance(String currency) {
    return switch (currency) {
      '金币' => goldCoins,
      '银币' => silverCoins,
      '铜币' => bronzeCoins,
      _ => silverFragments,
    };
  }

  Future<bool> awardChallengeRewardOnce({
    required String reward,
    required String awardId,
  }) async {
    if (!awardedChallengeIds.add(awardId)) return false;
    _addCurrency(reward, 1);
    notifyListeners();
    await _persistWallet();
    return true;
  }

  Future<void> awardChallengeReward(String reward) async {
    await awardChallengeRewardOnce(
      reward: reward,
      awardId:
          'legacy:${_clock().microsecondsSinceEpoch}:${awardedChallengeIds.length}',
    );
  }

  Future<SpecialJourneyUnlockResult> unlockSpecialJourney({
    required String journeyId,
    required String currency,
    required int cost,
  }) async {
    final initialBalance = walletBalance(currency);
    if (isSpecialJourneyUnlocked(journeyId)) {
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.alreadyUnlocked,
        currency: currency,
        cost: cost,
        balance: initialBalance,
      );
    }
    if (!_specialJourneyUnlocksInFlight.add(journeyId)) {
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.busy,
        currency: currency,
        cost: cost,
        balance: initialBalance,
      );
    }

    try {
      if (isSpecialJourneyUnlocked(journeyId)) {
        return SpecialJourneyUnlockResult(
          status: SpecialJourneyUnlockStatus.alreadyUnlocked,
          currency: currency,
          cost: cost,
          balance: walletBalance(currency),
        );
      }
      final currentBalance = walletBalance(currency);
      if (cost < 0 || currentBalance < cost) {
        return SpecialJourneyUnlockResult(
          status: SpecialJourneyUnlockStatus.insufficientFunds,
          currency: currency,
          cost: cost,
          balance: currentBalance,
        );
      }

      _addCurrency(currency, -cost);
      unlockedSpecialJourneyIds.add(journeyId);
      notifyListeners();
      await _persistWallet();
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.unlocked,
        currency: currency,
        cost: cost,
        balance: walletBalance(currency),
      );
    } finally {
      _specialJourneyUnlocksInFlight.remove(journeyId);
    }
  }

  void _addCurrency(String currency, int amount) {
    if (currency == '金币') {
      goldCoins = math.max(0, goldCoins + amount).toInt();
    } else if (currency == '银币') {
      silverCoins = math.max(0, silverCoins + amount).toInt();
    } else if (currency == '铜币') {
      bronzeCoins = math.max(0, bronzeCoins + amount).toInt();
    } else {
      silverFragments = math.max(0, silverFragments + amount).toInt();
    }
  }

  Future<void> _persistWallet() async {
    final prefs = await _preferencesLoader();
    final awarded = awardedChallengeIds.toList()..sort();
    final unlocked = unlockedSpecialJourneyIds.toList()..sort();
    await Future.wait([
      prefs.setInt('wallet.gold', goldCoins),
      prefs.setInt('wallet.silver', silverCoins),
      prefs.setInt('wallet.bronze', bronzeCoins),
      prefs.setInt('wallet.fragment', silverFragments),
      prefs.setStringList('challenge.awardedIds', awarded),
      prefs.setStringList('specialJourney.unlockedIds', unlocked),
    ]);
  }

  Future<void> toggleSavedWord(String word) async {
    if (savedWords.contains(word)) {
      savedWords.remove(word);
    } else {
      savedWords.add(word);
    }
    notifyListeners();

    final prefs = await _preferencesLoader();
    final orderedWords = savedWords.toList()..sort();
    await prefs.setStringList('savedWords', orderedWords);
  }

  Future<void> saveJourneyProgress({
    required int step,
    required String wonder,
    required String express,
    required String memory,
    JourneyCompositeSubstage? compositeSubstage,
  }) async {
    final safeStep = _safeJourneyStep(step);
    _journeyStep = safeStep;
    _journeyFurthestStep = math.max(_journeyFurthestStep, safeStep).toInt();
    journeyFlowVersion = journeyFlowVersionFor(activeJourneyId);
    journeyCompositeSubstage = activeJourneyId == 'beijing-summer-palace'
        ? compositeSubstage ?? journeyCompositeSubstage
        : JourneyCompositeSubstage.none;
    wonderDraft = wonder;
    expressDraft = express;
    memoryDraft = memory;
    journeyUpdatedAt = _clock();
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.setInt(_key('step'), _journeyStep),
      prefs.setInt(_key('furthestStep'), _journeyFurthestStep),
      prefs.setInt(_key('flowVersion'), journeyFlowVersion),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
      prefs.setString(_key('wonderDraft'), wonderDraft),
      prefs.setString(_key('expressDraft'), expressDraft),
      prefs.setString(_key('memoryDraft'), memoryDraft),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<String> ensureChallengeAttemptIdentity() async {
    if (journeyChallengeAttemptId.isNotEmpty) {
      return journeyChallengeAttemptId;
    }
    journeyChallengeAttemptSequence += 1;
    journeyChallengeAttemptId =
        '$activeJourneyId:flow-v$journeyFlowVersion:attempt-$journeyChallengeAttemptSequence';
    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.setInt(
        _key('challengeAttemptSequence'),
        journeyChallengeAttemptSequence,
      ),
      prefs.setString(_key('challengeAttemptId'), journeyChallengeAttemptId),
    ]);
    notifyListeners();
    return journeyChallengeAttemptId;
  }

  Future<void> _queueJourneyNarrationPersistence(
    Future<void> Function(SharedPreferences preferences) operation,
  ) {
    final previous = _journeyNarrationPersistence;
    final next = () async {
      try {
        await previous;
      } catch (_) {
        // Keep later latest-intent persistence moving after an older failure.
      }
      final preferences = await _preferencesLoader();
      await operation(preferences);
    }();
    _journeyNarrationPersistence = next.catchError((_) {});
    return next;
  }

  Future<void> saveJourneyNarrationPosition({
    required String contentId,
    required String contentSignature,
    required int offset,
  }) {
    final safeOffset = math.max(0, offset);
    journeyNarrationContentId = contentId;
    journeyNarrationContentSignature = contentSignature;
    journeyNarrationOffset = safeOffset;
    _journeyNarrationSignatures[contentId] = contentSignature;
    _journeyNarrationOffsets[contentId] = safeOffset;
    return _queueJourneyNarrationPersistence(
      (prefs) => Future.wait([
        prefs.setString(_key('narrationContentId'), contentId),
        prefs.setString(_key('narrationContentSignature'), contentSignature),
        prefs.setInt(_key('narrationOffset'), safeOffset),
        prefs.setString(_narrationKey(contentId, 'signature'), contentSignature),
        prefs.setInt(_narrationKey(contentId, 'offset'), safeOffset),
      ]),
    );
  }

  Future<void> clearJourneyNarrationPosition({String? contentId}) {
    if (contentId != null) {
      _journeyNarrationSignatures.remove(contentId);
      _journeyNarrationOffsets.remove(contentId);
      if (journeyNarrationContentId == contentId) {
        journeyNarrationContentId = null;
        journeyNarrationContentSignature = null;
        journeyNarrationOffset = 0;
      }
      return _queueJourneyNarrationPersistence(
        (prefs) => Future.wait([
          prefs.remove(_narrationKey(contentId, 'signature')),
          prefs.remove(_narrationKey(contentId, 'offset')),
        ]),
      );
    }

    journeyNarrationContentId = null;
    journeyNarrationContentSignature = null;
    journeyNarrationOffset = 0;
    _journeyNarrationSignatures.clear();
    _journeyNarrationOffsets.clear();
    return _queueJourneyNarrationPersistence(
      (prefs) => Future.wait([
        prefs.remove(_key('narrationContentId')),
        prefs.remove(_key('narrationContentSignature')),
        prefs.remove(_key('narrationOffset')),
        for (final id in const ['story', 'discovery'])
          prefs.remove(_narrationKey(id, 'signature')),
        for (final id in const ['story', 'discovery'])
          prefs.remove(_narrationKey(id, 'offset')),
      ]),
    );
  }

  Future<void> saveGuideFeedback({
    required String reply,
    required bool isOfflineFallback,
    String inputIdentity = '',
  }) async {
    guideFeedbackReply = reply.trim();
    guideFeedbackOffline = isOfflineFallback;
    guideFeedbackInputIdentity = inputIdentity;
    if (activeJourneyId == 'beijing-summer-palace') {
      journeyCompositeSubstage = JourneyCompositeSubstage.challenge;
    }
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.setString(_key('guideFeedbackReply'), guideFeedbackReply),
      prefs.setBool(_key('guideFeedbackOffline'), guideFeedbackOffline),
      prefs.setString(
        _key('guideFeedbackInputIdentity'),
        guideFeedbackInputIdentity,
      ),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
    ]);
  }

  Future<void> clearGuideFeedback() async {
    if (!hasGuideFeedback && guideFeedbackInputIdentity.isEmpty) return;
    guideFeedbackReply = '';
    guideFeedbackOffline = false;
    guideFeedbackInputIdentity = '';
    if (activeJourneyId == 'beijing-summer-palace' && _journeyStep == 3) {
      journeyCompositeSubstage = JourneyCompositeSubstage.reflection;
    }
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.remove(_key('guideFeedbackReply')),
      prefs.remove(_key('guideFeedbackOffline')),
      prefs.remove(_key('guideFeedbackInputIdentity')),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
    ]);
  }

  Future<void> saveWritingFeedback({
    required String corrected,
    required String explanation,
    required String natural,
    required String encouragement,
    required bool isOfflineFallback,
    String inputIdentity = '',
  }) async {
    writingFeedbackCorrected = corrected.trim();
    writingFeedbackExplanation = explanation.trim();
    writingFeedbackNatural = natural.trim();
    writingFeedbackEncouragement = encouragement.trim();
    writingFeedbackOffline = isOfflineFallback;
    writingFeedbackInputIdentity = inputIdentity;
    if (activeJourneyId == 'beijing-summer-palace') {
      journeyCompositeSubstage = JourneyCompositeSubstage.memory;
    }
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.setString(
        _key('writingFeedbackCorrected'),
        writingFeedbackCorrected,
      ),
      prefs.setString(
        _key('writingFeedbackExplanation'),
        writingFeedbackExplanation,
      ),
      prefs.setString(_key('writingFeedbackNatural'), writingFeedbackNatural),
      prefs.setString(
        _key('writingFeedbackEncouragement'),
        writingFeedbackEncouragement,
      ),
      prefs.setBool(_key('writingFeedbackOffline'), writingFeedbackOffline),
      prefs.setString(
        _key('writingFeedbackInputIdentity'),
        writingFeedbackInputIdentity,
      ),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
    ]);
  }

  Future<void> clearWritingFeedback() async {
    if (!hasWritingFeedback && writingFeedbackInputIdentity.isEmpty) return;
    writingFeedbackCorrected = '';
    writingFeedbackExplanation = '';
    writingFeedbackNatural = '';
    writingFeedbackEncouragement = '';
    writingFeedbackOffline = false;
    writingFeedbackInputIdentity = '';
    if (activeJourneyId == 'beijing-summer-palace' && _journeyStep == 4) {
      journeyCompositeSubstage = JourneyCompositeSubstage.writing;
    }
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.remove(_key('writingFeedbackCorrected')),
      prefs.remove(_key('writingFeedbackExplanation')),
      prefs.remove(_key('writingFeedbackNatural')),
      prefs.remove(_key('writingFeedbackEncouragement')),
      prefs.remove(_key('writingFeedbackOffline')),
      prefs.remove(_key('writingFeedbackInputIdentity')),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
    ]);
  }

  Future<void> restartJourney() async {
    journeyCompleted = false;
    _journeyStep = 0;
    _journeyFurthestStep = 0;
    journeyFlowVersion = journeyFlowVersionFor(activeJourneyId);
    journeyCompositeSubstage = JourneyCompositeSubstage.none;
    journeyChallengeAttemptId = '';
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    journeyNarrationContentId = null;
    journeyNarrationContentSignature = null;
    journeyNarrationOffset = 0;
    _journeyNarrationSignatures.clear();
    _journeyNarrationOffsets.clear();
    guideFeedbackReply = '';
    guideFeedbackOffline = false;
    guideFeedbackInputIdentity = '';
    writingFeedbackCorrected = '';
    writingFeedbackExplanation = '';
    writingFeedbackNatural = '';
    writingFeedbackEncouragement = '';
    writingFeedbackOffline = false;
    writingFeedbackInputIdentity = '';
    journeyUpdatedAt = _clock();
    notifyListeners();

    final prefs = await _preferencesLoader();
    await Future.wait([
      prefs.setBool(_key('completed'), false),
      prefs.setInt(_key('step'), 0),
      prefs.setInt(_key('furthestStep'), 0),
      prefs.setInt(_key('flowVersion'), journeyFlowVersion),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
      prefs.remove(_key('challengeAttemptId')),
      prefs.remove(_key('wonderDraft')),
      prefs.remove(_key('expressDraft')),
      prefs.remove(_key('memoryDraft')),
      prefs.remove(_key('narrationContentId')),
      prefs.remove(_key('narrationContentSignature')),
      prefs.remove(_key('narrationOffset')),
      for (final id in const ['story', 'discovery'])
        prefs.remove(_narrationKey(id, 'signature')),
      for (final id in const ['story', 'discovery'])
        prefs.remove(_narrationKey(id, 'offset')),
      prefs.remove(_key('guideFeedbackReply')),
      prefs.remove(_key('guideFeedbackOffline')),
      prefs.remove(_key('guideFeedbackInputIdentity')),
      prefs.remove(_key('writingFeedbackCorrected')),
      prefs.remove(_key('writingFeedbackExplanation')),
      prefs.remove(_key('writingFeedbackNatural')),
      prefs.remove(_key('writingFeedbackEncouragement')),
      prefs.remove(_key('writingFeedbackOffline')),
      prefs.remove(_key('writingFeedbackInputIdentity')),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<void> completeJourney(String memory) async {
    journeyCompleted = true;
    earnedJourneyStampIds.add(activeJourneyId);
    _journeyStep = journeyLastStep;
    _journeyFurthestStep = journeyLastStep;
    journeyCompositeSubstage = activeJourneyId == 'beijing-summer-palace'
        ? JourneyCompositeSubstage.completed
        : JourneyCompositeSubstage.none;
    journeyChallengeAttemptId = '';
    if (memory.trim().isNotEmpty) {
      memories.insert(0, '${activeJourney.stampTitle}｜${memory.trim()}');
    }
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    journeyNarrationContentId = null;
    journeyNarrationContentSignature = null;
    journeyNarrationOffset = 0;
    _journeyNarrationSignatures.clear();
    _journeyNarrationOffsets.clear();
    journeyUpdatedAt = _clock();

    final prefs = await _preferencesLoader();
    final stamps = earnedJourneyStampIds.toList()..sort();
    await Future.wait([
      prefs.setBool(_key('completed'), true),
      prefs.setStringList('earnedJourneyStampIds', stamps),
      prefs.setStringList('memories', memories),
      prefs.setInt(_key('step'), journeyLastStep),
      prefs.setInt(_key('furthestStep'), journeyLastStep),
      prefs.setString(
        _key('compositeSubstage'),
        journeyCompositeSubstage.storageValue,
      ),
      prefs.remove(_key('challengeAttemptId')),
      prefs.remove(_key('wonderDraft')),
      prefs.remove(_key('expressDraft')),
      prefs.remove(_key('memoryDraft')),
      prefs.remove(_key('narrationContentId')),
      prefs.remove(_key('narrationContentSignature')),
      prefs.remove(_key('narrationOffset')),
      for (final id in const ['story', 'discovery'])
        prefs.remove(_narrationKey(id, 'signature')),
      for (final id in const ['story', 'discovery'])
        prefs.remove(_narrationKey(id, 'offset')),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
    notifyListeners();
  }
}
