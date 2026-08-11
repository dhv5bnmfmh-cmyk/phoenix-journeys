import 'journey_semantic_fingerprint_catalog.dart';

const String sourceEvidenceInsufficientStopped =
    'SOURCE EVIDENCE INSUFFICIENT — STORY DEVELOPMENT STOPPED';
const String unverifiedFactualClaimBlocked =
    'UNVERIFIED FACTUAL CLAIM — BLOCKED';
const String genericPlaceStoryNotGoldReady =
    'GENERIC-PLACE STORY — NOT GOLD READY';
const String lv1CausalProofFailedDoNotExpand =
    'LV1 CAUSAL PROOF FAILED — DO NOT EXPAND';
const String taxonomyLaunderingBlocked =
    'NARRATIVE MECHANISM TAXONOMY LAUNDERING — BLOCKED';

/// Approved factual-evidence hierarchy for Story architecture.
enum StorySourceAuthority {
  internationalHeritageAuthority,
  government,
  officialHeritageMuseumAuthority,
  officialCulturalInstitution,
  academicInstitution,
  nonAuthoritative,
}

extension StorySourceAuthorityPolicy on StorySourceAuthority {
  bool get isApprovedForBindingFact =>
      this != StorySourceAuthority.nonAuthoritative;
}

enum StoryClaimClassification {
  verifiedFact,
  fictionalCharacterAction,
  fictionalDialogue,
  fictionalPersonalMotivation,
  interpretiveStoryDevice,
  unsupportedFactualClaim,
}

class StorySourceRecord {
  const StorySourceRecord({
    required this.sourceId,
    required this.authority,
    required this.citation,
  });

  final String sourceId;
  final StorySourceAuthority authority;
  final String citation;
}

class StoryClaimRecord {
  const StoryClaimRecord({
    required this.claimId,
    required this.claim,
    required this.classification,
    this.sourceIds = const <String>[],
    this.materiallySupportsStoryMechanism = false,
    this.realHistoricalPersonClaim = false,
    this.realPersonActionIntentOrDialogue = false,
  });

  final String claimId;
  final String claim;
  final StoryClaimClassification classification;
  final List<String> sourceIds;
  final bool materiallySupportsStoryMechanism;
  final bool realHistoricalPersonClaim;
  final bool realPersonActionIntentOrDialogue;
}

class PlaceCausalMechanismRecord {
  const PlaceCausalMechanismRecord({
    required this.verifiedPropertyClaimIds,
    required this.whyPropertyCreatesDramaticPossibility,
    required this.whyGenericSubstitutionFails,
    required this.affectedCausalDimensions,
    required this.genericPlaceSubstitutionLeavesCausalChainIntact,
    required this.humanSemanticSufficiencyReviewed,
  });

  final List<String> verifiedPropertyClaimIds;
  final String whyPropertyCreatesDramaticPossibility;
  final String whyGenericSubstitutionFails;
  final Set<NarrativeSemanticDimension> affectedCausalDimensions;

  /// This is an auditable human/Agent classification consumed by CI. CI does
  /// not infer it from arbitrary Story prose.
  final bool genericPlaceSubstitutionLeavesCausalChainIntact;
  final bool humanSemanticSufficiencyReviewed;
}

class StoryMechanismArchitecture {
  const StoryMechanismArchitecture({
    required this.protagonist,
    required this.relationshipGeometry,
    required this.goal,
    required this.conflict,
    required this.choice,
    required this.climax,
    required this.consequence,
    required this.transformation,
    required this.ending,
    required this.culturalAnchorFunction,
    required this.dramaticEngine,
  });

  final String protagonist;
  final String relationshipGeometry;
  final String goal;
  final String conflict;
  final String choice;
  final String climax;
  final String consequence;
  final String transformation;
  final String ending;
  final String culturalAnchorFunction;
  final String dramaticEngine;

  Iterable<String> get requiredValues => <String>[
        protagonist,
        relationshipGeometry,
        goal,
        conflict,
        choice,
        climax,
        consequence,
        transformation,
        ending,
        culturalAnchorFunction,
        dramaticEngine,
      ];
}

class Lv1CausalProofRecord {
  const Lv1CausalProofRecord({
    required this.hasProtagonist,
    required this.hasConcreteGoal,
    required this.hasConflict,
    required this.hasEnactedChoice,
    required this.hasDecisiveEvent,
    required this.hasCausedConsequence,
    required this.humanCausalSufficiencyReviewed,
  });

  final bool hasProtagonist;
  final bool hasConcreteGoal;
  final bool hasConflict;
  final bool hasEnactedChoice;
  final bool hasDecisiveEvent;
  final bool hasCausedConsequence;
  final bool humanCausalSufficiencyReviewed;

  bool get structurallyComplete =>
      hasProtagonist &&
      hasConcreteGoal &&
      hasConflict &&
      hasEnactedChoice &&
      hasDecisiveEvent &&
      hasCausedConsequence;
}

class MechanismFamilyGovernanceRecord {
  const MechanismFamilyGovernanceRecord({
    required this.introducesNewFamily,
    this.proposedFamilyName = '',
    this.nearestExistingFamiliesConsidered = const <String>[],
    this.whyNoExistingFamilyIsEquivalent = '',
    this.causalStructuralDifference = '',
    this.reusableBeyondOneJourney = true,
    this.journeySpecificNaming = false,
    this.createdToAvoidCollision = false,
    this.humanReviewCompleted = true,
  });

  final bool introducesNewFamily;
  final String proposedFamilyName;
  final List<String> nearestExistingFamiliesConsidered;
  final String whyNoExistingFamilyIsEquivalent;
  final String causalStructuralDifference;
  final bool reusableBeyondOneJourney;
  final bool journeySpecificNaming;
  final bool createdToAvoidCollision;
  final bool humanReviewCompleted;
}

class StoryDevelopmentGateInput {
  const StoryDevelopmentGateInput({
    required this.journeyId,
    required this.sources,
    required this.claims,
    required this.placeCausality,
    required this.storyMechanism,
    required this.candidateFingerprint,
    required this.taxonomyGovernance,
    required this.lv1CausalProof,
    this.fullStoryDraftedBeforePreLockGates = false,
    this.lv2ToLv10ExpansionRequested = false,
  });

  final String journeyId;
  final List<StorySourceRecord> sources;
  final List<StoryClaimRecord> claims;
  final PlaceCausalMechanismRecord placeCausality;
  final StoryMechanismArchitecture storyMechanism;
  final JourneySemanticFingerprint candidateFingerprint;
  final MechanismFamilyGovernanceRecord taxonomyGovernance;
  final Lv1CausalProofRecord lv1CausalProof;
  final bool fullStoryDraftedBeforePreLockGates;
  final bool lv2ToLv10ExpansionRequested;
}

class StoryDevelopmentGateResult {
  const StoryDevelopmentGateResult({
    required this.blockingStatuses,
    required this.semanticGate,
  });

  final List<String> blockingStatuses;
  final FutureGoldSemanticGateResult semanticGate;

  bool get canLockStory => blockingStatuses.isEmpty && semanticGate.isGoldReady;
  String get status => canLockStory ? 'STORY LOCKED' : blockingStatuses.first;
}

List<String> sourceTruthContractErrors(StoryDevelopmentGateInput input) {
  final errors = <String>[];
  final sourcesById = <String, StorySourceRecord>{
    for (final source in input.sources) source.sourceId: source,
  };

  for (final source in input.sources) {
    if (source.sourceId.trim().isEmpty || source.citation.trim().isEmpty) {
      errors.add(sourceEvidenceInsufficientStopped);
    }
  }

  for (final claim in input.claims) {
    if (claim.claimId.trim().isEmpty || claim.claim.trim().isEmpty) {
      errors.add(unverifiedFactualClaimBlocked);
      continue;
    }
    if (claim.classification == StoryClaimClassification.unsupportedFactualClaim) {
      errors.add(unverifiedFactualClaimBlocked);
      continue;
    }
    if (claim.classification == StoryClaimClassification.verifiedFact) {
      if (claim.sourceIds.isEmpty) {
        errors.add(sourceEvidenceInsufficientStopped);
        continue;
      }
      for (final sourceId in claim.sourceIds) {
        final source = sourcesById[sourceId];
        if (source == null || !source.authority.isApprovedForBindingFact) {
          errors.add(sourceEvidenceInsufficientStopped);
        }
      }
    }
    if (claim.materiallySupportsStoryMechanism &&
        claim.classification == StoryClaimClassification.verifiedFact &&
        claim.sourceIds.isEmpty) {
      errors.add(sourceEvidenceInsufficientStopped);
    }
    if (claim.realHistoricalPersonClaim &&
        claim.realPersonActionIntentOrDialogue &&
        claim.classification != StoryClaimClassification.verifiedFact) {
      errors.add(unverifiedFactualClaimBlocked);
    }
  }

  return List<String>.unmodifiable(errors.toSet());
}

List<String> placeCausalityContractErrors(StoryDevelopmentGateInput input) {
  final errors = <String>[];
  final verifiedClaimIds = input.claims
      .where((claim) => claim.classification == StoryClaimClassification.verifiedFact)
      .map((claim) => claim.claimId)
      .toSet();
  final place = input.placeCausality;

  if (place.verifiedPropertyClaimIds.isEmpty ||
      place.verifiedPropertyClaimIds.any((id) => !verifiedClaimIds.contains(id))) {
    errors.add(sourceEvidenceInsufficientStopped);
  }
  if (place.whyPropertyCreatesDramaticPossibility.trim().isEmpty ||
      place.whyGenericSubstitutionFails.trim().isEmpty ||
      place.affectedCausalDimensions.isEmpty ||
      !place.humanSemanticSufficiencyReviewed) {
    errors.add(genericPlaceStoryNotGoldReady);
  }
  if (place.genericPlaceSubstitutionLeavesCausalChainIntact) {
    errors.add(genericPlaceStoryNotGoldReady);
  }
  return List<String>.unmodifiable(errors.toSet());
}

List<String> storyMechanismContractErrors(StoryDevelopmentGateInput input) {
  if (input.storyMechanism.requiredValues.any((value) => value.trim().isEmpty)) {
    return const <String>['STORY MECHANISM INCOMPLETE — NOT GOLD READY'];
  }
  return const <String>[];
}

List<String> taxonomyGovernanceContractErrors(StoryDevelopmentGateInput input) {
  final record = input.taxonomyGovernance;
  if (!record.introducesNewFamily) return const <String>[];
  final incomplete = record.proposedFamilyName.trim().isEmpty ||
      record.nearestExistingFamiliesConsidered.isEmpty ||
      record.whyNoExistingFamilyIsEquivalent.trim().isEmpty ||
      record.causalStructuralDifference.trim().isEmpty ||
      !record.reusableBeyondOneJourney ||
      !record.humanReviewCompleted;
  if (incomplete || record.journeySpecificNaming || record.createdToAvoidCollision) {
    return const <String>[taxonomyLaunderingBlocked];
  }
  return const <String>[];
}

List<String> lv1CausalProofContractErrors(StoryDevelopmentGateInput input) {
  final proof = input.lv1CausalProof;
  if (!proof.structurallyComplete || !proof.humanCausalSufficiencyReviewed) {
    return const <String>[lv1CausalProofFailedDoNotExpand];
  }
  return const <String>[];
}

StoryDevelopmentGateResult evaluateStoryDevelopmentGate(
  StoryDevelopmentGateInput input,
) {
  final semanticGate = evaluateFutureGoldSemanticCandidate(input.candidateFingerprint);
  final blockers = <String>[
    if (input.fullStoryDraftedBeforePreLockGates)
      'FACT FIRST PIPELINE VIOLATION — STORY DEVELOPMENT BLOCKED',
    ...sourceTruthContractErrors(input),
    ...placeCausalityContractErrors(input),
    ...storyMechanismContractErrors(input),
    ...taxonomyGovernanceContractErrors(input),
    if (!semanticGate.isGoldReady) semanticTemplateCollisionNotGoldReady,
    ...lv1CausalProofContractErrors(input),
  ];
  if (input.lv2ToLv10ExpansionRequested &&
      lv1CausalProofContractErrors(input).isNotEmpty) {
    blockers.add(lv1CausalProofFailedDoNotExpand);
  }
  return StoryDevelopmentGateResult(
    blockingStatuses: List<String>.unmodifiable(blockers.toSet()),
    semanticGate: semanticGate,
  );
}
