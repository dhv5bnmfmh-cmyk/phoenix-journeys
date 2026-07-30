import 'dart:async';

import 'package:flutter/foundation.dart';

import 'narration_controller.dart';

const Duration narrationAutoFollowManualHold = Duration(milliseconds: 2400);

@visibleForTesting
Duration narrationAutoFollowRemainingHold({
  required DateTime now,
  required DateTime? holdUntil,
}) {
  if (holdUntil == null || !holdUntil.isAfter(now)) {
    return Duration.zero;
  }
  return holdUntil.difference(now);
}

class NarrationFollowCoordinator extends ChangeNotifier {
  NarrationFollowCoordinator._();

  static final Expando<NarrationFollowCoordinator> _coordinators =
      Expando<NarrationFollowCoordinator>('narration-follow-coordinator');

  static NarrationFollowCoordinator forController(
    NarrationController controller,
  ) {
    return _coordinators[controller] ??= NarrationFollowCoordinator._();
  }

  DateTime? _holdUntil;
  Timer? _expiryTimer;

  bool get isManualHoldActive => remainingHold > Duration.zero;

  Duration get remainingHold => narrationAutoFollowRemainingHold(
    now: DateTime.now(),
    holdUntil: _holdUntil,
  );

  void suspend({Duration duration = narrationAutoFollowManualHold}) {
    final now = DateTime.now();
    final requestedHoldUntil = now.add(duration);
    final currentHoldUntil = _holdUntil;
    if (currentHoldUntil == null || requestedHoldUntil.isAfter(currentHoldUntil)) {
      _holdUntil = requestedHoldUntil;
    }
    _scheduleExpiry();
    notifyListeners();
  }

  void resume() {
    if (_holdUntil == null) return;
    _expiryTimer?.cancel();
    _expiryTimer = null;
    _holdUntil = null;
    notifyListeners();
  }

  void _scheduleExpiry() {
    _expiryTimer?.cancel();
    final delay = remainingHold;
    if (delay <= Duration.zero) {
      _holdUntil = null;
      return;
    }
    _expiryTimer = Timer(delay + const Duration(milliseconds: 16), _expireHold);
  }

  void _expireHold() {
    final delay = remainingHold;
    if (delay > Duration.zero) {
      _scheduleExpiry();
      return;
    }
    _expiryTimer = null;
    _holdUntil = null;
    notifyListeners();
  }
}
