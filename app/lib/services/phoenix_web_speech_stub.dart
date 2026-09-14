typedef PhoenixSpeechStartCallback = void Function();
typedef PhoenixSpeechProgressCallback =
    void Function(int startOffset, int endOffset, String word);
typedef PhoenixSpeechCallback = void Function();
typedef PhoenixSpeechErrorCallback = void Function(String message);

final class PhoenixWebSpeech {
  PhoenixWebSpeech({
    required PhoenixSpeechStartCallback onStart,
    required PhoenixSpeechProgressCallback onProgress,
    required PhoenixSpeechCallback onComplete,
    required PhoenixSpeechCallback onPause,
    required PhoenixSpeechCallback onResume,
    required PhoenixSpeechErrorCallback onError,
  });

  bool get isAvailable => false;
  bool get isPaused => false;

  Future<bool> speak(
    String text, {
    required String languageCode,
    required double rate,
    double pitch = .98,
    double volume = 1,
    bool cancelExisting = true,
  }) async => false;

  Future<bool> pause() async => false;
  Future<bool> resume() async => false;
  Future<void> stop() async {}
  void dispose() {}
}
