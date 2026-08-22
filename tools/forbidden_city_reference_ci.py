#!/usr/bin/env python3
"""Forbidden City active-runtime legacy semantic gate.

Gold requires zero retired Forbidden City semantics in the canonical production
runtime. Historical/global compatibility catalogs are reported separately but do
not fail this gate when they are unreachable from the canonical Reference route.
"""

from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SELF = Path(__file__).resolve()

LEGACY_PATTERNS = (
    "一道没有跨过的门槛",
    "没有跨过门槛",
    "没有跨过去",
    "不该跨过去",
    "门槛",
    "越界",
    "跨过去",
    "地图空白",
    "空白地图",
    "规定路线",
    "旧木尺",
    "写下“界”",
    "补回故事中消失的一句",
    "因此${record.correct}",
    "而且${record.correct}",
    "only prescribed route",
    "blank map",
    "threshold boundary",
)

# These are the production files that can provide Forbidden City-specific
# semantics on the canonical route:
# JourneyScreen dispatcher -> ForbiddenCityReferenceJourneyScreen -> runtime /
# challenge package / challenge panel -> level-bound Memory and Completion.
ACTIVE_PRODUCTION_PATHS = (
    "app/lib/data/forbidden_city_journey_runtime.dart",
    "app/lib/data/forbidden_city_journey_runtime_base.dart",
    "app/lib/data/forbidden_city_challenge_package.dart",
    "app/lib/screens/journey_screen.dart",
    "app/lib/screens/forbidden_city_reference_journey_screen.dart",
    "app/lib/widgets/journey_challenge_panel.dart",
    "app/lib/widgets/forbidden_city_reference_challenge_panel.dart",
    "app/lib/data/world_geo_catalog.dart",
    "app/lib/data/world_geo_catalog_base.dart",
    "app/lib/models/geo_node.dart",
    "content/CN/BJ/CN-BJ-001/journey.json",
)

REFERENCE_MARKERS = (
    "forbiddenCity",
    "ForbiddenCity",
    "forbidden-city",
    "Forbidden City",
    "beijing-forbidden-city",
    "cn-beijing-dongcheng-forbidden-city",
)

TEXT_SUFFIXES = {".dart", ".json", ".md", ".py", ".yml", ".yaml", ".mjs"}


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        return ""


def count_matches(text: str) -> int:
    lowered = text.lower()
    return sum(lowered.count(pattern.lower()) for pattern in LEGACY_PATTERNS)


def active_production_files() -> list[Path]:
    selected: list[Path] = []
    missing: list[str] = []
    for relative in ACTIVE_PRODUCTION_PATHS:
        path = ROOT / relative
        if path.is_file():
            selected.append(path)
        else:
            missing.append(relative)
    if missing:
        print("ERROR: canonical production files missing:", file=sys.stderr)
        for relative in missing:
            print(f"  {relative}", file=sys.stderr)
        raise SystemExit(2)
    return sorted(set(selected))


def archive_test_doc_files() -> list[Path]:
    selected: list[Path] = []
    roots = (
        ROOT / "app" / "test",
        ROOT / "docs",
        ROOT / "tools",
    )
    for base in roots:
        if not base.exists():
            continue
        for path in base.rglob("*"):
            if not path.is_file() or path.resolve() == SELF:
                continue
            if path.suffix.lower() in TEXT_SUFFIXES:
                selected.append(path)

    sources = ROOT / "content" / "CN" / "BJ" / "CN-BJ-001" / "sources.md"
    if sources.is_file():
        selected.append(sources)
    return sorted(set(selected))


def nonactive_reference_files(active: set[Path]) -> list[Path]:
    """Report, but do not fail on, global/legacy catalogs outside the route."""
    selected: list[Path] = []
    lib = ROOT / "app" / "lib"
    if not lib.exists():
        return selected
    for path in lib.rglob("*.dart"):
        if path in active:
            continue
        text = read_text(path)
        if any(marker in text for marker in REFERENCE_MARKERS):
            selected.append(path)
    return sorted(set(selected))


def main() -> int:
    production = active_production_files()
    production_set = set(production)
    archive = archive_test_doc_files()
    nonactive = nonactive_reference_files(production_set)
    scanned = sorted(set(production + archive + nonactive))

    production_hits: list[tuple[Path, int]] = []
    production_matches = 0
    for path in production:
        hits = count_matches(read_text(path))
        production_matches += hits
        if hits:
            production_hits.append((path, hits))

    archive_matches = sum(count_matches(read_text(path)) for path in archive)
    nonactive_matches = sum(count_matches(read_text(path)) for path in nonactive)

    print("Semantic Scan:")
    print(f"files scanned: {len(scanned)}")
    print(f"active production files: {len(production)}")
    print(f"production matches: {production_matches}")
    print(f"archive/test/docs matches: {archive_matches}")
    print(f"nonactive app/lib matches: {nonactive_matches}")

    if production_hits:
        print("production legacy hits:")
        for path, hits in production_hits:
            print(f"  {path.relative_to(ROOT)}: {hits}")

    if not scanned or not production:
        print("ERROR: semantic scan selected zero required files", file=sys.stderr)
        return 2
    if production_matches != 0:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
