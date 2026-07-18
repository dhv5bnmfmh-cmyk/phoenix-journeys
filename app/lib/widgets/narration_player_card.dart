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

  final nativeOffsetIsReliable =
      controllerStatus == NarrationStatus.playing ||
      controllerStatus == NarrationStatus.paused;
  final candidate = nativeOffsetIsReliable
      ? math.max(estimatedOffset, controllerOffset)
      : estimatedOffset;
  return candidate.clamp(0, totalCharacters).toInt();
}

@visibleForTesting
int resolveNarrationPauseOffset({
  required int nativeOffset,
  required bool nativeProgressIsFresh,
  required int estimatedOffset,
  required int totalCharacters,
}) {
  if (totalCharacters <= 0) return 0;
  final maxOffset = math.max(0, totalCharacters - 1);
  if (nativeProgressIsFresh) {
    return nativeOffset.clamp(0, maxOffset).toInt();
  }

  final estimated = estimatedOffset.clamp(0, maxOffset).toInt();
  // When Safari has no exact word callback, resume slightly before the
  // estimate so Phoenix never skips text after pause or a speed change.
  return math.max(0, estimated - 2);
}

@visibleForTesting
int resolveNarrationContinuationOffset({
  required int nativeOffset,
  required bool nativeProgressIsFresh,
  required int controllerOffset,
  required int lastObservedOffset,
  required int totalCharacters,
}) {
  return resolveNarrationPauseOffset(
    nativeOffset: nativeOffset,
    nativeProgressIsFresh: nativeProgressIsFresh,
    estimatedOffset: math.max(controllerOffset, lastObservedOffset),
    totalCharacters: totalCharacters,
  );
}

class NarrationPlayerCard extends StatefulWidget {
  const NarrationPlayerCard({
    required this.controller,
    required this.contentId,
    required this.title,
    required this.subtitle,
    required this.onPlay,
    this.compact = false,
    super.key,
  });

  final NarrationController controller;
  final String contentId;
  final String title;
  final String subtitle;
  final Future<void> Function() onPlay;
  final bool compact;

  @override
  State<NarrationPlayerCard> createState() => _NarrationPlayerCardState();
}

class _NarrationPlayerCardState extends State<NarrationPlayerCard> {
  bool _sessionPlaying = false;
  bool _sessionPaused = false;
  int _commandVersion = 0;
  int _resumeOffset = 0;
  int _lastObservedOffset = 0;

  bool get _controllerIsCurrent =>
      widget.controller.contentId == widget.contentId;

  bool get _controllerFinished =>
      _controllerIsCurrent &&
      widget.controller.status == NarrationStatus.idle &&
      widget.controller.totalCharacters > 0 &&
      widget.controller.currentOffset >= widget.controller.totalCharacters;

  @override
  void didUpdateWidget(covariant NarrationPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentId != widget.contentId ||
        oldWidget.controller != widget.controller) {
      _commandVersion += 1;
      _resetLocalSession();
    }
  }

  @override
  void dispose() {
    _commandVersion += 1;
    super.dispose();
  }

  void _resetLocalSession() {
    _sessionPlaying = false;
    _sessionPaused = false;
    _resumeOffset = 0;
    _lastObservedOffset = 0;
  }

  void _beginLocalPlayback(int offset) {
    setState(() {
      _sessionPlaying = true;
      _sessionPaused = false;
      _resumeOffset = offset;
      _lastObservedOffset = offset;
    });
  }

  void _observeControllerOffset(NarrationStatus status) {
    if (!_controllerIsCurrent ||
        (status != NarrationStatus.playing &&
            status != NarrationStatus.paused)) {
      return;
    }

    final total = widget.controller.totalCharacters;
    if (total <= 0) return;
    final observed = widget.controller.currentOffset
        .clamp(0, math.max(0, total - 1))
        .toInt();
    if (observed > _lastObservedOffset) {
      _lastObservedOffset = observed;
    }
  }

  int _captureContinuationOffset() {
    if (!_controllerIsCurrent) return _resumeOffset;
    return resolveNarrationContinuationOffset(
      nativeOffset: widget.controller.lastNativeOffset,
      nativeProgressIsFresh: widget.controller.hasFreshNativeProgress,
      controllerOffset: widget.controller.currentOffset,
      lastObservedOffset: _lastObservedOffset,
      totalCharacters: widget.controller.totalCharacters,
    );
  }

  void _handleMainPressed() {
    final commandId = ++_commandVersion;
    final controllerPlaying =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.playing;
    final controllerPaused =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.paused;

    if (_controllerFinished) {
      _sessionPlaying = false;
      _sessionPaused = false;
      _resumeOffset = 0;
      _lastObservedOffset = 0;
      unawaited(_startSession(commandId));
      return;
    }
    if (_sessionPlaying || controllerPlaying) {
      unawaited(_pauseSession(commandId));
      return;
    }
    if (_sessionPaused || controllerPaused) {
      if (!_sessionPaused) {
        _resumeOffset = _captureContinuationOffset();
        _lastObservedOffset = _resumeOffset;
      }
      unawaited(_resumeSession(commandId));
      return;
    }
    unawaited(_startSession(commandId));
  }

  Future<void> _startSession(int commandId) async {
    _lastObservedOffset = 0;
    _beginLocalPlayback(0);
    await widget.onPlay();
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    final offset = _controllerIsCurrent ? widget.controller.currentOffset : 0;
    setState(() {
      _resumeOffset = offset;
      _lastObservedOffset = offset;
    });
  }

  Future<void> _pauseSession(int commandId) async {
    final offset = _captureContinuationOffset();
    if (!mounted || commandId != _commandVersion) return;
    setState(() {
      _sessionPlaying = false;
      _sessionPaused = true;
      _resumeOffset = offset;
      _lastObservedOffset = offset;
    });
    await widget.controller.pauseAtOffset(offset);
  }

  Future<void> _resumeSession(int commandId) async {
    final total = widget.controller.totalCharacters;
    final safeOffset = total <= 0
        ? 0
        : _resumeOffset.clamp(0, math.max(0, total - 1)).toInt();
    if (!mounted || commandId != _commandVersion) return;
    _beginLocalPlayback(safeOffset);
    await widget.controller.resumeFromOffset(safeOffset);
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    final controllerOffset = _controllerIsCurrent
        ? widget.controller.currentOffset
        : safeOffset;
    final continuedOffset = math.max(safeOffset, controllerOffset);
    setState(() {
      _resumeOffset = continuedOffset;
      _lastObservedOffset = continuedOffset;
    });
  }

  Future<void> _restartSession() async {
    final commandId = ++_commandVersion;
    _lastObservedOffset = 0;
    _beginLocalPlayback(0);
    if (_controllerIsCurrent && widget.controller.hasContent) {
      await widget.controller.restart();
    } else {
      await widget.onPlay();
    }
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    final offset = widget.controller.currentOffset;
    setState(() {
      _resumeOffset = offset;
      _lastObservedOffset = offset;
    });
  }

  Future<void> _setSpeechRate(double rate) async {
    if ((widget.controller.speechRate - rate).abs() < .001) return;

    final commandId = ++_commandVersion;
    final controllerPlaying =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.playing;
    final controllerPaused =
        _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.paused;
    final wasPlaying = _sessionPlaying || controllerPlaying;
    final wasPaused = _sessionPaused || controllerPaused;
    final offset = _captureContinuationOffset();

    if (mounted) {
      setState(() {
        _resumeOffset = offset;
        _lastObservedOffset = offset;
        if (wasPlaying) {
          _sessionPlaying = false;
          _sessionPaused = true;
        }
      });
    }

    if (wasPlaying) {
      await widget.controller.pauseAtOffset(offset);
      if (!mounted || commandId != _commandVersion) return;
    }

    await widget.controller.setSpeechRate(rate);
    if (!mounted || commandId != _commandVersion) return;

    if (wasPlaying) {
      _beginLocalPlayback(offset);
      await widget.controller.resumeFromOffset(offset);
      if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
      final controllerOffset = _controllerIsCurrent
          ? widget.controller.currentOffset
          : offset;
      final continuedOffset = math.max(offset, controllerOffset);
      setState(() {
        _resumeOffset = continuedOffset;
        _lastObservedOffset = math.max(
          _lastObservedOffset,
          continuedOffset,
        );
      });
    } else if (wasPaused) {
      setState(() {
        _sessionPlaying = false;
        _sessionPaused = true;
        _resumeOffset = offset;
      });
    }
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
        _observeControllerOffset(controllerStatus);

        final hasError =
            !_sessionPlaying &&
            !_sessionPaused &&
            controllerStatus == NarrationStatus.error;
        final finished =
            controllerIsCurrent &&
            controllerStatus == NarrationStatus.idle &&
            widget.controller.totalCharacters > 0 &&
            widget.controller.currentOffset >=
                widget.controller.totalCharacters;
        final isPlaying =
            !finished &&
            (_sessionPlaying ||
                (!_sessionPaused &&
                    controllerStatus == NarrationStatus.playing));
        final isPaused =
            !finished &&
            (_sessionPaused ||
                (!isPlaying && controllerStatus == NarrationStatus.paused));
        final status = hasError
            ? NarrationStatus.error
            : isPlaying
            ? NarrationStatus.playing
            : isPaused
            ? NarrationStatus.paused
            : NarrationStatus.idle;

        final total = controllerIsCurrent
            ? widget.controller.totalCharacters
            : 0;
        final retainedOffset = controllerIsCurrent
            ? math.max(
                widget.controller.currentOffset,
                math.max(_resumeOffset, _lastObservedOffset),
              )
            : 0;
        final visibleOffset = isPlaying || isPaused
            ? retainedOffset
            : controllerIsCurrent
            ? widget.controller.currentOffset
            : 0;
        final progress = total <= 0
            ? 0.0
            : (visibleOffset / total).clamp(0.0, 1.0).toDouble();
        final currentItem = controllerIsCurrent
            ? widget.controller.currentItemIndex
            : null;
        final itemCount = controllerIsCurrent ? widget.controller.itemCount : 0;
        final canControl =
            _sessionPlaying ||
            _sessionPaused ||
            (controllerIsCurrent && widget.controller.hasContent);
        final roundedPercent = (progress * 100).round();
        final percent = isPlaying
            ? roundedPercent.clamp(1, 99)
            : roundedPercent;
        final activeSubtitle = hasError
            ? widget.controller.errorMessage ?? '朗读暂时不可用'
            : isPlaying
            ? widget.controller.currentItemLabel != null
                  ? '${widget.controller.currentItemLabel} · $percent%'
                  : '正在朗读 · $percent%'
            : isPaused
            ? '已暂停 · $percent%'
            : widget.subtitle;
        final compact = widget.compact;

        return Semantics(
          container: true,
          label:
              '${widget.title}，${widget.subtitle}，${_statusText(status)}，进度 $percent%',
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              compact ? 9 : 12,
              compact ? 6 : 10,
              compact ? 8 : 10,
              compact ? 6 : 9,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PhoenixTheme.red.withValues(alpha: .98),
                  const Color(0xFF651418),
                ],
              ),
              borderRadius: BorderRadius.circular(compact ? 13 : 17),
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
                      width: compact ? 28 : 34,
                      height: compact ? 28 : 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.headphones_rounded,
                        color: Colors.white,
                        size: compact ? 16 : 19,
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
                      size: compact ? 42 : 50,
                      onPressed: _handleMainPressed,
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<double>(
                      key: const ValueKey('narration-speed-control'),
                      tooltip: '调整朗读语速',
                      padding: EdgeInsets.zero,
                      onSelected: (rate) {
                        unawaited(_setSpeechRate(rate));
                      },
                      itemBuilder: (context) => NarrationController.speedOptions
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
                SizedBox(height: compact ? 5 : 9),
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
                              minHeight: compact ? 5 : 7,
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
