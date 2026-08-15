import '../models/geo_node.dart';
import 'world_geo_catalog_base.dart' as base;

const worldGeoCatalog = <GeoNode>[
  ...base.worldGeoCatalog,
  GeoNode(
    id: 'cn-guangdong-jiangmen',
    name: '江门市',
    kind: GeoNodeKind.city,
    localType: '地级市',
    parentId: 'cn-guangdong',
    countryCode: 'CN',
    aliases: ['江门', 'Jiangmen'],
  ),
  GeoNode(
    id: 'cn-guangdong-jiangmen-kaiping',
    name: '开平市',
    kind: GeoNodeKind.adminLevel3,
    localType: '县级市',
    parentId: 'cn-guangdong-jiangmen',
    countryCode: 'CN',
    aliases: ['开平', 'Kaiping'],
  ),
  GeoNode(
    id: 'cn-guangdong-jiangmen-kaiping-diaolou-villages',
    name: '开平碉楼与村落',
    kind: GeoNodeKind.place,
    localType: '世界文化遗产',
    parentId: 'cn-guangdong-jiangmen-kaiping',
    countryCode: 'CN',
    aliases: ['开平碉楼', 'Kaiping Diaolou and Villages', 'Kaiping Diaolou'],
  ),
];
