import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

Future<void> showJourneyPlanSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const JourneyPlanSheet(),
  );
}

class JourneyPlanSheet extends StatefulWidget {
  const JourneyPlanSheet({super.key});

  @override
  State<JourneyPlanSheet> createState() => _JourneyPlanSheetState();
}

class _JourneyPlanSheetState extends State<JourneyPlanSheet> {
  static const _focusOptions = ['文化', '词汇', '表达'];

  late final TextEditingController _originController;
  DateTime? _date;
  String _focus = _focusOptions.first;
  bool _initialized = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final state = context.read<AppState>();
    _originController = TextEditingController(text: state.journeyOrigin);
    _date = state.plannedJourneyDate ??
        DateTime.now().add(const Duration(days: 7));
    _focus = _focusOptions.contains(state.journeyLearningFocus)
        ? state.journeyLearningFocus
        : _focusOptions.first;
    _initialized = true;
  }

  @override
  void dispose() {
    _originController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date == null || _date!.isBefore(today) ? today : _date!,
      firstDate: today,
      lastDate: DateTime(today.year + 2, today.month, today.day),
      helpText: '选择旅程日期',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final origin = _originController.text.trim();
    if (origin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写出发城市。')),
      );
      return;
    }
    final date = _date;
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择旅程日期。')),
      );
      return;
    }

    setState(() => _saving = true);
    await context.read<AppState>().saveJourneyPlan(
          origin: origin,
          date: date,
          focus: _focus,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('旅程计划已保存。'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String get _dateLabel {
    final date = _date;
    if (date == null) return '选择日期';
    return '${date.year}年${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '计划下一次语言旅程',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 4),
            const Text(
              '先为当前真实 Journey 安排日期与学习重点。',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('journey-plan-origin'),
              controller: _originController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: '出发城市',
                prefixIcon: Icon(Icons.flight_takeoff_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const InputDecorator(
              decoration: InputDecoration(
                labelText: '目的地',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              child: Text(
                '中国 · 北京 · 紫禁城',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              key: const ValueKey('journey-plan-date'),
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '旅程日期',
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  suffixIcon: Icon(Icons.chevron_right_rounded),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _dateLabel,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              '这次最想加强',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _focusOptions
                  .map(
                    (option) => ChoiceChip(
                      key: ValueKey('journey-plan-focus-$option'),
                      label: Text(option),
                      selected: _focus == option,
                      onSelected: (_) => setState(() => _focus = option),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton.icon(
                key: const ValueKey('save-journey-plan'),
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: PhoenixTheme.red,
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.event_available_rounded),
                label: Text(_saving ? '正在保存…' : '保存旅程计划'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
