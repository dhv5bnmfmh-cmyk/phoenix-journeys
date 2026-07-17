import '../models/geo_node.dart';

const worldGeoCatalog = <GeoNode>[
  GeoNode(
    id: 'world',
    name: '世界',
    kind: GeoNodeKind.world,
    localType: '世界',
  ),
  GeoNode(
    id: 'cn',
    name: '中国',
    kind: GeoNodeKind.country,
    localType: '国家',
    parentId: 'world',
    countryCode: 'CN',
    aliases: ['China', '中华人民共和国'],
  ),
  GeoNode(
    id: 'cn-beijing',
    name: '北京市',
    kind: GeoNodeKind.adminLevel1,
    localType: '直辖市',
    parentId: 'cn',
    countryCode: 'CN',
    aliases: ['北京', 'Beijing'],
  ),
  GeoNode(
    id: 'cn-beijing-dongcheng',
    name: '东城区',
    kind: GeoNodeKind.district,
    localType: '市辖区',
    parentId: 'cn-beijing',
    countryCode: 'CN',
    aliases: ['Dongcheng'],
  ),
  GeoNode(
    id: 'cn-beijing-dongcheng-forbidden-city',
    name: '故宫博物院',
    kind: GeoNodeKind.place,
    localType: '文化景点',
    parentId: 'cn-beijing-dongcheng',
    countryCode: 'CN',
    latitude: 39.9163,
    longitude: 116.3972,
    aliases: ['紫禁城', 'Forbidden City', '故宫'],
  ),
];
