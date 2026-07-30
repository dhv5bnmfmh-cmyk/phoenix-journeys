import '../models/geo_node.dart';
import '../services/journey_location_binding.dart';
import 'journey_city_catalog.dart';

class JourneyProvinceCatalogEntry {
  const JourneyProvinceCatalogEntry({
    required this.id,
    required this.name,
    required this.geoNodeId,
    required this.cityIds,
    this.isMunicipality = false,
  });

  final String id;
  final String name;
  final String geoNodeId;
  final List<String> cityIds;
  final bool isMunicipality;
}

const _chinaProvinceSpecs = <JourneyProvinceCatalogEntry>[
  JourneyProvinceCatalogEntry(
    id: 'beijing',
    name: '北京',
    geoNodeId: 'cn-beijing',
    cityIds: ['beijing'],
    isMunicipality: true,
  ),
  JourneyProvinceCatalogEntry(
    id: 'shanghai',
    name: '上海',
    geoNodeId: 'cn-shanghai',
    cityIds: ['shanghai'],
    isMunicipality: true,
  ),
  JourneyProvinceCatalogEntry(
    id: 'hebei',
    name: '河北',
    geoNodeId: 'cn-hebei',
    cityIds: ['chengde'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'heilongjiang',
    name: '黑龙江',
    geoNodeId: 'cn-heilongjiang',
    cityIds: ['harbin'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'shanxi',
    name: '山西',
    geoNodeId: 'cn-shanxi',
    cityIds: ['datong', 'pingyao'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'shandong',
    name: '山东',
    geoNodeId: 'cn-shandong',
    cityIds: ['qufu'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'henan',
    name: '河南',
    geoNodeId: 'cn-henan',
    cityIds: ['luoyang', 'kaifeng'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'shaanxi',
    name: '陕西',
    geoNodeId: 'cn-shaanxi',
    cityIds: ['xian'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'gansu',
    name: '甘肃',
    geoNodeId: 'cn-gansu',
    cityIds: ['dunhuang'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'jiangsu',
    name: '江苏',
    geoNodeId: 'cn-jiangsu',
    cityIds: ['nanjing', 'suzhou'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'zhejiang',
    name: '浙江',
    geoNodeId: 'cn-zhejiang',
    cityIds: ['hangzhou'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'anhui',
    name: '安徽',
    geoNodeId: 'cn-anhui',
    cityIds: ['huangshan'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'fujian',
    name: '福建',
    geoNodeId: 'cn-fujian',
    cityIds: ['quanzhou', 'xiamen', 'wuyishan'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'guangdong',
    name: '广东',
    geoNodeId: 'cn-guangdong',
    cityIds: ['guangzhou', 'jiangmen'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'hunan',
    name: '湖南',
    geoNodeId: 'cn-hunan',
    cityIds: ['zhangjiajie'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'sichuan',
    name: '四川',
    geoNodeId: 'cn-sichuan',
    cityIds: ['chengdu', 'leshan'],
  ),
  JourneyProvinceCatalogEntry(
    id: 'yunnan',
    name: '云南',
    geoNodeId: 'cn-yunnan',
    cityIds: ['lijiang', 'honghe', 'dali'],
  ),
];

final List<JourneyProvinceCatalogEntry> chinaProvinceCatalog =
    _buildValidatedChinaProvinceCatalog();

List<JourneyProvinceCatalogEntry> _buildValidatedChinaProvinceCatalog() {
  final assignedCityIds = <String>{};

  for (final province in _chinaProvinceSpecs) {
    if (province.isMunicipality && province.cityIds.length != 1) {
      throw StateError(
        'Municipality ${province.id} must map directly to one city.',
      );
    }

    for (final cityId in province.cityIds) {
      if (!assignedCityIds.add(cityId)) {
        throw StateError('City $cityId is assigned to more than one province.');
      }

      final city = requireJourneyCity(cityId);
      final binding = requireJourneyLocation(city.primaryDestination.id);
      final countryNodes = binding.geoPath.where(
        (node) => node.kind == GeoNodeKind.country,
      );
      final provinceNodes = binding.geoPath.where(
        (node) => node.kind == GeoNodeKind.adminLevel1,
      );

      if (countryNodes.length != 1 || countryNodes.single.id != 'cn') {
        throw StateError(
          'City $cityId must belong to exactly one country: cn.',
        );
      }
      if (provinceNodes.length != 1 ||
          provinceNodes.single.id != province.geoNodeId) {
        throw StateError(
          'City $cityId is not inside province ${province.geoNodeId}.',
        );
      }

      final localAdministrativeNodes = binding.geoPath.where(
        (node) =>
            node.isAdministrative && node.kind != GeoNodeKind.adminLevel1,
      );
      if (province.isMunicipality) {
        final provinceNode = provinceNodes.single;
        final names = <String>{
          provinceNode.name.replaceFirst(RegExp('市\$'), ''),
          ...provinceNode.aliases,
        };
        if (!names.contains(city.name)) {
          throw StateError(
            'Municipality ${province.id} does not match city ${city.name}.',
          );
        }
      } else if (!localAdministrativeNodes.any(
        (node) => _nodeMatchesCity(node, city.name),
      )) {
        throw StateError(
          'City $cityId does not match its authoritative city GeoNode.',
        );
      }

      if (binding.latitude < 18 ||
          binding.latitude > 54 ||
          binding.longitude < 73 ||
          binding.longitude > 135) {
        throw StateError(
          'City $cityId has coordinates outside the China map bounds.',
        );
      }
    }
  }

  final catalogCityIds = journeyCityCatalog.map((city) => city.id).toSet();
  if (assignedCityIds.length != catalogCityIds.length ||
      !assignedCityIds.containsAll(catalogCityIds)) {
    final missing = catalogCityIds.difference(assignedCityIds);
    final unknown = assignedCityIds.difference(catalogCityIds);
    throw StateError(
      'Province catalog mismatch. Missing: $missing; unknown: $unknown.',
    );
  }

  return List<JourneyProvinceCatalogEntry>.unmodifiable(_chinaProvinceSpecs);
}

bool _nodeMatchesCity(GeoNode node, String cityName) {
  final names = <String>{
    node.name.replaceFirst(RegExp('市\$'), ''),
    ...node.aliases,
  };
  return names.contains(cityName);
}

JourneyProvinceCatalogEntry requireJourneyProvince(String provinceId) {
  return chinaProvinceCatalog.firstWhere(
    (province) => province.id == provinceId,
    orElse: () => throw StateError(
      'Journey province is not registered: $provinceId.',
    ),
  );
}
