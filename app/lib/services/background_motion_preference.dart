import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMotionPreference extends ChangeNotifier {
  BackgroundMotionPreference._();

  static final BackgroundMotionPreference instance =
      BackgroundMotionPreference._();

  static const _storageKey = 'visual.reduceBackgroundMotion';

  bool _loaded = false;
  bool _reduceMotion = false;

  bool get loaded => _loaded;
  bool get reduceMotion => _reduceMotion;

  Future<void> load() async {
    if (_loaded) return;
    final preferences = await SharedPreferences.getInstance();
    _reduceMotion = preferences.getBool(_storageKey) ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setReduceMotion(bool value) async {
    if (_loaded && _reduceMotion == value) return;
    _loaded = true;
    _reduceMotion = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_storageKey, value);
  }
}
