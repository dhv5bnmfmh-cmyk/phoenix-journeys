import '../models/geo_node.dart';
import 'world_geo_catalog_base.dart' as base;

/// Canonical world registry with continent ancestry.
/// China is formally registered under Asia; all existing descendants retain
/// their stable IDs and parent relationships below the country node.
final worldGeoCatalog = <GeoNode>[
  base.worldGeoCatalog.first,
  const GeoNode(
    id: 'asia',
    name: '亚洲',
    kind: GeoNodeKind.continent,
    localType: '洲',
    parentId: 'world',
    aliases: ['Asia'],
  ),
  for (final node in base.worldGeoCatalog.skip(1))
    if (node.id == 'cn')
      GeoNode(
        id: node.id,
        name: node.name,
        kind: node.kind,
        localType: node.localType,
        parentId: 'asia',
        countryCode: node.countryCode,
        latitude: node.latitude,
        longitude: node.longitude,
        aliases: node.aliases,
      )
    else
      node,
];
