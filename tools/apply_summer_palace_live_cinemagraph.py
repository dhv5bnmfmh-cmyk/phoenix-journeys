from __future__ import annotations

import math
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "app/assets/images/backgrounds/generated/beijing/summer-palace/06-summer-lotus-lake.webp"
OUTPUT = ROOT / "app/assets/images/backgrounds/generated/beijing/summer-palace/live/11-live-cinemagraph.webp"
CATALOG = ROOT / "app/lib/data/journey_background_catalog.dart"
PUBSPEC = ROOT / "app/pubspec.yaml"
WIDGET = ROOT / "app/lib/widgets/destination_background.dart"
WIDGET_TEST = ROOT / "app/test/summer_palace_dynamic_background_test.dart"
RULE = ROOT / "worker/summer_palace_dynamic_background_rule.test.mjs"
DOCS = ROOT / "docs/development-workflow.md"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected one match, found {count}")
    return text.replace(old, new, 1)


def cover_resize(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    target_w, target_h = size
    scale = max(target_w / image.width, target_h / image.height)
    resized = image.resize(
        (round(image.width * scale), round(image.height * scale)),
        Image.Resampling.LANCZOS,
    )
    left = (resized.width - target_w) // 2
    top = (resized.height - target_h) // 2
    return resized.crop((left, top, left + target_w, top + target_h))


def water_displacement(frame: Image.Image, phase: float) -> Image.Image:
    array = np.asarray(frame).copy()
    height, _ = array.shape[:2]
    water_top = int(height * 0.48)
    source = array[water_top:].copy()
    displaced = source.copy()

    for row in range(source.shape[0]):
        depth = row / max(1, source.shape[0] - 1)
        offset = round(
            math.sin(phase * math.tau + row * 0.075) * (1.2 + depth * 3.4)
            + math.sin(phase * math.tau * 0.55 + row * 0.031) * 1.5
        )
        displaced[row] = np.roll(source[row], offset, axis=0)

    blend = np.linspace(0.0, 0.92, source.shape[0], dtype=np.float32)[:, None, None]
    mixed = source * (1 - blend) + displaced * blend
    array[water_top:] = np.clip(mixed, 0, 255).astype(np.uint8)
    return Image.fromarray(array, "RGB")


def add_live_details(frame: Image.Image, phase: float) -> Image.Image:
    width, height = frame.size
    overlay = Image.new("RGBA", frame.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay, "RGBA")

    water_top = int(height * 0.50)
    for line in range(12):
        y = water_top + line * int(height * 0.032)
        drift = math.sin(phase * math.tau + line * 0.7)
        x = int(width * (0.18 + 0.055 * line) + drift * width * 0.045)
        length = int(width * (0.12 + (line % 4) * 0.035))
        alpha = 18 + (line % 3) * 7
        draw.rounded_rectangle(
            (x, y, x + length, y + 2),
            radius=2,
            fill=(255, 229, 174, alpha),
        )

    boat_x = int(width * 0.70 + math.sin(phase * math.tau) * width * 0.035)
    boat_y = int(height * 0.585 + math.sin(phase * math.tau * 2) * 1.5)
    draw.polygon(
        [
            (boat_x - 18, boat_y + 7),
            (boat_x + 19, boat_y + 7),
            (boat_x + 13, boat_y + 13),
            (boat_x - 12, boat_y + 13),
        ],
        fill=(54, 35, 24, 170),
    )
    draw.line(
        (boat_x - 13, boat_y + 1, boat_x + 13, boat_y + 1),
        fill=(76, 43, 28, 185),
        width=2,
    )
    draw.line(
        (boat_x - 10, boat_y + 1, boat_x - 7, boat_y + 8),
        fill=(58, 35, 24, 175),
        width=1,
    )
    draw.line(
        (boat_x + 10, boat_y + 1, boat_x + 7, boat_y + 8),
        fill=(58, 35, 24, 175),
        width=1,
    )
    draw.rectangle(
        (boat_x - 9, boat_y - 5, boat_x + 9, boat_y + 1),
        fill=(67, 39, 25, 170),
    )

    walkway_y = int(height * 0.505)
    for index, base in enumerate((0.34, 0.39, 0.44)):
        person_x = int(
            width * base + ((phase + index * 0.17) % 1.0) * width * 0.018
        )
        bob = math.sin(phase * math.tau * 2 + index) * 0.8
        head_y = int(walkway_y - 7 + bob)
        draw.ellipse(
            (person_x - 1, head_y - 2, person_x + 2, head_y + 1),
            fill=(235, 218, 185, 170),
        )
        draw.line(
            (person_x, head_y + 1, person_x, head_y + 7),
            fill=(72, 56, 45, 165),
            width=2,
        )

    glow_x = int(width * (0.45 + math.sin(phase * math.tau) * 0.12))
    glow = Image.new("L", frame.size, 0)
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.ellipse((glow_x - 170, -90, glow_x + 170, 260), fill=36)
    glow = glow.filter(ImageFilter.GaussianBlur(58))
    warm = Image.new("RGBA", frame.size, (255, 224, 177, 0))
    warm.putalpha(glow)
    overlay = Image.alpha_composite(overlay, warm)

    composite = Image.alpha_composite(frame.convert("RGBA"), overlay)
    return composite.convert("RGB")


def generate_live_loop() -> None:
    if not SOURCE.exists():
        raise SystemExit(f"Missing Summer Palace source asset: {SOURCE}")

    base = cover_resize(Image.open(SOURCE).convert("RGB"), (540, 960))
    base = ImageEnhance.Contrast(base).enhance(1.02)
    frames: list[Image.Image] = []
    frame_count = 36

    for index in range(frame_count):
        phase = index / frame_count
        breathe = 1.015 + 0.008 * math.sin(phase * math.tau)
        scaled = base.resize(
            (round(base.width * breathe), round(base.height * breathe)),
            Image.Resampling.LANCZOS,
        )
        x = (scaled.width - base.width) // 2 + round(
            math.sin(phase * math.tau) * 3
        )
        y = (scaled.height - base.height) // 2 + round(
            math.cos(phase * math.tau) * 2
        )
        camera = scaled.crop((x, y, x + base.width, y + base.height))
        displaced = water_displacement(camera, phase)
        frames.append(add_live_details(displaced, phase))

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    frames[0].save(
        OUTPUT,
        save_all=True,
        append_images=frames[1:],
        duration=[150] * frame_count,
        loop=0,
        quality=38,
        method=6,
    )
    if OUTPUT.stat().st_size > 1_100_000:
        raise SystemExit(f"Live loop is too large: {OUTPUT.stat().st_size} bytes")


def update_background_catalog() -> None:
    text = CATALOG.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "import 'journey_background_generated.dart';\n\n",
        "import 'journey_background_generated.dart';\n\n"
        "const summerPalaceLiveLoopAssetPath =\n"
        "    'assets/images/backgrounds/generated/beijing/summer-palace/live/11-live-cinemagraph.webp';\n\n",
        "live loop catalog path",
    )
    CATALOG.write_text(text, encoding="utf-8")


def update_pubspec() -> None:
    text = PUBSPEC.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "    - assets/images/backgrounds/generated/beijing/summer-palace/\n",
        "    - assets/images/backgrounds/generated/beijing/summer-palace/\n"
        "    - assets/images/backgrounds/generated/beijing/summer-palace/live/\n",
        "live loop asset directory",
    )
    PUBSPEC.write_text(text, encoding="utf-8")


def update_flutter_widget() -> None:
    text = WIDGET.read_text(encoding="utf-8")
    text = replace_once(
        text,
        "    precacheImage(AssetImage(path), context);\n",
        "    precacheImage(AssetImage(path), context);\n"
        "    precacheImage(\n"
        "      const AssetImage(summerPalaceLiveLoopAssetPath),\n"
        "      context,\n"
        "    );\n",
        "live loop precache",
    )
    text = replace_once(
        text,
        "    final reduceMotion = _summerPalaceReduceMotion(context);\n    return RepaintBoundary(\n",
        "    final reduceMotion = _summerPalaceReduceMotion(context);\n"
        "    final useLiveLoop = !reduceMotion;\n"
        "    return RepaintBoundary(\n",
        "live loop preference",
    )
    text = replace_once(
        text,
        "                      _SummerPalaceCameraLayer(\n"
        "                        assetPath: widget.assetPath,\n"
        "                        progress: progress,\n"
        "                      ),\n",
        "                      _SummerPalaceCameraLayer(\n"
        "                        assetPath: widget.assetPath,\n"
        "                        progress: progress,\n"
        "                        useLiveLoop: useLiveLoop,\n"
        "                      ),\n",
        "camera live loop argument",
    )
    text = replace_once(
        text,
        "    required this.progress,\n  });\n\n  final String? assetPath;\n  final double progress;\n",
        "    required this.progress,\n"
        "    required this.useLiveLoop,\n"
        "  });\n\n"
        "  final String? assetPath;\n"
        "  final double progress;\n"
        "  final bool useLiveLoop;\n",
        "camera live loop field",
    )
    text = replace_once(
        text,
        "    final path = assetPath;\n    if (path == null) return const _BackgroundFallback();\n",
        "    final path = useLiveLoop ? summerPalaceLiveLoopAssetPath : assetPath;\n"
        "    if (path == null) return const _BackgroundFallback();\n",
        "camera live asset selection",
    )
    text = replace_once(
        text,
        "          child: Image.asset(\n            path,\n            fit: BoxFit.cover,\n",
        "          child: Image.asset(\n"
        "            path,\n"
        "            key: ValueKey(\n"
        "              useLiveLoop\n"
        "                  ? 'summer-palace-live-loop'\n"
        "                  : 'summer-palace-static-background',\n"
        "            ),\n"
        "            fit: BoxFit.cover,\n",
        "live loop image key",
    )
    WIDGET.write_text(text, encoding="utf-8")


def update_tests_and_rules() -> None:
    test = WIDGET_TEST.read_text(encoding="utf-8")
    test = replace_once(
        test,
        "    expect(\n      find.byKey(const ValueKey('summer-palace-camera-layer')),\n      findsOneWidget,\n    );\n",
        "    expect(\n"
        "      find.byKey(const ValueKey('summer-palace-camera-layer')),\n"
        "      findsOneWidget,\n"
        "    );\n"
        "    expect(\n"
        "      find.byKey(const ValueKey('summer-palace-static-background')),\n"
        "      findsOneWidget,\n"
        "    );\n"
        "    expect(\n"
        "      find.byKey(const ValueKey('summer-palace-live-loop')),\n"
        "      findsNothing,\n"
        "    );\n",
        "reduced motion live loop assertions",
    )
    test = replace_once(
        test,
        "    await tester.pump();\n\n    final initialTransform = tester\n",
        "    await tester.pump();\n\n"
        "    expect(\n"
        "      find.byKey(const ValueKey('summer-palace-live-loop')),\n"
        "      findsOneWidget,\n"
        "    );\n\n"
        "    final initialTransform = tester\n",
        "live loop enabled assertion",
    )
    WIDGET_TEST.write_text(test, encoding="utf-8")

    rule = RULE.read_text(encoding="utf-8")
    rule = replace_once(
        rule,
        "const widget = readFileSync(\n"
        "  'app/lib/widgets/destination_background.dart',\n"
        "  'utf8',\n"
        ");\n",
        "const widget = readFileSync(\n"
        "  'app/lib/widgets/destination_background.dart',\n"
        "  'utf8',\n"
        ");\n"
        "const catalog = readFileSync(\n"
        "  'app/lib/data/journey_background_catalog.dart',\n"
        "  'utf8',\n"
        ");\n",
        "live loop rule catalog source",
    )
    rule = replace_once(
        rule,
        "  assert.match(widget, /summer-palace-dynamic-background/);\n",
        "  assert.match(widget, /summer-palace-dynamic-background/);\n"
        "  assert.match(widget, /summerPalaceLiveLoopAssetPath/);\n"
        "  assert.match(catalog, /summer-palace\\/live\\/11-live-cinemagraph\\.webp/);\n"
        "  assert.match(widget, /summer-palace-live-loop/);\n"
        "  assert.match(widget, /summer-palace-static-background/);\n",
        "live loop permanent rule",
    )
    RULE.write_text(rule, encoding="utf-8")

    docs = DOCS.read_text(encoding="utf-8")
    marker = "- 朗读跨越段落分隔符时，即使语音引擎短暂不给出高亮快照，也不得把全文显现进度清零或产生整页闪烁。\n"
    addition = (
        marker
        + "\n## 重点旅程电影级动态背景准则\n\n"
        + "- 重点旅程可使用本地离线 animated WebP 作为局部真动态背景，禁止依赖在线流媒体或运行时生成。\n"
        + "- 动态循环必须包含至少 24 帧并保持无缝衔接；水面、光影、远景人物或船只应低速运动，不得抢夺阅读注意力。\n"
        + "- 单个动态背景资源目标小于 1.1 MB，并保留静态背景作为系统“减少动态效果”回退。\n"
        + "- 动态背景层必须与故事、发现、编号和注释控件隔离重绘，不能引发布局跳动。\n"
    )
    docs = replace_once(docs, marker, addition, "live background documentation")
    DOCS.write_text(docs, encoding="utf-8")


def main() -> None:
    generate_live_loop()
    update_background_catalog()
    update_pubspec()
    update_flutter_widget()
    update_tests_and_rules()
    print(f"Generated {OUTPUT.relative_to(ROOT)} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
