from pathlib import Path

path = Path('app/lib/agents/phoenix_language_level_agent.dart')
text = path.read_text(encoding='utf-8')

old_level_eight = '''        8 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.advanced,
            paragraphCount: 1,
            minTotalCharacters: 540,
            maxTotalCharacters: 720,
            targetVocabularyCount: 13,
            maximumVocabularyCount: 15,
'''
new_level_eight = '''        8 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.advanced,
            paragraphCount: 1,
            minTotalCharacters: 540,
            maxTotalCharacters: 720,
            targetVocabularyCount: 14,
            maximumVocabularyCount: 16,
'''
if old_level_eight not in text:
    raise SystemExit('Phoenix level eight plan anchor not found')
text = text.replace(old_level_eight, new_level_eight, 1)

start = text.index('  ReadingGenerationPlan _legacyPlan(PhoenixReadingBand band)')
end = text.index('  List<WordEntry> selectVocabulary({', start)
legacy = '''  ReadingGenerationPlan _legacyPlan(PhoenixReadingBand band) => switch (band) {
        PhoenixReadingBand.beginner => const ReadingGenerationPlan(
            band: PhoenixReadingBand.beginner,
            paragraphCount: 1,
            minTotalCharacters: 80,
            maxTotalCharacters: 140,
            targetVocabularyCount: 4,
            maximumVocabularyCount: 5,
            cultureWordQuota: 1,
            targetGrammarCount: 1,
            minimumKnownWordCoverage: .98,
            maximumSentenceCharacters: 16,
            speechRate: .80,
          ),
        PhoenixReadingBand.elementary => const ReadingGenerationPlan(
            band: PhoenixReadingBand.elementary,
            paragraphCount: 2,
            minTotalCharacters: 150,
            maxTotalCharacters: 240,
            targetVocabularyCount: 6,
            maximumVocabularyCount: 7,
            cultureWordQuota: 2,
            targetGrammarCount: 1,
            minimumKnownWordCoverage: .97,
            maximumSentenceCharacters: 22,
            speechRate: .85,
          ),
        PhoenixReadingBand.intermediate => const ReadingGenerationPlan(
            band: PhoenixReadingBand.intermediate,
            paragraphCount: 2,
            minTotalCharacters: 280,
            maxTotalCharacters: 400,
            targetVocabularyCount: 9,
            maximumVocabularyCount: 10,
            cultureWordQuota: 2,
            targetGrammarCount: 2,
            minimumKnownWordCoverage: .96,
            maximumSentenceCharacters: 30,
            speechRate: .90,
          ),
        PhoenixReadingBand.upperIntermediate => const ReadingGenerationPlan(
            band: PhoenixReadingBand.upperIntermediate,
            paragraphCount: 2,
            minTotalCharacters: 450,
            maxTotalCharacters: 600,
            targetVocabularyCount: 11,
            maximumVocabularyCount: 12,
            cultureWordQuota: 3,
            targetGrammarCount: 2,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 38,
            speechRate: .95,
          ),
        PhoenixReadingBand.advanced => const ReadingGenerationPlan(
            band: PhoenixReadingBand.advanced,
            paragraphCount: 1,
            minTotalCharacters: 600,
            maxTotalCharacters: 800,
            targetVocabularyCount: 14,
            maximumVocabularyCount: 16,
            cultureWordQuota: 4,
            targetGrammarCount: 3,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 48,
            speechRate: 1,
          ),
        PhoenixReadingBand.mastery => const ReadingGenerationPlan(
            band: PhoenixReadingBand.mastery,
            paragraphCount: 1,
            minTotalCharacters: 600,
            maxTotalCharacters: 900,
            targetVocabularyCount: 16,
            maximumVocabularyCount: 20,
            cultureWordQuota: 5,
            targetGrammarCount: 3,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 58,
            speechRate: 1.05,
          ),
      };

'''
text = text[:start] + legacy + text[end:]
path.write_text(text, encoding='utf-8')

Path('tool/patch_phoenix_level_plans.py').unlink(missing_ok=True)
Path('.github/workflows/patch-phoenix-level-plans.yml').unlink(missing_ok=True)
