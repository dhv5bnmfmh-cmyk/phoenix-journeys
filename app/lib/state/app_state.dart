import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:pinyin/pinyin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/daily_journey_catalog.dart';

enum ScriptMode { simplified, traditional }

enum AppLoadStatus { loading, ready, error }

class AppState extends ChangeNotifier {
  AppState({DateTime Function()? clock}) : _clock = clock ?? DateTime.now {
    activeJourneyId = dailyJourneyForDate(_clock()).id;
  }

  static const int journeyLastStep = 6;
  static const List<String> journeyStepLabels = [
    '故事',
    '生词',
    '发现',
    '思考',
    '表达',
    '回忆',
    '完成',
  ];

  // Compatibility aliases for stable widgets and older tests.
  static const int beijingJourneyLastStep = journeyLastStep;
  static const List<String> beijingJourneyStepLabels = journeyStepLabels;

  final DateTime Function() _clock;

  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  int selectedTab = 0;
  bool journeyCompleted = false;
  final List<String> memories = [];
  final Set<String> savedWords = <String>{};
  final Set<String> earnedJourneyStampIds = <String>{};

  late String activeJourneyId;
  int _journeyStep = 0;
  int _journeyFurthestStep = 0;
  String wonderDraft = '';
  String expressDraft = '';
  String memoryDraft = '';
  String guideFeedbackReply = '';
  bool guideFeedbackOffline = false;
  String writingFeedbackCorrected = '';
  String writingFeedbackExplanation = '';
  String writingFeedbackNatural = '';
  String writingFeedbackEncouragement = '';
  bool writingFeedbackOffline = false;
  DateTime? journeyUpdatedAt;

  AppLoadStatus loadStatus = AppLoadStatus.loading;
  String? loadErrorMessage;

  bool get isReady => loadStatus == AppLoadStatus.ready;
  bool get isTraditional => scriptMode == ScriptMode.traditional;
  DailyJourneyExperience get activeJourney =>
      requireDailyJourneyExperience(activeJourneyId);
  DailyJourneyExperience get todayJourney => dailyJourneyForDate(_clock());
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

  String get journeyStepLabel =>
      displayText(journeyStepLabels[_safeJourneyStep(_journeyStep)]);
  String get journeyFurthestStepLabel =>
      displayText(journeyStepLabels[_safeJourneyStep(_journeyFurthestStep)]);
  String get beijingJourneyStepLabel => journeyStepLabel;
  String get beijingJourneyFurthestStepLabel => journeyFurthestStepLabel;

  bool get hasGuideFeedback => guideFeedbackReply.trim().isNotEmpty;
  bool get hasWritingFeedback =>
      writingFeedbackCorrected.trim().isNotEmpty ||
      writingFeedbackExplanation.trim().isNotEmpty ||
      writingFeedbackNatural.trim().isNotEmpty ||
      writingFeedbackEncouragement.trim().isNotEmpty;

  bool isWordSaved(String word) => savedWords.contains(word);
  bool isJourneyStampEarned(String journeyId) =>
      earnedJourneyStampIds.contains(journeyId);

  String _key(String suffix, [String? journeyId]) =>
      'journey.${journeyId ?? activeJourneyId}.$suffix';

  Future<void> load() async {
    loadStatus = AppLoadStatus.loading;
    loadErrorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      scriptMode = prefs.getBool('traditional') == true
          ? ScriptMode.traditional
          : ScriptMode.simplified;
      translationLanguage =
          prefs.getString('translationLanguage') ?? '越南语';
      memories
        ..clear()
        ..addAll(prefs.getStringList('memories') ?? <String>[]);
      savedWords
        ..clear()
        ..addAll(prefs.getStringList('savedWords') ?? <String>[]);
      earnedJourneyStampIds
        ..clear()
        ..addAll(
          prefs.getStringList('earnedJourneyStampIds') ?? <String>[],
        );

      // Migrate the original single-city stamp without losing it.
      if (prefs.getBool('beijingStampEarned') == true ||
          prefs.getBool('journeyCompleted') == true) {
        earnedJourneyStampIds.add('beijing-forbidden-city');
      }

      activeJourneyId = dailyJourneyForDate(_clock()).id;
      _loadActiveJourney(prefs);
      loadStatus = AppLoadStatus.ready;
    } catch (error, stackTrace) {
      debugPrint('Failed to load Phoenix state: $error');
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = '暂时无法读取你的旅程记录，请重新尝试。';
    }

    notifyListeners();
  }

  void _loadActiveJourney(SharedPreferences prefs) {
    final isLegacyBeijing = activeJourneyId == 'beijing-forbidden-city';
    final storedStep = prefs.getInt(_key('step')) ??
        (isLegacyBeijing ? prefs.getInt('beijingJourneyStep') : null) ??
        0;
    final storedFurthest = prefs.getInt(_key('furthestStep')) ??
        (isLegacyBeijing
            ? prefs.getInt('beijingJourneyFurthestStep')
            : null) ??
        storedStep;

    _journeyStep = _safeJourneyStep(storedStep);
    _journeyFurthestStep = math
        .max(_journeyStep, _safeJourneyStep(storedFurthest))
        .toInt();
    journeyCompleted = prefs.getBool(_key('completed')) ??
        (isLegacyBeijing
            ? prefs.getBool('journeyCompleted') ?? false
            : false);
    wonderDraft = prefs.getString(_key('wonderDraft')) ??
        (isLegacyBeijing ? prefs.getString('wonderDraft') : null) ??
        '';
    expressDraft = prefs.getString(_key('expressDraft')) ??
        (isLegacyBeijing ? prefs.getString('expressDraft') : null) ??
        '';
    memoryDraft = prefs.getString(_key('memoryDraft')) ??
        (isLegacyBeijing ? prefs.getString('memoryDraft') : null) ??
        '';
    guideFeedbackReply = prefs.getString(_key('guideFeedbackReply')) ?? '';
    guideFeedbackOffline =
        prefs.getBool(_key('guideFeedbackOffline')) ?? false;
    writingFeedbackCorrected =
        prefs.getString(_key('writingFeedbackCorrected')) ?? '';
    writingFeedbackExplanation =
        prefs.getString(_key('writingFeedbackExplanation')) ?? '';
    writingFeedbackNatural =
        prefs.getString(_key('writingFeedbackNatural')) ?? '';
    writingFeedbackEncouragement =
        prefs.getString(_key('writingFeedbackEncouragement')) ?? '';
    writingFeedbackOffline =
        prefs.getBool(_key('writingFeedbackOffline')) ?? false;
    journeyUpdatedAt = DateTime.tryParse(
      prefs.getString(_key('updatedAt')) ??
          (isLegacyBeijing ? prefs.getString('journeyUpdatedAt') : null) ??
          '',
    );

    if (journeyCompleted) {
      _journeyStep = journeyLastStep;
      _journeyFurthestStep = journeyLastStep;
    }
  }

  int _safeJourneyStep(int value) {
    return value.clamp(0, journeyLastStep).toInt();
  }

  Future<void> activateJourney(String journeyId) async {
    if (journeyId == activeJourneyId) return;
    activeJourneyId = requireDailyJourneyExperience(journeyId).id;
    final prefs = await SharedPreferences.getInstance();
    _loadActiveJourney(prefs);
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('traditional', scriptMode == ScriptMode.traditional);
  }

  void setTab(int value) {
    selectedTab = value;
    notifyListeners();
  }

  Future<void> setTranslationLanguage(String value) async {
    translationLanguage = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('translationLanguage', value);
    notifyListeners();
  }

  Future<void> toggleSavedWord(String word) async {
    if (savedWords.contains(word)) {
      savedWords.remove(word);
    } else {
      savedWords.add(word);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final orderedWords = savedWords.toList()..sort();
    await prefs.setStringList('savedWords', orderedWords);
  }

  Future<void> saveJourneyProgress({
    required int step,
    required String wonder,
    required String express,
    required String memory,
  }) async {
    final safeStep = _safeJourneyStep(step);
    _journeyStep = safeStep;
    _journeyFurthestStep = math.max(_journeyFurthestStep, safeStep).toInt();
    wonderDraft = wonder;
    expressDraft = express;
    memoryDraft = memory;
    journeyUpdatedAt = _clock();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_key('step'), _journeyStep),
      prefs.setInt(_key('furthestStep'), _journeyFurthestStep),
      prefs.setString(_key('wonderDraft'), wonderDraft),
      prefs.setString(_key('expressDraft'), expressDraft),
      prefs.setString(_key('memoryDraft'), memoryDraft),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<void> saveGuideFeedback({
    required String reply,
    required bool isOfflineFallback,
  }) async {
    guideFeedbackReply = reply.trim();
    guideFeedbackOffline = isOfflineFallback;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_key('guideFeedbackReply'), guideFeedbackReply),
      prefs.setBool(_key('guideFeedbackOffline'), guideFeedbackOffline),
    ]);
  }

  Future<void> clearGuideFeedback() async {
    if (!hasGuideFeedback) return;
    guideFeedbackReply = '';
    guideFeedbackOffline = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_key('guideFeedbackReply')),
      prefs.remove(_key('guideFeedbackOffline')),
    ]);
  }

  Future<void> saveWritingFeedback({
    required String corrected,
    required String explanation,
    required String natural,
    required String encouragement,
    required bool isOfflineFallback,
  }) async {
    writingFeedbackCorrected = corrected.trim();
    writingFeedbackExplanation = explanation.trim();
    writingFeedbackNatural = natural.trim();
    writingFeedbackEncouragement = encouragement.trim();
    writingFeedbackOffline = isOfflineFallback;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(
        _key('writingFeedbackCorrected'),
        writingFeedbackCorrected,
      ),
      prefs.setString(
        _key('writingFeedbackExplanation'),
        writingFeedbackExplanation,
      ),
      prefs.setString(
        _key('writingFeedbackNatural'),
        writingFeedbackNatural,
      ),
      prefs.setString(
        _key('writingFeedbackEncouragement'),
        writingFeedbackEncouragement,
      ),
      prefs.setBool(_key('writingFeedbackOffline'), writingFeedbackOffline),
    ]);
  }

  Future<void> clearWritingFeedback() async {
    if (!hasWritingFeedback) return;
    writingFeedbackCorrected = '';
    writingFeedbackExplanation = '';
    writingFeedbackNatural = '';
    writingFeedbackEncouragement = '';
    writingFeedbackOffline = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_key('writingFeedbackCorrected')),
      prefs.remove(_key('writingFeedbackExplanation')),
      prefs.remove(_key('writingFeedbackNatural')),
      prefs.remove(_key('writingFeedbackEncouragement')),
      prefs.remove(_key('writingFeedbackOffline')),
    ]);
  }

  Future<void> restartJourney() async {
    journeyCompleted = false;
    _journeyStep = 0;
    _journeyFurthestStep = 0;
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    guideFeedbackReply = '';
    guideFeedbackOffline = false;
    writingFeedbackCorrected = '';
    writingFeedbackExplanation = '';
    writingFeedbackNatural = '';
    writingFeedbackEncouragement = '';
    writingFeedbackOffline = false;
    journeyUpdatedAt = _clock();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_key('completed'), false),
      prefs.setInt(_key('step'), 0),
      prefs.setInt(_key('furthestStep'), 0),
      prefs.remove(_key('wonderDraft')),
      prefs.remove(_key('expressDraft')),
      prefs.remove(_key('memoryDraft')),
      prefs.remove(_key('guideFeedbackReply')),
      prefs.remove(_key('guideFeedbackOffline')),
      prefs.remove(_key('writingFeedbackCorrected')),
      prefs.remove(_key('writingFeedbackExplanation')),
      prefs.remove(_key('writingFeedbackNatural')),
      prefs.remove(_key('writingFeedbackEncouragement')),
      prefs.remove(_key('writingFeedbackOffline')),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<void> completeJourney(String memory) async {
    journeyCompleted = true;
    earnedJourneyStampIds.add(activeJourneyId);
    _journeyStep = journeyLastStep;
    _journeyFurthestStep = journeyLastStep;
    if (memory.trim().isNotEmpty) {
      memories.insert(0, '${activeJourney.stampTitle}｜${memory.trim()}');
    }
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    journeyUpdatedAt = _clock();

    final prefs = await SharedPreferences.getInstance();
    final stamps = earnedJourneyStampIds.toList()..sort();
    await Future.wait([
      prefs.setBool(_key('completed'), true),
      prefs.setStringList('earnedJourneyStampIds', stamps),
      prefs.setStringList('memories', memories),
      prefs.setInt(_key('step'), journeyLastStep),
      prefs.setInt(_key('furthestStep'), journeyLastStep),
      prefs.remove(_key('wonderDraft')),
      prefs.remove(_key('expressDraft')),
      prefs.remove(_key('memoryDraft')),
      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),
    ]);
    notifyListeners();
  }
}
