import 'dart:async';

import 'package:flutter/foundation.dart';

/// Controls Phoenix's calm background-viewing mode on reading-focused pages.
///
/// After a short period without interaction, the journey chrome can fade away
/// without stopping narration or destroying the current reading state. Any
/// touch reveals the content immediately and restarts the idle countdown.
class PhoenixImmersionAgent extends ChangeNotifier {
  PhoenixImmersionAgent({
    this.idleDelay = const Duration(seconds: 7),
  });

  final Duration idleDelay;

  Timer? _idleTimer;
  bool _enabled = false;
  bool _immersed = false;

  bool get enabled => _enabled;
  bool get immersed => _immersed;

  void setEnabled(bool value) {
    if (_enabled == value) {
      if (value && !_immersed && _idleTimer == null) _schedule();
      return;
    }

    _enabled = value;
    _idleTimer?.cancel();
    _idleTimer = null;

    if (!value) {
      if (_immersed) {
        _immersed = false;
        notifyListeners();
      }
      return;
    }

    _schedule();
  }

  void registerInteraction() {
    if (!_enabled) return;

    _idleTimer?.cancel();
    _idleTimer = null;
    if (_immersed) {
      _immersed = false;
      notifyListeners();
    }
    _schedule();
  }

  void reveal() {
    registerInteraction();
  }

  void _schedule() {
    if (!_enabled) return;
    _idleTimer?.cancel();
    _idleTimer = Timer(idleDelay, () {
      _idleTimer = null;
      if (!_enabled || _immersed) return;
      _immersed = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }
}
