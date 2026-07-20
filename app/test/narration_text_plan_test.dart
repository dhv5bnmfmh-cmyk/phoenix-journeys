import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';

void main() {
  test('builds narration text and maps offsets to the correct item', () {
    final plan = NarrationTextPlan.fromItems(const [
      NarrationItem(id: 'one', text: '第一段。', label: '第一段'),
      NarrationItem(id: 'two', text: '第二段。', label: '第二段'),
      NarrationItem(id: 'three', text: '第三段。', label: '第三段'),
    ]);

    expect(plan.text, '第一段。\n第二段。\n第三段。');
    expect(plan.indexForOffset(0), 0);
    expect(plan.indexForOffset(plan.itemStarts[1]), 1);
    expect(plan.indexForOffset(plan.itemStarts[2] + 1), 2);
    expect(plan.indexForOffset(plan.text.length), 2);
  });

  test('ignores empty narration items', () {
    final plan = NarrationTextPlan.fromItems(const [
      NarrationItem(id: 'empty', text: '   ', label: '空白'),
      NarrationItem(id: 'content', text: '有效内容', label: '内容'),
    ]);

    expect(plan.items, hasLength(1));
    expect(plan.text, '有效内容');
    expect(plan.indexForOffset(0), 0);
  });

  test('offers unified player speed presets from 1x to 3x', () {
    const options = NarrationController.speedOptions;

    expect(options.map((option) => option.label), [
      '1.0×',
      '1.5×',
      '2.0×',
      '2.5×',
      '3.0×',
    ]);
    expect(options.first.rate, 1.0);
    expect(options.last.rate, 3.0);
  });
}
