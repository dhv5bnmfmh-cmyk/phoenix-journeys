typedef SentenceRecognitionResult = void Function(
  String text, {
  required bool isFinal,
});
typedef SentenceRecognitionCallback = void Function();

final class SentenceRecognitionService {
  bool get isAvailable => false;

  Future<bool> start({
    required SentenceRecognitionResult onResult,
    required SentenceRecognitionCallback onComplete,
    required SentenceRecognitionCallback onError,
  }) async {
    return false;
  }

  Future<void> stop() async {}

  Future<void> cancel() async {}
}
