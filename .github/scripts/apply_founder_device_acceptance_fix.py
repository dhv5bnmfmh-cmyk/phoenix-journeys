from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    target = Path(path)
    text = target.read_text()
    count = text.count(old)
    if count != 1:
        raise SystemExit(
            f"{path}: expected one match, found {count}: {old[:80]!r}"
        )
    target.write_text(text.replace(old, new, 1))


hsk = "app/lib/widgets/hsk_story_challenge.dart"
journey = "app/lib/screens/journey_screen.dart"

replace_once(
    hsk,
    "    this.onFeedbackAudio,\n    this.onBackStage,\n",
    "    this.onFeedbackAudio,\n    this.onQuestionChanged,\n    this.onBackStage,\n",
)
replace_once(
    hsk,
    "  final Future<void> Function(String questionId, bool correct)? onFeedbackAudio;\n"
    "  final VoidCallback? onBackStage;\n",
    "  final Future<void> Function(String questionId, String feedbackText)? "
    "onFeedbackAudio;\n"
    "  final VoidCallback? onQuestionChanged;\n"
    "  final VoidCallback? onBackStage;\n",
)
replace_once(
    hsk,
    "  bool submitted = false;\n  final List<String> built = <String>[];\n",
    "  bool submitted = false;\n"
    "  bool challengeCompleted = false;\n"
    "  final List<String> built = <String>[];\n",
)
replace_once(
    hsk,
    "  bool get _canSubmit {\n",
    "  String get _feedbackAudioText {\n"
    "    final parts = <String>[\n"
    "      '正确答案：${widget.displayText(question.answer)}',\n"
    "    ];\n"
    "    if (!_correct &&\n"
    "        selectedOption != null &&\n"
    "        selectedOption! < question.distractorRationales.length) {\n"
    "      final rationale = question.distractorRationales[selectedOption!];\n"
    "      if (rationale.isNotEmpty) {\n"
    "        parts.add('错误原因：${widget.displayText(rationale)}');\n"
    "      }\n"
    "    }\n"
    "    if (question.whyCorrect.isNotEmpty) {\n"
    "      parts.add('解释：${widget.displayText(question.whyCorrect)}');\n"
    "    } else if (question.grammarRevisionRule?.isNotEmpty ?? false) {\n"
    "      parts.add('解释：${widget.displayText(question.grammarRevisionRule!)}');\n"
    "    }\n"
    "    return parts.join('。');\n"
    "  }\n\n"
    "  bool get _canSubmit {\n",
)
replace_once(
    hsk,
    "    submitted = false;\n    built.clear();\n",
    "    submitted = false;\n"
    "    challengeCompleted = false;\n"
    "    built.clear();\n",
)
replace_once(
    hsk,
    "    final correct = _correct;\n"
    "    setState(() => submitted = true);\n"
    "    final feedbackAudio = widget.onFeedbackAudio;\n"
    "    if (feedbackAudio != null) {\n"
    "      unawaited(feedbackAudio(question.id, correct));\n"
    "    }\n",
    "    setState(() => submitted = true);\n"
    "    final feedbackAudio = widget.onFeedbackAudio;\n"
    "    if (feedbackAudio != null) {\n"
    "      unawaited(feedbackAudio(question.id, _feedbackAudioText));\n"
    "    }\n",
)
replace_once(
    hsk,
    "  Future<void> _next() async {\n"
    "    if (!submitted) return;\n"
    "    if (index == widget.challenge.questions.length - 1) {\n"
    "      await widget.onCompleted();\n"
    "      return;\n"
    "    }\n"
    "    setState(() {\n"
    "      index += 1;\n"
    "      _resetQuestion();\n"
    "    });\n"
    "  }\n",
    "  Future<void> _next() async {\n"
    "    if (!submitted || challengeCompleted) return;\n"
    "    widget.onQuestionChanged?.call();\n"
    "    if (index == widget.challenge.questions.length - 1) {\n"
    "      setState(() => challengeCompleted = true);\n"
    "      await widget.onCompleted();\n"
    "      return;\n"
    "    }\n"
    "    setState(() {\n"
    "      index += 1;\n"
    "      _resetQuestion();\n"
    "    });\n"
    "  }\n",
)
replace_once(
    hsk,
    "  void _previous() {\n    if (index == 0) {\n",
    "  void _previous() {\n"
    "    widget.onQuestionChanged?.call();\n"
    "    if (index == 0) {\n",
)
replace_once(
    hsk,
    "  Widget _bottomActions() => SizedBox(\n",
    "  Widget _bottomActions() => challengeCompleted\n"
    "      ? const SizedBox.shrink()\n"
    "      : SizedBox(\n",
)
replace_once(
    hsk,
    "                widget.onFeedbackAudio!(question.id, _correct),\n",
    "                widget.onFeedbackAudio!(question.id, _feedbackAudioText),\n",
)

replace_once(
    journey,
    "  Future<void> _playChallengeFeedbackAudio(String _, bool correct) async {\n"
    "    await _narration.speakTemporaryText(\n"
    "      correct ? '回答正确' : '回答错误，请查看红色标记',\n"
    "      languageCode: journeyStageNarrationLanguageCode(_appState.isTraditional),\n"
    "    );\n"
    "  }\n",
    "  void _resetChallengeAudio() {\n"
    "    _stageNarrationIntent += 1;\n"
    "    _stageNarrationRequestedId = null;\n"
    "    _narration.cancelPlaybackImmediately();\n"
    "  }\n\n"
    "  Future<void> _playChallengeFeedbackAudio(\n"
    "    String questionId,\n"
    "    String feedbackText,\n"
    "  ) async {\n"
    "    final text = feedbackText.trim();\n"
    "    if (text.isEmpty) return;\n"
    "    final contentId = 'challenge-feedback-$questionId';\n"
    "    _stageNarrationIntent += 1;\n"
    "    _stageNarrationRequestedId = null;\n"
    "    await _narration.stop();\n"
    "    if (!mounted) return;\n"
    "    await _narration.play(\n"
    "      contentId: contentId,\n"
    "      items: [NarrationItem(id: contentId, text: text, label: '答题反馈')],\n"
    "      languageCode: journeyStageNarrationLanguageCode(_appState.isTraditional),\n"
    "    );\n"
    "  }\n",
)
replace_once(
    journey,
    "              onNarrate: _speakChallengeNarration,\n"
    "              onFeedbackAudio: _playChallengeFeedbackAudio,\n"
    "              onCompleted: () async {\n",
    "              onNarrate: _speakChallengeNarration,\n"
    "              onFeedbackAudio: _playChallengeFeedbackAudio,\n"
    "              onQuestionChanged: _resetChallengeAudio,\n"
    "              onCompleted: () async {\n",
)
