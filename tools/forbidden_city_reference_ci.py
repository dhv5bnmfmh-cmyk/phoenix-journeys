#!/usr/bin/env python3
"""Forbidden City production legacy semantic gate.

This scanner is intentionally scoped to production files that participate in the
Forbidden City reference journey plus archive/test/docs evidence. Production
matches are fatal. Archive/test/docs matches are reported but allowed.
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
    "一张叠着两条路线的图",
    "双线节点",
    "补回故事中消失的一句",
    "因此${record.correct}",
    "而且${record.correct}",
    "only prescribed route",
    "blank map",
    "threshold boundary",
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


def production_files() -> list[Path]:
    selected: list[Path] = []
    lib = ROOT / "app" / "lib"
    for path in lib.rglob("*.dart"):
        text = read_text(path)
        if any(marker in text for marker in REFERENCE_MARKERS):
            selected.append(path)

    journey = ROOT / "content" / "CN" / "BJ" / "CN-BJ-001" / "journey.json"
    if journey.is_file():
        selected.append(journey)
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


def main() -> int:
    production = production_files()
    archive = archive_test_doc_files()
    scanned = sorted(set(production + archive))

    production_hits: list[tuple[Path, int]] = []
    production_matches = 0
    for path in production:
        hits = count_matches(read_text(path))
        production_matches += hits
        if hits:
            production_hits.append((path, hits))

    archive_matches = sum(count_matches(read_text(path)) for path in archive)

    print("Semantic Scan:")
    print(f"files scanned: {len(scanned)}")
    print(f"production matches: {production_matches}")
    print(f"archive/test/docs matches: {archive_matches}")

    if production_hits:
        print("production legacy hits:")
        for path, hits in production_hits:
            print(f"  {path.relative_to(ROOT)}: {hits}")

    if not scanned:
        print("ERROR: semantic scan selected zero files", file=sys.stderr)
        return 2
    if not production:
        print("ERROR: semantic scan selected zero production files", file=sys.stderr)
        return 2
    if production_matches != 0:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
