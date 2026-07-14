import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/word_detail_sheet.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int step = 0;
  final wonderController = TextEditingController();
  final expressController = TextEditingController();
  final memoryController = TextEditingController();
  String aiReply = '';

  @override
  void dispose() {
    wonderController.dispose();
    expressController.dispose();
    memoryController.dispose();
    super.dispose();
  }

  void next() => setState(() => step = (step + 1).clamp(0, 6));

  @override
  Widget build(BuildContext context) {
    final pages = [
      _story(context),
      _words(context),
      _discover(context),
      _wonder(context),
      _express(context),
      _memory(context),
      _complete(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('北京 · 紫禁城'),
        actions: [
          Consumer<AppState>(
            builder: (_, state, __) => TextButton(
              onPressed: state.toggleScript,
              child: Text(
                state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
              ),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: pages[step],
      ),
    );
  }

  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    VoidCallback? onNext,
  }) {
    return ListView(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 34),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        child,
        const SizedBox(height: 28),
        FilledButton(
          onPressed: onNext ?? next,
          child: Text(buttonText),
        ),
      ],
    );
  }

  Widget _story(BuildContext context) {
    return _page(
      title: '故事',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '点击带下划线的词语，可查看拼音、解释和辅助翻译。',
            style: TextStyle(color: PhoenixTheme.translation),
          ),
          const SizedBox(height: 16),
          ...storyParagraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(paragraph, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words
                .take(3)
                .map(
                  (entry) => ActionChip(
                    label: Text('${entry.word} · ${entry.pinyin}'),
                    onPressed: () => showWordDetail(context, entry),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _words(BuildContext context) {
    return _page(
      title: '生词',
      child: Column(
        children: words
            .map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => showWordDetail(context, entry),
                  leading: Text(entry.symbol, style: const TextStyle(fontSize: 32)),
                  title: Text(entry.word),
                  subtitle: Text(entry.pinyin),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _discover(BuildContext context) {
    return _page(
      title: '发现',
      child: Column(
        children: discoveries
            .map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(item),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _wonder(BuildContext context) {
    return _page(
      title: '思考',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(wonderQuestion),
          const SizedBox(height: 14),
          TextField(
            controller: wonderController,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '写下你的想法……',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              final answer = wonderController.text.trim();
              setState(() {
                aiReply = answer.isEmpty
                    ? '先写一点你的想法，我会认真回应。'
                    : '你的观察很有意思。你已经开始把建筑与人的生活连接起来了；下一次可以再补充一个具体细节，让表达更有画面。';
              });
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('请 AI 回应'),
          ),
          if (aiReply.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PhoenixTheme.ai.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                aiReply,
                style: const TextStyle(color: PhoenixTheme.ai),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _express(BuildContext context) {
    return _page(
      title: '表达',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expressQuestion),
          const SizedBox(height: 14),
          TextField(
            controller: expressController,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: '用中文写下你的表达……',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '后续版本将接入 AI：纠正语法、解释原因，并给出更自然的表达。',
            style: TextStyle(color: PhoenixTheme.translation),
          ),
        ],
      ),
    );
  }

  Widget _memory(BuildContext context) {
    return _page(
      title: '留下今天',
      buttonText: '完成旅程并自动保存',
      onNext: () async {
        await context.read<AppState>().completeJourney(memoryController.text);
        if (mounted) next();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('今天最想记住的一件事是什么？'),
          const SizedBox(height: 14),
          TextField(
            controller: memoryController,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '每一次感受都会自动保存，未来可以回来比较自己的变化。',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _complete(BuildContext context) {
    return _page(
      title: '北京已点亮',
      buttonText: '返回首页',
      onNext: () => Navigator.of(context).pop(),
      child: const Column(
        children: [
          SizedBox(height: 18),
          Text('🏯', style: TextStyle(fontSize: 78)),
          SizedBox(height: 18),
          Text(
            '你没有完成一堂课。\n你完成了一段旅程。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 1.6),
          ),
        ],
      ),
    );
  }
}
