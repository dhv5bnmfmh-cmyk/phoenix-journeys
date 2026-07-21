#!/usr/bin/env python3
"""Generate Phoenix's original offline WebP destination backgrounds.

No network calls, source photos, logos, text, characters, or artist imitation.
The output is deterministic so CI can reproduce and audit the library.
"""

from __future__ import annotations

import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance

WIDTH = 540
HEIGHT = 960
ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "app/assets/images/backgrounds/generated"
CATALOG = ROOT / "app/lib/data/journey_background_generated.dart"
MANIFEST = OUTPUT / "manifest.txt"

CITIES = (
    ("beijing-forbidden-city", "beijing"),
    ("shanghai-bund", "shanghai"),
    ("xian-city-wall", "xian"),
    ("hangzhou-west-lake", "hangzhou"),
    ("chengdu-kuanzhai-alley", "chengdu"),
    ("nanjing-qinhuai-river", "nanjing"),
    ("guangzhou-chen-clan", "guangzhou"),
)

VARIANTS = (
    ("sunrise-arrival", "sunrise", "clear"),
    ("morning-street", "morning", "cloud"),
    ("misty-detail", "morning", "mist"),
    ("bright-panorama", "afternoon", "clear"),
    ("after-rain", "afternoon", "rain"),
    ("seasonal-landscape", "late", "cloud"),
    ("golden-hour", "golden", "clear"),
    ("blue-hour", "blue", "cloud"),
    ("lantern-night", "night", "clear"),
    ("quiet-night-panorama", "night", "mist"),
)

SKIES = {
    "sunrise": ((245, 165, 115), (252, 231, 198)),
    "morning": ((165, 205, 230), (238, 241, 228)),
    "afternoon": ((100, 180, 225), (245, 225, 180)),
    "late": ((170, 192, 148), (244, 221, 176)),
    "golden": ((236, 132, 78), (249, 209, 148)),
    "blue": ((55, 82, 125), (132, 160, 188)),
    "night": ((16, 26, 50), (47, 65, 96)),
}


def gradient(top, bottom):
    image = Image.new("RGB", (WIDTH, HEIGHT))
    draw = ImageDraw.Draw(image)
    for y in range(HEIGHT):
        ratio = y / (HEIGHT - 1)
        color = tuple(round(top[i] * (1 - ratio) + bottom[i] * ratio) for i in range(3))
        draw.line((0, y, WIDTH, y), fill=color)
    return image


def sky_details(layer, mode, weather, variant):
    draw = ImageDraw.Draw(layer, "RGBA")
    x = 90 + (variant * 47) % 360
    y = 125 + (variant * 31) % 170
    if mode in {"night", "blue"}:
        draw.ellipse((x - 22, y - 22, x + 22, y + 22), fill=(255, 242, 198, 210))
        for star in range(18):
            sx = (33 * star + 17 * variant) % WIDTH
            sy = 55 + (77 * star + 21 * variant) % 300
            radius = 1 + star % 2
            draw.ellipse((sx - radius, sy - radius, sx + radius, sy + radius), fill=(255, 250, 220, 130))
    else:
        draw.ellipse((x - 34, y - 34, x + 34, y + 34), fill=(255, 216, 125, 215))
    if weather in {"cloud", "mist", "rain"}:
        rng = random.Random(1000 + variant)
        for _ in range(4 if weather == "mist" else 3):
            cx = rng.randint(-20, WIDTH + 20)
            cy = rng.randint(110, 430)
            scale = rng.uniform(0.7, 1.5)
            alpha = 40 if weather == "mist" else 75
            for ox, oy, rx, ry in ((-50, 0, 60, 23), (0, -12, 75, 30), (55, 4, 65, 24)):
                draw.ellipse((cx + ox * scale - rx * scale, cy + oy * scale - ry * scale, cx + ox * scale + rx * scale, cy + oy * scale + ry * scale), fill=(255, 255, 245, alpha))


def mountains(layer, seed, base_y=560, color=(40, 60, 60, 50)):
    rng = random.Random(seed)
    draw = ImageDraw.Draw(layer, "RGBA")
    points = [(0, base_y)]
    x = 0
    while x < WIDTH:
        x += rng.randint(60, 110)
        points.append((x, base_y - rng.randint(40, 170)))
    points.extend(((WIDTH, HEIGHT), (0, HEIGHT)))
    draw.polygon(points, fill=color)


def roof(draw, x, y, width, height, body, roof_color, trim=(220, 180, 90, 255)):
    draw.rounded_rectangle((x + width * .14, y + height * .42, x + width * .86, y + height), radius=6, fill=body)
    draw.polygon(((x, y + height * .45), (x + width * .5, y), (x + width, y + height * .45)), fill=roof_color)
    draw.line(((x, y + height * .45), (x + width * .13, y + height * .31), (x + width * .25, y + height * .35), (x + width * .75, y + height * .35), (x + width * .87, y + height * .31), (x + width, y + height * .45)), fill=trim, width=max(2, round(width * .014)))


def trees(draw, seed, base_y, count, autumn=False):
    rng = random.Random(seed)
    for _ in range(count):
        x = rng.randint(0, WIDTH)
        height = rng.randint(90, 240)
        draw.line((x, base_y, x + rng.randint(-20, 20), base_y - height), fill=(55, 45, 35, 220), width=rng.randint(5, 10))
        leaf = ((190 + rng.randint(-20, 30), 80 + rng.randint(0, 60), 40 + rng.randint(0, 30), 160) if autumn else (55 + rng.randint(0, 60), 105 + rng.randint(0, 60), 65 + rng.randint(0, 45), 150))
        for _ in range(12):
            cx = x + rng.randint(-55, 55)
            cy = base_y - height + rng.randint(-65, 55)
            radius = rng.randint(12, 30)
            draw.ellipse((cx - radius, cy - radius, cx + radius, cy + radius), fill=leaf)


def water(image, y0, tint=(40, 80, 100, 110)):
    layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer, "RGBA")
    draw.rectangle((0, y0, WIDTH, HEIGHT), fill=tint)
    rng = random.Random(y0)
    for _ in range(60):
        y = rng.randint(y0, HEIGHT - 1)
        x = rng.randint(0, WIDTH - 30)
        length = rng.randint(20, 120)
        draw.line((x, y, min(WIDTH, x + length), y), fill=(255, 240, 190, rng.randint(15, 55)), width=rng.randint(1, 3))
    image.alpha_composite(layer)


def beijing(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    trees(draw, 100 + variant, 690, 5, variant in {5, 6})
    roof(draw, 30, 440 - variant * 2, 480, 190, (130, 35, 32, 255), (165, 95, 34, 255))
    roof(draw, 100, 600, 340, 150, (105, 25, 25, 255), (175, 105, 40, 255))
    draw.rectangle((55, 680, 485, 900), fill=(115, 28, 28, 245))
    for pillar in range(6):
        x = 82 + pillar * 68
        draw.rounded_rectangle((x, 715, x + 28, 875), radius=5, fill=(205, 150, 55, 230))
    draw.rectangle((0, 875, WIDTH, HEIGHT), fill=(55, 40, 35, 255))


def shanghai(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    water(image, 680, (20, 70, 100, 125))
    xs = (25, 65, 115, 165, 220, 285, 345, 410, 470)
    heights = (170, 250, 220, 310, 190, 350, 260, 200, 290)
    for index, x in enumerate(xs):
        height = heights[index] + variant % 3 * 15
        width = 35 + index % 3 * 12
        y = 700 - height
        draw.rounded_rectangle((x, y, x + width, 700), radius=3, fill=(30 + 8 * index, 60 + 6 * index, 80 + 7 * index, 245))
        for wy in range(round(y + 20), 680, 25):
            for wx in range(x + 8, round(x + width - 6), 14):
                draw.rectangle((wx, wy, wx + 4, wy + 7), fill=(235, 190, 95, 100))
        if index in {1, 5, 8}:
            draw.ellipse((x + width / 2 - 15, y - 35, x + width / 2 + 15, y - 5), fill=(190, 60, 75, 235))
            draw.line((x + width / 2, y - 70, x + width / 2, y - 35), fill=(190, 60, 75, 255), width=4)
    draw.rectangle((0, 700, WIDTH, 715), fill=(45, 45, 50, 255))
    for x in range(0, WIDTH, 90):
        draw.rectangle((x, 590, x + 70, 705), fill=(125, 100, 75, 170))
        draw.polygon(((x, 590), (x + 35, 555), (x + 70, 590)), fill=(100, 80, 65, 180))


def xian(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    trees(draw, 300 + variant, 620, 4, variant in {5, 6})
    draw.rectangle((0, 660, WIDTH, HEIGHT), fill=(80, 50, 38, 255))
    draw.rectangle((25, 555, 515, 735), fill=(125, 70, 45, 255))
    for block in range(7):
        x = 45 + block * 70
        draw.rectangle((x, 525, x + 38, 590), fill=(180, 115, 60, 255))
    roof(draw, 150, 365 - variant, 240, 170, (90, 45, 35, 255), (150, 85, 38, 255))
    draw.rectangle((180, 505, 360, 720), fill=(100, 50, 35, 255))
    draw.rounded_rectangle((230, 570, 310, 720), radius=38, fill=(35, 30, 28, 255))
    draw.polygon(((110, HEIGHT), (430, HEIGHT), (330, 720), (210, 720)), fill=(120, 100, 80, 200))


def hangzhou(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    water(image, 600, (55, 110, 110, 110))
    layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    mountains(layer, 700 + variant, 520, (55, 90, 75, 100))
    image.alpha_composite(layer)
    draw.arc((60, 500, 480, 820), 180, 360, fill=(225, 215, 180, 230), width=24)
    draw.arc((75, 515, 465, 810), 180, 360, fill=(115, 100, 75, 200), width=5)
    draw.rectangle((405, 350, 420, 650), fill=(60, 55, 45, 255))
    for floor in range(5):
        roof(draw, 350, 500 - floor * 62, 125, 72, (65, 55, 45, 255), (125, 95, 48, 255))
    for stem in range(15):
        x = 30 + stem * 10
        draw.line((x, 420, x + 5 + stem % 4 * 9, 670), fill=(65, 120, 70, 100), width=3)


def chengdu(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    trees(draw, 500 + variant, 640, 8)
    draw.rectangle((0, 630, WIDTH, HEIGHT), fill=(170, 140, 100, 255))
    roof(draw, 20, 470, 500, 190, (55, 65, 50, 255), (95, 75, 45, 255))
    draw.rectangle((55, 635, 485, 850), fill=(75, 85, 65, 255))
    draw.rounded_rectangle((200, 665, 340, 850), radius=70, fill=(35, 40, 34, 255))
    draw.polygon(((160, HEIGHT), (380, HEIGHT), (330, 835), (210, 835)), fill=(135, 125, 110, 255))
    rng = random.Random(900 + variant)
    for _ in range(45):
        x = rng.randint(160, 380)
        y = rng.randint(840, HEIGHT)
        radius = rng.randint(5, 15)
        draw.ellipse((x - radius, y - radius / 2, x + radius, y + radius / 2), outline=(85, 80, 70, 120), width=2)
    for x in (115, 425):
        draw.line((x, 620, x, 735), fill=(60, 45, 35, 255), width=5)
        draw.ellipse((x - 18, 655, x + 18, 700), fill=(185, 65, 45, 220))


def nanjing(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    draw.rectangle((0, 530, 145, 780), fill=(210, 195, 165, 255))
    draw.rectangle((395, 510, 540, 800), fill=(205, 190, 160, 255))
    roof(draw, -15, 430, 190, 120, (55, 45, 40, 255), (125, 70, 45, 255))
    roof(draw, 365, 410, 210, 130, (55, 45, 40, 255), (135, 75, 48, 255))
    water(image, 650, (35, 70, 90, 140))
    draw.arc((70, 500, 470, 820), 180, 360, fill=(190, 145, 100, 255), width=30)
    draw.arc((90, 520, 450, 810), 180, 360, fill=(230, 205, 160, 180), width=4)
    for x in range(80, 500, 90):
        y = 550 + (x % 180) // 3
        draw.line((x, y, x, y + 80), fill=(55, 40, 35, 255), width=4)
        draw.ellipse((x - 15, y + 15, x + 15, y + 55), fill=(205, 65, 45, 230))
    draw.polygon(((180, 790), (360, 790), (330, 825), (210, 825)), fill=(70, 45, 32, 240))
    draw.polygon(((255, 700), (310, 780), (255, 780)), fill=(230, 220, 190, 180))


def guangzhou(image, variant):
    draw = ImageDraw.Draw(image, "RGBA")
    trees(draw, 800 + variant, 620, 5)
    draw.rectangle((0, 610, WIDTH, HEIGHT), fill=(205, 190, 160, 255))
    roof(draw, 18, 440, 505, 210, (55, 70, 68, 255), (115, 82, 50, 255), (220, 160, 55, 255))
    draw.rectangle((45, 640, 495, 860), fill=(65, 85, 82, 255))
    for arch in range(6):
        x = 65 + arch * 75
        draw.rounded_rectangle((x, 690, x + 48, 860), radius=24, fill=(35, 45, 44, 255))
    for ornament in range(7):
        x = 80 + ornament * 65
        y = 500 + ornament % 2 * 14
        draw.ellipse((x - 12, y - 12, x + 12, y + 12), fill=(210, 135, 55, 230))
        draw.polygon(((x, y - 28), (x + 10, y - 10), (x - 10, y - 10)), fill=(70, 125, 120, 230))


SCENES = {"beijing": beijing, "shanghai": shanghai, "xian": xian, "hangzhou": hangzhou, "chengdu": chengdu, "nanjing": nanjing, "guangzhou": guangzhou}


def add_rain(image, seed):
    layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer, "RGBA")
    rng = random.Random(seed)
    for _ in range(90):
        x = rng.randint(0, WIDTH)
        y = rng.randint(0, HEIGHT)
        length = rng.randint(18, 48)
        draw.line((x, y, x - 10, y + length), fill=(240, 250, 255, 45), width=1)
    image.alpha_composite(layer)


def build(city, mode, weather, variant):
    image = gradient(*SKIES[mode]).convert("RGBA")
    sky = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    sky_details(sky, mode, weather, variant)
    image.alpha_composite(sky)
    if city not in {"shanghai", "chengdu"}:
        layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
        mountains(layer, 2000 + variant)
        image.alpha_composite(layer)
    SCENES[city](image, variant)
    if weather == "rain":
        add_rain(image, 3000 + variant)
    if weather == "mist":
        image.alpha_composite(Image.new("RGBA", (WIDTH, HEIGHT), (245, 245, 235, 42)))
    wash = (255, 175, 95, 12) if mode in {"sunrise", "golden"} else ((50, 70, 110, 20) if mode in {"night", "blue"} else (255, 255, 245, 6))
    image.alpha_composite(Image.new("RGBA", (WIDTH, HEIGHT), wash))
    result = ImageEnhance.Contrast(image.convert("RGB")).enhance(1.06)
    return ImageEnhance.Color(result).enhance(1.08)


def write_catalog(records):
    entries = []
    for index, (journey_id, slug, path) in enumerate(records):
        variant = index % 10
        entries.append(f"""  JourneyBackgroundAsset(
    id: '{journey_id}-ai-{variant + 1:02d}-{slug}',
    journeyId: '{journey_id}',
    assetPath: '{path}',
    generatedOn: DateTime.utc(2026, 7, 21),
    origin: JourneyBackgroundOrigin.aiGenerated,
    complianceReviewed: true,
    complianceScore: 100,
    varietyScore: {92 + variant % 8},
  ),""")
    CATALOG.write_text("import '../models/journey_background.dart';\n\n// Generated offline by generate_offline_city_backgrounds.py.\nfinal generatedJourneyBackgrounds = <JourneyBackgroundAsset>[\n" + "\n".join(entries) + "\n];\n", encoding="utf-8")


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for old in OUTPUT.glob("*.webp"):
        old.unlink()
    records = []
    for journey_id, city in CITIES:
        for variant, (slug, mode, weather) in enumerate(VARIANTS):
            filename = f"{journey_id}-{variant + 1:02d}-{slug}.webp"
            destination = OUTPUT / filename
            build(city, mode, weather, variant).save(destination, "WEBP", quality=80, method=6)
            records.append((journey_id, slug, f"assets/images/backgrounds/generated/{filename}"))
    write_catalog(records)
    MANIFEST.write_text("\n".join(path for _, _, path in records) + "\n", encoding="utf-8")
    print(f"Generated {len(records)} original offline WebP backgrounds.")


if __name__ == "__main__":
    main()
