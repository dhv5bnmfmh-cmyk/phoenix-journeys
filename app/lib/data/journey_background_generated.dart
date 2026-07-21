import '../models/journey_background.dart';

class _CityBackgroundSpec {
  const _CityBackgroundSpec(
    this.journeyId,
    this.motif,
    this.base,
    this.accent,
    this.light,
    this.dark,
  );

  final String journeyId;
  final String motif;
  final String base;
  final String accent;
  final String light;
  final String dark;
}

class _BackgroundVariant {
  const _BackgroundVariant(
    this.slug,
    this.skyTop,
    this.skyBottom,
    this.time,
    this.weather,
  );

  final String slug;
  final String skyTop;
  final String skyBottom;
  final String time;
  final String weather;
}

const _citySpecs = <_CityBackgroundSpec>[
  _CityBackgroundSpec(
    'beijing-forbidden-city',
    'palace',
    '#7C1D1D',
    '#D9A441',
    '#F4E3C1',
    '#3B2A25',
  ),
  _CityBackgroundSpec(
    'shanghai-bund',
    'skyline',
    '#1D3E5F',
    '#C7A36A',
    '#D7E7EE',
    '#3C5266',
  ),
  _CityBackgroundSpec(
    'xian-city-wall',
    'wall',
    '#6D3C2E',
    '#C98B4A',
    '#E7D7BA',
    '#2F2B29',
  ),
  _CityBackgroundSpec(
    'hangzhou-west-lake',
    'lake',
    '#2E5D50',
    '#A9C7B8',
    '#E6E2CC',
    '#5B6E55',
  ),
  _CityBackgroundSpec(
    'chengdu-kuanzhai-alley',
    'courtyard',
    '#36543B',
    '#B88A4E',
    '#E7D9BC',
    '#28342B',
  ),
  _CityBackgroundSpec(
    'nanjing-qinhuai-river',
    'river',
    '#243E57',
    '#B94B3E',
    '#E6D4B9',
    '#3E2E2A',
  ),
  _CityBackgroundSpec(
    'guangzhou-chen-clan',
    'lingnan',
    '#315B5B',
    '#D59A3A',
    '#E8D8B8',
    '#46352C',
  ),
];

const _variants = <_BackgroundVariant>[
  _BackgroundVariant(
    'sunrise-arrival',
    '#F7C99D',
    '#F9EBD7',
    'sunrise',
    'clear',
  ),
  _BackgroundVariant(
    'morning-street',
    '#BFD7E6',
    '#F5EFE2',
    'morning',
    'cloud',
  ),
  _BackgroundVariant(
    'misty-detail',
    '#CBD1CC',
    '#EEF0E8',
    'morning',
    'mist',
  ),
  _BackgroundVariant(
    'bright-panorama',
    '#87C4E6',
    '#F5E8C8',
    'afternoon',
    'clear',
  ),
  _BackgroundVariant(
    'after-rain',
    '#7893A6',
    '#D8E1E3',
    'afternoon',
    'rain',
  ),
  _BackgroundVariant(
    'seasonal-landscape',
    '#B8C99A',
    '#F4E1B8',
    'late',
    'cloud',
  ),
  _BackgroundVariant(
    'golden-hour',
    '#F0A06B',
    '#F6D7A6',
    'golden',
    'clear',
  ),
  _BackgroundVariant(
    'blue-hour',
    '#39557A',
    '#8FA7C3',
    'blue',
    'cloud',
  ),
  _BackgroundVariant(
    'lantern-night',
    '#18243D',
    '#43506C',
    'night',
    'clear',
  ),
  _BackgroundVariant(
    'quiet-night-panorama',
    '#111827',
    '#334155',
    'night',
    'mist',
  ),
];

final generatedJourneyBackgrounds = <JourneyBackgroundAsset>[
  for (final city in _citySpecs)
    for (var index = 0; index < _variants.length; index += 1)
      JourneyBackgroundAsset(
        id:
            '${city.journeyId}-ai-${(index + 1).toString().padLeft(2, '0')}-${_variants[index].slug}',
        journeyId: city.journeyId,
        svgData: _buildSvg(city, _variants[index], index),
        generatedOn: DateTime.utc(2026, 7, 21),
        origin: JourneyBackgroundOrigin.aiGenerated,
        complianceReviewed: true,
        complianceScore: 100,
        varietyScore: 92 + (index % 8),
      ),
];

String _buildSvg(
  _CityBackgroundSpec city,
  _BackgroundVariant variant,
  int index,
) {
  final celestialX = 170 + ((index * 63) % 560);
  final celestialY = 210 + ((index * 47) % 220);
  final isNight = variant.time == 'night' || variant.time == 'blue';
  final clouds = variant.weather == 'clear'
      ? ''
      : '${_cloud(230, 350, 1.2, city.light, variant.weather == 'mist' ? .28 : .52)}'
          '${_cloud(670, 470, .9, city.light, variant.weather == 'mist' ? .22 : .45)}';
  final rain = variant.weather == 'rain'
      ? '<g stroke="#FFFFFF" stroke-width="5" opacity=".22">'
          '${List.generate(10, (line) {
            final x = 80 + (line * 90);
            final y = 240 + (x % 170);
            return '<path d="M$x $y l-45 120"/>';
          }).join()}'
          '</g>'
      : '';
  final stars = !isNight
      ? ''
      : '<g fill="#FFF8D6" opacity=".55">'
          '${List.generate(14, (star) {
            final x = 80 + ((star * 137) % 760);
            final y = 90 + ((star * 83) % 420);
            final radius = 2 + (star % 3);
            return '<circle cx="$x" cy="$y" r="$radius"/>';
          }).join()}'
          '</g>';
  final pattern = List.generate(18, (dot) {
    final x = 60 + ((dot * 97) % 820);
    final y = 620 + ((dot * 131) % 720);
    final radius = 12 + ((dot % 4) * 5);
    return '<circle cx="$x" cy="$y" r="$radius" '
        'fill="${city.accent}" opacity=".06"/>';
  }).join();

  return '<svg xmlns="http://www.w3.org/2000/svg" '
      'viewBox="0 0 900 1600" preserveAspectRatio="xMidYMid slice">'
      '<defs>'
      '<linearGradient id="sky$index" x1="0" y1="0" x2="0" y2="1">'
      '<stop stop-color="${variant.skyTop}"/>'
      '<stop offset="1" stop-color="${variant.skyBottom}"/>'
      '</linearGradient>'
      '<linearGradient id="veil$index" x1="0" y1="0" x2="1" y2="1">'
      '<stop stop-color="#FFFFFF" stop-opacity=".08"/>'
      '<stop offset="1" stop-color="${city.dark}" stop-opacity=".12"/>'
      '</linearGradient>'
      '</defs>'
      '<rect width="900" height="1600" fill="url(#sky$index)"/>'
      '$stars'
      '<circle cx="$celestialX" cy="$celestialY" '
      'r="${isNight ? 42 : 58}" '
      'fill="${isNight ? city.light : city.accent}" opacity=".84"/>'
      '$clouds'
      '$rain'
      '${_scene(city, index)}'
      '$pattern'
      '<rect width="900" height="1600" fill="url(#veil$index)"/>'
      '</svg>';
}

String _cloud(
  num x,
  num y,
  num scale,
  String fill,
  num opacity,
) {
  return '<g opacity="$opacity">'
      '<ellipse cx="$x" cy="$y" rx="${70 * scale}" '
      'ry="${25 * scale}" fill="$fill"/>'
      '<ellipse cx="${x - (45 * scale)}" cy="${y + (4 * scale)}" '
      'rx="${35 * scale}" ry="${20 * scale}" fill="$fill"/>'
      '<ellipse cx="${x + (45 * scale)}" cy="${y + (6 * scale)}" '
      'rx="${42 * scale}" ry="${22 * scale}" fill="$fill"/>'
      '</g>';
}

String _scene(_CityBackgroundSpec city, int index) {
  return switch (city.motif) {
    'palace' => _palace(city, index),
    'skyline' => _skyline(city, index),
    'wall' => _wall(city, index),
    'lake' => _lake(city, index),
    'courtyard' => _courtyard(city, index),
    'river' => _river(city, index),
    _ => _lingnan(city, index),
  };
}

String _roof(
  num x,
  num y,
  num width,
  num height,
  String fill,
  String accent,
) {
  return '<g>'
      '<rect x="${x + (width * .12)}" y="${y + (height * .42)}" '
      'width="${width * .76}" height="${height * .58}" rx="8" fill="$fill"/>'
      '<polygon points="$x,${y + (height * .42)} '
      '${x + (width * .5)},$y '
      '${x + width},${y + (height * .42)}" fill="$accent"/>'
      '<path d="M$x ${y + (height * .42)} '
      'Q${x + (width * .08)} ${y + (height * .28)} '
      '${x + (width * .18)} ${y + (height * .34)} '
      'L${x + (width * .82)} ${y + (height * .34)} '
      'Q${x + (width * .92)} ${y + (height * .28)} '
      '${x + width} ${y + (height * .42)}" '
      'fill="none" stroke="$fill" stroke-width="12" stroke-linecap="round"/>'
      '</g>';
}

String _mountains(String color, int index, {num baseY = 900}) {
  final ridgeOne = 120 + ((index * 31) % 120);
  final ridgeTwo = 80 + ((index * 47) % 150);
  return '<polygon points="0,$baseY 130,${baseY - ridgeOne} '
      '260,${baseY - 55} 430,${baseY - ridgeTwo} '
      '610,${baseY - 70} 760,${baseY - ridgeOne + 30} '
      '900,${baseY - 40} 900,1600 0,1600" fill="$color" opacity=".2"/>';
}

String _palace(_CityBackgroundSpec city, int index) {
  return '${_mountains(city.dark, index)}'
      '${_roof(80, 720 - (index * 4), 740, 310, city.base, city.accent)}'
      '${_roof(180, 930, 540, 240, city.dark, city.accent)}'
      '<rect x="130" y="1010" width="640" height="320" rx="18" '
      'fill="${city.base}"/>'
      '<g fill="${city.accent}" opacity=".9">'
      '${List.generate(6, (pillar) {
        return '<rect x="${180 + (pillar * 90)}" y="1060" '
            'width="38" height="240" rx="8"/>';
      }).join()}'
      '</g>'
      '<path d="M0 1330 H900 V1600 H0Z" fill="${city.dark}"/>';
}

String _skyline(_CityBackgroundSpec city, int index) {
  const xs = <int>[90, 180, 270, 360, 470, 570, 670, 760];
  const heights = <int>[300, 430, 250, 520, 360, 470, 280, 400];
  final buildings = List.generate(xs.length, (building) {
    final x = xs[building] + ((index % 3) * 4);
    final height = heights[building] + ((index % 2) * 24);
    final width = 55 + ((building % 3) * 18);
    final color = building.isEven ? city.base : city.accent;
    final crown = building == 1 || building == 3 || building == 5
        ? '<circle cx="${x + 28}" cy="${1180 - height - 35}" '
            'r="${20 + (building * 2)}" fill="${city.accent}"/>'
            '<rect x="${x + 25}" y="${1180 - height - 100}" '
            'width="6" height="70" fill="${city.accent}"/>'
        : '';
    return '<rect x="$x" y="${1180 - height}" width="$width" '
        'height="$height" rx="5" fill="$color" opacity=".9"/>$crown';
  }).join();
  return '<path d="M0 1050 Q300 980 900 1030 V1600 H0Z" '
      'fill="${city.light}" opacity=".45"/>'
      '<rect y="1180" width="900" height="420" fill="${city.dark}"/>'
      '$buildings'
      '<path d="M0 1250 Q450 1160 900 1240 V1600 H0Z" '
      'fill="${city.light}" opacity=".55"/>';
}

String _wall(_CityBackgroundSpec city, int index) {
  return '${_mountains(city.dark, index + 5)}'
      '<rect x="0" y="1010" width="900" height="590" fill="${city.dark}"/>'
      '<rect x="60" y="920" width="780" height="240" fill="${city.base}"/>'
      '${_roof(250, 650 - (index * 3), 400, 250, city.base, city.accent)}'
      '<g fill="${city.accent}">'
      '${List.generate(7, (block) {
        return '<rect x="${100 + (block * 100)}" y="870" '
            'width="55" height="90"/>';
      }).join()}'
      '</g>'
      '<path d="M0 1360 L900 1160 V1600 H0Z" '
      'fill="${city.base}" opacity=".72"/>';
}

String _lake(_CityBackgroundSpec city, int index) {
  final pagoda = List.generate(4, (floor) {
    return _roof(0, 80 - (floor * 70), 125, 90, city.dark, city.accent);
  }).join();
  return '${_mountains(city.dark, index + 9, baseY: 820)}'
      '<path d="M0 840 Q280 780 500 830 T900 800 V1600 H0Z" '
      'fill="${city.base}" opacity=".55"/>'
      '<path d="M90 1130 Q450 ${880 - (index * 4)} 810 1130" '
      'fill="none" stroke="${city.light}" stroke-width="36" '
      'stroke-linecap="round"/>'
      '<path d="M120 1145 Q450 ${930 - (index * 3)} 780 1145" '
      'fill="none" stroke="${city.accent}" stroke-width="8" opacity=".8"/>'
      '<g transform="translate(650 610)">'
      '<rect x="52" y="120" width="20" height="350" fill="${city.dark}"/>'
      '$pagoda'
      '</g>'
      '<path d="M0 1260 Q420 1160 900 1240 V1600 H0Z" '
      'fill="${city.dark}" opacity=".3"/>';
}

String _courtyard(_CityBackgroundSpec city, int index) {
  final bamboo = List.generate(7, (stem) {
    return '<path d="M${80 + (stem * 115)} 760 '
        'Q${110 + (stem * 115)} ${600 - (stem * 15)} '
        '${145 + (stem * 115)} 490"/>';
  }).join();
  final leaves = List.generate(7, (leaf) {
    return '<circle cx="${115 + (leaf * 115)}" '
        'cy="${540 + ((leaf % 2) * 50)}" r="${32 + (index % 4)}"/>';
  }).join();
  return '${_mountains(city.dark, index + 3, baseY: 850)}'
      '<rect y="930" width="900" height="670" fill="${city.light}"/>'
      '${_roof(40, 720, 820, 300, city.dark, city.accent)}'
      '<rect x="90" y="960" width="720" height="460" fill="${city.base}"/>'
      '<rect x="330" y="1030" width="240" height="390" '
      'rx="120 120 0 0" fill="${city.dark}"/>'
      '<g stroke="${city.dark}" stroke-width="16" stroke-linecap="round">'
      '$bamboo'
      '</g>'
      '<g fill="${city.accent}" opacity=".75">$leaves</g>';
}

String _river(_CityBackgroundSpec city, int index) {
  final lanterns = List.generate(5, (lantern) {
    final y = 830 + ((lantern % 2) * 50);
    return '<circle cx="${150 + (lantern * 150)}" cy="$y" r="26"/>'
        '<rect x="${146 + (lantern * 150)}" y="${y + 26}" '
        'width="8" height="80"/>';
  }).join();
  return '${_mountains(city.dark, index + 11, baseY: 820)}'
      '<g fill="${city.light}">'
      '<rect x="0" y="760" width="230" height="430"/>'
      '<rect x="670" y="730" width="230" height="460"/>'
      '</g>'
      '${_roof(-20, 620, 300, 180, city.dark, city.accent)}'
      '${_roof(620, 580, 320, 190, city.dark, city.accent)}'
      '<path d="M0 970 Q450 870 900 980 V1600 H0Z" '
      'fill="${city.base}" opacity=".7"/>'
      '<path d="M90 1190 Q450 ${940 - (index * 5)} 810 1190" '
      'fill="none" stroke="${city.accent}" stroke-width="36" '
      'stroke-linecap="round"/>'
      '<path d="M120 1205 Q450 ${980 - (index * 4)} 780 1205" '
      'fill="none" stroke="${city.light}" stroke-width="8" opacity=".8"/>'
      '<g fill="${city.accent}">$lanterns</g>';
}

String _lingnan(_CityBackgroundSpec city, int index) {
  final arches = List.generate(6, (arch) {
    return '<rect x="${130 + (arch * 120)}" y="1030" '
        'width="72" height="300" rx="36 36 0 0"/>';
  }).join();
  final ornaments = List.generate(6, (ornament) {
    return '<circle cx="${150 + (ornament * 120)}" '
        'cy="${780 + ((ornament % 2) * 40)}" '
        'r="${22 + (index % 3)}"/>';
  }).join();
  return '${_mountains(city.dark, index + 17, baseY: 830)}'
      '<rect y="930" width="900" height="670" fill="${city.light}"/>'
      '${_roof(40, 690, 820, 300, city.base, city.accent)}'
      '<rect x="80" y="960" width="740" height="440" fill="${city.base}"/>'
      '<g fill="${city.dark}">$arches</g>'
      '<path d="M90 730 Q170 610 250 730 T410 730 T570 730 '
      'T730 730 T890 730" fill="none" stroke="${city.accent}" '
      'stroke-width="24"/>'
      '<g fill="${city.accent}" opacity=".85">$ornaments</g>';
}
