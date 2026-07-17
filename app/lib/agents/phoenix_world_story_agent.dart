import '../models/geo_node.dart';
import '../models/story_content.dart';

class PhoenixWorldStoryAgent {
  PhoenixWorldStoryAgent({
    Iterable<GeoNode> nodes = const [],
    Iterable<StorySourceRecord> sources = const [],
    Iterable<JourneyContentRecord> journeys = const [],
  }) {
    registerAll(nodes);
    registerAllSources(sources);
    registerAllJourneys(journeys);
  }

  final Map<String, GeoNode> _nodes = {};
  final Map<String, StorySourceRecord> _sources = {};
  final Map<String, JourneyContentRecord> _journeys = {};

  void register(GeoNode node) {
    if (_nodes.containsKey(node.id)) {
      throw StateError('GeoNode already registered: ${node.id}');
    }
    if (node.parentId != null && !_nodes.containsKey(node.parentId)) {
      throw StateError('Parent GeoNode not registered: ${node.parentId}');
    }
    _nodes[node.id] = node;
  }

  void registerAll(Iterable<GeoNode> nodes) {
    for (final node in nodes) {
      register(node);
    }
  }

  void registerSource(StorySourceRecord source) {
    if (_sources.containsKey(source.id)) {
      throw StateError('Story source already registered: ${source.id}');
    }
    if (source.geoNodeIds.isEmpty) {
      throw StateError('Story source has no GeoNode: ${source.id}');
    }
    for (final geoNodeId in source.geoNodeIds) {
      if (!_nodes.containsKey(geoNodeId)) {
        throw StateError(
          'Story source ${source.id} references unknown GeoNode: $geoNodeId',
        );
      }
    }
    final uri = Uri.tryParse(source.url);
    if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
      throw StateError('Story source has an invalid URL: ${source.id}');
    }
    _sources[source.id] = source;
  }

  void registerAllSources(Iterable<StorySourceRecord> sources) {
    for (final source in sources) {
      registerSource(source);
    }
  }

  void registerJourney(JourneyContentRecord journey) {
    if (_journeys.containsKey(journey.id)) {
      throw StateError('Journey already registered: ${journey.id}');
    }
    if (!_nodes.containsKey(journey.geoNodeId)) {
      throw StateError(
        'Journey ${journey.id} references unknown GeoNode: ${journey.geoNodeId}',
      );
    }

    final sectionIds = <String>{};
    for (final section in journey.sections) {
      if (!sectionIds.add(section.id)) {
        throw StateError(
          'Journey ${journey.id} has duplicate section: ${section.id}',
        );
      }
      for (final sourceId in section.sourceIds) {
        if (!_sources.containsKey(sourceId)) {
          throw StateError(
            'Journey ${journey.id} references unknown source: $sourceId',
          );
        }
      }
    }

    _journeys[journey.id] = journey;
  }

  void registerAllJourneys(Iterable<JourneyContentRecord> journeys) {
    for (final journey in journeys) {
      registerJourney(journey);
    }
  }

  GeoNode? find(String id) => _nodes[id];

  StorySourceRecord? findSource(String id) => _sources[id];

  JourneyContentRecord? findJourney(String id) => _journeys[id];

  List<GeoNode> childrenOf(String parentId) => _nodes.values
      .where((node) => node.parentId == parentId)
      .toList(growable: false);

  List<GeoNode> pathTo(String id) {
    final path = <GeoNode>[];
    var current = _nodes[id];
    final visited = <String>{};

    while (current != null) {
      if (!visited.add(current.id)) {
        throw StateError('Circular GeoNode hierarchy detected at ${current.id}');
      }
      path.add(current);
      current = current.parentId == null ? null : _nodes[current.parentId];
    }

    return path.reversed.toList(growable: false);
  }

  List<GeoNode> search(String query) {
    final keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) return const [];

    return _nodes.values.where((node) {
      return node.name.toLowerCase().contains(keyword) ||
          node.localType.toLowerCase().contains(keyword) ||
          node.aliases.any((alias) => alias.toLowerCase().contains(keyword));
    }).toList(growable: false);
  }

  List<JourneyContentRecord> journeysForGeo(
    String geoNodeId, {
    bool includeDescendants = false,
  }) {
    if (!_nodes.containsKey(geoNodeId)) return const [];

    return _journeys.values.where((journey) {
      if (journey.geoNodeId == geoNodeId) return true;
      if (!includeDescendants) return false;
      return pathTo(journey.geoNodeId).any((node) => node.id == geoNodeId);
    }).toList(growable: false);
  }

  List<StorySourceRecord> sourcesForJourney(String journeyId) {
    final journey = _journeys[journeyId];
    if (journey == null) return const [];
    return journey.sourceIds
        .map((id) => _sources[id])
        .whereType<StorySourceRecord>()
        .toList(growable: false);
  }

  List<StorySourceRecord> evidenceForSection(
    String journeyId,
    String sectionId,
  ) {
    final journey = _journeys[journeyId];
    if (journey == null) return const [];

    final matches = journey.sections.where((item) => item.id == sectionId);
    if (matches.isEmpty) return const [];
    return matches.first.sourceIds
        .map((id) => _sources[id])
        .whereType<StorySourceRecord>()
        .toList(growable: false);
  }

  List<String> publicationIssues(String journeyId) {
    final journey = _journeys[journeyId];
    if (journey == null) return const ['Journey 尚未登记'];

    final issues = <String>[];
    if (journey.sections.isEmpty) issues.add('故事没有内容段落');
    if (journey.verificationStatus != StoryVerificationStatus.verified &&
        journey.verificationStatus != StoryVerificationStatus.published) {
      issues.add('故事尚未完成审核');
    }

    final sources = sourcesForJourney(journeyId);
    final authoritativePublishers = sources
        .where((source) => source.isAuthoritative)
        .map((source) => source.publisher)
        .toSet();
    if (authoritativePublishers.length < 2) {
      issues.add('故事至少需要两个独立权威来源');
    }

    final locationPathIds =
        pathTo(journey.geoNodeId).map((node) => node.id).toSet();
    for (final section in journey.sections) {
      if (section.text.trim().isEmpty) {
        issues.add('${section.id} 没有故事文字');
      }
      if (section.sourceIds.isEmpty) {
        issues.add('${section.id} 没有来源证据');
      }
    }

    for (final source in sources) {
      if (!source.isVerified) issues.add('${source.id} 尚未验证');
      final isLocationConnected =
          source.geoNodeIds.any(locationPathIds.contains);
      if (!isLocationConnected) {
        issues.add('${source.id} 与 Journey 地点没有关联');
      }
    }

    return issues;
  }

  bool isJourneyPublishable(String journeyId) =>
      publicationIssues(journeyId).isEmpty;
}
