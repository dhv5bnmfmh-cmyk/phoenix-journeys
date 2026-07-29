import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_voice_picker_service.dart';
import '../services/narration_voice_quality.dart';
import '../theme/phoenix_theme.dart';

class NarrationVoicePickerButton extends StatefulWidget {
  const NarrationVoicePickerButton({
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final bool dark;
  final bool compact;

  @override
  State<NarrationVoicePickerButton> createState() =>
      _NarrationVoicePickerButtonState();
}

class _NarrationVoicePickerButtonState
    extends State<NarrationVoicePickerButton> {
  bool _pressed = false;

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

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = widget.dark ? Colors.white : PhoenixTheme.red;
    final background = widget.dark
        ? Colors.white.withValues(alpha: _pressed ? .24 : .12)
        : Colors.white.withValues(alpha: _pressed ? .96 : .88);
    final border = widget.dark
        ? Colors.white.withValues(alpha: _pressed ? .48 : .24)
        : PhoenixTheme.red.withValues(alpha: _pressed ? .48 : .26);
    final radius = BorderRadius.circular(widget.compact ? 11 : 13);

    return Tooltip(
      message: '选择朗读声线',
      child: Semantics(
        button: true,
        label: '声线选择',
        child: AnimatedScale(
          scale: _pressed ? .92 : 1,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            key: const ValueKey('narration-voice-picker'),
            duration: const Duration(milliseconds: 100),
            width: widget.compact ? 36 : 49,
            height: widget.compact ? 31 : 36,
            decoration: BoxDecoration(
              color: background,
              borderRadius: radius,
              border: Border.all(color: border),
              boxShadow: _pressed
                  ? const []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: widget.dark ? .12 : .08,
                        ),
                        blurRadius: widget.compact ? 4 : 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: radius,
              child: InkWell(
                onTap: () => unawaited(_open(context)),
                onTapDown: (_) => _setPressed(true),
                onTapUp: (_) => _setPressed(false),
                onTapCancel: () => _setPressed(false),
                borderRadius: radius,
                splashColor: foreground.withValues(alpha: .20),
                highlightColor: foreground.withValues(alpha: .10),
                child: widget.compact
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                            size: 13,
                            color: foreground,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '声线',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 6.8,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                            size: 14,
                            color: foreground,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '声线',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 9,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
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
                        selected: selected,
                        selectedTileColor:
                            PhoenixTheme.red.withValues(alpha: .06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF7E6C2),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: PhoenixTheme.red,
                          ),
                        ),
                        title: const Text(
                          '自动选择最佳声线',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        subtitle: const Text('根据设备与中文地区自动匹配'),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: PhoenixTheme.red,
                              )
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
                      selected: selected,
                      selectedTileColor:
                          PhoenixTheme.red.withValues(alpha: .06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            PhoenixTheme.red.withValues(alpha: .08),
                        child: const Icon(
                          Icons.multitrack_audio_rounded,
                          color: PhoenixTheme.red,
                        ),
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
                          IconButton.filledTonal(
                            tooltip: '试听',
                            onPressed: () => unawaited(_preview(voice)),
                            icon: Icon(
                              previewing
                                  ? Icons.graphic_eq_rounded
                                  : Icons.play_arrow_rounded,
                              color: PhoenixTheme.red,
                            ),
                          ),
                          if (selected)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: PhoenixTheme.red,
                              ),
                            ),
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
