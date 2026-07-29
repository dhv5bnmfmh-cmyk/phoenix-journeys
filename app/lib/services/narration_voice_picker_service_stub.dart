import 'narration_voice_quality.dart';

final class NarrationVoicePickerService {
  bool get isAvailable => false;

  String? selectedVoiceId(String languageCode) => null;

  Future<List<NarrationVoiceOption>> loadVoices(String languageCode) async {
    return const <NarrationVoiceOption>[];
  }

  Future<void> selectVoice(String languageCode, String? voiceId) async {}

  Future<bool> previewVoice({
    required NarrationVoiceOption voice,
    required String languageCode,
    required String sample,
  }) async {
    return false;
  }

  Future<void> stopPreview() async {}
}
