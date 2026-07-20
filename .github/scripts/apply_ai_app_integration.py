from pathlib import Path

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text(encoding='utf-8')

anchor = """  void _clearAgentStatus() {
    if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

"""
profile_getter = """  void _clearAgentStatus() {
    if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Map<String, dynamic> get _aiLearnerProfile {
    final guideObservations = <String>[
      wonderController.text.trim(),
      _appState.guideFeedbackReply.trim(),
      ..._appState.memories.take(6),
    ].where((value) => value.isNotEmpty).toList(growable: false);
    final writingInsights = <String>[
      _appState.writingFeedbackExplanation.trim(),
      _appState.writingFeedbackNatural.trim(),
      expressController.text.trim(),
    ].where((value) => value.isNotEmpty).toList(growable: false);

    return <String, dynamic>{
      'interfaceLanguage': _appState.translationLanguage,
      'scriptMode': _appState.isTraditional ? 'traditional' : 'simplified',
      'currentLevel': '根据学习者本次中文动态判断',
      'savedWords': _appState.savedWords.toList(growable: false),
      'completedJourneys':
          _appState.earnedJourneyStampIds.toList(growable: false),
      'recentGuideObservations': guideObservations,
      'recentWritingInsights': writingInsights,
    };
  }

"""
if anchor not in journey:
    raise RuntimeError('Journey profile insertion anchor not found')
journey = journey.replace(anchor, profile_getter, 1)

old_guide = """        language: _appState.translationLanguage,
        journeyId: _experience.id,
      );
"""
new_guide = """        language: _appState.translationLanguage,
        journeyId: _experience.id,
        learnerProfile: _aiLearnerProfile,
      );
"""
if old_guide not in journey:
    raise RuntimeError('Guide call anchor not found')
journey = journey.replace(old_guide, new_guide, 1)

old_writing = """        text: writing,
        language: _appState.translationLanguage,
      );
"""
new_writing = """        text: writing,
        language: _appState.translationLanguage,
        journeyId: _experience.id,
        learnerProfile: _aiLearnerProfile,
      );
"""
if old_writing not in journey:
    raise RuntimeError('Writing call anchor not found')
journey = journey.replace(old_writing, new_writing, 1)
journey_path.write_text(journey, encoding='utf-8')

cards_path = Path('app/lib/widgets/phoenix_agent_cards.dart')
cards = cards_path.read_text(encoding='utf-8')
cards = cards.replace(
    "_AgentStatusChip(isOffline: feedback.isOfflineFallback)",
    "_AgentStatusChip(\n                isOffline: feedback.isOfflineFallback,\n                provider: feedback.provider,\n                qualityReviewed: feedback.qualityReviewed,\n              )",
)
old_chip = """class _AgentStatusChip extends StatelessWidget {
  const _AgentStatusChip({required this.isOffline});

  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOffline ? Colors.orange : Colors.green).withValues(alpha: .10),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isOffline ? '本地建议' : 'AI 在线',
        style: TextStyle(
          color: isOffline ? Colors.orange.shade800 : Colors.green.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
"""
new_chip = """class _AgentStatusChip extends StatelessWidget {
  const _AgentStatusChip({
    required this.isOffline,
    required this.provider,
    required this.qualityReviewed,
  });

  final bool isOffline;
  final String provider;
  final bool qualityReviewed;

  String get _label {
    if (isOffline) return '本地建议';
    if (provider == 'openai' && qualityReviewed) return 'GPT · 已复核';
    if (qualityReviewed) return 'AI · 已复核';
    return provider == 'openai' ? 'GPT 在线' : 'AI 在线';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('phoenix-agent-status-$provider-$qualityReviewed'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOffline ? Colors.orange : Colors.green).withValues(alpha: .10),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: isOffline ? Colors.orange.shade800 : Colors.green.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
"""
if old_chip not in cards:
    raise RuntimeError('Agent status chip anchor not found')
cards = cards.replace(old_chip, new_chip, 1)
cards_path.write_text(cards, encoding='utf-8')

Path('.github/scripts/apply_ai_app_integration.py').unlink(missing_ok=True)
Path('.github/workflows/apply-ai-app-integration.yml').unlink(missing_ok=True)
