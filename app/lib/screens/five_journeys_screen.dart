import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class FiveJourneysScreen extends StatefulWidget {
  const FiveJourneysScreen({super.key});

  @override
  State<FiveJourneysScreen> createState() => _FiveJourneysScreenState();
}

class _FiveJourneysScreenState extends State<FiveJourneysScreen> {
  static const _completionKey = 'phoenix.fiveJourneys.completed.v1';
  static const _rewardKey = 'phoenix.fiveJourneys.rewards.v1';

  Set<String> _completed = <String>{};
  Map<String, String> _rewards = <String, String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final rewards = <String, String>{};
    for (final record in prefs.getStringList(_rewardKey) ?? const <String>[]) {
      final split = record.indexOf('|');
      if (split > 0) rewards[record.substring(0, split)] = record.substring(split + 1);
    }
    if (!mounted) return;
    setState(() {
      _completed = (prefs.getStringList(_completionKey) ?? const <String>[]).toSet();
      _rewards = rewards;
      _loading = false;
    });
  }

  Future<void> _openJourney(_Journey journey) async {
    final result = await Navigator.of(context).push<_JourneyResult>(
      MaterialPageRoute<_JourneyResult>(
        builder: (_) => _JourneyExperienceScreen(journey: journey),
      ),
    );
    if (result == null) return;
    final prefs = await SharedPreferences.getInstance();
    final completed = <String>{..._completed, journey.id};
    final rewards = <String, String>{..._rewards, journey.id: result.reward};
    await prefs.setStringList(_completionKey, completed.toList()..sort());
    await prefs.setStringList(
      _rewardKey,
      rewards.entries.map((entry) => '${entry.key}|${entry.value}').toList()..sort(),
    );
    if (!mounted) return;
    setState(() {
      _completed = completed;
      _rewards = rewards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Phoenix · 五段新旅程'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              key: const ValueKey('five-journeys-home'),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 34),
              children: [
                _JourneyHeader(completed: _completed.length),
                const SizedBox(height: 18),
                for (var index = 0; index < fiveJourneys.length; index++) ...[
                  _JourneyCard(
                    journey: fiveJourneys[index],
                    number: index + 1,
                    completed: _completed.contains(fiveJourneys[index].id),
                    reward: _rewards[fiveJourneys[index].id],
                    onTap: () => _openJourney(fiveJourneys[index]),
                  ),
                  if (index != fiveJourneys.length - 1) const SizedBox(height: 14),
                ],
              ],
            ),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.completed});
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6F1D1B), Color(0xFFB24A2F)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('五城新章', style: TextStyle(color: Color(0xFFFFD879), fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('从海港晨雾，到雪山星火', style: TextStyle(color: Colors.white, fontSize: 24, height: 1.25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 9),
          Text('每段旅程都包含故事、生词、发现、挑战、印象与盖章。已完成 $completed / 5。', style: TextStyle(color: Colors.white.withValues(alpha: .88), height: 1.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: completed / 5, minHeight: 9, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD879))),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.journey, required this.number, required this.completed, required this.reward, required this.onTap});
  final _Journey journey;
  final int number;
  final bool completed;
  final String? reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .9),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: journey.colors),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(journey.icon, color: Colors.white, size: 31),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('旅程 $number · ${journey.location}', style: const TextStyle(color: PhoenixTheme.red, fontSize: 12, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(journey.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Text(journey.subtitle, style: TextStyle(color: Colors.black.withValues(alpha: .58), height: 1.35, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Icon(completed ? Icons.verified_rounded : Icons.chevron_right_rounded, color: completed ? const Color(0xFFB8860B) : Colors.black45),
                  if (reward != null) ...[
                    const SizedBox(height: 5),
                    Text(reward!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyExperienceScreen extends StatefulWidget {
  const _JourneyExperienceScreen({required this.journey});
  final _Journey journey;

  @override
  State<_JourneyExperienceScreen> createState() => _JourneyExperienceScreenState();
}

class _JourneyExperienceScreenState extends State<_JourneyExperienceScreen> {
  int _step = 0;
  int _attempts = 0;
  int? _selectedAnswer;
  int? _selectedImpression;
  String? _feedback;
  bool _challengeResolved = false;

  _Journey get journey => widget.journey;
  String get reward => _attempts <= 1 ? '金币' : _attempts == 2 ? '银币' : '铜币';

  void _next() {
    if (_step == 5) {
      Navigator.of(context).pop(_JourneyResult(reward));
      return;
    }
    setState(() {
      _step += 1;
      _feedback = null;
    });
  }

  void _checkChallenge() {
    if (_challengeResolved || _selectedAnswer == null) return;
    final attempt = _attempts + 1;
    final correct = _selectedAnswer == journey.correctAnswer;
    final exhausted = !correct && attempt >= 3;
    setState(() {
      _attempts = attempt;
      if (correct) {
        _challengeResolved = true;
        _feedback = '回答正确。${journey.explanation}';
      } else if (exhausted) {
        _challengeResolved = true;
        _selectedAnswer = journey.correctAnswer;
        _feedback = '三次机会已用完，正确答案已经标出。${journey.explanation}';
      } else {
        _selectedAnswer = null;
        _feedback = journey.hint;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = <String>['故事', '生词', '发现', '挑战', '留下印象', '盖章'];
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: Text(journey.title)),
      body: SafeArea(
        child: Column(
          children: [
            _StepRail(step: _step, labels: titles),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: SingleChildScrollView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                  child: _buildStep(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StoryStep(journey: journey, onNext: _next);
      case 1:
        return _VocabularyStep(journey: journey, onNext: _next);
      case 2:
        return _DiscoveryStep(journey: journey, onNext: _next);
      case 3:
        return _ChallengeStep(
          journey: journey,
          selected: _selectedAnswer,
          attempts: _attempts,
          resolved: _challengeResolved,
          feedback: _feedback,
          onSelect: (value) => setState(() => _selectedAnswer = value),
          onCheck: _checkChallenge,
          onNext: _next,
        );
      case 4:
        return _ImpressionStep(
          journey: journey,
          selected: _selectedImpression,
          onSelect: (value) => setState(() => _selectedImpression = value),
          onNext: _selectedImpression == null ? null : _next,
        );
      default:
        return _StampStep(journey: journey, reward: reward, onFinish: _next);
    }
  }
}

class _StepRail extends StatelessWidget {
  const _StepRail({required this.step, required this.labels});
  final int step;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: .75),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: index <= step ? PhoenixTheme.red : const Color(0xFFE6DED4),
                    child: Text('${index + 1}', style: TextStyle(color: index <= step ? Colors.white : Colors.black45, fontSize: 11, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 4),
                  Text(labels[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: index == step ? PhoenixTheme.red : Colors.black45)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StoryStep extends StatelessWidget {
  const _StoryStep({required this.journey, required this.onNext});
  final _Journey journey;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: journey.icon,
      eyebrow: journey.location,
      title: journey.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(journey.story, style: const TextStyle(fontSize: 16, height: 1.85, fontWeight: FontWeight.w600)),
          const SizedBox(height: 22),
          _PrimaryButton(label: '进入生词', onPressed: onNext),
        ],
      ),
    );
  }
}

class _VocabularyStep extends StatelessWidget {
  const _VocabularyStep({required this.journey, required this.onNext});
  final _Journey journey;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: Icons.translate_rounded,
      eyebrow: '旅程词袋',
      title: '先收下这些词',
      child: Column(
        children: [
          for (final word in journey.vocabulary) ...[
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: const Color(0xFFFFFBF3), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x1F7F1D1D))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(word.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: Text('${word.part} · ${word.english}\n${word.meaning}', style: const TextStyle(height: 1.45, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          _PrimaryButton(label: '继续发现', onPressed: onNext),
        ],
      ),
    );
  }
}

class _DiscoveryStep extends StatelessWidget {
  const _DiscoveryStep({required this.journey, required this.onNext});
  final _Journey journey;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: Icons.travel_explore_rounded,
      eyebrow: '旅途发现',
      title: journey.discoveryTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(journey.discovery, style: const TextStyle(fontSize: 16, height: 1.75, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: const Color(0xFFFFF0D1), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [const Icon(Icons.lightbulb_rounded, color: PhoenixTheme.red), const SizedBox(width: 10), Expanded(child: Text(journey.discoveryNote, style: const TextStyle(height: 1.45, fontWeight: FontWeight.w800)))]),
          ),
          const SizedBox(height: 22),
          _PrimaryButton(label: '接受挑战', onPressed: onNext),
        ],
      ),
    );
  }
}

class _ChallengeStep extends StatelessWidget {
  const _ChallengeStep({required this.journey, required this.selected, required this.attempts, required this.resolved, required this.feedback, required this.onSelect, required this.onCheck, required this.onNext});
  final _Journey journey;
  final int? selected;
  final int attempts;
  final bool resolved;
  final String? feedback;
  final ValueChanged<int> onSelect;
  final VoidCallback onCheck;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: Icons.extension_rounded,
      eyebrow: '最多三次机会 · ${attempts.clamp(0, 3)} / 3',
      title: journey.question,
      child: Column(
        children: [
          for (var index = 0; index < journey.options.length; index++) ...[
            Material(
              color: selected == index ? const Color(0xFFFFE8B6) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: resolved ? null : () => onSelect(index),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [CircleAvatar(radius: 14, backgroundColor: selected == index ? PhoenixTheme.red : const Color(0xFFEAE3D9), child: Text(String.fromCharCode(65 + index), style: TextStyle(color: selected == index ? Colors.white : Colors.black54, fontWeight: FontWeight.w900))), const SizedBox(width: 12), Expanded(child: Text(journey.options[index], style: const TextStyle(height: 1.4, fontWeight: FontWeight.w700)))]),
                ),
              ),
            ),
            const SizedBox(height: 9),
          ],
          if (feedback != null) ...[
            const SizedBox(height: 5),
            Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: resolved ? const Color(0xFFE9F5E8) : const Color(0xFFFFF0E4), borderRadius: BorderRadius.circular(16)), child: Text(feedback!, style: const TextStyle(height: 1.45, fontWeight: FontWeight.w700))),
          ],
          const SizedBox(height: 18),
          _PrimaryButton(label: resolved ? '留下印象' : '确认答案', onPressed: resolved ? onNext : selected == null ? null : onCheck),
        ],
      ),
    );
  }
}

class _ImpressionStep extends StatelessWidget {
  const _ImpressionStep({required this.journey, required this.selected, required this.onSelect, required this.onNext});
  final _Journey journey;
  final int? selected;
  final ValueChanged<int> onSelect;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: Icons.auto_stories_rounded,
      eyebrow: '不评分，只记录',
      title: '这段旅程给你留下什么？',
      child: Column(
        children: [
          for (var index = 0; index < journey.impressions.length; index++)
            RadioListTile<int>(value: index, groupValue: selected, onChanged: (value) { if (value != null) onSelect(value); }, title: Text(journey.impressions[index], style: const TextStyle(fontWeight: FontWeight.w700)), activeColor: PhoenixTheme.red, contentPadding: EdgeInsets.zero),
          const SizedBox(height: 16),
          _PrimaryButton(label: '盖下旅程章', onPressed: onNext),
        ],
      ),
    );
  }
}

class _StampStep extends StatelessWidget {
  const _StampStep({required this.journey, required this.reward, required this.onFinish});
  final _Journey journey;
  final String reward;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      icon: Icons.verified_rounded,
      eyebrow: '旅程完成',
      title: '${journey.location} · 已盖章',
      child: Column(
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: PhoenixTheme.red, width: 5), color: const Color(0xFFFFF2D5)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(journey.icon, color: PhoenixTheme.red, size: 52), const SizedBox(height: 9), Text(journey.stamp, textAlign: TextAlign.center, style: const TextStyle(color: PhoenixTheme.red, fontSize: 22, height: 1.2, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(reward, style: const TextStyle(color: Color(0xFF9A6B00), fontWeight: FontWeight.w900))]),
          ),
          const SizedBox(height: 18),
          Text(journey.closing, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w700)),
          const SizedBox(height: 22),
          _PrimaryButton(label: '返回五段旅程', onPressed: onFinish),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.icon, required this.eyebrow, required this.title, required this.child});
  final IconData icon;
  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: PhoenixTheme.red, size: 34),
          const SizedBox(height: 12),
          Text(eyebrow, style: const TextStyle(color: PhoenixTheme.red, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 23, height: 1.25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: FilledButton(onPressed: onPressed, style: FilledButton.styleFrom(backgroundColor: PhoenixTheme.red, padding: const EdgeInsets.symmetric(vertical: 15)), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))));
  }
}

class _JourneyResult {
  const _JourneyResult(this.reward);
  final String reward;
}

class _Word {
  const _Word(this.word, this.part, this.english, this.meaning);
  final String word;
  final String part;
  final String english;
  final String meaning;
}

class _Journey {
  const _Journey({required this.id, required this.location, required this.title, required this.subtitle, required this.icon, required this.colors, required this.story, required this.vocabulary, required this.discoveryTitle, required this.discovery, required this.discoveryNote, required this.question, required this.options, required this.correctAnswer, required this.hint, required this.explanation, required this.impressions, required this.stamp, required this.closing});
  final String id;
  final String location;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final String story;
  final List<_Word> vocabulary;
  final String discoveryTitle;
  final String discovery;
  final String discoveryNote;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String hint;
  final String explanation;
  final List<String> impressions;
  final String stamp;
  final String closing;
}

const fiveJourneys = <_Journey>[
  _Journey(
    id: 'haiphong-mist', location: '海防', title: '港口晨雾里的红花', subtitle: '沿着旧码头寻找一封没有寄出的船信', icon: Icons.directions_boat_filled_rounded, colors: [Color(0xFF315F73), Color(0xFFD65A3A)],
    story: '清晨，海防港被薄雾包住。码头边的凤凰花落在湿润的石阶上，像一串没有熄灭的小火。你在旧仓库门口发现一封船员留下的信。信中没有地址，只有一句话：“等花再开时，请替我看看这座城。”你沿着铁轨、钟楼和河岸前进，终于明白，这封信不是要寄往远方，而是写给多年后的故乡。',
    vocabulary: [_Word('薄雾', '名词', 'mist', '很淡的雾'), _Word('码头', '名词', 'wharf', '船只停靠、装卸货物的地方'), _Word('故乡', '名词', 'hometown', '出生或长期生活过的地方')],
    discoveryTitle: '港口为什么总与远方相连？', discovery: '港口不仅运送货物，也运送人的记忆。旧铁轨、仓库和钟声，会把城市过去的生活方式留在今天。', discoveryNote: '“远方”在中文里既可以指地点，也可以代表理想与未知。',
    question: '信中“写给多年后的故乡”最准确的意思是什么？', options: ['船员忘记填写收信地址', '这封信希望未来的人重新理解家乡', '故乡已经搬到了另一个地方', '信只能等凤凰花开时寄出', '船员想让别人替他买花'], correctAnswer: 1, hint: '注意故事最后一句，信真正等待的不是邮差，而是时间。', explanation: '这封信通过未来读者，让故乡重新看见自己的历史。',
    impressions: ['城市的记忆值得被保存', '离开以后才更懂故乡', '港口让我想到新的出发'], stamp: '海港\n晨花章', closing: '雾会散，花会再开。真正留下来的，是人们愿意重新讲述的城市记忆。',
  ),
  _Journey(
    id: 'suzhou-rain', location: '苏州', title: '雨巷里会移动的窗', subtitle: '跟随一扇借景之窗，穿过园林的四季', icon: Icons.window_rounded, colors: [Color(0xFF477A6A), Color(0xFF91B7A3)],
    story: '午后的小雨落在园林白墙上。你站在一扇花窗前，看见远处的竹子、石桥和一角屋檐。奇怪的是，每当你向前走一步，窗里的景色就会改变。园丁告诉你：“窗没有动，是你的位置改变了。”你绕过长廊后再次回望，才发现园林没有把风景一次说完，而是让游人用脚步慢慢读懂。',
    vocabulary: [_Word('园林', '名词', 'garden', '经过设计的自然与建筑空间'), _Word('借景', '动词', 'borrow scenery', '把远处景物纳入眼前构图'), _Word('屋檐', '名词', 'eaves', '屋顶向外伸出的边缘')],
    discoveryTitle: '一扇窗如何装下远山？', discovery: '中国园林常用“借景”把园外的山、水、塔或树纳入园内画面。景色没有真的移动，变化来自观看者的位置。', discoveryNote: '中文常用“读一座城”“读一座园”表达慢慢理解空间。',
    question: '“园林没有把风景一次说完”强调了什么？', options: ['园林还没有建设完成', '游客需要听园丁介绍', '景色会随着行走逐步展开', '窗户每天只能打开一次', '雨天看不清全部风景'], correctAnswer: 2, hint: '回想“每向前走一步，窗里的景色就会改变”。', explanation: '园林通过路线与视角，让景色像故事一样分段出现。',
    impressions: ['慢下来才能看见细节', '同一景物可以有不同角度', '空间也能像文章一样被阅读'], stamp: '苏园\n借景章', closing: '窗框住的不是一张固定图片，而是你与风景相遇的那一刻。',
  ),
  _Journey(
    id: 'xian-lantern', location: '西安', title: '城墙下最后一盏灯', subtitle: '在闭城鼓响前，为陌生人守住一段归途', icon: Icons.festival_rounded, colors: [Color(0xFF7B3F28), Color(0xFFD49A52)],
    story: '夜色落下，城墙上的灯依次亮起。卖灯老人把最后一盏灯交给你，请你送到东门。闭城鼓即将响起，你却在半路遇见一位迷路的孩子。若继续赶路，也许还能准时送灯；若停下来，东门可能已经关闭。你最终牵着孩子一起前行。鼓声响起时，守门人看见灯光，为你们多等了一会儿。原来老人送的不是普通灯笼，而是给晚归者留的一点耐心。',
    vocabulary: [_Word('城墙', '名词', 'city wall', '古代城市的防御建筑'), _Word('晚归', '动词', 'return late', '很晚才回去'), _Word('耐心', '名词', 'patience', '不急躁地等待或处理事情')],
    discoveryTitle: '灯为什么常代表等待？', discovery: '在许多中文故事里，灯既是照明工具，也象征家中有人等待、道路仍然开放，以及陌生人之间的善意。', discoveryNote: '“留一盏灯”常用来表达牵挂，而不只是实际照明。',
    question: '老人真正想送到东门的是什么？', options: ['最贵的一只灯笼', '守门人的新工具', '让晚归者被看见的善意', '孩子丢失的玩具', '闭城鼓的信号'], correctAnswer: 2, hint: '故事末尾已经说明，这盏灯并不普通。', explanation: '灯代表为别人多等一下、多留一条路的善意。',
    impressions: ['规则之外也需要体谅', '帮助别人不会让旅程失去意义', '微小的善意能够照亮归途'], stamp: '长安\n守灯章', closing: '有些灯照亮道路，有些灯提醒人们，别把最后一扇门关得太快。',
  ),
  _Journey(
    id: 'dali-wind', location: '大理', title: '风把云送回了山', subtitle: '在苍山与洱海之间，听懂一次没有答案的告别', icon: Icons.air_rounded, colors: [Color(0xFF4D7D91), Color(0xFF9CC8C4)],
    story: '傍晚，你在洱海边遇见一位收集风声的女孩。她把不同季节的风装进小小的陶瓶，却始终找不到“告别的声音”。第二天，山上的云被风推向远处，她忽然打开所有陶瓶。风声混在一起，没有一句清楚的话。女孩却笑了：“告别本来就没有标准答案。有人说再见，有人只是在离开前多看一眼。”',
    vocabulary: [_Word('洱海', '名词', 'Erhai Lake', '云南大理的高原湖泊'), _Word('陶瓶', '名词', 'clay bottle', '用陶土烧制的瓶子'), _Word('告别', '动词', 'say goodbye', '离开时与人或地方分别')],
    discoveryTitle: '为什么风适合写“告别”？', discovery: '风看不见，却能让云、树叶和水面发生变化。中文文学常借风表达离开、变化和无法握住的感受。', discoveryNote: '“多看一眼”常暗示舍不得，却不直接说出来。',
    question: '女孩最后明白了什么？', options: ['陶瓶无法保存任何声音', '山里的风都完全相同', '告别有很多不同的表达方式', '云必须被送回苍山', '只有说“再见”才算告别'], correctAnswer: 2, hint: '她说“有人说再见，有人只是在离开前多看一眼”。', explanation: '告别可以用语言，也可以通过动作、沉默和目光表达。',
    impressions: ['有些感受不必说得很清楚', '离开也是旅程的一部分', '自然景物能替人表达心情'], stamp: '苍洱\n听风章', closing: '风没有留下，但它经过的水面、云层与人心，都记住了方向。',
  ),
  _Journey(
    id: 'harbin-spark', location: '哈尔滨', title: '雪夜里没有熄灭的星火', subtitle: '穿过结冰的街道，把最后一点温暖送到车站', icon: Icons.ac_unit_rounded, colors: [Color(0xFF557A99), Color(0xFFB8D8EC)],
    story: '暴雪让城市突然安静下来。车站临时停电，一群旅客在候车厅里等待。你从面包店得到一只仍有余温的铁盒，店主说里面装着“星火”。到达车站后，你发现盒中只是几块刚烤好的面包。大家分着吃，陌生人开始聊天，有人给孩子讲故事，有人帮老人联系家人。灯还没有亮，候车厅却不再寒冷。',
    vocabulary: [_Word('暴雪', '名词', 'blizzard', '强烈而持续的大雪'), _Word('余温', '名词', 'remaining warmth', '事物冷却前留下的温度'), _Word('候车厅', '名词', 'waiting hall', '旅客等待上车的大厅')],
    discoveryTitle: '“星火”为什么不一定是火？', discovery: '“星火”本来指微小火光，也常比喻刚刚出现、却可能带来更大变化的力量。故事里的星火是食物，也是人与人重新连接的开始。', discoveryNote: '“星星之火”常用来形容很小但有发展力量的开始。',
    question: '候车厅为什么“灯没亮却不再寒冷”？', options: ['暴雪已经完全停止', '车站重新打开了暖气', '面包和互相帮助带来了温暖', '所有旅客都离开了车站', '铁盒里藏着真正的火炉'], correctAnswer: 2, hint: '注意人们吃完面包以后发生的变化。', explanation: '温暖既来自食物，也来自陌生人之间的交流与照顾。',
    impressions: ['分享能改变陌生的空间', '真正的温暖不只来自温度', '很小的行动也会产生连锁变化'], stamp: '冰城\n星火章', closing: '雪夜很长，但只要有人愿意分出一点温度，城市就不会真正熄灭。',
  ),
];
