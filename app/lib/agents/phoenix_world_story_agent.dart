import '../models/geo_node.dart';

class PhoenixWorldStoryAgent {
  PhoenixWorldStoryAgent({Iterable<GeoNode> nodes = const []}) {
    registerAll(nodes);
  }

  final Map<String, GeoNode> _nodes = {};

  void register(GeoNode node) {
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

  GeoNode? find(String id) => _nodes[id];

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
}
