import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:pinyin/pinyin.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScriptMode { simplified, traditional }

enum AppLoadStatus { loading, ready, error }

class AppState extends ChangeNotifier {
  static const int beijingJourneyLastStep = 6;
  static const List<String> beijingJourneyStepLabels = [
    '故事',
    '生词',
    '发现',
    '思考',
    '表达',
    '回忆',
    '完成',
  ];

  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  int selectedTab = 0;
  bool journeyCompleted = false;
  bool beijingStampEarned = false;
  final List<String> memories = [];
  final Set<String> savedWords = <String>{};

  int beijingJourneyStep = 0;
  int beijingJourneyFurthestStep = 0;
  String wonderDraft = '';
  String expressDraft = '';
  String memoryDraft = '';
  DateTime? journeyUpdatedAt;

  String journeyOrigin = '河内';
  DateTime? plannedJourneyDate;
  String journeyLearningFocus = '文化';

  AppLoadStatus loadStatus = AppLoadStatus.loading;
  String? loadErrorMessage;

  bool get isReady => loadStatus == AppLoadStatus.ready;
  bool get isTraditional => scriptMode == ScriptMode.traditional;

  String displayText(String text) {
    return isTraditional
        ? ChineseHelper.convertToTraditionalChinese(text)
        : ChineseHelper.convertToSimplifiedChinese(text);
  }

  bool get hasJourneyInProgress =>
      !journeyCompleted && beijingJourneyStep > 0;

  double get beijingJourneyProgress {
    if (journeyCompleted) return 1;
    return (beijingJourneyStep + 1) / (beijingJourneyLastStep + 1);
  }

  int get beijingJourneyProgressPercent =>
      (beijingJourneyProgress * 100).round();

  String get beijingJourneyStepLabel =>
      displayText(beijingJourneyStepLabels[_safeJourneyStep(beijingJourneyStep)]);

  String get beijingJourneyFurthestStepLabel => displayText(
        beijingJourneyStepLabels[_safeJourneyStep(beijingJourneyFurthestStep)],
      );

  bool get hasJourneyPlan => plannedJourneyDate != null;

  String get journeyPlanDateLabel {
    final date = plannedJourneyDate;
    if (date == null) return '计划';
    return '${date.month}月${date.day}日';
  }

  String get journeyPlanCountdownLabel {
    final date = plannedJourneyDate;
    if (date == null) return '计划旅程';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final days = target.difference(today).inDays;
    if (days < 0) return '计划日期已过';
    if (days == 0) return '今天出发';
    return '还有 $days 天';
  }

  bool isWordSaved(String word) => savedWords.contains(word);

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
      journeyCompleted = prefs.getBool('journeyCompleted') ?? false;
      beijingStampEarned =
          prefs.getBool('beijingStampEarned') ?? journeyCompleted;
      memories
        ..clear()
        ..addAll(prefs.getStringList('memories') ?? <String>[]);
      savedWords
        ..clear()
        ..addAll(prefs.getStringList('savedWords') ?? <String>[]);

      beijingJourneyStep = _safeJourneyStep(
        prefs.getInt('beijingJourneyStep') ?? 0,
      );
      beijingJourneyFurthestStep = math
          .max(
            beijingJourneyStep,
            _safeJourneyStep(
              prefs.getInt('beijingJourneyFurthestStep') ?? 0,
            ),
          )
          .toInt();
      wonderDraft = prefs.getString('wonderDraft') ?? '';
      expressDraft = prefs.getString('expressDraft') ?? '';
      memoryDraft = prefs.getString('memoryDraft') ?? '';
      journeyUpdatedAt = DateTime.tryParse(
        prefs.getString('journeyUpdatedAt') ?? '',
      );

      final storedOrigin = prefs.getString('journeyOrigin')?.trim();
      journeyOrigin = storedOrigin == null || storedOrigin.isEmpty
          ? '河内'
          : storedOrigin;
      plannedJourneyDate = DateTime.tryParse(
        prefs.getString('plannedJourneyDate') ?? '',
      );
      journeyLearningFocus =
          prefs.getString('journeyLearningFocus') ?? '文化';

      if (journeyCompleted) {
        beijingJourneyStep = beijingJourneyLastStep;
        beijingJourneyFurthestStep = beijingJourneyLastStep;
      }

      loadStatus = AppLoadStatus.ready;
    } catch (error, stackTrace) {
      debugPrint('Failed to load Phoenix state: $error');
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = '暂时无法读取你的旅程记录，请重新尝试。';
    }

    notifyListeners();
  }

  int _safeJourneyStep(int value) {
    return value.clamp(0, beijingJourneyLastStep).toInt();
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
    beijingJourneyStep = safeStep;
    beijingJourneyFurthestStep = math
        .max(
          beijingJourneyFurthestStep,
          safeStep,
        )
        .toInt();
    wonderDraft = wonder;
    expressDraft = express;
    memoryDraft = memory;
    journeyUpdatedAt = DateTime.now();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt('beijingJourneyStep', beijingJourneyStep),
      prefs.setInt(
        'beijingJourneyFurthestStep',
        beijingJourneyFurthestStep,
      ),
      prefs.setString('wonderDraft', wonderDraft),
      prefs.setString('expressDraft', expressDraft),
      prefs.setString('memoryDraft', memoryDraft),
      prefs.setString('journeyUpdatedAt', journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<void> saveJourneyPlan({
    required String origin,
    required DateTime date,
    required String focus,
  }) async {
    final normalizedOrigin = origin.trim();
    if (normalizedOrigin.isEmpty) return;

    journeyOrigin = normalizedOrigin;
    plannedJourneyDate = DateTime(date.year, date.month, date.day);
    journeyLearningFocus = focus;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('journeyOrigin', journeyOrigin),
      prefs.setString(
        'plannedJourneyDate',
        plannedJourneyDate!.toIso8601String(),
      ),
      prefs.setString('journeyLearningFocus', journeyLearningFocus),
    ]);
  }

  Future<void> restartJourney() async {
    journeyCompleted = false;
    beijingJourneyStep = 0;
    beijingJourneyFurthestStep = 0;
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    journeyUpdatedAt = DateTime.now();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool('journeyCompleted', false),
      prefs.setInt('beijingJourneyStep', 0),
      prefs.setInt('beijingJourneyFurthestStep', 0),
      prefs.remove('wonderDraft'),
      prefs.remove('expressDraft'),
      prefs.remove('memoryDraft'),
      prefs.setString('journeyUpdatedAt', journeyUpdatedAt!.toIso8601String()),
    ]);
  }

  Future<void> completeJourney(String memory) async {
    journeyCompleted = true;
    beijingStampEarned = true;
    beijingJourneyStep = beijingJourneyLastStep;
    beijingJourneyFurthestStep = beijingJourneyLastStep;
    if (memory.trim().isNotEmpty) {
      memories.insert(0, memory.trim());
    }
    wonderDraft = '';
    expressDraft = '';
    memoryDraft = '';
    journeyUpdatedAt = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool('journeyCompleted', true),
      prefs.setBool('beijingStampEarned', true),
      prefs.setStringList('memories', memories),
      prefs.setInt('beijingJourneyStep', beijingJourneyLastStep),
      prefs.setInt('beijingJourneyFurthestStep', beijingJourneyLastStep),
      prefs.remove('wonderDraft'),
      prefs.remove('expressDraft'),
      prefs.remove('memoryDraft'),
      prefs.setString('journeyUpdatedAt', journeyUpdatedAt!.toIso8601String()),
    ]);
    notifyListeners();
  }
}
