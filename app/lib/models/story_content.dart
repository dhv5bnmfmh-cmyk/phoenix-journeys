enum StorySourceKind {
  museum,
  government,
  unesco,
  academic,
  editorial,
}

enum StoryVerificationStatus {
  draft,
  reviewed,
  verified,
  published,
  rejected,
}

class StorySourceRecord {
  const StorySourceRecord({
    required this.id,
    required this.title,
    required this.publisher,
    required this.url,
    required this.kind,
    required this.languageCode,
    required this.geoNodeIds,
    required this.verificationStatus,
    this.accessedOn,
    this.notes,
  });

  final String id;
  final String title;
  final String publisher;
  final String url;
  final StorySourceKind kind;
  final String languageCode;
  final List<String> geoNodeIds;
  final StoryVerificationStatus verificationStatus;
  final String? accessedOn;
  final String? notes;

  bool get isVerified =>
      verificationStatus == StoryVerificationStatus.verified ||
      verificationStatus == StoryVerificationStatus.published;

  bool get isAuthoritative => switch (kind) {
        StorySourceKind.museum ||
        StorySourceKind.government ||
        StorySourceKind.unesco ||
        StorySourceKind.academic => true,
        StorySourceKind.editorial => false,
      };
}

class JourneyStorySection {
  const JourneyStorySection({
    required this.id,
    required this.text,
    required this.sourceIds,
  });

  final String id;
  final String text;
  final List<String> sourceIds;
}

class JourneyContentRecord {
  const JourneyContentRecord({
    required this.id,
    required this.title,
    required this.geoNodeId,
    required this.languageCode,
    required this.sections,
    required this.verificationStatus,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String geoNodeId;
  final String languageCode;
  final List<JourneyStorySection> sections;
  final StoryVerificationStatus verificationStatus;
  final List<String> tags;

  List<String> get storyParagraphs =>
      sections.map((section) => section.text).toList(growable: false);

  Set<String> get sourceIds => sections
      .expand((section) => section.sourceIds)
      .where((id) => id.trim().isNotEmpty)
      .toSet();
}
