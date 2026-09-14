import 'dart:typed_data';

import 'package:flutter/material.dart';

class JourneyMemoryPhotoPanel extends StatefulWidget {
  const JourneyMemoryPhotoPanel({
    required this.photoRef,
    required this.loadPhoto,
    required this.busy,
    required this.onPick,
    this.onDelete,
    this.errorText,
    super.key,
  });

  final String? photoRef;
  final Future<Uint8List?> Function(String ref) loadPhoto;
  final bool busy;
  final VoidCallback onPick;
  final VoidCallback? onDelete;
  final String? errorText;

  @override
  State<JourneyMemoryPhotoPanel> createState() =>
      _JourneyMemoryPhotoPanelState();
}

class _JourneyMemoryPhotoPanelState extends State<JourneyMemoryPhotoPanel> {
  Future<Uint8List?>? _preview;

  @override
  void initState() {
    super.initState();
    _refreshPreview();
  }

  @override
  void didUpdateWidget(covariant JourneyMemoryPhotoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoRef != widget.photoRef ||
        oldWidget.loadPhoto != widget.loadPhoto) {
      _refreshPreview();
    }
  }

  void _refreshPreview() {
    final ref = widget.photoRef;
    _preview = ref == null || ref.trim().isEmpty ? null : widget.loadPhoto(ref);
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = widget.photoRef?.trim().isNotEmpty ?? false;
    return Column(
      key: const ValueKey('journey-memory-photo-panel'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hasPhoto)
          OutlinedButton.icon(
            key: const ValueKey('journey-memory-photo-add'),
            onPressed: widget.busy ? null : widget.onPick,
            icon: widget.busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_photo_alternate_outlined),
            label: Text(widget.busy ? '正在打开照片…' : '添加照片'),
          )
        else ...[
          FutureBuilder<Uint8List?>(
            future: _preview,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(
                      key: ValueKey('journey-memory-photo-preview-loading'),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              final bytes = snapshot.data;
              if (snapshot.hasError || bytes == null || bytes.isEmpty) {
                return Container(
                  key: const ValueKey('journey-memory-photo-preview-error'),
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '无法读取照片，请重试',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  child: Image.memory(
                    bytes,
                    key: const ValueKey('journey-memory-photo-preview'),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('journey-memory-photo-replace'),
                  onPressed: widget.busy ? null : widget.onPick,
                  icon: const Icon(Icons.photo_library_outlined, size: 17),
                  label: const Text('更换照片'),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: TextButton.icon(
                  key: const ValueKey('journey-memory-photo-delete'),
                  onPressed: widget.busy ? null : widget.onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 17),
                  label: const Text('删除'),
                ),
              ),
            ],
          ),
          if (widget.busy) ...[
            const SizedBox(height: 5),
            const LinearProgressIndicator(
              key: ValueKey('journey-memory-photo-busy'),
              minHeight: 2,
            ),
          ],
        ],
        const SizedBox(height: 5),
        const Text(
          '照片仅保存在此设备',
          key: ValueKey('journey-memory-photo-local-hint'),
          style: TextStyle(color: Colors.white60, fontSize: 10),
        ),
        if (widget.errorText != null && widget.errorText!.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            key: const ValueKey('journey-memory-photo-error'),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}
