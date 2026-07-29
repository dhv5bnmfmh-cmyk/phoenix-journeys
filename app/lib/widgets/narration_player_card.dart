import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../services/narration_seek.dart';
import '../theme/phoenix_theme.dart';
import 'narration_seek_rail.dart';
import 'narration_speed_stepper.dart';
import 'phoenix_media_button.dart';

@visibleForTesting
int resolveNarrationDisplayOffset({
  required int estimatedOffset,
  required int controllerOffset,
  required NarrationStatus controllerStatus,
  required int totalCharacters,
}) {
  if (totalCharacters <= 0) return 0;

  final nativeOffsetIsReliable = controllerStatus == NarrationStatus.playing ||
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
  final estimated = estimatedOffset.clamp(0, maxOffset).toInt();
  final safeEstimated = math.max(0, estimated - 1);
  if (nativeProgressIsFresh) {
    final native = nativeOffset.clamp(0, maxOffset).toInt();
    return math.max(native, safeEstimated);
  }

  return safeEstimated;
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

@visibleForTesting
bool shouldClearNarrationLocalSession({
  required NarrationStatus controllerStatus,
  required bool finished,
}) {
  return finished || controllerStatus == NarrationStatus.error;
}

@visibleForTesting
String compactNarrationProgressLabel({
  required int? currentItemIndex,
  required int itemCount,
  required int currentOffset,
  required int totalCharacters,
  required bool finished,
}) {
  if (totalCharacters <= 0) return '准备朗读';
  if (finished) return '朗读完成 · 100%';

  final safeOffset = currentOffset.clamp(0, totalCharacters).toInt();
  final percent = ((safeOffset / totalCharacters) * 100).round().clamp(0, 99);
  final remaining = math.max(0, totalCharacters - safeOffset);
  if (currentItemIndex == null || itemCount <= 0) {
    return '总计 $totalCharacters 字';
  }
  final item = (currentItemIndex + 1).clamp(1, itemCount).toInt();
  return '第 $item / $itemCount 段 · $percent% · 剩余 $remaining 字';
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
  double? _seekPreviewProgress;
  bool _seekResumePlayback = false;
  int? _seekCommandId;
  Future<void>? _seekPauseFuture;

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
    _seekPreviewProgress = null;
    _seekResumePlayback = false;
    _seekCommandId = null;
    _seekPauseFuture = null;
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
    if (!_controllerIsCurrent || _seekPreviewProgress != null) return;

    // The controller is the single source of truth. Temporary word and
    // support speech can pause the same engine outside this card.
    if (status == NarrationStatus.playing) {
      _sessionPlaying = true;
      _sessionPaused = false;
    } else if (status == NarrationStatus.paused) {
      _sessionPlaying = false;
      _sessionPaused = true;
    } else if (shouldClearNarrationLocalSession(
      controllerStatus: status,
      finished: _controllerFinished,
    )) {
      _sessionPlaying = false;
      _sessionPaused = false;
    }

    if (status != NarrationStatus.playing && status != NarrationStatus.paused) {
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
    final total = widget.controller.totalCharacters;
    if (total <= 0) return 0;
    return widget.controller.currentOffset
        .clamp(0, math.max(0, total - 1))
        .toInt();
  }

  void _handleMainPressed() {
    final commandId = ++_commandVersion;
    final controllerPlaying = _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.playing;
    final controllerPaused = _controllerIsCurrent &&
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
    final safeOffset =
        total <= 0 ? 0 : _resumeOffset.clamp(0, math.max(0, total - 1)).toInt();
    if (!mounted || commandId != _commandVersion) return;
    _beginLocalPlayback(safeOffset);
    await widget.controller.resumeFromOffset(safeOffset);
    if (!mounted || commandId != _commandVersion || !_sessionPlaying) return;
    final controllerOffset =
        _controllerIsCurrent ? widget.controller.currentOffset : safeOffset;
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
    final controllerPlaying = _controllerIsCurrent &&
        widget.controller.status == NarrationStatus.playing;
    final controllerPaused = _controllerIsCurrent &&
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
      final controllerOffset =
          _controllerIsCurrent ? widget.controller.currentOffset : offset;
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

  void _handleSeekStart(double progress) {
    final total = widget.controller.totalCharacters;
    if (!_controllerIsCurrent || total <= 0) return;

    final commandId = ++_commandVersion;
    final pauseOffset = _captureContinuationOffset();
    final targetOffset = narrationSeekOffset(
      progress: progress,
      totalCharacters: total,
    );
    _seekResumePlayback = _sessionPlaying ||
        widget.controller.status == NarrationStatus.playing;
    _seekCommandId = commandId;
    _seekPauseFuture = widget.controller.pauseAtOffset(pauseOffset);

    setState(() {
      _seekPreviewProgress = progress.clamp(0.0, 1.0).toDouble();
      _sessionPlaying = false;
      _sessionPaused = true;
      _resumeOffset = targetOffset;
      _lastObservedOffset = targetOffset;
    });
  }

  void _handleSeekUpdate(double progress) {
    final total = widget.controller.totalCharacters;
    if (_seekCommandId == null || total <= 0) return;
    final targetOffset = narrationSeekOffset(
      progress: progress,
      totalCharacters: total,
    );
    setState(() {
      _seekPreviewProgress = progress.clamp(0.0, 1.0).toDouble();
      _resumeOffset = targetOffset;
      _lastObservedOffset = targetOffset;
    });
  }

  void _handleSeekEnd(double progress) {
    final total = widget.controller.totalCharacters;
    if (total <= 0) return;
    final commandId = _seekCommandId ?? ++_commandVersion;
    final targetOffset = narrationSeekOffset(
      progress: progress,
      totalCharacters: total,
    );
    final resumePlayback = _seekResumePlayback;

    setState(() {
      _seekPreviewProgress = null;
      _seekCommandId = null;
      _resumeOffset = targetOffset;
      _lastObservedOffset = targetOffset;
      _sessionPlaying = resumePlayback;
      _sessionPaused = !resumePlayback;
    });
    unawaited(_commitSeek(commandId, targetOffset, resumePlayback));
  }

  Future<void> _commitSeek(
    int commandId,
    int targetOffset,
    bool resumePlayback,
  ) async {
    await _seekPauseFuture;
    if (!mounted || commandId != _commandVersion) return;
    await widget.controller.seekToOffset(
      targetOffset,
      resumePlayback: resumePlayback,
    );
    if (!mounted || commandId != _commandVersion) return;
    setState(() {
      _seekPauseFuture = null;
      _resumeOffset = targetOffset;
      _lastObservedOffset = targetOffset;
      _sessionPlaying = resumePlayback;
      _sessionPaused = !resumePlayback;
    });
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

        final hasError = !_sessionPlaying &&
            !_sessionPaused &&
            controllerStatus == NarrationStatus.error;
        final finished = controllerIsCurrent &&
            controllerStatus == NarrationStatus.idle &&
            widget.controller.totalCharacters > 0 &&
            widget.controller.currentOffset >=
                widget.controller.totalCharacters;
        final isPlaying = !finished &&
            (_sessionPlaying ||
                (!_sessionPaused &&
                    controllerStatus == NarrationStatus.playing));
        final isPaused = !finished &&
            (_sessionPaused ||
                (!isPlaying && controllerStatus == NarrationStatus.paused));
        final status = hasError
            ? NarrationStatus.error
            : isPlaying
                ? NarrationStatus.playing
                : isPaused
                    ? NarrationStatus.paused
                    : NarrationStatus.idle;

        final total =
            controllerIsCurrent ? widget.controller.totalCharacters : 0;
        final controllerVisibleOffset = controllerIsCurrent
            ? isPaused
                ? math.max(widget.controller.currentOffset, _resumeOffset)
                : widget.controller.currentOffset
            : 0;
        final controllerProgress = total <= 0
            ? 0.0
            : (controllerVisibleOffset / total)
                .clamp(0.0, 1.0)
                .toDouble();
        final displayProgress =
            (_seekPreviewProgress ?? controllerProgress)
                .clamp(0.0, 1.0)
                .toDouble();
        final displayOffset = _seekPreviewProgress == null
            ? controllerVisibleOffset
            : narrationSeekOffset(
                progress: displayProgress,
                totalCharacters: total,
              );
        final currentItem =
            controllerIsCurrent ? widget.controller.currentItemIndex : null;
        final itemCount = controllerIsCurrent ? widget.controller.itemCount : 0;
        final canControl = _sessionPlaying ||
            _sessionPaused ||
            (controllerIsCurrent && widget.controller.hasContent);
        final canSeek = canControl && total > 0 && !hasError && !finished;
        final roundedPercent = (displayProgress * 100).round();
        final percent = isPlaying && _seekPreviewProgress == null
            ? roundedPercent.clamp(1, 99)
            : roundedPercent;
        final seeking = _seekPreviewProgress != null;
        final activeSubtitle = hasError
            ? widget.controller.errorMessage ?? '朗读暂时不可用'
            : seeking
                ? '定位到 $percent% · 松开跳转'
                : isPlaying
                    ? widget.controller.currentItemLabel ?? '正在朗读'
                    : isPaused
                        ? '已暂停 · $percent%'
                        : widget.subtitle;
        final compact = widget.compact;
        final compactProgress = seeking
            ? '定位 $percent% · 第 $displayOffset 字 · 松开跳转'
            : compactNarrationProgressLabel(
                currentItemIndex: currentItem,
                itemCount: itemCount,
                currentOffset: displayOffset,
                totalCharacters: total,
                finished: finished,
              );

        void startSeek(double value) => _handleSeekStart(value);
        void updateSeek(double value) => _handleSeekUpdate(value);
        void endSeek(double value) => _handleSeekEnd(value);

        return Semantics(
          container: true,
          label:
              '${widget.title}，${widget.subtitle}，${_statusText(status)}，进度 $percent%',
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              compact ? 6 : 10,
              compact ? 3 : 8,
              compact ? 5 : 8,
              compact ? 3 : 7,
            ),
            decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
              borderRadius: BorderRadius.circular(compact ? 11 : 17),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: compact ? 20 : 30,
                      height: compact ? 20 : 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.headphones_rounded,
                        color: Colors.white,
                        size: compact ? 12 : 17,
                      ),
                    ),
                    SizedBox(width: compact ? 6 : 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PhoenixTheme.journeyTitleStyle.copyWith(
                              fontSize: compact ? 11 : 12,
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
                              style: PhoenixTheme.journeyMetaStyle.copyWith(
                                fontSize: compact ? 8.2 : 9,
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
                      isError: hasError,
                      tooltip: _mainButtonTooltip(status),
                      size: compact ? 32 : 44,
                      onPressed: _handleMainPressed,
                    ),
                    if (compact) ...[
                      const SizedBox(width: 2),
                      _MiniIconButton(
                        tooltip: '重新播放',
                        icon: Icons.replay_rounded,
                        compact: true,
                        onPressed: canControl
                            ? () => unawaited(_restartSession())
                            : null,
                      ),
                    ],
                    SizedBox(width: compact ? 4 : 8),
                    NarrationSpeedStepper(
                      key: const ValueKey('narration-speed-control'),
                      controller: widget.controller,
                      onRateChange: _setSpeechRate,
                      dark: true,
                      compact: compact,
                    ),
                  ],
                ),
                if (compact) ...[
                  const SizedBox(height: 1),
                  NarrationSeekRail(
                    key: const ValueKey('narration-compact-progress'),
                    value: displayProgress,
                    minHeight: 4,
                    enabled: canSeek,
                    onSeekStart: canSeek ? startSeek : null,
                    onSeekUpdate: canSeek ? updateSeek : null,
                    onSeekEnd: canSeek ? endSeek : null,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: Text(
                        compactProgress,
                        key: ValueKey('narration-compact-label-$compactProgress'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8.4,
                          fontWeight: FontWeight.w700,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NarrationSeekRail(
                              key: const ValueKey('narration-full-progress'),
                              value: displayProgress,
                              minHeight: 7,
                              enabled: canSeek,
                              onSeekStart: canSeek ? startSeek : null,
                              onSeekUpdate: canSeek ? updateSeek : null,
                              onSeekEnd: canSeek ? endSeek : null,
                            ),
                            Row(
                              children: [
                                Text(
                                  seeking
                                      ? '正在定位第 $displayOffset 字'
                                      : currentItem == null || itemCount == 0
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
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
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
    this.compact = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.all(compact ? 2 : 4),
      constraints: BoxConstraints.tightFor(
        width: compact ? 26 : 30,
        height: compact ? 26 : 30,
      ),
      icon: Icon(icon, size: compact ? 15 : 17),
      color: Colors.white,
      disabledColor: Colors.white30,
    );
  }
}
