class JourneyMemoryEntry {
  const JourneyMemoryEntry({
    required this.id,
    required this.journeyId,
    required this.city,
    required this.place,
    required this.journeyTitle,
    required this.sessionLevel,
    required this.initialNote,
    required this.initialCreatedAt,
    required this.updatedNote,
    required this.updatedAt,
    required this.isVisited,
    required this.photoRefs,
    this.visitedAt,
    this.visitNote = '',
    this.legacy = false,
  });

  final String id;
  final String journeyId;
  final String city;
  final String place;
  final String journeyTitle;
  final int sessionLevel;
  final String initialNote;
  final DateTime initialCreatedAt;
  final String updatedNote;
  final DateTime updatedAt;
  final bool isVisited;
  final DateTime? visitedAt;
  final String visitNote;
  final List<String> photoRefs;
  final bool legacy;

  String get note => updatedNote.isEmpty ? initialNote : updatedNote;

  JourneyMemoryEntry copyWith({
    String? initialNote,
    String? updatedNote,
    DateTime? updatedAt,
    bool? isVisited,
    DateTime? visitedAt,
    bool clearVisitedAt = false,
    String? visitNote,
    List<String>? photoRefs,
  }) => JourneyMemoryEntry(
        id: id,
        journeyId: journeyId,
        city: city,
        place: place,
        journeyTitle: journeyTitle,
        sessionLevel: sessionLevel,
        initialNote: initialNote ?? this.initialNote,
        initialCreatedAt: initialCreatedAt,
        updatedNote: updatedNote ?? this.updatedNote,
        updatedAt: updatedAt ?? this.updatedAt,
        isVisited: isVisited ?? this.isVisited,
        visitedAt: clearVisitedAt ? null : (visitedAt ?? this.visitedAt),
        visitNote: visitNote ?? this.visitNote,
        photoRefs: List.unmodifiable(photoRefs ?? this.photoRefs),
        legacy: legacy,
      );

  Map<String, Object?> toJson() => {
        'id': id, 'journeyId': journeyId, 'city': city, 'place': place,
        'journeyTitle': journeyTitle, 'sessionLevel': sessionLevel,
        'initialNote': initialNote,
        'initialCreatedAt': initialCreatedAt.toIso8601String(),
        'updatedNote': updatedNote, 'updatedAt': updatedAt.toIso8601String(),
        'isVisited': isVisited, 'visitedAt': visitedAt?.toIso8601String(),
        'visitNote': visitNote, 'photoRefs': photoRefs, 'legacy': legacy,
      };

  factory JourneyMemoryEntry.fromJson(Map<String, dynamic> json) => JourneyMemoryEntry(
        id: json['id'] as String,
        journeyId: json['journeyId'] as String,
        city: json['city'] as String? ?? '',
        place: json['place'] as String? ?? '',
        journeyTitle: json['journeyTitle'] as String? ?? '',
        sessionLevel: json['sessionLevel'] as int? ?? 1,
        initialNote: json['initialNote'] as String? ?? '',
        initialCreatedAt: DateTime.parse(json['initialCreatedAt'] as String),
        updatedNote: json['updatedNote'] as String? ?? '',
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        isVisited: json['isVisited'] as bool? ?? false,
        visitedAt: json['visitedAt'] == null ? null : DateTime.parse(json['visitedAt'] as String),
        visitNote: json['visitNote'] as String? ?? '',
        photoRefs: List<String>.from(json['photoRefs'] as List? ?? const []),
        legacy: json['legacy'] as bool? ?? false,
      );
}
