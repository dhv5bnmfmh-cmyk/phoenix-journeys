import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum NarrationStatus { idle, playing, paused, error }

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
      if (index != items.length - 1) {
        buffer.write('\n');
      }
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
      if (safeOffset < itemStarts[index + 1]) {
        return index;
      }
    }

    return itemStarts.length - 1;
  }
}

class NarrationController extends ChangeNotifier {
  NarrationController({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _bindHandlers();
  }

  final FlutterTts _tts;

  NarrationStatus _status = NarrationStatus.idle;
  NarrationTextPlan _plan =
      NarrationTextPlan.fromItems(const <NarrationItem>[]);
  String? _contentId;
  String? _errorMessage;
  int _speechBaseOffset = 0;
  int _currentOffset = 0;
  int? _currentItemIndex;
  bool _disposed = false;

  NarrationStatus get status => _status;
  String? get contentId => _contentId;
  String? get errorMessage => _errorMessage;
  int? get currentItemIndex => _currentItemIndex;
  int get itemCount => _plan.items.length;
  bool get hasContent => !_plan.isEmpty;

  String? get currentItemLabel {
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
      _status = NarrationStatus.playing;
      _errorMessage = null;
      _safeNotify();
    });
    _tts.setCompletionHandler(() {
      _status = NarrationStatus.idle;
      _currentOffset = _plan.text.length;
      _currentItemIndex = null;
      _safeNotify();
    });
    _tts.setCancelHandler(() {
      if (_status == NarrationStatus.paused) return;
      _status = NarrationStatus.idle;
      _currentItemIndex = null;
      _safeNotify();
    });
    _tts.setProgressHandler((_, startOffset, __, ___) {
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

    _contentId = contentId;
    _plan = plan;
    _currentOffset = 0;
    _currentItemIndex = 0;
    _errorMessage = null;
    await _speakFrom(0);
  }

  Future<void> pause() async {
    if (_status != NarrationStatus.playing) return;

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
    if (_status != NarrationStatus.paused || _plan.isEmpty) return;

    final offset = _currentOffset >= _plan.text.length ? 0 : _currentOffset;
    await _speakFrom(offset);
  }

  Future<void> restart() async {
    if (_plan.isEmpty || _contentId == null) return;
    await _speakFrom(0);
  }

  Future<void> stop({bool resetPosition = true}) async {
    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('Unable to stop narration: $error');
    }

    if (_disposed) return;
    _status = NarrationStatus.idle;
    _errorMessage = null;
    _currentItemIndex = null;
    if (resetPosition) {
      _currentOffset = 0;
      _speechBaseOffset = 0;
    }
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
      await _tts.setSpeechRate(0.40);
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

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_tts.stop());
    super.dispose();
  }
}
