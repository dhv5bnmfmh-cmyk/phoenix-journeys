# Phoenix Location Hierarchy Standard

## 1. Canonical source of truth

`worldGeoCatalog` is the single geographic hierarchy. Every location-based
Journey binds to one coordinate-bearing `place` `GeoNode`, and
`JourneyLocationBinding.geoPath` is the authoritative ancestry from the world
root to that place. Journey packages and widgets MUST NOT maintain parallel
province, city, district, or place hierarchies.

Generic `GeoNodeKind.adminLevel1` remains an international administrative
concept. It MUST NOT be globally renamed to “province”. China presentation may
describe an `adminLevel1` node as a province-level region.

## 2. Journey location projection

UI and reporting code MUST use the centralized `JourneyLocationBinding`
projection instead of repeatedly interpreting raw node kinds. The projection
provides:

- `countryNode`;
- `provinceLevelNode`;
- `cityEquivalentNode`;
- optional `districtNode`;
- `placeNode`;
- full `geoPath` and display-ready names.

The existing `cityId`, `destinationId`, and `locationPath` remain stable runtime
identifiers. `cityId` is a backward-compatible product grouping key; geographic
city semantics come from `cityEquivalentNode`. Progress, completion, Words,
Memory, stamps, unlocks, narration, and generated background paths continue to
use the existing binding and `locationPath` namespaces.

## 3. Province-level and municipality semantics

For an ordinary Chinese province Journey, the required path is:

`country → adminLevel1 → city → optional district → place`

The `city` node is the city-equivalent region.

For a Chinese municipality, the required path is:

`country → municipality adminLevel1 → optional district → place`

The municipality `adminLevel1` node also serves as the city-equivalent region.
Phoenix MUST NOT create a duplicate same-name city node merely to satisfy an
ordinary province/city shape.

## 4. Display policy

Canonical hierarchy displays may include country through place. Compact Journey
presentation shows province-level and city-equivalent context, followed by place
identity. A municipality name appears once. When useful, its district follows:

- ordinary province: `四川省 · 成都市`, then `宽窄巷子`;
- municipality: `北京市 · 东城区`, then `故宫博物院`.

Narrow layouts preserve place identity first, then administrative context, and
ellipsize secondary text. Administrative breadcrumbs MUST NOT default to a
horizontal scrolling maze.

## 5. Derived navigation and coverage

Passport province and city organization and all coverage counts MUST derive
from registered `JourneyLocationBinding` values. No current count may be stored
manually. The reusable coverage projection supplies:

- covered province-level region count;
- covered city-equivalent region count;
- covered place count;
- Journey count;
- per-province-level Journey count;
- per-city-equivalent Journey count.

The model supports many cities per province, many districts per city, many
places per district, and many Journey places per city.

## 6. New Journey acceptance

Before Gold acceptance, every new location-based Journey MUST provide:

1. country ancestry;
2. province-level ancestry where applicable;
3. city-equivalent resolution;
4. one place `GeoNode`;
5. coordinates on that place;
6. one stable Journey-to-place binding;
7. a display-ready hierarchy from the binding projection;
8. a unique location binding and `locationPath`;
9. no manually divergent duplicate hierarchy.

Asset directories MUST NOT be renamed to make labels prettier. Geographic
navigation work MUST NOT alter Journey literary content, semantic evidence, or
map interaction behavior.
