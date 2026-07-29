// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:js' as js;

typedef SentenceRecognitionResult = void Function(
  String text, {
  required bool isFinal,
});
typedef SentenceRecognitionCallback = void Function();

final class SentenceRecognitionService {
  js.JsObject? _recognition;
  bool _ending = false;

  dynamic get _constructor =>
      js.context['SpeechRecognition'] ?? js.context['webkitSpeechRecognition'];

  bool get isAvailable => _constructor is js.JsFunction;

  Future<bool> start({
    required SentenceRecognitionResult onResult,
    required SentenceRecognitionCallback onComplete,
    required SentenceRecognitionCallback onError,
  }) async {
    if (!isAvailable) return false;
    await cancel();

    try {
      final recognition = js.JsObject(_constructor as js.JsFunction)
        ..['lang'] = 'zh-CN'
        ..['continuous'] = false
        ..['interimResults'] = true
        ..['maxAlternatives'] = 1;
      _recognition = recognition;
      _ending = false;

      recognition['onresult'] = js.JsFunction.withThis((dynamic _, dynamic event) {
        if (!identical(_recognition, recognition)) return;
        final results = js.JsObject.fromBrowserObject(event)['results'];
        if (results == null) return;
        final resultIndex =
            (js.JsObject.fromBrowserObject(event)['resultIndex'] as num?)
                    ?.toInt() ??
                0;
        final length = (results['length'] as num?)?.toInt() ?? 0;
        final buffer = StringBuffer();
        var finalResult = false;
        for (var index = resultIndex; index < length; index += 1) {
          final result = results[index];
          if (result == null) continue;
          final alternative = result[0];
          final transcript = '${alternative?['transcript'] ?? ''}'.trim();
          if (transcript.isNotEmpty) buffer.write(transcript);
          finalResult = finalResult || result['isFinal'] == true;
        }
        final text = buffer.toString().trim();
        if (text.isNotEmpty) onResult(text, isFinal: finalResult);
      });
      recognition['onend'] = js.JsFunction.withThis((dynamic _, dynamic event) {
        if (!identical(_recognition, recognition)) return;
        _recognition = null;
        if (_ending) return;
        onComplete();
      });
      recognition['onerror'] = js.JsFunction.withThis((dynamic _, dynamic event) {
        if (!identical(_recognition, recognition)) return;
        _recognition = null;
        if (_ending) return;
        onError();
      });
      recognition.callMethod('start');
      return true;
    } catch (_) {
      _recognition = null;
      onError();
      return false;
    }
  }

  Future<void> stop() async {
    final recognition = _recognition;
    if (recognition == null) return;
    try {
      recognition.callMethod('stop');
    } catch (_) {
      _recognition = null;
    }
  }

  Future<void> cancel() async {
    final recognition = _recognition;
    if (recognition == null) return;
    _ending = true;
    _recognition = null;
    try {
      recognition.callMethod('abort');
    } catch (_) {
      // The browser may already have ended the short recognition session.
    } finally {
      scheduleMicrotask(() => _ending = false);
    }
  }
}
