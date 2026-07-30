import 'dart:async';

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../services/narration_voice_picker_service.dart';
import '../services/narration_voice_quality.dart';
import '../theme/phoenix_theme.dart';

class NarrationVoicePickerButton extends StatefulWidget {
  const NarrationVoicePickerButton({
    required this.controller,
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final NarrationController controller;
  final bool dark;
  final bool compact;

  @override
  State<NarrationVoicePickerButton> createState() =>
      _NarrationVoicePickerButtonState();
}

class _NarrationVoicePickerButtonState
    extends State<NarrationVoicePickerButton> {
  final NarrationVoicePickerService _service = NarrationVoicePickerService();
  bool _pressed = false;
  bool _opening = false;

  String? get _selectedVoiceId {
    return _service.selectedVoiceId('zh-CN') ??
        _service.selectedVoiceId('zh-TW');
  }

  String get _initialLanguageCode {
    final simplified = _service.selectedVoiceId('zh-CN');
    final traditional = _service.selectedVoiceId('zh-TW');
    return simplified == null && traditional != null ? 'zh-TW' : 'zh-CN';
  }

  Future<void> _open(BuildContext context) async {
    if (_opening) return;
    final controller = widget.controller;
    final wasPlaying =
        controller.status == NarrationStatus.playing && controller.hasContent;
    final wasPaused =
        controller.status == NarrationStatus.paused && controller.hasContent;
    final resumeOffset = controller.currentOffset;

    setState(() => _opening = true);
    if (wasPlaying || wasPaused) {
      await controller.stop(resetPosition: false);
    }
    if (!mounted || !context.mounted) return;

    try {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: .76,
          child: _NarrationVoicePickerSheet(
            initialLanguageCode: _initialLanguageCode,
          ),
        ),
      );
    } finally {
      await _service.stopPreview();
      if (controller.hasContent) {
        if (wasPlaying) {
          await controller.resumeFromOffset(resumeOffset);
        } else if (wasPaused) {
          await controller.pauseAtOffset(resumeOffset);
        }
      }
      if (mounted) setState(() => _opening = false);
    }
  }

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final selectedVoiceId = _selectedVoiceId;
    final customSelected = selectedVoiceId != null;
    final selectionLabel = compactNarrationVoiceSelectionLabel(selectedVoiceId);
    final foreground = widget.dark ? Colors.white : PhoenixTheme.red;
    final background = widget.dark
        ? Colors.white.withValues(alpha: _pressed ? .24 : .12)
        : Colors.white.withValues(alpha: _pressed ? .96 : .88);
    final border = widget.dark
        ? Colors.white.withValues(alpha: _pressed ? .48 : .24)
        : PhoenixTheme.red.withValues(alpha: _pressed ? .48 : .26);
    final radius = BorderRadius.circular(widget.compact ? 11 : 13);

    return Tooltip(
      message: customSelected ? '选择朗读声线，当前为自选声线' : '选择朗读声线，当前为自动',
      child: Semantics(
        button: true,
        label: '声线选择，当前$selectionLabel',
        child: AnimatedScale(
          scale: _pressed ? .92 : 1,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            key: const ValueKey('narration-voice-picker'),
            duration: const Duration(milliseconds: 100),
            width: widget.compact ? 39 : 58,
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
                onTap: _opening ? null : () => unawaited(_open(context)),
                onTapDown: _opening ? null : (_) => _setPressed(true),
                onTapUp: _opening ? null : (_) => _setPressed(false),
                onTapCancel: _opening ? null : () => _setPressed(false),
                borderRadius: radius,
                splashColor: foreground.withValues(alpha: .20),
                highlightColor: foreground.withValues(alpha: .10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: _opening
                          ? SizedBox.square(
                              dimension: widget.compact ? 13 : 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: foreground,
                              ),
                            )
                          : widget.compact
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
                                      selectionLabel,
                                      key: const ValueKey(
                                        'narration-active-voice-label',
                                      ),
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
                                    const SizedBox(width: 4),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '声线',
                                          style: TextStyle(
                                            color: foreground,
                                            fontSize: 8.5,
                                            height: 1,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          selectionLabel,
                                          key: const ValueKey(
                                            'narration-active-voice-label',
                                          ),
                                          style: TextStyle(
                                            color: foreground.withValues(
                                              alpha: .72,
                                            ),
                                            fontSize: 6.8,
                                            height: 1,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                    ),
                    if (customSelected && !_opening)
                      Positioned(
                        top: 3,
                        right: 3,
                        child: Container(
                          key: const ValueKey('narration-custom-voice-dot'),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.dark
                                ? const Color(0xFFFFD66B)
                                : PhoenixTheme.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.dark
                                  ? const Color(0xFF5D1D1D)
                                  : Colors.white,
                              width: 1,
                            ),
                          ),
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
  const _NarrationVoicePickerSheet({required this.initialLanguageCode});

  final String initialLanguageCode;

  @override
  State<_NarrationVoicePickerSheet> createState() =>
      _NarrationVoicePickerSheetState();
}

class _NarrationVoicePickerSheetState
    extends State<_NarrationVoicePickerSheet> {
  final NarrationVoicePickerService _service = NarrationVoicePickerService();
  late String _languageCode;
  late Future<List<NarrationVoiceOption>> _voices;
  String? _selectedVoiceId;
  String? _previewingVoiceId;
  String? _selectionMessage;
  String? _previewError;
  double _previewProgress = 0;

  @override
  void initState() {
    super.initState();
    _languageCode = widget.initialLanguageCode;
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
    _previewProgress = 0;
    _previewError = null;
    _selectionMessage = null;
    _voices = _service.loadVoices(_languageCode);
  }

  Future<void> _changeLanguage(String value) async {
    if (value == _languageCode) return;
    await _service.stopPreview();
    if (!mounted) return;
    setState(() {
      _languageCode = value;
      _reload();
    });
  }

  Future<void> _select(String? voiceId, String label) async {
    await _service.stopPreview();
    await _service.selectVoice(_languageCode, voiceId);
    if (!mounted) return;
    setState(() {
      _selectedVoiceId = voiceId;
      _previewingVoiceId = null;
      _previewProgress = 0;
      _previewError = null;
      _selectionMessage = voiceId == null ? '已恢复自动最佳声线' : '已切换至 $label';
    });
  }

  Future<void> _stopPreview() async {
    await _service.stopPreview();
    if (!mounted) return;
    setState(() {
      _previewingVoiceId = null;
      _previewProgress = 0;
    });
  }

  Future<void> _preview(NarrationVoiceOption voice) async {
    if (_previewingVoiceId == voice.id) {
      await _stopPreview();
      return;
    }

    await _service.stopPreview();
    if (!mounted) return;
    setState(() {
      _previewingVoiceId = voice.id;
      _previewProgress = 0;
      _previewError = null;
    });

    final sample = _languageCode == 'zh-TW'
        ? '風從湖面吹來，Phoenix 陪你慢慢讀完這段旅程。'
        : '风从湖面吹来，Phoenix 陪你慢慢读完这段旅程。';
    final started = await _service.previewVoice(
      voice: voice,
      languageCode: _languageCode,
      sample: sample,
      onProgress: (progress) {
        if (!mounted || _previewingVoiceId != voice.id) return;
        setState(() => _previewProgress = progress);
      },
      onComplete: () {
        if (!mounted || _previewingVoiceId != voice.id) return;
        setState(() {
          _previewingVoiceId = null;
          _previewProgress = 0;
          _selectionMessage = '试听完成：${voice.name}';
        });
      },
      onError: () {
        if (!mounted || _previewingVoiceId != voice.id) return;
        setState(() {
          _previewingVoiceId = null;
          _previewProgress = 0;
          _previewError = '这条声线暂时无法试听，请选择其他声线。';
        });
      },
    );
    if (!mounted || started) return;
    setState(() {
      _previewingVoiceId = null;
      _previewProgress = 0;
      _previewError = '这条声线暂时无法试听，请选择其他声线。';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSummary = narrationVoiceSelectionSummary(_selectedVoiceId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '中文朗读声线',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton.filledTonal(
                tooltip: '关闭',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const Text(
            '试听后选择，Phoenix 会在这台设备上记住你的偏好。',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 9),
          AnimatedContainer(
            key: const ValueKey('narration-current-voice-summary'),
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: PhoenixTheme.red.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PhoenixTheme.red.withValues(alpha: .18),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.volume_up_rounded,
                  color: PhoenixTheme.red,
                  size: 18,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    currentSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          SegmentedButton<String>(
            key: const ValueKey('narration-voice-language-toggle'),
            segments: const [
              ButtonSegment(value: 'zh-CN', label: Text('简体普通话')),
              ButtonSegment(value: 'zh-TW', label: Text('台湾国语')),
            ],
            selected: {_languageCode},
            showSelectedIcon: false,
            onSelectionChanged: (values) =>
                unawaited(_changeLanguage(values.first)),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _selectionMessage == null
                ? const SizedBox(height: 8)
                : Container(
                    key: ValueKey(_selectionMessage),
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2D7C4B),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _selectionMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF245F3C),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_previewError != null)
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                _previewError!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(height: 6),
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
                        onTap: () => unawaited(_select(null, '自动最佳声线')),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${voice.locale} · ${voice.qualityLabel}'),
                          if (previewing) ...[
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              key: const ValueKey(
                                'narration-voice-preview-progress',
                              ),
                              value: _previewProgress <= .05
                                  ? null
                                  : _previewProgress,
                              minHeight: 3,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            key: ValueKey(
                              previewing
                                  ? 'narration-stop-preview-${voice.id}'
                                  : 'narration-preview-${voice.id}',
                            ),
                            tooltip: previewing ? '停止试听' : '试听',
                            onPressed: () => unawaited(_preview(voice)),
                            icon: Icon(
                              previewing
                                  ? Icons.stop_rounded
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
                      onTap: () => unawaited(_select(voice.id, voice.name)),
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
