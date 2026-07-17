import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScriptMode { simplified, traditional }

enum AppLoadStatus { loading, ready, error }

class AppState extends ChangeNotifier {
  static const int beijingJourneyLastStep = 6;

  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  int selectedTab = 0;
  bool journeyCompleted = false;
  final List<String> memories = [];
  final Set<String> savedWords = <String>{};

  int beijingJourneyStep = 0;
  int beijingJourneyFurthestStep = 0;
  String wonderDraft = '';
  String expressDraft = '';
  String memoryDraft = '';
  DateTime? journeyUpdatedAt;

  AppLoadStatus loadStatus = AppLoadStatus.loading;
  String? loadErrorMessage;

  bool get isReady => loadStatus == AppLoadStatus.ready;

  bool get hasJourneyInProgress =>
      !journeyCompleted && beijingJourneyStep > 0;

  double get beijingJourneyProgress {
    if (journeyCompleted) return 1;
    return (beijingJourneyStep + 1) / (beijingJourneyLastStep + 1);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('traditional', scriptMode == ScriptMode.traditional);
    notifyListeners();
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
