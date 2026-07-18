import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';
import 'phoenix_media_button.dart';

@visibleForTesting
int resolveNarrationDisplayOffset({
  required int estimatedOffset,
  required int controllerOffset,
  required NarrationStatus controllerStatus,
  required int totalCharacters,
}) {
  if (totalCharacters <= 0) return 0;

  // Safari/iOS can report completion while speech is still audible. In that
  // case the controller jumps to 100%, so only trust native offsets while the
  // controller still reports an active or paused session.
  final nativeOffsetIsReliable = controllerStatus == NarrationStatus.playing ||
      controllerStatus == NarrationStatus.paused;
  final candidate = nativeOffsetIsReliable
      ? math.max(estimatedOffset, controllerOffset)
      : estimatedOffset;
  return candidate.clamp(0, totalCharacters).toInt();
}

class NarrationPlayerCard extends StatefulWidget {
  const NarrationPlayerCard({
    required this.controller,
    required this.contentId,
    required this.title,
    required this.subtitle,
    required this.onPlay,
    super.key,
  });

  final NarrationController controller;
  final String contentId;
  final String title;
  final String subtitle;
  final Future<void> Function() onPlay;

  @override
  State<NarrationPlayerCard> createState() => _NarrationPlayerCardState();
}

class _NarrationPlayerCardState extends State<NarrationPlayerCard> {
  bool _sessionPlaying = false;
  bool _sessionPaused = false;
  bool _transitioning = false;
  int _displayOffset = 0;
  int _resumeOffset = 0;
  int _anchorOffset = 0;
  int? _displayItemIndex;
  DateTime? _anchorTime;
  Timer? _positionClock;

  @override
  void didUpdateWidget(covariant NarrationPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentId != widget.contentId ||
        oldWidget.controller != widget.controller) {
      _resetLocalSession();
    }
  }

  @override
  void dispose() {
    _positionClock?.cancel();
    super.dispose();
  }

  void _resetLocalSession() {
    _positionClock?.cancel();
    _positionClock = null;
    _sessionPlaying = false;
    _sessionPaused = false;
    _displayOffset = 0;
    _resumeOffset = 0;
    _anchorOffset = 0;
    _displayItemIndex = null;
    _anchorTime = null;
  }

  int _estimatedSessionOffset() {
    final total = widget.controller.totalCharacters;
    if (total <= 0) return 0;

    final anchorTime = _anchorTime ?? DateTime.now();
    final elapsedSeconds = DateTime.now()
            .difference(anchorTime)
            .inMilliseconds
            .toDouble() /
        1000;
    final charsPerSecond = 4.2 * (widget.controller.speechRate / .40);
    final estimated = _anchorOffset + (elapsedSeconds * charsPerSecond).floor();

    return resolveNarrationDisplayOffset(
      estimatedOffset: estimated,
      controllerOffset: widget.controller.currentOffset,
      controllerStatus: widget.controller.status,
      totalCharacters: total,
    );
  }

  void _startPositionClock() {
    _positionClock?.cancel();
    _positionClock = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (!mounted || !_sessionPlaying) return;

      if (widget.controller.status == NarrationStatus.error) {
        _positionClock?.cancel();
        setState(() {
          _sessionPlaying = false;
          _sessionPaused = false;
        });
        return;
      }

      final total = widget.controller.totalCharacters;
      final nextOffset = _estimatedSessionOffset();
      final nextItem = widget.controller.status == NarrationStatus.playing
          ? widget.controller.currentItemIndex
          : _displayItemIndex;

      if (total > 0 && nextOffset >= total) {
        _positionClock?.cancel();
        setState(() {
          _sessionPlaying = false;
          _sessionPaused = false;
          _displayOffset = total;
          _resumeOffset = total;
          _displayItemIndex = null;
        });
        return;
      }

      if (nextOffset != _displayOffset || nextItem != _displayItemIndex) {
        setState(() {
          _displayOffset = nextOffset;
          _displayItemIndex = nextItem ?? _displayItemIndex;
        });
      }
    });
  }

  void _beginLocalPlayback(int offset) {
    _positionClock?.cancel();
    setState(() {
      _sessionPlaying = true;
      _sessionPaused = false;
      _displayOffset = offset;
      _resumeOffset = offset;
      _anchorOffset = offset;
      _anchorTime = DateTime.now();
      _displayItemIndex = widget.controller.currentItemIndex ?? 0;
    });
    _startPositionClock();
  }

  Future<void> _handleMainPressed() async {
    if (_transitioning) return;
    _transitioning = true;
    try {
      if (_sessionPlaying) {
        await _pauseSession();
      } else if (_sessionPaused) {
        await _resumeSession();
      } else if (widget.controller.contentId == widget.contentId &&
          widget.controller.status == NarrationStatus.playing) {
        _beginLocalPlayback(widget.controller.currentOffset);
        await _pauseSession();
      } else if (widget.controller.contentId == widget.contentId &&
          widget.controller.status == NarrationStatus.paused) {
        _resumeOffset = widget.controller.currentOffset;
        await _resumeSession();
      } else {
        await _startSession();
      }
    } finally {
      _transitioning = false;
    }
  }

  Future<void> _startSession() async {
    _beginLocalPlayback(0);
    await widget.onPlay();
    if (!mounted) return;

    if (widget.controller.status == NarrationStatus.error) {
      _positionClock?.cancel();
      setState(() {
        _sessionPlaying = false;
        _sessionPaused = false;
      });
      return;
    }

    setState(() {
      _anchorOffset = 0;
      _anchorTime = DateTime.now();
      _displayOffset = 0;
      _resumeOffset = 0;
      _displayItemIndex = widget.controller.currentItemIndex ?? 0;
    });
    _startPositionClock();
  }

  Future<void> _pauseSession() async {
    final offset = _estimatedSessionOffset();
    _positionClock?.cancel();
    if (mounted) {
      setState(() {
        _sessionPlaying = false;
        _sessionPaused = true;
        _displayOffset = offset;
        _resumeOffset = offset;
        _anchorOffset = offset;
        _anchorTime = null;
      });
    }

    // stop(resetPosition: false) is deliberate: unlike pause(), it still
    // releases audio when Safari has already changed the controller to idle.
    await widget.controller.stop(resetPosition: false);
  }

  Future<void> _resumeSession() async {
    final total = widget.controller.totalCharacters;
    final safeOffset = total <= 0
        ? 0
        : _resumeOffset.clamp(0, math.max(0, total - 1)).toInt();
    _beginLocalPlayback(safeOffset);
    await widget.controller.resumeFromOffset(safeOffset);
    if (!mounted) return;

    if (widget.controller.status == NarrationStatus.error) {
      _positionClock?.cancel();
      setState(() {
        _sessionPlaying = false;
        _sessionPaused = true;
      });
    }
  }

  Future<void> _stopSession() async {
    _positionClock?.cancel();
    if (mounted) {
      setState(_resetLocalSession);
    } else {
      _resetLocalSession();
    }
    await widget.controller.stop();
  }

  Future<void> _restartSession() async {
    _beginLocalPlayback(0);
    if (widget.controller.contentId == widget.contentId &&
        widget.controller.hasContent) {
      await widget.controller.restart();
    } else {
      await widget.onPlay();
    }
  }

  Future<void> _setSpeechRate(double rate) async {
    if (_sessionPlaying) {
      final offset = _estimatedSessionOffset();
      setState(() {
        _displayOffset = offset;
        _resumeOffset = offset;
        _anchorOffset = offset;
        _anchorTime = DateTime.now();
      });
      await widget.controller.setSpeechRate(rate);
      if (widget.controller.status != NarrationStatus.playing) {
        await widget.controller.resumeFromOffset(offset);
      }
      return;
    }
    await widget.controller.setSpeechRate(rate);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controllerIsCurrent =
            widget.controller.contentId == widget.contentId;
        final controllerStatus = controllerIsCurrent
            ? widget.controller.status
            : NarrationStatus.idle;
        final hasError = controllerStatus == NarrationStatus.error;
        final isPlaying = _sessionPlaying ||
            (!_sessionPaused && controllerStatus == NarrationStatus.playing);
        final isPaused = _sessionPaused ||
            (!isPlaying && controllerStatus == NarrationStatus.paused);
        final status = hasError
            ? NarrationStatus.error
            : isPlaying
                ? NarrationStatus.playing
                : isPaused
                    ? NarrationStatus.paused
                    : NarrationStatus.idle;
        final total = widget.controller.totalCharacters;
        final progress = (_sessionPlaying || _sessionPaused) && total > 0
            ? (_displayOffset / total).clamp(0.0, 1.0).toDouble()
            : controllerIsCurrent
                ? widget.controller.progress
                : 0.0;
        final currentItem = (_sessionPlaying || _sessionPaused)
            ? _displayItemIndex
            : controllerIsCurrent
                ? widget.controller.currentItemIndex
                : null;
        final itemCount = controllerIsCurrent ? widget.controller.itemCount : 0;
        final canControl = _sessionPlaying ||
            _sessionPaused ||
            (controllerIsCurrent && widget.controller.hasContent);
        final percent = (progress * 100).round();
        final activeSubtitle = hasError
            ? widget.controller.errorMessage ?? '朗读暂时不可用'
            : isPlaying
                ? widget.controller.currentItemLabel != null
                    ? '${widget.controller.currentItemLabel} · $percent%'
                    : '正在朗读 · $percent%'
                : isPaused
                    ? '已暂停 · $percent%'
                    : widget.subtitle;

        return Semantics(
          container: true,
          label:
              '${widget.title}，${widget.subtitle}，${_statusText(status)}，进度 $percent%',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .98),
                  const Color(0xFF651418),
                ],
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 6),
                  color: Color(0x18000000),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.headphones_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 1),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Text(
                              activeSubtitle,
                              key: ValueKey(activeSubtitle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),
                    PhoenixMediaButton(
                      key: const ValueKey('narration-main-control'),
                      isPlaying: isPlaying,
                      tooltip: _mainButtonTooltip(status),
                      size: 50,
                      onPressed: () => unawaited(_handleMainPressed()),
                    ),
                    const SizedBox(width: 2),
                    _MiniIconButton(
                      key: const ValueKey('narration-stop-control'),
                      tooltip: '停止朗读',
                      icon: Icons.stop_rounded,
                      onPressed: canControl && status != NarrationStatus.idle
                          ? () => unawaited(_stopSession())
                          : null,
                    ),
                    PopupMenuButton<double>(
                      key: const ValueKey('narration-speed-control'),
                      tooltip: '调整朗读语速',
                      padding: EdgeInsets.zero,
                      onSelected: (rate) {
                        unawaited(_setSpeechRate(rate));
                      },
                      itemBuilder: (context) =>
                          NarrationController.speedOptions
                              .map(
                                (option) => PopupMenuItem<double>(
                                  value: option.rate,
                                  child: Text('${option.label} 语速'),
                                ),
                              )
                              .toList(growable: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          widget.controller.speedLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                              backgroundColor: Colors.white24,
                              color: const Color(0xFFFFD879),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                currentItem == null || itemCount == 0
                                    ? '尚未开始'
                                    : '第 ${currentItem + 1} / $itemCount 段',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$percent%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    _MiniIconButton(
                      tooltip: '重新播放',
                      icon: Icons.replay_rounded,
                      onPressed: canControl
                          ? () => unawaited(_restartSession())
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _mainButtonTooltip(NarrationStatus status) {
    return switch (status) {
      NarrationStatus.playing => '暂停朗读',
      NarrationStatus.paused => '继续朗读',
      NarrationStatus.idle => '开始朗读',
      NarrationStatus.error => '重新尝试朗读',
    };
  }

  String _statusText(NarrationStatus status) {
    return switch (status) {
      NarrationStatus.playing => '正在朗读',
      NarrationStatus.paused => '朗读已暂停',
      NarrationStatus.idle => '点击播放开始朗读',
      NarrationStatus.error => '朗读暂时不可用',
    };
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      icon: Icon(icon, size: 17),
      color: Colors.white,
      disabledColor: Colors.white30,
    );
  }
}
