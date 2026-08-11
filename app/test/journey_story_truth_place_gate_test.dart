import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/journey_story_development_gate.dart';

JourneySemanticFingerprint _fingerprint(
  String id, {
  Map<NarrativeSemanticDimension, NarrativeMechanismFamily>? mechanisms,
}) {
  final distinct = <NarrativeSemanticDimension, NarrativeMechanismFamily>{
    for (final dimension in NarrativeSemanticDimension.values)
      dimension: NarrativeMechanismFamily.prototypeFailureExposesMediumConstraint,
  };
  return JourneySemanticFingerprint(
    journeyId: id,
    surfaceIdentity: '$id / synthetic surface identity',
    mechanisms: Map.unmodifiable(mechanisms ?? distinct),
    coreEvidence: const <NarrativeMechanismEvidence>[],
  );
}

StoryDevelopmentGateInput _validInput({
  JourneySemanticFingerprint? fingerprint,
  List<StoryClaimRecord>? claims,
  PlaceCausalMechanismRecord? place,
  MechanismFamilyGovernanceRecord? taxonomy,
  Lv1CausalProofRecord? lv1,
  bool draftedEarly = false,
}) {
  const verifiedClaim = StoryClaimRecord(
    claimId: 'place-geometry',
    claim: 'The verified place property constrains movement through a specific spatial relation.',
    classification: StoryClaimClassification.verifiedFact,
    sourceIds: <String>['official-1'],
    materiallySupportsStoryMechanism: true,
  );
  return StoryDevelopmentGateInput(
    journeyId: 'future-gold-test',
    sources: const <StorySourceRecord>[
      StorySourceRecord(
        sourceId: 'official-1',
        authority: StorySourceAuthority.officialHeritageMuseumAuthority,
        citation: 'Official heritage authority record, section 2.',
      ),
    ],
    claims: claims ??
        <StoryClaimRecord>[
          verifiedClaim,
          const StoryClaimRecord(
            claimId: 'fiction-action',
            claim: 'A fictional present-day protagonist moves an ordinary object.',
            classification: StoryClaimClassification.fictionalCharacterAction,
          ),
        ],
    placeCausality: place ??
        const PlaceCausalMechanismRecord(
          verifiedPropertyClaimIds: <String>['place-geometry'],
          whyPropertyCreatesDramaticPossibility:
              'The verified spatial relation creates a concrete constraint the characters must act through.',
          whyGenericSubstitutionFails:
              'Removing the verified spatial relation removes the conflict and decisive action.',
          affectedCausalDimensions: <NarrativeSemanticDimension>{
            NarrativeSemanticDimension.conflictMechanism,
            NarrativeSemanticDimension.choiceMechanism,
            NarrativeSemanticDimension.climaxMechanism,
          },
          genericPlaceSubstitutionLeavesCausalChainIntact: false,
          humanSemanticSufficiencyReviewed: true,
        ),
    storyMechanism: const StoryMechanismArchitecture(
      protagonist: 'Named protagonist with a concrete responsibility',
      relationshipGeometry: 'peer coordination',
      goal: 'complete a place-caused task',
      conflict: 'verified spatial constraint blocks the first approach',
      choice: 'enacted alternative action',
      climax: 'the place-specific constraint is resolved through action',
      consequence: 'the action changes the practical state',
      transformation: 'control shifts to coordination',
      ending: 'changed behavior continues',
      culturalAnchorFunction: 'verified spatial property causes the conflict',
      dramaticEngine: 'distinct synthetic test engine',
    ),
    candidateFingerprint: fingerprint ?? _fingerprint('future-gold-test'),
    taxonomyGovernance: taxonomy ??
        const MechanismFamilyGovernanceRecord(introducesNewFamily: false),
    lv1CausalProof: lv1 ??
        const Lv1CausalProofRecord(
          hasProtagonist: true,
          hasConcreteGoal: true,
          hasConflict: true,
          hasEnactedChoice: true,
          hasDecisiveEvent: true,
          hasCausedConsequence: true,
          humanCausalSufficiencyReviewed: true,
        ),
    fullStoryDraftedBeforePreLockGates: draftedEarly,
  );
}

void main() {
  test('unsupported factual premise blocks Story development', () {
    final input = _validInput(
      claims: const <StoryClaimRecord>[
        StoryClaimRecord(
          claimId: 'invented-rule',
          claim: 'A fictional heritage restriction is asserted as a real rule.',
          classification: StoryClaimClassification.unsupportedFactualClaim,
          materiallySupportsStoryMechanism: true,
        ),
      ],
    );
    final result = evaluateStoryDevelopmentGate(input);
    expect(result.canLockStory, isFalse);
    expect(result.blockingStatuses, contains(unverifiedFactualClaimBlocked));
  });

  test('non-authoritative factual source cannot support a binding premise', () {
    final input = StoryDevelopmentGateInput(
      journeyId: 'future-gold-test',
      sources: const <StorySourceRecord>[
        StorySourceRecord(
          sourceId: 'blog-1',
          authority: StorySourceAuthority.nonAuthoritative,
          citation: 'Unsourced tourism article.',
        ),
      ],
      claims: const <StoryClaimRecord>[
        StoryClaimRecord(
          claimId: 'history',
          claim: 'A historical rule is asserted.',
          classification: StoryClaimClassification.verifiedFact,
          sourceIds: <String>['blog-1'],
          materiallySupportsStoryMechanism: true,
        ),
      ],
      placeCausality: const PlaceCausalMechanismRecord(
        verifiedPropertyClaimIds: <String>['history'],
        whyPropertyCreatesDramaticPossibility: 'Claim drives the plot.',
        whyGenericSubstitutionFails: 'Claim is site-specific.',
        affectedCausalDimensions: <NarrativeSemanticDimension>{
          NarrativeSemanticDimension.conflictMechanism,
        },
        genericPlaceSubstitutionLeavesCausalChainIntact: false,
        humanSemanticSufficiencyReviewed: true,
      ),
      storyMechanism: _validInput().storyMechanism,
      candidateFingerprint: _fingerprint('future-gold-test'),
      taxonomyGovernance:
          const MechanismFamilyGovernanceRecord(introducesNewFamily: false),
      lv1CausalProof: _validInput().lv1CausalProof,
    );
    expect(
      evaluateStoryDevelopmentGate(input).blockingStatuses,
      contains(sourceEvidenceInsufficientStopped),
    );
  });

  test('verified place facts plus fictional present-day action may proceed', () {
    final result = evaluateStoryDevelopmentGate(_validInput());
    expect(result.blockingStatuses, isEmpty);
    expect(result.semanticGate.isGoldReady, isTrue);
    expect(result.canLockStory, isTrue);
  });

  test('unsupported real-person action, intention, or dialogue is blocked', () {
    final input = _validInput(
      claims: const <StoryClaimRecord>[
        StoryClaimRecord(
          claimId: 'place-geometry',
          claim: 'Verified place property.',
          classification: StoryClaimClassification.verifiedFact,
          sourceIds: <String>['official-1'],
          materiallySupportsStoryMechanism: true,
        ),
        StoryClaimRecord(
          claimId: 'real-person-thought',
          claim: 'A real historical person privately intended a design effect.',
          classification: StoryClaimClassification.interpretiveStoryDevice,
          realHistoricalPersonClaim: true,
          realPersonActionIntentOrDialogue: true,
        ),
      ],
    );
    expect(
      evaluateStoryDevelopmentGate(input).blockingStatuses,
      contains(unverifiedFactualClaimBlocked),
    );
  });

  test('generic-place substitution failure is a blocking gate', () {
    final input = _validInput(
      place: const PlaceCausalMechanismRecord(
        verifiedPropertyClaimIds: <String>['place-geometry'],
        whyPropertyCreatesDramaticPossibility: 'The place is mentioned.',
        whyGenericSubstitutionFails: 'No material change has been demonstrated.',
        affectedCausalDimensions: <NarrativeSemanticDimension>{
          NarrativeSemanticDimension.conflictMechanism,
        },
        genericPlaceSubstitutionLeavesCausalChainIntact: true,
        humanSemanticSufficiencyReviewed: true,
      ),
    );
    final result = evaluateStoryDevelopmentGate(input);
    expect(result.canLockStory, isFalse);
    expect(result.blockingStatuses, contains(genericPlaceStoryNotGoldReady));
  });

  test('surface-disguised causal template still collides', () {
    final gold = approvedGoldSemanticFingerprints.values.first;
    final disguised = JourneySemanticFingerprint(
      journeyId: 'different-city-different-character',
      surfaceIdentity:
          'different city / different name / different profession / different object / different wording',
      mechanisms: gold.mechanisms,
      coreEvidence: const <NarrativeMechanismEvidence>[],
    );
    final result = evaluateStoryDevelopmentGate(
      _validInput(fingerprint: disguised),
    );
    expect(result.semanticGate.isGoldReady, isFalse);
    expect(result.blockingStatuses, contains(semanticTemplateCollisionNotGoldReady));
  });

  test('taxonomy laundering contract blocks a collision-escape near-synonym', () {
    final input = _validInput(
      taxonomy: const MechanismFamilyGovernanceRecord(
        introducesNewFamily: true,
        proposedFamilyName: 'candidateSpecificResponsibleRefusalVariant',
        nearestExistingFamiliesConsidered: <String>[
          'responsibleRefusalOfAvailableShortcut',
        ],
        whyNoExistingFamilyIsEquivalent: 'Different wording only.',
        causalStructuralDifference: 'No structural distinction.',
        reusableBeyondOneJourney: false,
        journeySpecificNaming: true,
        createdToAvoidCollision: true,
        humanReviewCompleted: true,
      ),
    );
    expect(
      evaluateStoryDevelopmentGate(input).blockingStatuses,
      contains(taxonomyLaunderingBlocked),
    );
  });

  test('atmospheric Lv1 cannot unlock Lv2-Lv10 expansion', () {
    final input = _validInput(
      lv1: const Lv1CausalProofRecord(
        hasProtagonist: true,
        hasConcreteGoal: false,
        hasConflict: false,
        hasEnactedChoice: false,
        hasDecisiveEvent: false,
        hasCausedConsequence: false,
        humanCausalSufficiencyReviewed: true,
      ),
    );
    final result = evaluateStoryDevelopmentGate(input);
    expect(result.canLockStory, isFalse);
    expect(result.blockingStatuses, contains(lv1CausalProofFailedDoNotExpand));
  });

  test('Fact First ordering blocks full Story drafting before pre-lock gates', () {
    final result = evaluateStoryDevelopmentGate(
      _validInput(draftedEarly: true),
    );
    expect(result.canLockStory, isFalse);
    expect(
      result.blockingStatuses,
      contains('FACT FIRST PIPELINE VIOLATION — STORY DEVELOPMENT BLOCKED'),
    );
  });

  test('existing eight-Gold semantic baseline remains 28 pairs with zero debt', () {
    expect(approvedGoldSemanticFingerprints.length, 8);
    final audit = auditApprovedGoldSemanticPairs();
    expect(audit.length, 28);
    expect(audit.where((comparison) => comparison.isCollision), isEmpty);
  });
}
