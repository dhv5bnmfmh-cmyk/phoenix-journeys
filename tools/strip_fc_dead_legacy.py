from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def remove_braced_block(text: str, marker: str, *, after: str | None = None) -> str:
    search_from = 0 if after is None else text.index(after)
    marker_at = text.index(marker, search_from)
    start = text.rfind("\n", 0, marker_at) + 1
    brace_at = text.index("{", marker_at)
    depth = 0
    quote = None
    escape = False
    line_comment = False
    block_comment = False
    i = brace_at
    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""
        if line_comment:
            if ch == "\n":
                line_comment = False
            i += 1
            continue
        if block_comment:
            if ch == "*" and nxt == "/":
                block_comment = False
                i += 2
                continue
            i += 1
            continue
        if quote is not None:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == quote:
                quote = None
            i += 1
            continue
        if ch == "/" and nxt == "/":
            line_comment = True
            i += 2
            continue
        if ch == "/" and nxt == "*":
            block_comment = True
            i += 2
            continue
        if ch in ("'", '"'):
            quote = ch
            i += 1
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = i + 1
                while end < len(text) and text[end] in " \t":
                    end += 1
                if end < len(text) and text[end] == "\n":
                    end += 1
                if end < len(text) and text[end] == "\n":
                    end += 1
                return text[:start] + text[end:]
        i += 1
    raise RuntimeError(f"Unbalanced block for {marker}")


def remove_case_before(text: str, marker: str, next_marker: str) -> str:
    at = text.index(marker)
    start = text.rfind("\n", 0, at) + 1
    nxt = text.index(next_marker, at)
    end = text.rfind("\n", 0, nxt) + 1
    return text[:start] + text[end:]


def strip_screen() -> None:
    path = ROOT / "app/lib/screens/journey_screen_legacy.dart"
    text = path.read_text()
    for line in (
        "import '../data/forbidden_city_content_cache.dart';\n",
        "import '../data/forbidden_city_journey_runtime.dart';\n",
        "  bool get _isForbiddenCity => _experience.id == forbiddenCityJourneyId;\n",
    ):
        if line not in text:
            raise RuntimeError(f"Missing screen token: {line!r}")
        text = text.replace(line, "", 1)

    cache_block = """    if (_experience.id == forbiddenCityJourneyId) {
      warmForbiddenCityContentCache();
    }
"""
    if cache_block not in text:
        raise RuntimeError("Missing Forbidden City cache block")
    text = text.replace(cache_block, "", 1)

    level_block = """    if (profile == null) {
      if (_isForbiddenCity) {
        final fallbackLevel = switch (difficulty) {
          JourneyDifficulty.easy => 1,
          JourneyDifficulty.standard => 5,
          JourneyDifficulty.challenge => 10,
        };
        final base = cachedForbiddenCityLevelContent(fallbackLevel);
        resolved = JourneyLevelContent(
          storyParagraphs: base.storyParagraphs,
          storyAnnotations: base.storyAnnotations,
          words: base.words,
          discoveries: base.discoveries,
          wonderQuestion: '',
          expressQuestion: '',
        );
      } else {
        resolved = resolveJourneyLevel(_experience, difficulty);
      }
    } else {
"""
    level_replacement = """    if (profile == null) {
      resolved = resolveJourneyLevel(_experience, difficulty);
    } else {
"""
    if level_block not in text:
        raise RuntimeError("Missing Forbidden City level fallback block")
    text = text.replace(level_block, level_replacement, 1)

    text = remove_braced_block(
        text,
        "    if (_isForbiddenCity) {",
        after="  List<NarrationItem> _memoryNarrationItems()",
    )
    text = remove_braced_block(
        text,
        "    if (_isForbiddenCity) {",
        after="  List<NarrationItem> _completionNarrationItems()",
    )

    completion_call = """    await _appState.completeJourney(
      _isForbiddenCity ? forbiddenCityMemoryAnchor : memoryController.text,
    );
"""
    if completion_call not in text:
        raise RuntimeError("Missing Forbidden City completion call")
    text = text.replace(
        completion_call,
        "    await _appState.completeJourney(memoryController.text);\n",
        1,
    )

    for line in (
        "    if (_isForbiddenCity) return _forbiddenCityMemoryPage();\n\n",
        "    if (_isForbiddenCity) return _forbiddenCityCompletePage();\n\n",
    ):
        if line not in text:
            raise RuntimeError(f"Missing legacy page dispatch: {line!r}")
        text = text.replace(line, "", 1)

    text = remove_braced_block(text, "  Widget _forbiddenCityMemoryPage() {")
    text = remove_braced_block(text, "  Widget _forbiddenCityCompletePage() {")
    text = remove_braced_block(text, "class _ForbiddenCityCompleteCard extends StatelessWidget {")

    if "forbiddenCity" in text or "ForbiddenCity" in text:
        raise RuntimeError("Forbidden City symbol remains in journey_screen_legacy.dart")
    path.write_text(text)


def strip_challenge() -> None:
    path = ROOT / "app/lib/widgets/journey_challenge_panel_legacy.dart"
    text = path.read_text()
    for line in (
        "import '../data/forbidden_city_challenge_package.dart';\n",
        "import '../data/forbidden_city_journey_runtime.dart';\n",
    ):
        if line not in text:
            raise RuntimeError(f"Missing challenge import: {line!r}")
        text = text.replace(line, "", 1)

    level_block = """    final forbiddenCityLevel = widget.journeyId == forbiddenCityJourneyId
        ? _resolveForbiddenCityChallengeLevel(widget.storyParagraphs)
        : null;
"""
    if level_block not in text:
        raise RuntimeError("Missing legacy challenge level block")
    text = text.replace(level_block, "", 1)

    arg_line = "          forbiddenCityLevel: forbiddenCityLevel,\n"
    if arg_line not in text:
        raise RuntimeError("Missing legacy challenge build arg")
    text = text.replace(arg_line, "", 1)

    param_line = "    int? forbiddenCityLevel,\n"
    if param_line not in text:
        raise RuntimeError("Missing legacy challenge build parameter")
    text = text.replace(param_line, "", 1)

    text = remove_braced_block(
        text,
        "    if (journeyId == forbiddenCityJourneyId) {",
        after="  factory _ChallengeSession.build({",
    )

    for marker in (
        "String _normalizeForbiddenCityChallengeText(String value) =>",
        "int _resolveForbiddenCityChallengeLevel(List<String> storyParagraphs) {",
        "JourneyChallengeDifficulty _forbiddenCityChallengeDifficulty(int level) {",
        "List<String> _forbiddenCityStorySentences(int level) {",
        "void _validateForbiddenCityChallengeTrace(int level) {",
        "  static _ChallengeSession _buildForbiddenCity({",
        "  static _ChallengeSession _buildForbiddenCityParagraph(",
        "  static _ChallengeSession _buildForbiddenCityGrammar(",
        "  static _ChallengeSession _buildForbiddenCityMissing(",
    ):
        if marker not in text:
            raise RuntimeError(f"Missing legacy challenge block: {marker}")
        if marker.endswith("=>"):
            start = text.rfind("\n", 0, text.index(marker)) + 1
            semi = text.index(";", text.index(marker)) + 1
            while semi < len(text) and text[semi] == "\n":
                semi += 1
            text = text[:start] + text[semi:]
        else:
            text = remove_braced_block(text, marker)

    group_line = "      'beijing-forbidden-city' ||\n"
    if group_line not in text:
        raise RuntimeError("Missing Forbidden City adaptive grammar route")
    text = text.replace(group_line, "", 1)

    text = remove_case_before(
        text,
        "      'beijing-forbidden-city' => (",
        "      'beijing-summer-palace' => (",
    )
    text = remove_case_before(
        text,
        "      'beijing-forbidden-city' => [",
        "      'beijing-summer-palace' => [",
    )

    forbidden = (
        "forbiddenCity",
        "ForbiddenCity",
        "beijing-forbidden-city",
        "规定进入路线",
    )
    for token in forbidden:
        if token in text:
            raise RuntimeError(
                f"Forbidden City legacy token remains in journey_challenge_panel_legacy.dart: {token}"
            )
    path.write_text(text)


strip_screen()
strip_challenge()
print("Forbidden City dead legacy branches removed from shared production files.")
