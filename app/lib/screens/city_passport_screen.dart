import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_city_catalog.dart';
import '../data/journey_geography_catalog.dart';
import '../services/journey_location_binding.dart';
import '../state/access_controlled_app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_symbol_badge.dart';
import 'journey_screen.dart';

class CityPassportScreen extends StatelessWidget {
  const CityPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Stack(
      key: const ValueKey('passport-hd-atlas-page'),
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFF2E2BD)),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 7),
          child: Column(
            children: [
              _PassportHeader(state: state),
              const SizedBox(height: 7),
              Expanded(child: _PassportMap(state: state)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PassportHeader extends StatelessWidget {
  const _PassportHeader({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: PhoenixTheme.red.withValues(alpha: .88),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            state.displayText('探索护照'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 17,
              height: 1,
              fontWeight: FontWeight.w900,
              shadows: const [
                Shadow(color: Color(0x99FFF8E8), blurRadius: 8),
              ],
            ),
          ),
        ),
        Text(
          state.displayText('北京 Reference'),
          style: const TextStyle(
            color: PhoenixTheme.red,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PassportMap extends StatefulWidget {
  const _PassportMap({required this.state});

  final AppState state;

  @override
  State<_PassportMap> createState() => _PassportMapState();
}

enum _PassportMapLevel { continent, country, province, city }

class _PassportMapState extends State<_PassportMap> {
  static const _continents = <({String id, String name})>[
    (id: 'asia', name: '亚洲'),
    (id: 'europe', name: '欧洲'),
    (id: 'africa', name: '非洲'),
    (id: 'america', name: '美洲'),
    (id: 'oceania', name: '大洋洲'),
  ];

  String _continentId = 'asia';
  _PassportMapLevel _level = _PassportMapLevel.continent;
  String? _selectedProvinceId;
  String? _selectedCityId;
  late final TransformationController _mapTransformationController;

  AppState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _mapTransformationController = TransformationController();
  }

  @override
  void dispose() {
    _mapTransformationController.dispose();
    super.dispose();
  }

  void _resetMapTransform() {
    _mapTransformationController.value = Matrix4.identity();
  }

  void _restoreCanonicalTransformAtBaseScale(ScaleEndDetails details) {
    if (_mapTransformationController.value.getMaxScaleOnAxis() <= 1.0001) {
      _resetMapTransform();
    }
  }

  void _selectContinent(String continentId) {
    _resetMapTransform();
    setState(() {
      _continentId = continentId;
      _level = _PassportMapLevel.continent;
      _selectedProvinceId = null;
      _selectedCityId = null;
    });
  }

  void _selectChina() {
    _resetMapTransform();
    setState(() {
      _level = _PassportMapLevel.country;
      _selectedProvinceId = null;
      _selectedCityId = null;
    });
  }

  void _selectProvince(String provinceId) {
    final province = requirePublishedJourneyProvince(provinceId);
    _resetMapTransform();
    setState(() {
      _selectedProvinceId = provinceId;
      if (province.isMunicipality) {
        _level = _PassportMapLevel.city;
        _selectedCityId = province.cityIds.single;
      } else {
        _level = _PassportMapLevel.province;
        _selectedCityId = null;
      }
    });
  }

  void _selectCity(String cityId) {
    _resetMapTransform();
    setState(() {
      _level = _PassportMapLevel.city;
      _selectedCityId = cityId;
    });
  }

  void _goBack() {
    _resetMapTransform();
    setState(() {
      if (_level == _PassportMapLevel.city) {
        final province = requirePublishedJourneyProvince(_selectedProvinceId!);
        _level = province.isMunicipality
            ? _PassportMapLevel.country
            : _PassportMapLevel.province;
        if (province.isMunicipality) _selectedProvinceId = null;
        _selectedCityId = null;
      } else if (_level == _PassportMapLevel.province) {
        _level = _PassportMapLevel.country;
        _selectedProvinceId = null;
        _selectedCityId = null;
      } else if (_level == _PassportMapLevel.country) {
        _level = _PassportMapLevel.continent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 34,
          child: ListView.separated(
            key: const ValueKey('passport-continent-tabs'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: _continents.length,
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              final continent = _continents[index];
              final selected = continent.id == _continentId;
              return ChoiceChip(
                key: ValueKey('passport-continent-${continent.id}'),
                selected: selected,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                label: Text(state.displayText(continent.name)),
                onSelected: (_) => _selectContinent(continent.id),
                selectedColor: PhoenixTheme.red,
                backgroundColor: const Color(0xEFFFF8E8),
                side: BorderSide(
                  color: selected
                      ? PhoenixTheme.red
                      : PhoenixTheme.red.withValues(alpha: .22),
                ),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF38231A),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 88,
                child: _PassportPlaceRail(
                  state: state,
                  continentId: _continentId,
                  level: _level,
                  selectedProvinceId: _selectedProvinceId,
                  selectedCityId: _selectedCityId,
                  onBack: _goBack,
                  onSelectChina: _selectChina,
                  onSelectProvince: _selectProvince,
                  onSelectCity: _selectCity,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(child: _buildMap()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapSize = constraints.biggest;
        final fittedMap = applyBoxFit(
          BoxFit.contain,
          const Size(941, 1672),
          mapSize,
        );
        final geographicMapRect = Alignment.center.inscribe(
          fittedMap.destination,
          Offset.zero & mapSize,
        );
        final markerPlacements = _resolveCityMarkerPlacements(
          geographicMapRect,
        );
        final selectedCity = _selectedCityId == null
            ? null
            : requirePublishedJourneyCity(_selectedCityId!);
        final showChinaMap = _level != _PassportMapLevel.continent;
        final mapAsset = showChinaMap
            ? 'assets/images/maps/china-passport-atlas-v2.webp'
            : _continentId == 'asia'
                ? 'assets/images/maps/east-asia-flight-relief-v2.webp'
                : 'assets/images/maps/world-flight-atlas-v1.webp';
        final mapFit = showChinaMap ? BoxFit.contain : BoxFit.cover;
        return SizedBox.fromSize(
          key: const ValueKey('passport-map-viewport'),
          size: mapSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InteractiveViewer(
                  key: const ValueKey('passport-pinch-zoom-map'),
                  transformationController: _mapTransformationController,
                  minScale: 1,
                  maxScale: 4,
                  boundaryMargin: EdgeInsets.zero,
                  panEnabled: true,
                  scaleEnabled: true,
                  onInteractionEnd: _restoreCanonicalTransformAtBaseScale,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox.fromSize(
                    key: const ValueKey('passport-map-content'),
                    size: mapSize,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: ColoredBox(
                            color: const Color(0xFFE8D7AF),
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.matrix(<double>[
                                1.28,
                                -.08,
                                -.08,
                                0,
                                -4,
                                -.08,
                                1.28,
                                -.08,
                                0,
                                -4,
                                -.08,
                                -.08,
                                1.28,
                                0,
                                -4,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ]),
                              child: Image.asset(
                                mapAsset,
                                key: const ValueKey(
                                  'passport-hd-atlas-image',
                                ),
                                fit: mapFit,
                                alignment: Alignment.center,
                                filterQuality: FilterQuality.high,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ),
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(.18, -.20),
                                radius: 1.12,
                                colors: [
                                  Color(0x00FFF8E8),
                                  Color(0x120D4A45),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (selectedCity != null) ...[
                          _CityMarkerLeader(
                            placement: markerPlacements[selectedCity.id]!,
                            earned: selectedCity.destinations.any(
                              (journey) =>
                                  state.isJourneyStampEarned(journey.id),
                            ),
                          ),
                          _CityMapMarker(
                            state: state,
                            city: selectedCity,
                            placement: markerPlacements[selectedCity.id]!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_level == _PassportMapLevel.continent)
                  Center(
                    child: _MapLevelCaption(
                      title: _continentId == 'asia'
                          ? state.displayText('亚洲')
                          : state.displayText('目的地即将开放'),
                      subtitle: _continentId == 'asia'
                          ? state.displayText('请从左侧选择国家')
                          : state.displayText('请选择其他洲继续探索'),
                    ),
                  )
                else if (_level == _PassportMapLevel.country)
                  Center(
                    child: _MapLevelCaption(
                      title: state.displayText('中国'),
                      subtitle: state.displayText('请从左侧选择省份'),
                    ),
                  )
                else if (_level == _PassportMapLevel.province)
                  Center(
                    child: _MapLevelCaption(
                      title: state.displayText(
                        requirePublishedJourneyProvince(_selectedProvinceId!)
                            .name,
                      ),
                      subtitle: state.displayText('请从左侧选择城市'),
                    ),
                  ),
                Positioned(
                  left: 9,
                  bottom: 9,
                  child: IgnorePointer(
                    child: Container(
                      key: const ValueKey('passport-pinch-hint'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xD92A2019),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        state.displayText('双指缩放查看地图'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PassportPlaceRail extends StatelessWidget {
  const _PassportPlaceRail({
    required this.state,
    required this.continentId,
    required this.level,
    required this.selectedProvinceId,
    required this.selectedCityId,
    required this.onBack,
    required this.onSelectChina,
    required this.onSelectProvince,
    required this.onSelectCity,
  });

  final AppState state;
  final String continentId;
  final _PassportMapLevel level;
  final String? selectedProvinceId;
  final String? selectedCityId;
  final VoidCallback onBack;
  final VoidCallback onSelectChina;
  final ValueChanged<String> onSelectProvince;
  final ValueChanged<String> onSelectCity;

  Future<void> _openDestination(
    BuildContext context,
    DailyJourneyExperience journey,
  ) async {
    await state.activateJourney(journey.id);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JourneyScreen(journeyId: journey.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = level != _PassportMapLevel.continent;
    final selectedCity = selectedCityId == null
        ? null
        : requirePublishedJourneyCity(selectedCityId!);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xDFFFF8E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhoenixTheme.red.withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          if (canGoBack)
            IconButton(
              key: const ValueKey('passport-place-back'),
              onPressed: onBack,
              tooltip: state.displayText('返回上一级'),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              color: PhoenixTheme.red,
              visualDensity: VisualDensity.compact,
            ),
          if (level == _PassportMapLevel.city && selectedCity != null)
            _PassportCityContext(state: state, city: selectedCity),
          Expanded(
            child: continentId != 'asia'
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        state.displayText('即将开放'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                : level == _PassportMapLevel.continent
                    ? ListView(
                        padding: const EdgeInsets.all(6),
                        children: [
                          _PlaceRailButton(
                            key: const ValueKey('passport-country-china'),
                            label: state.displayText('中国'),
                            selected: false,
                            onTap: onSelectChina,
                          ),
                        ],
                      )
                    : level == _PassportMapLevel.country
                        ? ListView.separated(
                            key: const ValueKey('passport-province-list'),
                            padding: const EdgeInsets.all(6),
                            itemCount: publishedChinaProvinceCatalog.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 4),
                            itemBuilder: (context, index) {
                              final province =
                                  publishedChinaProvinceCatalog[index];
                              return _PlaceRailButton(
                                key: ValueKey(
                                  'passport-province-${province.id}',
                                ),
                                label: state.displayText(province.name),
                                selected: false,
                                onTap: () => onSelectProvince(province.id),
                              );
                            },
                          )
                        : level == _PassportMapLevel.city
                            ? ListView.separated(
                                key:
                                    const ValueKey('passport-destination-list'),
                                padding: const EdgeInsets.all(6),
                                itemCount: requirePublishedJourneyCity(
                                  selectedCityId!,
                                ).destinations.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (context, index) {
                                  final journey = requirePublishedJourneyCity(
                                    selectedCityId!,
                                  ).destinations[index];
                                  final canOpen =
                                      state.canOpenJourney(journey.id);
                                  final location = requireJourneyLocation(
                                    journey.id,
                                  );
                                  return _PlaceRailJourneyButton(
                                    key: ValueKey(
                                      'passport-place-option-${journey.id}',
                                    ),
                                    state: state,
                                    location: location,
                                    selected: canOpen &&
                                        state.activeJourneyId == journey.id,
                                    onTap: canOpen
                                        ? () => unawaited(
                                              _openDestination(
                                                  context, journey),
                                            )
                                        : null,
                                  );
                                },
                              )
                            : ListView.separated(
                                key: const ValueKey('passport-city-list'),
                                padding: const EdgeInsets.all(6),
                                itemCount: requirePublishedJourneyProvince(
                                  selectedProvinceId!,
                                ).cityIds.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (context, index) {
                                  final province =
                                      requirePublishedJourneyProvince(
                                    selectedProvinceId!,
                                  );
                                  final city = requirePublishedJourneyCity(
                                    province.cityIds[index],
                                  );
                                  return _PlaceRailButton(
                                    key: ValueKey(
                                        'passport-city-option-${city.id}'),
                                    label: state.displayText(city.name),
                                    selected: selectedCityId == city.id,
                                    onTap: () => onSelectCity(city.id),
                                  );
                                },
                              ),
          ),
        ],
      ),
    );
  }
}

class _PassportCityContext extends StatelessWidget {
  const _PassportCityContext({required this.state, required this.city});

  final AppState state;
  final JourneyCityCatalogEntry city;

  @override
  Widget build(BuildContext context) {
    final location = requireJourneyLocation(city.primaryDestination.id);
    final provinceName = location.provinceLevelName!;
    final cityName = location.cityEquivalentName!;
    final countLabel = '${city.destinationCount} 段旅程';
    final administrativeLabel =
        location.isMunicipality ? provinceName : '$provinceName，$cityName';
    return Semantics(
      container: true,
      label: state.displayText(
        '$administrativeLabel，$countLabel',
      ),
      child: Padding(
        key: ValueKey('passport-city-context-${city.id}'),
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Column(
          children: [
            Text(
              state.displayText(provinceName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              state.displayText(
                location.isMunicipality
                    ? countLabel
                    : '$cityName · $countLabel',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceRailJourneyButton extends StatelessWidget {
  const _PlaceRailJourneyButton({
    super.key,
    required this.state,
    required this.location,
    required this.selected,
    required this.onTap,
  });

  final AppState state;
  final JourneyLocationBinding location;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final foreground = selected && enabled
        ? Colors.white
        : enabled
            ? const Color(0xFF38231A)
            : Colors.black38;
    return Semantics(
      button: true,
      enabled: enabled,
      label: state.displayText(
        '${location.compactAdministrativeLabel}，${location.placeName}',
      ),
      child: Material(
        color: selected && enabled ? PhoenixTheme.red : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
            child: Column(
              children: [
                if (location.districtName != null)
                  Text(
                    state.displayText(location.districtName!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foreground.withValues(alpha: .72),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                Text(
                  state.displayText(location.placeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceRailButton extends StatelessWidget {
  const _PlaceRailButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: selected && enabled ? PhoenixTheme.red : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected && enabled
                    ? Colors.white
                    : enabled
                        ? const Color(0xFF38231A)
                        : Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLevelCaption extends StatelessWidget {
  const _MapLevelCaption({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xEFFFF8E8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PhoenixTheme.red.withValues(alpha: .32)),
          boxShadow: const [
            BoxShadow(color: Color(0x26000000), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2A1D16),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityMarkerPlacement {
  const _CityMarkerPlacement({
    required this.anchor,
    required this.rect,
    required this.labelOnLeft,
  });

  final Offset anchor;
  final Rect rect;
  final bool labelOnLeft;
}

Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Rect mapRect) {
  const markerSize = Size(72, 28);
  const mapPadding = 7.0;
  final occupied = <Rect>[];
  final placements = <String, _CityMarkerPlacement>{};

  for (final city in publishedJourneyCityCatalog) {
    final binding = requireJourneyLocation(city.primaryDestination.id);
    final longitudeRatio = ((binding.longitude - 73) / (135 - 73)).clamp(0, 1);
    final latitudeRatio = ((binding.latitude - 18) / (54 - 18)).clamp(0, 1);
    final anchor = Offset(
      mapRect.left + mapRect.width * (.10 + longitudeRatio * .78),
      mapRect.top + mapRect.height * (.08 + (1 - latitudeRatio) * .82),
    );
    final candidates = <({Offset offset, bool labelOnLeft})>[
      (offset: const Offset(10, -14), labelOnLeft: false),
      (offset: const Offset(-82, -14), labelOnLeft: true),
      (offset: const Offset(9, -48), labelOnLeft: false),
      (offset: const Offset(-81, -48), labelOnLeft: true),
      (offset: const Offset(9, 20), labelOnLeft: false),
      (offset: const Offset(-81, 20), labelOnLeft: true),
      (offset: const Offset(28, -38), labelOnLeft: false),
      (offset: const Offset(-100, -38), labelOnLeft: true),
      (offset: const Offset(28, 10), labelOnLeft: false),
      (offset: const Offset(-100, 10), labelOnLeft: true),
      (offset: const Offset(-36, -58), labelOnLeft: false),
      (offset: const Offset(-36, 30), labelOnLeft: true),
      (offset: const Offset(48, -14), labelOnLeft: false),
      (offset: const Offset(-120, -14), labelOnLeft: true),
    ];

    _CityMarkerPlacement? selected;
    for (final candidate in candidates) {
      final translated = (candidate.offset & markerSize).shift(anchor);
      final rect = Rect.fromLTWH(
        translated.left.clamp(
          mapRect.left + mapPadding,
          mapRect.right - markerSize.width - mapPadding,
        ),
        translated.top.clamp(
          mapRect.top + mapPadding,
          mapRect.bottom - markerSize.height - mapPadding,
        ),
        markerSize.width,
        markerSize.height,
      );
      if (occupied.every((other) => !other.overlaps(rect.inflate(5)))) {
        selected = _CityMarkerPlacement(
          anchor: anchor,
          rect: rect,
          labelOnLeft: candidate.labelOnLeft,
        );
        break;
      }
    }

    if (selected == null) {
      for (var row = 0; row < 12 && selected == null; row += 1) {
        for (final onLeft in const [false, true]) {
          final left =
              onLeft ? anchor.dx - markerSize.width - 16 : anchor.dx + 16;
          final top =
              anchor.dy - 14 + (row.isEven ? 1 : -1) * ((row + 1) ~/ 2) * 34;
          final rect = Rect.fromLTWH(
            left.clamp(
              mapRect.left + mapPadding,
              mapRect.right - markerSize.width - mapPadding,
            ),
            top.clamp(
              mapRect.top + mapPadding,
              mapRect.bottom - markerSize.height - mapPadding,
            ),
            markerSize.width,
            markerSize.height,
          );
          if (occupied.every((other) => !other.overlaps(rect.inflate(5)))) {
            selected = _CityMarkerPlacement(
              anchor: anchor,
              rect: rect,
              labelOnLeft: onLeft,
            );
            break;
          }
        }
      }
    }

    selected ??= _CityMarkerPlacement(
      anchor: anchor,
      rect: Rect.fromLTWH(
        (anchor.dx + 12).clamp(
          mapRect.left + mapPadding,
          mapRect.right - markerSize.width - mapPadding,
        ),
        (anchor.dy - 14).clamp(
          mapRect.top + mapPadding,
          mapRect.bottom - markerSize.height - mapPadding,
        ),
        markerSize.width,
        markerSize.height,
      ),
      labelOnLeft: false,
    );
    occupied.add(selected.rect.inflate(5));
    placements[city.id] = selected;
  }

  return placements;
}

class _CityMarkerLeader extends StatelessWidget {
  const _CityMarkerLeader({required this.placement, required this.earned});

  final _CityMarkerPlacement placement;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _CityMarkerLeaderPainter(
            anchor: placement.anchor,
            labelRect: placement.rect,
            color: earned ? PhoenixTheme.gold : PhoenixTheme.red,
          ),
        ),
      ),
    );
  }
}

class _CityMarkerLeaderPainter extends CustomPainter {
  const _CityMarkerLeaderPainter({
    required this.anchor,
    required this.labelRect,
    required this.color,
  });

  final Offset anchor;
  final Rect labelRect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final target = Offset(
      anchor.dx < labelRect.left
          ? labelRect.left
          : anchor.dx > labelRect.right
              ? labelRect.right
              : anchor.dx,
      anchor.dy.clamp(labelRect.top + 5, labelRect.bottom - 5),
    );
    final linePaint = Paint()
      ..color = color.withValues(alpha: .72)
      ..strokeWidth = 1.15
      ..style = PaintingStyle.stroke;
    canvas.drawLine(anchor, target, linePaint);
    canvas.drawCircle(
      anchor,
      3.6,
      Paint()
        ..color = const Color(0xFFFFF4D6)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      anchor,
      2.35,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _CityMarkerLeaderPainter oldDelegate) {
    return oldDelegate.anchor != anchor ||
        oldDelegate.labelRect != labelRect ||
        oldDelegate.color != color;
  }
}

class _CityMapMarker extends StatelessWidget {
  const _CityMapMarker({
    required this.state,
    required this.city,
    required this.placement,
  });

  final AppState state;
  final JourneyCityCatalogEntry city;
  final _CityMarkerPlacement placement;

  Future<void> _showCityJourneys(BuildContext context) {
    final cityLocation = requireJourneyLocation(city.primaryDestination.id);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF3),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText(
                  '${cityLocation.cityEquivalentName} · '
                  '${city.destinationCount} 段旅程',
                ),
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                state.displayText(
                  cityLocation.isMunicipality
                      ? '按行政区与地点寻找旅程。'
                      : '${cityLocation.provinceLevelName} · '
                          '按地点寻找旅程。',
                ),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 12),
              for (final journey in city.destinations)
                _DestinationStampTile(state: state, journey: journey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = city.destinations.any(
      (journey) => state.isJourneyStampEarned(journey.id),
    );
    final accessible = city.destinations.any(
      (journey) => state.canOpenJourney(journey.id),
    );
    final badge = JourneySymbolBadge(
      journeyId: city.primaryDestination.id,
      isUnlocked: accessible,
      size: 22,
    );
    final label = Text(
      state.displayText(city.name),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF2A1D16),
        fontSize: 9.5,
        height: 1,
        fontWeight: FontWeight.w900,
      ),
    );

    return Positioned(
      key: ValueKey('passport-city-${city.id}'),
      left: placement.rect.left,
      top: placement.rect.top,
      width: placement.rect.width,
      height: placement.rect.height,
      child: Semantics(
        button: true,
        label: state.displayText('${city.name}旅程地点'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => unawaited(_showCityJourneys(context)),
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              key: ValueKey('passport-city-landmark-${city.id}'),
              padding: const EdgeInsets.fromLTRB(3, 2, 6, 2),
              decoration: BoxDecoration(
                color: const Color(0xEFFFF8E8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: earned
                      ? PhoenixTheme.gold.withValues(alpha: .90)
                      : PhoenixTheme.red.withValues(alpha: .48),
                  width: .8,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: placement.labelOnLeft
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: placement.labelOnLeft
                    ? [
                        Flexible(child: label),
                        const SizedBox(width: 4),
                        badge,
                      ]
                    : [
                        badge,
                        const SizedBox(width: 4),
                        Flexible(child: label),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationStampTile extends StatelessWidget {
  const _DestinationStampTile({required this.state, required this.journey});

  final AppState state;
  final DailyJourneyExperience journey;

  Future<void> _openJourney(BuildContext context) async {
    Navigator.of(context).pop();
    await state.activateJourney(journey.id);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JourneyScreen(journeyId: journey.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = state.canOpenJourney(journey.id);
    final location = requireJourneyLocation(journey.id);

    return Semantics(
      button: true,
      enabled: enabled,
      label: state.displayText('${journey.place}旅程'),
      child: Material(
        key: ValueKey('passport-destination-${journey.id}'),
        color: const Color(0x0FFFFFFF),
        child: InkWell(
          onTap: enabled ? () => unawaited(_openJourney(context)) : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: PhoenixTheme.red.withValues(alpha: .08),
          highlightColor: PhoenixTheme.gold.withValues(alpha: .06),
          child: SizedBox(
            height: 58,
            child: Row(
              children: [
                JourneySymbolBadge(
                  journeyId: journey.id,
                  isUnlocked: enabled,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (location.districtName != null)
                        Text(
                          state.displayText(location.districtName!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      Text(
                        state.displayText(location.placeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: enabled
                              ? const Color(0xFF251A15)
                              : Colors.black45,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          shadows: const [
                            Shadow(color: Color(0xCCFFF8E8), blurRadius: 7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
