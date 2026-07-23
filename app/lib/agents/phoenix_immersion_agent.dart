import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// Controls Phoenix's calm background-viewing mode on reading-focused pages.
///
/// After a short period without interaction, the journey chrome can fade away
/// without stopping narration or destroying the current reading state. Pointer
/// activity anywhere in the app, including modal sheets, reveals the content
/// immediately and restarts the idle countdown.
class PhoenixImmersionAgent extends ChangeNotifier {
  PhoenixImmersionAgent({
    this.idleDelay = const Duration(seconds: 7),
  }) {
    _globalPointerRoute = _handleGlobalPointerEvent;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_globalPointerRoute);
  }

  final Duration idleDelay;

  late final PointerRoute _globalPointerRoute;
  Timer? _idleTimer;
  bool _enabled = false;
  bool _immersed = false;
  bool _disposed = false;

  bool get enabled => _enabled;
  bool get immersed => _immersed;

  void setEnabled(bool value) {
    if (_disposed) return;
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
    if (_disposed || !_enabled) return;

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

  void _handleGlobalPointerEvent(PointerEvent event) {
    if (event is PointerDownEvent ||
        event is PointerMoveEvent ||
        event is PointerSignalEvent) {
      registerInteraction();
    }
  }

  void _schedule() {
    if (_disposed || !_enabled) return;
    _idleTimer?.cancel();
    _idleTimer = Timer(idleDelay, () {
      _idleTimer = null;
      if (_disposed || !_enabled || _immersed) return;
      _immersed = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _enabled = false;
    _immersed = false;
    _idleTimer?.cancel();
    _idleTimer = null;
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_globalPointerRoute);
    super.dispose();
  }
}
