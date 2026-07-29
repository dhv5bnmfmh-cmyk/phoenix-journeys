import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_voice_picker_service.dart';
import '../services/narration_voice_quality.dart';
import '../theme/phoenix_theme.dart';

class NarrationVoicePickerButton extends StatelessWidget {
  const NarrationVoicePickerButton({
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final bool dark;
  final bool compact;

  Future<void> _open(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: .72,
        child: _NarrationVoicePickerSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? Colors.white : PhoenixTheme.red;
    return IconButton(
      key: const ValueKey('narration-voice-picker'),
      tooltip: '选择朗读声线',
      onPressed: () => unawaited(_open(context)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        width: compact ? 18 : 21,
        height: compact ? 18 : 21,
      ),
      icon: Icon(
        Icons.record_voice_over_rounded,
        size: compact ? 12 : 14,
        color: foreground,
      ),
    );
  }
}

class _NarrationVoicePickerSheet extends StatefulWidget {
  const _NarrationVoicePickerSheet();

  @override
  State<_NarrationVoicePickerSheet> createState() =>
      _NarrationVoicePickerSheetState();
}

class _NarrationVoicePickerSheetState
    extends State<_NarrationVoicePickerSheet> {
  final NarrationVoicePickerService _service = NarrationVoicePickerService();
  String _languageCode = 'zh-CN';
  late Future<List<NarrationVoiceOption>> _voices;
  String? _selectedVoiceId;
  String? _previewingVoiceId;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    unawaited(_service.stopPreview());
    super.dispose();
  }

  void _reload() {
    _selectedVoiceId = _service.selectedVoiceId(_languageCode);
    _previewingVoiceId = null;
    _voices = _service.loadVoices(_languageCode);
  }

  void _changeLanguage(String value) {
    if (value == _languageCode) return;
    setState(() {
      _languageCode = value;
      _reload();
    });
  }

  Future<void> _select(String? voiceId) async {
    await _service.selectVoice(_languageCode, voiceId);
    if (!mounted) return;
    setState(() => _selectedVoiceId = voiceId);
  }

  Future<void> _preview(NarrationVoiceOption voice) async {
    final sample = _languageCode == 'zh-TW'
        ? '風從湖面吹來，Phoenix 陪你慢慢讀完這段旅程。'
        : '风从湖面吹来，Phoenix 陪你慢慢读完这段旅程。';
    final started = await _service.previewVoice(
      voice: voice,
      languageCode: _languageCode,
      sample: sample,
    );
    if (!mounted) return;
    setState(() => _previewingVoiceId = started ? voice.id : null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '中文朗读声线',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          const Text(
            '试听后选择，Phoenix 会在这台设备上记住你的偏好。',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            key: const ValueKey('narration-voice-language-toggle'),
            segments: const [
              ButtonSegment(value: 'zh-CN', label: Text('简体普通话')),
              ButtonSegment(value: 'zh-TW', label: Text('台湾国语')),
            ],
            selected: {_languageCode},
            showSelectedIcon: false,
            onSelectionChanged: (values) => _changeLanguage(values.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<NarrationVoiceOption>>(
              future: _voices,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final voices = snapshot.data ?? const <NarrationVoiceOption>[];
                if (!_service.isAvailable || voices.isEmpty) {
                  return const Center(
                    child: Text(
                      '当前浏览器没有提供可选择的中文声线。\nPhoenix 仍会自动使用最佳可用声线。',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: voices.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final selected = _selectedVoiceId == null;
                      return ListTile(
                        key: const ValueKey('narration-voice-auto'),
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF7E6C2),
                          child: Icon(Icons.auto_awesome_rounded,
                              color: PhoenixTheme.red),
                        ),
                        title: const Text('自动选择最佳声线',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        subtitle: const Text('根据设备与中文地区自动匹配'),
                        trailing: selected
                            ? const Icon(Icons.check_circle_rounded,
                                color: PhoenixTheme.red)
                            : null,
                        onTap: () => unawaited(_select(null)),
                      );
                    }

                    final voice = voices[index - 1];
                    final selected = _selectedVoiceId == voice.id;
                    final previewing = _previewingVoiceId == voice.id;
                    return ListTile(
                      key: ValueKey('narration-voice-${voice.id}'),
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                            PhoenixTheme.red.withValues(alpha: .08),
                        child: const Icon(Icons.multitrack_audio_rounded,
                            color: PhoenixTheme.red),
                      ),
                      title: Text(
                        voice.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text('${voice.locale} · ${voice.qualityLabel}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: '试听',
                            onPressed: () => unawaited(_preview(voice)),
                            icon: Icon(
                              previewing
                                  ? Icons.graphic_eq_rounded
                                  : Icons.play_circle_outline_rounded,
                              color: PhoenixTheme.red,
                            ),
                          ),
                          if (selected)
                            const Icon(Icons.check_circle_rounded,
                                color: PhoenixTheme.red),
                        ],
                      ),
                      onTap: () => unawaited(_select(voice.id)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
