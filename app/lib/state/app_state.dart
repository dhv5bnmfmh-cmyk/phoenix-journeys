import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScriptMode { simplified, traditional }

class AppState extends ChangeNotifier {
  ScriptMode scriptMode = ScriptMode.simplified;
  String translationLanguage = '越南语';
  int selectedTab = 0;
  bool journeyCompleted = false;
  final List<String> memories = [];

  Future<void> load() async {
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
