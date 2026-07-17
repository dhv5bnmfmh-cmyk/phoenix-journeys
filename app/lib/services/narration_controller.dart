import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum NarrationStatus { idle, playing, paused, error }

@immutable
class NarrationSpeedOption {
  const NarrationSpeedOption({required this.label, required this.rate});

  final String label;
  final double rate;
}

@immutable
class NarrationItem {
  const NarrationItem({
    required this.id,
    required this.text,
    required this.label,
  });

  final String id;
  final String text;
  final String label;
}

@immutable
class NarrationTextPlan {
  const NarrationTextPlan._({
    required this.items,
    required this.text,
    required this.itemStarts,
  });

  factory NarrationTextPlan.fromItems(List<NarrationItem> sourceItems) {
    final items = sourceItems
        .where((item) => item.text.trim().isNotEmpty)
        .toList(growable: false);
    final buffer = StringBuffer();
    final starts = <int>[];

    for (var index = 0; index < items.length; index += 1) {
      starts.add(buffer.length);
      buffer.write(items[index].text.trim());
      if (index != items.length - 1) buffer.write('\n');
    }

    return NarrationTextPlan._(
      items: items,
      text: buffer.toString(),
      itemStarts: starts,
    );
  }

  final List<NarrationItem> items;
  final String text;
  final List<int> itemStarts;

  bool get isEmpty => items.isEmpty || text.isEmpty;

  int? indexForOffset(int offset) {
    if (isEmpty) return null;

    final safeOffset = offset < 0
        ? 0
        : offset > text.length
            ? text.length
            : offset;

    for (var index = 0; index < itemStarts.length - 1; index += 1) {
      if (safeOffset < itemStarts[index + 1]) return index;
    }

    return itemStarts.length - 1;
  }
}

/// Owns all spoken-audio state for Phoenix Journeys.
///
/// It coordinates long-form narration, play/pause/resume, speed changes,
/// temporary vocabulary interruptions, and automatic continuation from the
/// saved reading position.
class PhoenixNarrationAgent extends ChangeNotifier {
  PhoenixNarrationAgent({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _bindHandlers();
  }

  static const speedOptions = <NarrationSpeedOption>[
    NarrationSpeedOption(label: '0.8×', rate: .32),
    NarrationSpeedOption(label: '1.0×', rate: .40),
    NarrationSpeedOption(label: '1.2×', rate: .48),
    NarrationSpeedOption(label: '1.5×', rate: .60),
  ];

  final FlutterTts _tts;

  NarrationStatus _status = NarrationStatus.idle;
  NarrationTextPlan _plan =
      NarrationTextPlan.fromItems(const <NarrationItem>[]);
  String? _contentId;
  String? _errorMessage;
  int _speechBaseOffset = 0;
  int _currentOffset = 0;
  int? _currentItemIndex;
  double _speechRate = .40;
  bool _disposed = false;

  bool _isInterrupting = false;
  String? _interruptionLabel;
  Completer<void>? _interruptionCompleter;
  int _interruptionGeneration = 0;

  NarrationStatus get status => _status;
  String? get contentId => _contentId;
  String? get errorMessage => _errorMessage;
  int? get currentItemIndex => _currentItemIndex;
  int get itemCount => _plan.items.length;
  bool get hasContent => !_plan.isEmpty;
  double get speechRate => _speechRate;
  bool get isInterrupting => _isInterrupting;
  String? get interruptionLabel => _interruptionLabel;

  String get speedLabel {
    return speedOptions
        .firstWhere(
          (option) => (option.rate - _speechRate).abs() < .001,
          orElse: () => speedOptions[1],
        )
        .label;
  }

  String? get currentItemLabel {
    if (_isInterrupting && _interruptionLabel != null) {
      return _interruptionLabel;
    }

    final index = _currentItemIndex;
    if (index == null || index < 0 || index >= _plan.items.length) {
      return null;
    }
    return _plan.items[index].label;
  }

  double get progress {
    if (_plan.text.isEmpty) return 0;
    final value = _currentOffset / _plan.text.length;
    return value.clamp(0.0, 1.0).toDouble();
  }

  void _bindHandlers() {
    _tts.setStartHandler(() {
      if (_isInterrupting) {
        _safeNotify();
        return;
      }
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _safeNotify();
    });

    _tts.setCompletionHandler(() {
      if (_isInterrupting) {
        final completer = _interruptionCompleter;
        if (completer != null && !completer.isCompleted) completer.complete();
        return;
      }

      _status = NarrationStatus.idle;
      _currentOffset = _plan.text.length;
      _currentItemIndex = null;
      _safeNotify();
    });

    _tts.setCancelHandler(() {
      if (_isInterrupting || _status == NarrationStatus.paused) return;
      _status = NarrationStatus.idle;
      _currentItemIndex = null;
      _safeNotify();
    });

    _tts.setProgressHandler((_, startOffset, __, ___) {
      if (_isInterrupting) return;
      final offset = _speechBaseOffset + startOffset;
      _currentOffset = offset < 0
          ? 0
          : offset > _plan.text.length
              ? _plan.text.length
              : offset;
      _currentItemIndex = _plan.indexForOffset(_currentOffset);
      _safeNotify();
    });

    _tts.setErrorHandler((message) {
      if (_isInterrupting) {
        final completer = _interruptionCompleter;
        if (completer != null && !completer.isCompleted) completer.complete();
        debugPrint('Vocabulary interruption error: $message');
        return;
      }

      _status = NarrationStatus.error;
      _errorMessage = '当前设备暂时无法朗读，请检查声音设置后重试。';
      _currentItemIndex = null;
      debugPrint('Narration error: $message');
      _safeNotify();
    });
  }

  Future<void> play({
    required String contentId,
    required List<NarrationItem> items,
  }) async {
    final plan = NarrationTextPlan.fromItems(items);
    if (plan.isEmpty) return;

    _cancelInterruption();
    _contentId = contentId;
    _plan = plan;
    _currentOffset = 0;
    _currentItemIndex = 0;
    _errorMessage = null;
    await _speakFrom(0);
  }

  Future<void> pause() async {
    if (_status != NarrationStatus.playing || _isInterrupting) return;

    _status = NarrationStatus.paused;
    _safeNotify();

    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('Unable to pause narration: $error');
    }

    if (_disposed) return;
    _status = NarrationStatus.paused;
    _safeNotify();
  }

  Future<void> resume() async {
    if (_status != NarrationStatus.paused || _plan.isEmpty || _isInterrupting) {
      return;
    }

    final offset = _currentOffset >= _plan.text.length ? 0 : _currentOffset;
    await _speakFrom(offset);
  }

  Future<void> restart() async {
    if (_plan.isEmpty || _contentId == null) return;
    _cancelInterruption();
    await _speakFrom(0);
  }

  Future<void> setSpeechRate(double rate) async {
    final option = speedOptions.reduce(
      (current, next) => (next.rate - rate).abs() <
              (current.rate - rate).abs()
          ? next
          : current,
    );
    if ((_speechRate - option.rate).abs() < .001) return;

    _speechRate = option.rate;
    _safeNotify();

    if (_status == NarrationStatus.playing && !_plan.isEmpty && !_isInterrupting) {
      await _speakFrom(_currentOffset);
    }
  }

  /// Temporarily interrupts long-form narration to pronounce one vocabulary
  /// item, then resumes from the saved reading offset when appropriate.
  Future<void> pronounceWordAndResume(String word) async {
    final vocabulary = word.trim();
    if (vocabulary.isEmpty || _disposed) return;

    final generation = ++_interruptionGeneration;
    final shouldResume = _status == NarrationStatus.playing && !_plan.isEmpty;
    final resumeOffset = _currentOffset;

    _interruptionCompleter?.complete();
    _interruptionCompleter = Completer<void>();

    try {
      await _tts.stop();
      if (_disposed || generation != _interruptionGeneration) return;

      _isInterrupting = true;
      _interruptionLabel = '生词 · $vocabulary';
      if (shouldResume) _status = NarrationStatus.paused;
      _errorMessage = null;
      _safeNotify();

      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(.42);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(vocabulary);

      if (result == 1) {
        await _interruptionCompleter!.future.timeout(
          const Duration(seconds: 8),
          onTimeout: () {},
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Unable to pronounce vocabulary "$vocabulary": $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (_disposed || generation != _interruptionGeneration) return;

      _isInterrupting = false;
      _interruptionLabel = null;
      _interruptionCompleter = null;
      _safeNotify();

      if (shouldResume && !_plan.isEmpty) {
        await _speakFrom(resumeOffset);
      }
    }
  }

  Future<void> stop({bool resetPosition = true}) async {
    _cancelInterruption();
    _status = NarrationStatus.idle;
    _errorMessage = null;
    _currentItemIndex = null;
    if (resetPosition) {
      _currentOffset = 0;
      _speechBaseOffset = 0;
    }
    _safeNotify();

    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('Unable to stop narration: $error');
    }

    if (_disposed) return;
    _status = NarrationStatus.idle;
    _currentItemIndex = null;
    _safeNotify();
  }

  Future<void> _speakFrom(int offset) async {
    final safeOffset = offset < 0
        ? 0
        : offset >= _plan.text.length
            ? 0
            : offset;
    final remainingText = _plan.text.substring(safeOffset);

    try {
      await _tts.stop();
      if (_disposed) return;

      _speechBaseOffset = safeOffset;
      _currentOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _safeNotify();

      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(remainingText);
      if (result != 1 && !_disposed) {
        _status = NarrationStatus.error;
        _errorMessage = '没有找到可用的中文语音，请换用 Safari 或 Chrome 重试。';
        _currentItemIndex = null;
        _safeNotify();
      }
    } catch (error, stackTrace) {
      debugPrint('Unable to start narration: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (_disposed) return;
      _status = NarrationStatus.error;
      _errorMessage = '朗读启动失败，请检查设备音量或浏览器权限。';
      _currentItemIndex = null;
      _safeNotify();
    }
  }

  void _cancelInterruption() {
    _interruptionGeneration += 1;
    _isInterrupting = false;
    _interruptionLabel = null;
    final completer = _interruptionCompleter;
    if (completer != null && !completer.isCompleted) completer.complete();
    _interruptionCompleter = null;
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelInterruption();
    unawaited(_tts.stop());
    super.dispose();
  }
}

/// Backward-compatible name while existing screens migrate to the Agent name.
class NarrationController extends PhoenixNarrationAgent {
  NarrationController({super.tts});
}
