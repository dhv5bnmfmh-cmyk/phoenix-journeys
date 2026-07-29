import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/widgets/narration_follow_status.dart';

void main() {
  test('follow status reports the current paragraph and spoken word', () {
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.playing,
        hasContent: true,
        currentItemLabel: '故事第 2 段',
        currentWord: '月光',
        currentOffset: 18,
        totalCharacters: 80,
      ),
      '故事第 2 段 · 月光',
    );
  });

  test('manual reading has a clear paused-follow label', () {
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.playing,
        hasContent: true,
        currentItemLabel: '今日发现 1',
        currentWord: '微光',
        currentOffset: 22,
        totalCharacters: 70,
        manualFollowPaused: true,
      ),
      '今日发现 1 · 已暂停跟随',
    );
  });

  test('follow status preserves a clear paused location', () {
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.paused,
        hasContent: true,
        currentItemLabel: '今日发现 1',
        currentWord: null,
        currentOffset: 22,
        totalCharacters: 70,
      ),
      '今日发现 1 · 已暂停',
    );
  });

  test('sentence guide resolves the active Chinese sentence', () {
    const text = '风从湖面吹来。月光落在古桥上！旅人停下脚步？';
    expect(
      narrationSentenceAtOffset(text: text, offset: 8),
      '月光落在古桥上！',
    );
    expect(
      narrationSentenceAtOffset(text: text, offset: 0),
      '风从湖面吹来。',
    );
    expect(
      narrationSentenceAtOffset(text: text, offset: text.length - 1),
      '旅人停下脚步？',
    );
  });

  test('sentence guide keeps closing quotation marks with the sentence', () {
    const text = '他说：“河灯亮了。”然后继续前行。';
    expect(
      narrationSentenceAtOffset(text: text, offset: 6),
      '他说：“河灯亮了。”',
    );
  });

  test('sentence guide handles empty content safely', () {
    expect(narrationSentenceAtOffset(text: '   ', offset: 0), isEmpty);
  });

  test('follow status distinguishes ready, complete, and error states', () {
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.idle,
        hasContent: false,
        currentItemLabel: null,
        currentWord: null,
        currentOffset: 0,
        totalCharacters: 0,
      ),
      '准备朗读',
    );
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.idle,
        hasContent: true,
        currentItemLabel: null,
        currentWord: null,
        currentOffset: 48,
        totalCharacters: 48,
      ),
      '本次朗读完成',
    );
    expect(
      narrationFollowStatusLabel(
        status: NarrationStatus.error,
        hasContent: true,
        currentItemLabel: '故事第 1 段',
        currentWord: null,
        currentOffset: 4,
        totalCharacters: 48,
      ),
      '朗读暂不可用',
    );
  });
}
