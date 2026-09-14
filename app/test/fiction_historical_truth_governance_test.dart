import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

enum PremiseScope { worldClaim, characterFiction, interpretiveDevice }

enum TruthCategory {
  verifiedFact,
  verifiedHistoricalAction,
  verifiedCulturalPractice,
  verifiedInstitutionalCondition,
  verifiedPhysicalOrSpatialCondition,
  fictionalCharacterIdentity,
  fictionalCharacterBackstory,
  fictionalCharacterAction,
  fictionalRelationship,
  fictionalDialogue,
  fictionalPersonalMotivation,
  fictionalPersonalChoice,
  fictionalPersonalCost,
  fictionalPersonalConsequence,
  interpretiveStoryDevice,
  legendOrFolklore,
  contested,
  unknown,
  unsupportedFactualClaim,
}

class GovernancePremise {
  const GovernancePremise({
    required this.scope,
    required this.category,
    required this.sourceIds,
    required this.plausible,
    required this.contradictsVerifiedWorld,
    required this.impliesUnsupportedWorldClaim,
  });

  final PremiseScope scope;
  final TruthCategory category;
  final List<String> sourceIds;
  final bool plausible;
  final bool contradictsVerifiedWorld;
  final bool impliesUnsupportedWorldClaim;
}

bool governanceAllows(GovernancePremise premise) {
  if (premise.category == TruthCategory.unsupportedFactualClaim) return false;
  if (premise.contradictsVerifiedWorld || premise.impliesUnsupportedWorldClaim) {
    return false;
  }
  switch (premise.scope) {
    case PremiseScope.worldClaim:
      return premise.sourceIds.isNotEmpty;
    case PremiseScope.characterFiction:
      return premise.plausible;
    case PremiseScope.interpretiveDevice:
      return premise.plausible;
  }
}

void main() {
  group('verified world plus fictional human governance', () {
    test('permits plausible fictional private action without documentary source', () {
      const premise = GovernancePremise(
        scope: PremiseScope.characterFiction,
        category: TruthCategory.fictionalPersonalChoice,
        sourceIds: <String>[],
        plausible: true,
        contradictsVerifiedWorld: false,
        impliesUnsupportedWorldClaim: false,
      );

      expect(governanceAllows(premise), isTrue);
    });

    test('blocks an unsourced historical rule hidden inside character stakes', () {
      const premise = GovernancePremise(
        scope: PremiseScope.worldClaim,
        category: TruthCategory.unsupportedFactualClaim,
        sourceIds: <String>[],
        plausible: true,
        contradictsVerifiedWorld: false,
        impliesUnsupportedWorldClaim: true,
      );

      expect(governanceAllows(premise), isFalse);
    });

    test('blocks fictional action that depends on an invented world condition', () {
      const premise = GovernancePremise(
        scope: PremiseScope.characterFiction,
        category: TruthCategory.fictionalCharacterAction,
        sourceIds: <String>[],
        plausible: true,
        contradictsVerifiedWorld: false,
        impliesUnsupportedWorldClaim: true,
      );

      expect(governanceAllows(premise), isFalse);
    });

    test('requires evidence for a verified institutional condition', () {
      const unsourced = GovernancePremise(
        scope: PremiseScope.worldClaim,
        category: TruthCategory.verifiedInstitutionalCondition,
        sourceIds: <String>[],
        plausible: true,
        contradictsVerifiedWorld: false,
        impliesUnsupportedWorldClaim: false,
      );
      const sourced = GovernancePremise(
        scope: PremiseScope.worldClaim,
        category: TruthCategory.verifiedInstitutionalCondition,
        sourceIds: <String>['official-source'],
        plausible: true,
        contradictsVerifiedWorld: false,
        impliesUnsupportedWorldClaim: false,
      );

      expect(governanceAllows(unsourced), isFalse);
      expect(governanceAllows(sourced), isTrue);
    });
  });

  test('canonical documents carry the same world/fiction boundary', () {
    final files = <String>[
      '../ai/AI_BEHAVIOR.md',
      '../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md',
      '../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md',
      '../docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md',
      '../docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md',
      '../docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md',
      '../docs/templates/PHOENIX_STORY_TRUTH_PLACE_GATE_RECORD.md',
    ];

    for (final path in files) {
      final text = File(path).readAsStringSync();
      expect(text, contains('FICTIONAL CHARACTER ACTION'), reason: path);
      expect(text, contains('UNSUPPORTED FACTUAL CLAIM'), reason: path);
    }
  });
}
