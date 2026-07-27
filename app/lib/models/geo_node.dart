enum GeoNodeKind {
  world,
  country,
  adminLevel1,
  adminLevel2,
  adminLevel3,
  city,
  district,
  town,
  place,
}

class GeoNode {
  const GeoNode({
    required this.id,
    required this.name,
    required this.kind,
    required this.localType,
    this.parentId,
    this.countryCode,
    this.latitude,
    this.longitude,
    this.aliases = const [],
  });

  final String id;
  final String name;
  final GeoNodeKind kind;
  final String localType;
  final String? parentId;
  final String? countryCode;
  final double? latitude;
  final double? longitude;
  final List<String> aliases;

  bool get isPlace => kind == GeoNodeKind.place;
  bool get isAdministrative => switch (kind) {
        GeoNodeKind.adminLevel1 ||
        GeoNodeKind.adminLevel2 ||
        GeoNodeKind.adminLevel3 ||
        GeoNodeKind.city ||
        GeoNodeKind.district ||
        GeoNodeKind.town => true,
        _ => false,
      };
}
