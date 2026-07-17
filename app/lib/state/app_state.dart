import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScriptMode { simplified, traditional }

enum AppLoadStatus { loading, ready, error }

class AppState extends ChangeNotifier {
  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  int selectedTab = 0;
  bool journeyCompleted = false;
  final List<String> memories = [];
  final Set<String> savedWords = <String>{};

  AppLoadStatus loadStatus = AppLoadStatus.loading;
  String? loadErrorMessage;

  bool get isReady => loadStatus == AppLoadStatus.ready;

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
      loadStatus = AppLoadStatus.ready;
    } catch (error, stackTrace) {
      debugPrint('Failed to load Phoenix state: $error');
      debugPrintStack(stackTrace: stackTrace);
      loadStatus = AppLoadStatus.error;
      loadErrorMessage = '暂时无法读取你的旅程记录，请重新尝试。';
    }

    notifyListeners();
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

  Future<void> completeJourney(String memory) async {
    journeyCompleted = true;
    if (memory.trim().isNotEmpty) {
      memories.insert(0, memory.trim());
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('journeyCompleted', true);
    await prefs.setStringList('memories', memories);
    notifyListeners();
  }
}
