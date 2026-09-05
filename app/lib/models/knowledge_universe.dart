enum KnowledgeAuthorityType {
  government,
  museum,
  unesco,
  academic,
  institutional,
}

enum KnowledgeStatus { verified, inference, interpretation, draft }

enum PlaceNodeType { country, city, site, gate, area, spatialFeature }

class KnowledgeSource {
  const KnowledgeSource({
    required this.sourceRef,
    required this.label,
    required this.publisher,
    required this.url,
    required this.authorityType,
    this.accessedOn,
    this.metadata = const <String, String>{},
  });

  final String sourceRef;
  final String label;
  final String publisher;
  final String url;
  final KnowledgeAuthorityType authorityType;
  final DateTime? accessedOn;
  final Map<String, String> metadata;
}

class PlaceNode {
  const PlaceNode({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.type,
    this.parentId,
    this.location,
    this.aliases = const <String>[],
    this.periodRefs = const <String>[],
    this.sourceRefs = const <String>[],
  });

  final String id;
  final String nameZh;
  final String nameEn;
  final PlaceNodeType type;
  final String? parentId;
  final String? location;
  final List<String> aliases;
  final List<String> periodRefs;
  final List<String> sourceRefs;
}

class HistoricalPeriod {
  const HistoricalPeriod({
    required this.id,
    required this.name,
    required this.description,
    this.startYear,
    this.endYear,
    this.chronologyNote,
    this.sourceRefs = const <String>[],
  });

  final String id;
  final String name;
  final String description;
  final int? startYear;
  final int? endYear;
  final String? chronologyNote;
  final List<String> sourceRefs;
}

class PersonRole {
  const PersonRole({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.role,
    required this.socialContext,
    this.periodRefs = const <String>[],
    this.placeRefs = const <String>[],
    this.professionRefs = const <String>[],
  });

  final String id;
  final String nameZh;
  final String nameEn;
  final String role;
  final String socialContext;
  final List<String> periodRefs;
  final List<String> placeRefs;
  final List<String> professionRefs;
}

class Profession {
  const Profession({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.industry,
    this.sourceRefs = const <String>[],
  });

  final String id;
  final String nameZh;
  final String nameEn;
  final String industry;
  final List<String> sourceRefs;
}

class CultureTopic {
  const CultureTopic({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.type,
    this.sourceRefs = const <String>[],
  });

  final String id;
  final String nameZh;
  final String nameEn;
  final String type;
  final List<String> sourceRefs;
}

class EventPractice {
  const EventPractice({
    required this.id,
    required this.nameZh,
    required this.nameEn,
    required this.type,
    this.placeRefs = const <String>[],
    this.periodRefs = const <String>[],
    this.sourceRefs = const <String>[],
  });

  final String id;
  final String nameZh;
  final String nameEn;
  final String type;
  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<String> sourceRefs;
}

class KnowledgeUnit {
  const KnowledgeUnit({
    required this.id,
    required this.claim,
    required this.simpleChinese,
    required this.status,
    this.placeRefs = const <String>[],
    this.periodRefs = const <String>[],
    this.personRoleRefs = const <String>[],
    this.professionRefs = const <String>[],
    this.cultureRefs = const <String>[],
    this.eventRefs = const <String>[],
    this.sourceRefs = const <String>[],
    this.tags = const <String>[],
  });

  final String id;
  final String claim;
  final String simpleChinese;
  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<String> personRoleRefs;
  final List<String> professionRefs;
  final List<String> cultureRefs;
  final List<String> eventRefs;
  final List<String> sourceRefs;
  final List<String> tags;
  final KnowledgeStatus status;
}

class KnowledgeRelation {
  const KnowledgeRelation({
    required this.fromId,
    required this.type,
    required this.toId,
    this.sourceRefs = const <String>[],
  });

  final String fromId;
  final String type;
  final String toId;
  final List<String> sourceRefs;
}

abstract final class KnowledgeRelationTypes {
  static const locatedIn = 'LOCATED_IN';
  static const alignedWith = 'ALIGNED_WITH';
  static const connects = 'CONNECTS';
  static const worksIn = 'WORKS_IN';
  static const associatedWith = 'ASSOCIATED_WITH';
}

class StorySeed {
  const StorySeed({
    required this.id,
    required this.placeRef,
    required this.characterRoleRef,
    required this.goal,
    required this.conflict,
    required this.knowledgeUnitRefs,
    required this.languageLevel,
    required this.learningFocus,
    this.periodRef,
    this.professionRef,
  });

  final String id;
  final String placeRef;
  final String? periodRef;
  final String characterRoleRef;
  final String? professionRef;
  final String goal;
  final String conflict;
  final List<String> knowledgeUnitRefs;
  final int languageLevel;
  final List<String> learningFocus;
}

class KnowledgeQuery {
  const KnowledgeQuery({
    this.placeRefs = const <String>[],
    this.periodRefs = const <String>[],
    this.personRoleRefs = const <String>[],
    this.professionRefs = const <String>[],
    this.cultureRefs = const <String>[],
    this.eventRefs = const <String>[],
    this.tags = const <String>[],
    this.statuses = const <KnowledgeStatus>[],
  });

  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<String> personRoleRefs;
  final List<String> professionRefs;
  final List<String> cultureRefs;
  final List<String> eventRefs;
  final List<String> tags;
  final List<KnowledgeStatus> statuses;
}

class KnowledgeUniverseRepository {
  KnowledgeUniverseRepository({
    required List<KnowledgeSource> sources,
    required List<PlaceNode> places,
    required List<HistoricalPeriod> periods,
    required List<PersonRole> personRoles,
    required List<Profession> professions,
    required List<CultureTopic> cultureTopics,
    required List<EventPractice> events,
    required List<KnowledgeUnit> knowledgeUnits,
    required List<KnowledgeRelation> relations,
    required List<StorySeed> storySeeds,
  })  : sources = List<KnowledgeSource>.unmodifiable(sources),
        places = List<PlaceNode>.unmodifiable(places),
        periods = List<HistoricalPeriod>.unmodifiable(periods),
        personRoles = List<PersonRole>.unmodifiable(personRoles),
        professions = List<Profession>.unmodifiable(professions),
        cultureTopics = List<CultureTopic>.unmodifiable(cultureTopics),
        events = List<EventPractice>.unmodifiable(events),
        knowledgeUnits = List<KnowledgeUnit>.unmodifiable(knowledgeUnits),
        relations = List<KnowledgeRelation>.unmodifiable(relations),
        storySeeds = List<StorySeed>.unmodifiable(storySeeds) {
    _validate();
  }

  final List<KnowledgeSource> sources;
  final List<PlaceNode> places;
  final List<HistoricalPeriod> periods;
  final List<PersonRole> personRoles;
  final List<Profession> professions;
  final List<CultureTopic> cultureTopics;
  final List<EventPractice> events;
  final List<KnowledgeUnit> knowledgeUnits;
  final List<KnowledgeRelation> relations;
  final List<StorySeed> storySeeds;

  Map<String, KnowledgeSource> get sourceByRef =>
      <String, KnowledgeSource>{for (final source in sources) source.sourceRef: source};

  Map<String, PlaceNode> get placeById =>
      <String, PlaceNode>{for (final place in places) place.id: place};

  Map<String, HistoricalPeriod> get periodById =>
      <String, HistoricalPeriod>{for (final period in periods) period.id: period};

  Map<String, PersonRole> get personRoleById =>
      <String, PersonRole>{for (final role in personRoles) role.id: role};

  Map<String, Profession> get professionById =>
      <String, Profession>{for (final profession in professions) profession.id: profession};

  Map<String, CultureTopic> get cultureTopicById =>
      <String, CultureTopic>{for (final topic in cultureTopics) topic.id: topic};

  Map<String, EventPractice> get eventById =>
      <String, EventPractice>{for (final event in events) event.id: event};

  Map<String, KnowledgeUnit> get knowledgeById =>
      <String, KnowledgeUnit>{for (final unit in knowledgeUnits) unit.id: unit};

  List<KnowledgeUnit> query(KnowledgeQuery query) {
    final matches = knowledgeUnits.where((unit) {
      return _containsAll(unit.placeRefs, query.placeRefs) &&
          _containsAll(unit.periodRefs, query.periodRefs) &&
          _containsAll(unit.personRoleRefs, query.personRoleRefs) &&
          _containsAll(unit.professionRefs, query.professionRefs) &&
          _containsAll(unit.cultureRefs, query.cultureRefs) &&
          _containsAll(unit.eventRefs, query.eventRefs) &&
          _containsAll(unit.tags, query.tags) &&
          (query.statuses.isEmpty || query.statuses.contains(unit.status));
    }).toList(growable: false)
      ..sort((a, b) => a.id.compareTo(b.id));
    return List<KnowledgeUnit>.unmodifiable(matches);
  }

  static bool _containsAll(List<String> actual, List<String> expected) {
    for (final value in expected) {
      if (!actual.contains(value)) return false;
    }
    return true;
  }

  void _validate() {
    _requireUnique('sourceRef', sources.map((source) => source.sourceRef));
    _requireUnique('place', places.map((place) => place.id));
    _requireUnique('period', periods.map((period) => period.id));
    _requireUnique('personRole', personRoles.map((role) => role.id));
    _requireUnique('profession', professions.map((profession) => profession.id));
    _requireUnique('cultureTopic', cultureTopics.map((topic) => topic.id));
    _requireUnique('event', events.map((event) => event.id));
    _requireUnique('knowledgeUnit', knowledgeUnits.map((unit) => unit.id));
    _requireUnique('storySeed', storySeeds.map((seed) => seed.id));

    final sourceRefs = sourceByRef.keys.toSet();
    final placeIds = placeById.keys.toSet();
    final periodIds = periodById.keys.toSet();
    final roleIds = personRoleById.keys.toSet();
    final professionIds = professionById.keys.toSet();
    final cultureIds = cultureTopicById.keys.toSet();
    final eventIds = eventById.keys.toSet();
    final knowledgeIds = knowledgeById.keys.toSet();

    for (final source in sources) {
      if (source.sourceRef.trim().isEmpty ||
          source.label.trim().isEmpty ||
          source.publisher.trim().isEmpty ||
          source.url.trim().isEmpty) {
        throw ArgumentError('Source metadata must be non-empty: ${source.sourceRef}');
      }
      final uri = Uri.tryParse(source.url);
      if (uri == null || !uri.hasScheme) {
        throw ArgumentError('Source URL must be absolute: ${source.sourceRef}');
      }
    }

    for (final place in places) {
      _validateSourceRefs(place.sourceRefs, sourceRefs, place.id);
      _validateRefs(place.periodRefs, periodIds, 'period', place.id);
      if (place.parentId != null) {
        if (place.parentId == place.id || !placeIds.contains(place.parentId)) {
          throw ArgumentError('Invalid place parent for ${place.id}: ${place.parentId}');
        }
      }
    }
    _validatePlaceCycles();

    for (final period in periods) {
      _validateSourceRefs(period.sourceRefs, sourceRefs, period.id);
      if (period.startYear != null &&
          period.endYear != null &&
          period.startYear! > period.endYear!) {
        throw ArgumentError('Invalid period range: ${period.id}');
      }
    }

    for (final role in personRoles) {
      _validateRefs(role.periodRefs, periodIds, 'period', role.id);
      _validateRefs(role.placeRefs, placeIds, 'place', role.id);
      _validateRefs(role.professionRefs, professionIds, 'profession', role.id);
    }

    for (final profession in professions) {
      _validateSourceRefs(profession.sourceRefs, sourceRefs, profession.id);
    }

    for (final topic in cultureTopics) {
      _validateSourceRefs(topic.sourceRefs, sourceRefs, topic.id);
    }

    for (final event in events) {
      _validateRefs(event.placeRefs, placeIds, 'place', event.id);
      _validateRefs(event.periodRefs, periodIds, 'period', event.id);
      _validateSourceRefs(event.sourceRefs, sourceRefs, event.id);
    }

    for (final unit in knowledgeUnits) {
      if (unit.claim.trim().isEmpty || unit.simpleChinese.trim().isEmpty) {
        throw ArgumentError('KnowledgeUnit text must be non-empty: ${unit.id}');
      }
      if (unit.status == KnowledgeStatus.verified && unit.sourceRefs.isEmpty) {
        throw ArgumentError('Verified KnowledgeUnit requires source: ${unit.id}');
      }
      _validateRefs(unit.placeRefs, placeIds, 'place', unit.id);
      _validateRefs(unit.periodRefs, periodIds, 'period', unit.id);
      _validateRefs(unit.personRoleRefs, roleIds, 'personRole', unit.id);
      _validateRefs(unit.professionRefs, professionIds, 'profession', unit.id);
      _validateRefs(unit.cultureRefs, cultureIds, 'culture', unit.id);
      _validateRefs(unit.eventRefs, eventIds, 'event', unit.id);
      _validateSourceRefs(unit.sourceRefs, sourceRefs, unit.id);
    }

    final graphIdList = <String>[
      ...placeIds,
      ...periodIds,
      ...roleIds,
      ...professionIds,
      ...cultureIds,
      ...eventIds,
      ...knowledgeIds,
    ];
    _requireUnique('graph entity', graphIdList);
    final graphIds = graphIdList.toSet();

    for (final relation in relations) {
      if (!graphIds.contains(relation.fromId) || !graphIds.contains(relation.toId)) {
        throw ArgumentError(
          'Relation endpoint missing: ${relation.fromId} ${relation.type} ${relation.toId}',
        );
      }
      if (relation.type.trim().isEmpty) {
        throw ArgumentError('Relation type must be non-empty');
      }
      _validateSourceRefs(
        relation.sourceRefs,
        sourceRefs,
        '${relation.fromId}:${relation.type}:${relation.toId}',
      );
    }

    for (final seed in storySeeds) {
      if (!placeIds.contains(seed.placeRef)) {
        throw ArgumentError('StorySeed place missing: ${seed.id}');
      }
      if (seed.periodRef != null && !periodIds.contains(seed.periodRef)) {
        throw ArgumentError('StorySeed period missing: ${seed.id}');
      }
      if (!roleIds.contains(seed.characterRoleRef)) {
        throw ArgumentError('StorySeed role missing: ${seed.id}');
      }
      if (seed.professionRef != null &&
          !professionIds.contains(seed.professionRef)) {
        throw ArgumentError('StorySeed profession missing: ${seed.id}');
      }
      if (seed.knowledgeUnitRefs.isEmpty) {
        throw ArgumentError('StorySeed requires KnowledgeUnit refs: ${seed.id}');
      }
      _validateRefs(seed.knowledgeUnitRefs, knowledgeIds, 'knowledgeUnit', seed.id);
      if (seed.languageLevel < 1 || seed.languageLevel > 10) {
        throw ArgumentError('StorySeed languageLevel must be Lv1-Lv10: ${seed.id}');
      }
    }
  }

  void _validatePlaceCycles() {
    final placesById = placeById;
    for (final place in places) {
      final seen = <String>{};
      var current = place;
      while (current.parentId != null) {
        if (!seen.add(current.id)) {
          throw ArgumentError('Place parent cycle detected: ${place.id}');
        }
        current = placesById[current.parentId]!;
      }
    }
  }

  static void _validateSourceRefs(
    Iterable<String> refs,
    Set<String> known,
    String owner,
  ) {
    _validateRefs(refs, known, 'sourceRef', owner);
  }

  static void _validateRefs(
    Iterable<String> refs,
    Set<String> known,
    String kind,
    String owner,
  ) {
    for (final ref in refs) {
      if (!known.contains(ref)) {
        throw ArgumentError('Invalid $kind "$ref" on $owner');
      }
    }
  }

  static void _requireUnique(String kind, Iterable<String> ids) {
    final seen = <String>{};
    for (final id in ids) {
      if (id.trim().isEmpty || !seen.add(id)) {
        throw ArgumentError('Invalid or duplicate $kind: $id');
      }
    }
  }
}
